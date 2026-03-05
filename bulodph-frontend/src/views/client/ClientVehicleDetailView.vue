<template>
  <DashboardTemplate
      :animate="true"
      :breadcrumb-items="vehicle ? [{ label: 'Dashboard', to: '/client' }, { label: 'Browse', to: '/client/browse-rentals' }, { label: vehicle.name }] : undefined"
    >
    <template #header>
      <div>
        <div class="d-flex align-center gap-3 mb-2">
          <h1 class="page-title mb-0">{{ vehicle?.name ?? 'Vehicle' }}</h1>
          <v-tooltip v-if="vehicle && !isAdmin" location="bottom">
            <template #activator="{ props: tooltipProps }">
              <v-btn
                v-bind="tooltipProps"
                :icon="favoritesStore.has(vehicle.id) ? 'mdi-heart' : 'mdi-heart-outline'"
                size="small"
                :color="favoritesStore.has(vehicle.id) ? 'error' : undefined"
                :variant="favoritesStore.has(vehicle.id) ? 'flat' : 'tonal'"
                :aria-label="favoritesStore.has(vehicle.id) ? 'Remove from favorites' : 'Add to favorites'"
                @click="favoritesStore.toggle(vehicle.id)"
              />
            </template>
            {{ favoritesStore.has(vehicle.id) ? 'Remove from favorites' : 'Add to favorites' }}
          </v-tooltip>
          <v-tooltip v-if="vehicle && !isAdmin" location="bottom">
            <template #activator="{ props: tooltipProps }">
              <v-btn
                v-bind="tooltipProps"
                icon="mdi-share-variant"
                size="small"
                variant="tonal"
                aria-label="Share vehicle"
                @click="shareVehicle"
              />
            </template>
            Share
          </v-tooltip>
        </div>
        <p class="page-subtitle mb-0">{{ vehicle?.location }} · {{ vehicle?.type }} · {{ vehicle ? formatPrice(vehicle.pricePerDay, { suffix: '/day' }) : '' }}</p>
        <div v-if="vehicle" class="d-flex flex-wrap gap-2 mt-2">
          <v-chip v-if="vehicle.rentalMode" size="small" variant="tonal" color="secondary" prepend-icon="mdi-car-key">{{ rentalModeLabel(vehicle.rentalMode) }}</v-chip>
          <v-chip v-if="minRentalChipText(vehicle.minRentalPeriodHours)" size="small" variant="tonal" color="secondary">{{ minRentalChipText(vehicle.minRentalPeriodHours) }}</v-chip>
        </div>
      </div>
      <v-btn
        v-if="!isAdmin"
        color="primary"
        size="default"
        prepend-icon="mdi-calendar-plus"
        rounded="lg"
        :to="bookNowTo"
      >
        Book this ride
      </v-btn>
      <v-btn
        v-else
        variant="outlined"
        size="default"
        prepend-icon="mdi-arrow-left"
        rounded="lg"
        :to="{ name: 'admin-vehicles' }"
      >
        Back to Vehicle Listings
      </v-btn>
    </template>

    <div v-if="vehicle" class="vehicle-detail-page" :class="{ 'vehicle-detail-page--with-bar': !isAdmin }">
      <LiabilityDisclaimerBanner dismiss-key="client-vehicle-detail-liability-dismissed" />
      <!-- Main content: full width, 2x2 grid for sections -->
      <v-card elevation="0" rounded="lg" class="modern-card mb-4">
        <div class="vehicle-detail-hero">
          <button type="button" class="vehicle-detail-hero__img-btn" @click="lightboxVisible = true">
            <v-img
              :src="selectedImage"
              :alt="vehicle.name"
              cover
              height="280"
              class="vehicle-detail-hero__img"
            />
          </button>
          <div v-if="rentalName" class="vehicle-detail-hero__watermark">{{ rentalName }}</div>
          <div v-if="rentalName" class="vehicle-detail-hero__rental-badge">
            <VehicleRentalBadge :rental-name="rentalName" :logo-url="rentalLogoUrl" :size="44" />
          </div>
        </div>
        <v-card-text v-if="vehicle.imagesFourSides" class="pa-4 pt-4">
          <div class="text-caption text-medium-emphasis mb-3">Vehicle views (4 sides)</div>
          <div class="vehicle-four-sides">
            <button
              v-for="side in fourSidesList"
              :key="side.key"
              type="button"
              class="vehicle-four-sides__thumb"
              :class="{ 'vehicle-four-sides__thumb--active': selectedImage === side.url }"
              @click="selectedImage = side.url; lightboxVisible = true"
            >
              <div class="vehicle-four-sides__thumb-img">
                <v-img :src="side.url" :alt="side.label" cover height="72" />
                <div v-if="rentalName" class="vehicle-four-sides__badge">
                  <VehicleRentalBadge :rental-name="rentalName" :logo-url="rentalLogoUrl" :size="28" />
                </div>
              </div>
              <span class="vehicle-four-sides__label">{{ side.label }}</span>
            </button>
          </div>
        </v-card-text>

        <v-card-text class="pa-4 detail-grid">
          <div class="detail-grid__cell">
            <div class="form-section-header">
              <div class="form-section-icon">
                <v-icon icon="mdi-text-box-outline" size="18" />
              </div>
              <span class="detail-grid__title">Description</span>
            </div>
            <p class="text-body-2 mb-0">{{ vehicle.description }}</p>
          </div>
          <div class="detail-grid__cell">
            <div class="form-section-header">
              <div class="form-section-icon">
                <v-icon icon="mdi-car-info" size="18" />
              </div>
              <span class="detail-grid__title">Basic Information</span>
            </div>
            <v-sheet rounded="lg" class="pa-3 detail-block">
              <v-row dense>
                <v-col cols="6"><span class="detail-label">Brand</span><div class="detail-value">{{ vehicle.brand ?? '—' }}</div></v-col>
                <v-col cols="6"><span class="detail-label">Model</span><div class="detail-value">{{ vehicle.model ?? '—' }}</div></v-col>
                <v-col cols="6"><span class="detail-label">Car Number</span><div class="detail-value">{{ vehicle.carNumber ?? '—' }}</div></v-col>
                <v-col cols="6"><span class="detail-label">Type</span><div class="detail-value">{{ vehicle.carType ?? vehicle.type }}</div></v-col>
                <v-col cols="12"><span class="detail-label">Location</span><div class="detail-value">{{ vehicle.location }}</div></v-col>
              </v-row>
            </v-sheet>
          </div>
          <div class="detail-grid__cell">
            <div class="form-section-header">
              <div class="form-section-icon">
                <v-icon icon="mdi-currency-php" size="18" />
              </div>
              <span class="detail-grid__title">Pricing</span>
            </div>
            <v-sheet rounded="lg" class="pa-3 detail-block">
              <v-row dense>
                <v-col cols="12"><span class="detail-label">Daily Rate</span><div class="detail-value"><PriceDisplay :price-per-day="vehicle.pricePerDay" :original-price-per-day="vehicle.originalPricePerDay" variant="detail" /></div></v-col>
                <v-col cols="6"><span class="detail-label">Overdue Charge</span><div class="detail-value">{{ vehicle.overdueChargeRate != null ? formatPrice(vehicle.overdueChargeRate, { suffix: '/hr' }) : '—' }}</div></v-col>
                <v-col cols="6"><span class="detail-label">Security Deposit</span><div class="detail-value">{{ vehicle.securityDeposit != null ? formatPrice(vehicle.securityDeposit) : '—' }}</div></v-col>
              </v-row>
            </v-sheet>
          </div>
          <div class="detail-grid__cell">
            <div class="form-section-header">
              <div class="form-section-icon">
                <v-icon icon="mdi-cog-outline" size="18" />
              </div>
              <span class="detail-grid__title">Specifications</span>
            </div>
            <v-sheet rounded="lg" class="pa-3 detail-block">
              <v-row dense>
                <v-col cols="6"><span class="detail-label">Transmission</span><div class="detail-value">{{ vehicle.transmission ?? '—' }}</div></v-col>
                <v-col cols="6"><span class="detail-label">Capacity</span><div class="detail-value">{{ vehicle.capacity != null ? vehicle.capacity + ' seats' : '—' }}</div></v-col>
                <v-col cols="6"><span class="detail-label">Fuel Type</span><div class="detail-value">{{ vehicle.fuelType ?? '—' }}</div></v-col>
                <v-col cols="6"><span class="detail-label">Rental mode</span><div class="detail-value">{{ vehicle.rentalMode ? rentalModeLabel(vehicle.rentalMode) : '—' }}</div></v-col>
                <v-col cols="6"><span class="detail-label">Min Rental</span><div class="detail-value">{{ vehicle.minRentalPeriodHours != null ? (vehicle.minRentalPeriodHours === 24 ? '1 day' : vehicle.minRentalPeriodHours + ' hours') : '—' }}</div></v-col>
              </v-row>
            </v-sheet>
          </div>
          <div class="detail-grid__cell">
            <div class="form-section-header">
              <div class="form-section-icon">
                <v-icon icon="mdi-file-document-outline" size="18" />
              </div>
              <span class="detail-grid__title">Rental Terms</span>
            </div>
            <v-sheet rounded="lg" class="pa-3 detail-block">
              <p class="text-body-2 mb-1"><span class="detail-label">Fuel Policy</span> {{ vehicle.fuelReturnPolicy ?? '—' }}</p>
              <p class="text-body-2 mb-0"><span class="detail-label">Car rental</span> {{ rentalName ?? '—' }}</p>
            </v-sheet>
          </div>
          <div class="detail-grid__cell">
            <div class="form-section-header">
              <div class="form-section-icon">
                <v-icon icon="mdi-star-outline" size="18" />
              </div>
              <span class="detail-grid__title">Recent Reviews</span>
            </div>
            <v-sheet rounded="lg" class="pa-3 detail-block">
              <template v-if="vehicleReviews.length">
                <div class="d-flex align-center gap-3 mb-3">
                  <v-rating :model-value="reviewsAverage" density="compact" size="small" half-increments readonly />
                  <span class="text-body-2 font-weight-medium">{{ reviewsAverage.toFixed(1) }}</span>
                  <span class="text-body-2 text-medium-emphasis">({{ vehicleReviews.length }} review{{ vehicleReviews.length === 1 ? '' : 's' }})</span>
                </div>
                <div class="reviews-list">
                  <div v-for="r in vehicleReviews.slice(0, 5)" :key="r.id" class="reviews-list__item">
                    <div class="d-flex align-center justify-space-between mb-1">
                      <span class="text-body-2 font-weight-medium">{{ r.authorName }}</span>
                      <span class="text-caption text-medium-emphasis">{{ r.date }}</span>
                    </div>
                    <v-rating :model-value="r.rating" density="compact" size="x-small" readonly class="mb-1" />
                    <p class="text-body-2 text-medium-emphasis mb-0">{{ r.comment }}</p>
                  </div>
                </div>
              </template>
              <p v-else class="text-body-2 text-medium-emphasis mb-0">No reviews yet for this vehicle.</p>
            </v-sheet>
          </div>
        </v-card-text>

        <v-card-text v-if="vehicle.knownIssues" class="pa-4 pt-0">
          <div class="form-section-header">
            <div class="form-section-icon">
              <v-icon icon="mdi-alert-circle-outline" size="18" color="warning" />
            </div>
            <span class="detail-grid__title">Known issues</span>
          </div>
          <v-sheet rounded="lg" class="pa-3 detail-block detail-block--warning">
            <p class="text-body-2 text-medium-emphasis mb-0">{{ vehicle.knownIssues }}</p>
          </v-sheet>
        </v-card-text>
      </v-card>

      <!-- Similar vehicles (same type or location) -->
      <v-card v-if="vehicle && similarVehicles.length && !isAdmin" elevation="0" rounded="lg" class="modern-card mt-4">
        <div class="section-card-header section-card-header--with-actions">
          <div class="section-card-icon">
            <v-icon icon="mdi-car-multiple" size="20" />
          </div>
          <span class="section-card-title">Similar vehicles</span>
          <v-spacer />
          <v-btn variant="tonal" color="primary" size="small" rounded="lg" :to="{ name: 'client-browse' }">Browse all</v-btn>
        </div>
        <v-divider />
        <v-card-text class="pa-4">
          <div class="similar-vehicles-grid">
            <v-card
              v-for="v in similarVehicles"
              :key="v.id"
              elevation="0"
              rounded="lg"
              class="modern-card similar-vehicle-card"
              hover
              :to="{ name: 'client-vehicle-detail', params: { id: v.id } }"
            >
              <v-img :src="v.image" :alt="v.name" cover height="120" class="similar-vehicle-card__img" />
              <v-card-text class="pa-3">
                <div class="d-flex flex-wrap gap-1 mb-1">
                  <v-chip v-if="v.rentalMode" size="x-small" variant="tonal" color="secondary" density="compact">{{ rentalModeLabel(v.rentalMode) }}</v-chip>
                  <v-chip v-if="minRentalChipText(v.minRentalPeriodHours)" size="x-small" variant="tonal" color="secondary" density="compact">{{ minRentalChipText(v.minRentalPeriodHours) }}</v-chip>
                </div>
                <h4 class="text-subtitle-2 font-weight-bold mb-1">{{ v.name }}</h4>
                <p class="text-caption text-medium-emphasis mb-2">{{ v.location }} · {{ v.type }}</p>
                <PriceDisplay :price-per-day="v.pricePerDay" :original-price-per-day="v.originalPricePerDay" variant="card" />
              </v-card-text>
            </v-card>
          </div>
        </v-card-text>
      </v-card>

      <!-- Floating bottom booking bar: teleport to body so position:fixed is relative to viewport (avoids layout scroll/transform conflicts) -->
      <Teleport to="body">
        <div v-if="vehicle && !isAdmin" class="booking-bar">
          <div class="booking-bar__inner">
            <div class="booking-bar__left">
              <p class="booking-bar__label">Daily rate</p>
              <div class="booking-bar__price">
                <PriceDisplay :price-per-day="vehicle.pricePerDay" :original-price-per-day="vehicle.originalPricePerDay" variant="detail" suffix="/ day" />
              </div>
              <p class="booking-bar__summary">Reserve this vehicle for your trip. Pick your dates, then pay securely when you confirm the booking.</p>
              <div class="booking-bar__payment">
                <v-icon size="18">mdi-shield-check-outline</v-icon>
                <span>Secure payment via GCash or Maya. Pay when you book—no hidden fees.</span>
              </div>
              <p class="booking-bar__note">Free cancellation up to 24 hours before pickup. See rental terms for fuel and deposit details.</p>
            </div>
            <div class="booking-bar__actions">
              <v-btn
                color="primary"
                size="large"
                rounded="lg"
                prepend-icon="mdi-calendar-plus"
                class="booking-bar__btn booking-bar__btn--primary"
                :to="bookNowTo"
              >
                Book now
              </v-btn>
              <v-btn
                variant="outlined"
                size="large"
                rounded="lg"
                class="booking-bar__btn"
                prepend-icon="mdi-cart-plus"
                @click="addToCart"
              >
                Add to cart
              </v-btn>
            </div>
          </div>
        </div>
      </Teleport>
    </div>

    <div v-else class="text-center py-8">
      <p class="text-medium-emphasis mb-3">Vehicle not found.</p>
      <v-btn variant="tonal" color="primary" rounded="lg" class="me-2" :to="{ name: 'client-browse' }">Back to browse</v-btn>
      <v-btn variant="outlined" rounded="lg" :to="{ name: 'client-browse-rentals' }">Browse car rentals</v-btn>
    </div>

    <HpaLightbox
      v-if="vehicle"
      :visible="lightboxVisible"
      :src="selectedImage"
      :alt="vehicle.name"
      @close="lightboxVisible = false"
    />
  </DashboardTemplate>
