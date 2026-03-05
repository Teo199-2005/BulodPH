<?php

declare(strict_types=1);

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Models\FraudRiskFlag;
use Illuminate\Http\Request;

final class FraudRiskController extends Controller
{
    public function index(Request $request)
    {
        $perPage = min((int) $request->input('per_page', 50), 100);
        $items = FraudRiskFlag::query()->latest()->limit($perPage)->get();
        return response()->json(['data' => $items]);
    }

    public function store(Request $request)
    {
        $payload = $request->validate([
            'user_id' => ['nullable', 'uuid'],
            'booking_reference' => ['nullable', 'string'],
            'reason' => ['required', 'string'],
            'severity' => ['nullable', 'string'],
            'status' => ['nullable', 'string'],
        ]);

        $flag = FraudRiskFlag::create([
            ...$payload,
            'severity' => $payload['severity'] ?? 'medium',
            'status' => $payload['status'] ?? 'open',
        ]);

        return response()->json(['data' => $flag], 201);
    }

    public function update(Request $request, FraudRiskFlag $fraud_risk_flag)
    {
        $payload = $request->validate([
            'status' => ['required', 'string', 'in:open,cleared,blocked'],
        ]);

        $fraud_risk_flag->update(['status' => $payload['status']]);

        return response()->json(['data' => $fraud_risk_flag]);
    }
}
