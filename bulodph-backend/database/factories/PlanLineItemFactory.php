<?php

declare(strict_types=1);

namespace Database\Factories;

use App\Models\BudgetCategory;
use App\Models\NDISSupportItem;
use App\Models\PlanLineItem;
use Illuminate\Database\Eloquent\Factories\Factory;

final class PlanLineItemFactory extends Factory
{
    protected $model = PlanLineItem::class;

    public function definition(): array
    {
        $allocatedUnits = $this->faker->randomFloat(2, 10, 500);
        $usedUnits = $this->faker->randomFloat(2, 0, $allocatedUnits * 0.6);
        $unitPrice = $this->faker->numberBetween(3000, 15000);

        return [
            'budget_category_id' => BudgetCategory::factory(),
            'support_item_id' => NDISSupportItem::factory(),
            'allocated_units' => $allocatedUnits,
            'allocated_amount_cents' => (int)($allocatedUnits * $unitPrice),
            'used_units' => $usedUnits,
            'used_amount_cents' => (int)($usedUnits * $unitPrice),
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

