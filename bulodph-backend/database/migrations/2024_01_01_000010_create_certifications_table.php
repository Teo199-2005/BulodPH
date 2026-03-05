<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    public function up(): void
    {
        Schema::create('certifications', function (Blueprint $table) {
            $table->uuid('id')->primary();
            $table->uuid('user_id');
            $table->enum('certification_type', [
                'FIRST_AID',
                'CPR',
                'NDIS_WORKER_SCREENING',
                'WWCC',
                'MANUAL_HANDLING',
                'MEDICATION_ADMINISTRATION'
            ]);
            $table->string('certification_number');
            $table->date('issued_date');
            $table->date('expiry_date');
            $table->string('document_path')->nullable();
            $table->timestamps();

            $table->foreign('user_id')
                ->references('id')
                ->on('users')
                ->cascadeOnDelete();

            $table->index(['user_id', 'expiry_date']);
        });
    }

    public function down(): void
    {
        Schema::dropIfExists('certifications');
    }
};

