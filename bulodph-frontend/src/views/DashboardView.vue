<template>
  <DashboardTemplate :animate="true">
    <!-- Client-only: Compact sliding promo strip (above stats) -->
    <v-row v-if="roleKey === 'client'" class="mb-2">
      <v-col cols="12">
        <DashboardPromoStrip />
      </v-col>
    </v-row>

    <!-- Role-based KPI cards (GSAP stagger on load) -->
    <div ref="statsStaggerRef" class="dashboard-stats-stagger-wrap">
      <v-row class="mb-4 align-center">
        <v-col
          v-for="(stat, i) in roleStats"
          :key="i"
          cols="6"
          sm="6"
          lg="3"
        >
          <HpaDashboardWidget
          :loading="kpiLoading"
          :role="primaryRole"
          :title="stat.title"
          :value="stat.value"
          :icon="stat.icon"
          :prefix="stat.prefix"
          :suffix="stat.suffix"
          :trend="stat.trend"
          :trend-value="stat.trendValue"
          :trend-label="stat.trendLabel"
        />
        </v-col>
      </v-row>
    </div>

    <!-- Admin-only: Rental analytics – Weekly Bookings, Car Types, Status Distribution -->
    <v-row v-if="roleKey === 'admin'" class="mb-4">
      <v-col cols="12" lg="8">
        <v-card elevation="0" rounded="lg" class="modern-card">
          <div class="section-card-header section-card-header--with-actions">
            <div class="section-card-icon">
              <v-icon icon="mdi-chart-bar" size="20" />
            </div>
            <span class="section-card-title">Weekly Bookings</span>
            <v-spacer />
            <v-btn-toggle
              v-model="dashboardTimeRange"
              mandatory
              density="compact"
              variant="outlined"
              rounded="lg"
              class="dashboard-mode-toggle"
            >
              <v-btn value="week" size="small">Week</v-btn>
              <v-btn value="month" size="small">Month</v-btn>
              <v-btn value="year" size="small">Year</v-btn>
            </v-btn-toggle>
          </div>
          <v-divider class="dashboard-divider" />
          <v-card-text class="pa-4">
            <div class="chart-height">
              <component :is="LineChart" v-if="LineChart" :data="weeklyBookingsData" :options="lineChartOptions" />
              <div v-else class="text-caption text-medium-emphasis">Loading chart…</div>
            </div>
          </v-card-text>
        </v-card>
      </v-col>
      <v-col cols="12" lg="4">
        <v-card elevation="0" rounded="lg" class="modern-card h-100">
          <div class="section-card-header section-card-header--with-actions">
            <div class="section-card-icon">
              <v-icon icon="mdi-car-side" size="20" />
            </div>
            <span class="section-card-title">Most Rented Car Types</span>
            <v-spacer />
            <v-btn-toggle
              v-model="dashboardTimeRange"
              mandatory
              density="compact"
              variant="outlined"
              rounded="lg"
              class="dashboard-mode-toggle"
            >
              <v-btn value="week" size="small">Week</v-btn>
              <v-btn value="month" size="small">Month</v-btn>
              <v-btn value="year" size="small">Year</v-btn>
            </v-btn-toggle>
          </div>
          <v-divider class="dashboard-divider" />
          <v-card-text class="pa-4">
            <div class="car-types-list car-types-bar-chart">
              <div v-for="row in mostRentedCarTypes" :key="row.type" class="car-type-row">
                <span class="car-type-name">{{ row.type }}</span>
                <div class="car-type-bar-track">
                  <div
                    class="car-type-bar-fill"
                    :style="{ width: Math.max(row.percent, 0) + '%' }"
                  />
                </div>
                <span class="car-type-meta">
                  <span class="car-type-count">{{ row.count }}</span>
                  <span class="car-type-pct">{{ row.percent }}%</span>
                </span>
              </div>
            </div>
          </v-card-text>
        </v-card>
      </v-col>
    </v-row>

    <!-- Admin: Dashboard promos currently displaying -->
    <v-row v-if="roleKey === 'admin'" class="mb-4">
      <v-col cols="12">
        <v-card elevation="0" rounded="lg" class="modern-card">
          <div class="section-card-header section-card-header--with-actions">
            <div class="section-card-icon">
              <v-icon icon="mdi-image-multiple" size="20" />
            </div>
            <span class="section-card-title">Dashboard promos (currently displaying)</span>
            <v-spacer />
            <v-btn color="primary" variant="tonal" size="small" rounded="lg" :to="{ name: 'admin-dashboard-promos' }">
              Manage
            </v-btn>
          </div>
          <v-divider class="dashboard-divider" />
          <v-card-text class="pa-4">
            <p class="text-body-2 text-medium-emphasis mb-3">These images are shown on Client, Car rental owner, and Marketing dashboards. Add, edit, or remove them below.</p>
            <div class="admin-promos-preview">
              <div
                v-for="promo in adminDashboardPromosList"
                :key="promo.id"
                class="admin-promos-preview__item"
              >
                <v-img :src="promo.imageUrl" :alt="promo.title" cover height="80" width="140" class="admin-promos-preview__img" />
                <div class="admin-promos-preview__meta">
                  <span class="admin-promos-preview__title">{{ promo.title || 'Untitled' }}</span>
                  <v-chip size="x-small" class="mt-1">{{ promo.targetRole }}</v-chip>
                </div>
              </div>
              <p v-if="!adminDashboardPromosList.length" class="text-body-2 text-medium-emphasis mb-0">No promos yet. Click Manage to add.</p>
            </div>
          </v-card-text>
        </v-card>
      </v-col>
    </v-row>

    <!-- Admin: Recent activity / recent bookings (full width to fill empty space) -->
    <v-row v-if="roleKey === 'admin'" class="mb-4">
      <v-col cols="12">
        <v-card elevation="0" rounded="lg" class="modern-card">
          <div class="section-card-header section-card-header--with-actions recent-bookings-header">
            <div class="section-card-icon">
              <v-icon icon="mdi-clock-outline" size="20" />
            </div>
            <span class="section-card-title">Recent bookings</span>
            <v-spacer />
            <v-btn variant="tonal" color="primary" size="small" rounded="lg" :to="{ name: 'admin-bookings' }">View all</v-btn>
          </div>
          <v-divider class="dashboard-divider" />
          <v-card-text class="pa-0">
            <div v-if="adminRecentBookings.length" class="activity-list">
              <router-link
                v-for="b in adminRecentBookings"
                :key="b.id"
                :to="{ name: 'admin-booking-detail', params: { id: b.id } }"
                class="activity-item text-decoration-none d-block"
              >
                <div class="d-flex align-center activity-item__inner">
                  <div class="activity-item__icon activity-item__icon--primary rounded-lg">
                    <v-icon icon="mdi-calendar-check" size="20" color="white" />
                  </div>
                  <div class="activity-item__body flex-grow-1 min-width-0">
                    <div class="activity-item__title text-body-1 font-weight-medium">{{ b.vehicleName || 'Booking' }} · {{ b.clientName || b.clientEmail || 'Client' }}</div>
                    <div class="activity-item__desc text-caption text-medium-emphasis">{{ b.startDate }} – {{ b.endDate }} · {{ b.status }}</div>
                  </div>
                  <v-icon icon="mdi-chevron-right" size="20" class="text-medium-emphasis" />
                </div>
              </router-link>
            </div>
            <v-card-text v-else class="pa-4">
              <p class="text-body-2 text-medium-emphasis mb-0">No recent bookings. New rentals will appear here.</p>
            </v-card-text>
          </v-card-text>
        </v-card>
      </v-col>
    </v-row>

    <!-- Client: Promos & offers + Plan your next gala now – same Promos container size as car owner -->
    <v-row v-if="roleKey === 'client'" class="mb-4 dashboard-promos-vehicles-row dashboard-promos-paired-row">
      <v-col cols="12" md="6" class="d-flex dashboard-promos-col" data-gsap-reveal>
        <PromosOffersBox :promos="dashboardPromosForRole" fill-height />
      </v-col>
      <v-col cols="12" md="6" class="d-flex" data-gsap-reveal>
        <v-card elevation="0" rounded="lg" class="modern-card flex-grow-1 d-flex flex-column">
          <div class="section-card-header section-card-header--with-actions">
            <div class="section-card-icon">
              <v-icon icon="mdi-car-side" size="20" />
            </div>
            <span class="section-card-title">Your next adventure</span>
            <v-spacer />
            <v-btn variant="tonal" color="primary" size="small" rounded="lg" prepend-icon="mdi-magnify" :to="{ name: 'client-browse' }">
              See all vehicles
            </v-btn>
          </div>
          <p class="text-body-2 text-medium-emphasis px-4 pt-0 pb-1 mb-0">Family trips, friends' outings—pick a ride below.</p>
          <v-divider class="dashboard-divider" />
          <v-card-text class="pa-4">
            <div class="dashboard-vehicles-grid dashboard-vehicles-grid--two-col">
              <v-card
                v-for="vehicle in clientDashboardVehicles"
                :key="vehicle.id"
                elevation="0"
                rounded="lg"
                class="modern-card dashboard-vehicle-card"
                hover
                :to="{ name: 'client-vehicle-detail', params: { id: vehicle.id } }"
              >
                <v-img :src="vehicle.image" :alt="vehicle.name" cover class="dashboard-vehicle-card__img" />
                <v-card-text class="pa-2">
                  <div class="d-flex flex-wrap gap-1 mb-1">
                    <v-chip v-if="vehicle.rentalMode" size="x-small" variant="tonal" color="secondary" density="compact">{{ rentalModeLabel(vehicle.rentalMode) }}</v-chip>
                    <v-chip v-if="minRentalChipText(vehicle.minRentalPeriodHours)" size="x-small" variant="tonal" color="secondary" density="compact">{{ minRentalChipText(vehicle.minRentalPeriodHours) }}</v-chip>
                  </div>
                  <h3 class="text-subtitle-1 font-weight-bold mb-1">{{ vehicle.name }}</h3>
                  <p class="text-body-2 text-medium-emphasis mb-2">{{ vehicle.location }} · {{ vehicle.type }}</p>
                  <PriceDisplay :price-per-day="vehicle.pricePerDay" :original-price-per-day="vehicle.originalPricePerDay" variant="card" />
                </v-card-text>
              </v-card>
            </div>
          </v-card-text>
        </v-card>
      </v-col>
    </v-row>

    <!-- Car owner: Promos (left) + Upcoming hand-offs (right), same container height -->
    <v-row v-if="roleKey === 'car_owner'" class="mb-4 dashboard-promos-handoffs-row dashboard-promos-paired-row">
      <v-col cols="12" md="6" class="d-flex dashboard-promos-col dashboard-promos-col--tall" data-gsap-reveal>
        <PromosOffersBox :promos="dashboardPromosForRole" fill-height />
      </v-col>
      <v-col cols="12" md="6" class="d-flex dashboard-handoffs-col" data-gsap-reveal>
        <v-card elevation="0" rounded="lg" class="modern-card flex-grow-1">
          <div class="section-card-header section-card-header--with-actions">
            <div class="section-card-icon">
              <v-icon icon="mdi-calendar-clock" size="20" />
            </div>
            <span class="section-card-title">Upcoming hand-offs & recent activity</span>
            <v-spacer />
            <v-btn variant="tonal" color="primary" size="small" rounded="lg" :to="{ name: 'car-owner-bookings' }">View all</v-btn>
          </div>
          <v-divider class="dashboard-divider" />
          <v-card-text class="pa-0">
            <div v-if="carOwnerRecentActivity.length" class="activity-list">
              <router-link
                v-for="b in carOwnerRecentActivity"
                :key="b.id"
                :to="{ name: 'car-owner-booking-detail', params: { id: b.id } }"
                class="activity-item text-decoration-none d-block"
              >
                <div class="d-flex align-center activity-item__inner">
                  <div class="activity-item__icon activity-item__icon--primary rounded-lg">
                    <v-icon icon="mdi-car-side" size="20" color="white" />
                  </div>
                  <div class="activity-item__body flex-grow-1 min-width-0">
                    <div class="activity-item__title text-body-1 font-weight-medium">{{ b.vehicleName }} · {{ b.renterName }}</div>
                    <div class="activity-item__desc text-caption text-medium-emphasis">{{ b.start }} – {{ b.end }} · {{ b.status }}</div>
                  </div>
                  <v-chip
                    v-if="b.status === 'Requested'"
                    color="warning"
                    size="small"
                    variant="tonal"
                    class="mr-2"
                  >
                    Action needed
                  </v-chip>
                  <v-icon icon="mdi-chevron-right" size="20" class="text-medium-emphasis" />
                </div>
              </router-link>
            </div>
            <v-card-text v-else class="pa-4">
              <p class="text-body-2 text-medium-emphasis mb-0">No upcoming hand-offs. New bookings will appear here.</p>
              <v-btn variant="tonal" color="primary" size="small" rounded="lg" class="mt-3" :to="{ name: 'car-owner-vehicles' }">Add vehicles to get started</v-btn>
            </v-card-text>
          </v-card-text>
        </v-card>
      </v-col>
    </v-row>

    <!-- Car owner only: My vehicles at a glance (no Quick links widget) -->
    <v-row v-if="roleKey === 'car_owner'" class="mb-4">
      <v-col cols="12">
        <v-card elevation="0" rounded="lg" class="modern-card">
          <div class="section-card-header section-card-header--with-actions">
            <div class="section-card-icon">
              <v-icon icon="mdi-car-multiple" size="20" />
            </div>
            <span class="section-card-title">My vehicles</span>
            <v-spacer />
            <v-btn variant="tonal" color="primary" size="small" rounded="lg" prepend-icon="mdi-plus-circle-outline" :to="{ name: 'car-owner-vehicle-new' }">Add vehicle</v-btn>
            <v-btn variant="tonal" color="primary" size="small" rounded="lg" :to="{ name: 'car-owner-vehicles' }">Manage</v-btn>
          </div>
          <v-divider class="dashboard-divider" />
          <v-card-text class="pa-4">
            <div v-if="carOwnerDashboardVehicles.length" class="dashboard-vehicles-grid dashboard-vehicles-grid--compact-car">
              <router-link
                v-for="v in carOwnerDashboardVehicles"
                :key="v.id"
                :to="{ name: 'car-owner-vehicle-edit', params: { id: v.id } }"
                class="dashboard-vehicle-minicard"
              >
                <v-img :src="v.image" :alt="v.name" cover class="dashboard-vehicle-minicard__img" />
                <div class="dashboard-vehicle-minicard__meta">
                  <span v-if="v.rentalMode || minRentalChipText(v.minRentalPeriodHours)" class="d-flex flex-wrap gap-1 mb-1">
                    <v-chip v-if="v.rentalMode" size="x-small" variant="tonal" color="secondary" density="compact" class="dashboard-vehicle-minicard__chip">{{ rentalModeLabel(v.rentalMode) }}</v-chip>
                    <v-chip v-if="minRentalChipText(v.minRentalPeriodHours)" size="x-small" variant="tonal" color="secondary" density="compact" class="dashboard-vehicle-minicard__chip">{{ minRentalChipText(v.minRentalPeriodHours) }}</v-chip>
                  </span>
                  <span class="dashboard-vehicle-minicard__name">{{ v.name }}</span>
                  <span class="dashboard-vehicle-minicard__type">{{ v.type || v.carType || 'Vehicle' }}</span>
                  <span class="dashboard-vehicle-minicard__price">₱{{ (v.pricePerDay ?? 0).toLocaleString() }}/day</span>
                </div>
              </router-link>
            </div>
            <HpaEmptyState
              v-else
              preset="no-vehicles"
              @action="$router.push({ name: 'car-owner-vehicle-new' })"
            />
          </v-card-text>
        </v-card>
      </v-col>
    </v-row>

    <!-- Marketing only: Promos & offers -->
    <v-row v-if="roleKey === 'marketing_staff'" class="mb-4 dashboard-promos-row">
      <v-col cols="12">
        <v-card v-if="dashboardPromosForRole.length" elevation="0" rounded="lg" class="modern-card h-100">
          <div class="section-card-header">
            <div class="section-card-icon">
              <v-icon icon="mdi-image-multiple" size="20" />
            </div>
            <span class="section-card-title">Promos & offers</span>
          </div>
          <v-divider class="dashboard-divider" />
          <v-card-text class="pa-4">
            <div class="dashboard-promos-grid dashboard-promos-grid--compact">
              <template v-for="promo in dashboardPromosForRole" :key="promo.id">
                <a
                  v-if="promo.linkUrl?.startsWith('http')"
                  :href="promo.linkUrl"
                  target="_blank"
                  rel="noopener"
                  class="dashboard-promo-card dashboard-promo-card--link"
                >
                  <v-img :src="promo.imageUrl" :alt="promo.title" cover class="dashboard-promo-card__img" />
                  <div v-if="promo.title" class="dashboard-promo-card__title">{{ promo.title }}</div>
                </a>
                <router-link
                  v-else-if="promo.linkUrl"
                  :to="promo.linkUrl"
                  class="dashboard-promo-card dashboard-promo-card--link"
                >
                  <v-img :src="promo.imageUrl" :alt="promo.title" cover class="dashboard-promo-card__img" />
                  <div v-if="promo.title" class="dashboard-promo-card__title">{{ promo.title }}</div>
                </router-link>
                <div v-else class="dashboard-promo-card">
                  <v-img :src="promo.imageUrl" :alt="promo.title" cover class="dashboard-promo-card__img" />
                  <div v-if="promo.title" class="dashboard-promo-card__title">{{ promo.title }}</div>
                </div>
              </template>
            </div>
          </v-card-text>
        </v-card>
        <v-card v-else elevation="0" rounded="lg" class="modern-card h-100">
          <div class="section-card-header">
            <div class="section-card-icon">
              <v-icon icon="mdi-tag-percent" size="20" />
            </div>
            <span class="section-card-title">Promos & offers</span>
          </div>
          <v-divider class="dashboard-divider" />
          <v-card-text class="pa-4">
            <p class="text-body-2 text-medium-emphasis mb-0">No promos at the moment. Check back later.</p>
          </v-card-text>
        </v-card>
      </v-col>
    </v-row>
  </DashboardTemplate>
