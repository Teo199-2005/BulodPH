<?php

declare(strict_types=1);

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Models\Refund;
use Illuminate\Http\Request;

final class RefundController extends Controller
{
    public function index(Request $request)
    {
        $query = Refund::query()->latest();

        if (! $request->user()?->hasRole('admin')) {
            $query->whereHas('cancellationRequest', function ($builder) use ($request) {
                $builder->where('user_id', $request->user()?->id);
            });
        }

        return response()->json(['data' => $query->get()]);
    }

    public function show(Refund $refund)
    {
        return response()->json(['data' => $refund]);
    }
}
