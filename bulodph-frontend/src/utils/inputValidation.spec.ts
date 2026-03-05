import { describe, it, expect } from 'vitest'
import {
    sanitizeBasicText,
    hasInjectionRisk,
    isSafeText,
    validateFiles,
    toFileArray
} from './inputValidation'

describe('inputValidation', () => {
    describe('sanitizeBasicText', () => {
        it('removes control characters and trims whitespace', () => {
            expect(sanitizeBasicText('  hello \x00 world  ')).toBe('hello world')
            expect(sanitizeBasicText('multiple   spaces')).toBe('multiple spaces')
        })
    })

    describe('hasInjectionRisk', () => {
        it('detects SQL injection patterns', () => {
            expect(hasInjectionRisk('SELECT * FROM users')).toBe(true)
            expect(hasInjectionRisk('DROP TABLE users;')).toBe(true)
            expect(hasInjectionRisk('user@email.com')).toBe(false)
        })

        it('detects HTML injection patterns', () => {
            expect(hasInjectionRisk('<script>alert("xss")</script>')).toBe(true)
            expect(hasInjectionRisk('just a normal string > than something else')).toBe(true)
            expect(hasInjectionRisk('safe string')).toBe(false)
        })
    })

    describe('isSafeText', () => {
        it('validates safe text', () => {
            expect(isSafeText('Hello World 123 !@#')).toBe(false) // ! is not allowed
            expect(isSafeText('Hello World 123.,\'"()-/#&:+?')).toBe(true)
            expect(isSafeText('   ')).toBe(true)
        })
    })

    describe('toFileArray', () => {
        it('converts single file to array', () => {
            const file = new File([''], 'test.txt')
            expect(toFileArray(file)).toEqual([file])
        })
        it('returns empty array for null/undefined', () => {
            expect(toFileArray(null)).toEqual([])
            expect(toFileArray(undefined)).toEqual([])
        })
    })

    describe('validateFiles', () => {
        it('validates required files', () => {
            expect(validateFiles(null, { required: true })).toBe('File is required')
            expect(validateFiles(null, { required: false })).toBeUndefined()
        })

        it('validates max size', () => {
            const file = new File(['x'.repeat(2 * 1024 * 1024)], 'test.txt') // 2MB
            expect(validateFiles(file, { maxSizeMb: 1 })).toBe('File must be under 1MB')
            expect(validateFiles(file, { maxSizeMb: 3 })).toBeUndefined()
        })

        it('validates allowed types', () => {
            const file = new File([''], 'test.txt', { type: 'text/plain' })
            expect(validateFiles(file, { allowedTypes: ['image/png', 'image/jpeg'] }))
                .toBe('File must be image/png, image/jpeg')
            expect(validateFiles(file, { allowedTypes: ['text/plain'] })).toBeUndefined()
        })
    })
})
