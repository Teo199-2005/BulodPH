<?php

declare(strict_types=1);

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Models\RewardTier;
use Illuminate\Http\Request;

final class RewardTierController extends Controller
{
    public function index()
    {
        return response()->json(['data' => RewardTier::query()->orderBy('min_points')->get()]);
    }

    public function store(Request $request)
    {
        $payload = $request->validate([
            'name' => ['required', 'string'],
            'min_points' => ['required', 'integer', 'min:0'],
            'benefits' => ['nullable', 'string'],
        ]);

        $tier = RewardTier::create($payload);

        return response()->json(['data' => $tier], 201);
    }
}
