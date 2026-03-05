/**
 * BulodPH role colors – single source of truth.
 * Aligns with registration page: navy (client), green (car owner), purple (marketing). Admin = red.
 * @see ROLE_COLORS_REFERENCE.md
 */

export type RoleColorKey = 'client' | 'car_owner' | 'marketing_staff' | 'admin'

export interface RoleColorSet {
  primary: string
  primaryHover: string
  gradient: string
  bgTint: string
  border: string
  borderHover: string
  textOnTint: string
}

const ROLE_COLORS: Record<RoleColorKey, RoleColorSet> = {
  client: {
    primary: '#1e3a5f',
    primaryHover: '#2d3a52',
    gradient: 'linear-gradient(90deg, #2d3a52, #1e3a5f)',
    bgTint: 'rgba(30, 58, 95, 0.12)',
    border: 'rgba(30, 58, 95, 0.25)',
    borderHover: 'rgba(30, 58, 95, 0.35)',
    textOnTint: '#1e3a5f',
  },
  car_owner: {
    primary: '#047857',
    primaryHover: '#059669',
    gradient: 'linear-gradient(90deg, #059669, #047857)',
    bgTint: 'rgba(4, 120, 87, 0.12)',
    border: 'rgba(4, 120, 87, 0.25)',
    borderHover: 'rgba(4, 120, 87, 0.35)',
    textOnTint: '#047857',
  },
  marketing_staff: {
    primary: '#5b21b6',
    primaryHover: '#6d28d9',
    gradient: 'linear-gradient(90deg, #6d28d9, #5b21b6)',
    bgTint: 'rgba(91, 33, 182, 0.12)',
    border: 'rgba(91, 33, 182, 0.25)',
    borderHover: 'rgba(91, 33, 182, 0.35)',
    textOnTint: '#5b21b6',
  },
  admin: {
    primary: '#dc2626',
    primaryHover: '#b91c1c',
    gradient: 'linear-gradient(90deg, #dc2626, #b91c1c)',
    bgTint: 'rgba(220, 38, 38, 0.12)',
    border: 'rgba(220, 38, 38, 0.25)',
    borderHover: 'rgba(220, 38, 38, 0.35)',
    textOnTint: '#dc2626',
  },
}

/** Normalize API/session role string to RoleColorKey */
export function toRoleColorKey(role: string | undefined): RoleColorKey {
  if (!role) return 'client'
  const r = role.toLowerCase().replace(/\s+/g, '_')
  if (r === 'admin') return 'admin'
  if (r === 'car_owner' || r === 'car owner') return 'car_owner'
  if (r === 'marketing_staff' || r === 'marketing_partner' || r === 'marketing staff') return 'marketing_staff'
  return 'client'
}

/** Get color set for a role (default: client) */
export function getRoleColors(role: string | undefined): RoleColorSet {
  return ROLE_COLORS[toRoleColorKey(role)]
}

/** CSS custom property names for role theme (set on app shell) */
export const ROLE_CSS_VARS = {
  primary: '--role-primary',
  primaryHover: '--role-primary-hover',
  gradient: '--role-gradient',
  bgTint: '--role-bg-tint',
  border: '--role-border',
  borderHover: '--role-border-hover',
  textOnTint: '--role-text-on-tint',
} as const

/** Apply role colors as CSS custom properties on an element */
export function applyRoleCssVars(element: HTMLElement, role: string | undefined): void {
  const set = getRoleColors(role)
  element.style.setProperty(ROLE_CSS_VARS.primary, set.primary)
  element.style.setProperty(ROLE_CSS_VARS.primaryHover, set.primaryHover)
  element.style.setProperty(ROLE_CSS_VARS.gradient, set.gradient)
  element.style.setProperty(ROLE_CSS_VARS.bgTint, set.bgTint)
  element.style.setProperty(ROLE_CSS_VARS.border, set.border)
  element.style.setProperty(ROLE_CSS_VARS.borderHover, set.borderHover)
  element.style.setProperty(ROLE_CSS_VARS.textOnTint, set.textOnTint)
}

export { ROLE_COLORS }
