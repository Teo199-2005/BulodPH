/**
 * User-scoped localStorage helpers.
 * Data persists across logout/login when keyed by user id.
 */

import { useUserSessionStore } from '@/stores/userSession'

function getUserScopedKey(baseKey: string): string {
  const session = useUserSessionStore()
  const userId = session.user?.id
  return userId ? `${baseKey}_${userId}` : `${baseKey}_guest`
}

export function getUserScopedItem<T>(baseKey: string): T | null {
  try {
    const key = getUserScopedKey(baseKey)
    const raw = localStorage.getItem(key)
    if (!raw) return null
    return JSON.parse(raw) as T
  } catch {
    return null
  }
}

export function setUserScopedItem<T>(baseKey: string, value: T): void {
  try {
    const key = getUserScopedKey(baseKey)
    localStorage.setItem(key, JSON.stringify(value))
  } catch {
    /* quota exceeded etc */
  }
}

export function removeUserScopedItem(baseKey: string): void {
  try {
    const key = getUserScopedKey(baseKey)
    localStorage.removeItem(key)
  } catch {
    /* ignore */
  }
}
