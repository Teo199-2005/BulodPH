<template>
    <DashboardTemplate title="Listings" subtitle="Car rental company submissions. Approve or feature listings for the website." :animate="true">
    <v-row class="mb-4">
      <v-col cols="6" sm="6" lg="3">
        <HpaDashboardWidget role="admin" :loading="false" title="Total" :value="listings.length" icon="mdi-format-list-bulleted" trend="neutral" trend-value="—" trend-label="listings" />
      </v-col>
      <v-col cols="6" sm="6" lg="3">
        <HpaDashboardWidget role="admin" :loading="false" title="Approved" :value="listingStats.approved" icon="mdi-check-circle" trend="neutral" :trend-value="String(listingStats.approved)" trend-label="approved" />
      </v-col>
      <v-col cols="6" sm="6" lg="3">
        <HpaDashboardWidget role="admin" :loading="false" title="Pending" :value="listingStats.pending" icon="mdi-clock-outline" trend="neutral" :trend-value="String(listingStats.pending)" trend-label="pending" />
      </v-col>
      <v-col cols="6" sm="6" lg="3">
        <HpaDashboardWidget role="admin" :loading="false" title="Featured" :value="listingStats.featured" icon="mdi-star" trend="neutral" :trend-value="String(listingStats.featured)" trend-label="featured" />
      </v-col>
    </v-row>
    <div class="d-flex flex-wrap align-center gap-3 mb-4">
      <v-text-field
        v-model="search"
        placeholder="Search by vehicle name or owner..."
        variant="outlined"
        density="comfortable"
        hide-details
        prepend-inner-icon="mdi-magnify"
        class="listings-search"
        clearable
        rounded="lg"
      />
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
      <v-expand-transition>
        <div v-show="showFilters" class="d-flex flex-wrap align-center gap-3 w-100 list-filters-expanded">
          <v-select
            v-model="filters.status"
            :items="statusFilterOptions"
            label="Status"
            variant="outlined"
            density="compact"
            hide-details
            rounded="lg"
            class="filter-select"
            style="min-width: 140px;"
          />
          <v-select
            v-model="filters.type"
            :items="typeFilterOptions"
            label="Type"
            variant="outlined"
            density="compact"
            hide-details
            rounded="lg"
            class="filter-select"
            style="min-width: 140px;"
          />
          <v-select
            v-model="filters.location"
            :items="locationFilterOptions"
            label="Location"
            variant="outlined"
            density="compact"
            hide-details
            rounded="lg"
            class="filter-select"
            style="min-width: 160px;"
          />
          <v-btn
            variant="outlined"
            size="small"
            rounded="lg"
            prepend-icon="mdi-filter-off"
            class="reset-filters-btn"
            aria-label="Reset filters"
            @click="resetFilters"
          >
            Reset
          </v-btn>
        </div>
      </v-expand-transition>
      <v-select
        v-model="sortBy"
        :items="sortOptions"
        label="Sort by"
        variant="outlined"
        density="compact"
        hide-details
        rounded="lg"
        class="sort-select"
        style="min-width: 160px;"
      />
    </div>
    <div ref="listingsListRef" class="admin-listings-stagger">
    <v-row>
      <v-col
        v-for="v in paginatedListings"
        :key="v.id"
        cols="12"
        sm="6"
        md="4"
        lg="3"
      >
        <v-card elevation="0" rounded="lg" class="listing-card" hover>
            <div class="listing-card__image">
            <v-img
              :src="getListingImage(v.id) || 'https://images.unsplash.com/photo-1544636331-e26879cd4d9b?w=800&q=80&fit=crop'"
              :alt="v.name"
              cover
              height="140"
              gradient="to bottom, rgba(0,0,0,0) 50%, rgba(0,0,0,0.4) 100%"
            />
            <div v-if="rentalName(v)" class="listing-card__watermark">{{ rentalName(v) }}</div>
            <div v-if="rentalName(v)" class="listing-card__rental-badge">
              <v-tooltip location="bottom">
                <template #activator="{ props: tooltipProps }">
                  <span v-bind="tooltipProps">
                    <VehicleRentalBadge :rental-name="rentalName(v)!" :logo-url="listingLogoUrl(v)" :size="36" />
                  </span>
                </template>
                {{ rentalName(v) }}
              </v-tooltip>
            </div>
            <span class="listing-card__type">{{ v.type }}</span>
            <div class="listing-card__badges">
              <v-chip :color="v.approved ? 'success' : 'warning'" :prepend-icon="v.approved ? 'mdi-check-circle' : 'mdi-clock-outline'" size="x-small" variant="tonal">{{ v.approved ? 'Approved' : 'Pending' }}</v-chip>
              <v-chip v-if="v.featured" color="primary" size="x-small" variant="tonal" prepend-icon="mdi-star">Featured</v-chip>
              <v-chip v-if="v.rentalMode" size="x-small" variant="tonal" color="secondary" prepend-icon="mdi-car-key">{{ rentalModeLabel(v.rentalMode) }}</v-chip>
              <v-chip v-if="minRentalChipText(v.minRentalPeriodHours)" size="x-small" variant="tonal" color="secondary">{{ minRentalChipText(v.minRentalPeriodHours) }}</v-chip>
            </div>
          </div>
          <v-card-text class="pa-4">
            <h3 class="listing-card__name">{{ v.name }}</h3>
            <p v-if="rentalName(v)" class="listing-card__owner text-body-2 text-medium-emphasis mb-1">{{ rentalName(v) }}</p>
            <p class="listing-card__meta">{{ v.type }} · {{ v.location }} · {{ formatPrice(v.pricePerDay, { suffix: '/day' }) }}</p>
            <div class="listing-card__actions action-buttons d-flex flex-wrap gap-2">
              <v-btn variant="outlined" size="small" color="primary" rounded="lg" prepend-icon="mdi-eye" aria-label="View listing" class="action-btn action-btn--primary" :to="{ name: 'client-vehicle-detail', params: { id: v.id } }">
                View
              </v-btn>
              <v-btn v-if="!v.approved" variant="outlined" size="small" color="success" rounded="lg" prepend-icon="mdi-check-circle" aria-label="Approve listing" class="action-btn action-btn--success" @click="approve(v.id)">
                Approve
              </v-btn>
              <v-btn variant="outlined" size="small" rounded="lg" :prepend-icon="v.featured ? 'mdi-star-off' : 'mdi-star'" :aria-label="v.featured ? 'Unfeature' : 'Feature'" class="action-btn action-btn--edit" @click="toggleFeatured(v)">
                {{ v.featured ? 'Unfeature' : 'Feature' }}
              </v-btn>
            </div>
          </v-card-text>
        </v-card>
      </v-col>
    </v-row>
    </div>
    <v-pagination
      v-if="totalPages > 1"
      v-model="currentPage"
      :length="totalPages"
      :total-visible="7"
      density="comfortable"
      rounded="lg"
      class="mt-4"
    />
    <v-card v-if="!filteredListings.length" elevation="0" rounded="lg" class="modern-card">
      <v-card-text class="pa-4">
        <HpaEmptyState
          title="No listings match"
          description="No vehicle listings match your search. Try a different search term or view all vehicles."
          icon="mdi-format-list-bulleted"
          action-text="View vehicles"
          action-icon="mdi-car-side"
          @action="router.push({ name: 'admin-vehicles' })"
        />
      </v-card-text>
    </v-card>
  </DashboardTemplate>
