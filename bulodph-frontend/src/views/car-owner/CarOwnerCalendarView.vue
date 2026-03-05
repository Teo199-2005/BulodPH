<template>
  <DashboardTemplate title="Calendar" subtitle="Availability and bookings" :animate="true">
    <v-card elevation="0" rounded="lg" class="calendar-card modern-card">
      <!-- Calendar header: BulodPH + month navigator -->
      <div class="calendar-card__header">
        <div class="calendar-card__brand">
          <img src="/logo.png" alt="BulodPH" class="calendar-card__logo" onerror="this.style.display='none'" />
          <span class="calendar-card__title">BulodPH</span>
          <span class="calendar-card__subtitle">Availability &amp; bookings</span>
        </div>
        <div class="calendar-card__month-nav">
          <v-tooltip location="bottom">
            <template #activator="{ props: tooltipProps }">
              <v-btn v-bind="tooltipProps" icon variant="text" size="small" aria-label="Previous month" @click="prevMonth">
                <v-icon>mdi-chevron-left</v-icon>
              </v-btn>
            </template>
            Previous month
          </v-tooltip>
          <span class="calendar-card__month-label">{{ monthLabel }}</span>
          <v-tooltip location="bottom">
            <template #activator="{ props: tooltipProps }">
              <v-btn v-bind="tooltipProps" icon variant="text" size="small" aria-label="Next month" @click="nextMonth">
                <v-icon>mdi-chevron-right</v-icon>
              </v-btn>
            </template>
            Next month
          </v-tooltip>
        </div>
      </div>

      <v-divider />

      <v-card-text class="pa-4">
        <div class="d-flex align-center justify-space-between flex-wrap gap-3 mb-3">
          <v-select
            v-model="selectedVehicle"
            :items="vehicleOptions"
            label="Vehicle"
            density="compact"
            hide-details
            variant="outlined"
            class="calendar-vehicle-select max-w-220"
          />
          <div class="calendar-legend-row">
            <div class="calendar-legend-item">
              <span class="calendar-legend calendar-legend--today" aria-hidden="true" />
              <span class="calendar-legend-label">Today</span>
            </div>
            <div class="calendar-legend-item">
              <span class="calendar-legend calendar-legend--requested" aria-hidden="true" />
              <span class="calendar-legend-label">Pending</span>
            </div>
            <div class="calendar-legend-item">
              <span class="calendar-legend calendar-legend--confirmed" aria-hidden="true" />
              <span class="calendar-legend-label">Confirmed</span>
            </div>
            <div class="calendar-legend-item">
              <span class="calendar-legend calendar-legend--completed" aria-hidden="true" />
              <span class="calendar-legend-label">Completed</span>
            </div>
          </div>
        </div>

        <!-- Calendar grid -->
        <div class="calendar-grid">
          <div class="calendar-grid__weekdays">
            <span v-for="d in dayLabels" :key="d" class="calendar-grid__weekday">{{ d }}</span>
          </div>
          <div class="calendar-grid__body">
            <template v-for="(week, wi) in weeks" :key="wi">
              <div
                v-for="(day, di) in week"
                :key="day?.date ?? `w${wi}-${di}`"
                class="calendar-grid__cell"
                :class="{
                  'calendar-grid__cell--empty': !day,
                  'calendar-grid__cell--has-bookings': day?.bookings?.length,
                  'calendar-grid__cell--today': day?.date === todayStr,
                  'calendar-grid__cell--selected': selectedDate === day?.date,
                }"
                @click="day ? selectDate(day.date) : null"
              >
                <template v-if="day">
                  <span class="calendar-grid__day-num">{{ day.day }}</span>
                  <!-- Single booking: fill the whole day cell -->
                  <div
                    v-if="day.bookings.length === 1"
                    class="calendar-day__single"
                    :class="`calendar-day__single--${day.bookings[0].status.toLowerCase()}`"
                    :title="`${day.bookings[0].vehicleName} · ${day.bookings[0].status}`"
                  >
                    <img
                      :src="getVehicleImage(day.bookings[0].vehicleName)"
                      :alt="day.bookings[0].vehicleName"
                      class="calendar-day__single-img"
                    />
                  </div>
                  <!-- Multiple bookings: minimalist indicator only -->
                  <div v-else-if="day.bookings.length > 1" class="calendar-day__multi">
                    <span class="calendar-day__multi-dot" :class="`calendar-day__multi-dot--${day.bookings[0].status.toLowerCase()}`" />
                    <span class="calendar-day__multi-label">View {{ day.bookings.length }} booking{{ day.bookings.length > 1 ? 's' : '' }}</span>
                  </div>
                </template>
              </div>
            </template>
          </div>
        </div>

        <!-- Booking details panel when a date is selected -->
        <div v-if="selectedDate" class="calendar-details mt-4">
          <div class="d-flex align-center justify-space-between mb-2">
            <h3 class="text-subtitle-1 font-weight-bold mb-0">Bookings on {{ selectedDateLabel }}</h3>
            <v-tooltip location="bottom">
              <template #activator="{ props: tooltipProps }">
                <v-btn v-bind="tooltipProps" icon variant="text" size="small" aria-label="Clear date selection" @click="selectedDate = null">
                  <v-icon>mdi-close</v-icon>
                </v-btn>
              </template>
              Clear date selection
            </v-tooltip>
          </div>
          <v-list v-if="bookingsOnSelectedDate.length" class="calendar-details__list rounded-lg">
            <v-list-item
              v-for="b in bookingsOnSelectedDate"
              :key="b.id"
              class="calendar-details__item"
              :to="{ name: 'car-owner-booking-detail', params: { id: b.id } }"
            >
              <template #prepend>
                <div class="calendar-details__thumb-wrap">
                  <img :src="getVehicleImage(b.vehicleName)" :alt="b.vehicleName" class="calendar-details__thumb" />
                </div>
              </template>
              <v-list-item-title class="font-weight-medium">{{ b.vehicleName }}</v-list-item-title>
              <v-list-item-subtitle>
                {{ b.renterName }} · {{ b.start }} – {{ b.end }}
              </v-list-item-subtitle>
              <v-list-item-subtitle class="mt-1">
                <v-chip :color="getStatusColor(b.status)" :prepend-icon="getStatusIcon(b.status)" size="x-small" variant="tonal" class="mr-2">{{ b.status }}</v-chip>
                Payment: {{ getPaymentLabel(b) }} · {{ formatPrice(b.earnings || 0) }} earned
              </v-list-item-subtitle>
              <template #append>
                <v-icon>mdi-chevron-right</v-icon>
              </template>
            </v-list-item>
          </v-list>
          <p v-else class="text-body-2 text-medium-emphasis mb-0">No bookings on this date.</p>
        </div>
      </v-card-text>
    </v-card>
  </DashboardTemplate>
