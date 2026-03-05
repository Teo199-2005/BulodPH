<template>
  <DashboardTemplate :animate="true">
    <template #header>
      <div>
        <h1 class="page-title mb-1">My vehicles</h1>
        <p class="page-subtitle">List and manage your cars</p>
      </div>
      <v-btn color="primary" prepend-icon="mdi-plus" rounded="lg" :to="{ name: 'car-owner-vehicle-new' }">
        Add vehicle
      </v-btn>
    </template>

    <div class="vehicles-toolbar mb-4">
      <v-text-field
        v-model="searchQuery"
        placeholder="Search by name or plate number..."
        prepend-inner-icon="mdi-magnify"
        variant="outlined"
        density="comfortable"
        hide-details
        clearable
        rounded="lg"
        class="vehicles-toolbar__search"
      />
      <v-select
        v-model="sortBy"
        :items="sortOptions"
        item-title="label"
        item-value="value"
        variant="outlined"
        density="comfortable"
        hide-details
        rounded="lg"
        class="vehicles-toolbar__sort"
      />
    </div>

    <div ref="vehiclesListRef" class="car-owner-vehicles-stagger">
    <v-row>
      <v-col v-for="v in paginatedVehicles" :key="v.id" cols="12" sm="6" md="4">
        <v-card elevation="0" rounded="lg" class="modern-card vehicle-card" hover>
          <div class="vehicle-card__image-wrap">
            <v-img :src="v.image" height="160" cover />
            <v-chip v-if="v.hiddenFromListing" color="warning" size="small" class="vehicle-card__hidden-badge" variant="tonal" prepend-icon="mdi-eye-off">
              Hidden from listing
            </v-chip>
            <div v-if="rentalName(v)" class="vehicle-card__watermark">{{ rentalName(v) }}</div>
            <div v-if="rentalName(v)" class="vehicle-card__rental-badge">
              <VehicleRentalBadge :rental-name="rentalName(v)" :logo-url="ownerLogoUrl" :size="40" />
            </div>
          </div>
          <v-card-text class="pa-4">
            <div class="d-flex align-center justify-space-between mb-2">
              <h3 class="text-h6 font-weight-bold">{{ v.name }}</h3>
              <v-switch
                :model-value="v.status === 'Available'"
                color="success"
                hide-details
                density="compact"
                class="vehicle-card__availability"
                @update:model-value="toggleAvailability(v)"
              />
            </div>
            <p class="text-body-2 text-medium-emphasis mb-2">{{ v.type }} · {{ v.location }}</p>
            <p class="text-caption text-medium-emphasis mb-3">{{ vehicleStats(v.name).bookings }} bookings · {{ formatPrice(vehicleStats(v.name).earnings) }} earned</p>
            <div class="d-flex flex-wrap gap-2 mb-2">
              <v-chip v-if="v.rentalMode" size="x-small" variant="tonal" color="secondary" prepend-icon="mdi-car-key">{{ rentalModeLabel(v.rentalMode) }}</v-chip>
              <v-chip v-if="minRentalChipText(v.minRentalPeriodHours)" size="x-small" variant="tonal" color="secondary">{{ minRentalChipText(v.minRentalPeriodHours) }}</v-chip>
            </div>
            <div class="text-h6 font-weight-bold text-primary mb-4">{{ formatPrice(v.pricePerDay, { suffix: '/day' }) }}</div>
            <div class="d-flex gap-2 flex-wrap action-buttons">
              <v-tooltip location="top">
                <template #activator="{ props: tooltipProps }">
                  <v-btn v-bind="tooltipProps" variant="outlined" size="small" rounded="lg" icon="mdi-pencil" aria-label="Edit vehicle" :to="{ name: 'car-owner-vehicle-edit', params: { id: v.id } }" />
                </template>
                Edit
              </v-tooltip>
              <v-tooltip location="top">
                <template #activator="{ props: tooltipProps }">
                  <v-btn v-bind="tooltipProps" variant="outlined" size="small" rounded="lg" icon="mdi-calendar-check" aria-label="View bookings" :to="{ name: 'car-owner-bookings', query: { vehicle: v.name } }" />
                </template>
                Bookings
              </v-tooltip>
              <v-tooltip location="top">
                <template #activator="{ props: tooltipProps }">
                  <v-btn v-bind="tooltipProps" variant="tonal" color="primary" size="small" rounded="lg" icon="mdi-calendar-month" aria-label="Calendar" :to="{ name: 'car-owner-calendar' }" />
                </template>
                Calendar
              </v-tooltip>
              <v-tooltip location="top">
                <template #activator="{ props: tooltipProps }">
                  <v-btn
                    v-bind="tooltipProps"
                    :variant="v.hiddenFromListing ? 'flat' : 'outlined'"
                    :color="v.hiddenFromListing ? 'success' : 'warning'"
                    size="small"
                    rounded="lg"
                    :icon="v.hiddenFromListing ? 'mdi-eye' : 'mdi-eye-off'"
                    :aria-label="v.hiddenFromListing ? 'Show on listing' : 'Hide from listing'"
                    :loading="togglingHiddenId === v.id"
                    @click="toggleHiddenFromListing(v)"
                  />
                </template>
                {{ v.hiddenFromListing ? 'Show on listing' : 'Hide from listing' }}
              </v-tooltip>
              <v-tooltip location="top">
                <template #activator="{ props: tooltipProps }">
                  <v-btn
                    v-bind="tooltipProps"
                    variant="outlined"
                    size="small"
                    rounded="lg"
                    icon="mdi-delete-outline"
                    color="error"
                    aria-label="Remove vehicle"
                    :loading="removingId === v.id"
                    @click="confirmRemove(v)"
                  />
                </template>
                Remove
              </v-tooltip>
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
    <v-card v-if="!filteredAndSortedVehicles.length" elevation="0" rounded="lg" class="modern-card">
      <v-card-text class="pa-4">
        <HpaEmptyState
          title="No vehicles yet"
          description="Add your first car to start earning."
          icon="mdi-car-side"
          action-text="Add vehicle"
          action-icon="mdi-plus"
          @action="goToAddVehicle"
        />
      </v-card-text>
    </v-card>

    <HpaConfirmModal
      v-model="showRemoveConfirm"
      title="Remove this vehicle?"
      :message="removeConfirmMessage"
      confirm-text="Remove"
      cancel-text="Cancel"
      variant="danger"
      :loading="removingId !== null"
      @confirm="doRemove"
    />
  </DashboardTemplate>
