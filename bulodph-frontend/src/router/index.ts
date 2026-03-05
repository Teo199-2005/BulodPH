import { createRouter, createWebHistory } from 'vue-router'
import { useUserSessionStore } from '@/stores/userSession'
import { useAgreementAcceptanceStore } from '@/stores/agreementAcceptance'
import MobileLayout from '@/layouts/MobileLayout.vue'

const router = createRouter({
  history: createWebHistory(import.meta.env.BASE_URL),
  routes: [
    {
      path: '/',
      name: 'landing',
      component: () => import('@/views/LandingPage.vue'),
      meta: { title: 'Home', requiresAuth: false, layout: false, description: 'Car rental marketplace in the Philippines. Browse and book from local rental partners with BulodPH.' },
    },
    {
      path: '/about',
      name: 'about',
      component: () => import('@/views/public/AboutUsView.vue'),
      meta: { title: 'About Us', requiresAuth: false, layout: false, description: 'Learn about BulodPH, our mission, and the team behind the leading car-sharing platform in the Philippines.' },
    },
    {
      path: '/fleet',
      name: 'fleet',
      component: () => import('@/views/public/PublicFleetView.vue'),
      meta: { title: 'Car Rental', requiresAuth: false, layout: false, description: 'Browse our extensive fleet of rental cars across the Philippines. Find the perfect ride for your next trip.' },
    },
    {
      path: '/contact',
      name: 'contact',
      component: () => import('@/views/public/ContactUsView.vue'),
      meta: { title: 'Contact Us', requiresAuth: false, layout: false, description: 'Get in touch with BulodPH. Our customer support team is here to help you 24/7 with your car rental needs.' },
    },
    {
      path: '/faq',
      name: 'faq',
      component: () => import('@/views/public/FaqView.vue'),
      meta: { title: 'FAQ', requiresAuth: false, layout: false, description: 'Find answers to frequently asked questions about the BulodPH car rental marketplace.' },
    },
    {
      path: '/login',
      name: 'login',
      component: () => import('@/views/LoginView.vue'),
      meta: { requiresAuth: false, layout: false, description: 'Sign in to BulodPH to manage your car rentals, listings, and account settings.' },
    },
    {
      path: '/register',
      name: 'register',
      component: () => import('@/views/RegisterView.vue'),
      meta: { requiresAuth: false, layout: false, description: 'Join BulodPH today. Sign up to start renting cars or earning money by listing your vehicle.' },
    },
    {
      path: '/forgot-password',
      name: 'forgot-password',
      component: () => import('@/views/ForgotPasswordView.vue'),
      meta: { requiresAuth: false, layout: false, description: 'Reset your BulodPH password securely.' },
    },
    {
      path: '/reset-password',
      name: 'reset-password',
      component: () => import('@/views/ResetPasswordView.vue'),
      meta: { requiresAuth: false, layout: false, description: 'Enter your new password to secure your BulodPH account.' },
    },
    {
      path: '/verify-email',
      name: 'verify-email',
      component: () => import('@/views/VerifyEmailView.vue'),
      meta: { requiresAuth: true, layout: false, title: 'Verify email', description: 'Enter the code we sent to your email.' },
    },
    {
      path: '/privacy',
      name: 'privacy',
      component: () => import('@/views/PrivacyPolicyView.vue'),
      meta: { requiresAuth: false, layout: false, description: 'Learn how BulodPH protects your data and privacy.' },
    },
    {
      path: '/terms',
      name: 'terms',
      component: () => import('@/views/TermsOfServiceView.vue'),
      meta: { requiresAuth: false, layout: false, description: 'Review the terms of service and rules for using the BulodPH car-sharing platform.' },
    },
    {
      path: '/accessibility',
      name: 'accessibility',
      component: () => import('@/views/AccessibilityStatementView.vue'),
      meta: { requiresAuth: false, layout: false, description: 'BulodPH accessibility statement and commitment to inclusive design.' },
    },
    {
      path: '/trust-safety',
      name: 'trust-safety',
      component: () => import('@/views/TrustSafetyView.vue'),
      meta: { requiresAuth: false, layout: false, description: 'Our commitment to trust, safety, and security for all renters and car owners on BulodPH.' },
    },
    {
      path: '/partners',
      name: 'affiliate-apply',
      component: () => import('@/views/AffiliateApplyView.vue'),
      meta: { requiresAuth: false, layout: false, description: 'Apply to become a BulodPH affiliate partner and earn rewards for referrals.' },
    },
    {
      path: '/blog',
      name: 'blog',
      component: () => import('@/views/BlogIndexView.vue'),
      meta: { title: 'Blog', requiresAuth: false, layout: false, description: 'Read the latest news, car rental tips, and road trip guides from the BulodPH team.' },
    },
    {
      path: '/blog/:id',
      name: 'blog-post',
      component: () => import('@/views/BlogPostView.vue'),
      meta: { requiresAuth: false, layout: false, description: 'Read our latest blog post about car sharing and travel in the Philippines.' },
    },
    {
      path: '/city/:slug',
      name: 'city-page',
      component: () => import('@/views/CityPageView.vue'),
      meta: { requiresAuth: false, layout: false, description: 'Find cars for rent in your city. Browse car rentals on the BulodPH marketplace.' },
    },
    // All dashboard routes use MobileLayout and render inside it via child route
    {
      path: '/',
      component: MobileLayout,
      meta: { requiresAuth: true },
      children: [
        {
          path: 'dashboard',
          name: 'dashboard',
          component: () => import('@/views/DashboardView.vue'),
        },
        {
          path: 'client',
          name: 'client-dashboard',
          component: () => import('@/views/DashboardView.vue'),
          meta: { role: 'client' },
        },
        {
          path: 'admin',
          name: 'admin-dashboard',
          component: () => import('@/views/DashboardView.vue'),
          meta: { role: 'admin' },
        },
        {
          path: 'car-owner',
          name: 'car-owner-dashboard',
          component: () => import('@/views/DashboardView.vue'),
          meta: { role: 'car_owner' },
        },
        {
          path: 'marketing',
          name: 'marketing-dashboard',
          component: () => import('@/views/DashboardView.vue'),
          meta: { role: 'marketing_staff' },
        },
        /* Client */
        { path: 'client/browse', name: 'client-browse', component: () => import('@/views/client/ClientBrowseView.vue'), meta: { title: 'Browse rides', subtitle: 'Find a ride throughout the region.' } },
        { path: 'client/browse-rentals', name: 'client-browse-rentals', component: () => import('@/views/client/ClientBrowseRentalsView.vue'), meta: { title: 'Browse car rentals', subtitle: 'Find rental companies and their fleets.' } },
        { path: 'client/rentals/:id', name: 'client-rental-detail', component: () => import('@/views/client/ClientRentalDetailView.vue'), meta: { title: 'Car rental', subtitle: 'Profile and fleet.' } },
        { path: 'client/browse/:id', name: 'client-vehicle-detail', component: () => import('@/views/client/ClientVehicleDetailView.vue'), meta: { title: 'Vehicle', subtitle: 'Details and book.' } },
        { path: 'client/bookings', name: 'client-bookings', component: () => import('@/views/client/ClientBookingsView.vue'), meta: { title: 'My bookings', subtitle: 'Upcoming and past trips.' } },
        { path: 'client/bookings/new', name: 'client-booking-new', component: () => import('@/views/client/ClientScheduleBookingView.vue'), meta: { title: 'Schedule booking', subtitle: 'Pick dates and confirm.' } },
        { path: 'client/bookings/:id', name: 'client-booking-detail', component: () => import('@/views/client/ClientBookingDetailView.vue'), meta: { title: 'Booking', subtitle: 'Details and actions.' } },
        { path: 'client/checkout', name: 'client-checkout', component: () => import('@/views/client/ClientCheckoutView.vue'), meta: { title: 'Checkout', subtitle: 'Review and pay.' } },
        { path: 'client/cart', name: 'client-cart', component: () => import('@/views/client/ClientCartView.vue'), meta: { title: 'Cart', subtitle: 'Your selected rides.' } },
        { path: 'client/payments', name: 'client-payments', component: () => import('@/views/client/ClientPaymentsView.vue'), meta: { title: 'Payments', subtitle: 'GCash, Maya and payment methods.' } },
        { path: 'client/promo', name: 'client-promo', component: () => import('@/views/client/ClientPromoView.vue'), meta: { title: 'Promos', subtitle: 'Discounts and offers.' } },
        { path: 'client/favorites', name: 'client-favorites', component: () => import('@/views/client/ClientFavoritesView.vue'), meta: { title: 'Favorites', subtitle: 'Your saved vehicles.' } },
        { path: 'client/help', name: 'client-help', component: () => import('@/views/client/ClientHelpView.vue'), meta: { title: 'Help & FAQ', subtitle: 'How to book and rental policies.' } },
        { path: 'client/support', name: 'client-support', component: () => import('@/views/client/ClientSupportView.vue'), meta: { title: 'Contact support', subtitle: 'Get in touch with BulodPH.' } },
        { path: 'client/disputes', name: 'client-disputes', component: () => import('@/views/DisputesView.vue'), meta: { title: 'Disputes & Resolution', subtitle: 'Report issues and track status.' } },
        { path: 'client/disputes/:id', name: 'client-dispute-detail', component: () => import('@/views/DisputeDetailView.vue'), meta: { title: 'Dispute details', subtitle: 'Upload evidence and track updates.' } },
        { path: 'client/reviews', name: 'client-reviews', component: () => import('@/views/ReviewsView.vue'), meta: { title: 'Reviews & Ratings', subtitle: 'Leave feedback after trips.' } },
        { path: 'client/kyc', name: 'client-kyc', component: () => import('@/views/KycVerificationView.vue'), meta: { title: 'ID Verification', subtitle: 'Upload documents for verification.' } },
        { path: 'client/cancellations', name: 'client-cancellations', component: () => import('@/views/CancellationRefundView.vue'), meta: { title: 'Cancellations & Refunds', subtitle: 'Cancel bookings and track refunds.' } },
        { path: 'client/messages', name: 'client-messages', component: () => import('@/views/MessagingView.vue'), meta: { title: 'Messages', subtitle: 'Chat with rental partners.' } },
        { path: 'client/insurance', name: 'client-insurance', component: () => import('@/views/InsuranceView.vue'), meta: { title: 'Insurance', subtitle: 'Choose coverage and submit claims.' } },
        { path: 'client/tax-invoicing', name: 'client-tax-invoicing', component: () => import('@/views/TaxInvoicingView.vue'), meta: { title: 'Tax & Invoicing', subtitle: 'Download invoices and receipts.' } },
        { path: 'client/activity', name: 'client-activity', component: () => import('@/views/ActivityLogsView.vue'), meta: { title: 'Account activity', subtitle: 'Login history and changes.' } },
        { path: 'client/rewards', name: 'client-rewards', component: () => import('@/views/RewardsView.vue'), meta: { title: 'Rewards & Loyalty', subtitle: 'Points and tier benefits.' } },
        /* Car owner */
        { path: 'car-owner/agreement', name: 'car-owner-agreement', component: () => import('@/views/car-owner/CarOwnerAgreementView.vue'), meta: { title: 'Platform Agreement', subtitle: 'Read and accept to continue.', requiresCarOwnerAgreement: false } },
        { path: 'car-owner/vehicles', name: 'car-owner-vehicles', component: () => import('@/views/car-owner/CarOwnerVehiclesView.vue'), meta: { title: 'My vehicles', subtitle: 'List and manage your vehicles.' } },
        { path: 'car-owner/vehicles/new', name: 'car-owner-vehicle-new', component: () => import('@/views/car-owner/CarOwnerVehicleFormView.vue'), meta: { title: 'Add vehicle', subtitle: 'List your car.' } },
        { path: 'car-owner/vehicles/:id/edit', name: 'car-owner-vehicle-edit', component: () => import('@/views/car-owner/CarOwnerVehicleFormView.vue'), meta: { title: 'Edit vehicle', subtitle: 'Update your listing.' } },
        { path: 'car-owner/bookings', name: 'car-owner-bookings', component: () => import('@/views/car-owner/CarOwnerBookingsView.vue'), meta: { title: 'Bookings', subtitle: 'Hand-offs and trip history.' } },
        { path: 'car-owner/bookings/:id', name: 'car-owner-booking-detail', component: () => import('@/views/car-owner/CarOwnerBookingDetailView.vue'), meta: { title: 'Booking', subtitle: 'Details and actions.' } },
        { path: 'car-owner/earnings', name: 'car-owner-earnings', component: () => import('@/views/car-owner/CarOwnerEarningsView.vue'), meta: { title: 'Earnings', subtitle: 'Payouts and balance.' } },
        { path: 'car-owner/payout-method', name: 'car-owner-payout-method', component: () => import('@/views/car-owner/CarOwnerPayoutMethodView.vue'), meta: { title: 'Payout method', subtitle: 'Receive payouts via GCash, Maya or bank.' } },
        { path: 'car-owner/calendar', name: 'car-owner-calendar', component: () => import('@/views/car-owner/CarOwnerCalendarView.vue'), meta: { title: 'Calendar', subtitle: 'Availability and bookings.' } },
        { path: 'car-owner/profile', redirect: { name: 'profile' } },
        { path: 'car-owner/help', name: 'car-owner-help', component: () => import('@/views/car-owner/CarOwnerHelpView.vue'), meta: { title: 'Help & getting started', subtitle: 'How to list and hand off.' } },
        { path: 'car-owner/payout-history', name: 'car-owner-payout-history', component: () => import('@/views/car-owner/CarOwnerPayoutHistoryView.vue'), meta: { title: 'Payout history', subtitle: 'Past payouts and status.' } },
        { path: 'car-owner/disputes', name: 'car-owner-disputes', component: () => import('@/views/DisputesView.vue'), meta: { title: 'Disputes & Resolution', subtitle: 'Handle renter disputes and evidence.' } },
        { path: 'car-owner/disputes/:id', name: 'car-owner-dispute-detail', component: () => import('@/views/DisputeDetailView.vue'), meta: { title: 'Dispute details', subtitle: 'Upload evidence and track updates.' } },
        { path: 'car-owner/reviews', name: 'car-owner-reviews', component: () => import('@/views/ReviewsView.vue'), meta: { title: 'Reviews & Ratings', subtitle: 'View feedback on your rentals.' } },
        { path: 'car-owner/messages', name: 'car-owner-messages', component: () => import('@/views/MessagingView.vue'), meta: { title: 'Messages', subtitle: 'Chat with renters.' } },
        { path: 'car-owner/insurance', name: 'car-owner-insurance', component: () => import('@/views/InsuranceView.vue'), meta: { title: 'Insurance', subtitle: 'Plans and claims.' } },
        { path: 'car-owner/tax-invoicing', name: 'car-owner-tax-invoicing', component: () => import('@/views/TaxInvoicingView.vue'), meta: { title: 'Tax & Invoicing', subtitle: 'Commission and tax summary.' } },
        { path: 'car-owner/activity', name: 'car-owner-activity', component: () => import('@/views/ActivityLogsView.vue'), meta: { title: 'Account activity', subtitle: 'Login history and changes.' } },
        { path: 'car-owner/rewards', name: 'car-owner-rewards', component: () => import('@/views/RewardsView.vue'), meta: { title: 'Rewards & Loyalty', subtitle: 'Points and tier benefits.' } },
        /* Marketing */
        { path: 'marketing/referral', name: 'marketing-referral', component: () => import('@/views/marketing/MarketingReferralView.vue'), meta: { title: 'Referral link', subtitle: 'Share and earn.' } },
        { path: 'marketing/analytics', name: 'marketing-analytics', component: () => import('@/views/marketing/MarketingAnalyticsView.vue'), meta: { title: 'Analytics', subtitle: 'Referral performance over time.' } },
        { path: 'marketing/how-you-earn', name: 'marketing-how-you-earn', component: () => import('@/views/marketing/MarketingHowYouEarnView.vue'), meta: { title: 'How you earn', subtitle: 'Commission rules and payout schedule.' } },
        { path: 'marketing/campaigns', name: 'marketing-campaigns', component: () => import('@/views/marketing/MarketingCampaignsView.vue'), meta: { title: 'Campaigns', subtitle: 'Active campaigns and materials.' } },
        { path: 'marketing/earnings', name: 'marketing-earnings', component: () => import('@/views/marketing/MarketingEarningsView.vue'), meta: { title: 'Earnings', subtitle: 'Referral earnings and payouts.' } },
        { path: 'marketing/payout-history', name: 'marketing-payout-history', component: () => import('@/views/marketing/MarketingPayoutHistoryView.vue'), meta: { title: 'Payout history', subtitle: 'Past payouts and status.' } },
        { path: 'marketing/resources', name: 'marketing-resources', component: () => import('@/views/marketing/MarketingResourcesView.vue'), meta: { title: 'Resources', subtitle: 'Logos and key messages.' } },
        { path: 'marketing/payout-method', name: 'marketing-payout-method', component: () => import('@/views/marketing/MarketingPayoutMethodView.vue'), meta: { title: 'Payout method', subtitle: 'Receive payouts via GCash, Maya or bank.' } },
        { path: 'marketing/activity', name: 'marketing-activity', component: () => import('@/views/ActivityLogsView.vue'), meta: { title: 'Account activity', subtitle: 'Login history and changes.' } },
        { path: 'marketing/rewards', name: 'marketing-rewards', component: () => import('@/views/RewardsView.vue'), meta: { title: 'Rewards & Loyalty', subtitle: 'Points and tier benefits.' } },
        /* Admin */
        { path: 'admin/listings', name: 'admin-listings', component: () => import('@/views/admin/AdminListingsView.vue'), meta: { title: 'Listings', subtitle: 'All vehicle listings.' } },
        { path: 'admin/bookings', name: 'admin-bookings', component: () => import('@/views/admin/AdminBookingsView.vue'), meta: { title: 'Bookings', subtitle: 'Rental analytics and records.' } },
        { path: 'admin/bookings/:id', name: 'admin-booking-detail', component: () => import('@/views/admin/AdminBookingDetailView.vue'), meta: { title: 'Booking', subtitle: 'Details and actions.' } },
        { path: 'admin/payouts', name: 'admin-payouts', component: () => import('@/views/admin/AdminPayoutsView.vue'), meta: { title: 'Payouts', subtitle: 'Payout requests and history.' } },
        { path: 'admin/dashboard-promos', name: 'admin-dashboard-promos', component: () => import('@/views/admin/AdminDashboardPromosView.vue'), meta: { title: 'Dashboard promos', subtitle: 'Images shown on Client, Car rental owner & Marketing dashboards.' } },
        { path: 'admin/payment-qr', name: 'admin-payment-qr', component: () => import('@/views/admin/AdminPaymentQrView.vue'), meta: { title: 'Payment collection (QR)', subtitle: 'GCash and Maya QR for manual payments.' } },
        {
          path: 'admin/car-owners',
          name: 'car-owners',
          component: () => import('@/views/CarOwnersView.vue'),
          meta: { title: 'Car rental owners', subtitle: 'Manage rental companies.' },
        },
        {
          path: 'admin/car-owners/:id',
          name: 'car-owner-details',
          component: () => import('@/views/admin/CarOwnerDetailsView.vue'),
          meta: { title: 'Car rental company details', subtitle: 'Company profile and listings.' },
        },
        {
          path: 'admin/vehicles',
          name: 'admin-vehicles',
          component: () => import('@/views/admin/AdminVehiclesView.vue'),
          meta: { title: 'Vehicle Listings', subtitle: 'Search vehicles, permits. Add, edit, remove.' },
        },
        {
          path: 'clients',
          name: 'clients',
          component: () => import('@/views/ClientsView.vue'),
          meta: { title: 'Clients', subtitle: 'Renters and bookings.' },
        },
        {
          path: 'clients/:id',
          name: 'client-details',
          component: () => import('@/views/ClientDetailsView.vue'),
          meta: { title: 'Renter profile', subtitle: 'Contact and booking history.' },
        },
        {
          path: 'admin/marketing-staff',
          name: 'marketing-staff',
          component: () => import('@/views/MarketingStaffView.vue'),
          meta: { title: 'Marketing staff', subtitle: 'Referral partners.' },
        },
        {
          path: 'admin/marketing-staff/:id',
          name: 'marketing-staff-details',
          component: () => import('@/views/admin/MarketingStaffDetailsView.vue'),
          meta: { title: 'Marketing partner details', subtitle: 'Partner profile and referrals.' },
        },
        {
          path: 'admin/shifts',
          name: 'shifts',
          component: () => import('@/views/ShiftsView.vue'),
          meta: { title: 'Rosters & Timesheets', subtitle: 'Manage staff shifts.' },
        },
        {
          path: 'admin/shifts/:id',
          name: 'shift-details',
          component: () => import('@/views/ShiftDetailsView.vue'),
          meta: { title: 'Shift details', subtitle: 'Shift overview and notes.' },
        },
        {
          path: 'reports',
          name: 'reports',
          component: () => import('@/views/ReportsView.vue'),
          meta: { title: 'Reports', subtitle: 'Platform analytics and export.' },
        },
        {
          path: 'announcements',
          name: 'announcements',
          component: () => import('@/views/AnnouncementsView.vue'),
        },
        {
          path: 'admin/disputes',
          name: 'admin-disputes',
          component: () => import('@/views/admin/AdminDisputesView.vue'),
          meta: { title: 'Dispute resolution', subtitle: 'Review and resolve disputes.' },
        },
        {
          path: 'admin/reviews',
          name: 'admin-review-moderation',
          component: () => import('@/views/admin/AdminReviewModerationView.vue'),
          meta: { title: 'Review moderation', subtitle: 'Approve or reject reviews.' },
        },
        {
          path: 'admin/fraud-risk',
          name: 'admin-fraud-risk',
          component: () => import('@/views/admin/AdminFraudRiskView.vue'),
          meta: { title: 'Fraud & risk', subtitle: 'Suspicious bookings and alerts.' },
        },
        {
          path: 'admin/system-logs',
          name: 'admin-system-logs',
          component: () => import('@/views/admin/AdminSystemLogsView.vue'),
          meta: { title: 'System logs', subtitle: 'Payment and API failures.' },
        },
        {
          path: 'admin/roles',
          name: 'admin-roles',
          component: () => import('@/views/admin/AdminRolesPermissionsView.vue'),
          meta: { title: 'Roles & permissions', subtitle: 'Manage access control.' },
        },
        {
          path: 'admin/email-templates',
          name: 'admin-email-templates',
          component: () => import('@/views/admin/AdminEmailTemplatesView.vue'),
          meta: { title: 'Email templates', subtitle: 'Manage email content.' },
        },
        {
          path: 'admin/webhooks',
          name: 'admin-webhook-logs',
          component: () => import('@/views/admin/AdminWebhookLogsView.vue'),
          meta: { title: 'Webhook logs', subtitle: 'Track payment webhooks.' },
        },
        {
          path: 'admin/affiliate-applications',
          name: 'admin-affiliate-applications',
          component: () => import('@/views/admin/AdminAffiliateApplicationsView.vue'),
          meta: { title: 'Affiliate applications', subtitle: 'Review partner applications.' },
        },
        {
          path: 'admin/insurance-plans',
          name: 'admin-insurance-plans',
          component: () => import('@/views/admin/AdminInsurancePlansView.vue'),
          meta: { title: 'Insurance plans', subtitle: 'Manage plan catalog.' },
        },
        {
          path: 'admin/tax-reports',
          name: 'admin-tax-reports',
          component: () => import('@/views/admin/AdminTaxReportsView.vue'),
          meta: { title: 'VAT & withholding', subtitle: 'Compliance reporting.' },
        },
        {
          path: 'admin/activity',
          name: 'admin-activity',
          component: () => import('@/views/ActivityLogsView.vue'),
          meta: { title: 'Account activity', subtitle: 'Audit user activity.' },
        },
        {
          path: 'profile',
          name: 'profile',
          component: () => import('@/views/ProfileView.vue'),
          meta: { title: 'Profile', subtitle: 'Your account and verification' },
        },
        {
          path: 'notifications',
          name: 'notifications',
          component: () => import('@/views/NotificationsView.vue'),
          meta: { title: 'Notifications', subtitle: 'Booking and account updates' },
        },
        {
          path: 'settings',
          name: 'settings',
          component: () => import('@/views/SettingsView.vue'),
          meta: { title: 'Settings', subtitle: 'Preferences and security.' },
        },
      ],
    },
    {
      path: '/:pathMatch(.*)*',
      name: 'not-found',
      component: () => import('@/views/NotFoundView.vue'),
      meta: { requiresAuth: false, layout: false },
    },
  ],
})

