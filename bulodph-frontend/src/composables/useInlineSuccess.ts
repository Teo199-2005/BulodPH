import { ref } from 'vue'

/**
 * Composable for showing brief inline success feedback (e.g. "Saved", "Copied!").
 * Returns a reactive visible state and a show() function that displays for a short duration.
 */
export function useInlineSuccess(defaultMessage = 'Saved', duration = 2000) {
  const visible = ref(false)
  const message = ref(defaultMessage)
  let timer: ReturnType<typeof setTimeout> | null = null

  function show(customMessage?: string) {
    if (timer) clearTimeout(timer)
    message.value = customMessage ?? defaultMessage
    visible.value = true
    timer = setTimeout(() => {
      visible.value = false
      timer = null
    }, duration)
  }

  function hide() {
    if (timer) clearTimeout(timer)
    visible.value = false
  }

  return { visible, message, show, hide }
}
