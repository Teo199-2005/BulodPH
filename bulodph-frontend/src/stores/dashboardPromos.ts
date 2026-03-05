import { defineStore } from 'pinia'
import { ref, computed } from 'vue'

const STORAGE_KEY = 'bulodph_dashboard_promos'

export type DashboardPromoRole = 'client' | 'car_owner' | 'marketing' | 'all'

export interface DashboardPromo {
  id: string
  imageUrl: string
  /** Detected or set when admin uploads (natural width in px). */
  imageWidth?: number
  /** Detected or set when admin uploads (natural height in px). */
  imageHeight?: number
  title: string
  linkUrl?: string
  /** Which dashboard(s) show this promo */
  targetRole: DashboardPromoRole
  order: number
  active: boolean
  createdAt: string
}

const SEED: DashboardPromo[] = [
  {
    id: '1',
    imageUrl: 'https://picsum.photos/seed/promo1/800/320',
    imageWidth: 800,
    imageHeight: 320,
    title: '10% off on 1-day booking',
    linkUrl: '/client/promo',
    targetRole: 'client',
    order: 1,
    active: true,
    createdAt: new Date().toISOString(),
  },
  {
    id: '2',
    imageUrl: 'https://picsum.photos/seed/promo2/800/320',
    imageWidth: 800,
    imageHeight: 320,
    title: 'List your vehicle and earn',
    linkUrl: '/car-owner/vehicles',
    targetRole: 'car_owner',
    order: 1,
    active: true,
    createdAt: new Date().toISOString(),
  },
  {
    id: '3',
    imageUrl: 'https://picsum.photos/seed/promo3/800/320',
    imageWidth: 800,
    imageHeight: 320,
    title: 'Share and earn with referrals',
    linkUrl: '/marketing/referral',
    targetRole: 'marketing',
    order: 1,
    active: true,
    createdAt: new Date().toISOString(),
  },
]

function loadFromStorage(): DashboardPromo[] {
  try {
    const raw = localStorage.getItem(STORAGE_KEY)
    const data = !raw
      ? JSON.parse(JSON.stringify(SEED))
      : (JSON.parse(raw) as DashboardPromo[])
    const list = Array.isArray(data) && data.length ? data : JSON.parse(JSON.stringify(SEED))
    const maxId = list.reduce((max: number, p: DashboardPromo) => Math.max(max, parseInt(p.id, 10) || 0), 0)
    nextId = Math.max(100, maxId + 1)
    return list
  } catch {
    return JSON.parse(JSON.stringify(SEED))
  }
}

function saveToStorage(list: DashboardPromo[]) {
  localStorage.setItem(STORAGE_KEY, JSON.stringify(list))
}

let nextId = 100
function generateId() {
  return String(nextId++)
}

export const useDashboardPromosStore = defineStore('dashboardPromos', () => {
  const list = ref<DashboardPromo[]>(loadFromStorage())

  const all = computed(() => [...list.value].sort((a, b) => a.order - b.order || a.createdAt.localeCompare(b.createdAt)))

  function getByRole(role: DashboardPromoRole): DashboardPromo[] {
    return list.value
      .filter((p) => p.active && (p.targetRole === role || p.targetRole === 'all'))
      .sort((a, b) => a.order - b.order)
  }

  function getById(id: string): DashboardPromo | undefined {
    return list.value.find((p) => p.id === id)
  }

  function add(item: Omit<DashboardPromo, 'id' | 'createdAt'>) {
    const maxOrder = Math.max(0, ...list.value.map((p) => p.order))
    const newItem: DashboardPromo = {
      ...item,
      id: generateId(),
      createdAt: new Date().toISOString(),
      order: item.order ?? maxOrder + 1,
    }
    list.value = [...list.value, newItem]
    saveToStorage(list.value)
    return newItem.id
  }

  function update(id: string, patch: Partial<Omit<DashboardPromo, 'id' | 'createdAt'>>) {
    const i = list.value.findIndex((p) => p.id === id)
    if (i === -1) return
    list.value = list.value.slice()
    list.value[i] = { ...list.value[i], ...patch }
    saveToStorage(list.value)
  }

  function remove(id: string) {
    list.value = list.value.filter((p) => p.id !== id)
    saveToStorage(list.value)
  }

  return {
    list: all,
    getByRole,
    getById,
    add,
    update,
    remove,
  }
})