</template>

<script setup lang="ts">
import { ref, computed, watch, onMounted } from 'vue'
import { useRouter } from 'vue-router'
import DashboardTemplate from '@/components/DashboardTemplate.vue'
import HpaDashboardWidget from '@/components/base/HpaDashboardWidget.vue'
import HpaEmptyState from '@/components/base/HpaEmptyState.vue'
import VehicleRentalBadge from '@/components/VehicleRentalBadge.vue'
import { rentalModeLabel, minRentalChipText } from '@/constants/vehicleSeed'
import { formatPrice } from '@/utils/priceFormat'
import { useToastStore } from '@/stores/toast'
import { useVehicles } from '@/composables/useVehicles'
import { useCarRentalProfiles } from '@/composables/useCarRentalProfiles'
import { useGsapStagger } from '@/composables/useGsapStagger'

const router = useRouter()
const listingsListRef = ref<HTMLElement | null>(null)
useGsapStagger(listingsListRef, { selector: '.v-col', y: 14, duration: 0.42, stagger: 0.06 })
const toast = useToastStore()
const { vehicles: vehiclesList, getById, update, fetchFromApi } = useVehicles()
const { rentals } = useCarRentalProfiles()
const search = ref('')
const showFilters = ref(false)
const sortBy = ref('name')
const filters = ref({
  status: 'all' as string,
  type: 'all' as string,
  location: 'all' as string,
})

