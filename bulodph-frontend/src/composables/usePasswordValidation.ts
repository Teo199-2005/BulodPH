import { computed, type Ref } from 'vue'

export interface PasswordRule {
  key: string
  label: string
  met: boolean
}

/**
 * Reactive password-strength validation composable.
 *
 * @param password – a reactive ref holding the current password string
 * @returns rules (array of { key, label, met }), isValid (all met), strengthPercent (0-100)
 */
export function usePasswordValidation(password: Ref<string>) {
  const rules = computed<PasswordRule[]>(() => {
    const pw = password.value ?? ''
    return [
      { key: 'length',    label: 'At least 8 characters',           met: pw.length >= 8 },
      { key: 'uppercase', label: 'At least 1 uppercase letter (A-Z)', met: /[A-Z]/.test(pw) },
      { key: 'digit',     label: 'At least 1 digit (0-9)',           met: /[0-9]/.test(pw) },
      { key: 'special',   label: 'At least 1 special character (!@#$%…)', met: /[^A-Za-z0-9]/.test(pw) },
    ]
  })

  const isValid = computed(() => rules.value.every((r) => r.met))

  const strengthPercent = computed(() => {
    const total = rules.value.length
    const met = rules.value.filter((r) => r.met).length
    return Math.round((met / total) * 100)
  })

  return { rules, isValid, strengthPercent }
}
