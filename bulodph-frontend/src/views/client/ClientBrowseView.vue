<template>
  <DashboardTemplate title="Browse rides" subtitle="Cars for family trips, outings, and everyday errands—throughout the region." :animate="true">
    <LiabilityDisclaimerBanner dismiss-key="client-browse-liability-dismissed" />
    <div class="mb-3">
      <v-btn
        variant="tonal"
        color="primary"
        size="small"
        rounded="lg"
        prepend-icon="mdi-storefront"
        :to="{ name: 'client-browse-rentals' }"
      >
        Browse by car rental company
      </v-btn>
    </div>
    <div class="browse-filters-wrap mb-4">
      <div class="d-flex align-center flex-wrap gap-3 mb-3">
        <v-btn
          variant="outlined"
          size="small"
          rounded="lg"
          :prepend-icon="showFilters ? 'mdi-chevron-up' : 'mdi-filter'"
          :color="showFilters ? 'primary' : undefined"
          class="filters-toggle-btn"
          aria-label="Toggle filters"
          @click="showFilters = !showFilters"
        >
          {{ showFilters ? 'Hide filters' : 'Filters' }}
        </v-btn>
        <v-text-field
          v-model="search"
          placeholder="Search by location or vehicle..."
          prepend-inner-icon="mdi-magnify"
          variant="outlined"
          density="comfortable"
          hide-details
          clearable
          rounded="lg"
          class="browse-search-inline max-w-320"
        />
        <v-select
          v-model="sortBy"
          :items="sortOptions"
          item-title="label"
          item-value="value"
          label="Sort by"
          variant="outlined"
          density="comfortable"
          hide-details
          rounded="lg"
          class="browse-sort-inline max-w-200"
        />
      </div>
      <v-expand-transition>
        <v-row v-show="showFilters" class="browse-filters">
      <v-col cols="12" md="3">
        <v-select
          v-model="location"
          :items="locations"
          label="Location"
          variant="outlined"
          density="comfortable"
          hide-details
          rounded="lg"
        />
      </v-col>
      <v-col cols="6" md="2">
        <v-select
          v-model="vehicleType"
          :items="['All', 'Car']"
          label="Type"
          variant="outlined"
          density="comfortable"
          hide-details
          rounded="lg"
        />
      </v-col>
      <v-col cols="6" md="2">
        <v-select
          v-model="carType"
          :items="carTypeOptions"
          label="Car type"
          variant="outlined"
          density="comfortable"
          hide-details
          rounded="lg"
        />
      </v-col>
      <v-col cols="6" md="2">
        <v-select
          v-model="seats"
          :items="seatsOptions"
          label="Seats"
          variant="outlined"
          density="comfortable"
          hide-details
          rounded="lg"
        />
      </v-col>
      <v-col cols="6" md="2">
        <v-select
          v-model="transmission"
          :items="transmissionOptions"
          label="Transmission"
          variant="outlined"
          density="comfortable"
          hide-details
          rounded="lg"
        />
      </v-col>
      <v-col cols="6" md="2">
        <v-select
          v-model="priceMin"
          :items="priceMinOptions"
          item-title="label"
          item-value="value"
          label="Min price/day"
          variant="outlined"
          density="comfortable"
          hide-details
          rounded="lg"
        />
      </v-col>
      <v-col cols="6" md="2">
        <v-select
          v-model="priceMax"
          :items="priceMaxOptions"
          item-title="label"
          item-value="value"
          label="Max price/day"
          variant="outlined"
          density="comfortable"
          hide-details
          rounded="lg"
        />
      </v-col>
      <v-col cols="6" md="2">
        <v-select
          v-model="rentalMode"
          :items="rentalModeFilterOptions"
          item-title="label"
          item-value="value"
          label="Rental mode"
          variant="outlined"
          density="comfortable"
          hide-details
          rounded="lg"
        />
      </v-col>
      <v-col cols="6" md="2">
        <v-select
          v-model="minDurationHours"
          :items="minDurationFilterOptions"
          item-title="label"
          item-value="value"
          label="Min duration"
          variant="outlined"
          density="comfortable"
          hide-details
          rounded="lg"
        />
      </v-col>
      <v-col cols="12" md="1" class="d-flex align-center">
        <v-btn
            variant="outlined"
            size="small"
            rounded="lg"
            prepend-icon="mdi-filter-off"
            class="reset-filters-btn"
            aria-label="Reset filters"
            @click="resetBrowseFilters"
          >
            Reset
          </v-btn>
      </v-col>
    </v-row>
      </v-expand-transition>
    </div>

    <p v-if="!vehiclesLoading && sortedVehicles.length" class="text-body-2 text-medium-emphasis mb-3">
      {{ sortedVehicles.length }} vehicle{{ sortedVehicles.length === 1 ? '' : 's' }} found
    </p>

    <v-row v-if="vehiclesLoading">
      <v-col v-for="i in 8" :key="i" cols="12" sm="6" md="4" lg="3">
        <HpaSkeletonLoader :loading="true" type="card-grid" :count="1" />
      </v-col>
    </v-row>
    <v-row v-else class="animate-stagger">
      <v-col
        v-for="vehicle in paginatedVehicles"
        :key="vehicle.id"
        cols="12"
        sm="6"
        md="4"
        lg="3"
      >
        <v-card elevation="0" rounded="lg" class="modern-card vehicle-card" hover>
          <div class="vehicle-card__image">
            <v-img
              :src="vehicle.image"
              :alt="vehicle.name"
              cover
              class="vehicle-card__img"
              gradient="to bottom, rgba(0,0,0,0) 60%, rgba(0,0,0,0.4) 100%"
            />
            <div v-if="rentalName(vehicle)" class="vehicle-card__watermark">{{ rentalName(vehicle) }}</div>
            <RouterLink
              v-if="rentalName(vehicle)"
              :to="{ name: 'client-rental-detail', params: { id: rentalSlug(vehicle) } }"
              class="vehicle-card__rental-badge"
              @click.stop
            >
              <VehicleRentalBadge :rental-name="rentalName(vehicle)" :logo-url="rentalLogoUrl(vehicle)" :size="56" />
            </RouterLink>
            <span class="vehicle-card__type">{{ vehicle.type }}</span>
            <span class="vehicle-card__location">
              <v-icon size="14">mdi-map-marker</v-icon>
              {{ vehicle.location }}
            </span>
            <v-tooltip location="top">
              <template #activator="{ props: tooltipProps }">
                <v-btn
                  v-bind="tooltipProps"
                  :icon="favoritesStore.has(vehicle.id) ? 'mdi-heart' : 'mdi-heart-outline'"
                  size="small"
                  :class="['vehicle-card__fav', { 'vehicle-card__fav--outline': !favoritesStore.has(vehicle.id) }]"
                  :color="favoritesStore.has(vehicle.id) ? 'error' : undefined"
                  :variant="favoritesStore.has(vehicle.id) ? 'flat' : 'tonal'"
                  :aria-label="favoritesStore.has(vehicle.id) ? 'Remove from favorites' : 'Add to favorites'"
                  @click.prevent="favoritesStore.toggle(vehicle.id)"
                />
              </template>
              {{ favoritesStore.has(vehicle.id) ? 'Remove from favorites' : 'Add to favorites' }}
            </v-tooltip>
          </div>
          <v-card-text class="pa-4">
            <div class="d-flex flex-wrap gap-2 mb-2 vehicle-card__badges">
              <v-chip v-if="vehicle.verified" size="x-small" color="success" variant="tonal" prepend-icon="mdi-shield-check">Verified</v-chip>
              <v-chip v-if="vehicle.hasPermit" size="x-small" color="info" variant="tonal" prepend-icon="mdi-file-document-check">Has Permit</v-chip>
              <v-chip v-if="vehicle.featured" size="x-small" color="primary" variant="tonal" prepend-icon="mdi-star">Featured</v-chip>
              <v-chip v-if="vehicle.rentalMode" size="x-small" variant="tonal" color="secondary" prepend-icon="mdi-car-key">{{ rentalModeLabel(vehicle.rentalMode) }}</v-chip>
              <v-chip v-if="minRentalChipText(vehicle.minRentalPeriodHours)" size="x-small" variant="tonal" color="secondary">{{ minRentalChipText(vehicle.minRentalPeriodHours) }}</v-chip>
            </div>
            <h3 class="text-h6 font-weight-bold mb-3">{{ vehicle.name }}</h3>
            <div v-if="vehicle.tags?.length" class="d-flex flex-wrap gap-2 mb-3">
              <v-chip
                v-for="tag in vehicle.tags"
                :key="tag"
                size="x-small"
                variant="tonal"
                color="primary"
                class="vehicle-card__tag"
              >
                {{ tag }}
              </v-chip>
            </div>
            <div class="browse-card__price-actions">
              <PriceDisplay
                :price-per-day="vehicle.pricePerDay"
                :original-price-per-day="vehicle.originalPricePerDay"
                :promo-label="vehicle.originalPricePerDay ? undefined : '10% on 3+ day booking'"
                variant="card"
              />
              <div class="d-flex gap-4 flex-wrap browse-card__btns">
                <v-btn
                  variant="outlined"
                  color="primary"
                  size="small"
                  rounded="lg"
                  prepend-icon="mdi-eye"
                  :to="{ name: 'client-vehicle-detail', params: { id: vehicle.id } }"
                >
                  View details
                </v-btn>
                <v-btn
                  color="primary"
                  variant="flat"
                  size="small"
                  rounded="lg"
                  prepend-icon="mdi-calendar-plus"
                  :to="{ name: 'client-booking-new', query: { vehicleId: vehicle.id } }"
                >
                  Book now
                </v-btn>
              </div>
            </div>
          </v-card-text>
        </v-card>
      </v-col>
    </v-row>

    <v-pagination
      v-if="!vehiclesLoading && totalPages > 1"
      v-model="currentPage"
      :length="totalPages"
      :total-visible="7"
      density="comfortable"
      rounded="lg"
      class="mt-4"
    />

    <v-card v-if="!vehiclesLoading && !sortedVehicles.length" elevation="0" rounded="lg" class="modern-card">
      <v-card-text class="pa-4">
        <HpaEmptyState
          :title="hasActiveFilters ? 'No vehicles match' : 'No vehicles yet'"
          :description="hasActiveFilters ? 'No vehicles match your filters. Try clearing filters or browse car rental companies.' : 'Vehicles will appear here once listed by rental companies.'"
          icon="mdi-car-search"
          :action-text="hasActiveFilters ? 'Clear filters' : 'Browse car rentals'"
          :action-icon="hasActiveFilters ? 'mdi-filter-off' : 'mdi-storefront'"
          @action="handleEmptyAction"
        />
      </v-card-text>
    </v-card>
  </DashboardTemplate>
