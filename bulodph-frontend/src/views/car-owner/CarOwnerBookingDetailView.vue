<template>
  <DashboardTemplate
    title="Booking"
    subtitle="Details and actions"
    :animate="true"
    :breadcrumb-items="[{ label: 'Dashboard', to: '/car-owner' }, { label: 'Bookings', to: '/car-owner/bookings' }, { label: booking?.vehicleName || 'Booking' }]"
  >
    <v-card v-if="booking" elevation="0" rounded="lg" class="modern-card mb-4">
      <v-card-text class="pa-4">
        <div class="booking-detail-image-wrap mb-4">
          <v-img
            :src="bookingImageUrl"
            :alt="booking.vehicleName"
            height="200"
            cover
            rounded="lg"
            class="booking-detail-image"
          />
        </div>
        <HpaStatusBadge :variant="getStatusVariant(booking.status)" :label="booking.status" class="mb-3" />
        <v-list density="compact" class="pa-0">
          <v-list-item>
            <template #prepend><v-icon>mdi-car-side</v-icon></template>
            <v-list-item-title>Vehicle</v-list-item-title>
            <v-list-item-subtitle>
              {{ booking.vehicleName }}
              <span v-if="bookingVehicle" class="d-inline-flex flex-wrap align-center gap-1 mt-1">
                <v-chip v-if="bookingVehicle.rentalMode" size="x-small" variant="tonal" color="secondary" density="compact">{{ rentalModeLabel(bookingVehicle.rentalMode) }}</v-chip>
                <v-chip v-if="minRentalChipText(bookingVehicle.minRentalPeriodHours)" size="x-small" variant="tonal" color="secondary" density="compact">{{ minRentalChipText(bookingVehicle.minRentalPeriodHours) }}</v-chip>
              </span>
            </v-list-item-subtitle>
          </v-list-item>
          <v-list-item>
            <template #prepend><v-icon>mdi-account</v-icon></template>
            <v-list-item-title>Renter</v-list-item-title>
            <v-list-item-subtitle>{{ booking.renterName }}</v-list-item-subtitle>
          </v-list-item>
          <v-list-item v-if="booking.renterPhone">
            <template #prepend><v-icon>mdi-phone</v-icon></template>
            <v-list-item-title>Renter phone</v-list-item-title>
            <v-list-item-subtitle>
              <a :href="`tel:${String(booking.renterPhone).replace(/\s/g, '')}`" class="text-primary">{{ booking.renterPhone }}</a>
            </v-list-item-subtitle>
          </v-list-item>
          <v-list-item>
            <template #prepend><v-icon>mdi-calendar</v-icon></template>
            <v-list-item-title>Dates</v-list-item-title>
            <v-list-item-subtitle>{{ booking.start }} – {{ booking.end }}</v-list-item-subtitle>
          </v-list-item>
          <v-list-item>
            <template #prepend><v-icon>mdi-clock-outline</v-icon></template>
            <v-list-item-title>Duration</v-list-item-title>
            <v-list-item-subtitle>
              <span class="booking-duration-text">{{ bookingDurationText }}</span>
              <span v-if="bookingDurationHours > 0" class="booking-duration-hours"> · {{ bookingDurationHours }} hour{{ bookingDurationHours === 1 ? '' : 's' }}</span>
            </v-list-item-subtitle>
          </v-list-item>
          <v-list-item>
            <template #prepend><v-icon>mdi-map-marker</v-icon></template>
            <v-list-item-title>Meet-up</v-list-item-title>
            <v-list-item-subtitle>{{ booking.meetUp || '—' }}</v-list-item-subtitle>
          </v-list-item>
          <v-list-item>
            <template #prepend><v-icon>mdi-cash</v-icon></template>
            <v-list-item-title>Earnings</v-list-item-title>
            <v-list-item-subtitle class="text-primary font-weight-bold">{{ formatPrice(booking.earnings) }}</v-list-item-subtitle>
          </v-list-item>
          <v-list-item>
            <template #prepend><v-icon>mdi-identifier</v-icon></template>
            <v-list-item-title>Booking reference</v-list-item-title>
            <v-list-item-subtitle class="text-medium-emphasis">{{ booking.id }}</v-list-item-subtitle>
          </v-list-item>
        </v-list>
        <v-divider class="my-3" />
        <div class="booking-detail-actions">
          <template v-if="booking.status === 'Requested'">
            <p class="text-body-2 text-medium-emphasis mb-3">Bookings are accepted by the platform. You will be notified when the booking is confirmed; no approval or rejection is needed from you. You can view details here anytime.</p>
            <v-btn variant="outlined" rounded="lg" prepend-icon="mdi-arrow-left" :to="{ name: 'car-owner-bookings' }">Back to Bookings</v-btn>
          </template>
          <template v-else>
            <div class="d-flex flex-wrap align-center gap-2">
              <v-btn v-if="booking.status === 'Confirmed'" color="primary" rounded="lg" prepend-icon="mdi-hand-back-right" @click="markHandedOver">Mark handed over</v-btn>
              <v-btn v-if="booking.status === 'Active'" color="primary" rounded="lg" prepend-icon="mdi-key-return" @click="markReturned">Mark returned</v-btn>
              <v-btn variant="outlined" rounded="lg" prepend-icon="mdi-arrow-left" :to="{ name: 'car-owner-bookings' }">Back to Bookings</v-btn>
            </div>
          </template>
        </div>
      </v-card-text>
    </v-card>

    <template v-if="booking && (booking.status === 'Confirmed' || booking.status === 'Active' || booking.status === 'Completed')">
      <v-card elevation="0" rounded="lg" class="modern-card mb-4">
        <v-card-text class="pa-4">
          <h3 class="text-subtitle-1 font-weight-bold mb-2 d-flex align-center gap-3">
            <v-icon icon="mdi-clipboard-check-outline" size="20" />
            Hand-off checklist
          </h3>
          <p class="text-body-2 text-medium-emphasis mb-3">Complete before handing over the vehicle.</p>
          <v-list density="compact" class="pa-0">
            <v-list-item v-for="item in handoffItems" :key="item.id" class="px-0">
              <template #prepend>
                <v-checkbox v-model="handoffChecked[item.id]" hide-details density="compact" color="primary" />
              </template>
              <v-list-item-title class="text-body-2">{{ item.label }}</v-list-item-title>
            </v-list-item>
          </v-list>
        </v-card-text>
      </v-card>
      <v-card elevation="0" rounded="lg" class="modern-card mb-4">
        <v-card-text class="pa-4">
          <h3 class="text-subtitle-1 font-weight-bold mb-2 d-flex align-center gap-3">
            <v-icon icon="mdi-clipboard-check-outline" size="20" />
            Return checklist
          </h3>
          <p class="text-body-2 text-medium-emphasis mb-3">Complete when the renter returns the vehicle.</p>
          <v-list density="compact" class="pa-0">
            <v-list-item v-for="item in returnItems" :key="item.id" class="px-0">
              <template #prepend>
                <v-checkbox v-model="returnChecked[item.id]" hide-details density="compact" color="primary" />
              </template>
              <v-list-item-title class="text-body-2">{{ item.label }}</v-list-item-title>
            </v-list-item>
          </v-list>
        </v-card-text>
      </v-card>
      <v-card elevation="0" rounded="lg" class="modern-card mb-4">
        <v-card-text class="pa-4">
          <h3 class="text-subtitle-1 font-weight-bold mb-2 d-flex align-center gap-3">
            <v-icon icon="mdi-camera" size="20" />
            Photos
          </h3>
          <p class="text-body-2 text-medium-emphasis mb-2">Optional: before/after photos for dispute protection.</p>
          <v-btn variant="outlined" size="small" rounded="lg" prepend-icon="mdi-camera" @click="onUploadPhotos">Upload photos</v-btn>
        </v-card-text>
      </v-card>
    </template>

    <p v-if="!booking" class="text-center text-medium-emphasis py-8">Booking not found.</p>
  </DashboardTemplate>