</template>

<script setup lang="ts">
import { ref, computed } from 'vue'
import DashboardTemplate from '@/components/DashboardTemplate.vue'
import { formatPrice } from '@/utils/priceFormat'
import { useCarOwnerBookingsStore } from '@/stores/carOwnerBookings'
import { useVehicles } from '@/composables/useVehicles'
import { getStoredVehiclesForCurrentUser, storageRefreshTrigger } from '@/composables/useCarOwnerVehiclePersistence'
import { useUserSessionStore } from '@/stores/userSession'
import type { CarOwnerBooking } from '@/stores/carOwnerBookings'

const DEFAULT_CAR_IMG = 'https://images.unsplash.com/photo-1544636331-e26879cd4d9b?w=200&q=80&fit=crop'

const carOwnerBookings = useCarOwnerBookingsStore()
const { vehicles: allVehicles } = useVehicles()
const userSession = useUserSessionStore()

const vehiclesByName = computed(() => {
  storageRefreshTrigger.value
  const fromApi = allVehicles.value
  const stored = getStoredVehiclesForCurrentUser()
  const map = new Map<string, { image: string }>()
  ;[...fromApi, ...stored].forEach(v => {
    if (v.name && !map.has(v.name)) map.set(v.name, { image: v.image || DEFAULT_CAR_IMG })
  })
  return map
})

