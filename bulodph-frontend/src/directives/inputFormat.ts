import type { DirectiveBinding } from 'vue'
import { formatInput, type InputFormat } from '@/utils/inputFormatters'

function getInput(el: HTMLElement): HTMLInputElement | HTMLTextAreaElement | null {
  if (el.tagName === 'INPUT' || el.tagName === 'TEXTAREA') {
    return el as HTMLInputElement | HTMLTextAreaElement
  }
  return el.querySelector('input, textarea')
}

function attachListener(el: HTMLElement, format: InputFormat) {
  const input = getInput(el)
  if (!input) return

  const handler = () => {
    const start = input.selectionStart ?? input.value.length
    const formatted = formatInput(input.value, format)
    if (formatted !== input.value) {
      input.value = formatted
      input.setSelectionRange(Math.min(start, formatted.length), Math.min(start, formatted.length))
      input.dispatchEvent(new Event('input', { bubbles: true }))
    }
  }

  input.addEventListener('input', handler)
  ;(el as any).__inputFormatCleanup = () => input.removeEventListener('input', handler)
}

export const vInputFormat = {
  mounted(el: HTMLElement, binding: DirectiveBinding<InputFormat>) {
    const format = binding.value ?? 'none'
    if (format === 'none') return
    // Vuetify may render input asynchronously
    const tryAttach = () => {
      if (getInput(el)) {
        attachListener(el, format)
      } else {
        requestAnimationFrame(tryAttach)
      }
    }
    tryAttach()
  },
  beforeUnmount(el: HTMLElement) {
    ;(el as any).__inputFormatCleanup?.()
  },
}