</template>

<script setup lang="ts">
import { ref, computed, onMounted, watch } from 'vue'
import { useRouter } from 'vue-router'
import DashboardTemplate from '@/components/DashboardTemplate.vue'
import LiabilityDisclaimerBanner from '@/components/LiabilityDisclaimerBanner.vue'
import HpaEmptyState from '@/components/base/HpaEmptyState.vue'
import HpaSkeletonLoader from '@/components/base/HpaSkeletonLoader.vue'
import PriceDisplay from '@/components/PriceDisplay.vue'
import VehicleRentalBadge from '@/components/VehicleRentalBadge.vue'
import { slugify } from '@/utils/slugify'
import { rentalModeLabel, minRentalChipText } from '@/constants/vehicleSeed'
import { useVehicles } from '@/composables/useVehicles'
import { useCarRentalProfiles } from '@/composables/useCarRentalProfiles'
import { useFavoritesStore } from '@/stores/favorites'

const router = useRouter()
const { approvedVehicles, loading: vehiclesLoading, fetchFromApi } = useVehicles()
const { rentals, fetchRentals } = useCarRentalProfiles()
const favoritesStore = useFavoritesStore()

onMounted(() => {
  fetchFromApi()
  fetchRentals()
})

const showFilters = ref(false)
const search = ref('')
const vehicleType = ref('All')
const location = ref('All')
const carType = ref('All')
const seats = ref('All')
const transmission = ref('All')
const priceMin = ref<number | null>(null)
const priceMax = ref<number | null>(null)
const rentalMode = ref<string>('All')
const minDurationHours = ref<number | null>(null)

