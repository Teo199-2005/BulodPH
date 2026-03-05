/**
 * Role-based navigation for BulodPH dashboards.
 * Sidebar and bottom nav items per role (client, car_owner, marketing_staff, admin).
 * @see DASHBOARD_CONTENT_GUIDE.md
 */

import type { RoleColorKey } from './roleColors'

export interface NavItem {
  to: string
  title: string
  icon: string
  /** When set, this item is a group header; children are shown in a dropdown. */
  children?: NavItem[]
}

/** Dashboard path for each role (used in sidebar "Dashboard" link and redirects) */
export const DASHBOARD_PATH_BY_ROLE: Record<RoleColorKey, string> = {
  client: '/client',
  car_owner: '/car-owner',
  marketing_staff: '/marketing',
  admin: '/admin',
}

/** Sidebar: main + other sections per role */
export interface RoleNavConfig {
  main: NavItem[]
  other: NavItem[]
  /** Bottom nav items (mobile). Max 4 for typical bottom bar. */
  bottomNav: NavItem[]
}

const CLIENT_NAV: RoleNavConfig = {
  main: [
    { to: '/client', title: 'Dashboard', icon: 'mdi-view-dashboard' },
    {
      to: '',
      title: 'Browse',
      icon: 'mdi-compass-outline',
      children: [
        { to: '/client/browse', title: 'Browse rides', icon: 'mdi-car-search' },
        { to: '/client/browse-rentals', title: 'Browse car rentals', icon: 'mdi-storefront' },
      ],
    },
    {
      to: '',
      title: 'Trips & favorites',
      icon: 'mdi-calendar-heart',
      children: [
        { to: '/client/bookings', title: 'My bookings', icon: 'mdi-calendar-check' },
        { to: '/client/cart', title: 'Cart', icon: 'mdi-cart-outline' },
        { to: '/client/favorites', title: 'Favorites', icon: 'mdi-heart-outline' },
      ],
    },
  ],
  other: [
    {
      to: '',
      title: 'Payments & rewards',
      icon: 'mdi-credit-card-outline',
      children: [
        { to: '/client/promo', title: 'Promos', icon: 'mdi-tag-outline' },
        { to: '/client/payments', title: 'Payments', icon: 'mdi-credit-card-outline' },
        { to: '/client/rewards', title: 'Rewards', icon: 'mdi-gift-outline' },
        { to: '/client/tax-invoicing', title: 'Tax & Invoicing', icon: 'mdi-receipt-text-outline' },
      ],
    },
    {
      to: '',
      title: 'Safety & support',
      icon: 'mdi-shield-check-outline',
      children: [
        { to: '/client/kyc', title: 'ID Verification', icon: 'mdi-card-account-details-outline' },
        { to: '/client/cancellations', title: 'Cancellations & Refunds', icon: 'mdi-cancel' },
        { to: '/client/help', title: 'Help & FAQ', icon: 'mdi-help-circle-outline' },
        { to: '/client/support', title: 'Contact support', icon: 'mdi-headset' },
      ],
    },
    {
      to: '',
      title: 'Account',
      icon: 'mdi-account-circle-outline',
      children: [
        { to: '/client/activity', title: 'Account activity', icon: 'mdi-history' },
      ],
    },
  ],
  bottomNav: [
    { to: '/client', title: 'Dashboard', icon: 'mdi-view-dashboard' },
    { to: '/client/browse', title: 'Browse', icon: 'mdi-car-search' },
    { to: '/client/bookings', title: 'My bookings', icon: 'mdi-calendar-check' },
    { to: '/settings', title: 'More', icon: 'mdi-dots-horizontal' },
  ],
}

