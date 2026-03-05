<?php

declare(strict_types=1);

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Models\CancellationRequest;
use App\Models\Refund;
use Illuminate\Http\Request;

final class CancellationController extends Controller
{
    public function index(Request $request)
    {
        $query = CancellationRequest::query()->latest();
        if (! $request->user()?->hasRole('admin')) {
            $query->where('user_id', $request->user()?->id);
        }

        return response()->json(['data' => $query->with('refund')->get()]);
    }

    public function store(Request $request)
    {
        $payload = $request->validate([
            'booking_reference' => ['nullable', 'string'],
            'reason' => ['nullable', 'string'],
        ]);

        $requestModel = CancellationRequest::create([
            ...$payload,
            'user_id' => $request->user()?->id,
            'status' => 'requested',
        ]);

        return response()->json(['data' => $requestModel], 201);
    }

    public function show(CancellationRequest $cancellation)
    {
        return response()->json(['data' => $cancellation->load('refund')]);
    }

    public function createRefund(Request $request, CancellationRequest $cancellation)
    {
        $payload = $request->validate([
            'amount' => ['required', 'numeric', 'min:0'],
            'currency' => ['nullable', 'string'],
            'status' => ['nullable', 'string'],
            'reference' => ['nullable', 'string'],
        ]);

        $refund = Refund::create([
            'cancellation_request_id' => $cancellation->id,
            'amount' => $payload['amount'],
            'currency' => $payload['currency'] ?? 'PHP',
            'status' => $payload['status'] ?? 'pending',
            'reference' => $payload['reference'] ?? null,
        ]);

        return response()->json(['data' => $refund], 201);
    }
}
