<?php

declare(strict_types=1);

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Models\AffiliateApplication;
use Illuminate\Http\Request;

final class AffiliateApplicationController extends Controller
{
    public function index()
    {
        return response()->json(['data' => AffiliateApplication::query()->latest()->get()]);
    }

    public function store(Request $request)
    {
        $payload = $request->validate([
            'name' => ['required', 'string'],
            'email' => ['required', 'email'],
            'company' => ['nullable', 'string'],
            'notes' => ['nullable', 'string'],
        ]);

        $application = AffiliateApplication::create([
            ...$payload,
            'status' => 'pending',
        ]);

        return response()->json(['data' => $application], 201);
    }

    public function update(Request $request, AffiliateApplication $application)
    {
        $payload = $request->validate([
            'status' => ['required', 'string'],
            'notes' => ['nullable', 'string'],
        ]);

        $application->update($payload);

        return response()->json(['data' => $application]);
    }
}
