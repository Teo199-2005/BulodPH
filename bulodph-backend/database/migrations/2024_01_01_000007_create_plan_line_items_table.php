<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    public function up(): void
    {
        Schema::create('plan_line_items', function (Blueprint $table) {
            $table->uuid('id')->primary();
            $table->uuid('budget_category_id');
            $table->uuid('support_item_id');
            $table->decimal('allocated_units', 10, 2)->unsigned();
            $table->bigInteger('allocated_amount_cents')->unsigned();
            $table->decimal('used_units', 10, 2)->unsigned()->default(0);
            $table->bigInteger('used_amount_cents')->unsigned()->default(0);
            $table->boolean('is_active')->default(true);
            $table->timestamps();

            $table->foreign('budget_category_id')
                ->references('id')
                ->on('budget_categories')
                ->restrictOnDelete();

            $table->foreign('support_item_id')
                ->references('id')
                ->on('ndis_support_items')
                ->restrictOnDelete();

            $table->index(['budget_category_id', 'is_active']);
        });
    }

    public function down(): void
    {
        Schema::dropIfExists('plan_line_items');
    }
};

