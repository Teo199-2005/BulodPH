import { defineStore } from 'pinia'
import { computed, ref, watch } from 'vue'

const THEME_KEY = 'bulodph-theme'
type ThemeName = 'bulodLight' | 'dark'

function getStoredTheme(): ThemeName {
  try {
    const v = localStorage.getItem(THEME_KEY)
    if (v === 'dark' || v === 'bulodLight') return v
    if (typeof window !== 'undefined' && window.matchMedia?.('(prefers-color-scheme: dark)').matches) return 'dark'
  } catch {
    /* ignore */
  }
  return 'bulodLight'
}

export const useThemeStore = defineStore('theme', () => {
  const currentTheme = ref<ThemeName>(getStoredTheme())
  const isDark = computed(() => currentTheme.value === 'dark')

  function toggle() {
    currentTheme.value = currentTheme.value === 'bulodLight' ? 'dark' : 'bulodLight'
    return currentTheme.value
  }

  function set(theme: ThemeName) {
    currentTheme.value = theme
  }

  watch(
    currentTheme,
    (t) => {
      try {
        localStorage.setItem(THEME_KEY, t)
      } catch {
        /* ignore */
      }
    },
    { immediate: true }
  )

  return { currentTheme, isDark, toggle, set }
})
