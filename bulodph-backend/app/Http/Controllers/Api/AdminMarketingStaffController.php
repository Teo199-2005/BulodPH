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

final class AdminMarketingStaffController extends Controller
{
    /**
     * List users with role "marketing_staff" in the same organization as the authenticated admin.
     */
    public function index(Request $request): JsonResponse
    {
        $teamId = auth()->user()->organization_id;
        $search = $this->sanitizeSearchLike($request->input('search'));

        $users = User::query()
            ->where('organization_id', $teamId)
            ->whereHas('roles', fn ($q) => $q->where('name', 'marketing_staff'))
            ->when($search !== null && $search !== '', function ($q) use ($search) {
                $q->where(function ($query) use ($search) {
                    $query->where('name', 'like', '%' . $search . '%')
                        ->orWhere('email', 'like', '%' . $search . '%')
                        ->orWhere('mobile', 'like', '%' . $search . '%');
                });
            })
            ->orderBy('name')
            ->get();

        $data = $users->map(function (User $user) {
            return [
                'id' => $user->id,
                'full_name' => $user->name ?? $user->email,
                'name' => $user->name ?? $user->email,
                'email' => $user->email,
                'phone' => $user->mobile ?? '',
                'city' => $user->city ?? '',
                'province' => $user->province ?? '',
                'referral_code' => '',
                'status' => $user->is_active ? 'Active' : 'Inactive',
                'referrals_count' => 0,
                'notes' => $user->notes ?? '',
                'avatar_url' => $user->avatar_url,
                'email_verified' => (bool) $user->email_verified_at,
            ];
        });

        return response()->json(['data' => $data->values()->all()]);
    }

    /**
     * Get a single marketing partner by id (uuid).
     */
    public function show(string $id): JsonResponse
    {
        $teamId = auth()->user()->organization_id;
        $user = User::query()
            ->where('organization_id', $teamId)
            ->whereHas('roles', fn ($q) => $q->where('name', 'marketing_staff'))
            ->find($id);

        if (!$user) {
            return response()->json(['data' => null], 404);
        }

        $data = [
            'id' => $user->id,
            'full_name' => $user->name ?? $user->email,
            'name' => $user->name ?? $user->email,
            'email' => $user->email,
            'phone' => $user->mobile ?? '',
            'city' => $user->city ?? '',
            'province' => $user->province ?? '',
            'referral_code' => '',
            'status' => $user->is_active ? 'Active' : 'Inactive',
            'referrals_count' => 0,
            'notes' => $user->notes ?? '',
            'avatar_url' => $user->avatar_url,
            'email_verified' => (bool) $user->email_verified_at,
        ];

        return response()->json(['data' => $data]);
    }

    /**
     * Create a marketing staff (user with role marketing_staff).
     */
    public function store(Request $request): JsonResponse
    {
        $teamId = auth()->user()->organization_id;
        if ($teamId === null) {
            return response()->json(['message' => 'No organization.'], 403);
        }

        $validated = $request->validate([
            'full_name' => ['required', 'string', 'max:255'],
            'name' => ['nullable', 'string', 'max:255'],
            'email' => ['required', 'email', 'max:255'],
            'phone' => ['nullable', 'string', 'max:50'],
            'city' => ['nullable', 'string', 'max:100'],
            'province' => ['nullable', 'string', 'max:100'],
            'status' => ['sometimes', 'string', 'in:Active,Pending,Inactive'],
            'notes' => ['nullable', 'string', 'max:1000'],
        ]);

        $email = strtolower($validated['email']);
        if (User::where('email', $email)->exists()) {
            return response()->json(['message' => 'A user with this email already exists.'], 422);
        }

        $fullName = $validated['full_name'] ?? $validated['name'] ?? 'Unnamed';
        setPermissionsTeamId($teamId);
        $role = Role::firstOrCreate(
            ['organization_id' => $teamId, 'name' => 'marketing_staff', 'guard_name' => 'web'],
            ['organization_id' => $teamId, 'name' => 'marketing_staff', 'guard_name' => 'web']
        );

        $user = User::create([
            'organization_id' => $teamId,
            'name' => $fullName,
            'email' => $email,
            'password' => Hash::make(Str::random(32)),
            'mobile' => $validated['phone'] ?? '',
            'city' => $validated['city'] ?? null,
            'province' => $validated['province'] ?? null,
            'notes' => $validated['notes'] ?? null,
            'is_active' => in_array($validated['status'] ?? 'Active', ['Active'], true),
        ]);
        $user->assignRole($role);

        $data = [
            'id' => $user->id,
            'full_name' => $user->name ?? $user->email,
            'name' => $user->name ?? $user->email,
            'email' => $user->email,
            'phone' => $user->mobile ?? '',
            'city' => $user->city ?? '',
            'province' => $user->province ?? '',
            'status' => $user->is_active ? 'Active' : 'Inactive',
            'referrals_count' => 0,
        ];

        return response()->json(['data' => $data], 201);
    }

    /**
     * Update a marketing staff by id.
     */
    public function update(Request $request, string $id): JsonResponse
    {
        $teamId = auth()->user()->organization_id;
        $user = User::query()
            ->where('organization_id', $teamId)
            ->whereHas('roles', fn ($q) => $q->where('name', 'marketing_staff'))
            ->find($id);

        if (! $user) {
            return response()->json(['message' => 'Marketing staff not found.'], 404);
        }

        $validated = $request->validate([
            'full_name' => ['sometimes', 'string', 'max:255'],
            'name' => ['nullable', 'string', 'max:255'],
            'email' => ['sometimes', 'email', 'max:255'],
            'phone' => ['nullable', 'string', 'max:50'],
            'city' => ['nullable', 'string', 'max:100'],
            'province' => ['nullable', 'string', 'max:100'],
            'status' => ['sometimes', 'string', 'in:Active,Pending,Inactive'],
            'notes' => ['nullable', 'string', 'max:1000'],
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
        if (array_key_exists('name', $validated) && $validated['name'] !== null && $validated['name'] !== '') {
            $user->name = $validated['name'];
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
        if (array_key_exists('status', $validated)) {
            $user->is_active = $validated['status'] === 'Active';
        }
        if (array_key_exists('notes', $validated)) {
            $user->notes = $validated['notes'];
        }
        $user->save();

        $data = [
            'id' => $user->id,
            'full_name' => $user->name ?? $user->email,
            'name' => $user->name ?? $user->email,
            'email' => $user->email,
            'phone' => $user->mobile ?? '',
            'city' => $user->city ?? '',
            'province' => $user->province ?? '',
            'status' => $user->is_active ? 'Active' : 'Inactive',
            'referrals_count' => 0,
        ];

        return response()->json(['data' => $data]);
    }

    /**
     * Deactivate a marketing staff (is_active = false).
     */
    public function destroy(string $id): JsonResponse
    {
        $teamId = auth()->user()->organization_id;
        $user = User::query()
            ->where('organization_id', $teamId)
            ->whereHas('roles', fn ($q) => $q->where('name', 'marketing_staff'))
            ->find($id);

        if (! $user) {
            return response()->json(['message' => 'Marketing staff not found.'], 404);
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
