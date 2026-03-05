<?php

declare(strict_types=1);

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Models\Favorite;
use Illuminate\Http\JsonResponse;
use Illuminate\Http\Request;

final class FavoriteController extends Controller
{
    /**
     * List the current user's favorite vehicle IDs.
     */
    public function index(Request $request): JsonResponse
    {
        $ids = Favorite::query()
            ->where('user_id', $request->user()->id)
            ->pluck('vehicle_id')
            ->values()
            ->all();

        return response()->json(['data' => $ids]);
    }

    /**
     * Add a vehicle to favorites.
     */
    public function store(Request $request): JsonResponse
    {
        $validated = $request->validate([
            'vehicle_id' => ['required', 'string', 'max:64'],
        ]);

        $userId = $request->user()->id;
        $vehicleId = $validated['vehicle_id'];

        Favorite::firstOrCreate(
            ['user_id' => $userId, 'vehicle_id' => $vehicleId],
            ['user_id' => $userId, 'vehicle_id' => $vehicleId]
        );

        $ids = Favorite::query()
            ->where('user_id', $userId)
            ->pluck('vehicle_id')
            ->values()
            ->all();

        return response()->json(['data' => $ids], 201);
    }

    /**
     * Remove a vehicle from favorites.
     */
    public function destroy(Request $request, string $vehicleId): JsonResponse
    {
        Favorite::query()
            ->where('user_id', $request->user()->id)
            ->where('vehicle_id', $vehicleId)
            ->delete();

        $ids = Favorite::query()
            ->where('user_id', $request->user()->id)
            ->pluck('vehicle_id')
            ->values()
            ->all();

        return response()->json(['data' => $ids]);
    }
}
