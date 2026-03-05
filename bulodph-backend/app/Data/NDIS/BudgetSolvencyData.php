<?php

declare(strict_types=1);

namespace App\Data\NDIS;

use Spatie\LaravelData\Data;

final class BudgetSolvencyData extends Data
{
    public function __construct(
        public readonly bool $isSolvent,
        public readonly float $requiredAmount,
        public readonly float $availableAmount,
        public readonly array $insufficientLineItems = [],
    ) {
    }
}

