import { ref } from 'vue'
import { RENTAL_BOOKINGS_SEED, type RentalBookingRecord } from '@/constants/rentalBookingsSeed'
import * as bookingsApi from '@/services/bookings'

const records = ref<RentalBookingRecord[]>(JSON.parse(JSON.stringify(RENTAL_BOOKINGS_SEED)))
const error = ref('')

export function useRentalBookings() {
  async function fetchFromApi() {
    error.value = ''
    try {
      const data = await bookingsApi.getRentalBookings()
      if (data?.length) records.value = data as RentalBookingRecord[]
    } catch (err) {
      error.value = (err as Error).message ?? 'Could not load bookings.'
    }
  }

  const getById = (id: string): RentalBookingRecord | undefined => {
    return records.value.find(r => r.id === id)
  }

  const setArchived = async (id: string, archived: boolean) => {
    const r = records.value.find(x => x.id === id)
    if (r) {
      const previous = r.archived
      r.archived = archived
      try {
        await bookingsApi.setRentalBookingArchived(id, archived)
      } catch (err) {
        r.archived = previous
        error.value = (err as Error).message ?? 'Could not update booking.'
      }
    }
  }

  const setStatus = async (id: string, status: RentalBookingRecord['status']) => {
    const r = records.value.find(x => x.id === id)
    if (r) {
      const previous = r.status
      r.status = status
      try {
        await bookingsApi.updateRentalBookingStatus(id, status)
      } catch (err) {
        r.status = previous
        error.value = (err as Error).message ?? 'Could not update booking.'
      }
    }
  }

  const markAsPaid = async (id: string) => {
    const r = records.value.find(x => x.id === id)
    if (!r) return
    try {
      const updated = await bookingsApi.markRentalBookingPaid(id)
      r.paidAt = updated.paidAt
    } catch (err) {
      error.value = (err as Error).message ?? 'Could not mark as paid.'
      throw err
    }
  }

  const add = (record: Omit<RentalBookingRecord, 'id'>, id?: string) => {
    const newId = id ?? String(Date.now())
    records.value = [...records.value, { ...record, id: newId }]
    return newId
  }

  /** Update local record after an API call that returned the full record (e.g. approve/reject cancellation). */
  function applyRecordUpdate(id: string, updates: Partial<RentalBookingRecord>) {
    const r = records.value.find(x => x.id === id)
    if (r) Object.assign(r, updates)
  }

  return {
    records,
    error,
    getById,
    setArchived,
    setStatus,
    markAsPaid,
    add,
    applyRecordUpdate,
    fetchFromApi,
  }
}