</template>

<script setup lang="ts">
import { computed, ref, watch } from 'vue'
import { useRoute, useRouter } from 'vue-router'
import DashboardTemplate from '@/components/DashboardTemplate.vue'
import HpaStatusBadge from '@/components/base/HpaStatusBadge.vue'
import { formatPrice } from '@/utils/priceFormat'
import { useToastStore } from '@/stores/toast'
import { useCarOwnerBookingsStore } from '@/stores/carOwnerBookings'
import { rentalModeLabel, minRentalChipText } from '@/constants/vehicleSeed'
import { useVehicles } from '@/composables/useVehicles'

const route = useRoute()
const router = useRouter()
const toast = useToastStore()
const carOwnerBookings = useCarOwnerBookingsStore()
const { vehicles: vehiclesList } = useVehicles()

const booking = computed(() => carOwnerBookings.getById(route.params.id as string) ?? null)

/** Resolve full vehicle for this booking (for rental mode / min rental display). */
const bookingVehicle = computed(() => {
  const b = booking.value
  if (!b) return null
  if (b.vehicleId) {
    const v = vehiclesList.value.find(x => x.id === b.vehicleId)
    if (v) return v
  }
  const name = (b.vehicleName || '').trim()
  return vehiclesList.value.find(v => (v.name || '').trim().toLowerCase() === name.toLowerCase()) ?? null
})

