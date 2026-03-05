<?php

declare(strict_types=1);

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Models\ClientProfile;
use App\Models\RentalBooking;
use App\Models\User;
use App\Models\Vehicle;
use Illuminate\Http\JsonResponse;
use Illuminate\Http\Request;
use Illuminate\Support\Carbon;
use Illuminate\Support\Facades\Hash;
use Illuminate\Support\Facades\Storage;
use Illuminate\Validation\ValidationException;
use Spatie\Permission\PermissionRegistrar;

/**
 * Stub controller for car rental endpoints.
 * Returns empty/default data so the frontend does not 404.
 * Replace with full implementations when car rental backend is built.
 */
final class CarRentalStubController extends Controller
{
    public function dashboardKpis(Request $request): JsonResponse
    {
        $user = $request->user();
        $role = $request->input('role');
        $teamId = $user?->organization_id;

        $data = [
            'totalBookings' => 0,
            'totalRevenue' => 0,
            'pendingPayouts' => 0,
            'activeVehicles' => 0,
            'totalUsers' => 0,
            'totalCars' => 0,
            'carOwners' => 0,
            'earningsMonth' => null,
            'referralEarnings' => null,
            'linkClicks' => null,
        ];

        $userId = $user?->id;
        $carOwnerVehicleIds = $userId ? Vehicle::where('user_id', $userId)->pluck('id') : collect();

        if ($teamId !== null) {
            $orgUserIds = User::where('organization_id', $teamId)->pluck('id');
            $data['totalUsers'] = $orgUserIds->count();
            $data['carOwners'] = (int) User::where('organization_id', $teamId)
                ->whereHas('roles', fn ($q) => $q->where('name', 'car_owner'))
                ->count();
            $data['totalCars'] = (int) Vehicle::whereIn('user_id', $orgUserIds)->count();
            $data['totalBookings'] = (int) RentalBooking::whereHas('vehicle', fn ($q) => $q->whereIn('user_id', $orgUserIds))
                ->count();
            $data['activeVehicles'] = (int) Vehicle::whereIn('user_id', $orgUserIds)->where('approved', true)->count();
            $data['totalRevenue'] = (int) RentalBooking::whereHas('vehicle', fn ($q) => $q->whereIn('user_id', $orgUserIds))
                ->whereIn('status', ['confirmed', 'active', 'completed'])
                ->sum('amount');
            $data['pendingPayouts'] = (int) \App\Models\Payout::where('status', 'pending')->whereIn('user_id', $orgUserIds)->sum('amount');
        }

        // Role-specific earnings (car owner: from own vehicles; marketing: referral, not yet implemented)
        if ($role === 'car_owner' && $carOwnerVehicleIds->isNotEmpty()) {
            $data['totalRevenue'] = (int) RentalBooking::whereIn('vehicle_id', $carOwnerVehicleIds)
                ->whereIn('status', ['confirmed', 'active', 'completed'])
                ->sum('amount');
            $data['earningsMonth'] = (int) RentalBooking::whereIn('vehicle_id', $carOwnerVehicleIds)
                ->whereIn('status', ['confirmed', 'active', 'completed'])
                ->whereYear('start_date', now()->year)
                ->whereMonth('start_date', now()->month)
                ->sum('amount');
        }

        return response()->json(['data' => $data]);
    }

    public function weeklyBookings(Request $request): JsonResponse
    {
        $range = $request->input('range', 'week');
        $query = RentalBooking::query()->where('archived', false);
        if ($range === 'week') {
            $start = now()->startOfWeek(Carbon::MONDAY);
            $end = now()->endOfWeek();
            $query->whereBetween('start_date', [$start->toDateString(), $end->toDateString()]);
        } elseif ($range === 'month') {
            $query->whereMonth('start_date', (int) now()->format('n'))->whereYear('start_date', (int) now()->format('Y'));
        } else {
            $query->whereYear('start_date', (int) now()->format('Y'));
        }
        $bookings = $query->limit(5000)->get();
        $labels = [];
        $completed = [];
        $pending = [];
        $cancelled = [];

        if ($range === 'week') {
            $labels = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
            $completed = array_fill(0, 7, 0);
            $pending = array_fill(0, 7, 0);
            $cancelled = array_fill(0, 7, 0);
            $start = now()->startOfWeek(Carbon::MONDAY);
            foreach ($bookings as $b) {
                $d = $b->start_date ? Carbon::parse($b->start_date) : null;
                if (! $d || $d->lt($start) || $d->gt(now()->endOfWeek())) {
                    continue;
                }
                $i = $d->dayOfWeekIso - 1; // 0 = Mon
                if ($b->status === 'Completed') {
                    $completed[$i]++;
                } elseif (in_array($b->status, ['Pending', 'Approved', 'Active'], true)) {
                    $pending[$i]++;
                } else {
                    $cancelled[$i]++;
                }
            }
        } elseif ($range === 'month') {
            $labels = ['Week 1', 'Week 2', 'Week 3', 'Week 4'];
            $completed = array_fill(0, 4, 0);
            $pending = array_fill(0, 4, 0);
            $cancelled = array_fill(0, 4, 0);
            foreach ($bookings as $b) {
                $d = $b->start_date ? Carbon::parse($b->start_date) : null;
                if (! $d || $d->month !== (int) now()->format('n')) {
                    continue;
                }
                $i = min(3, (int) (($d->day - 1) / 7));
                if ($b->status === 'Completed') {
                    $completed[$i]++;
                } elseif (in_array($b->status, ['Pending', 'Approved', 'Active'], true)) {
                    $pending[$i]++;
                } else {
                    $cancelled[$i]++;
                }
            }
        } else {
            $labels = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
            $completed = array_fill(0, 12, 0);
            $pending = array_fill(0, 12, 0);
            $cancelled = array_fill(0, 12, 0);
            $y = (int) now()->format('Y');
            foreach ($bookings as $b) {
                $d = $b->start_date ? Carbon::parse($b->start_date) : null;
                if (! $d || $d->year !== $y) {
                    continue;
                }
                $i = $d->month - 1;
                if ($b->status === 'Completed') {
                    $completed[$i]++;
                } elseif (in_array($b->status, ['Pending', 'Approved', 'Active'], true)) {
                    $pending[$i]++;
                } else {
                    $cancelled[$i]++;
                }
            }
        }

        return response()->json([
            'data' => [
                'labels' => $labels,
                'completed' => $completed,
                'pending' => $pending,
                'cancelled' => $cancelled,
            ],
        ]);
    }

