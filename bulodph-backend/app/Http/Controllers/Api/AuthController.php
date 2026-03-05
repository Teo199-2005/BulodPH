<?php

declare(strict_types=1);

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Models\CarRentalProfile;
use App\Models\Organization;
use App\Models\User;
use App\Services\BrevoMailService;
use Illuminate\Http\JsonResponse;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Auth;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Hash;
use Illuminate\Support\Str;
use Illuminate\Validation\ValidationException;
use Spatie\Permission\Models\Role;

final class AuthController extends Controller
{
    public function login(Request $request): JsonResponse
    {
        try {
            $request->validate([
                'email' => 'required|email',
                'password' => 'required',
            ]);

            $email = $request->string('email')->trim()->lower()->value();
            $user = User::where('email', $email)
                ->where('is_active', true)
                ->first();

            if (!$user || !Hash::check($request->password, $user->password)) {
                throw ValidationException::withMessages([
                    'email' => ['The provided credentials are incorrect.'],
                ]);
            }

            if ($user->organization_id) {
                setPermissionsTeamId($user->organization_id);
            }

            $token = $user->createToken('api-token')->plainTextToken;

            return response()->json([
                'token' => $token,
                'user' => [
                    'id' => $user->id,
                    'name' => $user->name ?? $user->email,
                    'email' => $user->email,
                    'organization_id' => $user->organization_id,
                    'mobile' => $user->mobile,
                    'avatar_url' => $user->avatar_url,
                    'is_active' => $user->is_active,
                    'email_verified_at' => $user->email_verified_at?->toIso8601String(),
                    'email_verified' => (bool) $user->email_verified_at,
                    'roles' => $user->getRoleNames(),
                ],
            ]);
        } catch (ValidationException $e) {
            throw $e;
        } catch (\Throwable $e) {
            if (config('app.debug')) {
                return response()->json([
                    'message' => 'Login failed',
                    'error' => $e->getMessage(),
                    'file' => $e->getFile(),
                    'line' => $e->getLine(),
                ], 500);
            }
            throw $e;
        }
    }

    public function logout(Request $request): JsonResponse
    {
        $request->user()?->currentAccessToken()->delete();

        return response()->json(['message' => 'Logged out successfully']);
    }

    public function me(Request $request): JsonResponse
    {
        $user = $request->user();

        if ($user->organization_id) {
            setPermissionsTeamId($user->organization_id);
        }

        return response()->json([
            'id' => $user->id,
            'name' => $user->name ?? $user->email,
            'email' => $user->email,
            'organization_id' => $user->organization_id,
            'mobile' => $user->mobile,
            'avatar_url' => $user->avatar_url,
            'is_active' => $user->is_active,
            'email_verified_at' => $user->email_verified_at?->toIso8601String(),
            'email_verified' => (bool) $user->email_verified_at,
            'roles' => $user->getRoleNames(),
        ]);
    }

