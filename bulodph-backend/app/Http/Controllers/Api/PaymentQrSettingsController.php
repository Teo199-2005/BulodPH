<?php

declare(strict_types=1);

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Models\PlatformSetting;
use Illuminate\Http\JsonResponse;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Log;

final class PaymentQrSettingsController extends Controller
{
    private const KEY_GCASH_QR = 'payment_qr_gcash_url';
    private const KEY_MAYA_QR = 'payment_qr_maya_url';

    /** Get QR URLs for client payment page (manual pay flow). Authenticated users only. */
    public function show(): JsonResponse
    {
        return $this->paymentQrResponse();
    }

    /** Public: same data, no auth required — clients can load QR when paying. */
    public function showPublic(): JsonResponse
    {
        return $this->paymentQrResponse();
    }

    private function paymentQrResponse(): JsonResponse
    {
        $gcash = PlatformSetting::get(self::KEY_GCASH_QR);
        $maya = PlatformSetting::get(self::KEY_MAYA_QR);
        if (($gcash === null || $gcash === '') && ($maya === null || $maya === '')) {
            Log::info('Payment QR: GCash/Maya URLs are empty. Have admin upload images in Payment collection (QR) and click Save.');
        }
        return response()->json([
            'data' => [
                'gcashQrUrl' => $gcash,
                'mayaQrUrl' => $maya,
            ],
        ]);
    }

    /** Admin: set GCash and Maya QR image URLs. */
    public function update(Request $request): JsonResponse
    {
        $valid = $request->validate([
            // Accept image URL or data URL (e.g. from upload)
            // Base64 data URLs can be >500k even for small images; allow a few MB.
            'gcashQrUrl' => ['nullable', 'string', 'max:5000000'],
            'mayaQrUrl' => ['nullable', 'string', 'max:5000000'],
        ]);

        if (array_key_exists('gcashQrUrl', $valid)) {
            PlatformSetting::set(self::KEY_GCASH_QR, $valid['gcashQrUrl'] ?: null);
        }
        if (array_key_exists('mayaQrUrl', $valid)) {
            PlatformSetting::set(self::KEY_MAYA_QR, $valid['mayaQrUrl'] ?: null);
        }

        return response()->json([
            'data' => [
                'gcashQrUrl' => PlatformSetting::get(self::KEY_GCASH_QR),
                'mayaQrUrl' => PlatformSetting::get(self::KEY_MAYA_QR),
            ],
        ]);
    }
}
