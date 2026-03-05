<template>
  <div ref="appShellRef" class="app-shell" :class="`app-shell--${roleKey}`">
    <!-- Skip link for keyboard users -->
    <a href="#main-content" class="skip-link">Skip to main content</a>
    <!-- Navigation Drawer -->
    <v-navigation-drawer
      v-model="drawer"
      :temporary="isMobile"
      :permanent="!isMobile"
      :width="260"
      app
      class="hpa-sidebar"
    >
      <div class="sidebar-inner">
        <!-- Logo -->
        <div class="sidebar-brand">
          <div v-if="logoSrc" class="sidebar-logo-wrap">
            <img
              src="/logo.png"
              alt="BulodPH"
              class="sidebar-logo"
              @error="logoSrc = false"
            />
          </div>
          <div v-else class="sidebar-brand-fallback">
            <span class="sidebar-brand-name">BulodPH</span>
            <span class="sidebar-brand-tagline">Car sharing</span>
          </div>
        </div>

        <!-- Welcome & date/time -->
        <div class="sidebar-welcome">
          <p class="sidebar-welcome-text">Welcome back, {{ userName }}</p>
          <p class="sidebar-welcome-datetime">{{ currentDate }} · {{ currentTime }}</p>
        </div>

        <div class="sidebar-divider" />

        <!-- Main -->
        <nav class="sidebar-nav">
          <span class="sidebar-nav-label">Main</span>
          <v-list v-model:opened="openGroups" nav density="compact" class="sidebar-list">
            <template v-for="item in mainMenuItems" :key="item.to || item.title">
              <v-list-group
                v-if="item.children?.length"
                :value="getGroupValue(item)"
                class="sidebar-group"
                :class="{ 'sidebar-group--active': isGroupActive(item) }"
              >
                <template #activator="{ props }">
                  <v-list-item
                    v-bind="props"
                    :prepend-icon="item.icon"
                    :title="item.title"
                    class="sidebar-item sidebar-item-group"
                    rounded="lg"
                  />
                </template>
                <v-list-item
                  v-for="child in item.children"
                  :key="child.to"
                  :prepend-icon="child.icon"
                  :title="child.title"
                  :class="['sidebar-item sidebar-item-child', { 'sidebar-item-active': isNavActive(child.to) }]"
                  :aria-current="isNavActive(child.to) ? 'page' : undefined"
                  rounded="lg"
                  @click.prevent="navigateTo(child.to)"
                />
              </v-list-group>
              <v-list-item
                v-else
                :prepend-icon="item.icon"
                :title="item.title"
                :class="['sidebar-item', { 'sidebar-item-active': isNavActive(item.to) }]"
                :aria-current="isNavActive(item.to) ? 'page' : undefined"
                rounded="lg"
                @click.prevent="navigateTo(item.to)"
              />
            </template>
          </v-list>
        </nav>

        <div class="sidebar-divider" />

        <!-- Other: rostering, finance, staff -->
        <nav class="sidebar-nav">
          <span class="sidebar-nav-label">Other</span>
          <v-list v-model:opened="openGroups" nav density="compact" class="sidebar-list">
            <template v-for="item in otherMenuItems" :key="item.to || item.title">
              <v-list-group
                v-if="item.children?.length"
                :value="getGroupValue(item)"
                class="sidebar-group"
                :class="{ 'sidebar-group--active': isGroupActive(item) }"
              >
                <template #activator="{ props }">
                  <v-list-item
                    v-bind="props"
                    :prepend-icon="item.icon"
                    :title="item.title"
                    class="sidebar-item sidebar-item-group"
                    rounded="lg"
                  />
                </template>
                <v-list-item
                  v-for="child in item.children"
                  :key="child.to"
                  :prepend-icon="child.icon"
                  :title="child.title"
                  :class="['sidebar-item sidebar-item-child', { 'sidebar-item-active': isNavActive(child.to) }]"
                  :aria-current="isNavActive(child.to) ? 'page' : undefined"
                  rounded="lg"
                  @click.prevent="navigateTo(child.to)"
                />
              </v-list-group>
              <v-list-item
                v-else
                :prepend-icon="item.icon"
                :title="item.title"
                :class="['sidebar-item', { 'sidebar-item-active': isNavActive(item.to) }]"
                :aria-current="isNavActive(item.to) ? 'page' : undefined"
                rounded="lg"
                @click.prevent="navigateTo(item.to)"
              />
            </template>
          </v-list>
        </nav>

        <div class="sidebar-divider" />

        <!-- Account -->
        <div class="sidebar-footer">
          <span class="sidebar-nav-label">Account</span>
          <v-list nav density="compact" class="sidebar-list footer-list">
            <v-list-item
              prepend-icon="mdi-account"
              title="Profile"
              :class="['sidebar-item', { 'sidebar-item-active': isNavActive('/profile') }]"
              :aria-current="isNavActive('/profile') ? 'page' : undefined"
              rounded="lg"
              @click.prevent="navigateTo('/profile')"
            />
            <v-list-item
              prepend-icon="mdi-cog"
              title="Settings"
              :class="['sidebar-item', { 'sidebar-item-active': isNavActive('/settings') }]"
              :aria-current="isNavActive('/settings') ? 'page' : undefined"
              rounded="lg"
              @click.prevent="navigateTo('/settings')"
            />
            <v-divider class="footer-divider" />
            <v-list-item
              prepend-icon="mdi-logout"
              title="Logout"
              class="sidebar-item sidebar-item-logout"
              rounded="lg"
              @click="handleLogout"
            />
          </v-list>
        </div>
      </div>
    </v-navigation-drawer>

    <!-- Topbar – desktop: single row; mobile: two rows so title/subtitle show in full -->
    <header class="topbar" :class="{ 'topbar--mobile': isMobile }">
      <!-- Desktop: single row -->
      <div v-if="!isMobile" class="topbar__row">
        <router-link
          v-if="showAnnouncementCta"
          :to="{ name: 'announcements' }"
          class="topbar__cta"
        >
          <v-icon icon="mdi-bullhorn-outline" size="20" />
          <span>Send Announcement</span>
        </router-link>
        <div class="topbar__spacer" />
        <div class="topbar__center">
          <h1 class="topbar__title">{{ currentPageTitle }}</h1>
          <p class="topbar__subtitle">{{ pageSubtitle }}</p>
        </div>
        <div class="topbar__spacer" />
        <div class="topbar__actions">
          <v-tooltip location="bottom">
            <template #activator="{ props: tooltipProps }">
              <button v-bind="tooltipProps" type="button" class="topbar__icon" aria-label="Search (Ctrl+K or /)" @click="commandPaletteStore.open()">
                <v-icon icon="mdi-magnify" size="22" />
              </button>
            </template>
            Search (Ctrl+K or /)
          </v-tooltip>
          <v-tooltip location="bottom">
            <template #activator="{ props: tooltipProps }">
              <router-link v-bind="tooltipProps" to="/notifications" class="topbar__icon" aria-label="Notifications">
                <HpaNotificationBadge :count="notificationsStore.unreadCount">
                  <v-icon icon="mdi-bell-outline" size="22" />
                </HpaNotificationBadge>
              </router-link>
            </template>
            Notifications
          </v-tooltip>
        </div>
        <v-menu
          location="bottom end"
          :close-on-content-click="true"
          transition="scale-transition"
          content-class="topbar-menu"
        >
          <template #activator="{ props }">
            <button v-bind="props" type="button" class="topbar__user">
              <span class="topbar__avatar-wrap">
                <v-avatar size="44" class="topbar__avatar">
                  <v-img v-if="userAvatar" :src="userAvatar" />
                  <span v-else class="topbar__avatar-txt">{{ userInitials }}</span>
                </v-avatar>
                <span class="topbar__avatar-dot" aria-hidden="true" />
              </span>
              <span class="topbar__user-info">
                <span class="topbar__user-name">{{ userName }}</span>
                <span class="topbar__user-role">{{ userRole }}</span>
              </span>
              <v-icon icon="mdi-chevron-down" size="20" class="topbar__user-chevron" />
            </button>
          </template>
          <v-list min-width="220" class="topbar-menu__list">
            <v-list-item to="/profile">
              <template #prepend><v-icon icon="mdi-account" size="20" /></template>
              <v-list-item-title>Profile</v-list-item-title>
            </v-list-item>
            <v-list-item to="/settings">
              <template #prepend><v-icon icon="mdi-cog" size="20" /></template>
              <v-list-item-title>Settings</v-list-item-title>
            </v-list-item>
            <v-divider />
            <v-list-item @click="handleLogout">
              <template #prepend><v-icon icon="mdi-logout" color="error" size="20" /></template>
              <v-list-item-title class="text-error">Logout</v-list-item-title>
            </v-list-item>
          </v-list>
        </v-menu>
      </div>

      <!-- Mobile: single row – menu, title/subtitle (small), actions, avatar -->
      <div v-else class="topbar__row">
        <v-tooltip location="bottom">
          <template #activator="{ props: tooltipProps }">
            <button
              v-bind="tooltipProps"
              type="button"
              class="topbar__menu"
              :class="{ 'topbar__menu--open': drawer }"
              aria-label="Menu"
              @click.stop.prevent="toggleDrawer"
            >
              <v-icon :icon="drawer ? 'mdi-close' : 'mdi-menu'" size="22" />
            </button>
          </template>
          Menu
        </v-tooltip>
        <div class="topbar__center topbar__center--mobile-inline">
          <h1 class="topbar__title topbar__title--mobile-inline">{{ currentPageTitle }}</h1>
          <p class="topbar__subtitle topbar__subtitle--mobile-inline">{{ pageSubtitle }}</p>
        </div>
        <div class="topbar__actions">
          <v-tooltip location="bottom">
            <template #activator="{ props: tooltipProps }">
              <button v-bind="tooltipProps" type="button" class="topbar__icon" aria-label="Search (Ctrl+K or /)" @click="commandPaletteStore.open()">
                <v-icon icon="mdi-magnify" size="22" />
              </button>
            </template>
            Search (Ctrl+K or /)
          </v-tooltip>
          <v-tooltip location="bottom">
            <template #activator="{ props: tooltipProps }">
              <router-link v-bind="tooltipProps" to="/notifications" class="topbar__icon" aria-label="Notifications">
                <HpaNotificationBadge :count="notificationsStore.unreadCount">
                  <v-icon icon="mdi-bell-outline" size="22" />
                </HpaNotificationBadge>
              </router-link>
            </template>
            Notifications
          </v-tooltip>
        </div>
        <v-menu
          location="bottom end"
          :close-on-content-click="true"
          transition="scale-transition"
          content-class="topbar-menu"
        >
          <template #activator="{ props }">
            <button v-bind="props" type="button" class="topbar__user topbar__user--mobile">
              <span class="topbar__avatar-wrap">
                <v-avatar size="40" class="topbar__avatar">
                  <v-img v-if="userAvatar" :src="userAvatar" />
                  <span v-else class="topbar__avatar-txt">{{ userInitials }}</span>
                </v-avatar>
                <span class="topbar__avatar-dot" aria-hidden="true" />
              </span>
            </button>
          </template>
          <v-list min-width="220" class="topbar-menu__list">
            <v-list-item to="/profile">
              <template #prepend><v-icon icon="mdi-account" size="20" /></template>
              <v-list-item-title>Profile</v-list-item-title>
            </v-list-item>
            <v-list-item to="/settings">
              <template #prepend><v-icon icon="mdi-cog" size="20" /></template>
              <v-list-item-title>Settings</v-list-item-title>
            </v-list-item>
            <v-divider />
            <v-list-item @click="handleLogout">
              <template #prepend><v-icon icon="mdi-logout" color="error" size="20" /></template>
              <v-list-item-title class="text-error">Logout</v-list-item-title>
            </v-list-item>
          </v-list>
        </v-menu>
      </div>
    </header>

    <!-- Main Content: content + footer in normal flow; footer sits below each page, scrolls with content -->
    <v-main id="main-content" class="main-content main-with-footer main-with-topbar" tabindex="-1" role="main">
      <div class="main-content-wrap app-dots-bg dashboard-watermark-wrap">
        <div class="dashboard-watermark" aria-hidden="true"></div>
        <div class="app-container main-content-inner">
          <router-view v-slot="{ Component }">
            <transition name="page" mode="out-in">
              <component :is="Component" :key="$route.path" />
            </transition>
          </router-view>
        </div>
      </div>
      <AppFooter />
    </v-main>

    <!-- Bottom Navigation (Mobile Only) – role-based -->
    <v-bottom-navigation
      v-if="isMobile"
      v-model="bottomNav"
      grow
      app
      class="bottom-nav"
      height="72"
    >
      <v-btn
        v-for="item in bottomNavItems"
        :key="item.to"
        :value="item.to"
        class="bottom-nav-btn"
        :aria-current="isNavActive(item.to) ? 'page' : undefined"
        @click.prevent="navigateTo(item.to)"
      >
        <v-icon size="26">{{ item.icon }}</v-icon>
        <span class="bottom-nav-label">{{ item.title }}</span>
      </v-btn>
    </v-bottom-navigation>

    <!-- Car owner: popup modal for unseen bookings (approved/paid) on login -->
    <CarOwnerUnseenBookingsModal v-if="roleKey === 'car_owner'" />
  </div>
