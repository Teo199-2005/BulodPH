import { describe, it, expect, beforeEach } from 'vitest'
import { setActivePinia, createPinia } from 'pinia'
import { useUserSessionStore } from '@/stores/userSession'
import { getUserScopedItem, setUserScopedItem, removeUserScopedItem } from './userScopedStorage'

const BASE_KEY = 'test_scoped_key'

describe('userScopedStorage', () => {
  beforeEach(() => {
    setActivePinia(createPinia())
    localStorage.clear()
    sessionStorage.clear()
  })

  it('returns null when no user and no stored data', () => {
    expect(getUserScopedItem(BASE_KEY)).toBeNull()
  })

  it('uses guest key when no user logged in', () => {
    setUserScopedItem(BASE_KEY, { x: 1 })
    expect(localStorage.getItem(`${BASE_KEY}_guest`)).toBe(JSON.stringify({ x: 1 }))
    expect(getUserScopedItem<{ x: number }>(BASE_KEY)).toEqual({ x: 1 })
  })

  it('stores and retrieves by user id when logged in', () => {
    const userSession = useUserSessionStore()
    userSession.setAuth('t', {
      id: 'user-abc',
      email: 'a@b.com',
      organization_id: 'o',
      mobile: '',
      is_active: true,
      roles: ['client'],
    })

    setUserScopedItem(BASE_KEY, { name: 'Test' })
    expect(localStorage.getItem(`${BASE_KEY}_user-abc`)).toBe(JSON.stringify({ name: 'Test' }))
    expect(getUserScopedItem<{ name: string }>(BASE_KEY)).toEqual({ name: 'Test' })
  })

  it('isolates data between users', () => {
    const userSession = useUserSessionStore()

    userSession.setAuth('t', {
      id: 'user-1',
      email: '1@b.com',
      organization_id: 'o',
      mobile: '',
      is_active: true,
      roles: ['client'],
    })
    setUserScopedItem(BASE_KEY, { value: 'first' })

    userSession.clearAuth()
    userSession.setAuth('t', {
      id: 'user-2',
      email: '2@b.com',
      organization_id: 'o',
      mobile: '',
      is_active: true,
      roles: ['client'],
    })
    setUserScopedItem(BASE_KEY, { value: 'second' })

    expect(getUserScopedItem<{ value: string }>(BASE_KEY)).toEqual({ value: 'second' })
    userSession.clearAuth()
    userSession.setAuth('t', {
      id: 'user-1',
      email: '1@b.com',
      organization_id: 'o',
      mobile: '',
      is_active: true,
      roles: ['client'],
    })
    expect(getUserScopedItem<{ value: string }>(BASE_KEY)).toEqual({ value: 'first' })
  })

  it('removeUserScopedItem clears key for current user', () => {
    const userSession = useUserSessionStore()
    userSession.setAuth('t', {
      id: 'user-xyz',
      email: 'x@y.com',
      organization_id: 'o',
      mobile: '',
      is_active: true,
      roles: ['client'],
    })
    setUserScopedItem(BASE_KEY, { data: true })
    expect(getUserScopedItem(BASE_KEY)).toBeTruthy()
    removeUserScopedItem(BASE_KEY)
    expect(getUserScopedItem(BASE_KEY)).toBeNull()
    expect(localStorage.getItem(`${BASE_KEY}_user-xyz`)).toBeNull()
  })
})
