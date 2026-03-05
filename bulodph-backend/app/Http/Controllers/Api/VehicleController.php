<?php

declare(strict_types=1);

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Models\Vehicle;
use Illuminate\Http\JsonResponse;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Storage;
use Illuminate\Support\Str;

final class VehicleController extends Controller
{
    private const IMAGE_MAX_LENGTH = 1020;

    private function toResponse(Vehicle $v): array
    {
        return [
            'id' => $v->id,
            'userId' => $v->user_id,
            'name' => $v->name,
            'type' => $v->type ?? 'Car',
            'location' => $v->location,
            'pricePerDay' => (float) $v->price_per_day,
            'originalPricePerDay' => $v->original_price_per_day !== null ? (float) $v->original_price_per_day : null,
            'description' => $v->description,
            'image' => $v->image,
            'status' => $v->status ?? 'Available',
            'approved' => (bool) $v->approved,
            'hiddenFromListing' => (bool) ($v->hidden_from_listing ?? false),
            'featured' => (bool) $v->featured,
            'hostName' => $v->host_name,
            'businessName' => $v->business_name,
            'carType' => $v->car_type,
            'capacity' => $v->capacity,
            'rentalMode' => $v->rental_mode ?? 'both',
            'minRentalPeriodHours' => $v->min_rental_period_hours !== null ? (int) $v->min_rental_period_hours : null,
            'tags' => $v->tags,
            'imagesFourSides' => $v->images_four_sides,
            'listedAt' => $v->listed_at?->toIso8601String(),
            'createdAt' => $v->created_at?->toIso8601String(),
            'updatedAt' => $v->updated_at?->toIso8601String(),
        ];
    }

    private function requestToAttributes(Request $request): array
    {
        $data = $request->all();
        $user = $request->user();
        $isAdmin = $user && method_exists($user, 'hasRole') && $user->hasRole('admin');

        $image = $data['image'] ?? null;
        if (is_string($image) && (str_starts_with($image, 'data:') || strlen($image) > self::IMAGE_MAX_LENGTH)) {
            $image = $this->saveDataUrlToStorage($image);
        }
        if (is_string($image) && strlen($image) > self::IMAGE_MAX_LENGTH) {
            $image = null;
        }

        $imagesFourSides = $data['imagesFourSides'] ?? $data['images_four_sides'] ?? null;
        if (is_array($imagesFourSides)) {
            foreach (['front', 'rear', 'left', 'right'] as $side) {
                $val = $imagesFourSides[$side] ?? null;
                if (is_string($val) && (str_starts_with($val, 'data:') || strlen($val) > self::IMAGE_MAX_LENGTH)) {
                    $saved = $this->saveDataUrlToStorage($val);
                    $imagesFourSides[$side] = $saved ?: '';
                } elseif (is_string($val) && strlen($val) > self::IMAGE_MAX_LENGTH) {
                    $imagesFourSides[$side] = '';
                }
            }
        }

        $capacity = isset($data['capacity']) ? (int) $data['capacity'] : null;
        if ($capacity === 0) {
            $capacity = null;
        }

        $attrs = [
            'name' => $data['name'] ?? null,
            'type' => $data['type'] ?? 'Car',
            'location' => $data['location'] ?? null,
            'price_per_day' => (float) ($data['pricePerDay'] ?? $data['price_per_day'] ?? 0),
            'original_price_per_day' => isset($data['originalPricePerDay']) ? (float) $data['originalPricePerDay'] : ($data['original_price_per_day'] ?? null),
            'description' => $data['description'] ?? null,
            'image' => $image,
            'status' => $data['status'] ?? 'Available',
            'approved' => $isAdmin ? (bool) ($data['approved'] ?? false) : false,
            'hidden_from_listing' => $data['hiddenFromListing'] ?? $data['hidden_from_listing'] ?? false,
            'featured' => $isAdmin ? (bool) ($data['featured'] ?? false) : false,
            'host_name' => $data['hostName'] ?? $data['host_name'] ?? null,
            'business_name' => $data['businessName'] ?? $data['business_name'] ?? null,
            'car_type' => $data['carType'] ?? $data['car_type'] ?? null,
            'capacity' => $capacity,
            'rental_mode' => $this->normalizeRentalMode($data['rentalMode'] ?? $data['rental_mode'] ?? null),
            'min_rental_period_hours' => $this->normalizeMinRentalHours($data['minRentalPeriodHours'] ?? $data['min_rental_period_hours'] ?? null),
            'tags' => $data['tags'] ?? null,
            'images_four_sides' => $imagesFourSides,
        ];
        if ($request->user()) {
            $attrs['user_id'] = $request->user()->id;
        }
        return array_filter($attrs, fn ($v) => $v !== null);
    }

