import api from '@/lib/api'
import { unwrapData } from './api-types'

function getErrorMessage(error: unknown): string {
  const message = (error as { response?: { data?: { message?: string } } })?.response?.data?.message
  return message ?? 'Request failed. Please try again.'
}

export interface DisputeRecord {
  id: string
  booking_reference?: string | null
  opened_by_user_id: string
  against_user_id?: string | null
  reason: string
  description?: string | null
  status: string
  resolved_at?: string | null
  created_at?: string
  updated_at?: string
  evidence?: { id: string; file_path: string; mime?: string; size?: number }[]
}

export interface CreateDisputePayload {
  booking_reference?: string
  against_user_id?: string
  reason: string
  description?: string
}

export async function getDisputes(): Promise<DisputeRecord[]> {
  try {
    const { data } = await api.get<{ data?: DisputeRecord[] } | DisputeRecord[]>('/disputes')
    return (unwrapData(data) as DisputeRecord[]) ?? []
  } catch (error) {
    throw new Error(getErrorMessage(error))
  }
}

export async function getDisputeById(id: string): Promise<DisputeRecord> {
  try {
    const { data } = await api.get<{ data?: DisputeRecord } | DisputeRecord>(`/disputes/${id}`)
    return unwrapData(data) as DisputeRecord
  } catch (error) {
    throw new Error(getErrorMessage(error))
  }
}

export async function createDispute(payload: CreateDisputePayload): Promise<DisputeRecord> {
  try {
    const body = {
      booking_reference: payload.booking_reference || undefined,
      against_user_id: payload.against_user_id || undefined,
      reason: payload.reason,
      description: payload.description || undefined,
    }
    const { data } = await api.post<{ data?: DisputeRecord } | DisputeRecord>('/disputes', body)
    return unwrapData(data) as DisputeRecord
  } catch (error) {
    throw new Error(getErrorMessage(error))
  }
}

export async function addDisputeEvidence(disputeId: string, file: File): Promise<{ id: string; file_path: string }> {
  try {
    const form = new FormData()
    form.append('file', file)
    const { data } = await api.post<{ data?: { id: string; file_path: string } }>(`/disputes/${disputeId}/evidence`, form, {
      headers: { 'Content-Type': 'multipart/form-data' },
    })
    return unwrapData(data) as { id: string; file_path: string }
  } catch (error) {
    throw new Error(getErrorMessage(error))
  }
}
