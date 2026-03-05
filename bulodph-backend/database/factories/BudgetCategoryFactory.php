<?php

declare(strict_types=1);

namespace Database\Factories;

use App\Models\BudgetCategory;
use App\Models\NDISPlan;
use Illuminate\Database\Eloquent\Factories\Factory;

final class BudgetCategoryFactory extends Factory
{
    protected $model = BudgetCategory::class;

    public function definition(): array
    {
        $totalBudget = $this->faker->numberBetween(50000, 500000); // $500 - $5000
        $spent = $this->faker->numberBetween(0, (int)($totalBudget * 0.5));
        $committed = $this->faker->numberBetween(0, (int)(($totalBudget - $spent) * 0.3));

        return [
            'ndis_plan_id' => NDISPlan::factory(),
            'category_type' => $this->faker->randomElement(['CORE', 'CAPACITY_BUILDING', 'CAPITAL']),
            'total_budget_cents' => $totalBudget,
            'spent_cents' => $spent,
            'committed_cents' => $committed,
        ];
    }
}