</template>

<script setup lang="ts">
import { ref, computed, watch, onMounted } from 'vue'
import { useRoute, useRouter } from 'vue-router'
import DashboardTemplate from '@/components/DashboardTemplate.vue'
import LiabilityDisclaimerBanner from '@/components/LiabilityDisclaimerBanner.vue'
import PriceDisplay from '@/components/PriceDisplay.vue'
import { formatPrice } from '@/utils/priceFormat'
import { useToastStore } from '@/stores/toast'
import { useUserSessionStore } from '@/stores/userSession'
import { useVehicles } from '@/composables/useVehicles'
import { useCarRentalProfiles } from '@/composables/useCarRentalProfiles'
import { useCartStore } from '@/stores/cart'
import { useFavoritesStore } from '@/stores/favorites'
import VehicleRentalBadge from '@/components/VehicleRentalBadge.vue'
import HpaLightbox from '@/components/base/HpaLightbox.vue'
import { getReviewsForVehicle } from '@/constants/reviewsSeed'
import { rentalModeLabel, minRentalChipText } from '@/constants/vehicleSeed'
import type { VehicleImagesFourSides } from '@/constants/vehicleSeed'

/** Same as browse: support API snake_case so rental name resolves. */
function rentalNameFrom(v: { businessName?: string; business_name?: string; hostName?: string; host_name?: string } | null) {
  if (!v) return undefined
  const s = (v.businessName ?? (v as { business_name?: string }).business_name ?? v.hostName ?? (v as { host_name?: string }).host_name ?? '').trim()
  return s || undefined
}