/** Duration between booking start and end (calendar days from date strings). */
const bookingDurationText = computed(() => {
  const b = booking.value
  if (!b?.start || !b?.end) return '—'
  const startMs = new Date(b.start).getTime()
  const endMs = new Date(b.end).getTime()
  if (isNaN(startMs) || isNaN(endMs)) return '—'
  const dayMs = 24 * 60 * 60 * 1000
  const days = Math.max(1, Math.round((endMs - startMs) / dayMs) + 1)
  return days === 1 ? '1 day' : `${days} days`
})

const bookingDurationHours = computed(() => {
  const b = booking.value
  if (!b?.start || !b?.end) return 0
  const startMs = new Date(b.start).getTime()
  const endMs = new Date(b.end).getTime()
  if (isNaN(startMs) || isNaN(endMs)) return 0
  return Math.round((endMs - startMs) / (60 * 60 * 1000))
})

/** Vehicle image: from booking (DB), or fleet lookup by id/name, or placeholder. */
const bookingImageUrl = computed(() => {
  const b = booking.value
  if (!b) return ''
  if (b.vehicleImage?.trim()) return b.vehicleImage.trim()
  if (b.vehicleId) {
    const v = vehiclesList.value.find(x => x.id === b.vehicleId)
    if (v?.image) return v.image
  }
  const name = (b.vehicleName || '').trim()
  const byName = vehiclesList.value.find(v => (v.name || '').trim().toLowerCase() === name.toLowerCase())
  if (byName?.image) return byName.image
  return `https://picsum.photos/seed/${encodeURIComponent(name || 'car')}/400/280`
})

const handoffItems = [
  { id: 'id', label: 'Verify renter ID' },
  { id: 'fuel', label: 'Note fuel level' },
  { id: 'damage', label: 'Check for existing damage (photos if any)' },
  { id: 'keys', label: 'Hand over keys and documents' },
]
const returnItems = [
  { id: 'fuel', label: 'Check fuel level' },
  { id: 'inspect', label: 'Inspect for new damage' },
  { id: 'keys', label: 'Collect keys and documents' },
]

const handoffChecked = ref<Record<string, boolean>>({})
const returnChecked = ref<Record<string, boolean>>({})

watch(booking, (b) => {
  if (!b) return
  handoffChecked.value = handoffItems.reduce((acc, i) => ({ ...acc, [i.id]: false }), {})
  returnChecked.value = returnItems.reduce((acc, i) => ({ ...acc, [i.id]: false }), {})
}, { immediate: true })

function onUploadPhotos() {
  toast.info('Photo upload coming soon. For now, keep photos on your device.')
}

function getStatusVariant(s: string): 'success' | 'warning' | 'error' | 'info' | 'neutral' | 'pending' {
  const map: Record<string, 'success' | 'warning' | 'error' | 'info' | 'neutral' | 'pending'> = {
    Requested: 'pending', Confirmed: 'success', Active: 'info', Completed: 'neutral', Declined: 'error',
  }
  return map[s] ?? 'neutral'
}

function markHandedOver() {
  const b = booking.value
  if (!b) return
  carOwnerBookings.setStatus(b.id, 'Active')
  toast.success('Marked as handed over.')
}

function markReturned() {
  const b = booking.value
  if (!b) return
  carOwnerBookings.setStatus(b.id, 'Completed')
  toast.success('Marked as returned.')
  router.push({ name: 'car-owner-bookings' })
}
</script>

<style scoped>
.booking-detail-image-wrap {
  border-radius: var(--radius-lg, 12px);
  overflow: hidden;
  border: 1px solid var(--border-subtle, #e2e8f0);
}
.booking-detail-image {
  display: block;
}
.booking-detail-actions {
  display: flex;
  flex-wrap: wrap;
  gap: 1rem;
}

.booking-duration-text {
  font-weight: 600;
  color: rgb(var(--v-theme-primary));
}

.booking-duration-hours {
  font-size: 0.9em;
  color: rgba(var(--v-theme-on-surface), 0.72);
}
</style>
