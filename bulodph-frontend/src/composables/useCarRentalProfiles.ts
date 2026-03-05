/**
 * Composable for car rental profiles.
 * Derives rental companies from vehicles (grouped by businessName) and merges with stored/seed profiles.
 */

import { ref, computed } from 'vue'
import { useVehicles } from './useVehicles'
import { useUserSessionStore } from '@/stores/userSession'
import * as carRentalApi from '@/services/carRentalProfile'
import { getRentalProfileSeed } from '@/constants/rentalProfilesSeed'
import type { CarRentalProfile, CarRentalProfileUpdatePayload } from '@/types/carRentalProfile'
import type { VehicleSeedItem } from '@/constants/vehicleSeed'

function slugify(str: string): string {
  return str
    .toLowerCase()
    .replace(/[^a-z0-9]+/g, '-')
    .replace(/^-|-$/g, '')
}

/** Get car rentals from vehicles (grouped by businessName/hostName). */
function deriveRentalsFromVehicles(vehicles: VehicleSeedItem[]): CarRentalProfile[] {
  const byName = new Map<string, VehicleSeedItem[]>()
  for (const v of vehicles) {
    const name = (v.businessName ?? v.hostName ?? 'Unknown').trim()
    if (!name) continue
    const list = byName.get(name) ?? []
    list.push(v)
    byName.set(name, list)
  }
  return Array.from(byName.entries()).map(([businessName, list]) => {
    const first = list[0]
    const loc = first.location ?? ''
    const [city, province] = loc.includes(',') ? loc.split(',').map(s => s.trim()) : [loc, '']
    const seed = getRentalProfileSeed(businessName)
    const base: CarRentalProfile = {
      id: slugify(businessName),
      businessName,
      slug: slugify(businessName),
      city: city || undefined,
      province: province || undefined,
      address: loc || undefined,
      vehicleCount: list.length,
    }
    return seed ? { ...base, ...seed, vehicleCount: list.length } : base
  })
}

/** Merge stored profile over derived rental (for current user's profile). */
function mergeStoredProfile(
  derived: CarRentalProfile,
  stored: CarRentalProfile | null
): CarRentalProfile {
  if (!stored || stored.businessName !== derived.businessName) return derived
  return {
    ...derived,
    ...stored,
    id: stored.id ?? derived.id,
    slug: stored.slug ?? derived.slug,
    vehicleCount: derived.vehicleCount,
  }
}

/** Normalize business name for matching (lowercase, trim). */
function normName(name: string): string {
  return (name ?? '').trim().toLowerCase()
}

/** Merge public profile (logo, bio, etc.) over derived rental so clients see saved profiles. Uses alternate business names so "Demo Car Owner" profile matches "Demo Car rental owner" rental. */
function mergePublicProfile(derived: CarRentalProfile): CarRentalProfile {
  const match = carRentalApi.getPublicProfileForDerived(derived)
  if (!match) return derived
  return {
    ...derived,
    ...match,
    id: match.id ?? derived.id,
    slug: match.slug ?? derived.slug,
    vehicleCount: derived.vehicleCount,
  }
}

/** Derive alternate business names from vehicles so a saved profile (e.g. "Demo Car Owner") also matches the rental derived from vehicles (e.g. "Demo Car rental owner"). */
function getAlternateBusinessNamesForOwner(
  _payload: CarRentalProfileUpdatePayload,
  _current: CarRentalProfile | null,
  derivedRentals: CarRentalProfile[],
  ownerNames: string[]
): string[] {
  const names = new Set(ownerNames.map(normName))
  return derivedRentals
    .filter(d => {
      const dn = normName(d.businessName)
      if (names.has(dn)) return true
      for (const n of names) {
        if (dn.includes(n) || n.includes(dn)) return true
      }
      return false
    })
    .map(d => d.businessName)
}

