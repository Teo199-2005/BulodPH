<?php

declare(strict_types=1);

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    public function up(): void
    {
        Schema::table('invoices', function (Blueprint $table) {
            $table->timestamp('paid_at')->nullable()->after('status');
        });

        Schema::table('car_rental_profiles', function (Blueprint $table) {
            $table->timestamp('verified_at')->nullable()->after('slug');
        });
    }

    public function down(): void
    {
        Schema::table('invoices', function (Blueprint $table) {
            $table->dropColumn('paid_at');
        });
        Schema::table('car_rental_profiles', function (Blueprint $table) {
            $table->dropColumn('verified_at');
        });
    }
};