</template>

<script setup lang="ts">
import { ref, computed, onMounted, shallowRef } from 'vue'
import DashboardPromoStrip from '@/components/DashboardPromoStrip.vue'
import HpaDashboardWidget from '@/components/base/HpaDashboardWidget.vue'
import HpaEmptyState from '@/components/base/HpaEmptyState.vue'
import DashboardTemplate from '@/components/DashboardTemplate.vue'
import PriceDisplay from '@/components/PriceDisplay.vue'
import PromosOffersBox from '@/components/PromosOffersBox.vue'
import { useAuthRedirectStore } from '@/stores/authRedirect'
import { useUserSessionStore } from '@/stores/userSession'
import { toRoleColorKey } from '@/constants/roleColors'
import { getRoleNav } from '@/constants/roleNav'
import { rentalModeLabel, minRentalChipText } from '@/constants/vehicleSeed'
import { useRentalBookings } from '@/composables/useRentalBookings'
import { useVehicles } from '@/composables/useVehicles'
import { useClientBookingsStore } from '@/stores/clientBookings'
import { useFavoritesStore } from '@/stores/favorites'
import { useCarOwnerBookingsStore } from '@/stores/carOwnerBookings'
import { getStoredVehiclesForCurrentUser, storageRefreshTrigger } from '@/composables/useCarOwnerVehiclePersistence'
import { getDashboardKpis } from '@/services/dashboard'
import { REFERRAL_STATS_SEED } from '@/constants/marketingSeed'
import { MARKETING_EARNINGS_SEED } from '@/constants/earningsSeed'
import { CAR_OWNER_EARNINGS_SEED } from '@/constants/earningsSeed'
import { useDashboardPromosStore } from '@/stores/dashboardPromos'
import type { DashboardPromoRole } from '@/stores/dashboardPromos'
import { useGsapStagger } from '@/composables/useGsapStagger'

