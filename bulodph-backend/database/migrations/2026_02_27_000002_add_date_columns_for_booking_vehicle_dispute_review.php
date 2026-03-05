<?php

declare(strict_types=1);

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    public function up(): void
    {
        Schema::table('rental_bookings', function (Blueprint $table) {
            $table->timestamp('confirmed_at')->nullable()->after('status');
            $table->timestamp('paid_at')->nullable()->after('confirmed_at');
            $table->timestamp('cancelled_at')->nullable()->after('paid_at');
            $table->timestamp('completed_at')->nullable()->after('cancelled_at');
        });

        Schema::table('vehicles', function (Blueprint $table) {
            $table->timestamp('approved_at')->nullable()->after('approved');
        });

        Schema::table('disputes', function (Blueprint $table) {
            $table->timestamp('resolved_at')->nullable()->after('status');
        });

        Schema::table('reviews', function (Blueprint $table) {
            $table->timestamp('approved_at')->nullable()->after('status');
        });
    }

    public function down(): void
    {
        Schema::table('rental_bookings', function (Blueprint $table) {
            $table->dropColumn(['confirmed_at', 'paid_at', 'cancelled_at', 'completed_at']);
        });
        Schema::table('vehicles', function (Blueprint $table) {
            $table->dropColumn('approved_at');
        });
        Schema::table('disputes', function (Blueprint $table) {
            $table->dropColumn('resolved_at');
        });
        Schema::table('reviews', function (Blueprint $table) {
            $table->dropColumn('approved_at');
        });
    }
};