const locations = computed(() => {
  const locs = new Set(vehicles.value.map(v => v.location).filter(Boolean))
  return ['All', ...Array.from(locs).sort()]
})

const carTypeOptions = ['All', 'Sedan', 'SUV', 'MPV', 'Hatchback', 'Van']
const seatsOptions = ['All', '2+', '4+', '5+', '7+', '12+']
const transmissionOptions = ['All', 'Automatic', 'Manual']

const priceMinOptions = [
  { label: 'Any', value: null as number | null },
  { label: '₱500', value: 500 },
  { label: '₱1,000', value: 1000 },
  { label: '₱2,000', value: 2000 },
  { label: '₱3,000', value: 3000 },
  { label: '₱5,000', value: 5000 },
  { label: '₱10,000', value: 10000 },
]
const priceMaxOptions = [
  { label: 'Any', value: null as number | null },
  { label: '₱1,000', value: 1000 },
  { label: '₱2,000', value: 2000 },
  { label: '₱3,000', value: 3000 },
  { label: '₱5,000', value: 5000 },
  { label: '₱10,000', value: 10000 },
  { label: '₱10,000+', value: 99999 },
]

const rentalModeFilterOptions = [
  { label: 'Any', value: 'All' },
  { label: 'Driver only', value: 'driver_only' },
  { label: 'Self-drive', value: 'self_drive_only' },
  { label: 'Both', value: 'both' },
]
const minDurationFilterOptions = [
  { label: 'Any', value: null as number | null },
  { label: '12h+', value: 12 },
  { label: '24h+', value: 24 },
  { label: '36h+', value: 36 },
  { label: '48h+', value: 48 },
]

