<?php

declare(strict_types=1);

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Models\CityPage;
use Illuminate\Http\Request;

final class CityPageController extends Controller
{
    public function index()
    {
        return response()->json([
            'data' => CityPage::query()
                ->where('status', 'published')
                ->orderBy('city')
                ->get(),
        ]);
    }

    public function show(CityPage $cityPage)
    {
        return response()->json(['data' => $cityPage]);
    }

    public function store(Request $request)
    {
        $payload = $request->validate([
            'slug' => ['required', 'string'],
            'city' => ['required', 'string'],
            'content' => ['required', 'string'],
            'status' => ['nullable', 'string'],
            'published_at' => ['nullable', 'date'],
        ]);

        $page = CityPage::create($payload);

        return response()->json(['data' => $page], 201);
    }

    public function update(Request $request, CityPage $cityPage)
    {
        $payload = $request->validate([
            'city' => ['sometimes', 'string'],
            'content' => ['sometimes', 'string'],
            'status' => ['sometimes', 'string'],
            'published_at' => ['nullable', 'date'],
        ]);

        $cityPage->update($payload);

        return response()->json(['data' => $cityPage]);
    }
}
