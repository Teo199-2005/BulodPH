/**
 * Input formatters for restricting/filtering user input.
 * Use with @update:model-value to enforce letters only, numbers only, etc.
 */

export type InputFormat =
  | 'letters'           // A-Za-z spaces . ' -
  | 'lettersStrict'     // A-Za-z spaces only (names, city)
  | 'numbers'           // 0-9 only
  | 'alphanumeric'      // A-Za-z0-9
  | 'alphanumericSpaces'// A-Za-z0-9 spaces
  | 'phone'             // 0-9, max 11 digits (PH mobile)
  | 'cardNumber'        // 0-9, max 19 digits
  | 'cardExpiry'        // MM/YY
  | 'idNumber'          // A-Za-z0-9-
  | 'plateNumber'       // A-Za-z0-9 spaces
  | 'referralCode'      // A-Za-z0-9-
  | 'address'           // Letters, numbers, spaces, . , # / - '
  | 'email'             // Standard email (no runtime filter; use type="email")
  | 'none'              // No filtering

// Allow common accented letters (e.g. ñ, é, ü)
const LETTERS_REGEX = /[^A-Za-z\u00C0-\u024F\u1E00-\u1EFF\s.'-]/g
const LETTERS_STRICT_REGEX = /[^A-Za-z\u00C0-\u024F\u1E00-\u1EFF\s]/g
const NUMBERS_REGEX = /[^0-9]/g
const ALPHANUMERIC_REGEX = /[^A-Za-z0-9]/g
const ALPHANUMERIC_SPACES_REGEX = /[^A-Za-z0-9\s]/g
const ID_NUMBER_REGEX = /[^A-Za-z0-9-]/g
const PLATE_REGEX = /[^A-Za-z0-9\s]/g
const REFERRAL_REGEX = /[^A-Za-z0-9-]/g
const ADDRESS_REGEX = /[^A-Za-z0-9\s.,#'/\-]/g  // - at end = literal

/** Format input value according to format type. Returns filtered string. */
export function formatInput(value: string | number | null | undefined, format: InputFormat): string {
  const str = String(value ?? '')

  switch (format) {
    case 'letters':
      return str.replace(LETTERS_REGEX, '')
    case 'lettersStrict':
      return str.replace(LETTERS_STRICT_REGEX, '')
    case 'numbers':
      return str.replace(NUMBERS_REGEX, '')
    case 'alphanumeric':
      return str.replace(ALPHANUMERIC_REGEX, '')
    case 'alphanumericSpaces':
      return str.replace(ALPHANUMERIC_SPACES_REGEX, '')
    case 'phone': {
      const digits = str.replace(NUMBERS_REGEX, '').slice(0, 11)
      return digits
    }
    case 'cardNumber': {
      const digits = str.replace(NUMBERS_REGEX, '').slice(0, 19)
      return digits
    }
    case 'cardExpiry': {
      const digits = str.replace(NUMBERS_REGEX, '').slice(0, 4)
      if (digits.length >= 2) {
        const m = digits.slice(0, 2)
        const y = digits.slice(2)
        return m + (y ? '/' + y : '')
      }
      return digits
    }
    case 'idNumber':
      return str.replace(ID_NUMBER_REGEX, '')
    case 'plateNumber':
      return str.replace(PLATE_REGEX, '')
    case 'referralCode':
      return str.replace(REFERRAL_REGEX, '')
    case 'address':
      return str.replace(ADDRESS_REGEX, '')
    case 'email':
    case 'none':
    default:
      return str
  }
}

/** Create an input handler that formats and assigns to a ref. */
export function createFormatHandler(
  ref: { value: string },
  format: InputFormat
): (v: string | number | null | undefined) => void {
  return (v) => {
    ref.value = formatInput(v, format)
  }
}
