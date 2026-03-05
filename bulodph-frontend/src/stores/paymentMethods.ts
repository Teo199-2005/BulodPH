import { defineStore } from 'pinia'
import { ref, computed } from 'vue'
import { getUserScopedItem, setUserScopedItem } from '@/utils/userScopedStorage'

export interface PaymentMethod {
  id: string
  type: string
  masked: string
  isDefault: boolean
}

const STORAGE_KEY = 'bulodph_payment_methods'
const DEFAULT_METHODS: PaymentMethod[] = [
  { id: '1', type: 'GCash', masked: '0917 *** 4567', isDefault: true },
  { id: '2', type: 'Maya', masked: '0918 *** 7890', isDefault: false },
]

function load(): PaymentMethod[] {
  const stored = getUserScopedItem<PaymentMethod[]>(STORAGE_KEY)
  if (stored && Array.isArray(stored) && stored.length) return stored
  return JSON.parse(JSON.stringify(DEFAULT_METHODS))
}

function persist(items: PaymentMethod[]) {
  setUserScopedItem(STORAGE_KEY, items)
}

export const usePaymentMethodsStore = defineStore('paymentMethods', () => {
  const items = ref<PaymentMethod[]>(load())

  const methods = computed(() => items.value)
  const defaultId = computed(() => items.value.find(m => m.isDefault)?.id ?? items.value[0]?.id)

  function setDefault(id: string) {
    items.value = items.value.map(m => ({ ...m, isDefault: m.id === id }))
    persist(items.value)
  }

  function remove(id: string) {
    const list = items.value.filter(m => m.id !== id)
    if (list.length && items.value.find(m => m.id === id)?.isDefault) {
      list[0].isDefault = true
    }
    items.value = list
    persist(items.value)
  }

  function add(method: Omit<PaymentMethod, 'id'>) {
    const id = String(Date.now())
    const list = [...items.value]
    if (method.isDefault) list.forEach(m => { m.isDefault = false })
    else if (!list.length) (method as PaymentMethod).isDefault = true
    list.push({ ...method, id })
    items.value = list
    persist(items.value)
    return id
  }

  function reload() {
    items.value = load()
  }

  return { methods, defaultId, setDefault, remove, add, reload }
})
