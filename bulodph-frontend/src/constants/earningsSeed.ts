/**
 * Seed data for Car Owner Earnings and Marketing Earnings pages.
 */

export interface EarningsHistoryItem {
  id: string
  label: string
  date: string
  amount: number
}

export const CAR_OWNER_EARNINGS_SEED = {
  availableBalance: 7500,
  thisMonth: 5000,
  totalEarned: 25000,
  history: [
    { id: '1', label: 'Toyota Innova – Feb 10-12', date: 'Feb 12, 2026', amount: 5000 },
    { id: '2', label: 'Honda City – Jan 20', date: 'Jan 20, 2026', amount: 500 },
  ] as EarningsHistoryItem[],
}

export const MARKETING_EARNINGS_SEED = {
  availableBalance: 3200,
  thisMonth: 2400,
  totalEarned: 8900,
  history: [
    { id: '1', label: 'Referral – Mary J. (booking)', date: 'Feb 5, 2026', amount: 400 },
    { id: '2', label: 'Referral – Robert W. (sign-up)', date: 'Feb 2, 2026', amount: 200 },
    { id: '3', label: 'Campaign – Isabela Launch', date: 'Jan 28, 2026', amount: 800 },
  ] as EarningsHistoryItem[],
}
