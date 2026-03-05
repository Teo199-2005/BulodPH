import { describe, it, expect, beforeEach } from 'vitest'
import { setActivePinia, createPinia } from 'pinia'
import { useAgreementAcceptanceStore } from './agreementAcceptance'
import { useUserSessionStore } from './userSession'

describe('useAgreementAcceptanceStore', () => {
  beforeEach(() => {
    setActivePinia(createPinia())
    localStorage.clear()
    sessionStorage.clear()
  })

  it('exposes agreement versions', () => {
    const store = useAgreementAcceptanceStore()
    expect(store.carOwnerVersion).toBeDefined()
    expect(store.clientVersion).toBeDefined()
  })

  it('has not accepted when no localStorage entry', () => {
    const store = useAgreementAcceptanceStore()
    expect(store.hasAcceptedCarOwnerAgreement).toBe(false)
    expect(store.hasAcceptedClientRentalAgreement).toBe(false)
  })

  it('accepts car owner agreement and persists per user', () => {
    const userSession = useUserSessionStore()
    const store = useAgreementAcceptanceStore()

    userSession.setAuth('t', {
      id: 'user-a',
      email: 'a@b.com',
      organization_id: 'o',
      mobile: '',
      is_active: true,
      roles: ['car_owner'],
    })

    store.acceptCarOwnerAgreement()
    expect(store.hasAcceptedCarOwnerAgreement).toBe(true)
    const key = `bulodph_car_owner_agreement_v_user-a_accepted`
    expect(localStorage.getItem(key)).toBe(store.carOwnerVersion)
  })

  it('accepts client rental agreement and persists per user', () => {
    const userSession = useUserSessionStore()
    const store = useAgreementAcceptanceStore()

    userSession.setAuth('t', {
      id: 'user-b',
      email: 'b@c.com',
      organization_id: 'o',
      mobile: '',
      is_active: true,
      roles: ['client'],
    })

    store.acceptClientRentalAgreement()
    expect(store.hasAcceptedClientRentalAgreement).toBe(true)
    const key = `bulodph_client_rental_agreement_v_user-b_accepted`
    expect(localStorage.getItem(key)).toBe(store.clientVersion)
  })

  it('scopes acceptance by user id so different users have separate state', () => {
    const userSession = useUserSessionStore()
    const store = useAgreementAcceptanceStore()

    userSession.setAuth('t', {
      id: 'user-1',
      email: 'u1@b.com',
      organization_id: 'o',
      mobile: '',
      is_active: true,
      roles: ['car_owner'],
    })
    store.acceptCarOwnerAgreement()
    expect(store.hasAcceptedCarOwnerAgreement).toBe(true)

    userSession.clearAuth()
    userSession.setAuth('t', {
      id: 'user-2',
      email: 'u2@b.com',
      organization_id: 'o',
      mobile: '',
      is_active: true,
      roles: ['car_owner'],
    })
    expect(store.hasAcceptedCarOwnerAgreement).toBe(false)

    const key1 = 'bulodph_car_owner_agreement_v_user-1_accepted'
    const key2 = 'bulodph_car_owner_agreement_v_user-2_accepted'
    expect(localStorage.getItem(key1)).toBeTruthy()
    expect(localStorage.getItem(key2)).toBeNull()
  })
})
