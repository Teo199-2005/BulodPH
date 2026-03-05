<?php

declare(strict_types=1);

use App\Http\Controllers\Api\AuthController;
use App\Http\Controllers\Api\AffiliateApplicationController;
use App\Http\Controllers\Api\ActivityLogController;
use App\Http\Controllers\Api\AdminCarOwnerController;
use App\Http\Controllers\Api\AnnouncementController;
use App\Http\Controllers\Api\AdminClientController;
use App\Http\Controllers\Api\AdminMarketingStaffController;
use App\Http\Controllers\Api\BlogPostController;
use App\Http\Controllers\Api\CancellationController;
use App\Http\Controllers\Api\CartController;
use App\Http\Controllers\Api\CarRentalProfileController;
use App\Http\Controllers\Api\CarRentalStubController;
use App\Http\Controllers\Api\ClientController;
use App\Http\Controllers\Api\CityPageController;
use App\Http\Controllers\Api\DisputeController;
use App\Http\Controllers\Api\EmailTemplateController;
use App\Http\Controllers\Api\FavoriteController;
use App\Http\Controllers\Api\FraudRiskController;
use App\Http\Controllers\Api\InsuranceClaimController;
use App\Http\Controllers\Api\InsurancePlanController;
use App\Http\Controllers\Api\InsuranceSelectionController;
use App\Http\Controllers\Api\InvoiceController;
use App\Http\Controllers\Api\KycController;
use App\Http\Controllers\Api\MessageController;
use App\Http\Controllers\Api\MessageThreadController;
use App\Http\Controllers\Api\NDISPlanController;
use App\Http\Controllers\Api\PaymentController;
use App\Http\Controllers\Api\AdminEmailSettingsController;
use App\Http\Controllers\Api\EmailVerificationController;
use App\Http\Controllers\Api\PaymentQrSettingsController;
use App\Http\Controllers\Api\PayoutController;
use App\Http\Controllers\Api\PaymentWebhookLogController;
use App\Http\Controllers\Api\PromoCodeController;
use App\Http\Controllers\Api\ReceiptController;
use App\Http\Controllers\Api\RefundController;
use App\Http\Controllers\Api\ReportController;
use App\Http\Controllers\Api\RentalBookingController;
use App\Http\Controllers\Api\ReviewController;
use App\Http\Controllers\Api\RolePermissionController;
use App\Http\Controllers\Api\RewardPointController;
use App\Http\Controllers\Api\RewardTierController;
use App\Http\Controllers\Api\ShiftController;
use App\Http\Controllers\Api\StaffController;
use App\Http\Controllers\Api\SupportTicketController;
use App\Http\Controllers\Api\SystemLogController;
use App\Http\Controllers\Api\TrustSafetyPolicyController;
use App\Http\Controllers\Api\VehicleController;
use Illuminate\Support\Facades\Route;

// Health check (no middleware) – if this returns 200, API bootstrap works
Route::get('/ping', fn () => response()->json(['ok' => true]));

// Login without throttle so cache/session issues don't cause 500 (re-add throttle after fixing)
Route::post('/login', [AuthController::class, 'login']);
Route::middleware(['throttle:10,1'])->group(function () {
    Route::post('/register', [AuthController::class, 'register']);
    Route::post('/forgot-password', [AuthController::class, 'forgotPassword']);
});
Route::middleware(['throttle:5,1'])->group(function () {
    Route::post('/reset-password', [AuthController::class, 'resetPassword']);
});

// Public content
Route::get('/trust-safety', [TrustSafetyPolicyController::class, 'index']);
Route::get('/blog-posts', [BlogPostController::class, 'index']);
Route::get('/blog-posts/{post}', [BlogPostController::class, 'show']);
Route::get('/city-pages', [CityPageController::class, 'index']);
Route::get('/city-pages/{cityPage}', [CityPageController::class, 'show']);
Route::post('/affiliate/apply', [AffiliateApplicationController::class, 'store']);

// Public: browse car rentals (no auth required so clients and guests see real data)
Route::get('/car-rentals', [CarRentalProfileController::class, 'index']);
Route::get('/car-rentals/logo/{id}', [CarRentalProfileController::class, 'streamLogo']);
Route::get('/car-rentals/{id}', [CarRentalProfileController::class, 'showPublic']);

// Public: payment QR codes (GCash/Maya) so clients can load them when paying without auth issues
Route::get('/public/payment-qr', [PaymentQrSettingsController::class, 'showPublic']);