/** Normalize name for matching (same as ClientBrowseView). */
function normRentalName(name: string): string {
  return name
    .replace(/\s*rental\s*/gi, ' ')
    .replace(/\s+/g, ' ')
    .trim()
    .toLowerCase()
}

const route = useRoute()
const favoritesStore = useFavoritesStore()
const router = useRouter()
const toast = useToastStore()
const userSession = useUserSessionStore()
const cartStore = useCartStore()

const { getById, approvedVehicles } = useVehicles()
const { rentals, fetchRentals } = useCarRentalProfiles()

onMounted(() => {
  fetchRentals()
})

/** Raw vehicle from store (may have snake_case from API) for rental name/logo resolution. */
const rawVehicle = computed(() => {
  const id = route.params.id as string
  return getById(id) ?? null
})

const rentalName = computed(() => rentalNameFrom(rawVehicle.value))
/** Logo URL for this vehicle's rental (from rental profiles, same as browse). */
const rentalLogoUrl = computed((): string | undefined => {
  const v = rawVehicle.value
  if (!v) return undefined
  const name = rentalNameFrom(v)
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
})

const isAdmin = computed(() => userSession.hasRole('admin'))
const backTo = computed(() => (isAdmin.value ? { name: 'admin-vehicles' } : { name: 'client-browse' }))
const backLabel = computed(() => (isAdmin.value ? 'Back to Vehicle Listings' : 'Back to browse'))

