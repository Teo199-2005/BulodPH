<?php

declare(strict_types=1);

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Models\CarRentalProfile;
use App\Models\User;
use App\Models\Vehicle;
use Illuminate\Http\JsonResponse;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Hash;
use Illuminate\Support\Str;
use Spatie\Permission\Models\Role;

final class AdminCarOwnerController extends Controller
{
    /**
     * List users with role "car_owner" in the same organization as the authenticated admin.
     */
    public function index(Request $request): JsonResponse
    {
        $teamId = auth()->user()->organization_id;
        $search = $this->sanitizeSearchLike($request->input('search'));

        $users = User::query()
            ->with('carRentalProfile')
            ->where('organization_id', $teamId)
            ->whereHas('roles', fn ($q) => $q->where('name', 'car_owner'))
            ->when($search !== null && $search !== '', function ($q) use ($search) {
                $q->where(function ($query) use ($search) {
                    $query->where('name', 'like', '%' . $search . '%')
                        ->orWhere('email', 'like', '%' . $search . '%')
                        ->orWhere('mobile', 'like', '%' . $search . '%');
                });
            })
            ->orderBy('name')
            ->get();

        $userIds = $users->pluck('id')->all();
        $listingsCount = Vehicle::query()
            ->whereIn('user_id', $userIds)
            ->selectRaw('user_id, count(*) as cnt')
            ->groupBy('user_id')
            ->pluck('cnt', 'user_id');

        $data = $users->map(function (User $user) use ($listingsCount) {
            $profile = $user->carRentalProfile;
            return [
                'id' => $user->id,
                'full_name' => $user->name ?? $user->email,
                'email' => $user->email,
                'phone' => $user->mobile ?? '',
                'city' => $user->city ?? '',
                'province' => $user->province ?? '',
                'status' => $user->is_active ? 'Active' : 'Inactive',
                'listings_count' => $listingsCount->get($user->id, 0),
                'avatar_url' => $user->avatar_url,
                'logo_url' => $profile?->logo_url,
                'business_name' => $profile?->business_name,
                'account_status' => $user->is_active ? 'Approved' : 'Pending',
                'verified' => (bool) $profile?->verified_at,
                'has_permit' => ! empty($profile?->business_permit_number),
                'email_verified' => (bool) $user->email_verified_at,
            ];
        });

        return response()->json(['data' => $data->values()->all()]);
    }

    /**
     * Get a single car owner by id (uuid).
     */
    public function show(string $id): JsonResponse
    {
        $teamId = auth()->user()->organization_id;
        $user = User::query()
            ->with('carRentalProfile')
            ->where('organization_id', $teamId)
            ->whereHas('roles', fn ($q) => $q->where('name', 'car_owner'))
            ->find($id);

        if (! $user) {
            return response()->json(['data' => null], 404);
        }

        $listingsCount = Vehicle::query()->where('user_id', $user->id)->count();
        $profile = $user->carRentalProfile;

        $data = [
            'id' => $user->id,
            'full_name' => $user->name ?? $user->email,
            'email' => $user->email,
            'phone' => $user->mobile ?? '',
            'city' => $user->city ?? '',
            'province' => $user->province ?? '',
            'status' => $user->is_active ? 'Active' : 'Inactive',
            'listings_count' => $listingsCount,
            'avatar_url' => $user->avatar_url,
            'logo_url' => $profile?->logo_url,
            'business_name' => $profile?->business_name,
            'account_status' => $user->is_active ? 'Approved' : 'Pending',
            'verified' => (bool) $profile?->verified_at,
            'has_permit' => ! empty($profile?->business_permit_number),
            'email_verified' => (bool) $user->email_verified_at,
        ];

        return response()->json(['data' => $data]);
    }

    /**
     * Create a car owner (user with role car_owner) and optional CarRentalProfile.
     */
    public function store(Request $request): JsonResponse
    {
        $teamId = auth()->user()->organization_id;
        if ($teamId === null) {
            return response()->json(['message' => 'No organization.'], 403);
        }

        $validated = $request->validate([
            'full_name' => ['required', 'string', 'max:255'],
            'business_name' => ['nullable', 'string', 'max:255'],
            'email' => ['required', 'email', 'max:255'],
            'phone' => ['nullable', 'string', 'max:50'],
            'address' => ['nullable', 'string', 'max:500'],
            'city' => ['nullable', 'string', 'max:100'],
            'province' => ['nullable', 'string', 'max:100'],
            'status' => ['sometimes', 'string', 'in:Active,Inactive'],
        ]);

        $email = strtolower($validated['email']);
        if (User::where('email', $email)->exists()) {
            return response()->json(['message' => 'A user with this email already exists.'], 422);
        }

        setPermissionsTeamId($teamId);
        $role = Role::firstOrCreate(
            ['organization_id' => $teamId, 'name' => 'car_owner', 'guard_name' => 'web'],
            ['organization_id' => $teamId, 'name' => 'car_owner', 'guard_name' => 'web']
        );

        $user = User::create([
            'organization_id' => $teamId,
            'name' => $validated['full_name'],
            'email' => $email,
            'password' => Hash::make(Str::random(32)),
            'mobile' => $validated['phone'] ?? '',
            'city' => $validated['city'] ?? null,
            'province' => $validated['province'] ?? null,
            'address' => $validated['address'] ?? null,
            'is_active' => ($validated['status'] ?? 'Active') === 'Active',
        ]);
        $user->assignRole($role);

        $businessName = $validated['business_name'] ?? $validated['full_name'];
        CarRentalProfile::create([
            'user_id' => $user->id,
            'business_name' => $businessName,
            'city' => $validated['city'] ?? null,
            'province' => $validated['province'] ?? null,
            'address' => $validated['address'] ?? null,
            'phone' => $validated['phone'] ?? null,
            'email' => $email,
            'slug' => CarRentalProfile::slugFrom($businessName),
        ]);

        $user->load('carRentalProfile');
        $profile = $user->carRentalProfile;
        $listingsCount = 0;
        $data = [
            'id' => $user->id,
            'full_name' => $user->name ?? $user->email,
            'email' => $user->email,
            'phone' => $user->mobile ?? '',
            'city' => $user->city ?? '',
            'province' => $user->province ?? '',
            'status' => $user->is_active ? 'Active' : 'Inactive',
            'listings_count' => $listingsCount,
            'avatar_url' => $user->avatar_url,
            'logo_url' => $profile?->logo_url,
            'business_name' => $profile?->business_name,
            'account_status' => $user->is_active ? 'Approved' : 'Pending',
            'verified' => (bool) $profile?->verified_at,
            'has_permit' => ! empty($profile?->business_permit_number),
        ];

        return response()->json(['data' => $data], 201);
    }

