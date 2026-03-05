<?php

namespace Database\Seeders;

use App\Models\Payout;
use App\Models\User;
use Illuminate\Database\Seeder;

class PayoutSeeder extends Seeder
{
    /**
     * Seed demo payouts for car owner and marketing demo accounts.
     */
    public function run(): void
    {
        $carOwner = User::where('email', 'carowner@bulodph.demo')->first();
        $marketing = User::where('email', 'marketing@bulodph.demo')->first();

        if ($carOwner) {
            Payout::firstOrCreate(
                [
                    'user_id' => $carOwner->id,
                    'amount' => 7500,
                    'status' => 'pending',
                ],
                [
                    'type' => 'car_owner',
                    'payee_name' => $carOwner->name,
                    'method' => 'GCash',
                    'requested_at' => now()->subDays(2),
                ]
            );
            Payout::firstOrCreate(
                [
                    'user_id' => $carOwner->id,
                    'amount' => 5000,
                    'status' => 'paid',
                ],
                [
                    'type' => 'car_owner',
                    'payee_name' => $carOwner->name,
                    'method' => 'GCash',
                    'requested_at' => now()->subDays(10),
                    'paid_at' => now()->subDays(8),
                ]
            );
        }

        if ($marketing) {
            Payout::firstOrCreate(
                [
                    'user_id' => $marketing->id,
                    'amount' => 3200,
                    'status' => 'pending',
                ],
                [
                    'type' => 'marketing',
                    'payee_name' => $marketing->name,
                    'method' => 'GCash',
                    'requested_at' => now()->subDay(),
                ]
            );
            Payout::firstOrCreate(
                [
                    'user_id' => $marketing->id,
                    'amount' => 1500,
                    'status' => 'paid',
                ],
                [
                    'type' => 'marketing',
                    'payee_name' => $marketing->name,
                    'method' => 'GCash',
                    'requested_at' => now()->subDays(15),
                    'paid_at' => now()->subDays(12),
                ]
            );
        }

        $this->command->info('Payout seeds created (pending + history for demo accounts).');
    }
}
