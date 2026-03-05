<?php

declare(strict_types=1);

namespace Database\Factories;

use App\Models\Organization;
use Illuminate\Database\Eloquent\Factories\Factory;

final class OrganizationFactory extends Factory
{
    protected $model = Organization::class;

    public function definition(): array
    {
        return [
            'abn' => str_pad((string) $this->faker->numberBetween(0, 99999999999), 11, '0', STR_PAD_LEFT),
            'trading_name' => $this->faker->company(),
            'ndis_registration_number' => $this->faker->boolean(70) ? str_pad((string) $this->faker->numberBetween(0, 99999999), 8, '0', STR_PAD_LEFT) : null,
            'is_active' => true,
            'settings' => [
                'shift_approval_required' => false,
                'geofence_radius_meters' => 100,
                'auto_invoice_generation' => true,
            ],
        ];
    }

    public function inactive(): static
    {
        return $this->state(fn (array $attributes) => [
            'is_active' => false,
        ]);
    }
}