    /** Decode data URL, save to public disk, return path for DB (e.g. /storage/vehicle-images/xxx.jpg). */
    private function saveDataUrlToStorage(string $dataUrl): ?string
    {
        if (!preg_match('#^data:([^;]+);base64,(.+)$#s', $dataUrl, $m)) {
            return null;
        }
        $mime = trim($m[1]);
        $body = base64_decode($m[2], true);
        if ($body === false || $body === '') {
            return null;
        }
        $ext = 'jpg';
        if (str_contains($mime, 'png')) {
            $ext = 'png';
        } elseif (str_contains($mime, 'gif')) {
            $ext = 'gif';
        } elseif (str_contains($mime, 'webp')) {
            $ext = 'webp';
        }
        $path = 'vehicle-images/' . Str::uuid() . '.' . $ext;
        Storage::disk('public')->put($path, $body);
        return '/storage/' . $path;
    }

    private function normalizeRentalMode(mixed $value): ?string
    {
        $allowed = ['driver_only', 'self_drive_only', 'both'];
        $v = is_string($value) ? trim($value) : null;
        return $v !== '' && in_array($v, $allowed, true) ? $v : null;
    }

    private function normalizeMinRentalHours(mixed $value): ?int
    {
        if ($value === null || $value === '') {
            return null;
        }
        $h = (int) $value;
        return $h >= 1 && $h <= 8760 ? $h : null;
    }

    public function index(Request $request): JsonResponse
    {
        $query = Vehicle::query()->orderByDesc('listed_at')->orderByDesc('created_at');

        $user = $request->user();
        if ($user && method_exists($user, 'hasRole') && $user->hasRole('car_owner')) {
            $query->where('user_id', $user->id);
        }

        if ($request->has('approved')) {
            $query->where('approved', (bool) $request->boolean('approved'));
        }

        if ($request->boolean('visible_only')) {
            $query->where(function ($q) {
                $q->where('hidden_from_listing', false)->orWhereNull('hidden_from_listing');
            });
        }

        $perPage = min((int) $request->input('per_page', 20), 100);
        $paginated = $query->paginate($perPage);

        $rows = $paginated->getCollection()->map(fn (Vehicle $v) => $this->toResponse($v));

        return response()->json([
            'data' => $rows->values()->all(),
            'meta' => [
                'current_page' => $paginated->currentPage(),
                'last_page' => $paginated->lastPage(),
                'per_page' => $paginated->perPage(),
                'total' => $paginated->total(),
            ],
        ]);
    }

    public function show(Request $request, string $id): JsonResponse
    {
        if (\strlen($id) > 64) {
            return response()->json(['message' => 'Vehicle not found.'], 404);
        }
        $vehicle = Vehicle::find($id);

        if (! $vehicle) {
            return response()->json(['message' => 'Vehicle not found.'], 404);
        }

        $user = $request->user();
        if ($vehicle->hidden_from_listing && $user && ! $this->canModifyVehicle($user, $vehicle)) {
            return response()->json(['message' => 'Vehicle not found.'], 404);
        }

        return response()->json(['data' => $this->toResponse($vehicle)]);
    }

    public function store(Request $request): JsonResponse
    {
        try {
            $attrs = $this->requestToAttributes($request);
            $attrs['name'] = $attrs['name'] ?? 'Unnamed';
            $attrs['location'] = $attrs['location'] ?? '';

            $vehicle = Vehicle::create($attrs);

            return response()->json(['data' => $this->toResponse($vehicle)], 201);
        } catch (\Throwable $e) {
            report($e);
            $message = config('app.debug') ? $e->getMessage() : 'Could not save vehicle. Check your connection and try again.';
            return response()->json(['message' => $message], 500);
        }
    }

    public function update(Request $request, string $id): JsonResponse
    {
        if (\strlen($id) > 64) {
            return response()->json(['message' => 'Vehicle not found.'], 404);
        }
        $vehicle = Vehicle::find($id);

        if (! $vehicle) {
            return response()->json(['message' => 'Vehicle not found.'], 404);
        }

        $user = $request->user();
        if ($user && ! $this->canModifyVehicle($user, $vehicle)) {
            return response()->json(['message' => 'You can only edit your own vehicles.'], 403);
        }

        $attrs = $this->requestToAttributes($request);
        unset($attrs['user_id']); // do not change owner on update unless explicitly allowed

        $vehicle->update($attrs);

        return response()->json(['data' => $this->toResponse($vehicle->fresh())]);
    }

    public function destroy(Request $request, string $id): JsonResponse
    {
        if (\strlen($id) > 64) {
            return response()->json(['message' => 'Vehicle not found.'], 404);
        }
        $vehicle = Vehicle::find($id);

        if (! $vehicle) {
            return response()->json(['message' => 'Vehicle not found.'], 404);
        }

        $user = $request->user();
        if ($user && ! $this->canModifyVehicle($user, $vehicle)) {
            return response()->json(['message' => 'You can only remove your own vehicles.'], 403);
        }

        $vehicle->delete();

        return response()->json(['message' => 'Deleted']);
    }

    /** Allow if current user is admin or owns the vehicle. */
    private function canModifyVehicle($user, Vehicle $vehicle): bool
    {
        if (method_exists($user, 'hasRole') && $user->hasRole('admin')) {
            return true;
        }
        return $vehicle->user_id !== null && (string) $vehicle->user_id === (string) $user->id;
    }
}
