<?php

declare(strict_types=1);

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Models\Payout;
use Illuminate\Http\JsonResponse;
use Illuminate\Http\Request;

final class PayoutController extends Controller
{
    /** Car owner or marketing: create a payout request. */
    public function store(Request $request): JsonResponse
    {
        $user = $request->user();
        if (! $user) {
            return response()->json(['message' => 'Unauthenticated.'], 401);
        }
        if (! $user->hasRole('car_owner') && ! $user->hasRole('marketing_staff')) {
            return response()->json(['message' => 'Only car owners and marketing staff can request payouts.'], 403);
        }

        $amount = (int) $request->input('amount', 0);
        if ($amount < 100) {
            return response()->json(['message' => 'Minimum payout amount is ₱100.'], 422);
        }

        $method = $request->input('method', 'GCash');
        $payeeName = $request->input('payeeName') ?? $user->name ?? $user->email;
        $type = $user->hasRole('marketing_staff') ? 'marketing' : 'car_owner';

        $payout = Payout::create([
            'user_id' => $user->id,
            'type' => $type,
            'payee_name' => $payeeName,
            'amount' => $amount,
            'method' => $method,
            'status' => 'pending',
            'requested_at' => now(),
        ]);

        return response()->json(['data' => $this->toItem($payout)], 201);
    }

    /** Pending payouts: admin sees all pending; car_owner/marketing see own. */
    public function pending(Request $request): JsonResponse
    {
        $user = $request->user();
        if (! $user) {
            return response()->json(['data' => []]);
        }

        $query = Payout::query()->where('status', 'pending')->orderByDesc('created_at');

        if (! $user->hasRole('admin')) {
            $query->where('user_id', $user->id);
        }

        $perPage = min((int) $request->input('per_page', 20), 100);
        $paginated = $query->paginate($perPage);
        $rows = $paginated->getCollection()->map(fn (Payout $p) => $this->toItem($p));

        return response()->json([
            'data' => $rows->values()->all(),
            'meta' => [
                'current_page' => $paginated->currentPage(),
                'last_page' => $paginated->lastPage(),
                'per_page' => $paginated->perPage(),
                'total' => $paginated->total(),
            ],
        ]);
    }

    /** History: admin sees all; car_owner/marketing see own. */
    public function history(Request $request): JsonResponse
    {
        $user = $request->user();
        if (! $user) {
            return response()->json(['data' => []]);
        }

        $query = Payout::query()->whereIn('status', ['paid', 'rejected'])->orderByDesc('updated_at');

        if (! $user->hasRole('admin')) {
            $query->where('user_id', $user->id);
        }

        $perPage = min((int) $request->input('per_page', 20), 100);
        $paginated = $query->paginate($perPage);
        $rows = $paginated->getCollection()->map(fn (Payout $p) => $this->toItem($p));

        return response()->json([
            'data' => $rows->values()->all(),
            'meta' => [
                'current_page' => $paginated->currentPage(),
                'last_page' => $paginated->lastPage(),
                'per_page' => $paginated->perPage(),
                'total' => $paginated->total(),
            ],
        ]);
    }

    /** Admin: approve payout (mark as paid). */
    public function approve(Request $request, string $id): JsonResponse
    {
        $payout = Payout::find($id);
        if (! $payout) {
            return response()->json(['message' => 'Payout not found.'], 404);
        }
        if ($payout->status !== 'pending') {
            return response()->json(['message' => 'Payout is not pending.'], 422);
        }

        $payout->update([
            'status' => 'paid',
            'paid_at' => $payout->paid_at ?? now(),
        ]);

        return response()->json(['data' => $this->toItem($payout->fresh())]);
    }

    /** Admin: reject payout. */
    public function reject(Request $request, string $id): JsonResponse
    {
        $reason = $request->input('reason', '');
        $payout = Payout::find($id);
        if (! $payout) {
            return response()->json(['message' => 'Payout not found.'], 404);
        }
        if ($payout->status !== 'pending') {
            return response()->json(['message' => 'Payout is not pending.'], 422);
        }

        $payout->update([
            'status' => 'rejected',
            'rejected_at' => now(),
            'reject_reason' => $reason,
        ]);

        return response()->json(['data' => $this->toItem($payout->fresh())]);
    }

    private function toItem(Payout $p): array
    {
        return [
            'id' => $p->id,
            'type' => $p->type === 'marketing' ? 'marketing' : 'car_owner',
            'payeeName' => $p->payee_name,
            'amount' => (int) $p->amount,
            'method' => $p->method,
            'status' => $p->status,
            'requestedAt' => $p->requested_at?->toIso8601String() ?? $p->created_at->toIso8601String(),
            'paidAt' => $p->paid_at?->toIso8601String(),
        ];
    }
}
