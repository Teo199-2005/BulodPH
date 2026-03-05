<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    public function up(): void
    {
        Schema::create('trust_safety_policies', function (Blueprint $table) {
            $table->uuid('id')->primary();
            $table->string('slug')->unique();
            $table->string('title');
            $table->longText('content');
            $table->boolean('is_published')->default(true);
            $table->foreignUuid('created_by')->nullable()->constrained('users')->nullOnDelete();
            $table->timestamps();
        });

        Schema::create('disputes', function (Blueprint $table) {
            $table->uuid('id')->primary();
            $table->string('booking_reference')->nullable()->index();
            $table->foreignUuid('opened_by_user_id')->constrained('users')->cascadeOnDelete();
            $table->foreignUuid('against_user_id')->nullable()->constrained('users')->nullOnDelete();
            $table->string('reason');
            $table->longText('description')->nullable();
            $table->string('status')->default('filed')->index();
            $table->timestamps();
        });

        Schema::create('dispute_evidence', function (Blueprint $table) {
            $table->uuid('id')->primary();
            $table->foreignUuid('dispute_id')->constrained('disputes')->cascadeOnDelete();
            $table->foreignUuid('uploaded_by_user_id')->constrained('users')->cascadeOnDelete();
            $table->string('file_path');
            $table->string('mime')->nullable();
            $table->unsignedBigInteger('size')->nullable();
            $table->timestamps();
        });

        Schema::create('reviews', function (Blueprint $table) {
            $table->uuid('id')->primary();
            $table->string('booking_reference')->nullable()->index();
            $table->foreignUuid('reviewer_id')->constrained('users')->cascadeOnDelete();
            $table->foreignUuid('reviewee_id')->nullable()->constrained('users')->nullOnDelete();
            $table->string('vehicle_reference')->nullable()->index();
            $table->unsignedTinyInteger('rating');
            $table->longText('comment')->nullable();
            $table->string('status')->default('pending')->index();
            $table->timestamps();
        });

        Schema::create('kyc_submissions', function (Blueprint $table) {
            $table->uuid('id')->primary();
            $table->foreignUuid('user_id')->constrained('users')->cascadeOnDelete();
            $table->string('status')->default('pending')->index();
            $table->string('id_type')->nullable();
            $table->string('id_number')->nullable();
            $table->string('id_front_path')->nullable();
            $table->string('id_back_path')->nullable();
            $table->string('license_path')->nullable();
            $table->string('selfie_path')->nullable();
            $table->foreignUuid('reviewed_by_user_id')->nullable()->constrained('users')->nullOnDelete();
            $table->timestamp('reviewed_at')->nullable();
            $table->string('rejection_reason')->nullable();
            $table->timestamps();
        });

        Schema::create('cancellation_requests', function (Blueprint $table) {
            $table->uuid('id')->primary();
            $table->string('booking_reference')->nullable()->index();
            $table->foreignUuid('user_id')->constrained('users')->cascadeOnDelete();
            $table->string('reason')->nullable();
            $table->string('status')->default('requested')->index();
            $table->timestamp('requested_at')->useCurrent();
            $table->timestamps();
        });

        Schema::create('refunds', function (Blueprint $table) {
            $table->uuid('id')->primary();
            $table->foreignUuid('cancellation_request_id')->constrained('cancellation_requests')->cascadeOnDelete();
            $table->decimal('amount', 10, 2)->default(0);
            $table->string('currency', 8)->default('PHP');
            $table->string('status')->default('pending')->index();
            $table->string('reference')->nullable();
            $table->timestamp('processed_at')->nullable();
            $table->timestamps();
        });

        Schema::create('message_threads', function (Blueprint $table) {
            $table->uuid('id')->primary();
            $table->string('booking_reference')->nullable()->index();
            $table->foreignUuid('client_id')->constrained('users')->cascadeOnDelete();
            $table->foreignUuid('owner_id')->constrained('users')->cascadeOnDelete();
            $table->string('status')->default('open')->index();
            $table->timestamps();
        });

        Schema::create('messages', function (Blueprint $table) {
            $table->uuid('id')->primary();
            $table->foreignUuid('thread_id')->constrained('message_threads')->cascadeOnDelete();
            $table->foreignUuid('sender_id')->constrained('users')->cascadeOnDelete();
            $table->longText('body')->nullable();
            $table->string('attachment_path')->nullable();
            $table->string('attachment_mime')->nullable();
            $table->unsignedBigInteger('attachment_size')->nullable();
            $table->timestamps();
        });

        Schema::create('insurance_plans', function (Blueprint $table) {
            $table->uuid('id')->primary();
            $table->string('name');
            $table->longText('description')->nullable();
            $table->decimal('price', 10, 2)->default(0);
            $table->string('currency', 8)->default('PHP');
            $table->longText('coverage_details')->nullable();
            $table->boolean('is_active')->default(true);
            $table->timestamps();
        });

        Schema::create('insurance_selections', function (Blueprint $table) {
            $table->uuid('id')->primary();
            $table->string('booking_reference')->nullable()->index();
            $table->foreignUuid('user_id')->constrained('users')->cascadeOnDelete();
            $table->foreignUuid('insurance_plan_id')->constrained('insurance_plans')->cascadeOnDelete();
            $table->string('status')->default('selected')->index();
            $table->timestamps();
        });

        Schema::create('insurance_claims', function (Blueprint $table) {
            $table->uuid('id')->primary();
            $table->foreignUuid('insurance_selection_id')->constrained('insurance_selections')->cascadeOnDelete();
            $table->foreignUuid('user_id')->constrained('users')->cascadeOnDelete();
            $table->longText('description')->nullable();
            $table->decimal('claim_amount', 10, 2)->default(0);
            $table->string('status')->default('submitted')->index();
            $table->string('evidence_path')->nullable();
            $table->timestamps();
        });

        Schema::create('invoices', function (Blueprint $table) {
            $table->uuid('id')->primary();
            $table->string('booking_reference')->nullable()->index();
            $table->foreignUuid('user_id')->nullable()->constrained('users')->nullOnDelete();
            $table->foreignUuid('owner_id')->nullable()->constrained('users')->nullOnDelete();
            $table->decimal('subtotal', 10, 2)->default(0);
            $table->decimal('taxes', 10, 2)->default(0);
            $table->decimal('total', 10, 2)->default(0);
            $table->string('currency', 8)->default('PHP');
            $table->string('status')->default('issued')->index();
            $table->string('pdf_path')->nullable();
            $table->timestamps();
        });

        Schema::create('receipts', function (Blueprint $table) {
            $table->uuid('id')->primary();
            $table->foreignUuid('invoice_id')->constrained('invoices')->cascadeOnDelete();
            $table->string('official_receipt_number')->nullable()->index();
            $table->timestamp('issued_at')->nullable();
            $table->string('pdf_path')->nullable();
            $table->timestamps();
        });

        Schema::create('activity_logs', function (Blueprint $table) {
            $table->uuid('id')->primary();
            $table->foreignUuid('user_id')->nullable()->constrained('users')->nullOnDelete();
            $table->string('action')->index();
            $table->json('metadata')->nullable();
            $table->string('ip_address', 45)->nullable();
            $table->text('user_agent')->nullable();
            $table->timestamps();
        });

        Schema::create('reward_tiers', function (Blueprint $table) {
            $table->uuid('id')->primary();
            $table->string('name');
            $table->unsignedInteger('min_points')->default(0);
            $table->longText('benefits')->nullable();
            $table->timestamps();
        });

        Schema::create('reward_points', function (Blueprint $table) {
            $table->uuid('id')->primary();
            $table->foreignUuid('user_id')->constrained('users')->cascadeOnDelete();
            $table->integer('points_delta');
            $table->integer('balance_after')->default(0);
            $table->string('reason')->nullable();
            $table->timestamps();
        });

        Schema::create('affiliate_applications', function (Blueprint $table) {
            $table->uuid('id')->primary();
            $table->string('name');
            $table->string('email');
            $table->string('company')->nullable();
            $table->string('status')->default('pending')->index();
            $table->longText('notes')->nullable();
            $table->timestamps();
        });

        Schema::create('blog_posts', function (Blueprint $table) {
            $table->uuid('id')->primary();
            $table->string('slug')->unique();
            $table->string('title');
            $table->longText('content');
            $table->string('status')->default('draft')->index();
            $table->timestamp('published_at')->nullable();
            $table->timestamps();
        });

        Schema::create('city_pages', function (Blueprint $table) {
            $table->uuid('id')->primary();
            $table->string('slug')->unique();
            $table->string('city');
            $table->longText('content');
            $table->string('status')->default('draft')->index();
            $table->timestamp('published_at')->nullable();
            $table->timestamps();
        });

        Schema::create('fraud_risk_flags', function (Blueprint $table) {
            $table->uuid('id')->primary();
            $table->foreignUuid('user_id')->nullable()->constrained('users')->nullOnDelete();
            $table->string('booking_reference')->nullable()->index();
            $table->string('reason');
            $table->string('severity')->default('medium')->index();
            $table->string('status')->default('open')->index();
            $table->timestamps();
        });

        Schema::create('system_logs', function (Blueprint $table) {
            $table->uuid('id')->primary();
            $table->string('type')->index();
            $table->string('message');
            $table->json('context')->nullable();
            $table->timestamps();
        });

        Schema::create('payment_webhook_logs', function (Blueprint $table) {
            $table->uuid('id')->primary();
            $table->string('provider')->index();
            $table->string('event')->index();
            $table->string('reference')->nullable()->index();
            $table->json('payload')->nullable();
            $table->string('status')->default('received')->index();
            $table->timestamps();
        });

        Schema::create('email_templates', function (Blueprint $table) {
            $table->uuid('id')->primary();
            $table->string('name')->unique();
            $table->string('subject');
            $table->longText('body');
            $table->boolean('is_active')->default(true);
            $table->timestamps();
        });
    }

    public function down(): void
    {
        Schema::dropIfExists('email_templates');
        Schema::dropIfExists('payment_webhook_logs');
        Schema::dropIfExists('system_logs');
        Schema::dropIfExists('fraud_risk_flags');
        Schema::dropIfExists('city_pages');
        Schema::dropIfExists('blog_posts');
        Schema::dropIfExists('affiliate_applications');
        Schema::dropIfExists('reward_points');
        Schema::dropIfExists('reward_tiers');
        Schema::dropIfExists('activity_logs');
        Schema::dropIfExists('receipts');
        Schema::dropIfExists('invoices');
        Schema::dropIfExists('insurance_claims');
        Schema::dropIfExists('insurance_selections');
        Schema::dropIfExists('insurance_plans');
        Schema::dropIfExists('messages');
        Schema::dropIfExists('message_threads');
        Schema::dropIfExists('refunds');
        Schema::dropIfExists('cancellation_requests');
        Schema::dropIfExists('kyc_submissions');
        Schema::dropIfExists('reviews');
        Schema::dropIfExists('dispute_evidence');
        Schema::dropIfExists('disputes');
        Schema::dropIfExists('trust_safety_policies');
    }
};