</template>

<script setup lang="ts">
import { ref, computed, onMounted, watch } from 'vue'
import { useRouter } from 'vue-router'
import DashboardTemplate from '@/components/DashboardTemplate.vue'
import VehicleRentalBadge from '@/components/VehicleRentalBadge.vue'
import HpaEmptyState from '@/components/base/HpaEmptyState.vue'
import HpaConfirmModal from '@/components/base/HpaConfirmModal.vue'
import { rentalModeLabel, minRentalChipText } from '@/constants/vehicleSeed'
import { formatPrice } from '@/utils/priceFormat'
import { useVehicles } from '@/composables/useVehicles'
import { useCarRentalProfiles } from '@/composables/useCarRentalProfiles'
import { getStoredVehiclesForCurrentUser, updateStoredVehicle, removeStoredVehicle, storageRefreshTrigger } from '@/composables/useCarOwnerVehiclePersistence'
import { useUserSessionStore } from '@/stores/userSession'
import { useCarOwnerBookingsStore } from '@/stores/carOwnerBookings'
import { useToastStore } from '@/stores/toast'
import { useGsapStagger } from '@/composables/useGsapStagger'

const router = useRouter()
const vehiclesListRef = ref<HTMLElement | null>(null)
useGsapStagger(vehiclesListRef, { selector: '.v-col', y: 14, duration: 0.42, stagger: 0.06 })
const toast = useToastStore()
const { vehicles: allVehicles, update, remove, fetchFromApi } = useVehicles()
const { myRentalProfile, fetchMyProfile } = useCarRentalProfiles()
const userSession = useUserSessionStore()
const carOwnerBookings = useCarOwnerBookingsStore()

/** Logo from current user's rental profile (so "My vehicles" shows company logo, not initials). */
const ownerLogoUrl = computed(() => {
  const p = myRentalProfile.value
  const url = p?.logoUrl ?? (p as { logo_url?: string })?.logo_url
  return typeof url === 'string' && url.trim() ? url.trim() : undefined
})

const searchQuery = ref('')
const sortBy = ref('name-asc')
const showRemoveConfirm = ref(false)
const vehicleToRemove = ref<{ id: string; name: string } | null>(null)
const removingId = ref<string | null>(null)
const togglingHiddenId = ref<string | null>(null)

const sortOptions = [
  { label: 'Name (A–Z)', value: 'name-asc' },
  { label: 'Name (Z–A)', value: 'name-desc' },
  { label: 'Price (low to high)', value: 'price-asc' },
  { label: 'Price (high to low)', value: 'price-desc' },
]

function goToAddVehicle() {
  router.push({ name: 'car-owner-vehicle-new' })
}

onMounted(() => {
  fetchFromApi()
  fetchMyProfile()
  window.scrollTo(0, 0)
  document.getElementById('main-content')?.focus({ preventScroll: true })
})

watch([searchQuery, sortBy], () => {
  currentPage.value = 1
})

const ITEMS_PER_PAGE = 12
const currentPage = ref(1)

