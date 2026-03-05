import api from '@/lib/api'
import { unwrapData } from './api-types'
import type { FinancialSummarySeed } from '@/constants/reportsSeed'

export interface BookingStatsSeed {
  completed: number
  scheduled: number
  pending: number
  cancelled: number
}

export interface ReportFinancialSummary extends FinancialSummarySeed {}

export async function getFinancialSummary(params?: { period?: string; startDate?: string; endDate?: string }): Promise<ReportFinancialSummary | null> {
  try {
    const { data } = await api.get<{ data?: ReportFinancialSummary } | ReportFinancialSummary>('/reports/financial', { params })
    return unwrapData(data) as ReportFinancialSummary
  } catch {
    return null
  }
}

export async function getBookingStats(params?: { period?: string; startDate?: string; endDate?: string }): Promise<BookingStatsSeed | null> {
  try {
    const { data } = await api.get<{ data?: BookingStatsSeed } | BookingStatsSeed>('/reports/bookings', { params })
    return unwrapData(data) as BookingStatsSeed
  } catch {
    return null
  }
}
