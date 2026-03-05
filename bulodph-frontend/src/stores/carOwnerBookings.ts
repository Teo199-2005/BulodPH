import { defineStore } from 'pinia'
import { ref, computed } from 'vue'
import * as bookingsApi from '@/services/bookings'
import { getUserScopedItem, setUserScopedItem } from '@/utils/userScopedStorage'

export type CarOwnerBookingStatus = 'Requested' | 'Confirmed' | 'Active' | 'Completed' | 'Declined'

export interface CarOwnerBooking {
  id: string
  vehicleId?: string
  vehicleName: string
  vehicleImage?: string
  renterName: string
  renterPhone?: string
  start: string
  end: string
  meetUp?: string
  status: CarOwnerBookingStatus
  earnings: number
}

const STORAGE_KEY = 'bulodph_car_owner_bookings'
const INITIAL: CarOwnerBooking[] = [
  { id: '1', vehicleName: 'Toyota Innova 2022', renterName: 'Mary J.', renterPhone: '0917 111 2233', start: 'Feb 10, 2026', end: 'Feb 12, 2026', meetUp: 'Cauayan city plaza', status: 'Requested', earnings: 0 },
  { id: '2', vehicleName: 'Toyota Innova 2022', renterName: 'Robert W.', renterPhone: '0918 222 3344', start: 'Feb 15, 2026', end: 'Feb 16, 2026', meetUp: '', status: 'Confirmed', earnings: 0 },
  { id: '3', vehicleName: 'Honda City 2023', renterName: 'Patricia M.', renterPhone: '0919 333 4455', start: 'Jan 20, 2026', end: 'Jan 20, 2026', meetUp: 'Ilagan', status: 'Completed', earnings: 500 },
]

function loadFromStorage(): CarOwnerBooking[] {
  const stored = getUserScopedItem<CarOwnerBooking[]>(STORAGE_KEY)
  if (stored && Array.isArray(stored) && stored.length) return stored
  return JSON.parse(JSON.stringify(INITIAL))
}

function persist(items: CarOwnerBooking[]) {
  setUserScopedItem(STORAGE_KEY, items)
}

export const useCarOwnerBookingsStore = defineStore('carOwnerBookings', () => {
  const list = ref<CarOwnerBooking[]>(loadFromStorage())
  const loadError = ref('')

  const requested = computed(() => list.value.filter(b => b.status === 'Requested'))
  const upcoming = computed(() => list.value.filter(b => b.status === 'Confirmed' || b.status === 'Active'))
  const completed = computed(() => list.value.filter(b => b.status === 'Completed'))

  function getById(id: string): CarOwnerBooking | undefined {
    return list.value.find(b => b.id === id)
  }

  async function setStatus(id: string, status: CarOwnerBookingStatus) {
    const b = list.value.find(x => x.id === id)
    if (b) {
      const previous = b.status
      b.status = status
      try {
        await bookingsApi.updateCarOwnerBookingStatus(id, status)
      } catch (err) {
        b.status = previous
        loadError.value = (err as Error).message ?? 'Could not update booking.'
      }
      persist(list.value)
    }
  }

  function add(booking: Omit<CarOwnerBooking, 'id'>, id?: string) {
    const newId = id ?? String(Date.now())
    list.value = [...list.value, { ...booking, id: newId }]
    persist(list.value)
    return newId
  }

  async function fetchFromApi() {
    loadError.value = ''
    try {
      const data = await bookingsApi.getCarOwnerBookings()
      if (data?.length) {
        list.value = data as CarOwnerBooking[]
        persist(list.value)
      }
    } catch (err) {
      loadError.value = (err as Error).message ?? 'Could not load bookings.'
    }
  }

  function reload() {
    list.value = loadFromStorage()
  }

  return { list, requested, upcoming, completed, loadError, getById, setStatus, add, fetchFromApi, reload }
})
