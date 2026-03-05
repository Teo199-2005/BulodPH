/**
 * Image Constants for BulodPH
 * Centralized image URLs for consistency across the application
 */

export const IMAGES = {
  // Dashboard (car-sharing context)
  dashboard: {
    welcome: 'https://images.unsplash.com/photo-1449965408869-eaa3f722e40d?w=1200&q=80&fit=crop',
    healthcare: 'https://images.unsplash.com/photo-1549317661-bd32c8ce0db2?w=800&q=80&fit=crop',
    team: 'https://images.unsplash.com/photo-1568602471122-7832951cc4c5?w=800&q=80&fit=crop',
    caregiving: 'https://images.unsplash.com/photo-1502877338535-766e1452684a?w=800&q=80&fit=crop',
    medical: 'https://images.unsplash.com/photo-1492144534655-ae79c964c9d7?w=800&q=80&fit=crop',
  },

  // Empty State Illustrations
  emptyStates: {
    noData: 'https://illustrations.popsy.co/amber/no-data.svg',
    noShifts: 'https://illustrations.popsy.co/amber/calendar.svg',
    noClients: 'https://illustrations.popsy.co/amber/people.svg',
    noStaff: 'https://illustrations.popsy.co/amber/team.svg',
    noReports: 'https://illustrations.popsy.co/amber/analytics.svg',
    error: 'https://illustrations.popsy.co/amber/error.svg',
    success: 'https://illustrations.popsy.co/amber/success.svg',
    emptyInbox: 'https://illustrations.popsy.co/amber/inbox.svg',
    noResults: 'https://illustrations.popsy.co/amber/search.svg',
  },

  placeholders: {
    avatar: (name: string) =>
      `https://ui-avatars.com/api/?name=${encodeURIComponent(name)}&background=057197&color=fff&size=128&bold=true`,
    client: 'https://images.unsplash.com/photo-1438761681033-6461ffad8d80?w=400&q=80&fit=crop',
    /** Default profile image for Demo Client when no avatar is set (DiceBear – loads reliably). */
    demoClientAvatar: 'https://api.dicebear.com/7.x/avataaars/png?seed=BulodDemoClient&size=80',
    staff: 'https://images.unsplash.com/photo-1472099645785-5658abf4ff4e?w=400&q=80&fit=crop',
    defaultAvatar: 'https://ui-avatars.com/api/?name=User&background=057197&color=fff&size=128',
  },

  // Hero: clean car at scenic location (Isabela / Philippines vibe — car by water or scenic road)
  hero: {
    grid: '/images/hero-grid.png',
    carScenic: 'https://images.unsplash.com/photo-1449965408869-eaa3f722e40d?w=1200&q=80&fit=crop',
    carLandmark: 'https://images.unsplash.com/photo-1502877338535-766e1452684a?w=1200&q=80&fit=crop',
    carClean: 'https://images.unsplash.com/photo-1549317661-bd32c8ce0db2?w=1200&q=80&fit=crop',
  },

  // People / community (car sharing, trust)
  people: {
    caregiverElderly: 'https://images.unsplash.com/photo-1568602471122-7832951cc4c5?w=800&q=80&fit=crop',
    engagementPhone: 'https://images.unsplash.com/photo-1558618666-fcd25c85cd64?w=800&q=80&fit=crop',
    clientHearingAid: 'https://images.unsplash.com/photo-1609521263047-f8f205293f24?w=800&q=80&fit=crop',
  },

  partners: {
    inclusiveAbilitiesCare: '/images/partners/inclusive-abilities-care.png',
    denatSupportServices: '/images/partners/denat-support-services.png',
    aimsHealthcare: '/images/partners/aims-healthcare.png',
    awesomeHealthcare: '/images/partners/awesome-healthcare.png',
    amgVictoria: '/images/partners/amg-victoria.png',
    filledWithHope: '/images/partners/filled-with-hope.png',
  },

  appScreenshots: {
    loginStaff: 'https://images.unsplash.com/photo-1512941937669-90a1b58e7e9c?w=400&q=80&fit=crop',
    phonesDuo: 'https://images.unsplash.com/photo-1512941937669-90a1b58e7e9c?w=600&q=80&fit=crop',
    tabletPhone: 'https://images.unsplash.com/photo-1558618666-fcd25c85cd64?w=600&q=80&fit=crop',
    schedule: 'https://images.unsplash.com/photo-1485291571150-772bcfc10da5?w=400&q=80&fit=crop',
    clientsProgress: 'https://images.unsplash.com/photo-1492144534655-ae79c964c9d7?w=600&q=80&fit=crop',
    dashboard: 'https://images.unsplash.com/photo-1492144534655-ae79c964c9d7?w=600&q=80&fit=crop',
    fallback: 'https://images.unsplash.com/photo-1449965408869-eaa3f722e40d?w=800&q=80',
  },

  // Car / vehicle images for listings and features
  features: {
    clientManagement: 'https://images.unsplash.com/photo-1552519507-da3b142c6e3d?w=600&q=80&fit=crop',
    staffManagement: 'https://images.unsplash.com/photo-1519641471654-76ce0107ad1b?w=600&q=80&fit=crop',
    scheduling: 'https://images.unsplash.com/photo-1502877338535-766e1452684a?w=600&q=80&fit=crop',
    reporting: 'https://images.unsplash.com/photo-1549317661-bd32c8ce0db2?w=600&q=80&fit=crop',
    invoicing: 'https://images.unsplash.com/photo-1568602471122-7832951cc4c5?w=600&q=80&fit=crop',
    documents: 'https://images.unsplash.com/photo-1609521263047-f8f205293f24?w=600&q=80&fit=crop',
  },

  // BulodPH backgrounds — Trust Blue + Cyan
  backgrounds: {
    gradient1: 'linear-gradient(180deg, #057197 0%, #044A5E 100%)',
    gradient2: 'linear-gradient(180deg, #044A5E 0%, #057197 100%)',
    gradient3: 'linear-gradient(135deg, #1ED7E2 0%, #18B8C2 100%)',
    gradient4: 'linear-gradient(135deg, #057197 0%, #0688A8 100%)',
    primary: 'linear-gradient(180deg, #057197 0%, #044A5E 100%)',
    secondary: 'linear-gradient(135deg, #1ED7E2 0%, #18B8C2 100%)',
  },

  branding: {
    logo: '/logo.png',
    logoWhite: '/logo-white.svg',
    favicon: '/favicon.ico',
  },

  // Cars for listing cards (sedan, hatchback, SUV – normal cars)
  cars: {
    sedan: 'https://images.unsplash.com/photo-1619767886558-efdc259cde1a?w=800&q=80&fit=crop',
    hatchback: 'https://images.unsplash.com/photo-1552519507-da3b142c6e3d?w=800&q=80&fit=crop',
    suv: 'https://images.unsplash.com/photo-1519641471654-76ce0107ad1b?w=800&q=80&fit=crop',
    family: 'https://images.unsplash.com/photo-1544636331-e26879cd4d9b?w=800&q=80&fit=crop',
    roadScenic: 'https://images.unsplash.com/photo-1449965408869-eaa3f722e40d?w=1200&q=80&fit=crop',
  },

  // Payment method logos (GCash, Maya, Visa, Mastercard, BPI)
  payments: {
    gcash: '/images/payments/gcash.png',
    maya: '/images/payments/maya.png',
    visa: '/images/payments/visa.png',
    mastercard: '/images/payments/mastercard.png',
    bpi: '/images/payments/bpi.png',
  },

  status: {
    success: 'https://illustrations.popsy.co/amber/checkmark.svg',
    warning: 'https://illustrations.popsy.co/amber/warning.svg',
    error: 'https://illustrations.popsy.co/amber/error.svg',
    info: 'https://illustrations.popsy.co/amber/info.svg',
  },
}

// Helper to resolve relative backend storage URLs (e.g. /storage/avatars/...)
// When VITE_API_URL is relative (/api), storage lives on the backend origin (e.g. http://localhost:8000).
export const resolveImageUrl = (url?: string | null): string | undefined => {
  if (!url) return undefined
  if (url.startsWith('http') || url.startsWith('data:')) return url
  const apiBase = import.meta.env.VITE_API_URL || 'http://localhost:8000/api'
  let backendBase = apiBase.replace(/\/api\/?$/, '')
  if (!backendBase || backendBase.startsWith('/')) {
    backendBase = import.meta.env.VITE_BACKEND_URL || 'http://localhost:8000'
  }
  return `${backendBase}/${url.replace(/^\//, '')}`
}

// Helper function to get avatar with fallback
export const getAvatarUrl = (name?: string, imageUrl?: string): string => {
  if (imageUrl) return resolveImageUrl(imageUrl)!
  if (name) return IMAGES.placeholders.avatar(name)
  return IMAGES.placeholders.defaultAvatar
}

// Helper function to get empty state image
export const getEmptyStateImage = (type: keyof typeof IMAGES.emptyStates): string => {
  return IMAGES.emptyStates[type] || IMAGES.emptyStates.noData
}

export default IMAGES

