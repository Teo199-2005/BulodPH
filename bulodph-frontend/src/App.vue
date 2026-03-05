<template>
  <v-app>
    <!-- Skip to main content for keyboard/screen reader users (WCAG 2.4.1) -->
    <a href="#app" class="skip-link">Skip to main content</a>
    <!-- Full-page loading screens: landing + post-login redirect -->
    <transition name="loading-fade">
      <HpaFullPageLoader
        v-if="showLandingLoader || showPostLoginLoader"
        :message="showPostLoginLoader ? 'Loading your dashboard...' : 'Loading your experience...'"
      />
    </transition>

    <!-- Single router-view: landing/login render here; dashboard routes render inside MobileLayout (nested in router) -->
    <div class="router-view-wrap">
      <router-view v-slot="{ Component }">
        <transition :name="authTransitionName" mode="out-in">
          <component :is="Component" />
        </transition>
      </router-view>
    </div>

    <!-- Toast Notifications -->
    <ToastContainer />

    <!-- Global Loading Overlay -->
    <HpaLoadingOverlay :visible="loadingOverlay.visible.value" :message="loadingOverlay.message.value" />

    <!-- Command Palette (Ctrl+K / Cmd+K or /) -->
    <HpaCommandPalette v-model="commandPaletteStore.isOpen" :items="commandPaletteItems" />
  </v-app>
</template>

<script setup lang="ts">
import { ref, watch, onMounted, onUnmounted, computed } from 'vue'
import { useRoute, useRouter } from 'vue-router'
import ToastContainer from './components/ToastContainer.vue'
import HpaFullPageLoader from '@/components/base/HpaFullPageLoader.vue'
import HpaLoadingOverlay from '@/components/base/HpaLoadingOverlay.vue'
import HpaCommandPalette from '@/components/base/HpaCommandPalette.vue'
import { useLoadingOverlay } from '@/composables/useLoadingOverlay'
import { useLocaleStore } from '@/stores/locale'
import { useUserSessionStore } from '@/stores/userSession'
import { useAuthRedirectStore } from '@/stores/authRedirect'
import { useCommandPaletteStore } from '@/stores/commandPalette'

// Apply saved language (en/ar) and dir on load
useLocaleStore()

const route = useRoute()
const router = useRouter()
const userSession = useUserSessionStore()
const previousRouteName = ref<string | undefined>(undefined)

// Global loading overlay
const loadingOverlay = useLoadingOverlay()

// Command palette – uses store so topbar search can open it
const commandPaletteStore = useCommandPaletteStore()
const commandPaletteItems = computed(() => {
  const role = userSession.user?.roles?.[0]?.toLowerCase?.() ?? ''
  const base = [
    { id: 'notifications', label: 'Notifications', icon: 'mdi-bell', action: () => router.push('/notifications') },
    { id: 'profile', label: 'Profile', icon: 'mdi-account', action: () => router.push('/profile') },
    { id: 'settings', label: 'Settings', icon: 'mdi-cog', action: () => router.push('/settings') },
  ]
  if (role === 'admin') {
    return [
      { id: 'dashboard', label: 'Dashboard', icon: 'mdi-view-dashboard', action: () => router.push('/admin') },
      { id: 'bookings', label: 'Bookings', icon: 'mdi-calendar', action: () => router.push('/admin/bookings') },
      { id: 'vehicles', label: 'Vehicle Listings', icon: 'mdi-car-multiple', action: () => router.push('/admin/vehicles') },
      { id: 'clients', label: 'Clients', icon: 'mdi-account-group', action: () => router.push('/clients') },
      { id: 'reports', label: 'Reports', icon: 'mdi-chart-bar', action: () => router.push('/reports') },
      ...base,
    ]
  }
  if (role === 'car_owner') {
    return [
      { id: 'dashboard', label: 'Dashboard', icon: 'mdi-view-dashboard', action: () => router.push('/car-owner') },
      { id: 'vehicles', label: 'My vehicles', icon: 'mdi-car-multiple', action: () => router.push('/car-owner/vehicles') },
      { id: 'bookings', label: 'Bookings', icon: 'mdi-calendar', action: () => router.push('/car-owner/bookings') },
      { id: 'earnings', label: 'Earnings', icon: 'mdi-currency-php', action: () => router.push('/car-owner/earnings') },
      ...base,
    ]
  }
  if (role === 'marketing_staff') {
    return [
      { id: 'dashboard', label: 'Dashboard', icon: 'mdi-view-dashboard', action: () => router.push('/marketing') },
      { id: 'referral', label: 'Referral link', icon: 'mdi-link', action: () => router.push('/marketing/referral') },
      { id: 'earnings', label: 'Earnings', icon: 'mdi-currency-php', action: () => router.push('/marketing/earnings') },
      ...base,
    ]
  }
  return [
    { id: 'dashboard', label: 'Dashboard', icon: 'mdi-view-dashboard', action: () => router.push('/client') },
    { id: 'browse', label: 'Browse rentals', icon: 'mdi-car-search', action: () => router.push('/client/browse-rentals') },
    { id: 'bookings', label: 'My bookings', icon: 'mdi-calendar', action: () => router.push('/client/bookings') },
    ...base,
  ]
})

// Slide transition between login and register: login panel slides right (off), register slides in
const authTransitionName = computed(() => {
  const to = route.name as string | undefined
  const from = previousRouteName.value
  if (to === 'register' && from === 'login') return 'slide-to-register'
  if (to === 'login' && from === 'register') return 'slide-to-login'
  return 'fade'
})

