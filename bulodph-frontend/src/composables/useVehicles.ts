import { ref, computed } from 'vue'
import { VEHICLE_SEED, type VehicleSeedItem } from '@/constants/vehicleSeed'
import * as vehiclesApi from '@/services/vehicles'

const vehicles = ref<VehicleSeedItem[]>(JSON.parse(JSON.stringify(VEHICLE_SEED)))
const loading = ref(false)

export function useVehicles() {
  async function fetchFromApi() {
    loading.value = true
    try {
      const data = await vehiclesApi.getVehicles({ approved: true, per_page: 100 })
      if (data) {
        vehicles.value = data
      }
    } finally {
      loading.value = false
    }
  }

  const list = computed(() => vehicles.value)

  const getById = (id: string): VehicleSeedItem | undefined => {
    return vehicles.value.find(v => v.id === id)
  }

  const add = async (item: Omit<VehicleSeedItem, 'id'>): Promise<VehicleSeedItem | null> => {
    const payload = { ...item, approved: item.approved !== false ? true : item.approved }
    const created = await vehiclesApi.createVehicle(payload)
    if (created?.id) {
      const withApproved = created.approved !== false ? { ...created, approved: true as const } : created
      vehicles.value = [...vehicles.value, withApproved]
      return withApproved
    }
    return null
  }

  const update = async (id: string, patch: Partial<VehicleSeedItem>): Promise<VehicleSeedItem | null> => {
    const updated = await vehiclesApi.updateVehicle(id, patch)
    if (updated) {
      const i = vehicles.value.findIndex(v => v.id === id)
      if (i !== -1) {
        vehicles.value = vehicles.value.slice()
        vehicles.value[i] = { ...vehicles.value[i], ...updated }
      }
      return updated
    }
    return null
  }

  const remove = async (id: string): Promise<{ ok: true } | { ok: false; message?: string }> => {
    const result = await vehiclesApi.deleteVehicle(id)
    if (result.ok) {
      vehicles.value = vehicles.value.filter(v => v.id !== id)
      return { ok: true }
    }
    return { ok: false, message: result.message }
  }

  const approvedList = computed(() =>
    vehicles.value.filter(v => v.approved !== false && v.hiddenFromListing !== true)
  )

  return { vehicles: list, approvedVehicles: approvedList, loading, getById, add, update, remove, fetchFromApi }
}