const CAR_OWNER_NAV: RoleNavConfig = {
  main: [
    { to: '/car-owner', title: 'Dashboard', icon: 'mdi-view-dashboard' },
    {
      to: '',
      title: 'Fleet & bookings',
      icon: 'mdi-car-multiple',
      children: [
        { to: '/car-owner/vehicles', title: 'My vehicles', icon: 'mdi-car-multiple' },
        { to: '/car-owner/bookings', title: 'Bookings', icon: 'mdi-calendar-check' },
        { to: '/car-owner/calendar', title: 'Calendar', icon: 'mdi-calendar-month' },
      ],
    },
    {
      to: '',
      title: 'Earnings & payouts',
      icon: 'mdi-currency-php',
      children: [
        { to: '/car-owner/earnings', title: 'Earnings', icon: 'mdi-currency-php' },
        { to: '/car-owner/payout-method', title: 'Payout method', icon: 'mdi-bank-transfer-out' },
        { to: '/car-owner/payout-history', title: 'Payout history', icon: 'mdi-history' },
      ],
    },
  ],
  other: [
    {
      to: '',
      title: 'Operations',
      icon: 'mdi-clipboard-check-outline',
      children: [
        { to: '/car-owner/reviews', title: 'Reviews & Ratings', icon: 'mdi-star-outline' },
      ],
    },
    {
      to: '',
      title: 'Compliance',
      icon: 'mdi-shield-check-outline',
      children: [
        { to: '/car-owner/tax-invoicing', title: 'Tax & Invoicing', icon: 'mdi-receipt-text-outline' },
      ],
    },
    {
      to: '',
      title: 'Account',
      icon: 'mdi-account-circle-outline',
      children: [
        { to: '/car-owner/activity', title: 'Account activity', icon: 'mdi-history' },
        { to: '/car-owner/rewards', title: 'Rewards', icon: 'mdi-gift-outline' },
        { to: '/car-owner/help', title: 'Help & getting started', icon: 'mdi-help-circle-outline' },
        { to: '/notifications', title: 'Notifications', icon: 'mdi-bell-outline' },
      ],
    },
  ],
  bottomNav: [
    { to: '/car-owner', title: 'Dashboard', icon: 'mdi-view-dashboard' },
    { to: '/car-owner/vehicles', title: 'Vehicles', icon: 'mdi-car-multiple' },
    { to: '/car-owner/bookings', title: 'Bookings', icon: 'mdi-calendar-check' },
    { to: '/settings', title: 'More', icon: 'mdi-dots-horizontal' },
  ],
}

const MARKETING_NAV: RoleNavConfig = {
  main: [
    { to: '/marketing', title: 'Dashboard', icon: 'mdi-view-dashboard' },
    {
      to: '',
      title: 'Growth',
      icon: 'mdi-chart-line',
      children: [
        { to: '/marketing/referral', title: 'Referral link', icon: 'mdi-link-variant' },
        { to: '/marketing/analytics', title: 'Analytics', icon: 'mdi-chart-line' },
        { to: '/marketing/campaigns', title: 'Campaigns', icon: 'mdi-bullhorn-outline' },
      ],
    },
    {
      to: '',
      title: 'Earnings & payouts',
      icon: 'mdi-currency-php',
      children: [
        { to: '/marketing/earnings', title: 'Earnings', icon: 'mdi-currency-php' },
        { to: '/marketing/payout-method', title: 'Payout method', icon: 'mdi-bank-transfer-out' },
        { to: '/marketing/payout-history', title: 'Payout history', icon: 'mdi-history' },
      ],
    },
  ],
  other: [
    {
      to: '',
      title: 'Resources',
      icon: 'mdi-folder-information-outline',
      children: [
        { to: '/marketing/resources', title: 'Resources', icon: 'mdi-folder-information-outline' },
        { to: '/marketing/how-you-earn', title: 'How you earn', icon: 'mdi-information-outline' },
      ],
    },
    {
      to: '',
      title: 'Account',
      icon: 'mdi-account-circle-outline',
      children: [
        { to: '/marketing/activity', title: 'Account activity', icon: 'mdi-history' },
        { to: '/marketing/rewards', title: 'Rewards', icon: 'mdi-gift-outline' },
        { to: '/notifications', title: 'Notifications', icon: 'mdi-bell-outline' },
      ],
    },
  ],
  bottomNav: [
    { to: '/marketing', title: 'Dashboard', icon: 'mdi-view-dashboard' },
    { to: '/marketing/referral', title: 'Referral', icon: 'mdi-link-variant' },
    { to: '/marketing/earnings', title: 'Earnings', icon: 'mdi-currency-php' },
    { to: '/settings', title: 'More', icon: 'mdi-dots-horizontal' },
  ],
}

