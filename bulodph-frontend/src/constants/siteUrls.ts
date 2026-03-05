/**
 * BulodPH site-wide URLs – contact, social, and map embed.
 * Single source of truth for footer, hero, contact page, and legal pages.
 */

const BASE = typeof window !== 'undefined' ? window.location.origin : ''

/** In-app routes (use with router-link or $router.push) */
export const ROUTES = {
  home: '/',
  about: '/about',
  fleet: '/fleet',
  blog: '/blog',
  contact: '/contact',
  faq: '/faq',
  login: '/login',
  register: '/register',
  privacy: '/privacy',
  terms: '/terms',
  accessibility: '/accessibility',
  trustSafety: '/trust-safety',
  partners: '/partners',
} as const

/** Full URLs for same-origin links (e.g. canonical, share) */
export const SITE_URLS = {
  home: `${BASE}/`,
  about: `${BASE}/about`,
  fleet: `${BASE}/fleet`,
  blog: `${BASE}/blog`,
  contact: `${BASE}/contact`,
  faq: `${BASE}/faq`,
  privacy: `${BASE}/privacy`,
  terms: `${BASE}/terms`,
  accessibility: `${BASE}/accessibility`,
  trustSafety: `${BASE}/trust-safety`,
  partners: `${BASE}/partners`,
} as const

/** Contact – use in href="tel:" and mailto: */
export const CONTACT = {
  phone: '+63 912 345 6789',
  phoneHref: 'tel:+639123456789',
  email: 'hello@bulodph.com',
  emailHref: 'mailto:hello@bulodph.com',
  supportEmail: 'support@bulodph.com',
  supportEmailHref: 'mailto:support@bulodph.com',
  privacyEmail: 'privacy@bulodph.com',
  privacyEmailHref: 'mailto:privacy@bulodph.com',
  accessibilityEmail: 'accessibility@bulodph.com',
  accessibilityEmailHref: 'mailto:accessibility@bulodph.com',
  address: 'National Highway, San Fermin, Cauayan City, Isabela 3305, Philippines',
  locationShort: 'The region, Philippines',
} as const

/** Social – full URLs for external links */
export const SOCIAL = {
  facebook: 'https://www.facebook.com/bulodph',
  instagram: 'https://www.instagram.com/bulodph/',
  twitter: 'https://twitter.com/bulodph',
  x: 'https://x.com/bulodph',
} as const

/** Google Maps link – opens in new tab */
export const MAP_LINK_URL =
  'https://www.google.com/maps/search/?api=1&query=Cauayan+City%2C+Isabela%2C+Philippines'

/** Image shown in footer/contact instead of map widget (Bulod PH branding/dashboard showcase). Native size: 826×806 px (~1:1). Use 2x for sharpness on Retina. */
export const FOOTER_SHOWCASE_IMAGE = '/images/bulod-dashboard-showcase.png'
/** Optional 2x image (e.g. 1652×1612) for Retina; set to same as FOOTER_SHOWCASE_IMAGE if you don't have a 2x asset. */
export const FOOTER_SHOWCASE_IMAGE_2X = '/images/bulod-dashboard-showcase.png'
