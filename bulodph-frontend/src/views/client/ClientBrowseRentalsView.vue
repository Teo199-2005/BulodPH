<template>
  <DashboardTemplate
    title="Browse car rentals"
    subtitle="Find rental companies and their fleets—throughout the region."
    :animate="true"
  >
    <LiabilityDisclaimerBanner dismiss-key="client-browse-rentals-liability-dismissed" />
    <div class="browse-rentals-filters mb-4 d-flex flex-wrap align-center gap-4">
      <v-text-field
        v-model="search"
        placeholder="Search by company name or location..."
        prepend-inner-icon="mdi-magnify"
        variant="outlined"
        density="comfortable"
        hide-details
        clearable
        rounded="lg"
        class="browse-search max-w-320"
      />
      <v-select
        v-model="locationFilter"
        :items="locationOptions"
        label="Location"
        variant="outlined"
        density="comfortable"
        hide-details
        rounded="lg"
        class="browse-location max-w-200"
      />
    </div>

    <p v-if="!loadingRentals && filteredRentals.length" class="text-body-2 text-medium-emphasis mb-3">
      {{ filteredRentals.length }} rental{{ filteredRentals.length === 1 ? '' : 's' }} found
    </p>

    <template v-if="loadingRentals">
      <v-row>
        <v-col v-for="i in 6" :key="i" cols="12" sm="6" md="4">
          <HpaSkeletonLoader :loading="true" type="card-grid" :count="1" />
        </v-col>
      </v-row>
    </template>
    <div v-else ref="rentalsListRef" class="rentals-list-stagger">
      <v-row>
      <v-col
        v-for="rental in paginatedRentals"
        :key="rental.id"
        cols="12"
        sm="6"
        md="4"
      >
        <v-card
          elevation="0"
          rounded="lg"
          class="modern-card rental-card"
          hover
          :to="{ name: 'client-rental-detail', params: { id: rental.slug ?? rental.id } }"
        >
          <div class="rental-card__header">
            <v-avatar :size="72" rounded="lg" class="rental-card__logo" :class="{ 'rental-card__logo--initials': showInitialsFor(rental) }">
              <v-img
                v-if="effectiveLogo(rental) && !logoLoadFailed(rental)"
                :src="resolveImageUrl(effectiveLogo(rental)!) ?? effectiveLogo(rental)!"
                cover
                @error="onLogoError(rental)"
              />
              <span v-else-if="effectiveName(rental)" class="rental-card__initials">{{ rentalCardInitials(effectiveName(rental)!) }}</span>
              <v-icon v-else size="36" color="grey">mdi-storefront-outline</v-icon>
            </v-avatar>
            <div class="rental-card__meta">
              <h3 class="rental-card__name">{{ effectiveName(rental) }}</h3>
              <div v-if="rental.city || rental.province" class="rental-card__location">
                <v-icon size="14">mdi-map-marker</v-icon>
                {{ [rental.city, rental.province].filter(Boolean).join(', ') }}
              </div>
              <div class="rental-card__vehicles">
                <v-icon size="14">mdi-car-multiple</v-icon>
                {{ rental.vehicleCount ?? 0 }} vehicle{{ (rental.vehicleCount ?? 0) === 1 ? '' : 's' }}
              </div>
            </div>
          </div>
          <v-card-text class="pa-4">
            <p v-if="rental.bio" class="rental-card__bio text-body-2 text-medium-emphasis">
              {{ rental.bio.length > 120 ? rental.bio.slice(0, 120) + '...' : rental.bio }}
            </p>
            <v-btn
              color="primary"
              variant="tonal"
              size="small"
              rounded="lg"
              block
              append-icon="mdi-arrow-right"
            >
              View fleet
            </v-btn>
          </v-card-text>
        </v-card>
      </v-col>
    </v-row>
    </div>

    <v-pagination
      v-if="!loadingRentals && totalPages > 1"
      v-model="currentPage"
      :length="totalPages"
      :total-visible="7"
      density="comfortable"
      rounded="lg"
      class="mt-4"
    />

    <v-card v-if="!loadingRentals && !filteredRentals.length" elevation="0" rounded="lg" class="modern-card">
      <v-card-text class="pa-4">
        <HpaEmptyState
          :title="hasActiveFilters ? 'No car rentals match' : 'No car rentals yet'"
          :description="hasActiveFilters ? 'No rental companies match your search. Try clearing filters or browse all vehicles.' : 'Rental companies will appear here once vehicles are listed.'"
          icon="mdi-storefront-outline"
          :action-text="hasActiveFilters ? 'Clear filters' : 'Browse all vehicles'"
          :action-icon="hasActiveFilters ? 'mdi-filter-off' : 'mdi-car-side'"
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
import { useCarRentalProfiles } from '@/composables/useCarRentalProfiles'
import { resolveImageUrl } from '@/constants/images'
import { useGsapStagger } from '@/composables/useGsapStagger'

const router = useRouter()
const rentalsListRef = ref<HTMLElement | null>(null)
useGsapStagger(rentalsListRef, { selector: '.v-col', y: 14, duration: 0.42, stagger: 0.06 })
const { rentals, fetchFromApi, fetchRentals, loadingRentals } = useCarRentalProfiles()