// Protected routes
Route::middleware(['auth:sanctum', 'audit.request'])->group(function () {
    // Auth
    Route::post('/logout', [AuthController::class, 'logout']);
    Route::get('/me', [AuthController::class, 'me']);

    // Email verification OTP (client, car_owner, marketing_staff only; admin excluded)
    Route::post('/email-verification/send-otp', [EmailVerificationController::class, 'sendOtp'])->middleware('throttle:3,1');
    Route::post('/email-verification/verify', [EmailVerificationController::class, 'verify']);

    // Shifts
    Route::apiResource('shifts', ShiftController::class);
    Route::post('/shifts/{shift}/clock-in', [ShiftController::class, 'clockIn']);
    Route::post('/shifts/{shift}/clock-out', [ShiftController::class, 'clockOut']);
    Route::post('/shifts/{shift}/cancel', [ShiftController::class, 'cancel']);

    // Clients
    Route::apiResource('clients', ClientController::class);

    // NDIS Plans
    Route::apiResource('ndis-plans', NDISPlanController::class);
    Route::get('/ndis-plans/{plan}/budget-summary', [NDISPlanController::class, 'budgetSummary']);

    // Car rental stubs (BulodPH) - return empty data until full backend is implemented
    $stub = CarRentalStubController::class;
    Route::get('/dashboard/kpis', [$stub, 'dashboardKpis']);
    Route::get('/dashboard/weekly-bookings', [$stub, 'weeklyBookings']);
    Route::get('/dashboard/car-types', [$stub, 'carTypes']);
    Route::get('/profile', [$stub, 'profile']);
    Route::put('/profile', [$stub, 'updateProfile']);
    Route::post('/profile/avatar', [$stub, 'profileAvatar']);
    Route::post('/profile/change-password', [$stub, 'changePassword']);
    Route::get('/cart', [CartController::class, 'index']);
    Route::post('/cart', [CartController::class, 'store']);
    Route::put('/cart/{id}', [CartController::class, 'update']);
    Route::delete('/cart/{id}', [CartController::class, 'destroy']);
    Route::get('/favorites', [FavoriteController::class, 'index']);
    Route::post('/favorites', [FavoriteController::class, 'store']);
    Route::delete('/favorites/{vehicleId}', [FavoriteController::class, 'destroy']);
    Route::get('/announcements', [AnnouncementController::class, 'index']);
    Route::get('/bookings', [RentalBookingController::class, 'index']);
    Route::get('/bookings/{id}', [RentalBookingController::class, 'show']);
    Route::post('/bookings', [RentalBookingController::class, 'store']);
    Route::patch('/bookings/{id}/status', [RentalBookingController::class, 'updateStatus']);
    Route::patch('/bookings/{id}/archive', [RentalBookingController::class, 'archive']);
    Route::post('/bookings/{id}/mark-paid', [RentalBookingController::class, 'markPaid']);
    Route::get('/client/bookings', [RentalBookingController::class, 'clientIndex']);
    Route::patch('/client/bookings/{id}/cancel', [RentalBookingController::class, 'clientCancel']);
    Route::get('/vehicles', [VehicleController::class, 'index']);
    Route::get('/vehicles/{id}', [VehicleController::class, 'show']);
    Route::post('/vehicles', [VehicleController::class, 'store']);
    Route::put('/vehicles/{id}', [VehicleController::class, 'update']);
    Route::delete('/vehicles/{id}', [VehicleController::class, 'destroy']);
    // Payouts: request (car_owner/marketing), pending/history for any auth user
    Route::post('/payouts', [PayoutController::class, 'store']);
    Route::get('/payouts/pending', [PayoutController::class, 'pending']);
    Route::get('/payouts/history', [PayoutController::class, 'history']);
    // Car owner only: rental profile
    Route::middleware(['role:car_owner'])->group(function () {
        Route::get('/car-owner/rental-profile', [CarRentalProfileController::class, 'show']);
        Route::put('/car-owner/rental-profile', [CarRentalProfileController::class, 'update']);
        Route::post('/car-owner/rental-profile/logo', [CarRentalProfileController::class, 'uploadLogo']);

        Route::get('/car-owner/bookings', [RentalBookingController::class, 'carOwnerIndex']);
        Route::get('/car-owner/bookings/unseen', [RentalBookingController::class, 'carOwnerUnseen']);
        Route::post('/car-owner/bookings/mark-seen', [RentalBookingController::class, 'carOwnerMarkSeen']);
        Route::patch('/car-owner/bookings/{id}/status', [RentalBookingController::class, 'carOwnerUpdateStatus']);
    });

    // Admin only: clients, car-owners, marketing, reports, announcements, payouts approve/reject
    Route::middleware(['role:admin'])->group(function () {
        Route::post('/payouts/{id}/approve', [PayoutController::class, 'approve']);
        Route::post('/payouts/{id}/reject', [PayoutController::class, 'reject']);
        Route::get('/admin/clients', [AdminClientController::class, 'index']);
        Route::get('/admin/clients/{id}/bookings', [RentalBookingController::class, 'clientBookingsForAdmin']);
        Route::post('/bookings/{id}/cancel-request/approve', [RentalBookingController::class, 'adminApproveCancellation']);
        Route::post('/bookings/{id}/cancel-request/reject', [RentalBookingController::class, 'adminRejectCancellation']);
        Route::get('/admin/clients/{id}', [AdminClientController::class, 'show']);
        Route::post('/admin/clients', [AdminClientController::class, 'store']);
        Route::put('/admin/clients/{id}', [AdminClientController::class, 'update']);
        Route::delete('/admin/clients/{id}', [AdminClientController::class, 'destroy']);
        Route::get('/admin/car-owners', [AdminCarOwnerController::class, 'index']);
        Route::get('/admin/car-owners/{id}', [AdminCarOwnerController::class, 'show']);
        Route::post('/admin/car-owners', [AdminCarOwnerController::class, 'store']);
        Route::put('/admin/car-owners/{id}', [AdminCarOwnerController::class, 'update']);
        Route::delete('/admin/car-owners/{id}', [AdminCarOwnerController::class, 'destroy']);
        Route::get('/admin/marketing-staff', [AdminMarketingStaffController::class, 'index']);
        Route::get('/admin/marketing-staff/{id}', [AdminMarketingStaffController::class, 'show']);
        Route::post('/admin/marketing-staff', [AdminMarketingStaffController::class, 'store']);
        Route::put('/admin/marketing-staff/{id}', [AdminMarketingStaffController::class, 'update']);
        Route::delete('/admin/marketing-staff/{id}', [AdminMarketingStaffController::class, 'destroy']);
        Route::get('/reports/financial', [ReportController::class, 'financial']);
        Route::get('/reports/bookings', [ReportController::class, 'bookings']);
        Route::get('/staff', [StaffController::class, 'index']);
        Route::post('/announcements/send', [AnnouncementController::class, 'send']);
    });
    Route::get('/settings/payment-qr', [PaymentQrSettingsController::class, 'show']);
    Route::post('/payments/create', [PaymentController::class, 'create']);
    Route::get('/payments/status/{ref}', [PaymentController::class, 'status']);

    // Trust & Safety (admin manage)
    Route::middleware(['role:admin'])->group(function () {
        Route::post('/trust-safety', [TrustSafetyPolicyController::class, 'store']);
        Route::put('/trust-safety/{policy}', [TrustSafetyPolicyController::class, 'update']);
        Route::delete('/trust-safety/{policy}', [TrustSafetyPolicyController::class, 'destroy']);
    });

    // Disputes
    Route::get('/disputes', [DisputeController::class, 'index']);
    Route::post('/disputes', [DisputeController::class, 'store']);
    Route::get('/disputes/{dispute}', [DisputeController::class, 'show']);
    Route::post('/disputes/{dispute}/evidence', [DisputeController::class, 'addEvidence']);
    Route::middleware(['role:admin'])->group(function () {
        Route::patch('/disputes/{dispute}/status', [DisputeController::class, 'updateStatus']);
    });

    // Reviews
    Route::get('/reviews', [ReviewController::class, 'index']);
    Route::post('/reviews', [ReviewController::class, 'store']);
    Route::middleware(['role:admin'])->group(function () {
        Route::patch('/reviews/{review}/status', [ReviewController::class, 'updateStatus']);
    });

    // KYC
    Route::post('/kyc/submit', [KycController::class, 'submit']);
    Route::get('/kyc/status', [KycController::class, 'status']);
    Route::middleware(['role:admin'])->group(function () {
        Route::get('/admin/kyc', [KycController::class, 'list']);
        Route::patch('/admin/kyc/{submission}', [KycController::class, 'review']);
    });

    // Cancellations & refunds
    Route::get('/cancellations', [CancellationController::class, 'index']);
    Route::post('/cancellations', [CancellationController::class, 'store']);
    Route::get('/cancellations/{cancellation}', [CancellationController::class, 'show']);
    Route::middleware(['role:admin'])->group(function () {
        Route::post('/cancellations/{cancellation}/refund', [CancellationController::class, 'createRefund']);
    });
    Route::get('/refunds', [RefundController::class, 'index']);
    Route::get('/refunds/{refund}', [RefundController::class, 'show']);

    // Messaging
    Route::get('/messages/threads', [MessageThreadController::class, 'index']);
    Route::post('/messages/threads', [MessageThreadController::class, 'store']);
    Route::get('/messages/threads/{thread}', [MessageThreadController::class, 'show']);
    Route::post('/messages/threads/{thread}', [MessageController::class, 'store']);

    // Insurance
    Route::get('/insurance/plans', [InsurancePlanController::class, 'index']);
    Route::post('/insurance/plans', [InsurancePlanController::class, 'store'])->middleware(['role:admin']);
    Route::put('/insurance/plans/{plan}', [InsurancePlanController::class, 'update'])->middleware(['role:admin']);
    Route::get('/insurance/selections', [InsuranceSelectionController::class, 'index']);
    Route::post('/insurance/selections', [InsuranceSelectionController::class, 'store']);
    Route::get('/insurance/claims', [InsuranceClaimController::class, 'index']);
    Route::post('/insurance/claims', [InsuranceClaimController::class, 'store']);
    Route::patch('/insurance/claims/{claim}/status', [InsuranceClaimController::class, 'updateStatus'])->middleware(['role:admin']);

    // Invoices & receipts
    Route::get('/invoices', [InvoiceController::class, 'index']);
    Route::post('/invoices', [InvoiceController::class, 'store'])->middleware(['role:admin']);
    Route::get('/invoices/{invoice}', [InvoiceController::class, 'show']);
    Route::get('/receipts/{receipt}', [ReceiptController::class, 'show']);

    // Support tickets (user's own)
    Route::get('/support', [SupportTicketController::class, 'index']);
    Route::post('/support', [SupportTicketController::class, 'store']);

    // Promo code validation (code + days)
    Route::get('/promo/validate', [PromoCodeController::class, 'validate']);

    // Activity logs
    Route::get('/activity-logs', [ActivityLogController::class, 'index']);

    // Rewards
    Route::get('/rewards/tiers', [RewardTierController::class, 'index']);
    Route::post('/rewards/tiers', [RewardTierController::class, 'store'])->middleware(['role:admin']);
    Route::get('/rewards/points', [RewardPointController::class, 'index']);
    Route::post('/rewards/points', [RewardPointController::class, 'store'])->middleware(['role:admin']);

    // Affiliate applications (admin list/update)
    Route::middleware(['role:admin'])->group(function () {
        Route::get('/admin/affiliate-applications', [AffiliateApplicationController::class, 'index']);
        Route::patch('/admin/affiliate-applications/{application}', [AffiliateApplicationController::class, 'update']);
    });

    // Blog and city pages (admin manage)
    Route::middleware(['role:admin'])->group(function () {
        Route::post('/admin/blog-posts', [BlogPostController::class, 'store']);
        Route::put('/admin/blog-posts/{post}', [BlogPostController::class, 'update']);
        Route::post('/admin/city-pages', [CityPageController::class, 'store']);
        Route::put('/admin/city-pages/{cityPage}', [CityPageController::class, 'update']);
    });

    // Fraud & system logs (admin)
    Route::middleware(['role:admin'])->group(function () {
        Route::get('/admin/fraud-flags', [FraudRiskController::class, 'index']);
        Route::post('/admin/fraud-flags', [FraudRiskController::class, 'store']);
        Route::patch('/admin/fraud-flags/{fraud_risk_flag}', [FraudRiskController::class, 'update']);
        Route::get('/admin/system-logs', [SystemLogController::class, 'index']);
        Route::get('/admin/payment-webhooks', [PaymentWebhookLogController::class, 'index']);
        Route::get('/admin/email-templates', [EmailTemplateController::class, 'index']);
        Route::post('/admin/email-templates', [EmailTemplateController::class, 'store']);
        Route::put('/admin/email-templates/{template}', [EmailTemplateController::class, 'update']);
        Route::get('/admin/roles', [RolePermissionController::class, 'index']);
        Route::patch('/admin/roles/{role}/permissions', [RolePermissionController::class, 'updateRolePermissions']);
        Route::get('/admin/settings/payment-qr', [PaymentQrSettingsController::class, 'show']);
        Route::put('/admin/settings/payment-qr', [PaymentQrSettingsController::class, 'update']);
        Route::post('/admin/settings/test-email', [AdminEmailSettingsController::class, 'sendTestEmail']);
    });
});

