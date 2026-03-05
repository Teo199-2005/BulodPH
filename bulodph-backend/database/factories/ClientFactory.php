<?php

declare(strict_types=1);

namespace Database\Factories;

use App\Models\Client;
use App\Models\Organization;
use Illuminate\Database\Eloquent\Factories\Factory;

final class ClientFactory extends Factory
{
    protected $model = Client::class;

    public function definition(): array
    {
        return [
            'organization_id' => Organization::factory(),
            'ndis_number' => str_pad((string) $this->faker->numberBetween(0, 9999999999), 10, '0', STR_PAD_LEFT),
            'first_name' => $this->faker->firstName(),
            'last_name' => $this->faker->lastName(),
            'date_of_birth' => $this->faker->date('Y-m-d', '-18 years'),
            'address_line_1' => $this->faker->streetAddress(),
            'address_line_2' => $this->faker->optional()->secondaryAddress(),
            'suburb' => $this->faker->city(),
            'state' => $this->faker->randomElement(['NSW', 'VIC', 'QLD', 'SA', 'WA', 'TAS', 'NT', 'ACT']),
            'postcode' => $this->faker->postcode(),
            'latitude' => $this->faker->latitude(-43.6345, -10.6681), // Australia bounds
            'longitude' => $this->faker->longitude(113.3389, 153.6139),
            'emergency_contact_name' => $this->faker->name(),
            'emergency_contact_phone' => '04' . $this->faker->numberBetween(10, 99) . $this->faker->numberBetween(100000, 999999),
        ];
    }
}

