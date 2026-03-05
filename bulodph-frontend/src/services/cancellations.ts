import api from '@/lib/api'
import { unwrapData } from './api-types'

function getErrorMessage(error: unknown): string {
  const message = (error as { response?: { data?: { message?: string } } })?.response?.data?.message
  return message ?? 'Request failed. Please try again.'
}

export interface CancellationRecord {
  id: string
  user_id: string
  booking_reference?: string | null
  reason?: string | null
  status: string
  created_at?: string
  updated_at?: string
  refund?: RefundRecord | null
}

export interface RefundRecord {
  id: string
  cancellation_request_id: string
  amount: number
  currency?: string
  status: string
  reference?: string | null
  created_at?: string
  updated_at?: string
}

export async function getCancellations(): Promise<CancellationRecord[]> {
  try {
    const { data } = await api.get<{ data?: CancellationRecord[] } | CancellationRecord[]>('/cancellations')
    return (unwrapData(data) as CancellationRecord[]) ?? []
  } catch (error) {
    throw new Error(getErrorMessage(error))
  }
}

export async function getCancellationById(id: string): Promise<CancellationRecord> {
  try {
    const { data } = await api.get<{ data?: CancellationRecord } | CancellationRecord>(`/cancellations/${id}`)
    return unwrapData(data) as CancellationRecord
  } catch (error) {
    throw new Error(getErrorMessage(error))
  }
}

export async function createCancellation(payload: { booking_reference?: string; reason?: string }): Promise<CancellationRecord> {
  try {
    const { data } = await api.post<{ data?: CancellationRecord } | CancellationRecord>('/cancellations', payload)
    return unwrapData(data) as CancellationRecord
  } catch (error) {
    throw new Error(getErrorMessage(error))
  }
}

export async function getRefunds(): Promise<RefundRecord[]> {
  try {
    const { data } = await api.get<{ data?: RefundRecord[] } | RefundRecord[]>('/refunds')
    return (unwrapData(data) as RefundRecord[]) ?? []
  } catch (error) {
    throw new Error(getErrorMessage(error))
  }
}

export async function getRefundById(id: string): Promise<RefundRecord> {
  try {
    const { data } = await api.get<{ data?: RefundRecord } | RefundRecord>(`/refunds/${id}`)
    return unwrapData(data) as RefundRecord
  } catch (error) {
    throw new Error(getErrorMessage(error))
  }
}
