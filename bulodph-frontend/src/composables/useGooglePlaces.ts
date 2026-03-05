/**
 * Load Google Maps Places API and init Autocomplete restricted to Philippines.
 * Requires VITE_GOOGLE_MAPS_API_KEY in .env (enable Places API in Google Cloud Console).
 */

declare global {
  interface Window {
    google?: {
      maps: {
        places: {
          Autocomplete: new (
            input: HTMLInputElement,
            opts?: { componentRestrictions?: { country: string }; types?: string[]; fields?: string[] }
          ) => {
            addListener: (event: string, fn: () => void) => void
            getPlace: () => {
              formatted_address?: string
              address_components?: Array<{ long_name: string; types: string[] }>
            }
          }
        }
        event?: { clearInstanceListeners: (instance: unknown) => void }
      }
    }
    initGooglePlaces?: () => void
  }
}

export interface PlaceResult {
  formattedAddress: string
  city: string
  province: string
  region?: string
}

let scriptLoaded = false
let loadPromise: Promise<void> | null = null

function loadScript(): Promise<void> {
  if (scriptLoaded && window.google?.maps?.places) return Promise.resolve()
  if (loadPromise) return loadPromise
  const key = import.meta.env.VITE_GOOGLE_MAPS_API_KEY as string | undefined
  if (!key) {
    return Promise.reject(new Error('VITE_GOOGLE_MAPS_API_KEY is not set'))
  }
  loadPromise = new Promise((resolve, reject) => {
    if (window.google?.maps?.places) {
      scriptLoaded = true
      resolve()
      return
    }
    const script = document.createElement('script')
    script.src = `https://maps.googleapis.com/maps/api/js?key=${key}&libraries=places&callback=initGooglePlaces`
    script.async = true
    script.defer = true
    window.initGooglePlaces = () => {
      scriptLoaded = true
      resolve()
    }
    script.onerror = () => reject(new Error('Failed to load Google Maps script'))
    document.head.appendChild(script)
  })
  return loadPromise
}

function getComponent(
  place: { address_components?: Array<{ long_name: string; types: string[] }> },
  type: string
): string {
  const comp = place.address_components?.find((c) => c.types.includes(type))
  return comp?.long_name ?? ''
}

export function parsePlaceResult(place: {
  formatted_address?: string
  address_components?: Array<{ long_name: string; types: string[] }>
}): PlaceResult {
  const city =
    getComponent(place, 'locality') ||
    getComponent(place, 'administrative_area_level_2') ||
    ''
  const province = getComponent(place, 'administrative_area_level_1') || ''
  const region = getComponent(place, 'administrative_area_level_1')
  return {
    formattedAddress: place.formatted_address ?? '',
    city,
    province,
    region: region || undefined,
  }
}

let autocompleteInstance: InstanceType<NonNullable<Window['google']>['maps']['places']['Autocomplete']> | null = null

/**
 * Attach Places Autocomplete to an input element, restricted to Philippines.
 * Call attach(inputElement) after the input is in the DOM (e.g. onMounted).
 * Returns cleanup function and isReady (true when API key is set).
 */
export function useGooglePlaces(onPlaceSelect: (result: PlaceResult) => void) {
  const attach = (input: HTMLInputElement | null | undefined) => {
    if (!input) return
    loadScript()
      .then(() => {
        if (!window.google?.maps?.places) return
        autocompleteInstance = new window.google.maps.places.Autocomplete(input, {
          componentRestrictions: { country: 'ph' },
          types: ['geocode'],
          fields: ['address_components', 'formatted_address'],
        })
        autocompleteInstance.addListener('place_changed', () => {
          const place = autocompleteInstance?.getPlace()
          if (place?.formatted_address) {
            onPlaceSelect(parsePlaceResult(place))
          }
        })
      })
      .catch(() => {})
  }

  const cleanup = () => {
    autocompleteInstance = null
  }

  const hasApiKey = Boolean(import.meta.env.VITE_GOOGLE_MAPS_API_KEY)

  return { attach, cleanup, loadScript, hasApiKey }
}
