import { ref } from 'vue'
import { useUserSessionStore } from '@/stores/userSession'
import type { VehicleSeedItem } from '@/constants/vehicleSeed'

const STORAGE_KEY = 'bulodph_car_owner_vehicles'

/** Bump this so computeds that depend on stored vehicles re-read (e.g. after remove). */
export const storageRefreshTrigger = ref(0)

type StoredByUser = Record<string, VehicleSeedItem[]>

function getStorage(): StoredByUser {
  try {
    const raw = localStorage.getItem(STORAGE_KEY)
    return raw ? (JSON.parse(raw) as StoredByUser) : {}
  } catch {
    return {}
  }
}

function setStorage(data: StoredByUser) {
  try {
    localStorage.setItem(STORAGE_KEY, JSON.stringify(data))
  } catch {
    // ignore
  }
}

function ownerKey(): string {
  const user = useUserSessionStore().user
  return (user?.id ?? user?.name ?? '').toString().trim() || 'default'
}

/** Vehicles stored for the current car owner (survives refresh). */
export function getStoredVehiclesForCurrentUser(): VehicleSeedItem[] {
  const key = ownerKey()
  const data = getStorage()
  return data[key] ?? []
}

/** Get one stored vehicle by id (for edit page). */
export function getStoredVehicleById(id: string): VehicleSeedItem | undefined {
  return getStoredVehiclesForCurrentUser().find(v => v.id === id)
}

/** Append a vehicle after successful add (call from form). */
export function persistVehicle(vehicle: VehicleSeedItem) {
  const key = ownerKey()
  const data = getStorage()
  const list = data[key] ?? []
  const idx = list.findIndex(v => v.id === vehicle.id)
  if (idx >= 0) list[idx] = vehicle
  else list.push(vehicle)
  data[key] = list
  setStorage(data)
}

/** Update a stored vehicle (e.g. after toggle availability). */
export function updateStoredVehicle(id: string, patch: Partial<VehicleSeedItem>) {
  const key = ownerKey()
  const data = getStorage()
  const list = data[key] ?? []
  const i = list.findIndex(v => v.id === id)
  if (i >= 0) {
    list[i] = { ...list[i], ...patch }
    data[key] = list
    setStorage(data)
  }
}

/** Remove a stored vehicle (after delete). */
export function removeStoredVehicle(id: string) {
  const key = ownerKey()
  const data = getStorage()
  const list = (data[key] ?? []).filter(v => v.id !== id)
  data[key] = list
  setStorage(data)
  storageRefreshTrigger.value++
}
