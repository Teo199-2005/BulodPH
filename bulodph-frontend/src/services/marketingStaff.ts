import api from '@/lib/api'
import { unwrapData } from './api-types'

export interface MarketingPartnerItem {
  id: number | string
  name?: string
  full_name?: string
  email: string
  phone: string
  city: string
  province: string
  status: string
  referrals_count: number
  avatar_url?: string | null
}

export async function getMarketingStaff(params?: { search?: string }): Promise<MarketingPartnerItem[] | null> {
  try {
    const { data } = await api.get<{ data?: MarketingPartnerItem[] } | MarketingPartnerItem[]>('/admin/marketing-staff', { params })
    return unwrapData(data) as MarketingPartnerItem[]
  } catch {
    return null
  }
}

export async function getMarketingPartnerById(id: string | number): Promise<MarketingPartnerItem | null> {
  try {
    const { data } = await api.get<{ data?: MarketingPartnerItem } | MarketingPartnerItem>(`/admin/marketing-staff/${id}`)
    return unwrapData(data) as MarketingPartnerItem
  } catch {
    return null
  }
}

export async function createMarketingPartner(payload: Partial<MarketingPartnerItem>): Promise<MarketingPartnerItem | null> {
  try {
    const { data } = await api.post<{ data?: MarketingPartnerItem } | MarketingPartnerItem>('/admin/marketing-staff', payload)
    return unwrapData(data) as MarketingPartnerItem
  } catch {
    return null
  }
}

export async function updateMarketingPartner(id: string | number, payload: Partial<MarketingPartnerItem>): Promise<MarketingPartnerItem | null> {
  try {
    const { data } = await api.put<{ data?: MarketingPartnerItem } | MarketingPartnerItem>(`/admin/marketing-staff/${id}`, payload)
    return unwrapData(data) as MarketingPartnerItem
  } catch {
    return null
  }
}

export async function deleteMarketingPartner(id: string | number): Promise<boolean> {
  try {
    await api.delete(`/admin/marketing-staff/${id}`)
    return true
  } catch {
    return false
  }
}