    public function carTypes(Request $request): JsonResponse
    {
        $order = ['Sedan', 'SUV', 'MPV', 'Hatchback', 'Van', 'Coupe', 'Convertible', 'Pickup'];
        $bookings = RentalBooking::query()
            ->where('archived', false)
            ->with('vehicle')
            ->limit(2000)
            ->get();
        $byType = [];
        foreach ($order as $t) {
            $byType[$t] = 0;
        }
        $total = 0;
        foreach ($bookings as $b) {
            $v = $b->vehicle;
            $type = $v && ($v->car_type ?? $v->type) ? (string) ($v->car_type ?? $v->type) : 'Sedan';
            if ($type === 'Car') {
                $type = 'Sedan';
            }
            $byType[$type] = ($byType[$type] ?? 0) + 1;
            $total++;
        }
        $total = $total ?: 1;
        $data = array_map(function ($type) use ($byType, $total) {
            $count = $byType[$type] ?? 0;
            return [
                'type' => $type,
                'count' => $count,
                'percent' => (int) round(($count / $total) * 100),
            ];
        }, $order);

        return response()->json(['data' => $data]);
    }

    public function profile(Request $request): JsonResponse
    {
        $user = $request->user();
        if ($user && $user->organization_id) {
            app(PermissionRegistrar::class)->setPermissionsTeamId($user->organization_id);
        }
        $payload = [
            'id' => $user->id,
            'name' => $user->name ?? $user->email,
            'email' => $user->email,
            'mobile' => $user->mobile,
            'avatar_url' => $user->avatar_url,
        ];
        if ($user->hasRole('client')) {
            $clientProfile = $user->clientProfile;
            if ($clientProfile) {
                $payload['avatar_url'] = $clientProfile->avatar_url ?? $user->avatar_url;
                $payload['client_profile'] = [
                    'id_number' => $clientProfile->id_number,
                    'emergency_contact_name' => $clientProfile->emergency_contact_name,
                    'emergency_contact_phone' => $clientProfile->emergency_contact_phone,
                    'address' => $clientProfile->address,
                    'city' => $clientProfile->city,
                    'province' => $clientProfile->province,
                ];
            }
        }
        return response()->json(['data' => $payload]);
    }

    public function updateProfile(Request $request): JsonResponse
    {
        $user = $request->user();
        if ($user && $user->organization_id) {
            app(PermissionRegistrar::class)->setPermissionsTeamId($user->organization_id);
        }
        $validated = $request->validate([
            'name' => 'sometimes|string|max:255',
            'email' => 'sometimes|email',
            'mobile' => 'sometimes|string|max:20',
            'address' => 'sometimes|nullable|string|max:500',
            'city' => 'sometimes|nullable|string|max:100',
            'province' => 'sometimes|nullable|string|max:100',
            'id_number' => 'sometimes|nullable|string|max:100',
            'emergency_contact_name' => 'sometimes|nullable|string|max:255',
            'emergency_contact_phone' => 'sometimes|nullable|string|max:30',
        ]);
        $user->update(array_intersect_key($validated, array_flip(['name', 'email', 'mobile', 'address', 'city', 'province'])));

        if ($user->hasRole('client')) {
            $profile = $user->clientProfile ?? new ClientProfile(['user_id' => $user->id]);
            if (! $profile->exists) {
                $profile->user_id = $user->id;
            }
            $profile->display_name = $validated['name'] ?? $user->name ?? $user->email;
            $profile->phone = $validated['mobile'] ?? $user->mobile;
            $profile->address = $validated['address'] ?? $user->address ?? $profile->address;
            $profile->city = $validated['city'] ?? $user->city ?? $profile->city;
            $profile->province = $validated['province'] ?? $user->province ?? $profile->province;
            $profile->id_number = $validated['id_number'] ?? $profile->id_number;
            $profile->emergency_contact_name = $validated['emergency_contact_name'] ?? $profile->emergency_contact_name;
            $profile->emergency_contact_phone = $validated['emergency_contact_phone'] ?? $profile->emergency_contact_phone;
            if (empty($profile->slug) && ! empty($profile->display_name)) {
                $profile->slug = ClientProfile::slugFrom($profile->display_name);
            }
            $profile->save();
        }

        return response()->json([
            'data' => [
                'id' => $user->id,
                'name' => $user->name ?? $user->email,
                'email' => $user->email,
                'mobile' => $user->mobile,
            ],
        ]);
    }