    /**
     * Update a car owner and their profile.
     */
    public function update(Request $request, string $id): JsonResponse
    {
        $teamId = auth()->user()->organization_id;
        $user = User::query()
            ->where('organization_id', $teamId)
            ->whereHas('roles', fn ($q) => $q->where('name', 'car_owner'))
            ->find($id);

        if (! $user) {
            return response()->json(['message' => 'Car owner not found.'], 404);
        }

        $validated = $request->validate([
            'full_name' => ['sometimes', 'string', 'max:255'],
            'business_name' => ['nullable', 'string', 'max:255'],
            'email' => ['sometimes', 'email', 'max:255'],
            'phone' => ['nullable', 'string', 'max:50'],
            'address' => ['nullable', 'string', 'max:500'],
            'city' => ['nullable', 'string', 'max:100'],
            'province' => ['nullable', 'string', 'max:100'],
            'status' => ['sometimes', 'string', 'in:Active,Inactive'],
        ]);

        if (isset($validated['email'])) {
            $email = strtolower($validated['email']);
            $existing = User::where('email', $email)->where('id', '!=', $user->id)->first();
            if ($existing) {
                return response()->json(['message' => 'Another user has this email.'], 422);
            }
            $user->email = $email;
        }
        if (array_key_exists('full_name', $validated)) {
            $user->name = $validated['full_name'];
        }
        if (array_key_exists('phone', $validated)) {
            $user->mobile = $validated['phone'];
        }
        if (array_key_exists('city', $validated)) {
            $user->city = $validated['city'];
        }
        if (array_key_exists('province', $validated)) {
            $user->province = $validated['province'];
        }
        if (array_key_exists('address', $validated)) {
            $user->address = $validated['address'];
        }
        if (array_key_exists('status', $validated)) {
            $user->is_active = $validated['status'] === 'Active';
        }
        $user->save();

        $profile = $user->carRentalProfile;
        if ($profile) {
            if (array_key_exists('business_name', $validated)) {
                $profile->business_name = $validated['business_name'] ?? $user->name;
                $profile->slug = CarRentalProfile::slugFrom($profile->business_name);
            }
            if (array_key_exists('city', $validated)) {
                $profile->city = $validated['city'];
            }
            if (array_key_exists('province', $validated)) {
                $profile->province = $validated['province'];
            }
            if (array_key_exists('address', $validated)) {
                $profile->address = $validated['address'];
            }
            if (array_key_exists('phone', $validated)) {
                $profile->phone = $validated['phone'];
            }
            if (array_key_exists('email', $validated)) {
                $profile->email = strtolower($validated['email']);
            }
            $profile->save();
        }

        $user->load('carRentalProfile');
        $profile = $user->carRentalProfile;
        $listingsCount = Vehicle::query()->where('user_id', $user->id)->count();
        $data = [
            'id' => $user->id,
            'full_name' => $user->name ?? $user->email,
            'email' => $user->email,
            'phone' => $user->mobile ?? '',
            'city' => $user->city ?? '',
            'province' => $user->province ?? '',
            'status' => $user->is_active ? 'Active' : 'Inactive',
            'listings_count' => $listingsCount,
            'avatar_url' => $user->avatar_url,
            'logo_url' => $profile?->logo_url,
            'business_name' => $profile?->business_name,
            'account_status' => $user->is_active ? 'Approved' : 'Pending',
            'verified' => (bool) $profile?->verified_at,
            'has_permit' => ! empty($profile?->business_permit_number),
        ];

        return response()->json(['data' => $data]);
    }

    /**
     * Deactivate a car owner (is_active = false).
     */
    public function destroy(string $id): JsonResponse
    {
        $teamId = auth()->user()->organization_id;
        $user = User::query()
            ->where('organization_id', $teamId)
            ->whereHas('roles', fn ($q) => $q->where('name', 'car_owner'))
            ->find($id);

        if (! $user) {
            return response()->json(['message' => 'Car owner not found.'], 404);
        }

        $user->update(['is_active' => false]);

        return response()->json(['message' => 'Deleted']);
    }

    /** Sanitize search for LIKE: limit length and escape wildcards. */
    private function sanitizeSearchLike(mixed $value): ?string
    {
        if ($value === null || $value === '') {
            return null;
        }
        $s = \is_string($value) ? $value : (string) $value;
        $s = mb_substr(trim($s), 0, 100);
        if ($s === '') {
            return null;
        }
        return str_replace(['\\', '%', '_'], ['\\\\', '\\%', '\\_'], $s);
    }
}
