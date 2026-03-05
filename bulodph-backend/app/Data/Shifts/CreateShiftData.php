<?php

declare(strict_types=1);

namespace App\Data\Shifts;

use Carbon\Carbon;
use Spatie\LaravelData\Attributes\Validation\After;
use Spatie\LaravelData\Attributes\Validation\ArrayType;
use Spatie\LaravelData\Attributes\Validation\Exists;
use Spatie\LaravelData\Attributes\Validation\Nullable;
use Spatie\LaravelData\Attributes\Validation\Required;
use Spatie\LaravelData\Attributes\Validation\Uuid;
use Spatie\LaravelData\Data;

final class CreateShiftData extends Data
{
    public function __construct(
        #[Required, Uuid, Exists('clients', 'id')]
        public readonly string $client_id,

        #[Required, Uuid, Exists('users', 'id')]
        public readonly string $primary_worker_id,

        #[Nullable, Uuid, Exists('shifts', 'id')]
        public readonly ?string $parent_shift_id,

        #[Required]
        public readonly Carbon $scheduled_start,

        #[Required, After('scheduled_start')]
        public readonly Carbon $scheduled_end,

        /** @var array<string> Array of plan_line_item UUIDs */
        #[Required, ArrayType]
        public readonly array $plan_line_item_ids,

        #[Nullable]
        public readonly ?string $notes,
    ) {
    }

    /**
     * Calculate shift duration in hours (for billing).
     */
    public function getDurationInHours(): float
    {
        return $this->scheduled_start->diffInMinutes($this->scheduled_end) / 60;
    }

    /**
     * Check if this is a shadow shift.
     */
    public function isShadowShift(): bool
    {
        return $this->parent_shift_id !== null;
    }
}

