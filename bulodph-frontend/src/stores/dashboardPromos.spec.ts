import { describe, it, expect, beforeEach } from 'vitest'
import { setActivePinia, createPinia } from 'pinia'
import { useDashboardPromosStore } from './dashboardPromos'

describe('useDashboardPromosStore', () => {
  beforeEach(() => {
    setActivePinia(createPinia())
    localStorage.clear()
  })

  it('loads seed promos when storage is empty', () => {
    const store = useDashboardPromosStore()
    expect(Array.isArray(store.list)).toBe(true)
    expect(store.list.length).toBeGreaterThanOrEqual(1)
  })

  it('getByRole returns only active promos for that role', () => {
    const store = useDashboardPromosStore()
    const clientPromos = store.getByRole('client')
    expect(clientPromos.every((p) => p.active && (p.targetRole === 'client' || p.targetRole === 'all'))).toBe(true)
  })

  it('add creates new promo and persists', () => {
    const store = useDashboardPromosStore()
    const id = store.add({
      imageUrl: 'https://example.com/promo.jpg',
      title: 'Test Promo',
      targetRole: 'client',
      order: 10,
      active: true,
    })
    expect(id).toBeDefined()
    const found = store.getById(id)
    expect(found?.title).toBe('Test Promo')
  })

  it('update patches existing promo', () => {
    const store = useDashboardPromosStore()
    const id = store.list[0]?.id
    if (!id) return
    store.update(id, { title: 'Updated Title' })
    expect(store.getById(id)?.title).toBe('Updated Title')
  })

  it('remove deletes promo', () => {
    const store = useDashboardPromosStore()
    const id = store.add({
      imageUrl: 'https://x.com/y.jpg',
      title: 'To Remove',
      targetRole: 'client',
      order: 1,
      active: true,
    })
    store.remove(id)
    expect(store.getById(id)).toBeUndefined()
  })
})
