import { describe, it, expect, beforeEach } from 'vitest'
import { setActivePinia, createPinia } from 'pinia'
import { useLocaleStore } from './locale'

describe('useLocaleStore', () => {
  beforeEach(() => {
    setActivePinia(createPinia())
    localStorage.clear()
  })

  it('defaults to en', () => {
    const store = useLocaleStore()
    expect(store.locale).toBe('en')
  })

  it('reads stored locale from localStorage', () => {
    localStorage.setItem('hpa_locale', 'ar')
    setActivePinia(createPinia())
    const store = useLocaleStore()
    expect(store.locale).toBe('ar')
  })

  it('setLocale updates state and localStorage', () => {
    const store = useLocaleStore()
    store.setLocale('ar')
    expect(store.locale).toBe('ar')
    expect(localStorage.getItem('hpa_locale')).toBe('ar')
  })
})
