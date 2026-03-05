import { describe, it, expect } from 'vitest'
import { usePasswordValidation } from './usePasswordValidation'
import { ref } from 'vue'

describe('usePasswordValidation', () => {
    it('validates a strong password', () => {
        const password = ref('StrongPass1!')
        const { isValid, strengthPercent, rules } = usePasswordValidation(password)

        expect(isValid.value).toBe(true)
        expect(strengthPercent.value).toBe(100)
        expect(rules.value.every(r => r.met)).toBe(true)
    })

    it('detects missing length', () => {
        const password = ref('A1!a')
        const { isValid, strengthPercent, rules } = usePasswordValidation(password)

        expect(isValid.value).toBe(false)
        expect(strengthPercent.value).toBe(75) // 3 out of 4 rules met
        expect(rules.value.find(r => r.key === 'length')?.met).toBe(false)
    })

    it('detects missing uppercase', () => {
        const password = ref('strongpass1!')
        const { isValid, rules } = usePasswordValidation(password)

        expect(isValid.value).toBe(false)
        expect(rules.value.find(r => r.key === 'uppercase')?.met).toBe(false)
    })

    it('detects missing digit', () => {
        const password = ref('StrongPass!')
        const { isValid, rules } = usePasswordValidation(password)

        expect(isValid.value).toBe(false)
        expect(rules.value.find(r => r.key === 'digit')?.met).toBe(false)
    })

    it('detects missing special character', () => {
        const password = ref('StrongPass123')
        const { isValid, rules } = usePasswordValidation(password)

        expect(isValid.value).toBe(false)
        expect(rules.value.find(r => r.key === 'special')?.met).toBe(false)
    })

    it('handles empty password', () => {
        const password = ref('')
        const { isValid, strengthPercent, rules } = usePasswordValidation(password)

        expect(isValid.value).toBe(false)
        expect(strengthPercent.value).toBe(0)
        expect(rules.value.every(r => !r.met)).toBe(true)
    })
})