</template>

<script setup lang="ts">
import { ref, computed, watch, onMounted, nextTick } from 'vue'
import { useDisplay } from 'vuetify'
import { useRoute, useRouter } from 'vue-router'
import { format } from 'date-fns'
import { useUserSessionStore } from '@/stores/userSession'
import { getAvatarUrl } from '@/constants/images'
import { useRoleTheme } from '@/composables/useRoleTheme'
import { getRoleNav, type NavItem } from '@/constants/roleNav'
import AppFooter from '@/components/AppFooter.vue'
import CarOwnerUnseenBookingsModal from '@/components/car-owner/CarOwnerUnseenBookingsModal.vue'
import HpaNotificationBadge from '@/components/base/HpaNotificationBadge.vue'
import { useNotificationsStore } from '@/stores/notifications'
import { useCommandPaletteStore } from '@/stores/commandPalette'
import { usePaymentMethodsStore } from '@/stores/paymentMethods'
import { useFavoritesStore } from '@/stores/favorites'
import { useCartStore } from '@/stores/cart'
import { useClientBookingsStore } from '@/stores/clientBookings'
import { useCarOwnerBookingsStore } from '@/stores/carOwnerBookings'
const { mobile } = useDisplay()
const notificationsStore = useNotificationsStore()
const commandPaletteStore = useCommandPaletteStore()
const isMobile = computed(() => mobile.value)
const route = useRoute()
const router = useRouter()
const userSession = useUserSessionStore()

