import { describe, it, expect } from 'vitest'
import { ROUTES, SITE_URLS, CONTACT } from './siteUrls'

describe('siteUrls', () => {
  describe('ROUTES', () => {
    it('defines login and register paths', () => {
      expect(ROUTES.login).toBe('/login')
      expect(ROUTES.register).toBe('/register')
    })
    it('has expected route keys', () => {
      expect(ROUTES).toHaveProperty('home')
      expect(ROUTES).toHaveProperty('login')
      expect(ROUTES).toHaveProperty('register')
      expect(ROUTES).toHaveProperty('privacy')
      expect(ROUTES).toHaveProperty('terms')
      expect(ROUTES).toHaveProperty('trustSafety')
      expect(ROUTES).toHaveProperty('partners')
    })
  })

  describe('SITE_URLS', () => {
    it('has home and legal paths', () => {
      expect(SITE_URLS).toHaveProperty('home')
      expect(SITE_URLS).toHaveProperty('privacy')
      expect(SITE_URLS).toHaveProperty('terms')
    })
  })

  describe('CONTACT', () => {
    it('defines email and phone', () => {
      expect(CONTACT.email).toBeTruthy()
      expect(CONTACT.phoneHref).toMatch(/^tel:/)
      expect(CONTACT.emailHref).toMatch(/^mailto:/)
    })
  })
})
