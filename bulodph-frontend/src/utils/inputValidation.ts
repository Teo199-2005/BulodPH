const CONTROL_CHARS = /[\u0000-\u001F\u007F]/g
const SQL_INJECTION_PATTERN =
  /(--|;|\/\*|\*\/|@@|\b(select|insert|update|delete|drop|alter|truncate|union|create|exec|execute)\b)/i
const HTML_INJECTION_PATTERN = /<|>|<\/?script/i

export const SAFE_TEXT_REGEX = /^[A-Za-z0-9\s.,'"()\-/#&:+?]+$/
export const LETTERS_ONLY_REGEX = /^[A-Za-z\s.'-]+$/
export const BOOKING_REF_REGEX = /^[A-Za-z0-9][A-Za-z0-9-_]{2,30}$/
export const ID_NUMBER_REGEX = /^[A-Za-z0-9][A-Za-z0-9-]{1,40}$/

export function sanitizeBasicText(value: string): string {
  return value.replace(CONTROL_CHARS, '').replace(/\s+/g, ' ').trim()
}

export function hasInjectionRisk(value: string): boolean {
  const trimmed = value.trim()
  if (!trimmed) return false
  return SQL_INJECTION_PATTERN.test(trimmed) || HTML_INJECTION_PATTERN.test(trimmed)
}

export function isSafeText(value: string): boolean {
  if (!value.trim()) return true
  return SAFE_TEXT_REGEX.test(value.trim())
}

export function toFileArray(value: File[] | File | null | undefined): File[] {
  if (!value) return []
  return Array.isArray(value) ? value : [value]
}

export function validateFiles(
  value: File[] | File | null | undefined,
  options: { required?: boolean; maxSizeMb?: number; allowedTypes?: string[]; label?: string } = {}
): string | undefined {
  const { required = false, maxSizeMb = 10, allowedTypes, label = 'File' } = options
  const files = toFileArray(value)
  if (!files.length) return required ? `${label} is required` : undefined
  const maxBytes = maxSizeMb * 1024 * 1024
  for (const file of files) {
    if (allowedTypes && allowedTypes.length && !allowedTypes.includes(file.type)) {
      return `${label} must be ${allowedTypes.join(', ')}`
    }
    if (file.size > maxBytes) {
      return `${label} must be under ${maxSizeMb}MB`
    }
  }
  return undefined
}
