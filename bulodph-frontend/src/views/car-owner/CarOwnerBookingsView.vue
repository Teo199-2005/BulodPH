<template>
  <DashboardTemplate title="Bookings" subtitle="Hand-offs and trip history" :animate="true">
    <v-select
      v-model="filterVehicle"
      :items="vehicleFilterOptions"
      label="Filter by vehicle"
      density="compact"
      hide-details
      variant="outlined"
      class="mb-4 max-w-260"
    />

    <v-tabs v-model="tab" color="primary" class="mb-4">
      <v-tab value="requested">
        <v-icon start size="18">mdi-clock-outline</v-icon>
        Requested
      </v-tab>
      <v-tab value="upcoming">
        <v-icon start size="18">mdi-calendar-clock</v-icon>
        Upcoming
      </v-tab>
      <v-tab value="completed">
        <v-icon start size="18">mdi-check-circle</v-icon>
        Completed
      </v-tab>
    </v-tabs>

    <div ref="bookingsListRef" class="car-owner-bookings-list">
    <v-window v-model="tab">
      <v-window-item value="requested">
        <v-card v-for="b in requestedFiltered" :key="b.id" elevation="0" rounded="lg" class="modern-card mb-3">
          <v-card-text class="pa-4">
            <div class="d-flex align-center justify-space-between flex-wrap car-owner-booking-row">
              <div class="car-owner-booking-thumb-wrap">
                <v-img
                  :src="getVehicleImage(b)"
                  :alt="b.vehicleName"
                  width="100"
                  height="70"
                  cover
                  rounded="lg"
                  class="car-owner-booking-thumb"
                />
              </div>
              <div class="car-owner-booking-info">
                <div class="font-weight-bold">{{ b.vehicleName }}</div>
                <div class="text-caption car-owner-booking-meta">{{ b.renterName }} · {{ b.renterPhone || '—' }} · {{ b.start }} – {{ b.end }}</div>
                <v-chip :color="getStatusColor(b.status)" :prepend-icon="getStatusIcon(b.status)" size="small" variant="tonal" class="car-owner-booking-chip">{{ b.status }}</v-chip>
              </div>
              <v-btn variant="outlined" size="small" rounded="lg" prepend-icon="mdi-eye" :to="{ name: 'car-owner-booking-detail', params: { id: b.id } }">
                View
              </v-btn>
            </div>
          </v-card-text>
        </v-card>
        <v-card v-if="!requestedFiltered.length" elevation="0" rounded="lg" class="modern-card">
          <v-card-text class="pa-4">
            <HpaEmptyState title="No new bookings" description="When a booking is made, you'll get a notification and it will appear here. You can view details only; approval is handled by the platform." icon="mdi-inbox" />
          </v-card-text>
        </v-card>
      </v-window-item>
      <v-window-item value="upcoming">
        <v-card v-for="b in upcomingFiltered" :key="b.id" elevation="0" rounded="lg" class="modern-card mb-3">
          <v-card-text class="pa-4">
            <div class="d-flex align-center justify-space-between flex-wrap car-owner-booking-row">
              <div class="car-owner-booking-thumb-wrap">
                <v-img
                  :src="getVehicleImage(b)"
                  :alt="b.vehicleName"
                  width="100"
                  height="70"
                  cover
                  rounded="lg"
                  class="car-owner-booking-thumb"
                />
              </div>
              <div class="car-owner-booking-info">
                <div class="font-weight-bold">{{ b.vehicleName }}</div>
                <div class="text-caption car-owner-booking-meta">{{ b.renterName }} · {{ b.renterPhone || '—' }} · {{ b.start }} – {{ b.end }}</div>
                <div class="d-flex align-center gap-2 flex-wrap car-owner-booking-chips">
                  <v-chip :color="getStatusColor(b.status)" :prepend-icon="getStatusIcon(b.status)" size="small" variant="tonal">{{ b.status }}</v-chip>
                  <v-chip v-if="isHandoffSoon(b)" color="warning" size="small" variant="tonal" prepend-icon="mdi-clock-alert-outline">Hand-off in 24h</v-chip>
                </div>
              </div>
              <v-tooltip location="bottom">
                <template #activator="{ props: tooltipProps }">
                  <v-btn v-bind="tooltipProps" variant="outlined" size="small" rounded="lg" icon="mdi-eye" aria-label="View details" :to="{ name: 'car-owner-booking-detail', params: { id: b.id } }" />
                </template>
                View details
              </v-tooltip>
            </div>
          </v-card-text>
        </v-card>
        <v-card v-if="!upcomingFiltered.length" elevation="0" rounded="lg" class="modern-card">
          <v-card-text class="pa-4">
            <HpaEmptyState title="No upcoming hand-offs" description="Accepted bookings will appear here until hand-off and return." icon="mdi-calendar-blank-outline" />
          </v-card-text>
        </v-card>
      </v-window-item>
      <v-window-item value="completed">
        <v-card v-for="b in completedFiltered" :key="b.id" elevation="0" rounded="lg" class="modern-card mb-3">
          <v-card-text class="pa-4">
            <div class="d-flex align-center justify-space-between flex-wrap car-owner-booking-row">
              <div class="car-owner-booking-thumb-wrap">
                <v-img
                  :src="getVehicleImage(b)"
                  :alt="b.vehicleName"
                  width="100"
                  height="70"
                  cover
                  rounded="lg"
                  class="car-owner-booking-thumb"
                />
              </div>
              <div class="car-owner-booking-info">
                <div class="font-weight-bold">{{ b.vehicleName }}</div>
                <div class="text-caption car-owner-booking-meta">{{ b.renterName }} · {{ b.start }} – {{ b.end }} · {{ formatPrice(b.earnings) }}</div>
                <v-chip color="grey" size="small" variant="tonal" prepend-icon="mdi-flag-checkered" class="car-owner-booking-chip">Completed</v-chip>
              </div>
              <v-tooltip location="bottom">
                <template #activator="{ props: tooltipProps }">
                  <v-btn v-bind="tooltipProps" variant="text" size="small" icon="mdi-eye" aria-label="View details" :to="{ name: 'car-owner-booking-detail', params: { id: b.id } }" />
                </template>
                View details
              </v-tooltip>
            </div>
          </v-card-text>
        </v-card>
        <v-card v-if="!completedFiltered.length" elevation="0" rounded="lg" class="modern-card">
          <v-card-text class="pa-4">
            <HpaEmptyState title="No completed trips yet" description="Finished trips will appear here with earnings." icon="mdi-check-circle-outline" />
          </v-card-text>
        </v-card>
      </v-window-item>
    </v-window>
    </div>

  </DashboardTemplate>
