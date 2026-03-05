/**
 * Car rental company profile – used when car owners set up their rental business
 * and when clients browse/view rental companies.
 */

export interface CarRentalProfile {
  id: string
  /** Owner user ID (for car owner's own profile) */
  ownerId?: string
  /** Company / rental business name */
  businessName: string
  /** Company logo URL */
  logoUrl?: string | null
  /** Short bio / description (shown on browse cards and profile) */
  bio?: string
  /** City */
  city?: string
  /** Province / region */
  province?: string
  /** Full address */
  address?: string
  /** Contact phone */
  phone?: string
  /** Contact email */
  email?: string
  /** Business permit number */
  businessPermitNumber?: string
  /** Business address (can differ from pickup address) */
  businessAddress?: string
  /** Number of vehicles (computed when listing) */
  vehicleCount?: number
  /** Slug for URL (e.g. "collins-rental") */
  slug?: string
}

export interface CarRentalProfileUpdatePayload {
  businessName?: string
  logoUrl?: string | null
  bio?: string
  city?: string
  province?: string
  address?: string
  phone?: string
  email?: string
  businessPermitNumber?: string
  businessAddress?: string
}
