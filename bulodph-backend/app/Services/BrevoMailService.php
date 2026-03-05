<?php

declare(strict_types=1);

namespace App\Services;

use Illuminate\Support\Facades\Log;
use Illuminate\Support\Facades\Mail;

final class BrevoMailService
{
    private string $senderEmail;

    private string $senderName;

    private MailTemplateService $template;

    public function __construct(MailTemplateService $template)
    {
        $this->senderEmail = config('mail.from.address', 'noreply@example.com');
        $this->senderName = config('mail.from.name', config('app.name'));
        $this->template = $template;
    }

    /**
     * Send a transactional email via Brevo SMTP (Laravel mailer). Uses MAIL_* / SMTP key only.
     */
    public function send(string $to, string $subject, string $htmlContent, ?string $textContent = null): bool
    {
        $result = $this->sendWithResult($to, $subject, $htmlContent, $textContent);
        return $result['success'];
    }

    /**
     * Send and return result with optional error message (for admin test email).
     *
     * @return array{success: bool, error: ?string}
     */
    public function sendWithResult(string $to, string $subject, string $htmlContent, ?string $textContent = null): array
    {
        try {
            $wrappedHtml = $this->template->wrap($htmlContent);
            Mail::html($wrappedHtml, function ($message) use ($to, $subject, $textContent) {
                $message->to($to)
                    ->subject($subject)
                    ->from($this->senderEmail, $this->senderName);
                if ($textContent !== null && $textContent !== '') {
                    $message->text($textContent);
                }
            });
            return ['success' => true, 'error' => null];
        } catch (\Throwable $e) {
            $msg = $e->getMessage();
            Log::error('Mail send failed', ['to' => $to, 'subject' => $subject, 'message' => $msg]);
            if (str_contains($msg, '535')) {
                return [
                    'success' => false,
                    'error' => 'Gmail rejected login. 1) Turn ON 2-Step Verification at myaccount.google.com/signinoptions/two-step-verification 2) Create an App Password at myaccount.google.com/apppasswords (select Mail, copy the 16-character password) 3) Set MAIL_PASSWORD to that password in .env (no spaces). If it still fails try MAIL_PORT=465 and MAIL_ENCRYPTION=ssl.',
                ];
            }
            return ['success' => false, 'error' => $msg];
        }
    }

    /**
     * Send email verification OTP (6-digit code).
     */
    public function sendOtp(string $to, string $code): bool
    {
        $result = $this->sendOtpWithResult($to, $code);
        return $result['success'];
    }

    /**
     * Send OTP and return result with error message if failed (for API to report mail failures).
     *
     * @return array{success: bool, error: ?string}
     */
    public function sendOtpWithResult(string $to, string $code): array
    {
        $subject = 'Your BulodPH verification code';
        $body = '<p style="margin:0 0 16px 0;color:#0f172a;">Your verification code is:</p>';
        $body .= '<p style="margin:8px 0 24px 0;font-size:28px;font-weight:700;letter-spacing:0.2em;color:#1e40af;">' . htmlspecialchars($code) . '</p>';
        $body .= '<p style="margin:0;font-size:14px;color:#475569;">This code expires in 10 minutes. If you didn\'t request it, you can ignore this email.</p>';
        return $this->sendWithResult($to, $subject, $body);
    }

    /**
     * Send password reset email.
     */
    public function sendPasswordReset(string $to, string $resetUrl): bool
    {
        $subject = 'Reset your password - ' . config('app.name');
        $body = '<p style="margin:0 0 16px 0;color:#1F2937;">You requested a password reset. Click the button below to set a new password.</p>';
        $body .= $this->template->button($resetUrl, 'Reset password');
        $body .= '<p style="margin:16px 0 0 0;font-size:14px;color:#64748B;">If you didn\'t request this, you can ignore this email. This link expires in 60 minutes.</p>';
        return $this->send($to, $subject, $body);
    }
}