const vehicle = computed(() => {
  const v = rawVehicle.value
  if (!v) return null
  return {
    id: v.id,
    name: v.name,
    type: v.type,
    location: v.location,
    pricePerDay: v.pricePerDay,
    originalPricePerDay: v.originalPricePerDay,
    description: v.description,
    image: v.image,
    imagesFourSides: v.imagesFourSides,
    knownIssues: v.knownIssues,
    hostName: v.hostName ?? (v as { host_name?: string }).host_name ?? undefined,
    businessName: v.businessName ?? (v as { business_name?: string }).business_name ?? undefined,
    brand: v.brand,
    model: v.model,
    carNumber: v.carNumber,
    carType: v.carType,
    capacity: v.capacity,
    transmission: v.transmission,
    fuelType: v.fuelType,
    fuelReturnPolicy: v.fuelReturnPolicy,
    minRentalPeriodHours: v.minRentalPeriodHours,
    overdueChargeRate: v.overdueChargeRate,
    securityDeposit: v.securityDeposit,
    reviewCount: v.reviewCount ?? 0,
  }
})

const vehicleReviews = computed(() => (vehicle.value ? getReviewsForVehicle(vehicle.value.id) : []))
const reviewsAverage = computed(() => {
  const r = vehicleReviews.value
  if (!r.length) return 0
  return r.reduce((a, x) => a + x.rating, 0) / r.length
})

