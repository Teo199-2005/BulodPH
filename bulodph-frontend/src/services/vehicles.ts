import api from '@/lib/api'
import { unwrapData } from './api-types'
import type { VehicleSeedItem } from '@/constants/vehicleSeed'

/** Supports pagination: per_page, page. */
export async function getVehicles(params?: { approved?: boolean; ownerId?: string; per_page?: number; page?: number }): Promise<VehicleSeedItem[] | null> {
  try {
    const { data } = await api.get<{ data?: VehicleSeedItem[]; meta?: { total: number; last_page: number } } | VehicleSeedItem[]>('/vehicles', { params })
    return unwrapData(data) as VehicleSeedItem[]
  } catch {
    return null
  }
}

export async function getVehicleById(id: string): Promise<VehicleSeedItem | null> {
  try {
    const { data } = await api.get<{ data?: VehicleSeedItem } | VehicleSeedItem>(`/vehicles/${id}`)
    return unwrapData(data) as VehicleSeedItem
  } catch {
    return null
  }
}

export async function createVehicle(payload: Omit<VehicleSeedItem, 'id'>): Promise<VehicleSeedItem | null> {
  try {
    const { data } = await api.post<{ data?: VehicleSeedItem } | VehicleSeedItem>('/vehicles', payload)
    return unwrapData(data) as VehicleSeedItem
  } catch {
    return null
  }
}

export async function updateVehicle(id: string, payload: Partial<VehicleSeedItem>): Promise<VehicleSeedItem | null> {
  try {
    const { data } = await api.put<{ data?: VehicleSeedItem } | VehicleSeedItem>(`/vehicles/${id}`, payload)
    return unwrapData(data) as VehicleSeedItem
  } catch {
    return null
  }
}

export type DeleteVehicleResult = { ok: true } | { ok: false; status?: number; message?: string }

export async function deleteVehicle(id: string): Promise<DeleteVehicleResult> {
  try {
    const res = await api.delete(`/vehicles/${id}`)
    if (res.status === 200 || res.status === 204) return { ok: true }
    return { ok: false, status: res.status }
  } catch (err: unknown) {
    const ax = err as { response?: { status?: number; data?: { message?: string } } }
    const status = ax?.response?.status
    const message = ax?.response?.data?.message
    if (status === 404) return { ok: true }
    return { ok: false, status, message }
  }
}