</template>

<style scoped>
.car-owner-booking-row { gap: 20px 32px; }
.car-owner-booking-thumb-wrap {
  flex-shrink: 0;
}
.car-owner-booking-thumb {
  border: 1px solid var(--border-subtle, #e2e8f0);
}
.car-owner-booking-info {
  display: flex;
  flex-direction: column;
  gap: 6px;
  flex: 1;
  min-width: 0;
  margin-left: 16px;
}
.car-owner-booking-meta { margin: 0; }
.car-owner-booking-chip,
.car-owner-booking-chips { margin-top: 4px; }
</style>

<script setup lang="ts">
import { ref, computed, onMounted } from 'vue'
import { useRoute } from 'vue-router'
import DashboardTemplate from '@/components/DashboardTemplate.vue'
import HpaEmptyState from '@/components/base/HpaEmptyState.vue'
import { formatPrice } from '@/utils/priceFormat'
import { useCarOwnerBookingsStore } from '@/stores/carOwnerBookings'
import { useToastStore } from '@/stores/toast'
import { useVehicles } from '@/composables/useVehicles'
import type { CarOwnerBooking } from '@/stores/carOwnerBookings'
import { useGsapStagger } from '@/composables/useGsapStagger'

const route = useRoute()
const bookingsListRef = ref<HTMLElement | null>(null)
useGsapStagger(bookingsListRef, { selector: '.modern-card.mb-3', y: 12, duration: 0.4, stagger: 0.05 })
const { vehicles: vehiclesList } = useVehicles()
const tab = ref('requested')
const filterVehicle = ref<string>('')
const carOwnerBookings = useCarOwnerBookingsStore()
const toast = useToastStore()

onMounted(() => {
  const q = route.query.vehicle
  if (typeof q === 'string') filterVehicle.value = q
  carOwnerBookings.fetchFromApi()
})

const vehicleFilterOptions = computed(() => {
  const names = new Set<string>()
  carOwnerBookings.list.forEach(b => names.add(b.vehicleName))
  return [{ title: 'All vehicles', value: '' }, ...Array.from(names).map(n => ({ title: n, value: n }))]
})

function filterList(list: CarOwnerBooking[]) {
  if (!filterVehicle.value) return list
  return list.filter(b => b.vehicleName === filterVehicle.value)
}

const requestedFiltered = computed(() => filterList(carOwnerBookings.requested))
const upcomingFiltered = computed(() => filterList(carOwnerBookings.upcoming))
const completedFiltered = computed(() => filterList(carOwnerBookings.completed))

function isHandoffSoon(b: CarOwnerBooking): boolean {
  try {
    const start = new Date(b.start)
    const now = new Date()
    const diffHours = (start.getTime() - now.getTime()) / (1000 * 60 * 60)
    return diffHours > 0 && diffHours <= 24
  } catch {
    return false
  }
}

function getStatusColor(s: string) {
  const map: Record<string, string> = { Requested: 'warning', Confirmed: 'success', Active: 'info', Completed: 'grey', Declined: 'error' }
  return map[s] ?? 'grey'
}

function getStatusIcon(s: string): string {
  const map: Record<string, string> = {
    Requested: 'mdi-clock-outline',
    Confirmed: 'mdi-check-circle',
    Active: 'mdi-play-circle',
    Completed: 'mdi-flag-checkered',
    Declined: 'mdi-close-circle',
  }
  return map[s] ?? 'mdi-circle-outline'
}

/** Use image from database when present; otherwise resolve from fleet by id/name; fallback placeholder. */
function getVehicleImage(b: CarOwnerBooking): string {
  if (b.vehicleImage && b.vehicleImage.trim()) return b.vehicleImage.trim()
  if (b.vehicleId) {
    const byId = vehiclesList.value.find(v => v.id === b.vehicleId)
    if (byId?.image) return byId.image
  }
  const name = (b.vehicleName || '').trim()
  const byName = vehiclesList.value.find(v => (v.name || '').trim().toLowerCase() === name.toLowerCase())
  if (byName?.image) return byName.image
  return `https://picsum.photos/seed/${encodeURIComponent(name || 'car')}/400/280`
}
</script>