const appShellRef = ref<HTMLElement | null>(null)
const { roleKey } = useRoleTheme(appShellRef)

const drawer = ref(!isMobile.value)
const isDrawerToggling = ref(false)
const bottomNav = ref(route.path)
const logoSrc = ref(true)
const openGroups = ref<string[]>([])

// Role-based sidebar and bottom nav
const roleNav = computed(() => getRoleNav(roleKey.value))
const mainMenuItems = computed(() => roleNav.value.main)
const otherMenuItems = computed(() => roleNav.value.other)
/** Flatten main items and their children for title/subtitle lookup */
const allNavItems = computed(() => {
  const out: { to: string; title: string }[] = []
  const collect = (items: NavItem[]) => {
    for (const item of items) {
      if (item.children?.length) {
        for (const c of item.children) out.push({ to: c.to, title: c.title })
      } else if (item.to) {
        out.push({ to: item.to, title: item.title })
      }
    }
  }
  collect(mainMenuItems.value)
  collect(otherMenuItems.value)
  return out
})
const bottomNavItems = computed(() => roleNav.value.bottomNav)

const getGroupValue = (item: NavItem) => `group-${item.title}`
const isGroupActive = (item: NavItem) => item.children?.some(child => isNavActive(child.to)) ?? false
const getActiveGroupValues = (items: NavItem[]) =>
  items.filter(item => item.children?.length && isGroupActive(item)).map(getGroupValue)

const currentPageTitle = computed(() => {
  const path = route.path
  const item = allNavItems.value.find(i => i.to === path)
  if (item) return item.title
  if (path.startsWith('/admin/vehicles')) return 'Browse rides'
  if (path.startsWith('/client/browse-rentals')) return 'Browse car rentals'
  if (path.startsWith('/client/rentals/')) return 'Car rental'
  if (path.startsWith('/car-owner/profile')) return 'Profile'
  if (path.startsWith('/admin/car-owners')) return 'Car rental owners'
  if (path.startsWith('/clients')) return 'Clients'
  if (path.startsWith('/admin/marketing-staff')) return 'Marketing staff'
  if (path.startsWith('/announcements')) return 'Announcements'
  if (path.startsWith('/reports')) return 'Reports'
  if (path.startsWith('/settings')) return 'Settings'
  if (path.startsWith('/profile')) return 'Profile'
  if (path.startsWith('/notifications')) return 'Notifications'
  const metaTitle = route.meta?.title as string | undefined
  if (metaTitle) return metaTitle
  return 'BulodPH'
})

