/**
 * Seed data for Admin Reports page (financial summary, recent reports, booking chart).
 */

export interface FinancialSummarySeed {
  totalRevenue: number
  totalRevenueTrend: number
  paidToOwners: number
  paidToOwnersTrend: number
  pendingPayouts: number
  pendingPayoutsCount: number
  overduePayouts: number
  overduePayoutsCount: number
}

export interface RecentReportSeed {
  id: number
  name: string
  type: string
  generated: string
  status: string
}

export const FINANCIAL_SUMMARY_SEED: FinancialSummarySeed = {
  totalRevenue: 125450,
  totalRevenueTrend: 12.5,
  paidToOwners: 98320,
  paidToOwnersTrend: 8.3,
  pendingPayouts: 27130,
  pendingPayoutsCount: 15,
  overduePayouts: 12450,
  overduePayoutsCount: 8,
}

export const RECENT_REPORTS_SEED: RecentReportSeed[] = [
  { id: 1, name: 'January 2026 Revenue Summary', type: 'Revenue', generated: '2026-01-30', status: 'Ready' },
  { id: 2, name: 'Bookings Report - Week 4', type: 'Bookings', generated: '2026-01-29', status: 'Ready' },
  { id: 3, name: 'Listings & Availability Q1 2026', type: 'Listings', generated: '2026-01-28', status: 'Processing' },
  { id: 4, name: 'Payout Report - January', type: 'Payouts', generated: '2026-01-27', status: 'Ready' },
]

/** Booking stats for Reports (Completed, Scheduled, Pending, Cancelled counts). */
export const BOOKING_STATS_SEED = {
  completed: 156,
  scheduled: 89,
  pending: 23,
  cancelled: 12,
}

/** Weekly chart data for Reports (Mon–Sun). */
export const BOOKING_CHART_SEED = {
  completed: [22, 25, 20, 28, 24, 18, 19],
  scheduled: [12, 15, 13, 14, 11, 10, 14],
  pending: [3, 4, 2, 5, 3, 2, 4],
  cancelled: [1, 0, 2, 1, 0, 1, 1],
}
