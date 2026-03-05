<?php

declare(strict_types=1);

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Models\Client;
use App\Models\NDISPlan;
use Illuminate\Http\JsonResponse;
use Illuminate\Http\Request;

final class NDISPlanController extends Controller
{
    public function index(Request $request): JsonResponse
    {
        $plans = NDISPlan::query()
            ->with(['client', 'budgetCategories.planLineItems.supportItem'])
            ->when($request->input('client_id'), fn($q, $clientId) => $q->where('client_id', $clientId))
            ->when($request->input('is_active'), fn($q, $isActive) => $q->where('is_active', $isActive))
            ->orderBy('start_date', 'desc')
            ->paginate(20);

        return response()->json($plans);
    }

    public function store(Request $request): JsonResponse
    {
        $validated = $request->validate([
            'client_id' => 'required|uuid|exists:clients,id',
            'plan_number' => 'required|string|max:50|unique:ndis_plans,plan_number',
            'start_date' => 'required|date',
            'end_date' => 'required|date|after:start_date',
            'plan_management_type' => 'required|string|in:SELF_MANAGED,PLAN_MANAGED,NDIA_MANAGED',
        ]);

        // Verify client belongs to user's organization
        $client = Client::findOrFail($validated['client_id']);
        $this->authorize('view', $client);

        $validated['is_active'] = true;

        $plan = NDISPlan::create($validated);

        return response()->json($plan->load('client'), 201);
    }

    public function show(NDISPlan $plan): JsonResponse
    {
        $this->authorize('view', $plan);

        return response()->json(
            $plan->load(['client', 'budgetCategories.planLineItems.supportItem'])
        );
    }

    public function update(Request $request, NDISPlan $plan): JsonResponse
    {
        $this->authorize('update', $plan);

        $validated = $request->validate([
            'end_date' => 'sometimes|date|after:start_date',
            'plan_management_type' => 'sometimes|string|in:SELF_MANAGED,PLAN_MANAGED,NDIA_MANAGED',
            'is_active' => 'sometimes|boolean',
        ]);

        $plan->update($validated);

        return response()->json($plan);
    }

    public function destroy(NDISPlan $plan): JsonResponse
    {
        $this->authorize('delete', $plan);

        // Prevent deletion of active plans
        if ($plan->is_active) {
            return response()->json([
                'message' => 'Cannot delete an active NDIS plan. Please deactivate it first.',
            ], 422);
        }

        $plan->delete();

        return response()->json(null, 204);
    }

    public function budgetSummary(NDISPlan $plan): JsonResponse
    {
        $this->authorize('view', $plan);

        $summary = $plan->budgetCategories->map(function ($category) {
            return [
                'category_type' => $category->category_type,
                'total_budget_cents' => $category->total_budget_cents,
                'spent_cents' => $category->spent_cents,
                'committed_cents' => $category->committed_cents,
                'remaining_cents' => $category->remaining_budget_cents,
                'utilization_percentage' => $category->total_budget_cents > 0
                    ? round((($category->spent_cents + $category->committed_cents) / $category->total_budget_cents) * 100, 2)
                    : 0,
            ];
        });

        return response()->json([
            'plan_id' => $plan->id,
            'plan_number' => $plan->plan_number,
            'categories' => $summary,
        ]);
    }
}

