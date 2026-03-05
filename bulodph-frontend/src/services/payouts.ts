import api from '@/lib/api'
import { unwrapData } from './api-types'

export interface PayoutItem {
  id: string
  type: 'car_owner' | 'marketing'
  payeeName: string
  amount: number
  method: string
  status: 'pending' | 'paid' | 'rejected'
  requestedAt: string
  paidAt?: string
}

export async function getPendingPayouts(): Promise<PayoutItem[] | null> {
  try {
    const { data } = await api.get<{ data?: PayoutItem[] } | PayoutItem[]>('/payouts/pending')
    return unwrapData(data) as PayoutItem[]
  } catch {
    return null
  }
}

export async function getPayoutHistory(params?: { limit?: number }): Promise<PayoutItem[] | null> {
  try {
    const { data } = await api.get<{ data?: PayoutItem[] } | PayoutItem[]>('/payouts/history', { params })
    return unwrapData(data) as PayoutItem[]
  } catch {
    return null
  }
}

export async function approvePayout(id: string): Promise<boolean> {
  try {
    await api.post(`/payouts/${id}/approve`)
    return true
  } catch {
    return false
  }
}

export async function rejectPayout(id: string, reason?: string): Promise<boolean> {
  try {
    await api.post(`/payouts/${id}/reject`, { reason })
    return true
  } catch {
    return false
  }
}

/** Request a payout (car_owner or marketing). Amount in pesos; min 100. */
export async function requestPayout(amount: number, method: string = 'GCash', payeeName?: string): Promise<PayoutItem | null> {
  try {
    const { data } = await api.post<{ data?: PayoutItem } | PayoutItem>('/payouts', {
      amount,
      method,
      ...(payeeName ? { payeeName } : {}),
    })
    const raw = (data as { data?: PayoutItem })?.data ?? (data as PayoutItem)
    return raw ? (raw as PayoutItem) : null
  } catch {
    return null
  }
}