watch(
  () => route.name,
  (name) => {
    previousRouteName.value = name as string | undefined
  },
  { immediate: true, flush: 'post' }
)

onMounted(() => {
  userSession.hydrate()
})

// Loading screen: show on landing until min time (1000ms) then fade out
const showLandingLoader = ref(false)
let loadingTimer: ReturnType<typeof setTimeout> | null = null

function scheduleHideLoader() {
  if (loadingTimer) clearTimeout(loadingTimer)
  loadingTimer = setTimeout(() => {
    showLandingLoader.value = false
    loadingTimer = null
  }, 1200)
}

watch(
  () => route.name,
  (name) => {
    if (name === 'landing') {
      showLandingLoader.value = true
      scheduleHideLoader()
    } else {
      showLandingLoader.value = false
      if (loadingTimer) {
        clearTimeout(loadingTimer)
        loadingTimer = null
      }
    }
  },
  { immediate: true }
)

onUnmounted(() => {
  if (loadingTimer) clearTimeout(loadingTimer)
  if (postLoginTimer) clearTimeout(postLoginTimer)
})

// Post-login loading: show when redirecting to dashboard, hide after data loads (or min time)
const authRedirect = useAuthRedirectStore()
const showPostLoginLoader = computed(() => authRedirect.isRedirecting)
let postLoginTimer: ReturnType<typeof setTimeout> | null = null

const DASHBOARD_ROUTES = ['dashboard', 'client-dashboard', 'admin-dashboard', 'car-owner-dashboard', 'marketing-dashboard']

function hidePostLoginLoader() {
  if (postLoginTimer) {
    clearTimeout(postLoginTimer)
    postLoginTimer = null
  }
  authRedirect.setRedirecting(false)
}

watch(
  () => ({ name: route.name, requiresAuth: route.meta?.requiresAuth === true, dashboardReady: authRedirect.dashboardDataReady }),
  ({ requiresAuth, dashboardReady }) => {
    if (!authRedirect.isRedirecting) return
    const isDashboardRoute = DASHBOARD_ROUTES.includes(route.name as string)
    if (requiresAuth) {
      // Landed on dashboard: wait for data to load, with max 3s timeout
      if (isDashboardRoute) {
        if (dashboardReady) {
          // Data loaded – hide after short delay for smooth transition
          if (postLoginTimer) clearTimeout(postLoginTimer)
          postLoginTimer = setTimeout(hidePostLoginLoader, 400)
        } else {
          // Start max-wait timer (3s) so we don't block forever
          if (!postLoginTimer) {
            postLoginTimer = setTimeout(() => {
              authRedirect.setRedirecting(false)
              postLoginTimer = null
            }, 3000)
          }
        }
      } else {
        // Other auth route (profile, settings, etc.) – hide after 800ms
        if (postLoginTimer) clearTimeout(postLoginTimer)
        postLoginTimer = setTimeout(() => {
          authRedirect.setRedirecting(false)
          postLoginTimer = null
        }, 800)
      }
    } else {
      if (postLoginTimer) {
        clearTimeout(postLoginTimer)
        postLoginTimer = null
      }
      authRedirect.setRedirecting(false)
    }
  },
  { immediate: true }
)
</script>

<style scoped>
/* Fade Transition (loading + default route) */
.loading-fade-enter-active {
  transition: opacity 0.3s ease;
}

.loading-fade-leave-active {
  transition: opacity 0.5s ease;
}

.loading-fade-enter-from,
.loading-fade-leave-to {
  opacity: 0;
}

/* Router view: clip sliding panels */
.skip-link {
  position: absolute;
  top: -100px;
  left: 0;
  padding: 0.75rem 1.25rem;
  background: rgb(var(--v-theme-primary));
  color: white;
  z-index: 9999;
  font-weight: 600;
  text-decoration: none;
  border-radius: 0 0 0.5rem 0;
  transition: top 0.2s ease;
}
.skip-link:focus {
  top: 0;
  outline: 2px solid white;
  outline-offset: 2px;
}

.router-view-wrap {
  overflow: hidden;
  width: 100%;
  min-height: 100vh;
}

/* Login → Register: current panel slides right (off), register slides in from right */
.slide-to-register-leave-active,
.slide-to-register-enter-active {
  transition: transform 0.45s cubic-bezier(0.4, 0, 0.2, 1);
}

.slide-to-register-leave-from {
  transform: translateX(0);
}

.slide-to-register-leave-to {
  transform: translateX(-100%);
}

.slide-to-register-enter-from {
  transform: translateX(100%);
}

.slide-to-register-enter-to {
  transform: translateX(0);
}

/* Register → Login: current panel slides right (off), login slides in from left */
.slide-to-login-leave-active,
.slide-to-login-enter-active {
  transition: transform 0.45s cubic-bezier(0.4, 0, 0.2, 1);
}

.slide-to-login-leave-from {
  transform: translateX(0);
}

.slide-to-login-leave-to {
  transform: translateX(100%);
}

.slide-to-login-enter-from {
  transform: translateX(-100%);
}

.slide-to-login-enter-to {
  transform: translateX(0);
}

/* Default fade for other route changes */
.fade-enter-active,
.fade-leave-active {
  transition: opacity 0.25s ease;
}

.fade-enter-from,
.fade-leave-to {
  opacity: 0;
}

</style>

