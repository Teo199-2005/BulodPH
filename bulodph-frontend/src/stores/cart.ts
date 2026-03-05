import { defineStore } from 'pinia'
import { ref, computed } from 'vue'
import { getUserScopedItem, setUserScopedItem } from '@/utils/userScopedStorage'
import { useUserSessionStore } from '@/stores/userSession'
import { sanitizePrice, sanitizeQuantity } from '@/utils/numericValidation'
import { getCart as apiGet, addToCart as apiAdd, updateCartItem as apiUpdate, removeCartItem as apiRemove } from '@/services/cart'

const CART_STORAGE_KEY = 'bulodph_cart'

export interface CartItem {
  id: string
  vehicleId: string
  vehicleName: string
  vehicleImage: string
  location: string
  pricePerDay: number
  days?: number
  start?: string
  end?: string
}

function loadCartLocal(): CartItem[] {
  const data = getUserScopedItem<CartItem[]>(CART_STORAGE_KEY)
  if (!Array.isArray(data)) return []
  return data.map((i) => ({
    ...i,
    pricePerDay: sanitizePrice(i.pricePerDay),
    days: i.days != null ? sanitizeQuantity(i.days, { min: 1, max: 365 }) : undefined,
  }))
}

function saveCartLocal(items: CartItem[]) {
  setUserScopedItem(CART_STORAGE_KEY, items)
}

function defaultDates(): { start: string; end: string } {
  const today = new Date().toISOString().slice(0, 10)
  const tomorrow = new Date(Date.now() + 864e5).toISOString().slice(0, 10)
  return { start: today, end: tomorrow }
}

export const useCartStore = defineStore('cart', () => {
  const items = ref<CartItem[]>(loadCartLocal())

  const cart = computed(() => items.value)
  const cartTotal = computed(() =>
    items.value.reduce((sum, i) => {
      const price = sanitizePrice(i.pricePerDay)
      const days = sanitizeQuantity(i.days ?? 1, { min: 1, max: 365 })
      return sum + price * days
    }, 0)
  )
  const cartCount = computed(() => items.value.length)

  function setItems(newItems: CartItem[]) {
    items.value = newItems
    saveCartLocal(newItems)
  }

  function addItem(item: Omit<CartItem, 'id'>) {
    const safePrice = sanitizePrice(item.pricePerDay)
    const safeDays = sanitizeQuantity(item.days ?? 1, { min: 1, max: 365 })
    const { start: defStart, end: defEnd } = defaultDates()
    const start = item.start ?? defStart
    const end = item.end ?? defEnd

    const session = useUserSessionStore()
    if (session.token && session.user?.id) {
      const optimistic: CartItem = {
        id: `opt-${Date.now()}`,
        vehicleId: item.vehicleId,
        vehicleName: item.vehicleName,
        vehicleImage: item.vehicleImage,
        location: item.location ?? '',
        pricePerDay: safePrice,
        days: safeDays,
        start,
        end,
      }
      items.value = [...items.value, optimistic]
      saveCartLocal(items.value)
      apiAdd({
        vehicle_id: item.vehicleId,
        vehicle_name: item.vehicleName,
        vehicle_image: item.vehicleImage,
        start_date: start,
        end_date: end,
        price_per_day: safePrice,
      })
        .then(() => apiGet())
        .then(setItems)
        .catch(() => {
          items.value = items.value.filter((i) => i.id !== optimistic.id)
          saveCartLocal(items.value)
        })
      return
    }

    const safeItem = { ...item, pricePerDay: safePrice, days: safeDays, start, end }
    const sameVehicleAndDates = items.value.find(
      (i) => i.vehicleId === safeItem.vehicleId && i.start === safeItem.start && i.end === safeItem.end
    )
    if (sameVehicleAndDates) {
      sameVehicleAndDates.pricePerDay = safePrice
      sameVehicleAndDates.days = safeDays
      sameVehicleAndDates.start = safeItem.start
      sameVehicleAndDates.end = safeItem.end
      saveCartLocal(items.value)
      return
    }
    const sameVehicle = items.value.find((i) => i.vehicleId === safeItem.vehicleId)
    if (sameVehicle && (safeItem.start != null || safeItem.end != null)) {
      sameVehicle.pricePerDay = safePrice
      sameVehicle.start = safeItem.start
      sameVehicle.end = safeItem.end
      sameVehicle.days = safeDays
      saveCartLocal(items.value)
      return
    }
    items.value.push({ ...safeItem, id: `${safeItem.vehicleId}-${Date.now()}` })
    saveCartLocal(items.value)
  }

  function removeAt(index: number) {
    const item = items.value[index]
    if (!item) return
    const session = useUserSessionStore()
    if (session.token && session.user?.id) {
      apiRemove(item.id)
        .then(() => apiGet())
        .then(setItems)
        .catch(() => {
          items.value.splice(index, 1)
          saveCartLocal(items.value)
        })
    } else {
      items.value.splice(index, 1)
      saveCartLocal(items.value)
    }
  }

  function removeById(id: string) {
    const session = useUserSessionStore()
    if (session.token && session.user?.id) {
      apiRemove(id)
        .then(() => apiGet())
        .then(setItems)
        .catch(() => {
          items.value = items.value.filter((i) => i.id !== id)
          saveCartLocal(items.value)
        })
    } else {
      items.value = items.value.filter((i) => i.id !== id)
      saveCartLocal(items.value)
    }
  }

  function updateItemDates(index: number, start?: string, end?: string, days?: number) {
    const item = items.value[index]
    if (!item) return
    const session = useUserSessionStore()
    if (session.token && session.user?.id && (start || end)) {
      const payload: { start_date?: string; end_date?: string; price_per_day?: number } = {}
      if (start) payload.start_date = start
      if (end) payload.end_date = end
      apiUpdate(item.id, payload)
        .then(() => apiGet())
        .then(setItems)
        .catch(() => {
          if (item) {
            item.start = start
            item.end = end
            if (days != null) item.days = sanitizeQuantity(days, { min: 1, max: 365 })
            saveCartLocal(items.value)
          }
        })
    } else {
      item.start = start
      item.end = end
      if (days != null) item.days = sanitizeQuantity(days, { min: 1, max: 365 })
      saveCartLocal(items.value)
    }
  }

  function clear() {
    const session = useUserSessionStore()
    if (session.token && session.user?.id) {
      Promise.all(items.value.map((i) => apiRemove(i.id)))
        .then(() => apiGet())
        .then(setItems)
        .catch(() => {
          items.value = []
          saveCartLocal([])
        })
    } else {
      items.value = []
      saveCartLocal([])
    }
  }

  async function reload() {
    const session = useUserSessionStore()
    if (session.token && session.user?.id) {
      try {
        const list = await apiGet()
        setItems(list)
      } catch {
        setItems(loadCartLocal())
      }
    } else {
      items.value = loadCartLocal()
    }
  }

  return {
    cart,
    cartTotal,
    cartCount,
    addItem,
    removeAt,
    removeById,
    updateItemDates,
    clear,
    reload,
  }
})
