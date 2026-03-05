import { defineStore } from 'pinia'
import { ref, computed } from 'vue'
import api from '@/lib/api'

const USER_STORAGE_KEY = 'hpa_user'
const TOKEN_STORAGE_KEY = 'auth_token'
const AVATAR_STORAGE_PREFIX = 'bulodph_avatar_'

/** Demo emails → correct role (backend may return wrong roles; fix for dashboard/UI) */
const DEMO_EMAIL_ROLES: Record<string, string> = {
  'client@bulodph.demo': 'client',
  'admin@bulodph.demo': 'admin',
  'carowner@bulodph.demo': 'car_owner',
  'marketing@bulodph.demo': 'marketing_staff',
}

function ensureDemoRoles(user: User): User {
  const email = (user.email ?? '').toLowerCase()
  const demoRole = DEMO_EMAIL_ROLES[email]
  if (demoRole && (!user.roles?.length || user.roles[0]?.toLowerCase() !== demoRole)) {
    return { ...user, roles: [demoRole] }
  }
  return user
}

function getStoredUser(): User | null {
  try {
    const raw = sessionStorage.getItem(USER_STORAGE_KEY)
    if (!raw) return null
    const data = JSON.parse(raw) as User
    return data?.id ? ensureDemoRoles(data) : null
  } catch {
    return null
  }
}

export interface User {
  id: string
  email: string
  name?: string
  organization_id: string
  mobile: string
  is_active: boolean
  roles: string[]
  /** Profile picture: data URL (base64) or URL from API; used in topbar and profile. */
  avatar_url?: string
  /** Set after OTP verification (client, car_owner, marketing_staff only). */
  email_verified?: boolean
  email_verified_at?: string
}

const IDLE_TIMEOUT_MS = 30 * 60 * 1000 // 30 minutes

export const useUserSessionStore = defineStore('userSession', () => {
  const storedUser = getStoredUser()
  const storedToken = sessionStorage.getItem(TOKEN_STORAGE_KEY)
  const token = ref<string | null>(storedUser && storedToken ? storedToken : null)
  const user = ref<User | null>(storedUser && storedToken ? storedUser : null)
  const isHydrated = ref(false)

  if (!storedUser && storedToken) {
    sessionStorage.removeItem(TOKEN_STORAGE_KEY)
  }

  const isAuthenticated = computed(() => !!token.value && !!user.value)

  const hasRole = (role: string): boolean => {
    return user.value?.roles.includes(role) ?? false
  }

  /* ── Idle timeout ─────────────────────────────────────── */
  let idleTimer: ReturnType<typeof setTimeout> | null = null

  function resetIdleTimer() {
    if (idleTimer) clearTimeout(idleTimer)
    if (!token.value) return
    idleTimer = setTimeout(() => {
      clearAuth()
      window.location.href = '/login?reason=idle'
    }, IDLE_TIMEOUT_MS)
  }

  const IDLE_EVENTS: (keyof WindowEventMap)[] = ['mousemove', 'keydown', 'scroll', 'touchstart', 'click']

  function startIdleWatch() {
    IDLE_EVENTS.forEach((evt) => window.addEventListener(evt, resetIdleTimer, { passive: true }))
    resetIdleTimer()
  }

  function stopIdleWatch() {
    IDLE_EVENTS.forEach((evt) => window.removeEventListener(evt, resetIdleTimer))
    if (idleTimer) { clearTimeout(idleTimer); idleTimer = null }
  }

  /* ── Auth management ──────────────────────────────────── */
  const setAuth = (authToken: string, userData: User) => {
    token.value = authToken
    let u = ensureDemoRoles({ ...userData })
    // Prefer server avatar from login response; fall back to localStorage cache
    if (u.id) {
      try {
        const stored = localStorage.getItem(AVATAR_STORAGE_PREFIX + u.id)
        if (stored && !u.avatar_url) u = { ...u, avatar_url: stored }
      } catch { /* ignore */ }
    }
    user.value = u
    sessionStorage.setItem(TOKEN_STORAGE_KEY, authToken)
    sessionStorage.setItem(USER_STORAGE_KEY, JSON.stringify(user.value))
    startIdleWatch()
  }

  const clearAuth = () => {
    stopIdleWatch()
    token.value = null
    user.value = null
    sessionStorage.removeItem(TOKEN_STORAGE_KEY)
    sessionStorage.removeItem(USER_STORAGE_KEY)
  }

  /** Update user profile (e.g. name, avatar_url) in memory and persist. */
  const updateUser = (updates: Partial<User>) => {
    if (!user.value) return
    user.value = { ...user.value, ...updates }
    sessionStorage.setItem(USER_STORAGE_KEY, JSON.stringify(user.value))
    // Persist avatar to localStorage as cache so it survives logout/login; API also stores it (users.avatar_url / client_profiles.avatar_url)
    if ('avatar_url' in updates && user.value.id) {
      try {
        const key = AVATAR_STORAGE_PREFIX + user.value.id
        if (updates.avatar_url) {
          localStorage.setItem(key, updates.avatar_url)
        } else {
          localStorage.removeItem(key)
        }
      } catch { /* ignore quota exceeded etc */ }
    }
  }

  const hydrate = async () => {
    if (isHydrated.value) return
    if (!token.value) {
      isHydrated.value = true
      return
    }
    try {
      const { data } = await api.get<User>('/me')
      let u = ensureDemoRoles(data)
      // Prefer server avatar from /me; fall back to localStorage cache
      if (u.id) {
        try {
          const stored = localStorage.getItem(AVATAR_STORAGE_PREFIX + u.id)
          if (stored && !u.avatar_url) u = { ...u, avatar_url: stored }
        } catch { /* ignore */ }
      }
      user.value = u
      sessionStorage.setItem(USER_STORAGE_KEY, JSON.stringify(user.value))
      startIdleWatch()
    } catch {
      clearAuth()
    } finally {
      isHydrated.value = true
    }
  }

  // If already authenticated on load (from sessionStorage), start watching
  if (storedUser && storedToken) startIdleWatch()

  return {
    user,
    token,
    isAuthenticated,
    hasRole,
    setAuth,
    clearAuth,
    updateUser,
    hydrate,
    isHydrated,
  }
})