const search = ref('')
const locationFilter = ref('All')
const logoFailedIds = ref<Set<string>>(new Set())

const locationOptions = computed(() => {
  const locs = new Set<string>()
  rentals.value.forEach(r => {
    if (r.city) locs.add(r.city)
    if (r.province) locs.add(r.province)
  })
  return ['All', ...Array.from(locs).sort()]
})

const filteredRentals = computed(() => {
  let list = rentals.value
  const q = search.value?.toLowerCase().trim()
  if (q) {
    list = list.filter(
      r =>
        r.businessName.toLowerCase().includes(q) ||
        (r.bio && r.bio.toLowerCase().includes(q)) ||
        (r.city && r.city.toLowerCase().includes(q)) ||
        (r.province && r.province.toLowerCase().includes(q)) ||
        (r.address && r.address.toLowerCase().includes(q))
    )
  }
  if (locationFilter.value !== 'All') {
    list = list.filter(
      r =>
        r.city === locationFilter.value ||
        r.province === locationFilter.value
    )
  }
  return list
})

const ITEMS_PER_PAGE = 12
const currentPage = ref(1)
const totalPages = computed(() => Math.max(1, Math.ceil(filteredRentals.value.length / ITEMS_PER_PAGE)))
const paginatedRentals = computed(() => {
  const list = filteredRentals.value
  const start = (currentPage.value - 1) * ITEMS_PER_PAGE
  return list.slice(start, start + ITEMS_PER_PAGE)
})

watch([search, locationFilter], () => { currentPage.value = 1 })
watch(rentals, () => { logoFailedIds.value = new Set() }, { deep: true })

const hasActiveFilters = computed(() => !!(search.value?.trim()) || locationFilter.value !== 'All')

function handleEmptyAction() {
  if (hasActiveFilters.value) {
    search.value = ''
    locationFilter.value = 'All'
  } else {
    router.push({ name: 'client-browse' })
  }
}

/** Effective logo URL (non-empty string) so v-img never gets empty and avatar never clears. */
function effectiveLogo(rental: { logoUrl?: string | null; logo_url?: string }): string | undefined {
  const url = rental.logoUrl ?? (rental as { logo_url?: string }).logo_url
  return typeof url === 'string' && url.trim() ? url.trim() : undefined
}
/** Display name so avatar/heading never empty (handles API snake_case or null). */
function effectiveName(rental: { businessName?: string; business_name?: string }): string {
  const name = rental.businessName ?? (rental as { business_name?: string }).business_name
  return typeof name === 'string' && name.trim() ? name.trim() : 'Rental'
}
function logoLoadFailed(rental: { id?: string }): boolean {
  return rental.id ? logoFailedIds.value.has(rental.id) : false
}
function onLogoError(rental: { id?: string }): void {
  if (rental.id) {
    logoFailedIds.value = new Set(logoFailedIds.value).add(rental.id)
  }
}
/** Whether to show initials style (no logo or logo failed to load). */
function showInitialsFor(rental: { logoUrl?: string | null; logo_url?: string; businessName?: string; business_name?: string; id?: string }): boolean {
  const hasLogo = effectiveLogo(rental) && !logoLoadFailed(rental)
  return !hasLogo && !!effectiveName(rental)
}
/** Initials from company name for avatar when no logo (company logo = profile photo). */
function rentalCardInitials(name: string): string {
  const parts = String(name || '').trim().split(/\s+/).filter(Boolean)
  if (parts.length >= 2) return (parts[0][0] + parts[parts.length - 1][0]).toUpperCase()
  return (name || '?').slice(0, 2).toUpperCase()
}

onMounted(() => {
  fetchFromApi()
  fetchRentals()
})
</script>

<style scoped>
.browse-rentals-filters {
  gap: 1.25rem !important;
}
.rental-card__header {
  display: flex;
  gap: 1rem;
  padding: 1rem 1rem 0;
}
.rental-card__logo {
  flex-shrink: 0;
  background: rgba(var(--v-theme-surface-variant), 0.3);
}
.rental-card__logo--initials {
  background: linear-gradient(135deg, rgb(var(--v-theme-primary)) 0%, rgba(var(--v-theme-primary), 0.85) 100%);
  color: rgb(var(--v-theme-on-primary));
  font-weight: 700;
  font-size: 1.25rem;
}
.rental-card__initials {
  letter-spacing: 0.02em;
}
.rental-card__meta {
  flex: 1;
  min-width: 0;
}
.rental-card__name {
  font-size: 1.125rem;
  font-weight: 700;
  margin: 0 0 8px;
  line-height: 1.3;
}
.rental-card__location,
.rental-card__vehicles {
  font-size: 0.8125rem;
  color: rgba(0, 0, 0, 0.6);
  display: flex;
  align-items: center;
  gap: 6px;
  margin-bottom: 4px;
}
.rental-card__bio {
  margin: 0 0 1rem;
  line-height: 1.5;
  display: -webkit-box;
  -webkit-line-clamp: 3;
  -webkit-box-orient: vertical;
  overflow: hidden;
}
</style>