onMounted(() => {
  fetchFromApi()
})

const statusFilterOptions = [
  { title: 'All statuses', value: 'all' },
  { title: 'Approved', value: 'approved' },
  { title: 'Pending', value: 'pending' },
]
const typeFilterOptions = [
  { title: 'All types', value: 'all' },
  { title: 'Car', value: 'Car' },
]

const listingStats = computed(() => {
  const list = vehiclesList.value
  return {
    total: list.length,
    approved: list.filter(v => v.approved !== false).length,
    pending: list.filter(v => v.approved === false).length,
    featured: list.filter(v => !!v.featured).length,
  }
})

const listings = computed(() =>
  vehiclesList.value.map(v => ({
    id: v.id,
    name: v.name,
    type: v.type,
    location: v.location,
    pricePerDay: v.pricePerDay,
    approved: v.approved ?? true,
    featured: v.featured ?? false,
    businessName: v.businessName,
    hostName: v.hostName,
  }))
)

function getListingImage(id: string): string | undefined {
  return getById(id)?.image
}

function rentalName(v: { businessName?: string; hostName?: string }) {
  return (v.businessName ?? v.hostName ?? '').trim() || undefined
}

function normRentalName(name: string): string {
  return name
    .replace(/\s*rental\s*/gi, ' ')
    .replace(/\s+/g, ' ')
    .trim()
    .toLowerCase()
}

function listingLogoUrl(v: { businessName?: string; hostName?: string }): string | undefined {
  const name = rentalName(v)
  if (!name) return undefined
  const norm = normRentalName(name)
  const match = rentals.value.find(rental => {
    const raw = (rental.businessName ?? (rental as { business_name?: string }).business_name ?? '') as string
    const rn = normRentalName(raw)
    if (!rn) return false
    if (rn === norm) return true
    if (norm.includes(rn) || rn.includes(norm)) return true
    return false
  })
  const url = (match as { logoUrl?: string; logo_url?: string } | undefined)?.logoUrl
    ?? (match as { logoUrl?: string; logo_url?: string } | undefined)?.logo_url
  return typeof url === 'string' && url.trim() ? url.trim() : undefined
}

const locationFilterOptions = computed(() => {
  const locs = [...new Set(listings.value.map(v => v.location).filter(Boolean))].sort()
  return [{ title: 'All locations', value: 'all' }, ...locs.map(l => ({ title: l, value: l }))]
})

const filteredListings = computed(() => {
  let list = listings.value
  const q = search.value?.toLowerCase() ?? ''
  if (q) {
    list = list.filter(
      v => v.name.toLowerCase().includes(q) || v.location.toLowerCase().includes(q) ||
        (v.businessName ?? '').toLowerCase().includes(q) || (v.hostName ?? '').toLowerCase().includes(q)
    )
  }
  if (filters.value.status === 'approved') list = list.filter(v => v.approved)
  else if (filters.value.status === 'pending') list = list.filter(v => !v.approved)
  if (filters.value.type !== 'all') list = list.filter(v => v.type === filters.value.type)
  if (filters.value.location !== 'all') list = list.filter(v => v.location === filters.value.location)
  // Sort
  const s = sortBy.value
  const sorted = [...list]
  if (s === 'name') sorted.sort((a, b) => a.name.localeCompare(b.name))
  else if (s === 'price-asc') sorted.sort((a, b) => a.pricePerDay - b.pricePerDay)
  else if (s === 'price-desc') sorted.sort((a, b) => b.pricePerDay - a.pricePerDay)
  else if (s === 'status') sorted.sort((a, b) => (a.approved ? 1 : 0) - (b.approved ? 1 : 0))
  else if (s === 'location') sorted.sort((a, b) => (a.location || '').localeCompare(b.location || ''))
  return sorted
})

