<?php

declare(strict_types=1);

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Models\InsurancePlan;
use Illuminate\Http\Request;

final class InsurancePlanController extends Controller
{
    public function index()
    {
        return response()->json(['data' => InsurancePlan::query()->where('is_active', true)->get()]);
    }

    public function store(Request $request)
    {
        $payload = $request->validate([
            'name' => ['required', 'string'],
            'description' => ['nullable', 'string'],
            'price' => ['required', 'numeric', 'min:0'],
            'currency' => ['nullable', 'string'],
            'coverage_details' => ['nullable', 'string'],
            'is_active' => ['boolean'],
        ]);

        $plan = InsurancePlan::create([
            ...$payload,
            'currency' => $payload['currency'] ?? 'PHP',
        ]);

        return response()->json(['data' => $plan], 201);
    }

    public function update(Request $request, InsurancePlan $plan)
    {
        $payload = $request->validate([
            'name' => ['sometimes', 'string'],
            'description' => ['sometimes', 'string'],
            'price' => ['sometimes', 'numeric', 'min:0'],
            'currency' => ['sometimes', 'string'],
            'coverage_details' => ['sometimes', 'string'],
            'is_active' => ['sometimes', 'boolean'],
        ]);

        $plan->update($payload);

        return response()->json(['data' => $plan]);
    }
}
