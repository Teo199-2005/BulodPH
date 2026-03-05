<?php

declare(strict_types=1);

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Models\CarRentalProfile;
use Illuminate\Http\JsonResponse;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Storage;
use Symfony\Component\HttpFoundation\StreamedResponse;

final class CarRentalProfileController extends Controller
{
    private function toResponse(CarRentalProfile $profile): array
    {
        $logoUrl = $profile->logo_url;
        if (!$logoUrl && $profile->relationLoaded('user') && $profile->user) {
            $logoUrl = $profile->user->avatar_url;
        }
        if ($logoUrl && str_starts_with((string) $logoUrl, '/')) {
            $logoUrl = url($logoUrl);
        }
        // When logo is already a data URL, return it so the frontend can use it directly (no extra request)
        if ($logoUrl && str_starts_with((string) $logoUrl, 'data:')) {
            // keep $logoUrl as-is
        } else {
            $apiLogoUrl = $this->logoStreamUrl($profile);
            if ($apiLogoUrl) {
                $logoUrl = $apiLogoUrl;
            }
        }
        return [
            'id' => $profile->id,
            'ownerId' => $profile->user_id,
            'businessName' => $profile->business_name ?? 'Rental',
            'logoUrl' => $logoUrl,
            'bio' => $profile->bio,
            'city' => $profile->city,
            'province' => $profile->province,
            'address' => $profile->address,
            'phone' => $profile->phone,
            'email' => $profile->email,
            'businessPermitNumber' => $profile->business_permit_number,
            'businessAddress' => $profile->business_address,
            'slug' => $profile->slug,
        ];
    }

    /** Build URL for logo stream endpoint (absolute so img src works from any frontend origin). */
    private function logoStreamUrl(CarRentalProfile $profile): ?string
    {
        $logoUrl = $profile->logo_url;
        if (!$logoUrl && $profile->relationLoaded('user') && $profile->user) {
            $logoUrl = $profile->user->avatar_url;
        }
        if (!$logoUrl) {
            return null;
        }
        $path = $this->logoStoragePath($logoUrl);
        $isDataUrl = str_starts_with((string) $logoUrl, 'data:');
        if (!$path && !$isDataUrl) {
            return null;
        }
        $request = request();
        $base = $request ? ($request->getSchemeAndHttpHost() . $request->getBasePath()) : url('');
        return rtrim($base, '/') . '/api/car-rentals/logo/' . $profile->id;
    }

    /** Get storage path from logo URL (e.g. rental-logos/user_id/file.jpg). */
    private function logoStoragePath(?string $logoUrl): ?string
    {
        if (!$logoUrl) {
            return null;
        }
        $path = parse_url($logoUrl, PHP_URL_PATH);
        if (!$path) {
            return null;
        }
        // Strip leading /storage/ to get disk path
        $prefix = '/storage/';
        if (str_starts_with($path, $prefix)) {
            return substr($path, strlen($prefix));
        }
        return $path;
    }

    /** GET /car-rentals/logo/{id} – stream rental logo image (public, so img src works). */
    public function streamLogo(string $id): StreamedResponse|JsonResponse
    {
        if (\strlen($id) > 64) {
            return response()->json(['message' => 'Not found'], 404);
        }
        $profile = CarRentalProfile::with('user')->where('id', $id)->orWhere('slug', $id)->first();
        if (!$profile) {
            return response()->json(['message' => 'Not found'], 404);
        }
        $logoUrl = $profile->logo_url ?? $profile->user?->avatar_url;

        // If DB has a data URL (old profile photo), stream it directly
        if ($logoUrl && str_starts_with((string) $logoUrl, 'data:')) {
            $data = $this->parseDataUrl($logoUrl);
            if ($data) {
                return response($data['body'], 200, [
                    'Content-Type' => $data['mime'],
                    'Cache-Control' => 'public, max-age=86400',
                ]);
            }
        }

        $path = $this->resolveLogoPath($profile);
        if (!$path) {
            return response()->json(['message' => 'Logo not found'], 404);
        }
        $mime = Storage::disk('public')->mimeType($path) ?: 'image/jpeg';
        return response()->stream(function () use ($path) {
            $stream = Storage::disk('public')->readStream($path);
            if ($stream) {
                fpassthru($stream);
                fclose($stream);
            }
        }, 200, [
            'Content-Type' => $mime,
            'Cache-Control' => 'public, max-age=86400',
        ]);
    }

    /** Parse data URL (e.g. data:image/jpeg;base64,...) into mime and binary body. */
    private function parseDataUrl(string $url): ?array
    {
        if (!preg_match('#^data:([^;]+);base64,(.+)$#s', $url, $m)) {
            return null;
        }
        $mime = trim($m[1]);
        $body = base64_decode($m[2], true);
        if ($body === false || $body === '') {
            return null;
        }
        return ['mime' => $mime, 'body' => $body];
    }

