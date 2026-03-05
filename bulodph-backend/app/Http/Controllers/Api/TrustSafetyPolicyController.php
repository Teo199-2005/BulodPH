<?php

declare(strict_types=1);

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Models\TrustSafetyPolicy;
use Illuminate\Http\Request;

final class TrustSafetyPolicyController extends Controller
{
    public function index()
    {
        return response()->json([
            'data' => TrustSafetyPolicy::query()
                ->where('is_published', true)
                ->orderBy('title')
                ->get(),
        ]);
    }

    public function store(Request $request)
    {
        $payload = $request->validate([
            'slug' => ['required', 'string'],
            'title' => ['required', 'string'],
            'content' => ['required', 'string'],
            'is_published' => ['boolean'],
        ]);

        $policy = TrustSafetyPolicy::create([
            ...$payload,
            'created_by' => $request->user()?->id,
        ]);

        return response()->json(['data' => $policy], 201);
    }

    public function update(Request $request, TrustSafetyPolicy $policy)
    {
        $payload = $request->validate([
            'slug' => ['sometimes', 'string'],
            'title' => ['sometimes', 'string'],
            'content' => ['sometimes', 'string'],
            'is_published' => ['sometimes', 'boolean'],
        ]);

        $policy->update($payload);

        return response()->json(['data' => $policy]);
    }

    public function destroy(TrustSafetyPolicy $policy)
    {
        $policy->delete();

        return response()->json(['message' => 'Deleted']);
    }
}
