import { defineStore } from 'pinia'
import { ref, computed } from 'vue'
import { NOTIFICATIONS_SEED, type NotificationSeedItem } from '@/constants/notificationsSeed'
import { getUserScopedItem, setUserScopedItem } from '@/utils/userScopedStorage'

const STORAGE_KEY = 'bulodph_notifications'

function load(): NotificationSeedItem[] {
  const data = getUserScopedItem<NotificationSeedItem[]>(STORAGE_KEY)
  return Array.isArray(data) && data.length ? data : [...NOTIFICATIONS_SEED]
}

function save(items: NotificationSeedItem[]) {
  try {
    setUserScopedItem(STORAGE_KEY, items)
  } catch {
    // ignore
  }
}

export const useNotificationsStore = defineStore('notifications', () => {
  const items = ref<NotificationSeedItem[]>(load())

  const unreadCount = computed(() => items.value.filter((n) => !n.read).length)

  function setItems(newItems: NotificationSeedItem[]) {
    items.value = newItems
    save(newItems)
  }

  function markRead(id: string) {
    const n = items.value.find((x) => x.id === id)
    if (n) {
      n.read = true
      save([...items.value])
    }
  }

  function markAllRead() {
    items.value.forEach((n) => { n.read = true })
    save([...items.value])
  }

  function reload() {
    items.value = load()
  }

  return { items, unreadCount, setItems, markRead, markAllRead, reload }
})