const userSession = useUserSessionStore()
const authRedirect = useAuthRedirectStore()
const dashboardPromosStore = useDashboardPromosStore()
const { records: rentalRecords, fetchFromApi: fetchRentalBookings } = useRentalBookings()
const { vehicles, approvedVehicles, fetchFromApi: fetchVehicles } = useVehicles()
const clientBookings = useClientBookingsStore()
const favoritesStore = useFavoritesStore()
const carOwnerBookings = useCarOwnerBookingsStore()

const primaryRole = computed(() => userSession.user?.roles?.[0])
const roleKey = computed(() => toRoleColorKey(primaryRole.value))
const userName = computed(() => userSession.user?.name || userSession.user?.email?.split('@')[0] || 'Admin')

const LineChart = shallowRef()
const dashboardKpis = ref<Awaited<ReturnType<typeof getDashboardKpis>>>(null)
const statsStaggerRef = ref<HTMLElement | null>(null)
useGsapStagger(statsStaggerRef, {
  selector: '.v-col',
  y: 14,
  duration: 0.42,
  stagger: 0.06,
  ease: 'power2.out',
})

/** Car owner: count vehicles for current user (by userId or name match) */
const carOwnerVehicleCount = computed(() => {
  storageRefreshTrigger.value
  const list = vehicles.value
  const currentUserId = userSession.user?.id
  const ownerName = userSession.user?.name?.trim()
  const filtered = list.filter(v => {
    if (currentUserId && (v as { userId?: string }).userId) return (v as { userId: string }).userId === currentUserId
    if (!ownerName) return false
    return (v.businessName ?? v.hostName ?? '').toLowerCase() === ownerName.toLowerCase()
  })
  const stored = getStoredVehiclesForCurrentUser()
  const apiIds = new Set(filtered.map(v => v.id))
  const fromStored = stored.filter(v => !apiIds.has(v.id))
  return filtered.length + fromStored.length
})