const sortOptions = [
  { title: 'Name A–Z', value: 'name' },
  { title: 'Price (low to high)', value: 'price-asc' },
  { title: 'Price (high to low)', value: 'price-desc' },
  { title: 'Status', value: 'status' },
  { title: 'Location', value: 'location' },
]

const ITEMS_PER_PAGE = 12
const currentPage = ref(1)
const totalPages = computed(() => Math.max(1, Math.ceil(filteredListings.value.length / ITEMS_PER_PAGE)))
const paginatedListings = computed(() => {
  const list = filteredListings.value
  const start = (currentPage.value - 1) * ITEMS_PER_PAGE
  return list.slice(start, start + ITEMS_PER_PAGE)
})

watch([search, sortBy, () => filters.value], () => { currentPage.value = 1 })

function resetFilters() {
  filters.value = { status: 'all', type: 'all', location: 'all' }
  search.value = ''
}

async function approve(id: string) {
  const updated = await update(id, { approved: true })
  if (updated) {
    toast.success('Listing approved.')
  } else {
    toast.error('Could not approve listing. Please try again.')
  }
}

async function toggleFeatured(v: { id: string; featured: boolean }) {
  const updated = await update(v.id, { featured: !v.featured })
  if (updated) {
    toast.success(v.featured ? 'Listing unfeatured.' : 'Listing featured.')
  } else {
    toast.error('Could not update listing. Please try again.')
  }
}
</script>

<style scoped>
.listings-search {
  max-width: 360px;
}
.listing-card__image {
  position: relative;
  overflow: hidden;
  border-radius: 12px 12px 0 0;
}
.listing-card__image .v-img {
  width: 100%;
  display: block;
}
.listing-card__type {
  position: absolute;
  top: 8px;
  left: 8px;
  background: rgba(0, 0, 0, 0.6);
  color: #fff;
  padding: 2px 8px;
  border-radius: 6px;
  font-size: 0.75rem;
}
.listing-card__watermark {
  position: absolute;
  bottom: 8px;
  left: 8px;
  right: 8px;
  font-size: 0.7rem;
  color: rgba(255, 255, 255, 0.85);
  text-shadow: 0 1px 2px rgba(0, 0, 0, 0.6);
  pointer-events: none;
  z-index: 1;
}
.listing-card__rental-badge {
  position: absolute;
  top: 8px;
  right: 8px;
  z-index: 2;
}
.listing-card__badges {
  position: absolute;
  top: 8px;
  right: 8px;
  display: flex;
  flex-wrap: wrap;
  gap: 4px;
  justify-content: flex-end;
}
.listing-card__image:has(.listing-card__rental-badge) .listing-card__badges {
  right: 52px;
}
.listing-card__name {
  font-size: 1rem;
  font-weight: 700;
  margin: 0 0 4px 0;
}
.listing-card__owner {
  margin: 0 0 6px 0;
}
.listing-card__meta {
  font-size: 0.875rem;
  color: var(--text-secondary, #64748b);
  margin: 0 0 16px 0;
}
.listing-card__actions {
  display: flex;
  flex-wrap: wrap;
  gap: 12px;
  padding-top: 16px;
  border-top: 1px solid rgba(0, 0, 0, 0.08);
}

/* Action buttons: thin border with respective colors */
.action-btn {
  min-width: auto;
  font-weight: 600;
  text-transform: none;
  border-width: 1.5px !important;
}
.action-btn--primary { border-color: rgb(var(--v-theme-primary)) !important; }
.action-btn--edit { border-color: var(--metallic-dark, #64748b) !important; color: var(--text-secondary, #64748b) !important; }
.action-btn--success { border-color: rgb(var(--v-theme-success)) !important; }
</style>