const pageSubtitleMap: Record<string, string> = {
  Dashboard: 'Overview and key metrics',
  'Browse rides': 'Find a ride throughout the region',
  'Browse car rentals': 'Find rental companies and their fleets',
  'Car rental': 'Profile and fleet',
  'My bookings': 'Upcoming and past trips',
  Promos: 'Discounts and offers',
  'My vehicles': 'List and manage your vehicles',
  Bookings: 'Hand-offs and trip history',
  Earnings: 'Payouts and balance',
  'Referral link': 'Share and earn',
  Campaigns: 'Active campaigns and materials',
  Resources: 'Logos and key messages',
  'User Management': 'Manage owners and administrators',
  'User management': 'Car rental companies, clients and marketing partners',
  'Car rental owners': 'Rental companies who list cars',
  Vehicles: 'Manage vehicles – add, edit, remove',
  Clients: 'Renters – view bookings and documents',
  'Marketing staff': 'Referral and marketing partners',
  Listings: 'Vehicle listings',
  Payouts: 'Payout requests and history',
  Announcements: 'Send announcements',
  Reports: 'Platform reports, insights and export data',
  Settings: 'Preferences and security',
  Profile: 'Your account and verification',
  Notifications: 'Booking and account updates',
}
const pageSubtitle = computed(() =>
  (route.meta?.subtitle as string) ?? pageSubtitleMap[currentPageTitle.value] ?? 'BulodPH'
)

const showAnnouncementCta = computed(() => roleKey.value === 'admin')

const userName = computed(() => userSession.user?.name || 'User')
const userAvatar = computed(() => getAvatarUrl(userName.value, userSession.user?.avatar_url))

const userInitials = computed(() => {
  const name = userName.value.trim()
  if (!name) return 'U'
  const parts = name.split(/\s+/).filter(Boolean)
  if (parts.length >= 2) return (parts[0][0] + parts[1][0]).toUpperCase()
  return name.slice(0, 2).toUpperCase()
})

const userRole = computed(() => {
  const roles = userSession.user?.roles
  if (roles?.length) {
    const r = roles[0]
    const normalized = (typeof r === 'string' ? r : String(r)).toLowerCase().replace(/\s+/g, '_')
    const labels: Record<string, string> = {
      admin: 'Administrator',
      car_owner: 'Car rental owner',
      marketing_staff: 'Partner',
      client: 'Renter',
    }
    return labels[normalized] ?? r.charAt(0).toUpperCase() + r.slice(1).toLowerCase()
  }
  // When roles not yet loaded (e.g. after refresh), infer from path so car-owner doesn't see "Administrator"
  const path = route.path
  if (path.startsWith('/car-owner')) return 'Car rental owner'
  if (path.startsWith('/admin')) return 'Administrator'
  if (path.startsWith('/dashboard') || path.startsWith('/client')) return 'Renter'
  return 'User'
})

const toggleDrawer = () => {
  if (isDrawerToggling.value) return
  isDrawerToggling.value = true

  if (drawer.value) {
    drawer.value = false
  } else {
    requestAnimationFrame(() => {
      drawer.value = true
    })
  }

  window.setTimeout(() => {
    isDrawerToggling.value = false
  }, 200)
}


const currentDate = ref(format(new Date(), 'EEEE, MMMM d, yyyy'))
const currentTime = ref(format(new Date(), 'h:mm a'))

watch(() => route.path, (path) => { bottomNav.value = path }, { immediate: true })
watch(
  () => route.path,
  () => {
    const activeGroups = [
      ...getActiveGroupValues(mainMenuItems.value),
      ...getActiveGroupValues(otherMenuItems.value),
    ]
    for (const value of activeGroups) {
      if (!openGroups.value.includes(value)) openGroups.value.push(value)
    }
  },
  { immediate: true }
)

watch(
  () => isMobile.value,
  (mobileView) => {
    drawer.value = mobileView ? false : true
  },
  { immediate: true }
)

// Reload user-scoped stores when user changes (logout/login or switch account)
watch(
  () => userSession.user?.id,
  () => {
    usePaymentMethodsStore().reload()
    useFavoritesStore().reload()
    useCartStore().reload()
    useNotificationsStore().reload()
    useClientBookingsStore().reload()
    useCarOwnerBookingsStore().reload()
  },
  { immediate: true }
)

// #region agent log
function logFooterLayout() {
  nextTick(() => {
    const el = appShellRef.value
    if (!el) return
    const main = el.querySelector('#main-content') as HTMLElement | null
    const wrap = el.querySelector('.main-content-wrap') as HTMLElement | null
    const footer = el.querySelector('.app-footer') as HTMLElement | null
    const mainStyle = main ? getComputedStyle(main) : null
    const wrapStyle = wrap ? getComputedStyle(wrap) : null
    const parent = main?.parentElement
    const parentStyle = parent ? getComputedStyle(parent) : null
    const payload = {
      sessionId: '178d91',
      runId: 'footer-debug',
      hypothesisId: 'A-C',
      location: 'MobileLayout.vue:logFooterLayout',
      message: 'Footer layout heights and computed styles (desktop vs mobile)',
      data: {
        route: route.path,
        viewportWidth: typeof window !== 'undefined' ? window.innerWidth : null,
        isMobile: isMobile.value,
        mainHeight: main?.offsetHeight ?? null,
        wrapHeight: wrap?.offsetHeight ?? null,
        footerHeight: footer?.offsetHeight ?? null,
        mainFlex: mainStyle?.flex ?? null,
        mainMinHeight: mainStyle?.minHeight ?? null,
        wrapFlex: wrapStyle?.flex ?? null,
        wrapMinHeight: wrapStyle?.minHeight ?? null,
        gapApprox: main && wrap && footer ? main.offsetHeight - wrap.offsetHeight - footer.offsetHeight : null,
        parentTagName: parent?.tagName ?? null,
        parentDisplay: parentStyle?.display ?? null,
        parentMinHeight: parentStyle?.minHeight ?? null,
        parentHeight: parent?.clientHeight ?? null,
      },
      timestamp: Date.now(),
    }
    if (import.meta.env.DEV) {
      fetch('http://127.0.0.1:7729/ingest/4e9ac25c-fe57-41fa-a774-d34fd0bff637', {
        method: 'POST',
        headers: { 'Content-Type': 'application/json', 'X-Debug-Session-Id': '178d91' },
        body: JSON.stringify(payload),
      }).catch(() => {})
    }
  })
}
// #endregion

