import { describe, it, expect, beforeEach } from 'vitest'
import { setActivePinia, createPinia } from 'pinia'
import { useUserSessionStore } from './userSession'

describe('useUserSessionStore', () => {
    beforeEach(() => {
        setActivePinia(createPinia())
        sessionStorage.clear()
        localStorage.clear()
    })

    it('initializes with empty state', () => {
        const store = useUserSessionStore()
        expect(store.user).toBeNull()
        expect(store.token).toBeNull()
        expect(store.isAuthenticated).toBe(false)
        expect(store.isHydrated).toBe(false)
    })

    it('sets authentication', () => {
        const store = useUserSessionStore()
        const mockUser = {
            id: '1',
            email: 'test@example.com',
            organization_id: 'org1',
            mobile: '09171234567',
            is_active: true,
            roles: ['client']
        }

        store.setAuth('mock-token', mockUser)

        expect(store.token).toBe('mock-token')
        expect(store.user?.email).toBe('test@example.com')
        expect(store.isAuthenticated).toBe(true)
        expect(sessionStorage.getItem('auth_token')).toBe('mock-token')
    })

    it('clears authentication', () => {
        const store = useUserSessionStore()
        const mockUser = { id: '1', email: 'test@example.com', organization_id: 'org1', mobile: '', is_active: true, roles: [] }

        store.setAuth('mock-token', mockUser)
        store.clearAuth()

        expect(store.token).toBeNull()
        expect(store.user).toBeNull()
        expect(store.isAuthenticated).toBe(false)
        expect(sessionStorage.getItem('auth_token')).toBeNull()
    })

    it('updates user profile', () => {
        const store = useUserSessionStore()
        const mockUser = { id: '1', email: 'test@example.com', organization_id: 'org1', mobile: '', is_active: true, roles: [] }

        store.setAuth('mock-token', mockUser)
        store.updateUser({ name: 'Test User' })

        expect(store.user?.name).toBe('Test User')
        expect(JSON.parse(sessionStorage.getItem('hpa_user') || '{}').name).toBe('Test User')
    })

    it('checks permissions correctly', () => {
        const store = useUserSessionStore()
        const mockUser = { id: '1', email: 'test@example.com', organization_id: 'org1', mobile: '', is_active: true, roles: ['admin', 'client'] }

        store.setAuth('mock-token', mockUser)

        expect(store.hasRole('admin')).toBe(true)
        expect(store.hasRole('client')).toBe(true)
        expect(store.hasRole('car_owner')).toBe(false)
    })

    it('persists avatar to localStorage on updateUser and restores on setAuth', () => {
        const store = useUserSessionStore()
        const mockUser = { id: 'user-123', email: 'a@b.com', organization_id: 'org1', mobile: '', is_active: true, roles: ['client'] }
        store.setAuth('token', mockUser)

        const dataUrl = 'data:image/png;base64,abc123'
        store.updateUser({ avatar_url: dataUrl })

        expect(store.user?.avatar_url).toBe(dataUrl)
        expect(localStorage.getItem('bulodph_avatar_user-123')).toBe(dataUrl)
    })

    it('prefers localStorage avatar over API when setAuth is called with user without avatar', () => {
        const store = useUserSessionStore()
        const dataUrl = 'data:image/jpeg;base64,xyz789'
        localStorage.setItem('bulodph_avatar_user-456', dataUrl)

        const mockUser = { id: 'user-456', email: 'c@d.com', organization_id: 'org1', mobile: '', is_active: true, roles: ['client'] }
        store.setAuth('token', mockUser)

        expect(store.user?.avatar_url).toBe(dataUrl)
    })

    it('clears auth without removing avatar from localStorage', () => {
        const store = useUserSessionStore()
        const mockUser = { id: 'user-789', email: 'e@f.com', organization_id: 'org1', mobile: '', is_active: true, roles: ['client'] }
        store.setAuth('token', mockUser)
        store.updateUser({ avatar_url: 'data:image/png;base64,x' })
        expect(localStorage.getItem('bulodph_avatar_user-789')).toBeTruthy()

        store.clearAuth()
        expect(store.user).toBeNull()
        expect(localStorage.getItem('bulodph_avatar_user-789')).toBe('data:image/png;base64,x')
    })

    it('normalizes demo roles for demo account emails', () => {
        const store = useUserSessionStore()
        store.setAuth('t', {
            id: '1',
            email: 'client@bulodph.demo',
            organization_id: 'o',
            mobile: '',
            is_active: true,
            roles: ['wrong_role'],
        })
        expect(store.user?.roles).toEqual(['client'])
    })
})
