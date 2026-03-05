import { defineStore } from 'pinia'
import { ref, computed } from 'vue'
import * as bookingsApi from '@/services/bookings'
import { getUserScopedItem, setUserScopedItem } from '@/utils/userScopedStorage'
import { sanitizePrice } from '@/utils/numericValidation'

export type ClientBookingStatus = 'Pending approval' | 'Pending payment' | 'Approved' | 'Confirmed' | 'Completed' | 'Cancelled' | 'Pending cancellation'

export interface ClientBooking {
  id: string
  vehicleName: string
  vehicleImage: string
  vehicleId?: string
  start: string
  end: string
  location: string
  total: number
  status: ClientBookingStatus
  hostName: string
  hostPhone: string
  /** Set when admin has marked this booking as paid; client sees Confirmed. */
  paidAt?: string | null
  /** Car owner user id (for messaging). From API when available. */
  ownerId?: string | null
}

const STORAGE_KEY = 'bulodph_client_bookings'
const INITIAL: ClientBooking[] = [
  { id: '1', vehicleName: 'Toyota Innova 2022', vehicleImage: 'https://picsum.photos/seed/innova/400/300', vehicleId: '1', start: 'Feb 10, 2026', end: 'Feb 12, 2026', location: 'Cauayan', total: 5000, status: 'Confirmed', hostName: 'Juan D.', hostPhone: '0917 123 4567' },
  { id: '2', vehicleName: 'Honda City 2023', vehicleImage: 'https://picsum.photos/seed/city/400/300', vehicleId: '2', start: 'Feb 15, 2026', end: 'Feb 15, 2026', location: 'Ilagan', total: 500, status: 'Pending payment', hostName: 'Maria S.', hostPhone: '0918 234 5678' },
  { id: '3', vehicleName: 'Toyota Vios 2021', vehicleImage: 'https://picsum.photos/seed/vios/400/300', vehicleId: '3', start: 'Jan 20, 2026', end: 'Jan 22, 2026', location: 'Santiago', total: 3600, status: 'Completed', hostName: 'Pedro R.', hostPhone: '0919 345 6789' },
]

function loadFromStorage(): ClientBooking[] {
  const stored = getUserScopedItem<ClientBooking[]>(STORAGE_KEY)
  if (!stored || !Array.isArray(stored) || !stored.length) return JSON.parse(JSON.stringify(INITIAL))
  return stored.map((b) => ({ ...b, total: sanitizePrice(b.total) }))
}

function persist(items: ClientBooking[]) {
  setUserScopedItem(STORAGE_KEY, items)
}

export const useClientBookingsStore = defineStore('clientBookings', () => {
  const list = ref<ClientBooking[]>(loadFromStorage())
  const loadError = ref('')

  const bookings = computed(() => list.value)
  const upcomingBookings = computed(() =>
    list.value.filter(b => b.status !== 'Completed' && b.status !== 'Cancelled')
  )
  const pastBookings = computed(() =>
    list.value.filter(b => b.status === 'Completed' || b.status === 'Cancelled')
  )

  function getById(id: string): ClientBooking | undefined {
    return list.value.find(b => b.id === id)
  }

  function setStatus(id: string, status: ClientBookingStatus) {
    const b = list.value.find(x => x.id === id)
    if (b) {
      b.status = status
      persist(list.value)
    }
  }

  function add(booking: Omit<ClientBooking, 'id'>, id?: string) {
    const newId = id ?? String(Date.now())
    const safeBooking = { ...booking, total: sanitizePrice(booking.total) }
    list.value = [...list.value, { ...safeBooking, id: newId }]
    persist(list.value)
    return newId
  }

  async function fetchFromApi() {
    loadError.value = ''
    try {
      const data = await bookingsApi.getClientBookings()
      if (data?.length) {
        list.value = data as ClientBooking[]
        persist(list.value)
      }
      // If API returns empty, keep current list (from storage or INITIAL)
    } catch (err) {
      loadError.value = (err as Error).message ?? 'Could not load bookings.'
    }
  }

  function reload() {
    list.value = loadFromStorage()
  }

  return {
    bookings,
    upcomingBookings,
    pastBookings,
    loadError,
    getById,
    setStatus,
    add,
    fetchFromApi,
    reload,
  }
})
