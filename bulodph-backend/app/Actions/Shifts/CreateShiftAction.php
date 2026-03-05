<?php

declare(strict_types=1);

namespace App\Actions\Shifts;

use App\Actions\Certifications\ValidateStaffCertificationsAction;
use App\Actions\NDIS\CalculateBudgetSolvencyAction;
use App\Data\Shifts\CreateShiftData;
use App\Domain\Shifts\Enums\ShiftStatus;
use App\Models\Shift;
use App\Models\User;
use Carbon\Carbon;
use Illuminate\Support\Facades\DB;
use Illuminate\Validation\ValidationException;

final readonly class CreateShiftAction
{
    public function __construct(
        private ValidateStaffCertificationsAction $validateCertifications,
        private CalculateBudgetSolvencyAction $calculateBudgetSolvency,
        private ValidateShiftAvailabilityAction $validateAvailability,
    ) {
    }

    /**
     * Create a new shift with comprehensive validation.
     *
     * Validates:
     * 1. Staff availability (no overlapping shifts)
     * 2. NDIS budget solvency (sufficient funds in plan line items)
     * 3. Certification validity (First Aid, CPR, NDIS Worker Screening)
     *
     * @throws ValidationException
     */
    public function execute(CreateShiftData $data, User $authenticatedUser): Shift
    {
        return DB::transaction(function () use ($data, $authenticatedUser) {
            // 1. Validate staff availability
            $this->validateAvailability->execute(
                workerId: $data->primary_worker_id,
                start: $data->scheduled_start,
                end: $data->scheduled_end,
                excludeShiftId: null
            );

            // 2. Validate certifications
            $this->validateCertifications->execute(
                userId: $data->primary_worker_id,
                asOfDate: $data->scheduled_start
            );

            // 3. Validate budget solvency
            $budgetValidation = $this->calculateBudgetSolvency->execute(
                planLineItemIds: $data->plan_line_item_ids,
                requiredHours: $data->getDurationInHours()
            );

            if (!$budgetValidation->isSolvent) {
                throw ValidationException::withMessages([
                    'plan_line_item_ids' => [
                        "Insufficient budget. Required: \${$budgetValidation->requiredAmount}, Available: \${$budgetValidation->availableAmount}"
                    ]
                ]);
            }

            // 4. If shadow shift, validate parent shift overlap
            if ($data->isShadowShift()) {
                $this->validateShadowShiftOverlap($data);
            }

            // 5. Create shift
            $shift = Shift::create([
                'id' => (string) \Illuminate\Support\Str::orderedUuid(),
                'organization_id' => $authenticatedUser->organization_id,
                'client_id' => $data->client_id,
                'primary_worker_id' => $data->primary_worker_id,
                'parent_shift_id' => $data->parent_shift_id,
                'scheduled_start' => $data->scheduled_start,
                'scheduled_end' => $data->scheduled_end,
                'status' => ShiftStatus::SCHEDULED->value,
                'notes' => $data->notes,
            ]);

            // 6. Create shift lines (billing records)
            $this->createShiftLines($shift, $data);

            return $shift->load(['client', 'primaryWorker', 'shiftLines.planLineItem.supportItem']);
        });
    }

    private function validateShadowShiftOverlap(CreateShiftData $data): void
    {
        $parentShift = Shift::findOrFail($data->parent_shift_id);

        if ($data->scheduled_start->lt($parentShift->scheduled_start) ||
            $data->scheduled_end->gt($parentShift->scheduled_end)) {
            throw ValidationException::withMessages([
                'scheduled_start' => ['Shadow shift must be within parent shift timeframe.']
            ]);
        }
    }

    private function createShiftLines(Shift $shift, CreateShiftData $data): void
    {
        $planLineItems = \App\Models\PlanLineItem::with('supportItem')
            ->whereIn('id', $data->plan_line_item_ids)
            ->get();

        $hoursPerLineItem = $data->getDurationInHours() / $planLineItems->count();

        foreach ($planLineItems as $lineItem) {
            \App\Models\ShiftLine::create([
                'id' => (string) \Illuminate\Support\Str::orderedUuid(),
                'shift_id' => $shift->id,
                'plan_line_item_id' => $lineItem->id,
                'units' => $hoursPerLineItem,
                'unit_price_cents' => $lineItem->supportItem->price_cents,
                'total_cents' => (int) ($hoursPerLineItem * $lineItem->supportItem->price_cents),
                'is_billable' => !$data->isShadowShift(), // Shadow shifts not billable by default
            ]);
        }
    }
}

