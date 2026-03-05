<?php

declare(strict_types=1);

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Models\Message;
use App\Models\MessageThread;
use Illuminate\Http\Request;

final class MessageController extends Controller
{
    public function store(Request $request, MessageThread $thread)
    {
        $payload = $request->validate([
            'body' => ['nullable', 'string'],
            'attachment' => ['nullable', 'file', 'max:5120'],
        ]);

        $path = isset($payload['attachment'])
            ? $payload['attachment']->store('messages', 'public')
            : null;

        $message = Message::create([
            'thread_id' => $thread->id,
            'sender_id' => $request->user()?->id,
            'body' => $payload['body'] ?? null,
            'attachment_path' => $path,
            'attachment_mime' => $payload['attachment']?->getMimeType(),
            'attachment_size' => $payload['attachment']?->getSize(),
        ]);

        return response()->json(['data' => $message], 201);
    }
}