/** Admin stats: prefer API KPIs when present, else from rental + vehicles */
const adminStats = computed(() => {
  const kpis = dashboardKpis.value
  if (kpis && (kpis.totalBookings != null || kpis.totalUsers != null)) {
    return {
      totalBookings: kpis.totalBookings ?? 0,
      totalCars: kpis.totalCars ?? kpis.activeVehicles ?? 0,
      carOwners: kpis.carOwners ?? 0,
      totalUsers: kpis.totalUsers ?? 0,
    }
  }
  const bookings = rentalRecords.value.filter(r => !r.archived)
  const cars = vehicles.value
  const ownerSet = new Set(cars.map(v => v.businessName ?? v.hostName).filter(Boolean))
  const clientSet = new Set(bookings.map(r => r.clientEmail || r.clientName).filter(Boolean))
  const totalUsers = Math.max(ownerSet.size + clientSet.size, 1)
  return {
    totalBookings: bookings.length,
    totalCars: cars.length,
    carOwners: ownerSet.size || 1,
    totalUsers,
  }
})

/** Role-based stats for KPI cards (wired to stores / seed where available) */
const roleStats = computed(() => {
  const key = roleKey.value
  const pastCompleted = clientBookings.pastBookings.filter(b => b.status === 'Completed').length
  const stats = {
    client: [
      { title: 'Total trips', value: pastCompleted, icon: 'mdi-car-side', trend: 'neutral' as const, trendValue: pastCompleted ? 'Completed' : 'No trips yet', trendLabel: pastCompleted ? 'trips' : '—' },
      { title: 'Upcoming bookings', value: clientBookings.upcomingBookings.length, icon: 'mdi-calendar-check', trend: 'neutral' as const, trendValue: 'Scheduled', trendLabel: 'bookings' },
      { title: 'Saved vehicles', value: favoritesStore.vehicleIds.length, icon: 'mdi-heart-outline', trend: 'neutral' as const, trendValue: 'Favorites', trendLabel: 'saved' },
      { title: 'Promo available', value: 'BULOD10', icon: 'mdi-tag-outline', trend: 'up' as const, trendValue: '10% off', trendLabel: '1-day booking' },
    ],
    car_owner: [
      { title: 'Earnings (month)', value: dashboardKpis.value?.earningsMonth ?? CAR_OWNER_EARNINGS_SEED.thisMonth, prefix: '₱', icon: 'mdi-currency-php', trend: 'neutral' as const, trendValue: '', trendLabel: '' },
      { title: 'Active listings', value: carOwnerVehicleCount.value, icon: 'mdi-car-multiple', trend: 'neutral' as const, trendValue: 'Listed', trendLabel: 'vehicles' },
      { title: 'Upcoming hand-offs', value: carOwnerBookings.upcoming.length, icon: 'mdi-calendar-check', trend: 'neutral' as const, trendValue: 'Scheduled', trendLabel: 'hand-offs' },
      { title: 'Completed trips', value: carOwnerBookings.completed.length, icon: 'mdi-check-circle', trend: 'neutral' as const, trendValue: 'Done', trendLabel: 'trips' },
    ],
    marketing_staff: [
      { title: 'Link clicks', value: dashboardKpis.value?.linkClicks ?? REFERRAL_STATS_SEED.clicks ?? 0, icon: 'mdi-cursor-default-click', trend: 'neutral' as const, trendValue: 'Clicks', trendLabel: 'on your link' },
      { title: 'Sign-ups', value: REFERRAL_STATS_SEED.signUps ?? 0, icon: 'mdi-account-plus', trend: 'neutral' as const, trendValue: 'Referred', trendLabel: 'sign-ups' },
      { title: 'Conversions', value: 3, icon: 'mdi-chart-line', trend: 'neutral' as const, trendValue: 'First', trendLabel: 'bookings' },
      { title: 'Referral earnings', value: dashboardKpis.value?.referralEarnings ?? MARKETING_EARNINGS_SEED.thisMonth, prefix: '₱', icon: 'mdi-currency-php', trend: 'neutral' as const, trendValue: 'This month', trendLabel: 'earnings' },
    ],
    admin: [
      { title: 'Bookings', value: adminStats.value.totalBookings, icon: 'mdi-calendar-check', trend: 'neutral' as const, trendValue: 'All', trendLabel: 'bookings' },
      { title: 'Total Cars', value: adminStats.value.totalCars, icon: 'mdi-car-multiple', trend: 'neutral' as const, trendValue: 'Listed', trendLabel: 'vehicles' },
      { title: 'Car rental companies', value: adminStats.value.carOwners, icon: 'mdi-account-group', trend: 'neutral' as const, trendValue: 'Registered', trendLabel: 'rentals' },
      { title: 'Total Users', value: adminStats.value.totalUsers, icon: 'mdi-account-multiple', trend: 'neutral' as const, trendValue: 'Platform', trendLabel: 'users' },
    ],
  }
  return stats[key] ?? stats.client
})

