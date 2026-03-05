<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    public function up(): void
    {
        Schema::create('budget_categories', function (Blueprint $table) {
            $table->uuid('id')->primary();
            $table->uuid('ndis_plan_id');
            $table->enum('category_type', ['CORE', 'CAPITAL', 'CAPACITY_BUILDING']);
            $table->bigInteger('total_budget_cents')->unsigned();
            $table->bigInteger('spent_cents')->unsigned()->default(0);
            $table->bigInteger('committed_cents')->unsigned()->default(0);
            $table->timestamps();

            $table->foreign('ndis_plan_id')
                ->references('id')
                ->on('ndis_plans')
                ->restrictOnDelete();

            $table->index(['ndis_plan_id', 'category_type']);
        });
    }

    public function down(): void
    {
        Schema::dropIfExists('budget_categories');
    }
};

