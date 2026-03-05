<?php

declare(strict_types=1);

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Models\User;
use Illuminate\Http\JsonResponse;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Hash;
use Illuminate\Support\Str;
use Spatie\Permission\Models\Role;
use Spatie\Permission\PermissionRegistrar;

final class AdminClientController extends Controller
{
    /**
     * List users with role "client" in the same organization as the authenticated admin.
     */
    public function index(Request $request): JsonResponse
    {
        $teamId = auth()->user()?->organization_id;
        if ($teamId === null) {
            return response()->json(['data' => []], 200);
        }
        app(PermissionRegistrar::class)->setPermissionsTeamId($teamId);
        $search = $this->sanitizeSearchLike($request->input('search'));

        $users = User::query()
            ->from('users')
            ->leftJoin('client_profiles', 'users.id', '=', 'client_profiles.user_id')
            ->where('users.organization_id', $teamId)
            ->whereHas('roles', fn ($q) => $q->where('name', 'client'))
            ->when($search !== null && $search !== '', function ($q) use ($search) {
                $q->where(function ($query) use ($search) {
                    $query->where('users.name', 'like', '%' . $search . '%')
                        ->orWhere('users.email', 'like', '%' . $search . '%')
                        ->orWhere('users.mobile', 'like', '%' . $search . '%');
                });
            })
            ->orderBy('users.name')
            ->select([
                'users.id',
                'users.name',
                'users.email',
                'users.mobile',
                'users.city',
                'users.province',
                'users.address',
                'users.notes',
                'users.is_active',
                'users.email_verified_at',
                'users.avatar_url as users_avatar_url',
                'client_profiles.avatar_url as client_profile_avatar_url',
            ])
            ->get();

        $data = $users->map(function ($row) {
            $avatarUrl = $row->client_profile_avatar_url ?? $row->users_avatar_url;
            return [
                'id' => $row->id,
                'full_name' => $row->name ?? $row->email,
                'email' => $row->email,
                'phone' => $row->mobile ?? '',
                'city' => $row->city ?? '',
                'province' => $row->province ?? '',
                'address' => $row->address ?? '',
                'status' => $row->is_active ? 'Active' : 'Inactive',
                'bookings_count' => 0,
                'notes' => $row->notes ?? '',
                'avatar_url' => $avatarUrl,
                'email_verified' => (bool) $row->email_verified_at,
            ];
        });

        return response()
            ->json(['data' => $data->values()->all()])
            ->header('Cache-Control', 'no-store, no-cache, must-revalidate, max-age=0')
            ->header('Pragma', 'no-cache');
    }

    /**
     * Get a single client by id (uuid).
     */
    public function show(string $id): JsonResponse
    {
        if (\strlen($id) > 64) {
            return response()->json(['message' => 'Invalid ID.'], 404);
        }
        $teamId = auth()->user()?->organization_id;
        if ($teamId === null) {
            return response()->json(['data' => null], 404);
        }
        app(PermissionRegistrar::class)->setPermissionsTeamId($teamId);
        $row = User::query()
            ->from('users')
            ->leftJoin('client_profiles', 'users.id', '=', 'client_profiles.user_id')
            ->where('users.organization_id', $teamId)
            ->whereHas('roles', fn ($q) => $q->where('name', 'client'))
            ->where('users.id', $id)
            ->select([
                'users.id',
                'users.name',
                'users.email',
                'users.mobile',
                'users.city',
                'users.province',
                'users.address',
                'users.notes',
                'users.is_active',
                'users.email_verified_at',
                'users.avatar_url as users_avatar_url',
                'client_profiles.avatar_url as client_profile_avatar_url',
            ])
            ->first();

        if (!$row) {
            return response()->json(['data' => null], 404);
        }

        $avatarUrl = $row->client_profile_avatar_url ?? $row->users_avatar_url;
        $data = [
            'id' => $row->id,
            'full_name' => $row->name ?? $row->email,
            'email' => $row->email,
            'phone' => $row->mobile ?? '',
            'city' => $row->city ?? '',
            'province' => $row->province ?? '',
            'address' => $row->address ?? '',
            'status' => $row->is_active ? 'Active' : 'Inactive',
            'bookings_count' => 0,
            'notes' => $row->notes ?? '',
            'avatar_url' => $avatarUrl,
            'email_verified' => (bool) $row->email_verified_at,
        ];

        return response()
            ->json(['data' => $data])
            ->header('Cache-Control', 'no-store, no-cache, must-revalidate, max-age=0')
            ->header('Pragma', 'no-cache');
    }

