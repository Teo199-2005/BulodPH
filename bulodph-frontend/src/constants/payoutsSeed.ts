/**
 * Seed data for admin Payouts (pending + history).
 */

export interface PayoutRequestSeed {
  id: string
  recipientName: string
  type: string
  method: string
  accountSuffix: string
  amount: number
}

export interface PayoutHistorySeed {
  id: string
  recipientName: string
  date: string
  amount: number
  status: 'Paid' | 'Failed'
}

export const PENDING_PAYOUTS_SEED: PayoutRequestSeed[] = [
  { id: '1', recipientName: 'Juan Dela Cruz', type: 'Car rental owner', method: 'GCash', accountSuffix: '4567', amount: 7500 },
  { id: '2', recipientName: 'Maria Santos', type: 'Marketing', method: 'GCash', accountSuffix: '8901', amount: 3200 },
]

export const PAYOUT_HISTORY_SEED: PayoutHistorySeed[] = [
  { id: 'h1', recipientName: 'Ana Lopez', date: 'Feb 1, 2026', amount: 5000, status: 'Paid' },
  { id: 'h2', recipientName: 'Pedro Reyes', date: 'Jan 28, 2026', amount: 2500, status: 'Paid' },
]
