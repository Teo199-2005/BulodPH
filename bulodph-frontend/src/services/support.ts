import api from '@/lib/api'
import { unwrapData } from './api-types'

function getErrorMessage(error: unknown): string {
  const message = (error as { response?: { data?: { message?: string } } })?.response?.data?.message
  return message ?? 'Request failed. Please try again.'
}

export interface SupportTicketRecord {
  id: string
  user_id: string
  subject?: string | null
  message: string
  status: string
  created_at?: string
  updated_at?: string
}

export interface CreateSupportTicketPayload {
  subject?: string
  message: string
}

export async function getSupportTickets(): Promise<SupportTicketRecord[]> {
  try {
    const { data } = await api.get<{ data?: SupportTicketRecord[] } | SupportTicketRecord[]>('/support')
    return (unwrapData(data) as SupportTicketRecord[]) ?? []
  } catch (error) {
    throw new Error(getErrorMessage(error))
  }
}

export async function createSupportTicket(payload: CreateSupportTicketPayload): Promise<SupportTicketRecord> {
  try {
    const { data } = await api.post<{ data?: SupportTicketRecord } | SupportTicketRecord>('/support', payload)
    return unwrapData(data) as SupportTicketRecord
  } catch (error) {
    throw new Error(getErrorMessage(error))
  }
}
