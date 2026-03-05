<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    public function up(): void
    {
        Schema::create('ndis_plans', function (Blueprint $table) {
            $table->uuid('id')->primary();
            $table->uuid('client_id');
            $table->string('plan_number')->unique();
            $table->date('start_date');
            $table->date('end_date');
            $table->enum('plan_management_type', ['SELF_MANAGED', 'PLAN_MANAGED', 'NDIA_MANAGED']);
            $table->boolean('is_active')->default(true);
            $table->timestamps();

            $table->foreign('client_id')
                ->references('id')
                ->on('clients')
                ->restrictOnDelete();

            $table->index(['client_id', 'is_active']);
        });
    }

    public function down(): void
    {
        Schema::dropIfExists('ndis_plans');
    }
};

