import api from '@/lib/api'

export async function getFavorites(): Promise<string[]> {
  const { data } = await api.get<{ data?: string[] }>('/favorites')
  return Array.isArray(data?.data) ? data.data : []
}

export async function addFavorite(vehicleId: string): Promise<string[]> {
  const { data } = await api.post<{ data?: string[] }>('/favorites', { vehicle_id: vehicleId })
  return Array.isArray(data?.data) ? data.data : []
}

export async function removeFavorite(vehicleId: string): Promise<string[]> {
  const res = await api.delete<{ data?: string[] }>(`/favorites/${vehicleId}`)
  return Array.isArray(res?.data?.data) ? res.data.data : []
}