/** Dashboard promos for current role (client / car_owner / marketing) */
const dashboardPromosForRole = computed(() => {
  const key = roleKey.value
  const role: DashboardPromoRole = key === 'marketing_staff' ? 'marketing' : key === 'car_owner' ? 'car_owner' : key === 'client' ? 'client' : 'client'
  return dashboardPromosStore.getByRole(role)
})

/** Admin: all dashboard promos for "currently displaying" preview */
const adminDashboardPromosList = computed(() => dashboardPromosStore.list)

/** Admin: recent bookings (last 5 by start date) for Recent activity card */
const adminRecentBookings = computed(() => {
  const list = rentalRecords.value.filter(r => !r.archived)
  return [...list]
    .sort((a, b) => {
      const da = parseRecordDate(a.startDate)?.getTime() ?? 0
      const db = parseRecordDate(b.startDate)?.getTime() ?? 0
      return db - da
    })
    .slice(0, 5)
})

/** Client dashboard: first few vehicles for "Plan your next gala now" */
const clientDashboardVehicles = computed(() => approvedVehicles.value.slice(0, 4))

/** Car owner: recent activity = requested first, then upcoming, then completed (max 6) */
const carOwnerRecentActivity = computed(() => {
  const req = carOwnerBookings.requested
  const up = carOwnerBookings.upcoming
  const done = carOwnerBookings.completed
  return [...req, ...up, ...done.slice(0, 3)].slice(0, 6)
})

/** Car owner: vehicles for this owner (API by userId or name + stored), same logic as My vehicles page */
const carOwnerDashboardVehicles = computed(() => {
  storageRefreshTrigger.value
  const currentUserId = userSession.user?.id
  const ownerName = userSession.user?.name?.trim()
  const fromApi = vehicles.value
  const fromApiMine = fromApi.filter(v => {
    if (currentUserId && (v as { userId?: string }).userId) return (v as { userId: string }).userId === currentUserId
    if (!ownerName) return false
    return (v.businessName ?? v.hostName ?? '').toLowerCase() === ownerName.toLowerCase()
  })
  const stored = getStoredVehiclesForCurrentUser()
  const apiIds = new Set(fromApiMine.map(v => v.id))
  const fromStored = stored.filter(v => !apiIds.has(v.id))
  const merged = [...fromApiMine, ...fromStored]
  return merged.slice(0, 6).map(v => ({
    id: v.id,
    name: v.name,
    image: v.image,
    type: v.type,
    carType: (v as { carType?: string }).carType,
    pricePerDay: v.pricePerDay ?? 0,
    rentalMode: (v as { rentalMode?: string }).rentalMode,
    minRentalPeriodHours: (v as { minRentalPeriodHours?: number }).minRentalPeriodHours,
  }))
})

const kpiLoading = ref(false)

async function refreshKpis() {
  kpiLoading.value = true
  try {
    const role = roleKey.value
    const [_, __, ___, ____, kpis] = await Promise.all([
      fetchRentalBookings(),
      fetchVehicles(),
      clientBookings.fetchFromApi(),
      carOwnerBookings.fetchFromApi(),
      getDashboardKpis(role),
    ])
    dashboardKpis.value = kpis ?? null
  } finally {
    kpiLoading.value = false
    authRedirect.setDashboardDataReady(true)
  }
}

onMounted(() => {
  void loadCharts()
  refreshKpis()
})

async function loadCharts() {
  if (LineChart.value) return
  const [{ Line }, chartJs] = await Promise.all([
    import('vue-chartjs'),
    import('chart.js'),
  ])
  const {
    Chart: ChartJS,
    CategoryScale,
    LinearScale,
    PointElement,
    LineElement,
    Title,
    Tooltip,
    Legend,
    Filler,
  } = chartJs
  ChartJS.register(CategoryScale, LinearScale, PointElement, LineElement, Title, Tooltip, Legend, Filler)
  LineChart.value = Line
}


// Dashboard time range (Week / Month / Year) for admin rental analytics
const dashboardTimeRange = ref('week')

// Helper: parse seed date (e.g. 11/23/2025) to Date
function parseRecordDate(s: string): Date | null {
  if (!s) return null
  const parts = s.split(/[/-]/)
  if (parts.length >= 3) {
    const month = parseInt(parts[0], 10) - 1
    const day = parseInt(parts[1], 10)
    const year = parseInt(parts[2], 10)
    if (!isNaN(month) && !isNaN(day) && !isNaN(year)) return new Date(year, month, day)
  }
  return null
}

