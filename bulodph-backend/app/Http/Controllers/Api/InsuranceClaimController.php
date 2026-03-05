<?php

declare(strict_types=1);

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Models\InsuranceClaim;
use Illuminate\Http\Request;

final class InsuranceClaimController extends Controller
{
    public function index(Request $request)
    {
        $query = InsuranceClaim::query()->latest();

        if (! $request->user()?->hasRole('admin')) {
            $query->where('user_id', $request->user()?->id);
        }

        return response()->json(['data' => $query->get()]);
    }

    public function store(Request $request)
    {
        $payload = $request->validate([
            'insurance_selection_id' => ['required', 'uuid'],
            'description' => ['nullable', 'string'],
            'claim_amount' => ['nullable', 'numeric', 'min:0'],
            'evidence' => ['nullable', 'file', 'max:5120'],
        ]);

        $path = isset($payload['evidence'])
            ? $payload['evidence']->store('insurance-claims', 'public')
            : null;

        $claim = InsuranceClaim::create([
            'insurance_selection_id' => $payload['insurance_selection_id'],
            'user_id' => $request->user()?->id,
            'description' => $payload['description'] ?? null,
            'claim_amount' => $payload['claim_amount'] ?? 0,
            'status' => 'submitted',
            'evidence_path' => $path,
        ]);

        return response()->json(['data' => $claim], 201);
    }

    public function updateStatus(Request $request, InsuranceClaim $claim)
    {
        $payload = $request->validate([
            'status' => ['required', 'string'],
        ]);

        $claim->update(['status' => $payload['status']]);

        return response()->json(['data' => $claim]);
    }
}
