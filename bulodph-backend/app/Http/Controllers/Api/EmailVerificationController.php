<?php

declare(strict_types=1);

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Services\BrevoMailService;
use Illuminate\Http\JsonResponse;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Cache;
use Illuminate\Validation\ValidationException;

final class EmailVerificationController extends Controller
{
    private const OTP_CACHE_PREFIX = 'email_verification_otp:';
    private const OTP_SENT_AT_PREFIX = 'email_verification_sent_at:';
    private const OTP_TTL_MINUTES = 10;
    private const RESEND_COOLDOWN_SECONDS = 60;

    /** Roles that must verify email (non-admin). */
    private const VERIFY_ROLES = ['client', 'car_owner', 'marketing_staff'];

    private function userCanVerify(Request $request): bool
    {
        $user = $request->user();
        if (!$user) {
            return false;
        }
        if ($user->organization_id) {
            setPermissionsTeamId($user->organization_id);
        }
        $roles = $user->getRoleNames()->map(fn ($r) => strtolower((string) $r))->toArray();
        foreach (self::VERIFY_ROLES as $role) {
            if (in_array($role, $roles, true)) {
                return true;
            }
        }
        return false;
    }

    /**
     * Send OTP to current user's email. Throttled per user (1 per 60s).
     */
    public function sendOtp(Request $request): JsonResponse
    {
        if (!$this->userCanVerify($request)) {
            return response()->json(['message' => 'Not allowed.'], 403);
        }

        $user = $request->user();
        $sentKey = self::OTP_SENT_AT_PREFIX . $user->id;
        $lastSent = Cache::get($sentKey);
        if ($lastSent && (time() - (int) $lastSent) < self::RESEND_COOLDOWN_SECONDS) {
            throw ValidationException::withMessages([
                'email' => ['Please wait ' . self::RESEND_COOLDOWN_SECONDS . ' seconds before requesting another code.'],
            ]);
        }

        $code = (string) random_int(100000, 999999);
        Cache::put(self::OTP_CACHE_PREFIX . $user->id, $code, now()->addMinutes(self::OTP_TTL_MINUTES));
        Cache::put($sentKey, (string) time(), now()->addSeconds(self::RESEND_COOLDOWN_SECONDS));

        $mailer = app(BrevoMailService::class);
        $result = $mailer->sendOtpWithResult($user->email, $code);
        if (!$result['success']) {
            $error = $result['error'] ?? 'Mail could not be sent.';
            return response()->json([
                'message' => 'Could not send verification email. Check server mail configuration (MAIL_MAILER, Brevo SMTP).',
                'error' => config('app.debug') ? $error : null,
            ], 500);
        }

        return response()->json(['message' => 'OTP sent']);
    }

    /**
     * Verify OTP and set email_verified_at.
     */
    public function verify(Request $request): JsonResponse
    {
        if (!$this->userCanVerify($request)) {
            return response()->json(['message' => 'Not allowed.'], 403);
        }

        $validated = $request->validate([
            'otp' => ['required', 'string', 'size:6', 'regex:/^[0-9]+$/'],
        ]);

        $user = $request->user();
        $cached = Cache::get(self::OTP_CACHE_PREFIX . $user->id);
        if ($cached === null || $cached !== $validated['otp']) {
            throw ValidationException::withMessages([
                'otp' => ['The code is invalid or has expired. Request a new one.'],
            ]);
        }

        Cache::forget(self::OTP_CACHE_PREFIX . $user->id);
        $user->update(['email_verified_at' => now()]);

        if ($user->organization_id) {
            setPermissionsTeamId($user->organization_id);
        }

        $payload = [
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
        ];

        return response()->json(['message' => 'Email verified', 'user' => $payload]);
    }
}
