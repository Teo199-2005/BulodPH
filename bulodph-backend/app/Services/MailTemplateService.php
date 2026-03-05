<?php

declare(strict_types=1);

namespace App\Services;

/**
 * Branded HTML email wrapper for BulodPH. Uses inline styles for email client compatibility.
 * Blue-black color scheme: dark blue-black header, blue CTAs, black text.
 */
final class MailTemplateService
{
    private const BRAND_PRIMARY = '#0a0e1a';
    private const BRAND_ACTION = '#1e40af';
    private const BRAND_BG = '#f0f4f8';
    private const TEXT_PRIMARY = '#0f172a';
    private const TEXT_MUTED = '#475569';
    private const BORDER = '#cbd5e1';
    private const WHITE = '#ffffff';
    private const FOOTER_LINK = '#1e40af';
    private const FOOTER_BG = '#e2e8f0';

    private const BRAND_NAME = 'BulodPH';
    private const BRAND_TAGLINE = 'BulodPH car rental marketplace';

    private string $appUrl;

    public function __construct()
    {
        $this->appUrl = rtrim(config('app.url', 'https://bulodph.com'), '/');
    }

    /**
     * Wrap body HTML in the branded BulodPH email layout.
     */
    public function wrap(string $bodyHtml): string
    {
        $year = date('Y');
        $bg = self::BRAND_BG;
        $primary = self::BRAND_PRIMARY;
        $white = self::WHITE;
        $text = self::TEXT_PRIMARY;
        $border = self::BORDER;
        $muted = self::TEXT_MUTED;
        $link = self::FOOTER_LINK;
        $footerBg = self::FOOTER_BG;
        $name = self::BRAND_NAME;
        $tagline = self::BRAND_TAGLINE;
        $url = $this->appUrl;
        return <<<HTML
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="utf-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>{$name}</title>
</head>
<body style="margin:0;padding:0;background-color:{$bg};font-family:-apple-system,BlinkMacSystemFont,'Segoe UI',Roboto,Oxygen-Sans,Ubuntu,sans-serif;font-size:16px;line-height:1.5;color:{$text};">
  <table role="presentation" width="100%" cellspacing="0" cellpadding="0" border="0" style="background-color:{$bg};">
    <tr>
      <td align="center" style="padding:32px 16px;">
        <table role="presentation" width="100%" cellspacing="0" cellpadding="0" border="0" style="max-width:560px;margin:0 auto;">
          <tr>
            <td style="background-color:{$primary};color:{$white};padding:20px 24px;border-radius:12px 12px 0 0;">
              <span style="font-size:22px;font-weight:700;letter-spacing:-0.02em;">{$name}</span>
            </td>
          </tr>
          <tr>
            <td style="background-color:{$white};padding:32px 24px;border-left:1px solid {$border};border-right:1px solid {$border};border-bottom:1px solid {$border};">
{$bodyHtml}
            </td>
          </tr>
          <tr>
            <td style="background-color:{$footerBg};padding:24px;text-align:center;font-size:13px;color:{$muted};border:1px solid {$border};border-top:none;border-radius:0 0 12px 12px;">
              <a href="{$url}" style="color:{$link};text-decoration:none;font-weight:600;">{$url}</a>
              <br><br>
              &copy; {$year} {$tagline}.
            </td>
          </tr>
        </table>
      </td>
    </tr>
  </table>
</body>
</html>
HTML;
    }

    /**
     * Wrap plain text content as a single paragraph (for simple messages).
     */
    public function wrapParagraph(string $text): string
    {
        $escaped = htmlspecialchars($text, ENT_QUOTES, 'UTF-8');
        return '<p style="margin:0 0 16px 0;color:' . self::TEXT_PRIMARY . ';">' . $escaped . '</p>';
    }

    /**
     * Build a primary CTA button (inline styles for email).
     */
    public function button(string $url, string $label): string
    {
        $escapedLabel = htmlspecialchars($label, ENT_QUOTES, 'UTF-8');
        $action = self::BRAND_ACTION;
        return <<<HTML
<table role="presentation" cellspacing="0" cellpadding="0" border="0" style="margin:24px 0;">
  <tr>
    <td>
      <a href="{$url}" style="display:inline-block;background-color:{$action};color:white;text-decoration:none;font-weight:600;padding:12px 24px;border-radius:8px;font-size:15px;">{$escapedLabel}</a>
    </td>
  </tr>
</table>
HTML;
    }
}
