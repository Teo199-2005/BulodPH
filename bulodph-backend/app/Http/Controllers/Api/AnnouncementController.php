<?php

declare(strict_types=1);

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Models\Announcement;
use Illuminate\Http\JsonResponse;
use Illuminate\Http\Request;

final class AnnouncementController extends Controller
{
    /**
     * List announcements (admin: all; user: filtered by recipient_type).
     */
    public function index(Request $request): JsonResponse
    {
        $user = $request->user();
        $isAdmin = $user->hasRole('admin');

        if ($isAdmin) {
            $items = Announcement::query()
                ->with('creator:id,name,email')
                ->orderByDesc('created_at')
                ->limit(100)
                ->get();
        } else {
            $recipient = $this->recipientFromRole($user);
            $userId = $user->id;
            $items = Announcement::query()
                ->whereNotNull('sent_at')
                ->where(function ($q) use ($recipient, $userId) {
                    $q->where('recipient_type', 'all')
                        ->orWhere('recipient_type', $recipient)
                        ->orWhere(function ($q2) use ($userId) {
                            $q2->where('recipient_type', 'specific')
                                ->whereJsonContains('recipient_ids', $userId);
                        });
                })
                ->orderByDesc('sent_at')
                ->limit(50)
                ->get();
        }

        $data = $items->map(function (Announcement $a) use ($isAdmin) {
            $body = (string) ($a->body ?? '');
            $snippet = mb_strlen($body) > 80 ? mb_substr($body, 0, 80) . '…' : $body;
            $tag = match ($a->recipient_type) {
                'clients' => 'Renters only',
                'car_owners' => 'Car rental owners only',
                'marketing_staff' => 'Marketing staff only',
                'specific' => 'Specific people',
                default => 'Everyone',
            };
            $d = [
                'id' => $a->id,
                'subject' => $a->title,
                'snippet' => $snippet,
                'sent_at' => $a->sent_at?->toIso8601String(),
                'recipient_tag' => $tag,
                'title' => $a->title,
                'body' => $a->body,
                'recipient_type' => $a->recipient_type,
            ];
            if ($isAdmin) {
                $d['created_at'] = $a->created_at->toIso8601String();
                $d['created_by'] = $a->creator?->name ?? $a->creator?->email ?? null;
            }
            return $d;
        });

        return response()->json(['data' => $data->values()->all()]);
    }

    /**
     * Create a draft announcement (admin only). Use send to actually send it.
     */
    public function store(Request $request): JsonResponse
    {
        $validated = $request->validate([
            'title' => ['required', 'string', 'max:255'],
            'body' => ['nullable', 'string'],
            'recipient_type' => ['required', 'string', 'in:all,clients,car_owners,marketing_staff'],
        ]);

        $announcement = Announcement::create([
            'title' => $validated['title'],
            'body' => $validated['body'] ?? null,
            'recipient_type' => $validated['recipient_type'],
            'created_by' => $request->user()->id,
        ]);

        return response()->json([
            'data' => [
                'id' => $announcement->id,
                'title' => $announcement->title,
                'body' => $announcement->body,
                'recipient_type' => $announcement->recipient_type,
                'sent_at' => $announcement->sent_at?->toIso8601String(),
            ],
        ], 201);
    }

    /**
     * Create and send announcement in one request (admin only). Matches frontend POST /announcements/send.
     */
    public function send(Request $request): JsonResponse
    {
        $validated = $request->validate([
            'subject' => ['required', 'string', 'max:255'],
            'message' => ['required', 'string'],
            'send_to_dashboard' => ['sometimes', 'boolean'],
            'send_to_email' => ['sometimes', 'boolean'],
            'recipient_type' => ['required', 'string', 'in:all,clients_only,staff_only,specific'],
            'client_ids' => ['nullable', 'array'],
            'client_ids.*' => ['uuid'],
            'staff_ids' => ['nullable', 'array'],
            'staff_ids.*' => ['uuid'],
            'marketing_ids' => ['nullable', 'array'],
            'marketing_ids.*' => ['uuid'],
        ]);

        $recipientType = $this->mapRecipientType($validated['recipient_type']);
        $recipientIds = null;
        if (($validated['recipient_type'] ?? '') === 'specific') {
            $ids = array_merge(
                $validated['client_ids'] ?? [],
                $validated['staff_ids'] ?? [],
                $validated['marketing_ids'] ?? []
            );
            $recipientIds = array_values(array_unique($ids));
        }

        $announcement = Announcement::create([
            'title' => $validated['subject'],
            'body' => $validated['message'],
            'recipient_type' => $recipientType,
            'recipient_ids' => $recipientIds,
            'created_by' => $request->user()->id,
            'sent_at' => now(),
        ]);

        return response()->json([
            'data' => [
                'id' => $announcement->id,
                'title' => $announcement->title,
                'body' => $announcement->body,
                'recipient_type' => $announcement->recipient_type,
                'sent_at' => $announcement->sent_at->toIso8601String(),
            ],
        ], 201);
    }

    /**
     * Send an existing draft announcement (admin only).
     */
    public function sendDraft(string $id): JsonResponse
    {
        $announcement = Announcement::find($id);
        if (! $announcement) {
            return response()->json(['message' => 'Announcement not found.'], 404);
        }
        $announcement->update(['sent_at' => now()]);

        return response()->json([
            'data' => [
                'id' => $announcement->id,
                'title' => $announcement->title,
                'body' => $announcement->body,
                'recipient_type' => $announcement->recipient_type,
                'sent_at' => $announcement->sent_at->toIso8601String(),
            ],
        ]);
    }

    private function mapRecipientType(string $ft): string
    {
        return match ($ft) {
            'clients_only' => 'clients',
            'staff_only' => 'car_owners',
            'specific' => 'specific',
            default => 'all',
        };
    }

    private function recipientFromRole($user): string
    {
        if ($user->hasRole('client')) {
            return 'clients';
        }
        if ($user->hasRole('car_owner')) {
            return 'car_owners';
        }
        if ($user->hasRole('marketing_staff')) {
            return 'marketing_staff';
        }
        return 'all';
    }
}
