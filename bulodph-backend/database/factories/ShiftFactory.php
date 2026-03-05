<?php

declare(strict_types=1);

namespace Database\Factories;

use App\Domain\Shifts\Enums\ShiftStatus;
use App\Models\Client;
use App\Models\Organization;
use App\Models\Shift;
use App\Models\User;
use Illuminate\Database\Eloquent\Factories\Factory;

final class ShiftFactory extends Factory
{
    protected $model = Shift::class;

    public function definition(): array
    {
        $scheduledStart = $this->faker->dateTimeBetween('now', '+30 days');
        $scheduledEnd = (clone $scheduledStart)->modify('+' . $this->faker->numberBetween(2, 8) . ' hours');

        return [
            'organization_id' => Organization::factory(),
            'client_id' => Client::factory(),
            'primary_worker_id' => User::factory(),
            'parent_shift_id' => null,
            'scheduled_start' => $scheduledStart,
            'scheduled_end' => $scheduledEnd,
            'actual_start' => null,
            'actual_end' => null,
            'clock_in_latitude' => null,
            'clock_in_longitude' => null,
            'clock_out_latitude' => null,
            'clock_out_longitude' => null,
            'status' => ShiftStatus::SCHEDULED,
            'cancellation_reason' => null,
            'notes' => $this->faker->optional()->sentence(),
        ];
    }

    public function inProgress(): static
    {
        return $this->state(function (array $attributes) {
            $actualStart = $this->faker->dateTimeBetween('-2 hours', 'now');
            
            return [
                'status' => ShiftStatus::IN_PROGRESS,
                'actual_start' => $actualStart,
                'clock_in_latitude' => $this->faker->latitude(-43.6345, -10.6681),
                'clock_in_longitude' => $this->faker->longitude(113.3389, 153.6139),
            ];
        });
    }

    public function completed(): static
    {
        return $this->state(function (array $attributes) {
            $actualStart = $this->faker->dateTimeBetween('-8 hours', '-4 hours');
            $actualEnd = (clone $actualStart)->modify('+' . $this->faker->numberBetween(2, 8) . ' hours');
            
            return [
                'status' => ShiftStatus::COMPLETED,
                'actual_start' => $actualStart,
                'actual_end' => $actualEnd,
                'clock_in_latitude' => $this->faker->latitude(-43.6345, -10.6681),
                'clock_in_longitude' => $this->faker->longitude(113.3389, 153.6139),
                'clock_out_latitude' => $this->faker->latitude(-43.6345, -10.6681),
                'clock_out_longitude' => $this->faker->longitude(113.3389, 153.6139),
            ];
        });
    }

    public function cancelled(): static
    {
        return $this->state(fn (array $attributes) => [
            'status' => ShiftStatus::CANCELLED,
            'cancellation_reason' => $this->faker->randomElement([
                'Client unavailable',
                'Worker sick',
                'Emergency',
                'Client cancelled',
            ]),
        ]);
    }

    public function shadowShift(): static
    {
        return $this->state(fn (array $attributes) => [
            'parent_shift_id' => Shift::factory(),
        ]);
    }
}

