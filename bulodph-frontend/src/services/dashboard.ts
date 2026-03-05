import api from '@/lib/api'
import { unwrapData } from './api-types'

export interface DashboardKpis {
  totalBookings?: number
  totalUsers?: number
  totalRevenue?: number
  upcomingBookings?: number
  totalTrips?: number
  earningsMonth?: number
  linkClicks?: number
  referralEarnings?: number
  [key: string]: number | undefined
}

export interface WeeklyBookingsSeries {
  labels: string[]
  completed: number[]
  pending: number[]
  cancelled: number[]
}

export interface CarTypeStat {
  type: string
  count: number
  percent: number
}

export async function getDashboardKpis(role?: string): Promise<DashboardKpis | null> {
  try {
    const { data } = await api.get<{ data?: DashboardKpis } | DashboardKpis>('/dashboard/kpis', {
      params: role ? { role } : undefined,
    })
    return unwrapData(data) as DashboardKpis
  } catch {
    return null
  }
}

export async function getWeeklyBookings(range: 'week' | 'month' | 'year'): Promise<WeeklyBookingsSeries | null> {
  try {
    const { data } = await api.get<{ data?: WeeklyBookingsSeries } | WeeklyBookingsSeries>('/dashboard/weekly-bookings', {
      params: { range },
    })
    return unwrapData(data) as WeeklyBookingsSeries
  } catch {
    return null
  }
}

export async function getMostRentedCarTypes(): Promise<CarTypeStat[] | null> {
  try {
    const { data } = await api.get<{ data?: CarTypeStat[] } | CarTypeStat[]>('/dashboard/car-types')
    return unwrapData(data) as CarTypeStat[]
  } catch {
    return null
  }
}