    /** Resolve a storage file path for the profile logo (handles truncated URLs by scanning dir). */
    private function resolveLogoPath(CarRentalProfile $profile): ?string
    {
        $logoUrl = $profile->logo_url ?? $profile->user?->avatar_url;
        $path = $this->logoStoragePath($logoUrl);
        if ($path && Storage::disk('public')->exists($path)) {
            $type = Storage::disk('public')->getMetadata($path)['type'] ?? null;
            if ($type === 'file') {
                return $path;
            }
        }
        $dirs = [];
        if ($profile->user_id) {
            $dirs[] = 'rental-logos/' . $profile->user_id;
            $dirs[] = 'avatars/' . $profile->user_id;
        }
        foreach ($dirs as $dir) {
            if (!Storage::disk('public')->exists($dir)) {
                continue;
            }
            $files = Storage::disk('public')->files($dir);
            foreach ($files as $file) {
                if ($file && !str_ends_with($file, '.gitignore')) {
                    return $file;
                }
            }
        }
        return null;
    }

    /** GET /car-owner/rental-profile – current user's profile (auth). */
    public function show(Request $request): JsonResponse
    {
        $profile = CarRentalProfile::with('user')->where('user_id', $request->user()->id)->first();
        return response()->json(['data' => $profile ? $this->toResponse($profile) : null]);
    }

    /** GET /car-rentals – list all rental profiles (public). */
    public function index(): JsonResponse
    {
        $profiles = CarRentalProfile::with('user')->orderBy('business_name')->limit(200)->get();
        return response()
            ->json([
                'data' => $profiles->map(fn (CarRentalProfile $p) => $this->toResponse($p))->values()->all(),
            ])
            ->header('Cache-Control', 'public, max-age=300, s-maxage=300'); // 5 min cache for public listings
    }

    /** GET /car-rentals/{id} – single rental by id or slug (public). */
    public function showPublic(string $id): JsonResponse
    {
        if (\strlen($id) > 64) {
            return response()->json(['data' => null])->header('Cache-Control', 'public, max-age=300, s-maxage=300');
        }
        $profile = CarRentalProfile::with('user')->where('id', $id)
            ->orWhere('slug', $id)
            ->first();
        return response()
            ->json(['data' => $profile ? $this->toResponse($profile) : null])
            ->header('Cache-Control', 'public, max-age=300, s-maxage=300'); // 5 min cache
    }

    public function update(Request $request): JsonResponse
    {
        $validated = $request->validate([
            'businessName' => 'sometimes|string|max:255',
            'logoUrl' => 'nullable|string|max:512000', // allow data URLs from profile photo (~500KB)
            'bio' => 'nullable|string|max:2000',
            'city' => 'nullable|string|max:100',
            'province' => 'nullable|string|max:100',
            'address' => 'nullable|string|max:500',
            'phone' => 'nullable|string|max:30',
            'email' => 'nullable|email|max:255',
            'businessPermitNumber' => 'nullable|string|max:100',
            'businessAddress' => 'nullable|string|max:500',
        ]);

        $user = $request->user();
        $profile = CarRentalProfile::where('user_id', $user->id)->first();

        $map = [
            'businessName' => 'business_name',
            'logoUrl' => 'logo_url',
            'businessPermitNumber' => 'business_permit_number',
            'businessAddress' => 'business_address',
        ];
        $data = [];
        foreach ($validated as $k => $v) {
            $data[$map[$k] ?? \Illuminate\Support\Str::snake($k)] = $v;
        }

        try {
            if ($profile) {
                $profile->update($data);
            } else {
                $profile = CarRentalProfile::create(array_merge($data, [
                    'user_id' => $user->id,
                    'business_name' => $data['business_name'] ?? $user->name ?? 'Rental',
                ]));
            }
        } catch (\Throwable $e) {
            if ($profile && isset($data['logo_url']) && \strlen((string) $data['logo_url']) > 1024) {
                unset($data['logo_url']);
                $profile->update($data);
            } else {
                throw $e;
            }
        }

        if (isset($data['business_name'])) {
            $profile->slug = CarRentalProfile::slugFrom($data['business_name']);
            $profile->save();
        }

        return response()->json(['data' => $this->toResponse($profile->fresh()->load('user'))]);
    }

    public function uploadLogo(Request $request): JsonResponse
    {
        $request->validate(['logo' => 'required|image|mimes:jpeg,png,jpg,gif,webp|max:5120']);

        $user = $request->user();
        $file = $request->file('logo');
        $path = $file->store('rental-logos/' . $user->id, 'public');
        $url = url(Storage::url($path));

        $profile = CarRentalProfile::where('user_id', $user->id)->first();
        if ($profile) {
            if ($profile->logo_url) {
                $oldPath = str_replace(url('/storage') . '/', '', $profile->logo_url);
                if ($oldPath && Storage::disk('public')->exists($oldPath)) {
                    Storage::disk('public')->delete($oldPath);
                }
            }
            $profile->update(['logo_url' => $url]);
        } else {
            CarRentalProfile::create([
                'user_id' => $user->id,
                'business_name' => $user->name ?? 'Rental',
                'logo_url' => $url,
                'slug' => CarRentalProfile::slugFrom($user->name ?? 'rental'),
            ]);
            $profile = CarRentalProfile::where('user_id', $user->id)->first();
        }

        return response()->json([
            'data' => ['logo_url' => $url],
            'logo_url' => $url,
        ]);
    }
}
