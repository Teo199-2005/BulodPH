<?php

declare(strict_types=1);

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Models\KycSubmission;
use Illuminate\Http\Request;

final class KycController extends Controller
{
    public function submit(Request $request)
    {
        $payload = $request->validate([
            'id_type' => ['required', 'string'],
            'id_number' => ['nullable', 'string'],
            'id_front' => ['nullable', 'file', 'max:5120'],
            'id_back' => ['nullable', 'file', 'max:5120'],
            'license' => ['nullable', 'file', 'max:5120'],
            'selfie' => ['nullable', 'file', 'max:5120'],
        ]);

        $submission = KycSubmission::create([
            'user_id' => $request->user()?->id,
            'status' => 'pending',
            'id_type' => $payload['id_type'],
            'id_number' => $payload['id_number'] ?? null,
            'id_front_path' => isset($payload['id_front']) ? $payload['id_front']->store('kyc', 'public') : null,
            'id_back_path' => isset($payload['id_back']) ? $payload['id_back']->store('kyc', 'public') : null,
            'license_path' => isset($payload['license']) ? $payload['license']->store('kyc', 'public') : null,
            'selfie_path' => isset($payload['selfie']) ? $payload['selfie']->store('kyc', 'public') : null,
        ]);

        return response()->json(['data' => $submission], 201);
    }

    public function status(Request $request)
    {
        $submission = KycSubmission::query()
            ->where('user_id', $request->user()?->id)
            ->latest()
            ->first();

        return response()->json(['data' => $submission]);
    }

    public function list()
    {
        return response()->json(['data' => KycSubmission::query()->latest()->get()]);
    }

    public function review(Request $request, KycSubmission $submission)
    {
        $payload = $request->validate([
            'status' => ['required', 'string'],
            'rejection_reason' => ['nullable', 'string'],
        ]);

        $submission->update([
            'status' => $payload['status'],
            'rejection_reason' => $payload['rejection_reason'] ?? null,
            'reviewed_by_user_id' => $request->user()?->id,
            'reviewed_at' => now(),
        ]);

        return response()->json(['data' => $submission]);
    }
}
