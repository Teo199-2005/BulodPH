import { describe, it, expect } from 'vitest'
import { getPrimaryRole, getDashboardRouteForRole } from './useAuth'

describe('useAuth (helpers)', () => {
  describe('getPrimaryRole', () => {
    it('returns admin for admin role', () => {
      expect(getPrimaryRole(['admin'])).toBe('admin')
    })
    it('returns car_owner for car_owner and "car owner"', () => {
      expect(getPrimaryRole(['car_owner'])).toBe('car_owner')
      expect(getPrimaryRole(['car owner'])).toBe('car_owner')
    })
    it('returns marketing_staff for marketing variants', () => {
      expect(getPrimaryRole(['marketing_staff'])).toBe('marketing_staff')
      expect(getPrimaryRole(['marketing_partner'])).toBe('marketing_staff')
      expect(getPrimaryRole(['marketing staff'])).toBe('marketing_staff')
    })
    it('returns client for client, renter, or empty', () => {
      expect(getPrimaryRole(['client'])).toBe('client')
      expect(getPrimaryRole(['renter'])).toBe('client')
      expect(getPrimaryRole([])).toBe('client')
      expect(getPrimaryRole(['unknown'])).toBe('client')
    })
    it('uses first role in list', () => {
      expect(getPrimaryRole(['admin', 'client'])).toBe('admin')
    })
  })

  describe('getDashboardRouteForRole', () => {
    it('returns correct route for each role', () => {
      expect(getDashboardRouteForRole('admin')).toBe('admin-dashboard')
      expect(getDashboardRouteForRole('car_owner')).toBe('car-owner-dashboard')
      expect(getDashboardRouteForRole('marketing_staff')).toBe('marketing-dashboard')
      expect(getDashboardRouteForRole('client')).toBe('client-dashboard')
    })
  })
})
