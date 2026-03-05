<?php

declare(strict_types=1);

namespace Database\Factories;

use App\Models\NDISSupportItem;
use Illuminate\Database\Eloquent\Factories\Factory;

final class NDISSupportItemFactory extends Factory
{
    protected $model = NDISSupportItem::class;

    public function definition(): array
    {
        return [
            'support_item_number' => '01_' . $this->faker->numberBetween(100, 999) . '_' . $this->faker->numberBetween(1000, 9999) . '_' . $this->faker->numberBetween(1, 9) . '_' . $this->faker->numberBetween(1, 9),
            'support_item_name' => $this->faker->randomElement([
                'Assistance with Self-Care Activities',
                'Community Nursing Care',
                'Therapeutic Supports',
                'Assistance with Travel/Transport',
                'Development of Daily Living Skills',
            ]),
            'category_type' => $this->faker->randomElement(['CORE', 'CAPACITY_BUILDING', 'CAPITAL']),
            'unit_of_measure' => $this->faker->randomElement(['HOUR', 'EACH', 'WEEK', 'MONTH']),
            'price_cents' => $this->faker->numberBetween(3000, 15000), // $30 - $150
            'effective_from' => $this->faker->dateTimeBetween('-2 years', 'now')->format('Y-m-d'),
            'effective_to' => $this->faker->optional()->dateTimeBetween('now', '+2 years')?->format('Y-m-d'),
        ];
    }
}

