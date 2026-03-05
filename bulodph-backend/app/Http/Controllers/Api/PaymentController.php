<?php

declare(strict_types=1);

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Http\Requests\CreatePaymentRequest;
use Illuminate\Http\JsonResponse;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Log;

/**
 * Payment API (GCash / Maya).
 * When PAYMENT_GATEWAY_ENABLED is false, returns 503 so the frontend can show "Payments coming soon".
 * When enabled, wire in your gateway here and persist payment records.
 */
final class PaymentController extends Controller
{
    public function create(CreatePaymentRequest $request): JsonResponse
    {
        $valid = $request->validated();
        $userId = $request->user()?->id;

        Log::info('Payment create requested', [
            'booking_id' => $valid['booking_id'],
            'amount' => $valid['amount'],
            'currency' => $valid['currency'] ?? 'PHP',
            'user_id' => $userId,
        ]);

        if (! config('services.payment_gateway_enabled', false)) {
            return response()->json([
                'message' => 'Payment gateway is not configured.',
                'code' => 'payment_unavailable',
            ], 503);
        }

        // TODO: Create Payment model record, call GCash/Maya API, return reference and checkout_url.
        return response()->json([
            'data' => [
                'reference' => '',
                'checkout_url' => '',
            ],
        ], 201);
    }

    public function status(Request $request, string $ref): JsonResponse
    {
        $ref = trim($ref);
        if ($ref === '') {
            return response()->json(['message' => 'Invalid reference.'], 422);
        }

        // TODO: When Payment model exists, look up by reference and return status; scope by auth user.
        Log::info('Payment status requested', ['reference' => $ref, 'user_id' => $request->user()?->id]);

        return response()->json(['message' => 'Payment record not found.'], 404);
    }
}
