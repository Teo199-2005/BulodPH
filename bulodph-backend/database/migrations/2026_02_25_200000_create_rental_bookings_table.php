<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    public function up(): void
    {
        Schema::create('rental_bookings', function (Blueprint $table) {
            $table->string('id', 64)->primary();
            $table->string('transaction_id', 64)->index();
            $table->string('vehicle_name');
            $table->string('business_name');
            $table->string('client_name');
            $table->string('client_email');
            $table->date('start_date');
            $table->date('end_date');
            $table->unsignedInteger('amount');
            $table->string('status', 32)->default('Pending')->index();
            $table->boolean('archived')->default(false);
            $table->string('vehicle_id', 64)->nullable()->index();
            $table->foreignUuid('client_user_id')->nullable()->constrained('users')->nullOnDelete();
            $table->timestamps();
        });
    }

    public function down(): void
    {
        Schema::dropIfExists('rental_bookings');
    }
};
