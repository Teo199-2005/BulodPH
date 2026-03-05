<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    public function up(): void
    {
        Schema::create('shift_lines', function (Blueprint $table) {
            $table->uuid('id')->primary();
            $table->uuid('shift_id');
            $table->uuid('plan_line_item_id');
            $table->decimal('units', 10, 2)->unsigned();
            $table->bigInteger('unit_price_cents')->unsigned();
            $table->bigInteger('total_cents')->unsigned();
            $table->boolean('is_billable')->default(true);
            $table->timestamps();

            $table->foreign('shift_id')
                ->references('id')
                ->on('shifts')
                ->cascadeOnDelete();

            $table->foreign('plan_line_item_id')
                ->references('id')
                ->on('plan_line_items')
                ->restrictOnDelete();

            $table->index('shift_id');
        });
    }

    public function down(): void
    {
        Schema::dropIfExists('shift_lines');
    }
};

