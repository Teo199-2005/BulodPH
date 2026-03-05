<?php

declare(strict_types=1);

namespace Database\Factories;

use App\Models\Client;
use App\Models\NDISPlan;
use Illuminate\Database\Eloquent\Factories\Factory;

final class NDISPlanFactory extends Factory
{
    protected $model = NDISPlan::class;

    public function definition(): array
    {
        $startDate = $this->faker->dateTimeBetween('-1 year', 'now');
        $endDate = (clone $startDate)->modify('+12 months');

        return [
            'client_id' => Client::factory(),
            'plan_number' => 'PLAN-' . str_pad((string) $this->faker->numberBetween(0, 99999999), 8, '0', STR_PAD_LEFT),
            'start_date' => $startDate->format('Y-m-d'),
            'end_date' => $endDate->format('Y-m-d'),
            'plan_management_type' => $this->faker->randomElement(['SELF_MANAGED', 'PLAN_MANAGED', 'NDIA_MANAGED']),
            'is_active' => true,
        ];
    }

    public function inactive(): static
    {
        return $this->state(fn (array $attributes) => [
            'is_active' => false,
        ]);
    }
}

