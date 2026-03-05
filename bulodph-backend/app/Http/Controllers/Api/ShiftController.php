<?php

declare(strict_types=1);

namespace App\Http\Controllers\Api;

use App\Actions\Shifts\CreateShiftAction;
use App\Data\Shifts\ClockInData;
use App\Data\Shifts\CreateShiftData;
use App\Domain\Shifts\Enums\ShiftStatus;
use App\Http\Controllers\Controller;
use App\Models\Shift;
use Illuminate\Http\JsonResponse;
use Illuminate\Http\Request;

final class ShiftController extends Controller
{
    public function index(Request $request): JsonResponse
    {
        $shifts = Shift::query()
            ->with(['client', 'primaryWorker', 'shiftLines.planLineItem.supportItem'])
            ->when($request->input('status'), fn($q, $status) => $q->where('status', $status))
            ->when($request->input('worker_id'), fn($q, $workerId) => $q->where('primary_worker_id', $workerId))
            ->when($request->input('client_id'), fn($q, $clientId) => $q->where('client_id', $clientId))
            ->orderBy('scheduled_start', 'desc')
            ->paginate(20);

        return response()->json($shifts);
    }

    public function store(CreateShiftData $data, CreateShiftAction $action): JsonResponse
    {
        $shift = $action->execute($data, auth()->user());

        return response()->json($shift->load(['client', 'primaryWorker', 'shiftLines']), 201);
    }

    public function show(Shift $shift): JsonResponse
    {
        $this->authorize('view', $shift);

        return response()->json(
            $shift->load(['client', 'primaryWorker', 'shiftLines.planLineItem.supportItem', 'shadowShifts'])
        );
    }

    public function clockIn(Shift $shift, Request $request): JsonResponse
    {
        $this->authorize('update', $shift);

        $data = ClockInData::from($request->all());

        $shift->update([
            'status' => ShiftStatus::IN_PROGRESS,
            'actual_start' => now(),
            'clock_in_latitude' => $data->latitude,
            'clock_in_longitude' => $data->longitude,
        ]);

        return response()->json($shift);
    }

    public function clockOut(Shift $shift, Request $request): JsonResponse
    {
        $this->authorize('update', $shift);

        $validated = $request->validate([
            'latitude' => 'required|numeric',
            'longitude' => 'required|numeric',
        ]);

        $shift->update([
            'status' => ShiftStatus::COMPLETED,
            'actual_end' => now(),
            'clock_out_latitude' => $validated['latitude'],
            'clock_out_longitude' => $validated['longitude'],
        ]);

        return response()->json($shift);
    }

    public function cancel(Shift $shift, Request $request): JsonResponse
    {
        $this->authorize('update', $shift);

        $validated = $request->validate([
            'cancellation_reason' => 'required|string|max:500',
        ]);

        $shift->update([
            'status' => ShiftStatus::CANCELLED,
            'cancellation_reason' => $validated['cancellation_reason'],
        ]);

        return response()->json($shift);
    }

    public function destroy(Shift $shift): JsonResponse
    {
        $this->authorize('delete', $shift);

        $shift->delete();

        return response()->json(null, 204);
    }
}

