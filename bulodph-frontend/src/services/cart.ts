import api from '@/lib/api'
import type { CartItem } from '@/stores/cart'

export interface ApiCartItem {
  id: string
  vehicle_id: string
  vehicle_name: string | null
  vehicle_image: string | null
  location: string | null
  start_date: string
  end_date: string
  price_per_day: number
  quantity_days: number
  meet_up: string | null
}

function toStoreItem(a: ApiCartItem): CartItem {
  return {
    id: a.id,
    vehicleId: a.vehicle_id,
    vehicleName: a.vehicle_name ?? '',
    vehicleImage: a.vehicle_image ?? '',
    location: a.location ?? '',
    pricePerDay: a.price_per_day,
    days: a.quantity_days,
    start: a.start_date,
    end: a.end_date,
  }
}

export async function getCart(): Promise<CartItem[]> {
  const { data } = await api.get<{ data?: ApiCartItem[] }>('/cart')
  const list = Array.isArray(data?.data) ? data.data : []
  return list.map(toStoreItem)
}

export async function addToCart(payload: {
  vehicle_id: string
  vehicle_name?: string
  vehicle_image?: string
  start_date: string
  end_date: string
  price_per_day: number
  meet_up?: string
}): Promise<CartItem> {
  const { data } = await api.post<{ data?: ApiCartItem }>('/cart', payload)
  if (!data?.data) throw new Error('Invalid response')
  return toStoreItem(data.data)
}

export async function updateCartItem(
  id: string,
  payload: { start_date?: string; end_date?: string; price_per_day?: number }
): Promise<CartItem> {
  const { data } = await api.put<{ data?: ApiCartItem }>(`/cart/${id}`, payload)
  if (!data?.data) throw new Error('Invalid response')
  return toStoreItem(data.data)
}

export async function removeCartItem(id: string): Promise<void> {
  await api.delete(`/cart/${id}`)
}
