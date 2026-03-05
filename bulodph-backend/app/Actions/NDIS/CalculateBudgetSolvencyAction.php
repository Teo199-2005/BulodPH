<?php

declare(strict_types=1);

namespace App\Actions\NDIS;

use App\Data\NDIS\BudgetSolvencyData;
use App\Models\PlanLineItem;

final readonly class CalculateBudgetSolvencyAction
{
    /**
     * Calculate if there is sufficient budget across plan line items.
     *
     * @param array<string> $planLineItemIds
     * @param float $requiredHours
     */
    public function execute(array $planLineItemIds, float $requiredHours): BudgetSolvencyData
    {
        $lineItems = PlanLineItem::with('supportItem')
            ->whereIn('id', $planLineItemIds)
            ->where('is_active', true)
            ->get();

        $totalRequiredCents = 0;
        $totalAvailableCents = 0;
        $insufficientLineItems = [];

        $hoursPerLineItem = $requiredHours / $lineItems->count();

        foreach ($lineItems as $lineItem) {
            $requiredCents = (int) ($hoursPerLineItem * $lineItem->supportItem->price_cents);
            $availableCents = $lineItem->allocated_amount_cents - $lineItem->used_amount_cents;

            $totalRequiredCents += $requiredCents;
            $totalAvailableCents += $availableCents;

            if ($requiredCents > $availableCents) {
                $insufficientLineItems[] = [
                    'line_item_id' => $lineItem->id,
                    'support_item_name' => $lineItem->supportItem->support_item_name,
                    'required_cents' => $requiredCents,
                    'available_cents' => $availableCents,
                ];
            }
        }

        return new BudgetSolvencyData(
            isSolvent: empty($insufficientLineItems),
            requiredAmount: $totalRequiredCents / 100,
            availableAmount: $totalAvailableCents / 100,
            insufficientLineItems: $insufficientLineItems
        );
    }
}

