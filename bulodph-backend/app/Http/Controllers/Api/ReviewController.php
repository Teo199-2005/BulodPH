<?php

declare(strict_types=1);

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Models\Review;
use Illuminate\Http\Request;

final class ReviewController extends Controller
{
    public function index(Request $request)
    {
        $query = Review::query()->latest();

        if ($request->filled('vehicle_reference')) {
            $query->where('vehicle_reference', $request->string('vehicle_reference'));
        }

        if ($request->filled('reviewee_id')) {
            $query->where('reviewee_id', $request->string('reviewee_id'));
        }

        return response()->json(['data' => $query->get()]);
    }

    public function store(Request $request)
    {
        $payload = $request->validate([
            'booking_reference' => ['nullable', 'string'],
            'reviewee_id' => ['nullable', 'uuid'],
            'vehicle_reference' => ['nullable', 'string'],
            'rating' => ['required', 'integer', 'min:1', 'max:5'],
            'comment' => ['nullable', 'string'],
        ]);

        $review = Review::create([
            ...$payload,
            'reviewer_id' => $request->user()?->id,
            'status' => 'pending',
        ]);

        return response()->json(['data' => $review], 201);
    }

    public function updateStatus(Request $request, Review $review)
    {
        $payload = $request->validate([
            'status' => ['required', 'string'],
        ]);

        $review->update(['status' => $payload['status']]);

        return response()->json(['data' => $review]);
    }
}