const ADMIN_NAV: RoleNavConfig = {
  main: [
    { to: '/admin', title: 'Dashboard', icon: 'mdi-view-dashboard' },
    {
      to: '',
      title: 'User Management',
      icon: 'mdi-account-cog',
      children: [
        { to: '/admin/car-owners', title: 'Car rental owners', icon: 'mdi-car-side' },
        { to: '/clients', title: 'Clients', icon: 'mdi-account-group' },
        { to: '/admin/marketing-staff', title: 'Marketing staff', icon: 'mdi-bullhorn-outline' },
      ],
    },
    {
      to: '',
      title: 'Operations',
      icon: 'mdi-clipboard-check-outline',
      children: [
        { to: '/admin/vehicles', title: 'Vehicles', icon: 'mdi-car-multiple' },
        { to: '/admin/listings', title: 'Listings', icon: 'mdi-car-multiple' },
        { to: '/admin/bookings', title: 'Bookings', icon: 'mdi-calendar-check' },
        { to: '/admin/payouts', title: 'Payouts', icon: 'mdi-bank-transfer-out' },
        { to: '/admin/shifts', title: 'Rosters & Timesheets', icon: 'mdi-calendar-clock' },
      ],
    },
    {
      to: '',
      title: 'Comms & promos',
      icon: 'mdi-bullhorn-outline',
      children: [
        { to: '/admin/dashboard-promos', title: 'Dashboard promos', icon: 'mdi-image-multiple' },
        { to: '/admin/payment-qr', title: 'Payment collection (QR)', icon: 'mdi-qrcode' },
        { to: '/announcements', title: 'Announcements', icon: 'mdi-bullhorn-outline' },
      ],
    },
  ],
  other: [
    {
      to: '',
      title: 'Oversight',
      icon: 'mdi-chart-box-outline',
      children: [
        { to: '/reports', title: 'Reports', icon: 'mdi-chart-box-outline' },
        { to: '/admin/disputes', title: 'Dispute resolution', icon: 'mdi-alert-circle-outline' },
        { to: '/admin/reviews', title: 'Review moderation', icon: 'mdi-star-outline' },
        { to: '/admin/fraud-risk', title: 'Fraud & Risk', icon: 'mdi-shield-alert-outline' },
      ],
    },
    {
      to: '',
      title: 'Platform',
      icon: 'mdi-shield-account-outline',
      children: [
        { to: '/admin/system-logs', title: 'System logs', icon: 'mdi-file-document-outline' },
        { to: '/admin/roles', title: 'Roles & permissions', icon: 'mdi-shield-account-outline' },
        { to: '/admin/email-templates', title: 'Email templates', icon: 'mdi-email-outline' },
        { to: '/admin/webhooks', title: 'Webhook logs', icon: 'mdi-webhook' },
      ],
    },
    {
      to: '',
      title: 'Partnerships',
      icon: 'mdi-account-multiple-plus-outline',
      children: [
        { to: '/admin/affiliate-applications', title: 'Affiliate applications', icon: 'mdi-account-multiple-plus-outline' },
        { to: '/admin/insurance-plans', title: 'Insurance plans', icon: 'mdi-shield-outline' },
        { to: '/admin/tax-reports', title: 'VAT & withholding', icon: 'mdi-receipt-text-outline' },
      ],
    },
    {
      to: '',
      title: 'Account',
      icon: 'mdi-account-circle-outline',
      children: [
        { to: '/admin/activity', title: 'Account activity', icon: 'mdi-history' },
        { to: '/notifications', title: 'Notifications', icon: 'mdi-bell-outline' },
      ],
    },
  ],
  bottomNav: [
    { to: '/admin', title: 'Dashboard', icon: 'mdi-view-dashboard' },
    { to: '/clients', title: 'Users', icon: 'mdi-account-multiple' },
    { to: '/admin/bookings', title: 'Bookings', icon: 'mdi-calendar-check' },
    { to: '/settings', title: 'More', icon: 'mdi-dots-horizontal' },
  ],
}

export const ROLE_NAV: Record<RoleColorKey, RoleNavConfig> = {
  client: CLIENT_NAV,
  car_owner: CAR_OWNER_NAV,
  marketing_staff: MARKETING_NAV,
  admin: ADMIN_NAV,
}

export function getRoleNav(roleKey: RoleColorKey): RoleNavConfig {
  return ROLE_NAV[roleKey] ?? ROLE_NAV.client
}
