import { defineStore } from 'pinia'
import { ref, watch } from 'vue'

const LOCALE_STORAGE_KEY = 'hpa_locale'

export type LocaleCode = 'en' | 'ar'

const DEFAULT_LOCALE: LocaleCode = 'en'

function getStoredLocale(): LocaleCode {
  try {
    const raw = localStorage.getItem(LOCALE_STORAGE_KEY)
    if (raw === 'en' || raw === 'ar') return raw
  } catch {
    // ignore
  }
  return DEFAULT_LOCALE
}

function applyLocale(locale: LocaleCode) {
  document.documentElement.lang = locale === 'ar' ? 'ar' : 'en'
  document.documentElement.dir = locale === 'ar' ? 'rtl' : 'ltr'
}

export const useLocaleStore = defineStore('locale', () => {
  const locale = ref<LocaleCode>(getStoredLocale())

  function setLocale(value: LocaleCode) {
    locale.value = value
    localStorage.setItem(LOCALE_STORAGE_KEY, value)
    applyLocale(value)
  }

  // Apply on init and whenever locale changes
  applyLocale(locale.value)
  watch(locale, (value) => {
    localStorage.setItem(LOCALE_STORAGE_KEY, value)
    applyLocale(value)
  }, { immediate: false })

  return {
    locale,
    setLocale,
  }
})