function getVehicleImage(vehicleName: string): string {
  return vehiclesByName.value.get(vehicleName)?.image ?? DEFAULT_CAR_IMG
}

const vehicleOptions = computed(() => {
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
  const names = [...new Set(merged.map(v => v.name))]
  return [{ title: 'All vehicles', value: '' }, ...names.map(n => ({ title: n, value: n }))]
})

const selectedVehicle = ref('')
const selectedDate = ref<string | null>(null)

const todayStr = computed(() => {
  const d = new Date()
  return `${d.getFullYear()}-${String(d.getMonth() + 1).padStart(2, '0')}-${String(d.getDate()).padStart(2, '0')}`
})

/** Parse "Feb 10, 2026" to YYYY-MM-DD for comparison */
function parseBookingDate(s: string): string | null {
  try {
    const d = new Date(s)
    if (isNaN(d.getTime())) return null
    return `${d.getFullYear()}-${String(d.getMonth() + 1).padStart(2, '0')}-${String(d.getDate()).padStart(2, '0')}`
  } catch {
    return null
  }
}

/** All bookings that span a given date (YYYY-MM-DD) */
const bookingsByDate = computed(() => {
  const map = new Map<string, CarOwnerBooking[]>()
  const filterName = selectedVehicle.value
  const bookings = carOwnerBookings.upcoming.concat(carOwnerBookings.completed).concat(carOwnerBookings.requested)
  const list = filterName ? bookings.filter(b => b.vehicleName === filterName) : bookings
  list.forEach(b => {
    const start = parseBookingDate(b.start)
    const end = parseBookingDate(b.end)
    if (!start || !end) return
    const startD = new Date(start)
    const endD = new Date(end)
    for (let d = new Date(startD); d <= endD; d.setDate(d.getDate() + 1)) {
      const key = d.toISOString().slice(0, 10)
      if (!map.has(key)) map.set(key, [])
      map.get(key)!.push(b)
    }
  })
  return map
})


const bookingsOnSelectedDate = computed(() => {
  if (!selectedDate.value) return []
  return bookingsByDate.value.get(selectedDate.value) ?? []
})

const selectedDateLabel = computed(() => {
  if (!selectedDate.value) return ''
  const [y, m, d] = selectedDate.value.split('-')
  const date = new Date(parseInt(y, 10), parseInt(m, 10) - 1, parseInt(d, 10))
  return date.toLocaleDateString('en-PH', { weekday: 'short', month: 'short', day: 'numeric', year: 'numeric' })
})

