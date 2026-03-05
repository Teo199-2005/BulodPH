import api from '@/lib/api'
import { unwrapData } from './api-types'

export interface CarOwnerItem {
  id: number
  full_name: string
  email: string
  phone: string
  city: string
  province: string
  status: string
  account_status: string
  verified: boolean
  has_permit: boolean
  listings_count: number
  avatar_url?: string | null
  logo_url?: string | null
  business_name?: string | null
}

export async function getCarOwners(params?: { search?: string }): Promise<CarOwnerItem[] | null> {
  try {
    const { data } = await api.get<{ data?: CarOwnerItem[] } | CarOwnerItem[]>('/admin/car-owners', { params })
    return unwrapData(data) as CarOwnerItem[]
  } catch {
    return null
  }
}

export async function getCarOwnerById(id: string | number): Promise<CarOwnerItem | null> {
  try {
    const { data } = await api.get<{ data?: CarOwnerItem } | CarOwnerItem>(`/admin/car-owners/${id}`)
    return unwrapData(data) as CarOwnerItem
  } catch {
    return null
  }
}

export async function createCarOwner(payload: Partial<CarOwnerItem>): Promise<CarOwnerItem | null> {
  try {
    const { data } = await api.post<{ data?: CarOwnerItem } | CarOwnerItem>('/admin/car-owners', payload)
    return unwrapData(data) as CarOwnerItem
  } catch {
    return null
  }
}

export async function updateCarOwner(id: string | number, payload: Partial<CarOwnerItem>): Promise<CarOwnerItem | null> {
  try {
    const { data } = await api.put<{ data?: CarOwnerItem } | CarOwnerItem>(`/admin/car-owners/${id}`, payload)
    return unwrapData(data) as CarOwnerItem
  } catch {
    return null
  }
}

export async function deleteCarOwner(id: string | number): Promise<boolean> {
  try {
    await api.delete(`/admin/car-owners/${id}`)
    return true
  } catch {
    return false
  }
}