    /**
     * Create a client (user with role client) in the admin's organization.
     */
    public function store(Request $request): JsonResponse
    {
        $teamId = auth()->user()?->organization_id;
        if ($teamId === null) {
            return response()->json(['message' => 'No organization.'], 403);
        }

        $validated = $request->validate([
            'full_name' => ['required', 'string', 'max:255'],
            'email' => ['required', 'email', 'max:255'],
            'phone' => ['nullable', 'string', 'max:50'],
            'address' => ['nullable', 'string', 'max:500'],
            'city' => ['nullable', 'string', 'max:100'],
            'province' => ['nullable', 'string', 'max:100'],
            'notes' => ['nullable', 'string', 'max:2000'],
        ]);

        $email = strtolower($validated['email']);
        if (User::where('email', $email)->exists()) {
            return response()->json(['message' => 'A user with this email already exists.'], 422);
        }

        app(PermissionRegistrar::class)->setPermissionsTeamId($teamId);
        $role = Role::firstOrCreate(
            ['organization_id' => $teamId, 'name' => 'client', 'guard_name' => 'web'],
            ['organization_id' => $teamId, 'name' => 'client', 'guard_name' => 'web']
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
            'notes' => $validated['notes'] ?? null,
            'is_active' => true,
        ]);
        $user->assignRole($role);

        $data = [
            'id' => $user->id,
            'full_name' => $user->name ?? $user->email,
            'email' => $user->email,
            'phone' => $user->mobile ?? '',
            'city' => $validated['city'] ?? '',
            'province' => $validated['province'] ?? '',
            'address' => $validated['address'] ?? '',
            'status' => 'Active',
            'bookings_count' => 0,
            'notes' => $validated['notes'] ?? '',
            'avatar_url' => $user->avatar_url,
        ];

        return response()->json(['data' => $data], 201);
    }

    /**
     * Update a client by id.
     */
    public function update(Request $request, string $id): JsonResponse
    {
        if (\strlen($id) > 64) {
            return response()->json(['message' => 'Invalid ID.'], 404);
        }
        $teamId = auth()->user()?->organization_id;
        if ($teamId === null) {
            return response()->json(['message' => 'No organization.'], 403);
        }
        app(PermissionRegistrar::class)->setPermissionsTeamId($teamId);
        $user = User::query()
            ->where('organization_id', $teamId)
            ->whereHas('roles', fn ($q) => $q->where('name', 'client'))
            ->find($id);

        if (!$user) {
            return response()->json(['message' => 'Client not found.'], 404);
        }

        $validated = $request->validate([
            'full_name' => ['sometimes', 'string', 'max:255'],
            'email' => ['sometimes', 'email', 'max:255'],
            'phone' => ['nullable', 'string', 'max:50'],
            'address' => ['nullable', 'string', 'max:500'],
            'city' => ['nullable', 'string', 'max:100'],
            'province' => ['nullable', 'string', 'max:100'],
            'notes' => ['nullable', 'string', 'max:2000'],
            'status' => ['sometimes', 'string', 'in:Active,Inactive,Pending'],
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
        if (array_key_exists('status', $validated)) {
            $user->is_active = $validated['status'] === 'Active';
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
        if (array_key_exists('notes', $validated)) {
            $user->notes = $validated['notes'];
        }
        $user->save();

        $user->load('clientProfile');
        $avatarUrl = $user->clientProfile?->avatar_url ?? $user->avatar_url;
        $data = [
            'id' => $user->id,
            'full_name' => $user->name ?? $user->email,
            'email' => $user->email,
            'phone' => $user->mobile ?? '',
            'city' => $user->city ?? '',
            'province' => $user->province ?? '',
            'address' => $user->address ?? '',
            'status' => $user->is_active ? 'Active' : 'Inactive',
            'bookings_count' => 0,
            'notes' => $user->notes ?? '',
            'avatar_url' => $avatarUrl,
        ];

        return response()->json(['data' => $data]);
    }

    /**
     * Delete (deactivate) a client. Sets is_active = false to avoid breaking booking references.
     */
    public function destroy(string $id): JsonResponse
    {
        if (\strlen($id) > 64) {
            return response()->json(['message' => 'Invalid ID.'], 404);
        }
        $teamId = auth()->user()?->organization_id;
        if ($teamId === null) {
            return response()->json(['message' => 'No organization.'], 403);
        }
        app(PermissionRegistrar::class)->setPermissionsTeamId($teamId);
        $user = User::query()
            ->where('organization_id', $teamId)
            ->whereHas('roles', fn ($q) => $q->where('name', 'client'))
            ->find($id);

        if (!$user) {
            return response()->json(['message' => 'Client not found.'], 404);
        }

        $user->update(['is_active' => false]);

        return response()->json(['message' => 'Deleted']);
    }

    /**
     * Sanitize search string for LIKE: limit length and escape wildcards (\% _) to prevent abuse.
     */
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
