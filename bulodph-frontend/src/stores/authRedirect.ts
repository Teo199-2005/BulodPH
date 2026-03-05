import { defineStore } from 'pinia'
import { ref } from 'vue'

/** Tracks post-login/register redirect so we can show a loading screen until the dashboard is ready. */
export const useAuthRedirectStore = defineStore('authRedirect', () => {
  const isRedirecting = ref(false)
  /** Set to true when DashboardView has loaded its core data (KPIs, bookings, vehicles, etc.) */
  const dashboardDataReady = ref(false)

  function setRedirecting(value: boolean) {
    isRedirecting.value = value
    if (!value) dashboardDataReady.value = false
  }

  function setDashboardDataReady(value: boolean) {
    dashboardDataReady.value = value
  }

  return {
    isRedirecting,
    dashboardDataReady,
    setRedirecting,
    setDashboardDataReady,
  }
})
