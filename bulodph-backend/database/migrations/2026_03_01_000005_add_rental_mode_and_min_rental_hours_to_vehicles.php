<?php

declare(strict_types=1);

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    public function up(): void
    {
        Schema::table('vehicles', function (Blueprint $table) {
            $table->string('rental_mode', 32)->default('both')->after('capacity');
            $table->unsignedInteger('min_rental_period_hours')->nullable()->after('rental_mode');
        });
    }

    public function down(): void
    {
        Schema::table('vehicles', function (Blueprint $table) {
            $table->dropColumn(['rental_mode', 'min_rental_period_hours']);
        });
    }
};