/** Currently shown hero image (main or one of 4 sides) */
const selectedImage = ref(vehicle.value?.image ?? '')
const lightboxVisible = ref(false)
watch(vehicle, (v) => {
  selectedImage.value = v?.image ?? ''
}, { immediate: true })

/** Ordered list for 4-side gallery: Front, Rear, Left, Right */
const fourSidesList = computed((): { key: keyof VehicleImagesFourSides; label: string; url: string }[] => {
  const sides = vehicle.value?.imagesFourSides
  if (!sides) return []
  return [
    { key: 'front', label: 'Front', url: sides.front },
    { key: 'rear', label: 'Rear', url: sides.rear },
    { key: 'left', label: 'Left', url: sides.left },
    { key: 'right', label: 'Right', url: sides.right },
  ]
})

const bookNowTo = computed(() => ({
  name: 'client-booking-new',
  query: { vehicleId: vehicle.value?.id },
}))

/** Similar vehicles: same type or location, exclude current, limit 4 */
const similarVehicles = computed(() => {
  const v = vehicle.value
  if (!v) return []
  const list = approvedVehicles.value.filter(x => x.id !== v.id)
  const byType = list.filter(x => (x.type || '').toLowerCase() === (v.type || '').toLowerCase())
  const byLocation = list.filter(x => (x.location || '').toLowerCase().includes((v.location || '').toLowerCase()) || (v.location || '').toLowerCase().includes((x.location || '').toLowerCase()))
  const combined = [...new Map([...byType, ...byLocation].map(item => [item.id, item]).filter(([, item]) => item)).values()]
  return combined.slice(0, 4).map(x => ({
    id: x.id,
    name: x.name,
    type: x.type,
    location: x.location,
    pricePerDay: x.pricePerDay,
    originalPricePerDay: x.originalPricePerDay,
    image: x.image,
    rentalMode: x.rentalMode,
    minRentalPeriodHours: x.minRentalPeriodHours,
  }))
})