const vehicles = approvedVehicles

const sortOptions = [
  { label: 'Newest first', value: 'newest' },
  { label: 'Price: low to high', value: 'price_asc' },
  { label: 'Price: high to low', value: 'price_desc' },
]
const sortBy = ref('newest')

const filteredVehicles = computed(() => {
  let list = vehicles.value
  if (search.value) {
    const q = search.value.toLowerCase()
    list = list.filter(v => v.name.toLowerCase().includes(q) || (v.location && v.location.toLowerCase().includes(q)) || v.type.toLowerCase().includes(q))
  }
  if (vehicleType.value !== 'All') list = list.filter(v => v.type === vehicleType.value)
  if (location.value !== 'All') list = list.filter(v => v.location === location.value)
  if (carType.value !== 'All') list = list.filter(v => (v.carType ?? v.type) === carType.value)
  if (seats.value !== 'All') {
    const minSeats = parseInt(seats.value.replace('+', ''), 10)
    list = list.filter(v => (v.capacity ?? 0) >= minSeats)
  }
  if (transmission.value !== 'All') list = list.filter(v => v.transmission === transmission.value)
  if (priceMin.value != null && priceMin.value > 0) list = list.filter(v => v.pricePerDay >= priceMin.value!)
  if (priceMax.value != null && priceMax.value > 0 && priceMax.value < 99999) list = list.filter(v => v.pricePerDay <= priceMax.value!)
  if (rentalMode.value !== 'All') list = list.filter(v => (v.rentalMode ?? 'both') === rentalMode.value)
  if (minDurationHours.value != null) list = list.filter(v => v.minRentalPeriodHours == null || v.minRentalPeriodHours <= minDurationHours.value!)
  return list
})

const sortedVehicles = computed(() => {
  const list = [...filteredVehicles.value]
  if (sortBy.value === 'price_asc') list.sort((a, b) => a.pricePerDay - b.pricePerDay)
  else if (sortBy.value === 'price_desc') list.sort((a, b) => b.pricePerDay - a.pricePerDay)
  else list.sort((a, b) => (b.createdAt ?? '').localeCompare(a.createdAt ?? ''))
  return list
})

const ITEMS_PER_PAGE = 12
const currentPage = ref(1)
const totalPages = computed(() => Math.max(1, Math.ceil(sortedVehicles.value.length / ITEMS_PER_PAGE)))
const paginatedVehicles = computed(() => {
  const list = sortedVehicles.value
  const start = (currentPage.value - 1) * ITEMS_PER_PAGE
  return list.slice(start, start + ITEMS_PER_PAGE)
})

watch(
  [search, sortBy, location, vehicleType, carType, seats, transmission, priceMin, priceMax, rentalMode, minDurationHours],
  () => { currentPage.value = 1 }
)

function rentalName(vehicle: { businessName?: string; business_name?: string; hostName?: string; host_name?: string }) {
  const name = (vehicle.businessName ?? vehicle.business_name ?? vehicle.hostName ?? vehicle.host_name ?? '').trim()
  return name || undefined
}

