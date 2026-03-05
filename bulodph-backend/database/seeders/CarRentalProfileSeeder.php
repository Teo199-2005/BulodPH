<?php

declare(strict_types=1);

namespace Database\Seeders;

use App\Models\CarRentalProfile;
use App\Models\User;
use Illuminate\Database\Seeder;

class CarRentalProfileSeeder extends Seeder
{
    /**
     * Seed a car rental profile for the demo car owner so the table is not empty.
     */
    public function run(): void
    {
        $user = User::where('email', 'carowner@bulodph.demo')->first();
        if (!$user) {
            $this->command->warn('Demo car owner (carowner@bulodph.demo) not found. Run DemoAccountsSeeder first.');
            return;
        }

        CarRentalProfile::updateOrCreate(
            ['user_id' => $user->id],
            [
                'business_name' => 'Demo Car Owner',
                'bio' => 'Demo rental for BulodPH pilot testing.',
                'city' => null,
                'province' => null,
                'address' => null,
                'phone' => $user->mobile ?? '639171234569',
                'email' => $user->email,
                'business_permit_number' => null,
                'business_address' => null,
                'slug' => CarRentalProfile::slugFrom('Demo Car Owner'),
            ]
        );

        $this->command->info('Car rental profile seeded for demo car owner.');
    }
}