export function useCarRentalProfiles() {
  const { approvedVehicles, fetchFromApi, loading: vehiclesLoading } = useVehicles()
  const userSession = useUserSessionStore()

  const storedProfile = ref<CarRentalProfile | null>(null)
  const apiRentals = ref<CarRentalProfile[] | null>(null)
  const loading = ref(false)

  /** All car rentals: from API if available, else derived from vehicles + public profiles (including standalone saved profiles so "View as client" always finds a rental). */
  const rentals = computed(() => {
    if (apiRentals.value && apiRentals.value.length > 0) {
      return apiRentals.value
    }
    const derived = deriveRentalsFromVehicles(approvedVehicles.value)
    const stored = carRentalApi.getMyRentalProfileFromStorage()
    const merged = derived.map(d => {
      const withStored = mergeStoredProfile(d, stored && normName(stored.businessName) === normName(d.businessName) ? stored : null)
      return mergePublicProfile(withStored)
    })
    const publicProfiles = carRentalApi.getPublicRentalProfiles()
    const mergedSlugs = new Set(merged.map(r => (r.slug ?? slugify(r.businessName)).toLowerCase()))
    const mergedNames = new Set(merged.map(r => normName(r.businessName)))
    for (const p of publicProfiles) {
      const slug = (p.slug ?? slugify(p.businessName)).toLowerCase()
      const name = normName(p.businessName)
      if (mergedSlugs.has(slug) || mergedNames.has(name)) continue
      merged.push({
        ...p,
        id: p.id ?? slug,
        slug: p.slug ?? slug,
        vehicleCount: p.vehicleCount ?? 0,
      })
      mergedSlugs.add(slug)
      mergedNames.add(name)
    }
    return merged
  })

  /** Current user's rental profile (for car owners editing). Uses stored profile, or derives from their vehicles, or builds from user. */
  const myRentalProfile = computed(() => {
    const stored = storedProfile.value ?? carRentalApi.getMyRentalProfileFromStorage()
    const ownerName = userSession.user?.name?.trim()
    const derived = ownerName
      ? rentals.value.find(r => r.businessName.toLowerCase() === ownerName.toLowerCase())
      : null
    if (stored) {
      const base = derived ?? {
        id: slugify(stored.businessName),
        businessName: stored.businessName,
        slug: stored.slug ?? slugify(stored.businessName),
        vehicleCount: 0,
      }
      return { ...base, ...stored, ownerId: userSession.user?.id }
    }
    if (derived) return { ...derived, ownerId: userSession.user?.id }
    if (!ownerName) return null
    return {
      id: slugify(ownerName),
      ownerId: userSession.user?.id,
      businessName: ownerName,
      slug: slugify(ownerName),
      city: '',
      province: '',
      address: '',
      phone: userSession.user?.mobile ?? '',
      email: userSession.user?.email ?? '',
    } as CarRentalProfile
  })

  async function fetchRentals() {
    try {
      const list = await carRentalApi.getCarRentals()
      apiRentals.value = list?.length ? list : null
    } catch {
      // Keep previous apiRentals so avatar/name don't clear when a re-fetch fails (e.g. 401 or network)
    }
  }

  async function fetchMyProfile() {
    loading.value = true
    try {
      const fromApi = await carRentalApi.getMyRentalProfile()
      if (fromApi) {
        storedProfile.value = fromApi
        return fromApi
      }
      storedProfile.value = carRentalApi.getMyRentalProfileFromStorage()
      return storedProfile.value
    } finally {
      loading.value = false
    }
  }

  async function updateMyProfile(payload: CarRentalProfileUpdatePayload): Promise<{ profile: CarRentalProfile; savedToServer: boolean }> {
    loading.value = true
    try {
      const fromApi = await carRentalApi.updateMyRentalProfile(payload)
      const derived = deriveRentalsFromVehicles(approvedVehicles.value)
      const ownerNames = [payload.businessName, myRentalProfile.value?.businessName, userSession.user?.name].filter(Boolean) as string[]

      if (fromApi) {
        const merged = { ...fromApi, ...payload }
        storedProfile.value = merged
        const alternates = getAlternateBusinessNamesForOwner(payload, myRentalProfile.value, derived, ownerNames)
        carRentalApi.savePublicRentalProfile(merged, alternates)
        return { profile: merged, savedToServer: true }
      }
      const current = myRentalProfile.value
      if (current) {
        const updated: CarRentalProfile = { ...current, ...payload }
        carRentalApi.saveMyRentalProfileToStorage(updated)
        storedProfile.value = updated
        const alternates = getAlternateBusinessNamesForOwner(payload, current, derived, ownerNames)
        carRentalApi.savePublicRentalProfile(updated, alternates)
        return { profile: updated, savedToServer: false }
      }
      const minimal: CarRentalProfile = {
        id: payload.businessName ? slugify(payload.businessName) : 'profile',
        businessName: payload.businessName ?? '',
        slug: payload.businessName ? slugify(payload.businessName) : 'profile',
        vehicleCount: 0,
        ...payload,
      }
      carRentalApi.saveMyRentalProfileToStorage(minimal)
      storedProfile.value = minimal
      const alternates = getAlternateBusinessNamesForOwner(payload, null, derived, ownerNames)
      carRentalApi.savePublicRentalProfile(minimal, alternates)
      return { profile: minimal, savedToServer: false }
    } finally {
      loading.value = false
    }
  }

  async function uploadLogo(file: File) {
    const result = await carRentalApi.uploadRentalLogo(file)
    if (result?.logo_url) return result.logo_url
    return null
  }

  function getRentalById(idOrSlug: string): CarRentalProfile | undefined {
    const found = rentals.value.find(
      r => r.id === idOrSlug || r.slug === idOrSlug || slugify(r.businessName) === slugify(idOrSlug)
    )
    if (found) return found
    const mine = myRentalProfile.value
    if (mine) {
      const slugNorm = slugify(idOrSlug)
      if ((mine.slug && slugify(mine.slug) === slugNorm) || slugify(mine.businessName) === slugNorm) return mine
      const userSlug = userSession.user?.name ? slugify(userSession.user.name) : ''
      if (userSlug && userSlug === slugNorm) return mine
    }
    return undefined
  }

  function getVehiclesByRental(idOrSlug: string): VehicleSeedItem[] {
    const rental = getRentalById(idOrSlug)
    if (!rental) return []
    return approvedVehicles.value.filter(
      v => (v.businessName ?? v.hostName ?? '').trim() === rental.businessName
    )
  }

  return {
    rentals,
    myRentalProfile,
    loading,
    /** True while initial vehicles/rentals fetch is in progress */
    loadingRentals: vehiclesLoading,
    fetchMyProfile,
    fetchRentals,
    updateMyProfile,
    uploadLogo,
    getRentalById,
    getVehiclesByRental,
    fetchFromApi,
  }
}
