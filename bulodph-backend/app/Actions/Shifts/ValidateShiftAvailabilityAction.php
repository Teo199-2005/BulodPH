<?php

declare(strict_types=1);

namespace App\Actions\Shifts;

use App\Models\Shift;
use Carbon\Carbon;
use Illuminate\Validation\ValidationException;

final readonly class ValidateShiftAvailabilityAction
{
    /**
     * Validate that a worker has no overlapping shifts.
     *
     * @throws ValidationException
     */
    public function execute(
        string $workerId,
        Carbon $start,
        Carbon $end,
        ?string $excludeShiftId = null
    ): void {
        $query = Shift::where('primary_worker_id', $workerId)
            ->where('status', '!=', 'CANCELLED')
            ->where(function ($q) use ($start, $end) {
                $q->whereBetween('scheduled_start', [$start, $end])
                    ->orWhereBetween('scheduled_end', [$start, $end])
                    ->orWhere(function ($q2) use ($start, $end) {
                        $q2->where('scheduled_start', '<=', $start)
                            ->where('scheduled_end', '>=', $end);
                    });
            });

        if ($excludeShiftId) {
            $query->where('id', '!=', $excludeShiftId);
        }

        if ($query->exists()) {
            throw ValidationException::withMessages([
                'primary_worker_id' => ['Worker has overlapping shifts during this time period.']
            ]);
        }
    }
}

