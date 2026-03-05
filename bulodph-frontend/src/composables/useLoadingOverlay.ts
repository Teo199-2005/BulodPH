import { ref } from 'vue'

const visible = ref(false)
const message = ref('')

/**
 * Global loading overlay state. Use with HpaLoadingOverlay in App.vue.
 */
export function useLoadingOverlay() {
  function show(msg?: string) {
    message.value = msg ?? ''
    visible.value = true
  }

  function hide() {
    visible.value = false
  }

  return { visible, message, show, hide }
}