// Weekly Bookings chart – driven by dashboardTimeRange and rental data
const weeklyBookingsData = computed(() => {
  const list = rentalRecords.value.filter(r => !r.archived)
  const range = dashboardTimeRange.value

  if (range === 'week') {
    const dayNames = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun']
    const completed = [0, 0, 0, 0, 0, 0, 0]
    const pending = [0, 0, 0, 0, 0, 0, 0]
    const cancelled = [0, 0, 0, 0, 0, 0, 0]
    list.forEach(r => {
      const d = parseRecordDate(r.startDate)
      if (d) {
        const dayIndex = (d.getDay() + 6) % 7
        if (r.status === 'Completed') completed[dayIndex]++
        else if (r.status === 'Pending' || r.status === 'Active') pending[dayIndex]++
        else cancelled[dayIndex]++
      }
    })
    return {
      labels: dayNames,
      datasets: [
        { label: 'Completed', data: completed, borderColor: '#166534', backgroundColor: 'rgba(22, 101, 52, 0.12)', fill: true, tension: 0.4 },
        { label: 'Pending', data: pending, borderColor: '#ca8a04', backgroundColor: 'rgba(202, 138, 4, 0.12)', fill: true, tension: 0.4 },
        { label: 'Cancelled', data: cancelled, borderColor: '#dc2626', backgroundColor: 'rgba(220, 38, 38, 0.08)', fill: true, tension: 0.4 },
      ],
    }
  }

  if (range === 'month') {
    const labels = ['Week 1', 'Week 2', 'Week 3', 'Week 4']
    const completed = [0, 0, 0, 0]
    const pending = [0, 0, 0, 0]
    const cancelled = [0, 0, 0, 0]
    list.forEach(r => {
      const d = parseRecordDate(r.startDate)
      if (d) {
        const weekIndex = Math.min(3, Math.floor((d.getDate() - 1) / 7))
        if (r.status === 'Completed') completed[weekIndex]++
        else if (r.status === 'Pending' || r.status === 'Active') pending[weekIndex]++
        else cancelled[weekIndex]++
      }
    })
    return {
      labels,
      datasets: [
        { label: 'Completed', data: completed, borderColor: '#166534', backgroundColor: 'rgba(22, 101, 52, 0.12)', fill: true, tension: 0.4 },
        { label: 'Pending', data: pending, borderColor: '#ca8a04', backgroundColor: 'rgba(202, 138, 4, 0.12)', fill: true, tension: 0.4 },
        { label: 'Cancelled', data: cancelled, borderColor: '#dc2626', backgroundColor: 'rgba(220, 38, 38, 0.08)', fill: true, tension: 0.4 },
      ],
    }
  }

  // year: by month
  const monthNames = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec']
  const completed = monthNames.map(() => 0)
  const pending = monthNames.map(() => 0)
  const cancelled = monthNames.map(() => 0)
  list.forEach(r => {
    const d = parseRecordDate(r.startDate)
    if (d) {
      const i = d.getMonth()
      if (r.status === 'Completed') completed[i]++
      else if (r.status === 'Pending' || r.status === 'Active') pending[i]++
      else cancelled[i]++
    }
  })
  return {
    labels: monthNames,
    datasets: [
      { label: 'Completed', data: completed, borderColor: '#166534', backgroundColor: 'rgba(22, 101, 52, 0.12)', fill: true, tension: 0.4 },
      { label: 'Pending', data: pending, borderColor: '#ca8a04', backgroundColor: 'rgba(202, 138, 4, 0.12)', fill: true, tension: 0.4 },
      { label: 'Cancelled', data: cancelled, borderColor: '#dc2626', backgroundColor: 'rgba(220, 38, 38, 0.08)', fill: true, tension: 0.4 },
    ],
  }
})

const lineChartOptions = {
  responsive: true,
  maintainAspectRatio: false,
  plugins: {
    legend: {
      display: true,
      position: 'top' as const,
    },
    tooltip: {
      mode: 'index' as const,
      intersect: false,
    },
  },
  scales: {
    y: {
      beginAtZero: true,
      grid: {
        color: 'rgba(0, 0, 0, 0.05)',
      }
    },
    x: {
      grid: {
        display: false,
      }
    }
  }
}

/** Most rented car types: join rental records with vehicles to get carType, then count */
const CAR_TYPE_ORDER = ['Sedan', 'SUV', 'MPV', 'Hatchback', 'Van', 'Coupe', 'Convertible', 'Pickup']
const mostRentedCarTypes = computed(() => {
  const list = rentalRecords.value.filter(r => !r.archived)
  const vehicleList = vehicles.value
  const byType: Record<string, number> = {}
  CAR_TYPE_ORDER.forEach(t => { byType[t] = 0 })
  list.forEach(r => {
    const v = vehicleList.find(v => v.name === r.vehicleName)
    const type = (v?.carType ?? v?.type ?? 'Sedan') as string
    const key = type === 'Car' ? 'Sedan' : type
    if (CAR_TYPE_ORDER.includes(key)) byType[key] = (byType[key] ?? 0) + 1
    else byType['Sedan'] = (byType['Sedan'] ?? 0) + 1
  })
  const total = list.length || 1
  return CAR_TYPE_ORDER.map(type => ({
    type,
    count: byType[type] ?? 0,
    percent: Math.round(((byType[type] ?? 0) / total) * 100),
  }))
})

</script>

<style scoped>
.car-types-list {
  display: flex;
  flex-direction: column;
  gap: 0.5rem;
}

