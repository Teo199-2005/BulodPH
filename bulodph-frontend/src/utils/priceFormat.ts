/**
 * BulodPH — consistent PHP price formatting (₱ with thousands separator).
 * Use for all displayed prices; keep inputs/filters as raw numbers.
 */

const LOCALE = 'en-PH'
const DEFAULT_OPTIONS: Intl.NumberFormatOptions = {
  minimumFractionDigits: 0,
  maximumFractionDigits: 0,
}

export interface FormatPriceOptions {
  /** Show decimal places (e.g. 2,500.00) */
  showDecimals?: boolean
  /** Append e.g. "/day" or "/hr" */
  suffix?: string
}

/**
 * Format a number as Philippine Peso, e.g. "₱2,500" or "₱2,500/day".
 */
export function formatPrice(
  amount: number,
  options: FormatPriceOptions = {}
): string {
  const { showDecimals = false, suffix = '' } = options
  const formatted = new Intl.NumberFormat(LOCALE, {
    ...DEFAULT_OPTIONS,
    minimumFractionDigits: showDecimals ? 2 : 0,
    maximumFractionDigits: showDecimals ? 2 : 0,
  }).format(amount)
  const withPeso = `₱${formatted}`
  return suffix ? `${withPeso}${suffix.startsWith('/') ? '' : ' '}${suffix}` : withPeso
}

/**
 * Format a price range, e.g. "₱2,000 – ₱4,000/day".
 */
export function formatPriceRange(
  min: number,
  max?: number,
  suffix = '/day'
): string {
  if (max == null || max === min) return formatPrice(min, { suffix })
  return `${formatPrice(min)} – ${formatPrice(max, { suffix })}`
}

/**
 * Compute discount percentage from original and current price.
 */
export function discountPercent(original: number, current: number): number {
  if (original <= 0 || current >= original) return 0
  return Math.round(((original - current) / original) * 100)
}

/**
 * Compute savings amount (original - current).
 */
export function savingsAmount(original: number, current: number): number {
  if (current >= original) return 0
  return original - current
}
