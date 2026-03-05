import api from '@/lib/api'
import { unwrapData } from './api-types'
import type { ClientSeedItem } from '@/constants/clientsSeed'

export type ClientListResponse = ClientSeedItem[]

export async function getClients(params?: { search?: string }): Promise<ClientSeedItem[] | null> {
  try {
    const { data } = await api.get<{ data?: ClientSeedItem[] } | ClientSeedItem[]>('/admin/clients', { params })
    return unwrapData(data) as ClientSeedItem[]
  } catch {
    return null
  }
}

export async function getClientById(id: string | number, options?: { cacheBust?: boolean }): Promise<ClientSeedItem | null> {
  try {
    const params = options?.cacheBust ? { _: String(Date.now()) } : undefined
    const { data } = await api.get<{ data?: ClientSeedItem } | ClientSeedItem>(`/admin/clients/${id}`, { params })
    return unwrapData(data) as ClientSeedItem
  } catch {
    return null
  }
}

export async function createClient(payload: Partial<ClientSeedItem>): Promise<ClientSeedItem | null> {
  try {
    const { data } = await api.post<{ data?: ClientSeedItem } | ClientSeedItem>('/admin/clients', payload)
    return unwrapData(data) as ClientSeedItem
  } catch {
    return null
  }
}

export async function updateClient(id: string | number, payload: Partial<ClientSeedItem>): Promise<ClientSeedItem | null> {
  try {
    const { data } = await api.put<{ data?: ClientSeedItem } | ClientSeedItem>(`/admin/clients/${id}`, payload)
    return unwrapData(data) as ClientSeedItem
  } catch {
    return null
  }
}

export async function deleteClient(id: string | number): Promise<boolean> {
  try {
    await api.delete(`/admin/clients/${id}`)
    return true
  } catch {
    return false
  }
}