    public function profileAvatar(Request $request): JsonResponse
    {
        $user = $request->user();
        if ($user && $user->organization_id) {
            app(PermissionRegistrar::class)->setPermissionsTeamId($user->organization_id);
        }

        $file = null;
        $useBase64 = $request->has('avatar_base64') && is_string($request->input('avatar_base64'));

        if ($useBase64) {
            $request->validate([
                'avatar_base64' => ['required', 'string', 'regex:/^data:image\/(jpeg|png|gif|webp);base64,/i'],
            ], [
                'avatar_base64.required' => 'Please select a photo to upload.',
                'avatar_base64.regex' => 'The photo must be a JPEG, PNG, GIF, or WebP image.',
            ]);
        } else {
            $request->validate([
                'avatar' => ['required', 'file', 'image', 'max:5120'],
            ], [
                'avatar.required' => 'Please select a photo to upload. If you did, try using a JPEG or PNG under 5 MB.',
                'avatar.file' => 'The uploaded file is invalid.',
                'avatar.image' => 'The photo must be a JPEG, PNG, GIF, or WebP image.',
                'avatar.max' => 'The photo must not be larger than 5 MB.',
            ]);
            $file = $request->file('avatar');
        }

        try {
            // Delete old avatar if exists
            if ($user->avatar_url) {
                $oldPath = str_replace('/storage/', '', parse_url($user->avatar_url, PHP_URL_PATH));
                if ($oldPath && Storage::disk('public')->exists($oldPath)) {
                    Storage::disk('public')->delete($oldPath);
                }
            }

            if ($useBase64) {
                $data = $request->input('avatar_base64');
                $path = $this->storeBase64Image($data, $user->id);
            } else {
                $path = $file->store('avatars/' . $user->id, 'public');
            }

            $path = str_replace('\\', '/', $path);
            $url = rtrim($request->getSchemeAndHttpHost(), '/') . '/storage/' . $path;

            $user->update(['avatar_url' => $url]);

            if ($user->hasRole('client')) {
                $profile = $user->clientProfile ?? new ClientProfile(['user_id' => $user->id]);
                if (! $profile->exists) {
                    $profile->user_id = $user->id;
                }
                $profile->avatar_url = $url;
                if (empty($profile->display_name)) {
                    $profile->display_name = $user->name ?? $user->email;
                }
                if (empty($profile->slug) && ! empty($profile->display_name)) {
                    $profile->slug = ClientProfile::slugFrom($profile->display_name);
                }
                $profile->save();
            }

            return response()->json([
                'data' => ['avatar_url' => $url],
                'avatar_url' => $url,
            ]);
        } catch (\Throwable $e) {
            report($e);
            return response()->json([
                'message' => 'The avatar failed to upload. Please try again.',
            ], 500);
        }
    }

    private function storeBase64Image(string $dataUrl, string $userId): string
    {
        if (! preg_match('/^data:image\/(jpeg|png|gif|webp);base64,(.+)$/i', $dataUrl, $m)) {
            throw new \InvalidArgumentException('Invalid image data.');
        }
        $ext = str_replace('jpeg', 'jpg', strtolower($m[1]));
        $data = base64_decode($m[2], true);
        if ($data === false || strlen($data) > 5 * 1024 * 1024) {
            throw new \InvalidArgumentException('Invalid or too large image.');
        }
        $filename = uniqid('', true) . '.' . $ext;
        $dir = 'avatars/' . $userId;
        Storage::disk('public')->put($dir . '/' . $filename, $data);
        return $dir . '/' . $filename;
    }

    public function changePassword(Request $request): JsonResponse
    {
        $request->validate([
            'current_password' => 'required',
            'new_password' => 'required|string|min:8',
        ]);
        $user = $request->user();
        if (!Hash::check($request->current_password, $user->password)) {
            throw ValidationException::withMessages(['current_password' => ['The current password is incorrect.']]);
        }
        $user->update(['password' => Hash::make($request->new_password)]);
        return response()->json(['message' => 'Password updated']);
    }

}