function shareVehicle() {
  const url = window.location.href
  if (navigator.share && typeof navigator.share === 'function') {
    navigator.share({ title: vehicle.value?.name ?? 'Vehicle', url }).then(() => toast.success('Link shared.')).catch(() => copyShareUrl(url))
  } else {
    copyShareUrl(url)
  }
}

function copyShareUrl(url: string) {
  navigator.clipboard.writeText(url).then(() => toast.success('Link copied to clipboard.')).catch(() => toast.warning('Could not copy link.'))
}

function addToCart() {
  if (!vehicle.value) return
  cartStore.addItem({
    vehicleId: vehicle.value.id,
    vehicleName: vehicle.value.name,
    vehicleImage: vehicle.value.image,
    location: vehicle.value.location,
    pricePerDay: vehicle.value.pricePerDay,
  })
  toast.success(`"${vehicle.value.name}" added to cart. Pick dates in Cart or proceed to checkout.`)
  router.push({ name: 'client-cart' })
}
</script>

<style scoped>
.vehicle-detail-page--with-bar {
  padding-bottom: 200px;
}
@media (max-width: 959.99px) {
  .vehicle-detail-page--with-bar {
    padding-bottom: 260px;
  }
}

.detail-grid {
  display: grid;
  grid-template-columns: repeat(2, 1fr);
  gap: 1.25rem 1.5rem;
}
@media (max-width: 759.99px) {
  .detail-grid {
    grid-template-columns: 1fr;
  }
}
.detail-grid__cell {
  min-width: 0;
}
.detail-grid__title {
  font-size: 1rem;
  font-weight: 700;
  margin: 0 0 0.5rem 0;
}
.reviews-list__item {
  padding: 0.5rem 0;
  border-bottom: 1px solid rgba(var(--v-border-color), var(--v-border-opacity));
}
.reviews-list__item:last-child {
  border-bottom: none;
}

