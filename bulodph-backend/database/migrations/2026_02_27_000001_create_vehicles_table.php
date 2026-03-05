<?php

declare(strict_types=1);

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    public function up(): void
    {
        Schema::create('vehicles', function (Blueprint $table) {
            $table->uuid('id')->primary();
            $table->foreignUuid('user_id')->nullable()->constrained('users')->nullOnDelete();
            $table->string('name');
            $table->string('type', 50)->default('Car');
            $table->string('location', 255)->nullable();
            $table->decimal('price_per_day', 12, 2)->default(0);
            $table->decimal('original_price_per_day', 12, 2)->nullable();
            $table->text('description')->nullable();
            $table->string('image', 1024)->nullable();
            $table->string('status', 50)->default('Available');
            $table->boolean('approved')->default(false);
            $table->boolean('featured')->default(false);
            $table->string('host_name', 255)->nullable();
            $table->string('business_name', 255)->nullable();
            $table->string('car_type', 50)->nullable();
            $table->unsignedTinyInteger('capacity')->nullable();
            $table->json('tags')->nullable();
            $table->json('images_four_sides')->nullable();
            /** When the car was listed (first created). */
            $table->timestamp('listed_at')->nullable();
            $table->timestamps();
        });

        Schema::table('vehicles', function (Blueprint $table) {
            $table->index(['approved', 'listed_at']);
        });
    }

    public function down(): void
    {
        Schema::dropIfExists('vehicles');
    }
};
