<?php

namespace Database\Seeders;

use App\Models\PromoCode;
use Illuminate\Database\Seeder;

class PromoCodeSeeder extends Seeder
{
    public function run(): void
    {
        $promos = [
            [
                'code' => 'BULOD10',
                'title' => '10% off 3-day minimum booking',
                'description' => 'Use at checkout for 10% off when you book for 3 or more days.',
                'discount_percent' => 10,
                'min_rental_days' => 3,
                'max_rental_days' => null,
                'active' => true,
                'expires_at' => now()->endOfYear(),
            ],
        ];

        foreach ($promos as $p) {
            PromoCode::updateOrCreate(
                ['code' => $p['code']],
                $p
            );
        }
    }
}