onMounted(() => {
  setInterval(() => {
    currentDate.value = format(new Date(), 'EEEE, MMMM d, yyyy')
    currentTime.value = format(new Date(), 'h:mm a')
  }, 60000)
  logFooterLayout()
})
watch(() => route.path, () => logFooterLayout())

/** Client-side navigation – prevents full page refresh when clicking sidebar/bottom nav */
function navigateTo(path: string) {
  if (!path || path === route.path) return
  router.push(path).catch(() => {})
  if (isMobile.value) drawer.value = false
}

/** Check if a nav link is active (handles nested paths like /clients/123) */
function isNavActive(to: string): boolean {
  if (route.path === to) return true
  if (to && to !== '/' && route.path.startsWith(to + '/')) return true
  return false
}

const handleLogout = () => {
  userSession.clearAuth()
  router.push('/login')
}
</script>

<style scoped>
/* App shell – light base so dot pattern can show in main area */
.app-shell {
  background-color: var(--surface-0, #ffffff) !important;
}

/* Desktop: shell is flex column so main can fill remaining viewport height (sticky footer) */
@media (min-width: 960px) {
  .app-shell {
    display: flex;
    flex-direction: column;
    min-height: 100vh;
  }
}

/* Sidebar – role-colored dark gradient (vars set by useRoleTheme) */
:deep(.hpa-sidebar) {
  position: fixed !important;
  top: 0 !important;
  left: 0 !important;
  bottom: 0 !important;
  height: 100vh !important;
  min-height: 100vh !important;
  max-height: 100vh !important;
  z-index: 1000;
  background: linear-gradient(165deg, var(--role-primary, #1e3a5f) 0%, #0f172a 50%, #0c1222 100%) !important;
  border-right: 1px solid rgba(255, 255, 255, 0.08) !important;
  box-shadow: 4px 0 24px rgba(0, 0, 0, 0.15) !important;
}

:deep(.hpa-sidebar) .v-navigation-drawer__content {
  display: flex;
  flex-direction: column;
  height: 100%;
  min-height: 100vh;
  max-height: 100vh;
  overflow: hidden;
  scrollbar-width: none;
  -ms-overflow-style: none;
}

:deep(.hpa-sidebar) .v-navigation-drawer__content::-webkit-scrollbar {
  display: none;
}

.sidebar-inner {
  display: flex;
  flex-direction: column;
  height: 100%;
  min-height: 0;
  padding: 0;
  overflow-y: auto;
  overflow-x: hidden;
  scrollbar-width: none;
  -ms-overflow-style: none;
}

.sidebar-inner::-webkit-scrollbar {
  display: none;
}

.sidebar-brand {
  padding: 16px 16px 14px;
  display: flex;
  justify-content: stretch;
  width: 100%;
  box-sizing: border-box;
}

.sidebar-logo-wrap {
  display: block;
  width: 100%;
  padding: 12px 16px;
  box-sizing: border-box;
  background: rgba(255, 255, 255, 0.98);
  border-radius: var(--radius-md, 12px);
  border: 1px solid rgba(255, 255, 255, 0.2);
  box-shadow: 0 2px 16px rgba(0, 0, 0, 0.25), 0 0 0 1px rgba(30, 58, 95, 0.1);
}

.sidebar-logo {
  width: 100%;
  height: auto;
  min-height: 44px;
  max-height: 64px;
  object-fit: contain;
  object-position: center center;
  display: block;
}

.sidebar-brand-fallback {
  display: flex;
  flex-direction: column;
  gap: 2px;
  padding-left: 8px;
}

.sidebar-brand-name {
  font-size: 0.9375rem;
  font-weight: 700;
  color: #f8fafc;
  letter-spacing: 0.02em;
}

.sidebar-brand-tagline {
  font-size: 0.625rem;
  color: rgba(248, 250, 252, 0.5);
  text-transform: uppercase;
  letter-spacing: 0.04em;
}

.sidebar-welcome {
  padding: 10px 16px 12px;
  flex-shrink: 0;
  margin: 0 12px;
}

.sidebar-welcome-text {
  font-size: 0.8125rem;
  font-weight: 500;
  color: rgba(248, 250, 252, 0.9);
  margin: 0 0 2px;
  line-height: 1.3;
}

.sidebar-welcome-datetime {
  font-size: var(--text-xs, 0.75rem);
  color: var(--sidebar-text-muted, rgba(248, 250, 252, 0.65));
  margin: 0;
  line-height: 1.3;
  font-weight: 500;
}

.sidebar-divider {
  height: 1px;
  background: linear-gradient(90deg, transparent 0%, rgba(255, 255, 255, 0.12) 20%, rgba(255, 255, 255, 0.12) 80%, transparent 100%);
  flex-shrink: 0;
  margin: 0 16px;
}

.sidebar-nav {
  flex: 0 0 auto;
  padding: 12px 0;
  overflow: visible;
  min-height: 0;
}

.sidebar-nav-label {
  display: block;
  padding: 0 16px 8px;
  font-size: var(--text-xs, 0.75rem);
  font-weight: 600;
  color: var(--sidebar-label, rgba(248, 250, 252, 0.55));
  text-transform: uppercase;
  letter-spacing: 0.06em;
}

.sidebar-list {
  padding: 0 8px !important;
  background: transparent !important;
}

:deep(.hpa-sidebar) .sidebar-list .v-list-item {
  color: rgba(248, 250, 252, 0.85);
  font-size: 0.8125rem;
  font-weight: 500;
  min-height: 40px !important;
  padding-inline: 12px !important;
  margin-bottom: 2px;
  border-radius: 8px;
  transition: background 0.2s ease, color 0.2s ease;
}

:deep(.hpa-sidebar) .sidebar-list .v-list-item:hover {
  background: rgba(255, 255, 255, 0.06);
  color: #f8fafc;
}

:deep(.hpa-sidebar) .sidebar-list .v-list-item .v-icon {
  color: rgba(248, 250, 252, 0.7);
  margin-inline-end: 10px;
  font-size: 1.125rem;
}

:deep(.hpa-sidebar) .sidebar-group .v-list-group__items .v-list-item {
  padding-inline-start: 36px !important;
}

:deep(.hpa-sidebar) .sidebar-group.sidebar-group--active > .v-list-group__header .v-list-item {
  background: rgba(255, 255, 255, 0.04);
  color: #f8fafc;
}

/* Role-colored active state (CSS vars set by useRoleTheme) */
:deep(.hpa-sidebar) .sidebar-item-active {
  background: var(--role-bg-tint, rgba(30, 58, 95, 0.18)) !important;
  color: #e0f2fe !important;
  border-left: 3px solid var(--role-primary, #1e3a5f);
  padding-left: 9px !important;
  box-shadow: inset 0 0 0 1px var(--role-border, rgba(30, 58, 95, 0.12));
}

:deep(.hpa-sidebar) .sidebar-item-active .v-icon {
  color: #c7e0f4 !important;
}

.sidebar-footer {
  padding: 10px 0 16px;
  flex-shrink: 0;
  margin-top: auto;
  border-top: 1px solid rgba(255, 255, 255, 0.08);
}

.sidebar-footer .sidebar-nav-label {
  padding: 0 16px 6px;
}

.sidebar-footer .footer-list {
  padding-top: 0;
}

:deep(.hpa-sidebar) .footer-divider {
  margin: 8px 16px 8px 48px;
  border-color: rgba(255, 255, 255, 0.08);
  opacity: 1;
}

:deep(.hpa-sidebar) .sidebar-item-logout .v-icon {
  color: rgba(248, 250, 252, 0.6);
}

:deep(.hpa-sidebar) .sidebar-item-logout:hover {
  color: #fca5a5;
}

:deep(.hpa-sidebar) .sidebar-item-logout:hover .v-icon {
  color: #fca5a5 !important;
}

/* ========== Topbar – glass bar (centered title, user card) ========== */
.topbar {
  position: fixed;
  top: 0;
  left: 0;
  right: 0;
  z-index: 1005;
  height: 80px;
  background: rgba(255, 255, 255, 0.7);
  backdrop-filter: blur(20px);
  -webkit-backdrop-filter: blur(20px);
  border-bottom: 1px solid rgba(255, 255, 255, 0.5);
  box-shadow: var(--shadow-topbar, 0 2px 8px rgba(0, 0, 0, 0.06)), 0 0 0 1px rgba(255, 255, 255, 0.3) inset;
  font-family: 'DM Sans', system-ui, -apple-system, sans-serif;
  transition: left 0.2s ease;
}
@media (min-width: 960px) {
  .topbar {
    left: 260px;
  }
}

.topbar__row {
  display: flex;
  align-items: center;
  height: 100%;
  padding: 0 16px;
  gap: 20px;
}

.topbar__menu {
  display: inline-flex;
  align-items: center;
  justify-content: center;
  min-width: 44px;
  min-height: 44px;
  width: 48px;
  height: 48px;
  border: 1px solid rgba(15, 23, 42, 0.14);
  border-radius: 14px;
  background: rgba(255, 255, 255, 0.9);
  color: var(--trust-blue, #0f172a);
  cursor: pointer;
  flex-shrink: 0;
  box-shadow: 0 10px 20px rgba(15, 23, 42, 0.12), 0 0 0 1px rgba(255, 255, 255, 0.5) inset;
  transition: transform 0.2s ease, box-shadow 0.2s ease, border-color 0.2s ease, background-color 0.2s ease, color 0.2s ease;
}
.topbar__menu:hover {
  background: #ffffff;
  border-color: rgba(15, 23, 42, 0.24);
  box-shadow: 0 14px 28px rgba(15, 23, 42, 0.16), 0 0 0 1px rgba(255, 255, 255, 0.7) inset;
  transform: translateY(-1px);
}
.topbar__menu:active {
  transform: scale(0.98);
}
.topbar__menu--open {
  background: rgba(15, 23, 42, 0.08);
  border-color: rgba(15, 23, 42, 0.28);
  box-shadow: 0 8px 18px rgba(15, 23, 42, 0.12), 0 0 0 1px rgba(255, 255, 255, 0.6) inset;
}


.topbar__cta {
  display: inline-flex;
  align-items: center;
  gap: 10px;
  padding: 12px 20px;
  border-radius: 12px;
  background: var(--role-gradient, linear-gradient(135deg, #2d3a52 0%, #1e3a5f 100%));
  color: #fff;
  font-size: 0.9375rem;
  font-weight: 600;
  text-decoration: none;
  letter-spacing: 0.02em;
  box-shadow: 0 2px 10px rgba(30, 58, 95, 0.3);
  transition: transform 0.2s, box-shadow 0.2s;
}
.topbar__cta:hover {
  transform: translateY(-1px);
  box-shadow: 0 4px 16px rgba(30, 58, 95, 0.35);
}

.topbar__spacer {
  flex: 1;
  min-width: 16px;
}

.topbar__center {
  display: flex;
  flex-direction: column;
  align-items: center;
  justify-content: center;
  text-align: center;
  min-width: 0;
  gap: 6px;
}

/* Desktop: shift title right so it appears centered in viewport (accounting for sidebar + right actions) */
@media (min-width: 960px) {
  .topbar__row .topbar__center {
    margin-left: 160px;
  }
}

.topbar__title {
  font-size: var(--text-xl, 1.375rem);
  font-weight: 700;
  color: var(--trust-blue, #0f172a);
  letter-spacing: 0.02em;
  line-height: 1.2;
  margin: 0;
  white-space: nowrap;
  overflow: hidden;
  text-overflow: ellipsis;
  max-width: 320px;
}

.topbar__subtitle {
  font-size: var(--text-body-sm, 0.875rem);
  font-weight: 500;
  color: var(--text-secondary, #64748b);
  letter-spacing: 0.02em;
  line-height: 1.3;
  margin: 0;
  white-space: nowrap;
  overflow: hidden;
  text-overflow: ellipsis;
  max-width: 320px;
}

.topbar__actions {
  display: flex;
  align-items: center;
  gap: 6px;
}

.topbar__icon {
  display: flex;
  align-items: center;
  justify-content: center;
  min-width: 44px;
  min-height: 44px;
  width: 48px;
  height: 48px;
  border: none;
  border-radius: 12px;
  background: transparent;
  color: var(--text-secondary, #64748b);
  cursor: pointer;
  transition: background 0.2s, color 0.2s;
}
.topbar__icon:hover {
  background: var(--hover-overlay, rgba(15, 23, 42, 0.06));
  color: var(--role-primary, #1e3a5f);
}

.topbar__icon--badge {
  position: relative;
}
.topbar__badge {
  position: absolute;
  top: 10px;
  right: 10px;
  min-width: 20px;
  height: 20px;
  padding: 0 6px;
  border-radius: 10px;
  background: var(--role-primary, #1e3a5f);
  color: #fff;
  font-size: 0.6875rem;
  font-weight: 700;
  display: flex;
  align-items: center;
  justify-content: center;
}

.topbar__user {
  display: flex;
  align-items: center;
  gap: 14px;
  padding: 8px 16px 8px 8px;
  border: none;
  border-radius: 999px;
  background: rgba(248, 250, 252, 0.9);
  border: 1px solid rgba(255, 255, 255, 0.6);
  box-shadow: 0 1px 2px rgba(71, 85, 105, 0.08), 0 1px 2px rgba(255, 255, 255, 0.5) inset;
  cursor: pointer;
  transition: background 0.2s, border-color 0.2s, box-shadow 0.2s;
}
.topbar__user:hover {
  background: rgba(241, 245, 249, 0.95);
  border-color: rgba(148, 163, 184, 0.4);
  box-shadow: 0 4px 12px rgba(15, 23, 42, 0.1), 0 2px 4px rgba(255, 255, 255, 0.5) inset;
}

.topbar__avatar-wrap {
  position: relative;
  flex-shrink: 0;
}

.topbar__avatar {
  background: var(--role-gradient, linear-gradient(145deg, #1e3a5f 0%, #334155 100%)) !important;
  border: 2px solid #fff;
  box-shadow: 0 2px 10px rgba(0, 0, 0, 0.15);
}

.topbar__avatar-txt {
  color: #fff;
  font-weight: 700;
  font-size: 1rem;
  letter-spacing: 0.02em;
}

.topbar__avatar-dot {
  position: absolute;
  bottom: 0;
  right: 0;
  width: 12px;
  height: 12px;
  background: var(--accent-green, #22c55e);
  border: 2px solid #fff;
  border-radius: 50%;
  box-shadow: 0 0 0 1px rgba(34, 197, 94, 0.3);
}

.topbar__user-info {
  display: flex;
  flex-direction: column;
  align-items: flex-start;
  gap: 2px;
  min-width: 0;
  text-align: left;
}

.topbar__user-name {
  font-size: var(--text-body, 0.9375rem);
  font-weight: 600;
  color: var(--trust-blue, #0f172a);
  line-height: 1.2;
  white-space: nowrap;
  overflow: hidden;
  text-overflow: ellipsis;
  max-width: 160px;
}

.topbar__user-role {
  font-size: var(--text-xs, 0.6875rem);
  font-weight: 700;
  text-transform: uppercase;
  letter-spacing: 0.05em;
  color: var(--text-secondary, #64748b);
}

.topbar__user-chevron {
  color: var(--text-muted, #94a3b8);
  flex-shrink: 0;
}

/* User dropdown menu */
:deep(.topbar-menu) {
  margin-top: 10px;
  border-radius: 20px;
  overflow: hidden;
  background: transparent;
  box-shadow: 0 20px 45px rgba(15, 23, 42, 0.2), 0 6px 18px rgba(15, 23, 42, 0.12);
  transform-origin: top right;
}

/* Ensure Vuetify overlay content is rounded too */
:deep(.topbar-menu .v-overlay__content) {
  border-radius: 20px;
  overflow: hidden;
}

:deep(.topbar-menu) .topbar-menu__list {
  padding: 10px;
  background: rgba(255, 255, 255, 0.98);
  backdrop-filter: blur(20px);
  -webkit-backdrop-filter: blur(20px);
  border: 1px solid rgba(148, 163, 184, 0.18);
  border-radius: 20px;
  min-width: 240px !important;
}

:deep(.topbar-menu) .v-list-item {
  border-radius: 14px;
  margin: 4px;
  min-height: 44px;
  font-weight: 600;
  color: var(--trust-blue, #0f172a);
  transition: background 0.2s ease, color 0.2s ease, transform 0.2s ease;
}

:deep(.topbar-menu) .v-list-item:hover {
  background: rgba(15, 23, 42, 0.06);
  transform: translateX(2px);
}

:deep(.topbar-menu) .v-list-item .v-icon {
  color: var(--text-secondary, #64748b);
}

:deep(.topbar-menu) .v-divider {
  margin: 6px 10px;
  border-color: rgba(148, 163, 184, 0.18);
}

/* Mobile: single row, smaller title/subtitle so they fit in the top bar */
.topbar--mobile {
  height: 72px;
  min-height: 72px;
}
.topbar--mobile .topbar__row {
  height: 100%;
  padding: 0 10px;
  gap: 8px;
}
.topbar--mobile .topbar__center--mobile-inline {
  flex: 1;
  min-width: 0;
  display: flex;
  flex-direction: column;
  justify-content: center;
  align-items: flex-start;
  text-align: left;
  gap: 0;
  padding: 2px 0;
}
.topbar--mobile .topbar__title--mobile-inline {
  font-size: var(--text-body, 0.9375rem);
  font-weight: 700;
  color: var(--trust-blue, #0f172a);
  margin: 0;
  line-height: 1.2;
  white-space: nowrap;
  overflow: hidden;
  text-overflow: ellipsis;
  max-width: 100%;
}
.topbar--mobile .topbar__subtitle--mobile-inline {
  font-size: var(--text-xs, 0.75rem);
  font-weight: 500;
  color: var(--text-secondary, #64748b);
  margin: 0;
  line-height: 1.2;
  white-space: nowrap;
  overflow: hidden;
  text-overflow: ellipsis;
  max-width: 100%;
}
.topbar--mobile .topbar__user--mobile {
  padding: 4px;
}
.topbar--mobile .topbar__user-info,
.topbar--mobile .topbar__user-chevron {
  display: none;
}
.topbar--mobile .topbar__avatar,
.topbar--mobile .topbar__avatar-wrap :deep(.v-avatar) {
  width: 40px !important;
  height: 40px !important;
  min-width: 40px !important;
  min-height: 40px !important;
}

@media (max-width: 599px) {
  .topbar:not(.topbar--mobile) {
    height: 72px;
  }
  .topbar--mobile {
    height: 72px;
    min-height: 72px;
  }
}

/* Main content offset – use :deep so rules apply to v-main root (it has our classes but not our scoped data-v-*) */
:deep(.main-content.main-with-topbar) {
  padding-top: 80px !important;
}
@media (max-width: 599px) {
  :deep(.main-content.main-with-topbar) {
    padding-top: 72px !important;
  }
}

/* Main content – transparent; mobile: content-sized. Desktop: min height so body fills viewport and footer at bottom */
:deep(.main-content) {
  background-color: transparent !important;
  background-image: none !important;
  flex: 0 0 auto !important;
  padding-top: 120px !important;
}

/* Force Vuetify v-main inner area transparent */
:deep(.main-content .v-main__scroller) {
  background: transparent !important;
}

/* Mobile: content + footer in normal flow. Desktop: flex column so content area can grow and footer stays at bottom */
:deep(.main-with-footer) {
  display: block;
  min-height: 0;
}

.main-content-wrap {
  width: 100%;
  max-width: none;
  min-height: 0;
  box-sizing: border-box;
  padding: var(--page-padding-y, 24px) var(--page-padding-x, 24px) 32px;
  padding-bottom: 24px;
}

/* Desktop: main body fills remaining viewport; content area grows so footer sits at bottom */
@media (min-width: 960px) {
  :deep(.main-content) {
    display: flex !important;
    flex-direction: column !important;
    flex: 1 1 auto !important; /* fill app-shell so main gets full height below header */
    min-height: 0 !important;
  }
  :deep(.main-with-footer) {
    display: flex !important;
    flex-direction: column !important;
    min-height: 100% !important;
  }
  /* v-main direct children: .main-content-wrap (grow) + .app-footer (shrink 0) */
  :deep(.main-content > .main-content-wrap) {
    flex: 1 1 auto !important;
    min-height: 0 !important;
  }
  :deep(.main-content > .app-footer) {
    flex: 0 0 auto !important;
  }
}

/* Footer top border uses role primary */
:deep(.app-footer) {
  border-top-color: var(--role-primary, var(--border-subtle, #e2e8f0));
}

@media (max-width: 599px) {
  :deep(.main-content) {
    padding-top: 72px !important;
  }
}

@media (min-width: 600px) {
  .main-content-wrap {
    padding: var(--page-padding-y, 24px) var(--page-padding-x, 24px) 28px;
  }
}

@media (min-width: 960px) {
  .main-content-wrap {
    padding: var(--page-padding-y, 24px) var(--page-padding-x, 24px) 28px;
  }
}

/* Mobile: space above bottom nav so footer isn't hidden behind it */
@media (max-width: 959.99px) {
  .main-with-footer .app-footer {
    margin-bottom: 0px;
  }
}

.bottom-nav {
  background: var(--glass-bg, rgba(255, 255, 255, 0.75)) !important;
  backdrop-filter: blur(var(--glass-blur, 20px));
  -webkit-backdrop-filter: blur(var(--glass-blur, 20px));
  border-top: 1px solid var(--glass-border-dark, rgba(15, 23, 42, 0.08));
  box-shadow: var(--shadow-topbar, 0 2px 8px rgba(0, 0, 0, 0.06)), 0 0 0 1px rgba(255, 255, 255, 0.3) inset;
}

.bottom-nav-label {
  font-size: var(--text-body) !important;
  font-weight: 600;
}

.bottom-nav-btn {
  min-height: 72px;
  min-width: 44px;
}

/* Page transition: fade + subtle slide (formal, not bouncy) */
.page-enter-active,
.page-leave-active {
  transition: opacity 0.35s cubic-bezier(0.4, 0, 0.2, 1),
    transform 0.35s cubic-bezier(0.4, 0, 0.2, 1);
}

.page-enter-from {
  opacity: 0;
  transform: translateX(8px);
}

.page-leave-to {
  opacity: 0;
  transform: translateX(-6px);
}
</style>