function selectDate(dateStr: string) {
  selectedDate.value = dateStr
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

function getPaymentLabel(b: CarOwnerBooking) {
  if (b.status === 'Completed') return 'Paid'
  if (b.status === 'Requested') return 'Pending'
  return 'Paid'
}

const dayLabels = ['Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat']

const currentMonth = ref(new Date())
const year = computed(() => currentMonth.value.getFullYear())
const month = computed(() => currentMonth.value.getMonth())

const monthLabel = computed(() => currentMonth.value.toLocaleDateString('en-PH', { month: 'long', year: 'numeric' }))

function prevMonth() {
  currentMonth.value = new Date(year.value, month.value - 1, 1)
}
function nextMonth() {
  currentMonth.value = new Date(year.value, month.value + 1, 1)
}

const weeks = computed(() => {
  const first = new Date(year.value, month.value, 1)
  const last = new Date(year.value, month.value + 1, 0)
  const startDay = first.getDay()
  const daysInMonth = last.getDate()
  const padStart = startDay
  const byDate = bookingsByDate.value
  const grid: { day: number; date: string; bookings: CarOwnerBooking[] }[] = []
  for (let i = 0; i < padStart; i++) grid.push(null as any)
  for (let d = 1; d <= daysInMonth; d++) {
    const dateStr = `${year.value}-${String(month.value + 1).padStart(2, '0')}-${String(d).padStart(2, '0')}`
    grid.push({
      day: d,
      date: dateStr,
      bookings: byDate.get(dateStr) ?? [],
    })
  }
  const result: ({ day: number; date: string; bookings: CarOwnerBooking[] } | null)[][] = []
  const rows = Math.ceil(grid.length / 7)
  for (let r = 0; r < rows; r++) {
    result.push(grid.slice(r * 7, (r + 1) * 7))
  }
  return result
})
</script>

<style scoped>
.calendar-card {
  overflow: hidden;
}
.calendar-card__header {
  display: flex;
  align-items: center;
  justify-content: space-between;
  flex-wrap: wrap;
  gap: 1rem;
  padding: 1rem 1.25rem;
  background: linear-gradient(135deg, rgba(30, 58, 95, 0.06) 0%, rgba(30, 58, 95, 0.02) 100%);
  border-bottom: 1px solid rgba(30, 58, 95, 0.08);
}
.calendar-card__brand {
  display: flex;
  align-items: center;
  gap: 0.75rem;
}
.calendar-card__logo {
  height: 36px;
  width: auto;
  object-fit: contain;
}
.calendar-card__title {
  font-size: 1.25rem;
  font-weight: 800;
  color: var(--text-primary, #0f172a);
  letter-spacing: -0.02em;
}
.calendar-card__subtitle {
  font-size: 0.75rem;
  color: var(--text-secondary, #64748b);
  font-weight: 500;
  margin-left: 0.25rem;
}
.calendar-card__month-nav {
  display: flex;
  align-items: center;
  gap: 0.5rem;
}
.calendar-card__month-label {
  font-size: 1rem;
  font-weight: 700;
  color: var(--text-primary, #0f172a);
  min-width: 140px;
  text-align: center;
}

.calendar-vehicle-select { flex-shrink: 0; }

.calendar-grid {
  border: 1px solid rgba(30, 58, 95, 0.12);
  border-radius: 12px;
  overflow: hidden;
  background: var(--surface-1, #fff);
}
.calendar-grid__weekdays {
  display: grid;
  grid-template-columns: repeat(7, 1fr);
  background: rgba(30, 58, 95, 0.06);
  font-size: 0.6875rem;
  font-weight: 700;
  text-transform: uppercase;
  letter-spacing: 0.05em;
  color: var(--text-secondary, #64748b);
}
.calendar-grid__weekday {
  padding: 0.5rem 0.25rem;
  text-align: center;
  border-bottom: 1px solid rgba(30, 58, 95, 0.08);
}
.calendar-grid__weekday:not(:last-child) {
  border-right: 1px solid rgba(30, 58, 95, 0.06);
}
.calendar-grid__body {
  display: grid;
  grid-template-columns: repeat(7, 1fr);
  gap: 0;
}
.calendar-grid__cell {
  min-height: 72px;
  padding: 0.35rem;
  display: flex;
  flex-direction: column;
  align-items: center;
  justify-content: flex-start;
  border-bottom: 1px solid rgba(30, 58, 95, 0.06);
  border-right: 1px solid rgba(30, 58, 95, 0.06);
  font-size: 0.875rem;
  font-weight: 500;
  cursor: pointer;
  transition: background 0.15s ease;
}
.calendar-grid__cell:nth-child(7n) {
  border-right: none;
}
.calendar-grid__cell--empty {
  background: var(--surface-2, #f8fafc);
  cursor: default;
}
.calendar-grid__cell--has-bookings {
  background: rgba(30, 58, 95, 0.04);
}
.calendar-grid__cell--has-bookings:hover {
  background: rgba(30, 58, 95, 0.08);
}
.calendar-grid__cell--today {
  background: rgba(30, 58, 95, 0.08);
  font-weight: 700;
}
.calendar-grid__cell--today.calendar-grid__cell--has-bookings {
  background: rgba(30, 58, 95, 0.12);
}
.calendar-grid__cell--selected {
  outline: 2px solid rgb(var(--v-theme-primary));
  outline-offset: -2px;
  z-index: 1;
  background: rgba(var(--v-theme-primary), 0.1);
}
.calendar-grid__day-num {
  display: block;
  flex-shrink: 0;
  margin-bottom: 4px;
}

/* Single booking: fills the rest of the day cell */
.calendar-day__single {
  flex: 1;
  width: 100%;
  min-height: 0;
  border-radius: 8px;
  overflow: hidden;
  border: 2px solid transparent;
  box-shadow: 0 1px 3px rgba(0, 0, 0, 0.12);
}
.calendar-day__single--requested {
  border-color: #f59e0b;
}
.calendar-day__single--confirmed,
.calendar-day__single--active {
  border-color: #10b981;
}
.calendar-day__single--completed {
  border-color: #64748b;
}
.calendar-day__single--declined {
  border-color: #ef4444;
}
.calendar-day__single-img {
  width: 100%;
  height: 100%;
  min-height: 32px;
  object-fit: cover;
  display: block;
}

/* Multiple bookings: minimal indicator */
.calendar-day__multi {
  display: flex;
  align-items: center;
  justify-content: center;
  gap: 4px;
  width: 100%;
  padding: 2px 4px;
  flex-shrink: 0;
}
.calendar-day__multi-dot {
  width: 8px;
  height: 8px;
  border-radius: 50%;
  flex-shrink: 0;
}
.calendar-day__multi-dot--requested {
  background: #f59e0b;
}
.calendar-day__multi-dot--confirmed,
.calendar-day__multi-dot--active {
  background: #10b981;
}
.calendar-day__multi-dot--completed {
  background: #64748b;
}
.calendar-day__multi-dot--declined {
  background: #ef4444;
}
.calendar-day__multi-label {
  font-size: 0.625rem;
  font-weight: 600;
  color: var(--text-secondary, #64748b);
  white-space: nowrap;
  overflow: hidden;
  text-overflow: ellipsis;
  max-width: 100%;
}

/* Legend: aligned icon + label per item */
.calendar-legend-row {
  display: flex;
  align-items: center;
  flex-wrap: wrap;
  gap: 1rem 1.25rem;
}
.calendar-legend-item {
  display: inline-flex;
  align-items: center;
  gap: 0.375rem;
  line-height: 1;
}
.calendar-legend {
  width: 12px;
  height: 12px;
  min-width: 12px;
  min-height: 12px;
  border-radius: 3px;
  flex-shrink: 0;
  display: inline-block;
  vertical-align: middle;
}
.calendar-legend-label {
  font-size: 0.75rem;
  font-weight: 500;
  color: var(--text-secondary, #64748b);
  white-space: nowrap;
}
.calendar-legend--today {
  background: rgba(30, 58, 95, 0.4);
  border: 1px solid rgba(30, 58, 95, 0.3);
}
.calendar-legend--requested {
  background: #f59e0b;
}
.calendar-legend--confirmed {
  background: #10b981;
}
.calendar-legend--completed {
  background: #64748b;
}

.calendar-details {
  padding: 1rem;
  border-radius: 12px;
  background: var(--surface-2, #f8fafc);
  border: 1px solid rgba(30, 58, 95, 0.1);
}
.calendar-details__list { background: transparent !important; }
.calendar-details__item {
  border-radius: 8px;
  margin-bottom: 4px;
}
.calendar-details__thumb-wrap {
  width: 40px;
  height: 40px;
  border-radius: 10px;
  overflow: hidden;
  flex-shrink: 0;
  background: var(--surface-2, #f1f5f9);
}
.calendar-details__thumb {
  width: 100%;
  height: 100%;
  object-fit: cover;
  display: block;
}
</style>
