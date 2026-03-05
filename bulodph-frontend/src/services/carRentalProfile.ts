/**
 * Car rental profile API.
 * Car owners: GET/PUT their rental profile.
 * Clients: GET list of rental companies, GET single rental by id/slug.
 */

import api from '@/lib/api'
import { unwrapData } from './api-types'
import type { CarRentalProfile, CarRentalProfileUpdatePayload } from '@/types/carRentalProfile'
import { getUserScopedItem, setUserScopedItem } from '@/utils/userScopedStorage'
import { useUserSessionStore } from '@/stores/userSession'

/** Normalize API rental to camelCase and safe defaults so avatar/name never "clear" from missing keys or null. */
function normalizeRental(raw: Record<string, unknown>): CarRentalProfile {
  const r = raw
  const name = (r.businessName ?? r.business_name ?? 'Rental') as string
  const logo = r.logoUrl ?? r.logo_url
  const logoUrl = typeof logo === 'string' && logo.trim() ? logo.trim() : undefined
  return {
    id: (r.id as string) ?? '',
    ownerId: (r.ownerId ?? r.owner_id) as string | undefined,
    businessName: name,
    logoUrl: logoUrl ?? null,
    bio: (r.bio as string) ?? undefined,
    city: (r.city as string) ?? undefined,
    province: (r.province as string) ?? undefined,
    address: (r.address as string) ?? undefined,
    phone: (r.phone as string) ?? undefined,
    email: (r.email as string) ?? undefined,
    businessPermitNumber: (r.businessPermitNumber ?? r.business_permit_number) as string | undefined,
    businessAddress: (r.businessAddress ?? r.business_address) as string | undefined,
    vehicleCount: (r.vehicleCount ?? r.vehicle_count) as number | undefined,
    slug: (r.slug as string) ?? undefined,
  }
}

const STORAGE_KEY = 'bulodph_car_rental_profile'
/** Key by email so profile survives re-login when backend returns a different user id (e.g. demo accounts) */
const EMAIL_FALLBACK_KEY_PREFIX = 'bulodph_car_rental_profile_email_'
/** Non-user-scoped: so clients can see profiles saved by car owners when API is not used */
const PUBLIC_PROFILES_KEY = 'bulodph_rental_profiles_public'

function getEmailKey(): string | null {
  const email = useUserSessionStore().user?.email
  if (!email || typeof email !== 'string') return null
  return EMAIL_FALLBACK_KEY_PREFIX + email.trim().toLowerCase()
}

/** Get car owner's own rental profile (for editing). */
export async function getMyRentalProfile(): Promise<CarRentalProfile | null> {
  try {
    const { data } = await api.get<{ data?: CarRentalProfile } | CarRentalProfile>('/car-owner/rental-profile')
    const profile = unwrapData(data) as CarRentalProfile | null | undefined
    if (profile && typeof profile.businessName === 'string') {
      saveMyRentalProfileToStorage(profile)
      return profile
    }
    return getMyRentalProfileFromStorage()
  } catch {
    return getMyRentalProfileFromStorage()
  }
}

/** Update car owner's rental profile. */
export async function updateMyRentalProfile(payload: CarRentalProfileUpdatePayload): Promise<CarRentalProfile | null> {
  try {
    const { data } = await api.put<{ data?: CarRentalProfile } | CarRentalProfile>('/car-owner/rental-profile', payload)
    return unwrapData(data) as CarRentalProfile
  } catch {
    return null
  }
}

/** Upload rental company logo. */
export async function uploadRentalLogo(file: File): Promise<{ logo_url: string } | null> {
  try {
    const formData = new FormData()
    formData.append('logo', file)
    const { data } = await api.post<{ data?: { logo_url: string }; logo_url?: string }>(
      '/car-owner/rental-profile/logo',
      formData
    )
    const result = unwrapData(data) as { logo_url?: string }
    const url = result?.logo_url ?? (data as { logo_url?: string })?.logo_url
    return url ? { logo_url: url } : null
  } catch {
    return null
  }
}

/** List all car rentals (for client browse). Returns normalized camelCase so avatar/name never clear. */
export async function getCarRentals(params?: { search?: string; location?: string }): Promise<CarRentalProfile[]> {
  try {
    const { data } = await api.get<{ data?: CarRentalProfile[] } | CarRentalProfile[]>(
      '/car-rentals',
      { params }
    )
    const list = unwrapData(data) as unknown[] | undefined
    if (!Array.isArray(list)) return []
    return list.map((item) => normalizeRental((item ?? {}) as unknown as Record<string, unknown>))
  } catch {
    return []
  }
}

