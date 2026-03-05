import api from '@/lib/api'
import { unwrapData } from './api-types'
import type { RentalBookingRecord } from '@/constants/rentalBookingsSeed'

function getErrorMessage(error: unknown): string {
  const message = (error as { response?: { data?: { message?: string } } })?.response?.data?.message
  return message ?? 'Request failed. Please try again.'
}

export interface CreateBookingPayload {
  vehicleId: string
  clientId?: string
  startDate: string
  endDate: string
  amount: number
  meetUp?: string
  specialRequests?: string
}

/** Payload for creating a booking from checkout (matches backend rental_bookings). */
export interface CreateRentalBookingCheckoutPayload {
  vehicle_id: string
  vehicle_name: string
  business_name: string
  client_name: string
  client_email: string
  start_date: string
  end_date: string
  amount: number
  transaction_id?: string
}

/** Admin rental bookings (Total Bookings list). Supports pagination: per_page, page. */
export async function getRentalBookings(params?: { archived?: boolean; per_page?: number; page?: number }): Promise<RentalBookingRecord[]> {
  try {
    const { data } = await api.get<{ data?: RentalBookingRecord[]; meta?: { total: number; last_page: number } } | RentalBookingRecord[]>('/bookings', { params })
    return unwrapData(data) as RentalBookingRecord[]
  } catch (error) {
    throw new Error(getErrorMessage(error))
  }
}

/** Admin: bookings for a specific client (renter profile booking history). */
export async function getBookingsForClient(clientId: string): Promise<RentalBookingRecord[]> {
  try {
    const { data } = await api.get<{ data?: RentalBookingRecord[] } | RentalBookingRecord[]>(`/admin/clients/${clientId}/bookings`)
    return unwrapData(data) as RentalBookingRecord[] ?? []
  } catch {
    return []
  }
}

export async function getRentalBookingById(id: string): Promise<RentalBookingRecord> {
  try {
    const { data } = await api.get<{ data?: RentalBookingRecord } | RentalBookingRecord>(`/bookings/${id}`)
    return unwrapData(data) as RentalBookingRecord
  } catch (error) {
    throw new Error(getErrorMessage(error))
  }
}

export async function createRentalBooking(payload: CreateBookingPayload): Promise<RentalBookingRecord> {
  try {
    const { data } = await api.post<{ data?: RentalBookingRecord } | RentalBookingRecord>('/bookings', payload)
    return unwrapData(data) as RentalBookingRecord
  } catch (error) {
    throw new Error(getErrorMessage(error))
  }
}

/** Create a rental booking from checkout payload (backend persists and returns record). */
export async function createRentalBookingFromCheckout(
  payload: CreateRentalBookingCheckoutPayload
): Promise<RentalBookingRecord> {
  try {
    const { data } = await api.post<{ data?: RentalBookingRecord } | RentalBookingRecord>('/bookings', payload)
    return unwrapData(data) as RentalBookingRecord
  } catch (error) {
    throw new Error(getErrorMessage(error))
  }
}

export async function updateRentalBookingStatus(id: string, status: string): Promise<RentalBookingRecord> {
  try {
    const { data } = await api.patch<{ data?: RentalBookingRecord } | RentalBookingRecord>(`/bookings/${id}/status`, { status })
    return unwrapData(data) as RentalBookingRecord
  } catch (error) {
    throw new Error(getErrorMessage(error))
  }
}

export async function setRentalBookingArchived(id: string, archived: boolean): Promise<boolean> {
  try {
    await api.patch(`/bookings/${id}/archive`, { archived })
    return true
  } catch (error) {
    throw new Error(getErrorMessage(error))
  }
}

/** Admin: mark approved booking as paid (client has paid). Returns updated record. */
export async function markRentalBookingPaid(id: string): Promise<RentalBookingRecord> {
  try {
    const { data } = await api.post<{ data?: RentalBookingRecord } | RentalBookingRecord>(`/bookings/${id}/mark-paid`)
    return unwrapData(data) as RentalBookingRecord
  } catch (error) {
    throw new Error(getErrorMessage(error))
  }
}