// Navigation guard
router.beforeEach(async (to, _from) => {
  const userSession = useUserSessionStore()
  const agreementStore = useAgreementAcceptanceStore()

  if (!userSession.isHydrated) {
    await userSession.hydrate()
  }

  if (to.meta.requiresAuth && !userSession.isAuthenticated) {
    return { name: 'login' }
  }
  if ((to.name === 'login' || to.name === 'register' || to.name === 'forgot-password' || to.name === 'reset-password') && userSession.isAuthenticated) {
    const roles = userSession.user?.roles ?? []
    const primary = roles[0]?.toLowerCase?.() ?? ''
    const routeName =
      primary === 'admin' ? 'admin-dashboard'
        : primary === 'car_owner' || primary === 'car owner' ? 'car-owner-dashboard'
          : primary === 'marketing_staff' || primary === 'marketing_partner' ? 'marketing-dashboard'
            : 'client-dashboard'
    return { name: routeName }
  }
  if (to.name === 'landing' && userSession.isAuthenticated) {
    const roles = userSession.user?.roles ?? []
    const primary = roles[0]?.toLowerCase?.() ?? ''
    const routeName =
      primary === 'admin' ? 'admin-dashboard'
        : primary === 'car_owner' || primary === 'car owner' ? 'car-owner-dashboard'
          : primary === 'marketing_staff' || primary === 'marketing_partner' ? 'marketing-dashboard'
            : 'client-dashboard'
    return { name: routeName }
  }

  // Non-admin (client, car_owner, marketing_staff): must verify email before accessing app
  const primaryRole = userSession.user?.roles?.[0]?.toLowerCase?.() ?? ''
  const isAdmin = primaryRole === 'admin'
  const isNonAdminRequiringVerification = !isAdmin && (
    primaryRole === 'client' ||
    primaryRole === 'car_owner' ||
    primaryRole === 'car owner' ||
    primaryRole === 'marketing_staff' ||
    primaryRole === 'marketing_partner'
  )
  const emailVerified = userSession.user?.email_verified !== false
  if (userSession.isAuthenticated && isNonAdminRequiringVerification && !emailVerified && to.name !== 'verify-email') {
    return { name: 'verify-email' }
  }

  // Car owner: must accept platform agreement before accessing any car-owner route (except the agreement page)
  const isCarOwnerRoute = to.path.startsWith('/car-owner') || (typeof to.name === 'string' && to.name.startsWith('car-owner-') && to.name !== 'car-owner-agreement')
  const isCarOwner = userSession.hasRole('car_owner') || userSession.hasRole('car owner')
  if (isCarOwnerRoute && isCarOwner && to.name !== 'car-owner-agreement' && !agreementStore.hasAcceptedCarOwnerAgreement) {
    return { name: 'car-owner-agreement' }
  }
})

// Set document title and SEO meta description from route meta
const APP_TITLE = 'BulodPH'
router.afterEach((to) => {
  const title = to.meta?.title as string | undefined
  document.title = title ? `${title} · ${APP_TITLE}` : APP_TITLE

  const description = to.meta?.description as string | undefined
  if (description) {
    let metaTag = document.querySelector('meta[name="description"]')
    if (!metaTag) {
      metaTag = document.createElement('meta')
      metaTag.setAttribute('name', 'description')
      document.head.appendChild(metaTag)
    }
    metaTag.setAttribute('content', description)
  }
})

export default router
