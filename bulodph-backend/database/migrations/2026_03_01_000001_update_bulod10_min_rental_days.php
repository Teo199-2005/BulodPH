<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Support\Facades\DB;

return new class extends Migration
{
    public function up(): void
    {
        DB::table('promo_codes')
            ->where('code', 'BULOD10')
            ->update([
                'title' => '10% off 3-day minimum booking',
                'description' => 'Use at checkout for 10% off when you book for 3 or more days.',
                'min_rental_days' => 3,
                'max_rental_days' => null,
                'updated_at' => now(),
            ]);
    }

    public function down(): void
    {
        DB::table('promo_codes')
            ->where('code', 'BULOD10')
            ->update([
                'title' => '10% off 1-day booking',
                'description' => 'Use at checkout for 10% off when you book for 1 day only.',
                'min_rental_days' => 1,
                'max_rental_days' => 1,
                'updated_at' => now(),
            ]);
    }
};