function rentalSlug(vehicle: { businessName?: string; hostName?: string }) {
  const name = rentalName(vehicle)
  return name ? slugify(name) : ''
}

/** Normalize name for matching (lowercase, collapse "rental" so "Demo Car rental owner" matches "Demo Car Owner"). */
function normRentalName(name: string): string {
  return name
    .replace(/\s*rental\s*/gi, ' ')
    .replace(/\s+/g, ' ')
    .trim()
    .toLowerCase()
}

/** Logo URL for this vehicle's rental (from API profiles so e.g. Demo Car Owner shows real logo). */
function rentalLogoUrl(vehicle: { businessName?: string; business_name?: string; hostName?: string; host_name?: string }): string | undefined {
  const name = rentalName(vehicle)
  if (!name) return undefined
  const norm = normRentalName(name)
  const r = rentals.value.find(rental => {
    const rn = normRentalName(rental.businessName ?? (rental as { business_name?: string }).business_name ?? '')
    if (!rn) return false
    if (rn === norm) return true
    if (norm.includes(rn) || rn.includes(norm)) return true
    return false
  })
  const url = r?.logoUrl ?? (r as { logo_url?: string })?.logo_url
  return typeof url === 'string' && url.trim() ? url.trim() : undefined
}

const hasActiveFilters = computed(() =>
  !!search.value ||
  location.value !== 'All' ||
  vehicleType.value !== 'All' ||
  carType.value !== 'All' ||
  seats.value !== 'All' ||
  transmission.value !== 'All' ||
  priceMin.value != null ||
  (priceMax.value != null && priceMax.value < 99999) ||
  rentalMode.value !== 'All' ||
  minDurationHours.value != null
)

function handleEmptyAction() {
  if (hasActiveFilters.value) {
    resetBrowseFilters()
  } else {
    router.push({ name: 'client-browse-rentals' })
  }
}

function resetBrowseFilters() {
  location.value = 'All'
  vehicleType.value = 'All'
  carType.value = 'All'
  seats.value = 'All'
  transmission.value = 'All'
  priceMin.value = null
  priceMax.value = null
  rentalMode.value = 'All'
  minDurationHours.value = null
}
</script>

<style scoped>
.vehicle-card__image {
  position: relative;
  overflow: hidden;
  border-radius: 12px 12px 0 0;
  aspect-ratio: 4/3;
  min-height: 140px;
}
.vehicle-card__image .vehicle-card__img,
.vehicle-card__image :deep(.v-img) {
  position: absolute;
  inset: 0;
  width: 100%;
  height: 100%;
}
.vehicle-card__type {
  position: absolute;
  top: 12px;
  left: 12px;
  background: rgba(0,0,0,0.6);
  color: #fff;
  font-size: 0.6875rem;
  font-weight: 700;
  text-transform: uppercase;
  padding: 4px 8px;
  border-radius: 6px;
}
.vehicle-card__location {
  position: absolute;
  bottom: 12px;
  left: 12px;
  color: #fff;
  font-size: 0.8125rem;
  display: flex;
  align-items: center;
  gap: 4px;
}
.vehicle-card__fav {
  position: absolute;
  bottom: 8px;
  right: 8px;
}
.vehicle-card__fav--outline :deep(.v-icon) {
  color: rgb(255, 255, 255) !important;
}

.vehicle-card__rental-badge {
  position: absolute;
  top: 8px;
  right: 8px;
  z-index: 2;
}

.vehicle-card__badges {
  min-height: 24px;
}

.browse-card__price-actions {
  display: flex;
  align-items: flex-start;
  justify-content: space-between;
  flex-wrap: wrap;
  gap: 16px 20px;
  margin-top: 4px;
}
.browse-card__btns {
  flex-shrink: 0;
  gap: 14px !important;
}
.vehicle-card__watermark {
  position: absolute;
  bottom: 50%;
  left: 50%;
  transform: translate(-50%, 50%) rotate(-25deg);
  font-size: 1.25rem;
  font-weight: 800;
  color: rgba(255, 255, 255, 0.35);
  text-shadow: 0 1px 3px rgba(0, 0, 0, 0.5), 0 0 1px rgba(0, 0, 0, 0.8);
  white-space: nowrap;
  pointer-events: none;
  z-index: 1;
  letter-spacing: 0.03em;
}
</style>
