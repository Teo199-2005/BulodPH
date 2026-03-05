<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    public function up(): void
    {
        Schema::create('ndis_support_items', function (Blueprint $table) {
            $table->uuid('id')->primary();
            $table->string('support_item_number', 20)->unique();
            $table->string('support_item_name');
            $table->enum('category_type', ['CORE', 'CAPITAL', 'CAPACITY_BUILDING']);
            $table->enum('unit_of_measure', ['HOUR', 'EACH', 'WEEK', 'MONTH']);
            $table->bigInteger('price_cents')->unsigned();
            $table->date('effective_from');
            $table->date('effective_to')->nullable();
            $table->timestamps();

            $table->index('support_item_number');
            $table->index(['category_type', 'effective_from']);
        });
    }

    public function down(): void
    {
        Schema::dropIfExists('ndis_support_items');
    }
};

