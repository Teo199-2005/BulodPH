/**
 * Car owner payout history (for Payout history page).
 */
export interface CarOwnerPayoutHistoryItem {
  id: string
  date: string
  amount: number
  method: string
  accountSuffix: string
  status: 'Paid' | 'Failed'
}

export const CAR_OWNER_PAYOUT_HISTORY_SEED: CarOwnerPayoutHistoryItem[] = [
  { id: '1', date: 'Feb 2, 2026', amount: 5500, method: 'GCash', accountSuffix: '7890', status: 'Paid' },
  { id: '2', date: 'Jan 26, 2026', amount: 500, method: 'GCash', accountSuffix: '7890', status: 'Paid' },
]