    public function register(Request $request): JsonResponse
    {
        $validated = $request->validate([
            'full_name' => 'required|string|max:255',
            'email' => 'required|email|unique:users,email',
            'phone' => 'required|string|max:20',
            'province_code' => 'required|string|max:20',
            'city_code' => 'required|string|max:20',
            'barangay' => 'required|string|max:255',
            'street_address' => 'required|string|max:500',
            'password' => 'required|string|min:8',
            'account_type' => 'required|in:renter,car_owner,marketing_partner',
            'marketing_consent' => 'sometimes|boolean',
            // Rental profile (when account_type is car_owner)
            'business_name' => 'required_if:account_type,car_owner|nullable|string|max:255',
            'bio' => 'nullable|string|max:2000',
            'city' => 'nullable|string|max:100',
            'province' => 'nullable|string|max:100',
            'address' => 'nullable|string|max:500',
            'business_permit_number' => 'nullable|string|max:100',
            'business_address' => 'nullable|string|max:500',
        ]);

        $organization = Organization::firstOrCreate(
            ['abn' => '11111111111'],
            [
                'trading_name' => 'BulodPH Platform',
                'is_active' => true,
            ]
        );

        $roleName = match ($validated['account_type']) {
            'renter' => 'client',
            'car_owner' => 'car_owner',
            'marketing_partner' => 'marketing_staff',
            default => 'client',
        };

        $user = DB::transaction(function () use ($validated, $organization, $roleName) {
            setPermissionsTeamId($organization->id);

            $role = Role::firstOrCreate(
                [
                    'organization_id' => $organization->id,
                    'name' => $roleName,
                    'guard_name' => 'web',
                ]
            );

            $marketingConsent = (bool) ($validated['marketing_consent'] ?? false);
            $user = User::create([
                'organization_id' => $organization->id,
                'name' => $validated['full_name'],
                'email' => strtolower($validated['email']),
                'password' => Hash::make($validated['password']),
                'mobile' => $validated['phone'],
                'is_active' => true,
                'marketing_consent_at' => $marketingConsent ? now() : null,
                'marketing_consent_source' => $marketingConsent ? 'registration' : null,
            ]);

            $user->assignRole($role);

            if (($validated['account_type'] ?? '') === 'car_owner' && !empty(trim((string) ($validated['business_name'] ?? '')))) {
                CarRentalProfile::create([
                    'user_id' => $user->id,
                    'business_name' => trim($validated['business_name']),
                    'bio' => isset($validated['bio']) ? trim($validated['bio']) : null,
                    'city' => isset($validated['city']) ? trim($validated['city']) : null,
                    'province' => isset($validated['province']) ? trim($validated['province']) : null,
                    'address' => isset($validated['address']) ? trim($validated['address']) : null,
                    'phone' => $validated['phone'] ?? null,
                    'email' => isset($validated['email']) ? trim($validated['email']) : null,
                    'business_permit_number' => isset($validated['business_permit_number']) ? trim($validated['business_permit_number']) : null,
                    'business_address' => isset($validated['business_address']) ? trim($validated['business_address']) : null,
                    'slug' => CarRentalProfile::slugFrom(trim($validated['business_name'])),
                ]);
            }

            return $user;
        });

        $token = $user->createToken('api-token')->plainTextToken;

        return response()->json([
            'token' => $token,
            'user' => [
                'id' => $user->id,
                'name' => $user->name,
                'email' => $user->email,
                'organization_id' => $user->organization_id,
                'mobile' => $user->mobile,
                'is_active' => $user->is_active,
                'email_verified_at' => $user->email_verified_at?->toIso8601String(),
                'email_verified' => (bool) $user->email_verified_at,
                'roles' => $user->getRoleNames(),
            ],
        ], 201);
    }

    public function forgotPassword(Request $request): JsonResponse
    {
        $request->validate(['email' => 'required|email']);

        $user = User::where('email', $request->email)->first();
        if (!$user) {
            return response()->json(['message' => 'If an account exists, you will receive a reset link.']);
        }

        $token = Str::random(64);
        DB::table('password_reset_tokens')->updateOrInsert(
            ['email' => $user->email],
            ['token' => Hash::make($token), 'created_at' => now()]
        );

        $frontendUrl = rtrim(config('app.frontend_url', 'http://localhost:5173'), '/');
        $resetUrl = "{$frontendUrl}/reset-password?token={$token}&email=" . urlencode($user->email);

        $mailer = app(BrevoMailService::class);
        $mailer->sendPasswordReset($user->email, $resetUrl);

        return response()->json(['message' => 'If an account exists, you will receive a reset link.']);
    }

    public function resetPassword(Request $request): JsonResponse
    {
        $request->validate([
            'email' => 'required|email',
            'token' => 'required|string',
            'password' => 'required|string|min:8|confirmed',
        ]);

        $record = DB::table('password_reset_tokens')->where('email', $request->email)->first();
        if (!$record || !Hash::check($request->token, $record->token)) {
            throw ValidationException::withMessages([
                'email' => ['This password reset link is invalid or has expired.'],
            ]);
        }

        $createdAt = \Carbon\Carbon::parse($record->created_at);
        if ($createdAt->addMinutes(60)->isPast()) {
            DB::table('password_reset_tokens')->where('email', $request->email)->delete();
            throw ValidationException::withMessages([
                'email' => ['This password reset link has expired. Please request a new one.'],
            ]);
        }

        $user = User::where('email', $request->email)->firstOrFail();
        $user->update(['password' => Hash::make($request->password)]);
        DB::table('password_reset_tokens')->where('email', $request->email)->delete();

        return response()->json(['message' => 'Password has been reset. You can now log in.']);
    }
}