.vehicle-detail-hero {
  position: relative;
  overflow: hidden;
  border-radius: 12px 12px 0 0;
}
.vehicle-detail-hero__img-btn {
  display: block;
  width: 100%;
  padding: 0;
  border: none;
  background: none;
  cursor: pointer;
}
.vehicle-detail-hero__img {
  display: block;
}
.vehicle-detail-hero__watermark {
  position: absolute;
  bottom: 12px;
  left: 12px;
  right: 12px;
  font-size: 0.8rem;
  color: rgba(255, 255, 255, 0.9);
  text-shadow: 0 1px 3px rgba(0, 0, 0, 0.7);
  pointer-events: none;
  z-index: 2;
}
.vehicle-detail-hero__rental-badge {
  position: absolute;
  top: 12px;
  right: 12px;
  z-index: 2;
}
.vehicle-four-sides {
  display: grid;
  grid-template-columns: repeat(4, 1fr);
  gap: 8px;
}
.vehicle-four-sides__thumb {
  position: relative;
  border: 2px solid transparent;
  border-radius: 8px;
  overflow: hidden;
  padding: 0;
  background: transparent;
  cursor: pointer;
  transition: border-color 0.2s, box-shadow 0.2s;
}
.vehicle-four-sides__thumb:hover {
  border-color: rgba(30, 58, 95, 0.3);
  box-shadow: 0 2px 8px rgba(0, 0, 0, 0.08);
}
.vehicle-four-sides__thumb--active {
  border-color: rgb(var(--v-theme-primary));
  box-shadow: 0 0 0 2px rgba(var(--v-theme-primary), 0.2);
}
.vehicle-four-sides__thumb-img {
  position: relative;
  display: block;
}
.vehicle-four-sides__thumb :deep(.v-img) {
  border-radius: 6px;
}
.vehicle-four-sides__badge {
  position: absolute;
  top: 4px;
  right: 4px;
  z-index: 2;
}
.vehicle-four-sides__label {
  display: block;
  font-size: 0.6875rem;
  font-weight: 600;
  color: rgb(var(--v-theme-on-surface));
  text-align: center;
  padding: 4px 0;
}
.similar-vehicles-grid {
  display: grid;
  grid-template-columns: repeat(auto-fill, minmax(160px, 1fr));
  gap: 1rem;
}
.similar-vehicle-card__img {
  border-radius: 12px 12px 0 0;
}
/* Booking card: sticky so it stays visible when scrolling and doesn’t join the main content */
/* Floating bottom booking bar – wide, fixed to bottom */
/* Bar is teleported to body so position:fixed is relative to viewport (no scroll/transform conflict) */
/* Constrain to main content area: do not overlap the sidebar (260px on desktop) */
.booking-bar {
  position: fixed !important;
  bottom: 0;
  left: 0;
  right: 0;
  z-index: 9999;
  padding: 12px 16px 16px;
  background: linear-gradient(to top, rgb(var(--v-theme-surface)) 92%, transparent);
  box-shadow: 0 -4px 24px rgba(0, 0, 0, 0.12);
  isolation: isolate;
}
@media (min-width: 960px) {
  .booking-bar {
    left: 260px;
  }
}
@media (max-width: 959.99px) {
  .booking-bar {
    bottom: 72px;
  }
}
.booking-bar__inner {
  max-width: 920px;
  margin: 0 auto;
  display: flex;
  align-items: center;
  gap: 1.5rem;
  flex-wrap: wrap;
  padding: 1rem 1.25rem;
  background: rgb(var(--v-theme-surface));
  border: 1px solid rgba(0, 0, 0, 0.08);
  border-radius: 16px;
  box-shadow: 0 4px 20px rgba(0, 0, 0, 0.08);
}
.booking-bar__left {
  flex: 1 1 320px;
  min-width: 0;
}
.booking-bar__label {
  font-size: 0.6875rem;
  font-weight: 700;
  text-transform: uppercase;
  letter-spacing: 0.06em;
  color: rgb(var(--v-theme-primary));
  margin: 0 0 2px 0;
}
.booking-bar__price {
  line-height: 1.2;
  margin-bottom: 0.25rem;
}
.booking-bar__amount {
  font-size: 1.5rem;
  font-weight: 700;
  color: rgb(var(--v-theme-on-surface));
}
.booking-bar__period {
  font-size: 0.9375rem;
  font-weight: 400;
  color: var(--text-secondary, #64748b);
}
.booking-bar__summary {
  font-size: 0.875rem;
  color: var(--text-primary, #1F2937);
  line-height: 1.4;
  margin: 0 0 0.5rem 0;
}
.booking-bar__payment {
  display: inline-flex;
  align-items: center;
  gap: 0.35rem;
  padding: 0.35rem 0.6rem;
  background: rgba(var(--v-theme-primary), 0.08);
  border-radius: 8px;
  font-size: 0.8125rem;
  color: var(--text-secondary, #64748b);
  margin-bottom: 0.25rem;
}
.booking-bar__payment .v-icon {
  color: rgb(var(--v-theme-primary));
  flex-shrink: 0;
}
.booking-bar__note {
  font-size: 0.75rem;
  color: var(--text-secondary, #64748b);
  margin: 0;
  line-height: 1.3;
}
.booking-bar__actions {
  display: flex;
  flex-direction: column;
  gap: 0.5rem;
  flex-shrink: 0;
}
@media (min-width: 600px) {
  .booking-bar__actions {
    flex-direction: row;
  }
}
.booking-bar__btn {
  font-weight: 600;
  min-width: 140px;
}
.booking-bar__btn--primary {
  box-shadow: 0 2px 8px rgba(var(--v-theme-primary), 0.25);
}

.detail-block {
  background: rgba(0, 0, 0, 0.03);
}
.detail-block--warning {
  background: rgba(245, 158, 11, 0.08);
}
.detail-label {
  display: block;
  font-size: 0.75rem;
  font-weight: 600;
  color: var(--text-secondary, #64748b);
  text-transform: uppercase;
  letter-spacing: 0.03em;
  margin-bottom: 2px;
}
.detail-value {
  font-size: 0.9375rem;
  font-weight: 500;
  color: var(--text-primary, #1F2937);
}
</style>