/** Client bookings (My Bookings) */
export interface ClientBookingItem {
  id: string
  vehicleName: string
  vehicleImage: string
  vehicleId?: string
  location: string
  start: string
  end: string
  total: number
  status: string
  hostName?: string
  hostPhone?: string
  paidAt?: string | null
  ownerId?: string | null
}

export async function getClientBookings(): Promise<ClientBookingItem[]> {
  try {
    const { data } = await api.get<{ data?: ClientBookingItem[] } | ClientBookingItem[]>('/client/bookings')
    return unwrapData(data) as ClientBookingItem[]
  } catch (error) {
    throw new Error(getErrorMessage(error))
  }
}

/** Client requests cancellation (sets status to Pending cancellation; admin must approve). Returns updated record. */
export async function cancelClientBooking(id: string): Promise<ClientBookingItem> {
  try {
    const { data } = await api.patch<{ data?: ClientBookingItem } | ClientBookingItem>(`/client/bookings/${id}/cancel`)
    return unwrapData(data) as ClientBookingItem
  } catch (error) {
    throw new Error(getErrorMessage(error))
  }
}

/** Admin: approve a client's cancellation request. Sets booking to Cancelled. */
export async function adminApproveCancellationRequest(bookingId: string): Promise<RentalBookingRecord> {
  try {
    const { data } = await api.post<{ data?: RentalBookingRecord } | RentalBookingRecord>(`/bookings/${bookingId}/cancel-request/approve`)
    return unwrapData(data) as RentalBookingRecord
  } catch (error) {
    throw new Error(getErrorMessage(error))
  }
}

/** Admin: reject a client's cancellation request. Restores booking to previous status. */
export async function adminRejectCancellationRequest(bookingId: string): Promise<RentalBookingRecord> {
  try {
    const { data } = await api.post<{ data?: RentalBookingRecord } | RentalBookingRecord>(`/bookings/${bookingId}/cancel-request/reject`)
    return unwrapData(data) as RentalBookingRecord
  } catch (error) {
    throw new Error(getErrorMessage(error))
  }
}

/** Car owner bookings (backend may send vehicleId + vehicleImage from DB). */
export interface CarOwnerBookingItem {
  id: string
  vehicleId?: string
  vehicleName: string
  vehicleImage?: string
  renterName: string
  renterPhone?: string
  start: string
  end: string
  meetUp?: string
  status: string
  earnings: number
}

export async function getCarOwnerBookings(): Promise<CarOwnerBookingItem[]> {
  try {
    const { data } = await api.get<{ data?: CarOwnerBookingItem[] } | CarOwnerBookingItem[]>('/car-owner/bookings')
    return unwrapData(data) as CarOwnerBookingItem[]
  } catch (error) {
    throw new Error(getErrorMessage(error))
  }
}

/** Car owner: unseen bookings (approved/paid, not yet dismissed). For login popup. */
export async function getCarOwnerUnseenBookings(): Promise<CarOwnerBookingItem[]> {
  try {
    const { data } = await api.get<{ data?: CarOwnerBookingItem[] } | CarOwnerBookingItem[]>('/car-owner/bookings/unseen')
    return unwrapData(data) as CarOwnerBookingItem[]
  } catch (error) {
    throw new Error(getErrorMessage(error))
  }
}

/** Car owner: mark bookings as seen (close popup). */
export async function markCarOwnerBookingsSeen(ids: string[]): Promise<void> {
  try {
    await api.post('/car-owner/bookings/mark-seen', { ids })
  } catch (error) {
    throw new Error(getErrorMessage(error))
  }
}

export async function updateCarOwnerBookingStatus(id: string, status: string): Promise<boolean> {
  try {
    await api.patch(`/car-owner/bookings/${id}/status`, { status })
    return true
  } catch (error) {
    throw new Error(getErrorMessage(error))
  }
}
