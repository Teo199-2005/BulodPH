<?php

declare(strict_types=1);

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Models\Dispute;
use App\Models\DisputeEvidence;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Storage;

final class DisputeController extends Controller
{
    public function index(Request $request)
    {
        $userId = $request->user()?->id;

        $query = Dispute::query()->latest();
        if (! $request->user()?->hasRole('admin')) {
            $query->where(function ($builder) use ($userId) {
                $builder->where('opened_by_user_id', $userId)
                    ->orWhere('against_user_id', $userId);
            });
        }

        return response()->json(['data' => $query->get()]);
    }

    public function store(Request $request)
    {
        $payload = $request->validate([
            'booking_reference' => ['nullable', 'string'],
            'against_user_id' => ['nullable', 'uuid'],
            'reason' => ['required', 'string'],
            'description' => ['nullable', 'string'],
        ]);

        $dispute = Dispute::create([
            ...$payload,
            'opened_by_user_id' => $request->user()?->id,
            'status' => 'filed',
        ]);

        return response()->json(['data' => $dispute], 201);
    }

    public function show(Dispute $dispute)
    {
        return response()->json(['data' => $dispute->load('evidence')]);
    }

    public function addEvidence(Request $request, Dispute $dispute)
    {
        $payload = $request->validate([
            'file' => ['required', 'file', 'max:5120'],
        ]);

        $path = $payload['file']->store('disputes', 'public');

        $evidence = DisputeEvidence::create([
            'dispute_id' => $dispute->id,
            'uploaded_by_user_id' => $request->user()?->id,
            'file_path' => $path,
            'mime' => $payload['file']->getMimeType(),
            'size' => $payload['file']->getSize(),
        ]);

        return response()->json(['data' => $evidence], 201);
    }

    public function updateStatus(Request $request, Dispute $dispute)
    {
        $payload = $request->validate([
            'status' => ['required', 'string'],
        ]);

        $dispute->update(['status' => $payload['status']]);

        return response()->json(['data' => $dispute]);
    }
}