const vehicles = computed(() => {
  storageRefreshTrigger.value
  const ownerName = userSession.user?.name?.trim()
  const fromApi = allVehicles.value
  const fromApiMine = ownerName
    ? fromApi.filter(v => (v.businessName ?? v.hostName ?? '').toLowerCase() === ownerName.toLowerCase())
    : []
  const stored = getStoredVehiclesForCurrentUser()
  const apiIds = new Set(fromApiMine.map(v => v.id))
  const fromStored = stored.filter(v => !apiIds.has(v.id))
  const merged = [...fromApiMine, ...fromStored]
  return merged.map(v => ({
    id: v.id,
    name: v.name,
    type: v.type,
    location: v.location,
    pricePerDay: v.pricePerDay,
    status: (v.status ?? 'Available') as 'Available' | 'Unavailable',
    image: v.image,
    businessName: v.businessName,
    hostName: v.hostName,
    carNumber: v.carNumber ?? '',
    hiddenFromListing: v.hiddenFromListing === true,
  }))
})

const filteredAndSortedVehicles = computed(() => {
  let list = vehicles.value
  const q = searchQuery.value.trim().toLowerCase()
  if (q) {
    list = list.filter(
      v =>
        v.name.toLowerCase().includes(q) ||
        (v.carNumber && v.carNumber.toLowerCase().replace(/\s/g, '').includes(q.replace(/\s/g, '')))
    )
  }
  const sort = sortBy.value
  return [...list].sort((a, b) => {
    if (sort === 'name-asc') return a.name.localeCompare(b.name)
    if (sort === 'name-desc') return b.name.localeCompare(a.name)
    if (sort === 'price-asc') return a.pricePerDay - b.pricePerDay
    if (sort === 'price-desc') return b.pricePerDay - a.pricePerDay
    return 0
  })
})

const totalPages = computed(() => Math.max(1, Math.ceil(filteredAndSortedVehicles.value.length / ITEMS_PER_PAGE)))

const paginatedVehicles = computed(() => {
  const list = filteredAndSortedVehicles.value
  const start = (currentPage.value - 1) * ITEMS_PER_PAGE
  return list.slice(start, start + ITEMS_PER_PAGE)
})

function vehicleStats(vehicleName: string) {
  const all = carOwnerBookings.completed.concat(carOwnerBookings.upcoming).filter(b => b.vehicleName === vehicleName)
  const earnings = all.reduce((sum, b) => sum + (b.earnings ?? 0), 0)
  return { bookings: all.length, earnings }
}

function rentalName(v: { businessName?: string; hostName?: string }) {
  return (v.businessName ?? v.hostName ?? '').trim() || undefined
}

async function toggleAvailability(v: { id: string; status: string }) {
  const next = v.status === 'Available' ? 'Unavailable' : 'Available'
  const updated = await update(v.id, { status: next as 'Available' | 'Unavailable' })
  if (updated) {
    updateStoredVehicle(v.id, { status: next as 'Available' | 'Unavailable' })
  } else {
    toast.error('Could not update availability. Please try again.')
  }
}

async function toggleHiddenFromListing(v: { id: string; hiddenFromListing?: boolean }) {
  togglingHiddenId.value = v.id
  const next = !v.hiddenFromListing
  const updated = await update(v.id, { hiddenFromListing: next })
  if (updated) {
    updateStoredVehicle(v.id, { hiddenFromListing: next })
    toast.success(next ? 'Vehicle is hidden from listing.' : 'Vehicle is now visible on the listing.')
  } else {
    toast.error('Could not update. Please try again.')
  }
  togglingHiddenId.value = null
}

function confirmRemove(v: { id: string; name: string }) {
  vehicleToRemove.value = { id: v.id, name: v.name }
  showRemoveConfirm.value = true
}

const removeConfirmMessage = computed(() =>
  vehicleToRemove.value
    ? `"${vehicleToRemove.value.name}" will be removed from your fleet. You can add it again later.`
    : ''
)

async function doRemove() {
  if (!vehicleToRemove.value) return
  const id = vehicleToRemove.value.id
  removingId.value = id
  const result = await remove(id)
  if (result.ok) {
    removeStoredVehicle(id)
    toast.success('Vehicle removed.')
    showRemoveConfirm.value = false
    vehicleToRemove.value = null
  } else {
    const msg = result.message || 'Could not remove vehicle. Please try again.'
    toast.error(msg)
  }
  removingId.value = null
}
</script>

<style scoped>
.vehicles-toolbar {
  display: flex;
  flex-wrap: wrap;
  gap: 0.75rem;
  align-items: center;
}
.vehicles-toolbar__search {
  min-width: 220px;
  max-width: 320px;
}
.vehicles-toolbar__sort {
  width: 200px;
}
.vehicle-card__availability { flex-shrink: 0; }
.vehicle-card__image-wrap {
  position: relative;
  overflow: hidden;
  border-radius: 12px 12px 0 0;
}
.vehicle-card__hidden-badge {
  position: absolute;
  top: 8px;
  left: 8px;
  z-index: 2;
}
.vehicle-card__watermark {
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
.vehicle-card__rental-badge {
  position: absolute;
  top: 8px;
  right: 8px;
  z-index: 2;
}
</style>
