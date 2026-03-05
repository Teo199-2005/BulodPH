<?php

declare(strict_types=1);

namespace App\Data\Shifts;

use Spatie\LaravelData\Attributes\Validation\Exists;
use Spatie\LaravelData\Attributes\Validation\Numeric;
use Spatie\LaravelData\Attributes\Validation\Required;
use Spatie\LaravelData\Attributes\Validation\Uuid;
use Spatie\LaravelData\Data;

final class ClockInData extends Data
{
    public function __construct(
        #[Required, Uuid, Exists('shifts', 'id')]
        public readonly string $shift_id,

        #[Required, Numeric]
        public readonly float $latitude,

        #[Required, Numeric]
        public readonly float $longitude,
    ) {
    }
}

