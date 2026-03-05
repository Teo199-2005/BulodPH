/**
 * Numeric validation & sanitization to prevent cheating, bypassing, and invalid values.
 * Use for prices, amounts, quantities, and any user-editable numeric fields.
 */

/** Maximum allowed price/amount (₱999,999,999) */
export const MAX_SAFE_AMOUNT = 999_999_999

/** Maximum discount percentage */
export const MAX_DISCOUNT_PERCENT = 100

/** Maximum rental days */
export const MAX_RENTAL_DAYS = 365

export interface SanitizeOptions {
  min?: number
  max?: number
  defaultIfInvalid?: number
  allowZero?: boolean
}

/**
 * Sanitize a value to a valid non-negative number.
 * Rejects: NaN, Infinity, -Infinity, negative numbers (unless min allows).
 */
export function sanitizeNonNegative(
  value: string | number | null | undefined,
  options: SanitizeOptions = {}
): number {
  const { min = 0, max = MAX_SAFE_AMOUNT, defaultIfInvalid = 0 } = options
  if (value === null || value === undefined) return defaultIfInvalid
  const n = typeof value === 'number' ? value : parseFloat(String(value).replace(/[^\d.-]/g, ''))
  if (Number.isNaN(n) || !Number.isFinite(n)) return defaultIfInvalid
  const clamped = Math.max(min, Math.min(max, n))
  return clamped
}

/**
 * Sanitize a price/amount. Always returns >= 0.
 */
export function sanitizePrice(value: string | number | null | undefined): number {
  return sanitizeNonNegative(value, { min: 0, max: MAX_SAFE_AMOUNT, defaultIfInvalid: 0 })
}

/**
 * Sanitize discount percentage (0–100).
 */
export function sanitizeDiscountPercent(value: string | number | null | undefined): number {
  return sanitizeNonNegative(value, { min: 0, max: MAX_DISCOUNT_PERCENT, defaultIfInvalid: 0 })
}

/**
 * Sanitize quantity (e.g. rental days, capacity). Min 1.
 */
export function sanitizeQuantity(
  value: string | number | null | undefined,
  options: { min?: number; max?: number } = {}
): number {
  const { min = 1, max = MAX_RENTAL_DAYS } = options
  return sanitizeNonNegative(value, { min, max, defaultIfInvalid: min })
}

/**
 * Validate a price. Returns error message or undefined if valid.
 */
export function validatePrice(value: unknown): string | undefined {
  const n = Number(value)
  if (Number.isNaN(n)) return 'Invalid amount'
  if (!Number.isFinite(n)) return 'Invalid amount'
  if (n < 0) return 'Amount cannot be negative'
  if (n > MAX_SAFE_AMOUNT) return `Amount cannot exceed ₱${MAX_SAFE_AMOUNT.toLocaleString()}`
  return undefined
}

/**
 * Validate discount percentage (0–100).
 */
export function validateDiscountPercent(value: unknown): string | undefined {
  const n = Number(value)
  if (Number.isNaN(n)) return 'Invalid percentage'
  if (n < 0 || n > MAX_DISCOUNT_PERCENT) return `Discount must be between 0 and ${MAX_DISCOUNT_PERCENT}%`
  return undefined
}

/**
 * Clamp a number to a range. Returns valid number, never NaN or Infinity.
 */
export function clampNumber(
  value: string | number | null | undefined,
  min: number,
  max: number,
  fallback: number = min
): number {
  const n = typeof value === 'number' ? value : parseFloat(String(value ?? ''))
  if (Number.isNaN(n) || !Number.isFinite(n)) return fallback
  return Math.max(min, Math.min(max, n))
}

/**
 * Ensure a computed total is never negative (e.g. subtotal - discount).
 */
export function ensureNonNegativeTotal(subtotal: number, discount: number): number {
  const sub = sanitizePrice(subtotal)
  const disc = sanitizeDiscountPercent(discount)
  const cappedDiscount = Math.min(disc, 100)
  const discountAmount = Math.round(sub * (cappedDiscount / 100))
  return Math.max(0, sub - discountAmount)
}
