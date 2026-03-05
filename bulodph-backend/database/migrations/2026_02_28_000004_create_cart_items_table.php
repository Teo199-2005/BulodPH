<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    public function up(): void
    {
        Schema::create('cart_items', function (Blueprint $table) {
            $table->uuid('id')->primary();
            $table->foreignUuid('user_id')->constrained('users')->cascadeOnDelete();
            $table->string('vehicle_id', 64)->index();
            $table->string('vehicle_name')->nullable();
            $table->string('vehicle_image')->nullable();
            $table->date('start_date');
            $table->date('end_date');
            $table->unsignedInteger('price_per_day')->default(0);
            $table->unsignedInteger('quantity_days')->default(1);
            $table->string('meet_up')->nullable();
            $table->timestamps();

            $table->index(['user_id', 'vehicle_id', 'start_date', 'end_date']);
        });
    }

    public function down(): void
    {
        Schema::dropIfExists('cart_items');
    }
};
