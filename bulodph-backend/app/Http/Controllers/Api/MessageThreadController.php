<?php

declare(strict_types=1);

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Models\MessageThread;
use Illuminate\Http\Request;

final class MessageThreadController extends Controller
{
    public function index(Request $request)
    {
        $userId = $request->user()?->id;

        return response()->json([
            'data' => MessageThread::query()
                ->where('client_id', $userId)
                ->orWhere('owner_id', $userId)
                ->latest()
                ->get(),
        ]);
    }

    public function store(Request $request)
    {
        $payload = $request->validate([
            'booking_reference' => ['nullable', 'string'],
            'client_id' => ['required', 'uuid'],
            'owner_id' => ['required', 'uuid'],
        ]);

        $thread = MessageThread::create([
            ...$payload,
            'status' => 'open',
        ]);

        return response()->json(['data' => $thread], 201);
    }

    public function show(MessageThread $thread)
    {
        return response()->json(['data' => $thread->load('messages')]);
    }
}
