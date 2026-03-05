import { describe, it, expect } from 'vitest'
import { formatInput } from './inputFormatters'

describe('inputFormatters', () => {
    it('formats letters (allows . \' -)', () => {
        expect(formatInput("O'Brien Jr.", 'letters')).toBe("O'Brien Jr.")
        expect(formatInput('Hello 123!', 'letters')).toBe('Hello ')
    })

    it('formats letters strictly', () => {
        expect(formatInput('Hello World 123!', 'lettersStrict')).toBe('Hello World ')
    })

    it('formats numbers only', () => {
        expect(formatInput('abc123def456', 'numbers')).toBe('123456')
    })

    it('formats alphanumeric spaces', () => {
        expect(formatInput('Hello @World 123!', 'alphanumericSpaces')).toBe('Hello World 123')
    })

    it('formats phone numbers', () => {
        expect(formatInput('abc0917-123-4567def', 'phone')).toBe('09171234567')
        expect(formatInput('0917123456789', 'phone')).toBe('09171234567') // max 11
    })

    it('formats id numbers', () => {
        expect(formatInput('ID@#-123-ABC', 'idNumber')).toBe('ID-123-ABC')
    })

    it('formats card expiry', () => {
        expect(formatInput('1234', 'cardExpiry')).toBe('12/34')
        expect(formatInput('1', 'cardExpiry')).toBe('1')
        expect(formatInput('12', 'cardExpiry')).toBe('12')
        expect(formatInput('123', 'cardExpiry')).toBe('12/3')
    })
})
