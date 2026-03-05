<?php

declare(strict_types=1);

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Models\RewardPoint;
use Illuminate\Http\Request;

final class RewardPointController extends Controller
{
    public function index(Request $request)
    {
        $query = RewardPoint::query()->latest();

        if (! $request->user()?->hasRole('admin')) {
            $query->where('user_id', $request->user()?->id);
        }

        return response()->json(['data' => $query->get()]);
    }

    public function store(Request $request)
    {
        $payload = $request->validate([
            'user_id' => ['required', 'uuid'],
            'points_delta' => ['required', 'integer'],
            'balance_after' => ['required', 'integer'],
            'reason' => ['nullable', 'string'],
        ]);

        $entry = RewardPoint::create($payload);

        return response()->json(['data' => $entry], 201);
    }
}
