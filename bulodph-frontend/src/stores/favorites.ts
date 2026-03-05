import { defineStore } from 'pinia'
import { ref, computed } from 'vue'
import { getUserScopedItem, setUserScopedItem } from '@/utils/userScopedStorage'
import { useUserSessionStore } from '@/stores/userSession'
import { getFavorites as apiGet, addFavorite as apiAdd, removeFavorite as apiRemove } from '@/services/favorites'

const FAVORITES_STORAGE_KEY = 'bulodph_favorites'

function loadFavoritesLocal(): string[] {
  const data = getUserScopedItem<string[]>(FAVORITES_STORAGE_KEY)
  return Array.isArray(data) ? data : []
}

function saveFavoritesLocal(ids: string[]) {
  setUserScopedItem(FAVORITES_STORAGE_KEY, ids)
}

export const useFavoritesStore = defineStore('favorites', () => {
  const vehicleIds = ref<string[]>(loadFavoritesLocal())

  const count = computed(() => vehicleIds.value.length)
  const has = (id: string) => vehicleIds.value.includes(id)

  function setIds(ids: string[]) {
    vehicleIds.value = ids
    saveFavoritesLocal(ids)
  }

  function toggle(id: string) {
    const session = useUserSessionStore()
    if (session.token && session.user?.id) {
      if (vehicleIds.value.includes(id)) {
        apiRemove(id).then(setIds).catch(() => {})
      } else {
        apiAdd(id).then(setIds).catch(() => {})
      }
    } else {
      const i = vehicleIds.value.indexOf(id)
      if (i === -1) vehicleIds.value = [...vehicleIds.value, id]
      else vehicleIds.value = vehicleIds.value.filter((_, idx) => idx !== i)
      saveFavoritesLocal(vehicleIds.value)
    }
  }

  function add(id: string) {
    const session = useUserSessionStore()
    if (session.token && session.user?.id) {
      if (!vehicleIds.value.includes(id)) {
        apiAdd(id).then(setIds).catch(() => {})
      }
    } else if (!vehicleIds.value.includes(id)) {
      vehicleIds.value = [...vehicleIds.value, id]
      saveFavoritesLocal(vehicleIds.value)
    }
  }

  function remove(id: string) {
    const session = useUserSessionStore()
    if (session.token && session.user?.id) {
      apiRemove(id).then(setIds).catch(() => {})
    } else {
      vehicleIds.value = vehicleIds.value.filter((x) => x !== id)
      saveFavoritesLocal(vehicleIds.value)
    }
  }

  async function reload() {
    const session = useUserSessionStore()
    if (session.token && session.user?.id) {
      try {
        const ids = await apiGet()
        setIds(ids)
      } catch {
        setIds(loadFavoritesLocal())
      }
    } else {
      vehicleIds.value = loadFavoritesLocal()
    }
  }

  return { vehicleIds, count, has, toggle, add, remove, reload }
})
