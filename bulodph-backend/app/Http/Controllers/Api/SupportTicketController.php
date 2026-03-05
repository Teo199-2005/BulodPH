<?php

declare(strict_types=1);

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Models\SupportTicket;
use Illuminate\Http\JsonResponse;
use Illuminate\Http\Request;

final class SupportTicketController extends Controller
{
    /**
     * List the authenticated user's support tickets.
     */
    public function index(Request $request): JsonResponse
    {
        $tickets = SupportTicket::query()
            ->where('user_id', $request->user()->id)
            ->orderByDesc('created_at')
            ->limit(50)
            ->get();

        return response()->json(['data' => $tickets]);
    }

    /**
     * Create a new support ticket.
     */
    public function store(Request $request): JsonResponse
    {
        $payload = $request->validate([
            'subject' => ['nullable', 'string', 'max:500'],
            'message' => ['required', 'string', 'max:10000'],
        ]);

        $ticket = SupportTicket::create([
            'user_id' => $request->user()->id,
            'subject' => $payload['subject'] ?? null,
            'message' => $payload['message'],
            'status' => 'open',
        ]);

        return response()->json(['data' => $ticket], 201);
    }
}
