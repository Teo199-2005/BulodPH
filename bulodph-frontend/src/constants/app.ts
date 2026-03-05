/**
 * App constants – single source for version and product name (footer, etc.)
 */

export const APP_NAME = 'BulodPH'

/** Demo accounts (login shortcuts). Use for avatar defaults and feature detection. */
export const DEMO_CLIENT_EMAIL = 'client@bulodph.demo'
export const DEMO_CLIENT_DISPLAY_NAME = 'Demo Client'

export const APP_VERSION =
  typeof import.meta.env?.VITE_APP_VERSION === 'string' &&
  import.meta.env.VITE_APP_VERSION.trim() !== ''
    ? import.meta.env.VITE_APP_VERSION.trim()
    : '1.0.0'
