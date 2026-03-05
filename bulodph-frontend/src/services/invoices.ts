import api from '@/lib/api'
import { unwrapData } from './api-types'

function getErrorMessage(error: unknown): string {
  const message = (error as { response?: { data?: { message?: string } } })?.response?.data?.message
  return message ?? 'Request failed. Please try again.'
}

export interface InvoiceRecord {
  id: string
  booking_reference?: string | null
  user_id?: string | null
  owner_id?: string | null
  subtotal?: number
  taxes?: number
  total?: number
  currency?: string | null
  status?: string | null
  paid_at?: string | null
  pdf_path?: string | null
  created_at?: string
  updated_at?: string
}

export async function getInvoices(): Promise<InvoiceRecord[]> {
  try {
    const { data } = await api.get<{ data?: InvoiceRecord[] } | InvoiceRecord[]>('/invoices')
    return (unwrapData(data) as InvoiceRecord[]) ?? []
  } catch (error) {
    throw new Error(getErrorMessage(error))
  }
}

export async function getInvoiceById(id: string): Promise<InvoiceRecord> {
  try {
    const { data } = await api.get<{ data?: InvoiceRecord } | InvoiceRecord>(`/invoices/${id}`)
    return unwrapData(data) as InvoiceRecord
  } catch (error) {
    throw new Error(getErrorMessage(error))
  }
}
