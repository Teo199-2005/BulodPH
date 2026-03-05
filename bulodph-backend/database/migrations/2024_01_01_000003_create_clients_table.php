<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    public function up(): void
    {
        Schema::create('clients', function (Blueprint $table) {
            $table->uuid('id')->primary();
            $table->uuid('organization_id');
            $table->string('ndis_number', 9)->unique();
            $table->string('first_name');
            $table->string('last_name');
            $table->date('date_of_birth');
            $table->string('address_line_1');
            $table->string('address_line_2')->nullable();
            $table->string('suburb');
            $table->enum('state', ['NSW', 'VIC', 'QLD', 'SA', 'WA', 'TAS', 'NT', 'ACT']);
            $table->string('postcode', 4);
            $table->decimal('latitude', 10, 7)->nullable();
            $table->decimal('longitude', 10, 7)->nullable();
            $table->string('emergency_contact_name');
            $table->string('emergency_contact_phone', 20);
            $table->timestamps();

            $table->foreign('organization_id')
                ->references('id')
                ->on('organizations')
                ->restrictOnDelete();

            $table->index(['organization_id', 'ndis_number']);
        });
    }

    public function down(): void
    {
        Schema::dropIfExists('clients');
    }
};