/* Horizontal bar chart: Most Rented Car Types */
.car-types-bar-chart .car-type-row {
  display: grid;
  grid-template-columns: minmax(90px, auto) 1fr minmax(4rem, auto);
  align-items: center;
  gap: 0.75rem;
  font-size: 0.875rem;
}
.car-types-bar-chart .car-type-name {
  font-weight: 600;
  color: var(--text-primary, #0f172a);
}
.car-type-bar-track {
  height: 24px;
  min-width: 0;
  background: var(--surface-2, #e2e8f0);
  border-radius: 12px;
  overflow: hidden;
}
.car-type-bar-fill {
  height: 100%;
  min-width: 0;
  border-radius: 12px;
  background: linear-gradient(90deg, var(--role-primary) 0%, var(--role-primary-dark) 100%);
  box-shadow: 0 1px 3px rgba(30, 58, 95, 0.25);
  transition: width 0.35s ease;
}
.car-types-bar-chart .car-type-meta {
  display: flex;
  align-items: center;
  justify-content: flex-end;
  gap: 0.5rem;
  min-width: 4rem;
}
.car-types-bar-chart .car-type-count {
  font-weight: 600;
  color: var(--text-primary, #0f172a);
}
.car-types-bar-chart .car-type-pct {
  color: var(--text-secondary, #64748b);
  font-size: 0.8125rem;
}

.car-type-row {
  display: flex;
  align-items: center;
  justify-content: space-between;
  font-size: var(--text-body, 0.9375rem);
}
.car-type-name {
  font-weight: 500;
  color: var(--text-primary, #0f172a);
}
.car-type-count,
.car-type-pct {
  color: var(--text-secondary, #64748b);
}
.car-type-pct {
  min-width: 2.5rem;
  text-align: right;
}

/* Same Promos & offers container size on client and car owner */
.dashboard-promos-paired-row .dashboard-promos-col {
  align-self: stretch;
}
.dashboard-promos-paired-row .dashboard-promos-col .promos-offers-box {
  width: 100%;
}
.dashboard-promos-paired-row .dashboard-promos-col--tall,
.dashboard-promos-paired-row .dashboard-handoffs-col {
  min-height: 320px;
}

.dashboard-promos-vehicles-row .v-col {
  align-items: stretch;
}
.dashboard-promos-vehicles-row .modern-card {
  display: flex;
  flex-direction: column;
  min-height: 0;
}

/* Same-size section titles and headers for Promos & offers and Plan your next gala now */
.dashboard-promos-vehicles-row .section-card-header,
.dashboard-promos-vehicles-row :deep(.section-card-header) {
  padding: 1rem 1.25rem;
}
.dashboard-promos-vehicles-row .section-card-title,
.dashboard-promos-vehicles-row :deep(.section-card-title) {
  font-size: var(--text-base, 1.0625rem);
  font-weight: 600;
  line-height: 1.3;
}

.dashboard-promos-grid {
  display: grid;
  grid-template-columns: repeat(auto-fill, minmax(260px, 1fr));
  gap: 1rem;
}
.dashboard-promos-grid--compact {
  grid-template-columns: 1fr;
  gap: 0.75rem;
}
.dashboard-promos-grid--compact .dashboard-promo-card__img {
  height: 160px;
  min-height: 120px;
}
.dashboard-promo-card {
  display: flex;
  flex-direction: column;
  border-radius: 12px;
  overflow: hidden;
  background: var(--surface-2, #e2e8f0);
  text-decoration: none;
  color: inherit;
  transition: box-shadow 0.2s ease, transform 0.2s ease;
  min-height: 0;
  max-width: 100%;
}
.dashboard-promo-card--link:hover {
  box-shadow: 0 4px 16px rgba(0, 0, 0, 0.12);
  transform: translateY(-2px);
}
/* Image: fill container with cover so any size image scales and fills the area */
.dashboard-promo-card__img {
  width: 100%;
  max-width: 100%;
  flex: none;
  height: 160px;
  min-height: 120px;
  display: block;
  position: relative;
  overflow: hidden;
  border-radius: 12px 12px 0 0;
  background: var(--surface-2, #e2e8f0);
}
.dashboard-promo-card__img :deep(.v-img) {
  position: absolute;
  inset: 0;
  width: 100%;
  height: 100%;
}
.dashboard-promo-card__img :deep(.v-img__img),
.dashboard-promo-card__img :deep(img) {
  width: 100%;
  height: 100%;
  object-fit: cover;
  object-position: center;
}
.dashboard-promo-card__title {
  flex-shrink: 0;
  padding: 0.5rem 0.75rem;
  font-size: var(--text-body, 0.9375rem);
  font-weight: 600;
  color: var(--text-primary, #0f172a);
}
/* Car owner: Promos card is content-height only (no stretch) so no big white padding below image */
.dashboard-promos-handoffs-row .v-col:last-child .v-card {
  display: flex;
  flex-direction: column;
  min-height: 0;
  flex-grow: 1;
}
.dashboard-promos-handoffs-row .v-col:last-child .v-card-text {
  flex: 1 1 auto;
  min-height: 0;
}
.dashboard-promos-row .v-card-text {
  padding-top: 0.75rem;
  padding-bottom: 0.75rem;
  padding-left: 1rem;
  padding-right: 1rem;
}
.dashboard-vehicles-grid {
  display: grid;
  grid-template-columns: repeat(auto-fill, minmax(200px, 1fr));
  gap: 0.75rem;
}
.dashboard-vehicles-grid--two-col {
  grid-template-columns: repeat(2, 1fr);
}

.car-owner-quick-actions-grid {
  display: flex;
  flex-direction: column;
  gap: 0.5rem;
}
.car-owner-quick-actions-card .quick-action-btn {
  text-transform: none;
  justify-content: flex-start;
}

.dashboard-vehicles-grid--compact-car {
  grid-template-columns: repeat(auto-fill, minmax(140px, 1fr));
  gap: 0.75rem;
}

.dashboard-vehicle-minicard {
  display: flex;
  flex-direction: column;
  border-radius: var(--radius-md, 12px);
  overflow: hidden;
  background: var(--surface-2, #f1f5f9);
  text-decoration: none;
  color: inherit;
  transition: box-shadow 0.2s ease, transform 0.2s ease;
}

.dashboard-vehicle-minicard:hover {
  box-shadow: 0 4px 12px rgba(0, 0, 0, 0.1);
  transform: translateY(-2px);
}

.dashboard-vehicle-minicard__img {
  height: 72px;
  min-height: 72px;
  background: var(--surface-3, #e2e8f0);
}

.dashboard-vehicle-minicard__img :deep(.v-img),
.dashboard-vehicle-minicard__img :deep(img) {
  height: 100%;
  object-fit: cover;
}

.dashboard-vehicle-minicard__meta {
  padding: 0.5rem 0.75rem;
  display: flex;
  flex-direction: column;
  gap: 0.125rem;
}

.dashboard-vehicle-minicard__name {
  font-size: var(--text-sm, 0.8125rem);
  font-weight: 600;
  color: var(--text-primary, #1f2937);
  overflow: hidden;
  text-overflow: ellipsis;
  white-space: nowrap;
}

.dashboard-vehicle-minicard__type {
  font-size: var(--text-xs, 0.75rem);
  color: var(--text-secondary, #64748b);
}

.dashboard-vehicle-minicard__price {
  font-size: var(--text-xs, 0.75rem);
  font-weight: 600;
  color: var(--role-primary, #1e3a5f);
  margin-top: 0.125rem;
}

.earnings-preview {
  display: flex;
  flex-direction: column;
  gap: 0.5rem;
}
.earnings-preview__amount {
  font-size: var(--text-2xl, 1.75rem);
  font-weight: 700;
  color: var(--text-primary, #0f172a);
  font-variant-numeric: tabular-nums;
  letter-spacing: -0.02em;
}
.earnings-preview__link {
  font-size: var(--text-sm, 0.875rem);
  font-weight: 500;
  color: var(--role-primary, #1e3a5f);
  text-decoration: none;
  transition: color 0.15s ease;
}
.earnings-preview__link:hover {
  color: var(--role-primary-dark, #0f2744);
  text-decoration: underline;
}
.earnings-card .section-card-header--compact {
  padding: 0.75rem 1rem;
}
.earnings-card .section-card-header--compact .section-card-icon {
  display: none;
}
.dashboard-vehicle-card {
  text-decoration: none;
  color: inherit;
  transition: box-shadow 0.2s ease, transform 0.2s ease;
}
.dashboard-vehicle-card:hover {
  box-shadow: 0 4px 16px rgba(0, 0, 0, 0.1);
  transform: translateY(-2px);
}
.dashboard-vehicle-card__img {
  border-radius: 12px 12px 0 0;
  height: 96px;
  min-height: 72px;
}
.dashboard-vehicle-card__img :deep(.v-img),
.dashboard-vehicle-card__img :deep(img) {
  height: 100%;
  object-fit: cover;
}

.admin-promos-preview {
  display: flex;
  flex-wrap: wrap;
  gap: 1rem;
}
.admin-promos-preview__item {
  display: flex;
  align-items: center;
  gap: 0.75rem;
  padding: 0.5rem;
  border-radius: 8px;
  background: var(--surface-2, #f1f5f9);
}
.admin-promos-preview__img {
  border-radius: 6px;
  flex-shrink: 0;
}
.admin-promos-preview__meta {
  display: flex;
  flex-direction: column;
  min-width: 0;
}
.admin-promos-preview__title {
  font-size: var(--text-body, 0.9375rem);
  font-weight: 600;
  color: var(--text-primary, #0f172a);
  overflow: hidden;
  text-overflow: ellipsis;
  white-space: nowrap;
}

.section-card-header--with-actions {
  padding: 1rem 1.25rem;
}

.recent-bookings-header {
  gap: 1rem;
}

.chart-height {
  min-height: 260px;
  height: 260px;
}

.dashboard-mode-toggle :deep(.v-btn) {
  font-weight: 500;
  font-size: var(--text-body);
}

.dashboard-twin-card {
  min-height: 0;
}

.dashboard-twin-card__body {
  flex: 1 1 0;
  min-height: 280px;
  min-width: 0;
  overflow: hidden;
}

.dashboard-divider {
  border-color: rgba(30, 58, 95, 0.08);
}

.dashboard-link-btn {
  font-weight: 600;
  text-transform: none;
  letter-spacing: 0.01em;
}

/* Recent Activity */
.activity-list {
  padding: 0.75rem 0;
}

.activity-item {
  display: flex;
  align-items: flex-start;
  gap: 1rem;
  padding: 1.25rem 1.5rem;
  transition: background 0.2s ease;
  border-bottom: 1px solid rgba(30, 58, 95, 0.06);
}

.activity-item:last-child {
  border-bottom: none;
}

.activity-item:hover {
  background: rgba(30, 58, 95, 0.04);
}

.activity-item__icon {
  flex-shrink: 0;
  width: 40px;
  height: 40px;
  border-radius: 12px;
  display: flex;
  align-items: center;
  justify-content: center;
  color: #fff;
}

.activity-item__icon--success {
  background: linear-gradient(135deg, #059669 0%, #10b981 100%);
  box-shadow: 0 2px 8px rgba(5, 150, 105, 0.3);
}

.activity-item__icon--primary {
  background: linear-gradient(135deg, var(--role-primary) 0%, var(--role-primary-dark) 100%);
  box-shadow: 0 2px 8px rgba(30, 58, 95, 0.3);
}

.activity-item__icon--action,
.activity-item__icon--info {
  background: linear-gradient(135deg, var(--metallic-shadow) 0%, var(--metallic-dark) 100%);
  box-shadow: 0 2px 8px rgba(71, 85, 105, 0.25);
}

.activity-item__inner {
  width: 100%;
  min-width: 0;
  gap: 1.5rem;
}

.activity-item__body {
  flex: 1;
  min-width: 0;
}

.activity-item__title {
  font-size: var(--text-body-lg);
  font-weight: 600;
  color: var(--text-primary);
  margin-bottom: 6px;
  letter-spacing: 0.01em;
  line-height: 1.35;
}

.activity-item__desc {
  font-size: var(--text-body);
  color: var(--text-secondary);
  line-height: 1.5;
  margin-bottom: 0;
}

.activity-item__time {
  font-size: var(--text-sm);
  color: var(--text-muted);
  font-weight: 500;
}

/* Upcoming Shifts */
.shifts-list {
  padding: 0.5rem 0;
}

.shift-item {
  display: flex;
  align-items: center;
  gap: 14px;
  padding: 14px 1.25rem;
  transition: background 0.2s ease;
  border-bottom: 1px solid rgba(30, 58, 95, 0.06);
}

.shift-item:last-child {
  border-bottom: none;
}

.shift-item:hover {
  background: rgba(30, 58, 95, 0.04);
}

.shift-item__avatar {
  flex-shrink: 0;
  border: 2px solid rgba(30, 58, 95, 0.15);
}

.shift-item__body {
  flex: 1;
  min-width: 0;
}

.shift-item__staff {
  font-size: var(--text-body-lg);
  font-weight: 600;
  color: var(--text-primary);
  margin-bottom: 2px;
  letter-spacing: 0.01em;
}

.shift-item__meta {
  font-size: var(--text-body);
  color: var(--text-secondary);
  line-height: 1.4;
}

.shift-item__chip {
  flex-shrink: 0;
  font-weight: 600;
  font-size: var(--text-xs);
  letter-spacing: 0.03em;
  text-transform: uppercase;
}

.shift-item__chip--completed {
  background: #166534 !important;
  color: #fff !important;
}

.shift-item__chip--scheduled {
  background: #ea580c !important;
  color: #fff !important;
}

.shift-item__chip--pending {
  background: #ca8a04 !important;
  color: #1c1917 !important;
}

.shift-item__chip--cancelled {
  background: #dc2626 !important;
  color: #fff !important;
}

.shift-item__chip--booked {
  background: #1e40af !important;
  color: #fff !important;
}

.shift-item__chip--invoiced {
  background: #0d9488 !important;
  color: #fff !important;
}
</style>
