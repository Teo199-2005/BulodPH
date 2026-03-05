import { defineStore } from 'pinia'
import { ref, computed } from 'vue'

/** Global command palette open state. Used by App.vue and MobileLayout topbar search. */
export const useCommandPaletteStore = defineStore('commandPalette', () => {
  const _isOpen = ref(false)

  const isOpen = computed({
    get: () => _isOpen.value,
    set: (v: boolean) => { _isOpen.value = v },
  })

  function open() {
    _isOpen.value = true
  }

  function close() {
    _isOpen.value = false
  }

  function toggle() {
    _isOpen.value = !_isOpen.value
  }

  return { isOpen, open, close, toggle }
})
