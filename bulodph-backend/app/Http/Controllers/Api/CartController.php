<?php

declare(strict_types=1);

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Models\CartItem;
use Illuminate\Http\JsonResponse;
use Illuminate\Http\Request;

final class CartController extends Controller
{
    /**
     * List the current user's cart items.
     */
    public function index(Request $request): JsonResponse
    {
        $items = CartItem::query()
            ->where('user_id', $request->user()->id)
            ->orderBy('created_at')
            ->get();

        $data = $items->map(function (CartItem $c) {
            return [
                'id' => $c->id,
                'vehicle_id' => $c->vehicle_id,
                'vehicle_name' => $c->vehicle_name,
                'vehicle_image' => $c->vehicle_image,
                'location' => null,
                'start_date' => $c->start_date->format('Y-m-d'),
                'end_date' => $c->end_date->format('Y-m-d'),
                'price_per_day' => (int) $c->price_per_day,
                'quantity_days' => (int) $c->quantity_days,
                'meet_up' => $c->meet_up,
            ];
        });

        return response()->json(['data' => $data->values()->all()]);
    }

    /**
     * Add item to cart.
     */
    public function store(Request $request): JsonResponse
    {
        $validated = $request->validate([
            'vehicle_id' => ['required', 'string', 'max:64'],
            'vehicle_name' => ['nullable', 'string', 'max:255'],
            'vehicle_image' => ['nullable', 'string', 'max:500'],
            'start_date' => ['required', 'date'],
            'end_date' => ['required', 'date', 'after_or_equal:start_date'],
            'price_per_day' => ['required', 'integer', 'min:0'],
            'meet_up' => ['nullable', 'string', 'max:255'],
        ]);

        $start = $validated['start_date'];
        $end = $validated['end_date'];
        $days = (int) (strtotime($end) - strtotime($start)) / 86400 + 1;
        $days = max(1, $days);

        $userId = $request->user()->id;

        $item = CartItem::create([
            'user_id' => $userId,
            'vehicle_id' => $validated['vehicle_id'],
            'vehicle_name' => $validated['vehicle_name'] ?? null,
            'vehicle_image' => $validated['vehicle_image'] ?? null,
            'start_date' => $start,
            'end_date' => $end,
            'price_per_day' => (int) $validated['price_per_day'],
            'quantity_days' => $days,
            'meet_up' => $validated['meet_up'] ?? null,
        ]);

        return response()->json([
            'data' => [
                'id' => $item->id,
                'vehicle_id' => $item->vehicle_id,
                'vehicle_name' => $item->vehicle_name,
                'vehicle_image' => $item->vehicle_image,
                'location' => null,
                'start_date' => $item->start_date->format('Y-m-d'),
                'end_date' => $item->end_date->format('Y-m-d'),
                'price_per_day' => (int) $item->price_per_day,
                'quantity_days' => $item->quantity_days,
                'meet_up' => $item->meet_up,
            ],
        ], 201);
    }

    /**
     * Update cart item dates.
     */
    public function update(Request $request, string $id): JsonResponse
    {
        if (\strlen($id) > 64) {
            return response()->json(['message' => 'Cart item not found.'], 404);
        }
        $item = CartItem::query()
            ->where('user_id', $request->user()->id)
            ->find($id);

        if (! $item) {
            return response()->json(['message' => 'Cart item not found.'], 404);
        }

        $validated = $request->validate([
            'start_date' => ['sometimes', 'date'],
            'end_date' => ['sometimes', 'date'],
            'price_per_day' => ['sometimes', 'integer', 'min:0'],
        ]);

        if (isset($validated['start_date'])) {
            $item->start_date = $validated['start_date'];
        }
        if (isset($validated['end_date'])) {
            $item->end_date = $validated['end_date'];
        }
        if (isset($validated['price_per_day'])) {
            $item->price_per_day = $validated['price_per_day'];
        }

        $days = (int) $item->start_date->diffInDays($item->end_date) + 1;
        $item->quantity_days = max(1, $days);
        $item->save();

        return response()->json([
            'data' => [
                'id' => $item->id,
                'vehicle_id' => $item->vehicle_id,
                'vehicle_name' => $item->vehicle_name,
                'vehicle_image' => $item->vehicle_image,
                'location' => null,
                'start_date' => $item->start_date->format('Y-m-d'),
                'end_date' => $item->end_date->format('Y-m-d'),
                'price_per_day' => (int) $item->price_per_day,
                'quantity_days' => $item->quantity_days,
                'meet_up' => $item->meet_up,
            ],
        ]);
    }

    /**
     * Remove cart item.
     */
    public function destroy(Request $request, string $id): JsonResponse
    {
        if (\strlen($id) > 64) {
            return response()->json(['message' => 'Cart item not found.'], 404);
        }
        $deleted = CartItem::query()
            ->where('user_id', $request->user()->id)
            ->where('id', $id)
            ->delete();

        if ($deleted === 0) {
            return response()->json(['message' => 'Cart item not found.'], 404);
        }

        return response()->json(['message' => 'Deleted']);
    }
}
