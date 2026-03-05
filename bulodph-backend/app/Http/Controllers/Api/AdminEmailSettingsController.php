<?php

declare(strict_types=1);

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Services\BrevoMailService;
use Illuminate\Http\JsonResponse;
use Illuminate\Http\Request;

final class AdminEmailSettingsController extends Controller
{
    /** Default recipient for admin test emails. */
    private const TEST_EMAIL_TO = 'teofiloharry69@gmail.com';

    /**
     * Send a test email to verify Brevo is configured and delivering.
     * POST /admin/settings/test-email
     */
    public function sendTestEmail(Request $request): JsonResponse
    {
        $valid = $request->validate([
            'to' => ['nullable', 'email'],
        ]);
        $to = $valid['to'] ?? self::TEST_EMAIL_TO;

        $mailer = app(BrevoMailService::class);
        $subject = 'BulodPH – Test email';
        $body = '<p style="margin:0 0 16px 0;color:#1F2937;">This is a test email from BulodPH.</p>';
        $body .= '<p style="margin:0;color:#64748B;font-size:14px;">If you received this, your email delivery is working correctly.</p>';

        $result = $mailer->sendWithResult($to, $subject, $body);

        if (!$result['success']) {
            return response()->json([
                'message' => $result['error'] ?? 'Failed to send test email. Check BREVO_API_KEY and Brevo SMTP settings.',
            ], 502);
        }

        return response()->json([
            'message' => 'Test email sent to ' . $to,
        ]);
    }
}
