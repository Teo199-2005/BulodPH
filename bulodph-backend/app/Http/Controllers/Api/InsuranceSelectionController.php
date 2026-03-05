<?php

declare(strict_types=1);

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Models\InsuranceSelection;
use Illuminate\Http\Request;

final class InsuranceSelectionController extends Controller
{
    public function index(Request $request)
    {
        $query = InsuranceSelection::query()->latest();

        if (! $request->user()?->hasRole('admin')) {
            $query->where('user_id', $request->user()?->id);
        }

        return response()->json(['data' => $query->get()]);
    }

    public function store(Request $request)
    {
        $payload = $request->validate([
            'booking_reference' => ['nullable', 'string'],
            'insurance_plan_id' => ['required', 'uuid'],
        ]);

        $selection = InsuranceSelection::create([
            ...$payload,
            'user_id' => $request->user()?->id,
            'status' => 'selected',
        ]);

        return response()->json(['data' => $selection], 201);
    }
}
