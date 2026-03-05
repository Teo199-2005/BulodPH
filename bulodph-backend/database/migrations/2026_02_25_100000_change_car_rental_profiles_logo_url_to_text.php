<?php

declare(strict_types=1);

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    public function up(): void
    {
        Schema::table('car_rental_profiles', function (Blueprint $table) {
            $table->text('logo_url')->nullable()->change();
        });
    }

    public function down(): void
    {
        Schema::table('car_rental_profiles', function (Blueprint $table) {
            $table->string('logo_url', 1024)->nullable()->change();
        });
    }
};
