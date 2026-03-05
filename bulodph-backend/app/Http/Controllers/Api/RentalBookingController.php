<?php

declare(strict_types=1);

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Models\RentalBooking;
use App\Models\User;
use App\Models\Vehicle;
use Carbon\Carbon;
use Illuminate\Http\JsonResponse;
use Illuminate\Http\Request;
use Illuminate\Support\Str;

final class RentalBookingController extends Controller
{
    /**
     * Admin: bookings for a specific client (by client user id). Client must be in admin's org.
     */
    public function clientBookingsForAdmin(string $clientId): JsonResponse
    {
        $admin = auth()->user();
        $teamId = $admin->organization_id;

        $client = User::query()
            ->where('organization_id', $teamId)
            ->whereHas('roles', fn ($q) => $q->where('name', 'client'))
            ->find($clientId);

        if (! $client) {
            return response()->json(['message' => 'Client not found.'], 404);
        }

        $bookings = RentalBooking::query()
            ->where('client_user_id', $clientId)
            ->where('archived', false)
            ->orderByDesc('created_at')
            ->limit(100)
            ->get();

        $rows = $bookings->map(fn (RentalBooking $b) => $this->toRecord($b));

        return response()->json(['data' => $rows->values()->all()]);
    }

    public function index(Request $request): JsonResponse
    {
        $query = RentalBooking::query()->orderByDesc('created_at');

        if ($request->has('archived')) {
            $query->where('archived', (bool) $request->boolean('archived'));
        } else {
            $query->where('archived', false);
        }

        $perPage = min((int) $request->input('per_page', 20), 100);
        $paginated = $query->paginate($perPage);

        $rows = $paginated->getCollection()->map(fn (RentalBooking $b) => $this->toRecord($b));

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

    public function show(string $id): JsonResponse
    {
        if (\strlen($id) > 64) {
            return response()->json(['message' => 'Booking not found.'], 404);
        }
        $booking = RentalBooking::find($id);

        if (! $booking) {
            return response()->json(['message' => 'Booking not found.'], 404);
        }

        return response()->json(['data' => $this->toRecord($booking)]);
    }

    public function store(Request $request): JsonResponse
    {
        $valid = $request->validate([
            'vehicle_id' => ['required', 'string', 'max:64'],
            'vehicle_name' => ['required', 'string', 'max:255'],
            'business_name' => ['required', 'string', 'max:255'],
            'client_name' => ['required', 'string', 'max:255'],
            'client_email' => ['required', 'email'],
            'start_date' => ['required', 'date'],
            'end_date' => ['required', 'date', 'after_or_equal:start_date'],
            'amount' => ['required', 'integer', 'min:0'],
            'transaction_id' => ['nullable', 'string', 'max:64'],
        ]);

        $vehicle = Vehicle::find($valid['vehicle_id']);
        if ($vehicle && $vehicle->min_rental_period_hours !== null) {
            $start = Carbon::parse($valid['start_date'])->startOfDay();
            $end = Carbon::parse($valid['end_date'])->startOfDay();
            $days = $start->diffInDays($end) + 1;
            $durationHours = $days * 24;
            if ($durationHours < (int) $vehicle->min_rental_period_hours) {
                return response()->json([
                    'message' => 'Minimum rental for this vehicle is ' . $vehicle->min_rental_period_hours . ' hours.',
                ], 422);
            }
        }

        $id = (string) Str::ulid();
        $transactionId = $valid['transaction_id'] ?? 'T' . substr($id, -8);

        $booking = RentalBooking::create([
            'id' => $id,
            'transaction_id' => $transactionId,
            'client_user_id' => $request->user()?->id,
            'vehicle_id' => $valid['vehicle_id'],
            'vehicle_name' => $valid['vehicle_name'],
            'business_name' => $valid['business_name'],
            'client_name' => $valid['client_name'],
            'client_email' => $valid['client_email'],
            'start_date' => $valid['start_date'],
            'end_date' => $valid['end_date'],
            'amount' => (int) $valid['amount'],
            'status' => 'Pending',
        ]);

        return response()->json(['data' => $this->toRecord($booking)], 201);
    }

    public function updateStatus(Request $request, string $id): JsonResponse
    {
        if (\strlen($id) > 64) {
            return response()->json(['message' => 'Booking not found.'], 404);
        }
        $valid = $request->validate([
            'status' => ['required', 'string', 'in:' . implode(',', RentalBooking::validStatuses())],
        ]);

        $booking = RentalBooking::find($id);

        if (! $booking) {
            return response()->json(['message' => 'Booking not found.'], 404);
        }

        $updates = ['status' => $valid['status']];
        if ($valid['status'] === 'Active' && $booking->paid_at === null) {
            $updates['paid_at'] = now();
        }
        $booking->update($updates);

        return response()->json(['data' => $this->toRecord($booking)]);
    }

    public function archive(Request $request, string $id): JsonResponse
    {
        if (\strlen($id) > 64) {
            return response()->json(['message' => 'Booking not found.'], 404);
        }
        $valid = $request->validate([
            'archived' => ['required', 'boolean'],
        ]);

        $booking = RentalBooking::find($id);

        if (! $booking) {
            return response()->json(['message' => 'Booking not found.'], 404);
        }

        $booking->update(['archived' => $valid['archived']]);

        return response()->json(['data' => $this->toRecord($booking)]);
    }

    /**
     * Client cancels their own booking (Pending or Approved only).
     */
    public function clientCancel(Request $request, string $id): JsonResponse
    {
        if (\strlen($id) > 64) {
            return response()->json(['message' => 'Booking not found.'], 404);
        }
        $user = $request->user();

        if (! $user) {
            return response()->json(['message' => 'Unauthorized.'], 401);
        }

        $booking = RentalBooking::where('id', $id)
            ->where('client_user_id', $user->id)
            ->first();

        if (! $booking) {
            return response()->json(['message' => 'Booking not found.'], 404);
        }

        if (! in_array($booking->status, ['Pending', 'Approved', 'Active'], true)) {
            return response()->json(['message' => 'This booking can no longer be cancelled.'], 422);
        }

        $previousStatus = $booking->status;
        $booking->update([
            'status' => 'Pending cancellation',
            'previous_status' => $previousStatus,
        ]);

        return response()->json(['data' => $this->toRecord($booking->fresh())]);
    }

    /**
     * Admin: approve a client's cancellation request. Sets status to Cancelled.
     */
    public function adminApproveCancellation(Request $request, string $id): JsonResponse
    {
        if (\strlen($id) > 64) {
            return response()->json(['message' => 'Booking not found.'], 404);
        }

        $booking = RentalBooking::find($id);
        if (! $booking) {
            return response()->json(['message' => 'Booking not found.'], 404);
        }
        if ($booking->status !== 'Pending cancellation') {
            return response()->json(['message' => 'This booking does not have a pending cancellation request.'], 422);
        }

        $booking->update(['status' => 'Cancelled', 'previous_status' => null]);

        return response()->json(['data' => $this->toRecord($booking->fresh())]);
    }

    /**
     * Admin: reject a client's cancellation request. Restores previous status.
     */
    public function adminRejectCancellation(Request $request, string $id): JsonResponse
    {
        if (\strlen($id) > 64) {
            return response()->json(['message' => 'Booking not found.'], 404);
        }

        $booking = RentalBooking::find($id);
        if (! $booking) {
            return response()->json(['message' => 'Booking not found.'], 404);
        }
        if ($booking->status !== 'Pending cancellation') {
            return response()->json(['message' => 'This booking does not have a pending cancellation request.'], 422);
        }

        $restoreStatus = $booking->previous_status ?? 'Pending';
        $booking->update(['status' => $restoreStatus, 'previous_status' => null]);

        return response()->json(['data' => $this->toRecord($booking->fresh())]);
    }

    /**
     * Car owner: bookings not yet seen (for login popup). Approved/Active/Completed with car_owner_seen_at = null.
     */
    public function carOwnerUnseen(Request $request): JsonResponse
    {
        $user = $request->user();

        if (! $user) {
            return response()->json(['data' => []]);
        }

        $bookings = RentalBooking::with('vehicle')
            ->whereHas('vehicle', fn ($q) => $q->where('user_id', $user->id))
            ->whereNull('car_owner_seen_at')
            ->whereIn('status', ['Approved', 'Active', 'Completed'])
            ->where('archived', false)
            ->orderByDesc('created_at')
            ->limit(20)
            ->get();

        $rows = $bookings->map(function (RentalBooking $b): array {
            $vehicle = $b->vehicle;

            return [
                'id' => $b->id,
                'vehicleId' => $b->vehicle_id ?? ($vehicle?->id ?? null),
                'vehicleName' => $b->vehicle_name ?? ($vehicle?->name ?? 'Vehicle'),
                'vehicleImage' => $vehicle?->image ?? '',
                'renterName' => $b->client_name,
                'renterPhone' => null,
                'start' => $b->start_date?->format('M j, Y') ?? (string) $b->start_date,
                'end' => $b->end_date?->format('M j, Y') ?? (string) $b->end_date,
                'status' => $this->mapCarOwnerStatus($b),
                'earnings' => (int) $b->amount,
                'paidAt' => $b->paid_at?->toIso8601String(),
            ];
        });

        return response()->json(['data' => $rows->values()->all()]);
    }

    /**
     * Car owner: mark one or more bookings as seen (dismiss popup).
     */
    public function carOwnerMarkSeen(Request $request): JsonResponse
    {
        $user = $request->user();

        if (! $user) {
            return response()->json(['message' => 'Unauthorized.'], 401);
        }

        $validated = $request->validate([
            'ids' => ['required', 'array'],
            'ids.*' => ['string', 'max:64'],
        ]);

        $updated = RentalBooking::query()
            ->whereIn('id', $validated['ids'])
            ->whereHas('vehicle', fn ($q) => $q->where('user_id', $user->id))
            ->update(['car_owner_seen_at' => now()]);

        return response()->json(['data' => ['marked' => $updated]]);
    }

    /**
     * Car owner-specific bookings (their fleet).
     */
    public function carOwnerIndex(Request $request): JsonResponse
    {
        $user = $request->user();

        if (! $user) {
            return response()->json(['data' => []]);
        }

        $perPage = min((int) $request->input('per_page', 50), 100);
        $bookings = RentalBooking::with('vehicle')
            ->whereHas('vehicle', fn ($q) => $q->where('user_id', $user->id))
            ->where('archived', false)
            ->orderByDesc('created_at')
            ->limit($perPage)
            ->get();

        $rows = $bookings->map(function (RentalBooking $b): array {
            $vehicle = $b->vehicle;

            return [
                'id' => $b->id,
                'vehicleId' => $b->vehicle_id ?? ($vehicle?->id ?? null),
                'vehicleName' => $b->vehicle_name ?? ($vehicle?->name ?? 'Vehicle'),
                'vehicleImage' => $vehicle?->image ?? '',
                'renterName' => $b->client_name,
                'renterPhone' => null,
                'start' => $b->start_date?->format('M j, Y') ?? (string) $b->start_date,
                'end' => $b->end_date?->format('M j, Y') ?? (string) $b->end_date,
                'meetUp' => null,
                'status' => $this->mapCarOwnerStatus($b),
                'earnings' => (int) $b->amount,
                'paidAt' => $b->paid_at?->toIso8601String(),
            ];
        });

        return response()->json(['data' => $rows->values()->all()]);
    }

    /**
     * Update booking status from car owner actions (accept/decline/hand-over/return).
     */
    public function carOwnerUpdateStatus(Request $request, string $id): JsonResponse
    {
        if (\strlen($id) > 64) {
            return response()->json(['message' => 'Booking not found.'], 404);
        }
        $user = $request->user();

        if (! $user) {
            return response()->json(['message' => 'Unauthorized.'], 401);
        }

        $validated = $request->validate([
            'status' => ['required', 'string'],
        ]);

        $booking = RentalBooking::with('vehicle')
            ->where('id', $id)
            ->whereHas('vehicle', fn ($q) => $q->where('user_id', $user->id))
            ->first();

        if (! $booking) {
            return response()->json(['message' => 'Booking not found.'], 404);
        }

        $backendStatus = $this->mapCarOwnerStatusToBackend($validated['status']);

        if (! in_array($backendStatus, RentalBooking::validStatuses(), true)) {
            return response()->json(['message' => 'Invalid status.'], 422);
        }

        $booking->update(['status' => $backendStatus]);

        return response()->json(['data' => $this->toRecord($booking)]);
    }

    /**
     * Client-specific bookings (My bookings view).
     */
    public function clientIndex(Request $request): JsonResponse
    {
        $user = $request->user();

        if (! $user) {
            return response()->json(['data' => []]);
        }

        $perPage = min((int) $request->input('per_page', 50), 100);
        $bookings = RentalBooking::with('vehicle')
            ->where('client_user_id', $user->id)
            ->where('archived', false)
            ->orderByDesc('created_at')
            ->limit($perPage)
            ->get();

        $rows = $bookings->map(function (RentalBooking $b): array {
            $vehicle = $b->vehicle;
            $ownerId = $vehicle?->user_id ?? null;
            $image = $vehicle?->image;
            $vehicleImage = is_string($image) && trim($image) !== ''
                ? trim($image)
                : 'https://images.unsplash.com/photo-1544636331-e26879cd4d9b?w=800&q=80&fit=crop';

            return [
                'id' => $b->id,
                'vehicleName' => $b->vehicle_name ?? ($vehicle?->name ?? 'Vehicle'),
                'vehicleImage' => $vehicleImage,
                'vehicleId' => $b->vehicle_id,
                'location' => $vehicle?->location ?? '',
                'start' => $b->start_date?->format('M j, Y') ?? (string) $b->start_date,
                'end' => $b->end_date?->format('M j, Y') ?? (string) $b->end_date,
                'total' => (int) $b->amount,
                'status' => $this->mapClientStatus($b),
                'paidAt' => $b->paid_at?->toIso8601String(),
                'hostName' => $vehicle?->host_name ?? $b->business_name ?? '',
                'hostPhone' => '',
                'ownerId' => $ownerId,
            ];
        });

        return response()->json(['data' => $rows->values()->all()]);
    }

    /**
     * Admin: mark an approved booking as paid (client has paid).
     */
    public function markPaid(string $id): JsonResponse
    {
        if (\strlen($id) > 64) {
            return response()->json(['message' => 'Booking not found.'], 404);
        }
        $booking = RentalBooking::find($id);

        if (! $booking) {
            return response()->json(['message' => 'Booking not found.'], 404);
        }

        if ($booking->status !== 'Approved') {
            return response()->json(['message' => 'Only approved bookings can be marked as paid.'], 422);
        }

        if ($booking->paid_at !== null) {
            return response()->json(['message' => 'Booking is already marked as paid.'], 422);
        }

        $booking->update(['paid_at' => now()]);

        return response()->json(['data' => $this->toRecord($booking->fresh())]);
    }

    private function toRecord(RentalBooking $b): array
    {
        return [
            'id' => $b->id,
            'transactionId' => $b->transaction_id,
            'vehicleName' => $b->vehicle_name,
            'businessName' => $b->business_name,
            'clientUserId' => $b->client_user_id,
            'clientName' => $b->client_name,
            'clientEmail' => $b->client_email,
            'startDate' => $b->start_date->format('Y-m-d'),
            'endDate' => $b->end_date->format('Y-m-d'),
            'amount' => (int) $b->amount,
            'status' => $b->status,
            'archived' => $b->archived,
            'paidAt' => $b->paid_at?->toIso8601String(),
        ];
    }

    private function mapClientStatus(RentalBooking $b): string
    {
        $status = $b->status;
        if ($status === 'Approved') {
            return $b->paid_at === null ? 'Approved' : 'Confirmed';
        }
        return match ($status) {
            'Pending' => 'Pending approval',
            'Pending cancellation' => 'Pending cancellation',
            'Active', 'Overdue' => 'Confirmed',
            'Completed' => 'Completed',
            'Cancelled', 'Rejected' => 'Cancelled',
            default => 'Pending approval',
        };
    }

    private function mapCarOwnerStatus(RentalBooking $b): string
    {
        $status = $b->status;
        if ($status === 'Approved') {
            return $b->paid_at === null ? 'Requested' : 'Confirmed';
        }
        return match ($status) {
            'Pending' => 'Requested',
            'Active', 'Overdue' => 'Active',
            'Completed' => 'Completed',
            'Cancelled', 'Rejected' => 'Declined',
            default => 'Requested',
        };
    }

    private function mapCarOwnerStatusToBackend(string $status): string
    {
        return match ($status) {
            'Requested' => 'Pending',
            'Confirmed' => 'Approved',
            'Active' => 'Active',
            'Completed' => 'Completed',
            'Declined' => 'Cancelled',
            default => 'Pending',
        };
    }
}
