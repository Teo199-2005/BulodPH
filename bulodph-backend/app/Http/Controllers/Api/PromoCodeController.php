<?php

declare(strict_types=1);

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Models\PromoCode;
use Illuminate\Http\JsonResponse;
use Illuminate\Http\Request;

final class PromoCodeController extends Controller
{
    /**
     * Validate a promo code and return discount info. Query: code, days (rental days).
     */
    public function validate(Request $request): JsonResponse
    {
        $code = $request->input('code');
        $days = (int) $request->input('days', 1);

        if (empty($code) || !is_string($code)) {
            return response()->json(['valid' => false, 'message' => 'Code is required']);
        }

        $promo = PromoCode::query()
            ->where('code', strtoupper(trim($code)))
            ->where('active', true)
            ->where(function ($q) {
                $q->whereNull('expires_at')->orWhere('expires_at', '>', now());
            })
            ->first();

        if (!$promo) {
            return response()->json(['valid' => false, 'message' => 'Invalid or expired promo code']);
        }

        if ($days < $promo->min_rental_days) {
            return response()->json([
                'valid' => false,
                'message' => "This code requires a minimum of {$promo->min_rental_days} day(s).",
            ]);
        }

        if ($promo->max_rental_days !== null && $days > $promo->max_rental_days) {
            return response()->json([
                'valid' => false,
                'message' => "This code is valid for {$promo->max_rental_days}-day booking(s) only.",
            ]);
        }

        return response()->json([
            'valid' => true,
            'code' => $promo->code,
            'title' => $promo->title,
            'discount_percent' => $promo->discount_percent,
        ]);
    }
}
