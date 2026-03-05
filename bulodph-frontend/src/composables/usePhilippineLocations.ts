/**
 * Philippines provinces and cities/municipalities via PSGC Cloud API.
 * No API key required. https://psgc.cloud/api-docs
 */

const PSGC_BASE = 'https://psgc.cloud/api'
const REQUEST_TIMEOUT_MS = 8000

export interface Province {
  name: string
  code: string
}

export interface CityMunicipality {
  name: string
  code: string
  type?: string
  zip_code?: string
  district?: string
}

async function fetchWithTimeout(url: string) {
  const controller = new AbortController()
  const timeout = window.setTimeout(() => controller.abort(), REQUEST_TIMEOUT_MS)
  try {
    return await fetch(url, { signal: controller.signal })
  } finally {
    window.clearTimeout(timeout)
  }
}

let provincesCache: Province[] | null = null
const citiesCache = new Map<string, CityMunicipality[]>()

export async function fetchProvinces(): Promise<Province[]> {
  if (provincesCache) return provincesCache
  const res = await fetchWithTimeout(`${PSGC_BASE}/provinces`)
  if (!res.ok) throw new Error('Failed to fetch provinces')
  const data = await res.json()
  provincesCache = (data as Province[]).sort((a, b) => a.name.localeCompare(b.name))
  return provincesCache
}

export async function fetchCitiesMunicipalities(provinceCode: string): Promise<CityMunicipality[]> {
  if (citiesCache.has(provinceCode)) return citiesCache.get(provinceCode)!
  const res = await fetchWithTimeout(`${PSGC_BASE}/provinces/${provinceCode}/cities-municipalities`)
  if (!res.ok) throw new Error('Failed to fetch cities/municipalities')
  const data = await res.json()
  const list = (data as CityMunicipality[]).sort((a, b) => a.name.localeCompare(b.name))
  citiesCache.set(provinceCode, list)
  return list
}

import { ref } from 'vue'

export function usePhilippineLocations() {
  const provinces = ref<Province[]>([])
  const cities = ref<CityMunicipality[]>([])
  const loadingProvinces = ref(false)
  const loadingCities = ref(false)
  const provincesError = ref('')
  const citiesError = ref('')

  async function loadProvinces() {
    loadingProvinces.value = true
    provincesError.value = ''
    try {
      provinces.value = await fetchProvinces()
    } catch (e) {
      provincesError.value = 'Could not load provinces'
      provinces.value = []
    } finally {
      loadingProvinces.value = false
    }
  }

  async function loadCities(provinceCode: string) {
    if (!provinceCode) {
      cities.value = []
      return
    }
    loadingCities.value = true
    citiesError.value = ''
    try {
      cities.value = await fetchCitiesMunicipalities(provinceCode)
    } catch (e) {
      citiesError.value = 'Could not load cities'
      cities.value = []
    } finally {
      loadingCities.value = false
    }
  }

  return {
    provinces,
    cities,
    loadingProvinces,
    loadingCities,
    provincesError,
    citiesError,
    loadProvinces,
    loadCities,
  }
}