/** Get single car rental by id or slug (for client detail view). Returns normalized so avatar/name never clear. */
export async function getCarRentalById(idOrSlug: string): Promise<CarRentalProfile | null> {
  try {
    const { data } = await api.get<{ data?: CarRentalProfile } | CarRentalProfile>(
      `/car-rentals/${encodeURIComponent(idOrSlug)}`
    )
    const raw = unwrapData(data) as unknown as Record<string, unknown> | null | undefined
    if (!raw || typeof raw !== 'object') return null
    return normalizeRental(raw)
  } catch {
    return null
  }
}

/** Get vehicles for a rental (by owner id or business name). */
export async function getRentalVehicles(rentalIdOrSlug: string): Promise<unknown[]> {
  try {
    const { data } = await api.get<{ data?: unknown[] } | unknown[]>(
      `/car-rentals/${encodeURIComponent(rentalIdOrSlug)}/vehicles`
    )
    const list = unwrapData(data) as unknown[] | undefined
    return Array.isArray(list) ? list : []
  } catch {
    return []
  }
}

// --- Local storage fallback when API not implemented ---

function slugify(str: string): string {
  return str
    .toLowerCase()
    .replace(/[^a-z0-9]+/g, '-')
    .replace(/^-|-$/g, '')
}

export function getMyRentalProfileFromStorage(): CarRentalProfile | null {
  const stored = getUserScopedItem<CarRentalProfile>(STORAGE_KEY)
  if (stored) return stored
  const emailKey = getEmailKey()
  if (!emailKey) return null
  try {
    const raw = localStorage.getItem(emailKey)
    if (!raw) return null
    const parsed = JSON.parse(raw) as CarRentalProfile
    if (parsed && typeof parsed.businessName === 'string') {
      setUserScopedItem(STORAGE_KEY, parsed)
      return parsed
    }
  } catch {
    // ignore
  }
  return null
}

export function saveMyRentalProfileToStorage(profile: CarRentalProfile): void {
  try {
    const withSlug = { ...profile, slug: profile.slug ?? slugify(profile.businessName) }
    setUserScopedItem(STORAGE_KEY, withSlug)
    savePublicRentalProfile(withSlug)
    const emailKey = getEmailKey()
    if (emailKey) localStorage.setItem(emailKey, JSON.stringify(withSlug))
  } catch {
    // ignore
  }
}

interface PublicProfileEntry {
  profile: CarRentalProfile
  alternateBusinessNames: string[]
}

function normName(name: string): string {
  return (name ?? '').trim().toLowerCase()
}

function getPublicEntries(): PublicProfileEntry[] {
  try {
    const raw = localStorage.getItem(PUBLIC_PROFILES_KEY)
    if (!raw) return []
    const parsed = JSON.parse(raw)
    if (Array.isArray(parsed)) {
      return parsed.map((p: PublicProfileEntry | CarRentalProfile) =>
        'profile' in p && p.profile ? p as PublicProfileEntry : { profile: p as CarRentalProfile, alternateBusinessNames: [] }
      )
    }
    if (parsed?.profiles) return parsed.profiles
    return []
  } catch {
    return []
  }
}

/** Get all rental profiles saved by any car owner on this device (for browse when API not used). */
export function getPublicRentalProfiles(): CarRentalProfile[] {
  return getPublicEntries().map(e => e.profile)
}

/** Find a public profile that matches this derived rental (by businessName or alternate names from vehicles). */
export function getPublicProfileForDerived(derived: { businessName: string }): CarRentalProfile | null {
  const entries = getPublicEntries()
  const derivedNorm = normName(derived.businessName)
  for (const { profile, alternateBusinessNames } of entries) {
    if (normName(profile.businessName) === derivedNorm) return profile
    if (alternateBusinessNames?.some(a => normName(a) === derivedNorm)) return profile
  }
  return null
}

/** Add or update one profile in the public cache. Pass alternateBusinessNames so the profile also matches rentals derived from vehicles (e.g. "Demo Car rental owner"). */
export function savePublicRentalProfile(profile: CarRentalProfile, alternateBusinessNames: string[] = []): void {
  try {
    const list = getPublicEntries()
    const slug = profile.slug ?? slugify(profile.businessName)
    const entryProfile: CarRentalProfile = { ...profile, slug, id: profile.id ?? slug }
    const mainNorm = normName(profile.businessName)
    const idx = list.findIndex(
      e => normName(e.profile.businessName) === mainNorm || (e.profile.slug ?? slugify(e.profile.businessName)) === slug
    )
    const entry: PublicProfileEntry = { profile: entryProfile, alternateBusinessNames }
    if (idx >= 0) list[idx] = entry
    else list.push(entry)
    localStorage.setItem(PUBLIC_PROFILES_KEY, JSON.stringify(list))
  } catch {
    // ignore
  }
}
