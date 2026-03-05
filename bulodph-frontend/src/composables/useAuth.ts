import { useMutation } from '@tanstack/vue-query'
import api from '@/lib/api'
import { useUserSessionStore } from '@/stores/userSession'
import { useAuthRedirectStore } from '@/stores/authRedirect'
import { useRouter } from 'vue-router'

/** Role values returned by the API; used for redirect and UI */
export type AuthRole = 'client' | 'admin' | 'car_owner' | 'marketing_staff'

export interface LoginPayload {
  email: string
  password: string
}

export interface LoginResponse {
  token: string
  user: {
    id: string
    email: string
    name?: string
    organization_id: string
    mobile: string
    is_active: boolean
    roles: string[]
    email_verified?: boolean
    email_verified_at?: string
  }
}

/** Resolve primary role for redirect (first role in list, normalized) */
export function getPrimaryRole(roles: string[]): AuthRole {
  const r = (roles && roles[0]) ? roles[0].toLowerCase() : ''
  if (r === 'admin') return 'admin'
  if (r === 'car_owner' || r === 'car owner') return 'car_owner'
  if (r === 'marketing_staff' || r === 'marketing_partner' || r === 'marketing staff') return 'marketing_staff'
  return 'client' // renter, client, etc.
}

/** Demo account emails → role (backend may return wrong roles; we override for correct redirect) */
const DEMO_EMAIL_ROLES: Record<string, AuthRole> = {
  'client@bulodph.demo': 'client',
  'admin@bulodph.demo': 'admin',
  'carowner@bulodph.demo': 'car_owner',
  'marketing@bulodph.demo': 'marketing_staff',
}

/** Route name for the user's dashboard by role */
export function getDashboardRouteForRole(role: AuthRole): string {
  switch (role) {
    case 'admin':
      return 'admin-dashboard'
    case 'car_owner':
      return 'car-owner-dashboard'
    case 'marketing_staff':
      return 'marketing-dashboard'
    default:
      return 'client-dashboard'
  }
}

export function useLogin() {
  const userSession = useUserSessionStore()
  const authRedirect = useAuthRedirectStore()
  const router = useRouter()

  return useMutation({
    mutationFn: async (payload: LoginPayload) => {
      const { data } = await api.post<LoginResponse>('/login', payload)
      return data
    },
    onSuccess: (data) => {
      authRedirect.setRedirecting(true)
      const email = (data.user.email ?? '').toLowerCase()
      const demoRole = DEMO_EMAIL_ROLES[email]
      if (demoRole) {
        data.user.roles = [demoRole]
      }
      userSession.setAuth(data.token, data.user)
      const role = getPrimaryRole(data.user.roles)
      const needsEmailVerification = role !== 'admin' && !data.user.email_verified
      if (needsEmailVerification) {
        router.push({ name: 'verify-email' })
      } else {
        router.push({ name: getDashboardRouteForRole(role) })
      }
    },
  })
}

/** Registration payload; backend stores these and hashes password */
export interface RegisterPayload {
  full_name: string
  email: string
  phone: string
  province_code: string
  city_code: string
  barangay: string
  street_address: string
  password: string
  account_type: 'renter' | 'car_owner' | 'marketing_partner'
  marketing_consent?: boolean
  /** Rental company profile (when account_type is car_owner) */
  business_name?: string
  bio?: string
  city?: string
  province?: string
  address?: string
  business_permit_number?: string
  business_address?: string
}

export function useRegister() {
  const router = useRouter()
  const authRedirect = useAuthRedirectStore()

  return useMutation({
    mutationFn: async (payload: RegisterPayload) => {
      const { data } = await api.post<{ message?: string; user?: LoginResponse['user']; token?: string }>('/register', payload)
      return data
    },
    onSuccess: (data) => {
      if (data?.token && data?.user) {
        authRedirect.setRedirecting(true)
        const userSession = useUserSessionStore()
        userSession.setAuth(data.token, data.user)
        const role = getPrimaryRole(data.user.roles)
        const needsEmailVerification = role !== 'admin' && !data.user.email_verified
        if (needsEmailVerification) {
          router.push({ name: 'verify-email' })
        } else {
          router.push({ name: getDashboardRouteForRole(role) })
        }
      } else {
        router.push({ name: 'login' })
      }
    },
  })
}

export function useLogout() {
  const userSession = useUserSessionStore()
  const router = useRouter()

  return useMutation({
    mutationFn: async () => {
      await api.post('/logout')
    },
    onSuccess: () => {
      userSession.clearAuth()
      router.push({ name: 'login' })
    },
  })
}

