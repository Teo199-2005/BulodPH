/**
 * Marketing partner payout history (for Payout history page).
 */
export interface MarketingPayoutHistoryItem {
  id: string
  date: string
  amount: number
  method: string
  accountSuffix: string
  status: 'Paid' | 'Failed'
}

export const MARKETING_PAYOUT_HISTORY_SEED: MarketingPayoutHistoryItem[] = [
  { id: '1', date: 'Jan 31, 2026', amount: 2400, method: 'GCash', accountSuffix: '4567', status: 'Paid' },
  { id: '2', date: 'Jan 24, 2026', amount: 1800, method: 'GCash', accountSuffix: '4567', status: 'Paid' },
  { id: '3', date: 'Jan 17, 2026', amount: 1200, method: 'GCash', accountSuffix: '4567', status: 'Paid' },
]
