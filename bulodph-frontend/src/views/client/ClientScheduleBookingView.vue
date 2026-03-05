<template>
  <DashboardTemplate title="Schedule booking" subtitle="Pick your dates and apply a promo—then continue to checkout." :animate="true" :back-to="backTo" back-label="Back">
    <LiabilityDisclaimerBanner dismiss-key="client-schedule-booking-liability-dismissed" />
    <v-card v-if="vehicle" elevation="0" rounded="lg" class="modern-card schedule-booking-card mb-4">
      <!-- Vehicle summary with proper image aspect ratio (16:9) -->
      <div class="schedule-booking__vehicle">
        <router-link :to="{ name: 'client-vehicle-detail', params: { id: vehicle.id } }" class="schedule-booking__vehicle-link">
          <div class="schedule-booking__image-wrap">
            <v-img :src="vehicle.image" cover class="schedule-booking__img" />
          </div>
          <div class="schedule-booking__vehicle-info">
            <h2 class="schedule-booking__vehicle-name">{{ vehicle.name }}</h2>
            <p class="schedule-booking__vehicle-meta">{{ vehicle.location }} · {{ formatPrice(vehicle.pricePerDay, { suffix: '/day' }) }}</p>
            <span class="text-caption text-primary">View vehicle details</span>
          </div>
        </router-link>
      </div>

      <v-card-text class="pa-4">
        <v-form ref="scheduleFormRef" @submit.prevent="submitSchedule">
        <h3 class="text-subtitle-1 font-weight-bold mb-3 d-flex align-center gap-2">
          <v-icon icon="mdi-calendar-edit" size="22" />
          Booking details
        </h3>
        <v-row dense>
          <v-col cols="12" sm="6">
            <v-text-field
              v-model="startDate"
              label="Start date *"
              type="date"
              variant="outlined"
              density="comfortable"
              :rules="[rules.required]"
              hide-details="auto"
              :min="today"
              class="schedule-field"
            />
          </v-col>
          <v-col cols="12" sm="6">
            <v-text-field
              v-model="endDate"
              label="End date *"
              type="date"
              variant="outlined"
              density="comfortable"
              :rules="[rules.required, rules.endDateAfterStart, rules.minRentalPeriod]"
              hide-details="auto"
              :min="startDate || today"
              class="schedule-field"
            />
          </v-col>
          <v-col cols="12" sm="6">
            <v-text-field
              v-model="pickupTime"
              label="Pickup time"
              type="time"
              variant="outlined"
              density="comfortable"
              hide-details
              class="schedule-field"
            />
          </v-col>
          <v-col cols="12" sm="6">
            <v-text-field
              v-model="returnTime"
              label="Return time"
              type="time"
              variant="outlined"
              density="comfortable"
              hide-details
              class="schedule-field"
            />
          </v-col>
          <v-col cols="12" sm="6">
            <v-text-field
              :model-value="passengers"
              @update:model-value="(v) => passengers = sanitizeQuantity(v, { min: 1, max: 99 })"
              label="Number of passengers"
              type="number"
              min="1"
              max="99"
              variant="outlined"
              density="comfortable"
              hide-details
              class="schedule-field"
            />
          </v-col>
          <v-col cols="12" sm="6">
            <v-text-field
              v-model="contactPhone"
              label="Contact phone for this trip"
              placeholder="09XX XXX XXXX"
              variant="outlined"
              density="comfortable"
              hide-details
              class="schedule-field"
            />
          </v-col>
          <v-col cols="12">
            <v-text-field
              v-model="meetUp"
              label="Meet-up location / notes *"
              placeholder="e.g. Cauayan city plaza, or I'll message the rental"
              variant="outlined"
              density="comfortable"
              :rules="[rules.required, rules.minLength(3)]"
              hide-details="auto"
              class="schedule-field"
            />
          </v-col>
          <v-col cols="12">
            <v-textarea
              v-model="specialRequests"
              label="Special requests (optional)"
              placeholder="e.g. child seat needed, luggage space, accessibility"
              variant="outlined"
              density="comfortable"
              rows="2"
              hide-details
              class="schedule-field"
            />
          </v-col>
        </v-row>

        <!-- Clear day & time summary so clients see what they booked -->
        <div v-if="startDate && endDate && days > 0" class="booking-summary-indicator mt-4">
          <div class="booking-summary-indicator__label">
            <v-icon icon="mdi-calendar-check" size="20" class="mr-1" />
            You're booking
          </div>
          <div class="booking-summary-indicator__dates">
            {{ bookingDateRangeText }}
          </div>
          <div class="booking-summary-indicator__meta">
            <span>{{ bookingTimesText }}</span>
          </div>
          <div v-if="hasDuration" class="booking-summary-indicator__total">
            Total: <strong>{{ bookingDurationText }}</strong>
          </div>
        </div>
        </v-form>
      </v-card-text>
    </v-card>

    <!-- Promo code – separate container, marketable -->
    <v-card v-if="vehicle" elevation="0" rounded="lg" class="modern-card promo-voucher-card mb-4">
      <v-card-text class="pa-4">
        <div class="promo-voucher__header">
          <v-icon icon="mdi-tag-percent" size="28" class="promo-voucher__icon" />
          <div>
            <h3 class="promo-voucher__title">Got a voucher or promo code?</h3>
            <p class="promo-voucher__subtitle">Enter it below to get a discount on your booking.</p>
          </div>
        </div>
        <div class="promo-voucher__input-row">
          <v-text-field
            v-model="promoCode"
            placeholder="e.g. BULOD10"
            variant="outlined"
            density="comfortable"
            hide-details
            class="promo-voucher__input ma-0"
            @blur="applyPromo"
          >
            <template #prepend-inner>
              <v-icon icon="mdi-ticket-percent" size="20" class="text-medium-emphasis" />
            </template>
          </v-text-field>
          <v-btn
            color="primary"
            variant="flat"
            rounded="lg"
            class="promo-voucher__apply"
            @click="applyPromo"
          >
            Apply
          </v-btn>
        </div>
        <div v-if="discountAmount > 0" ref="promoSuccessRef" class="promo-voucher__success mt-2">
          <v-icon icon="mdi-check-circle" size="18" color="success" />
          <span>10% off 1 day applied. You're saving {{ formatPrice(discountAmount) }}!</span>
        </div>
        <p v-else-if="promoCode.trim().toUpperCase() === 'BULOD10' && days < 3" class="text-caption text-medium-emphasis mt-2 mb-0">
          BULOD10 is valid for 3-day minimum bookings. Book at least 3 days to get 10% off.
        </p>
      </v-card-text>
    </v-card>

    <!-- Price summary – separate container, clear totals + voucher-applied styling -->
    <v-card v-if="vehicle" elevation="0" rounded="lg" class="modern-card price-summary-card mb-4" :class="{ 'price-summary-card--voucher-applied': discountAmount > 0 }">
      <v-card-text class="pa-4">
        <h3 class="price-summary__title d-flex align-center gap-2">
          <v-icon icon="mdi-cash-multiple" size="20" />
          Price summary
        </h3>
        <div class="price-summary__rows">
          <div class="price-summary__row">
            <span>{{ vehicle.name }} · {{ days }} day(s)</span>
            <span>{{ formatPrice(subtotal) }}</span>
          </div>
          <div v-if="discountAmount > 0" class="price-summary__row price-summary__row--discount">
            <span>
              <v-icon icon="mdi-tag-check" size="16" class="mr-1" />
              Promo (10% off 1 day)
            </span>
            <span class="price-summary__savings">-{{ formatPrice(discountAmount) }}</span>
          </div>
        </div>
        <v-divider class="my-3" />
        <div class="price-summary__total">
          <span>Total</span>
          <span class="price-summary__total-amount">{{ formatPrice(total) }}</span>
        </div>
        <p v-if="days === 0" class="text-caption text-medium-emphasis mt-2 mb-0">Select start and end dates to see total.</p>
        <p v-else class="text-caption text-medium-emphasis mt-2 mb-0">Minimum rental: {{ minRentalDisplayText }}.</p>
      </v-card-text>
    </v-card>

    <div class="d-flex justify-end align-center mt-4 gap-relaxed-lg">
      <v-btn variant="outlined" rounded="lg" prepend-icon="mdi-close" :to="backTo">Cancel</v-btn>
      <v-btn color="primary" rounded="lg" size="large" prepend-icon="mdi-arrow-right" :disabled="!canProceed" @click="submitSchedule">
        Continue to checkout
      </v-btn>
    </div>

    <p v-if="!vehicle" class="text-center text-medium-emphasis py-8">Select a vehicle from Browse first.</p>
  </DashboardTemplate>
</template>

<script setup lang="ts">
import { ref, computed, watch, nextTick } from 'vue'
import { useRoute, useRouter } from 'vue-router'
import DashboardTemplate from '@/components/DashboardTemplate.vue'
import LiabilityDisclaimerBanner from '@/components/LiabilityDisclaimerBanner.vue'
import { formatPrice } from '@/utils/priceFormat'
import { sanitizeDiscountPercent, sanitizeQuantity, sanitizePrice } from '@/utils/numericValidation'
import { useVehicles } from '@/composables/useVehicles'
import { useCartStore } from '@/stores/cart'

const route = useRoute()
const router = useRouter()
const cartStore = useCartStore()
const { vehicles: vehiclesList } = useVehicles()

const vehicles = computed(() =>
  Object.fromEntries(
    vehiclesList.value.map((v) => [
      v.id,
      {
        id: v.id,
        name: v.name,
        location: v.location,
        pricePerDay: v.pricePerDay,
        image: v.image,
      },
    ])
  )
)

const vehicleId = computed(() => route.query.vehicleId as string)
const vehicle = computed(() => vehicleId.value ? vehicles.value[vehicleId.value] ?? null : null)

const today = computed(() => new Date().toISOString().slice(0, 10))
const startDate = ref('')
const endDate = ref('')
const pickupTime = ref('')
const returnTime = ref('')
const passengers = ref<number>(1)
const contactPhone = ref('')
const meetUp = ref('')
const specialRequests = ref('')
const promoCode = ref('')
const discountPercent = ref(0)

const days = computed(() => {
  if (!startDate.value || !endDate.value) return 0
  const s = new Date(startDate.value).getTime()
  const e = new Date(endDate.value).getTime()
  return Math.max(1, Math.ceil((e - s) / (24 * 60 * 60 * 1000)) + 1)
})

const opts = { month: 'short' as const, day: 'numeric' as const, year: 'numeric' as const }
const bookingDateRangeText = computed(() => {
  if (!startDate.value || !endDate.value) return ''
  const start = new Date(startDate.value)
  const end = new Date(endDate.value)
  if (isNaN(start.getTime()) || isNaN(end.getTime())) return ''
  return `${start.toLocaleDateString('en-PH', opts)} – ${end.toLocaleDateString('en-PH', opts)}`
})

function formatTime12h(timeStr: string): string {
  if (!timeStr || !/^\d{1,2}:\d{2}$/.test(timeStr)) return '—'
  const [h, m] = timeStr.split(':').map(Number)
  const hour = h % 12 || 12
  const ampm = h < 12 ? 'AM' : 'PM'
  return `${hour}:${String(m).padStart(2, '0')} ${ampm}`
}

const bookingTimesText = computed(() => {
  const pickup = formatTime12h(pickupTime.value)
  const ret = formatTime12h(returnTime.value)
  return `Pickup ${pickup} · Return ${ret}`
})

/** Total duration from start date+pickup time to end date+return time (e.g. "3 days and 8 hours"). */
const bookingDurationText = computed(() => {
  if (!startDate.value || !endDate.value) return ''
  const startStr = startDate.value + 'T' + (pickupTime.value || '00:00')
  const endStr = endDate.value + 'T' + (returnTime.value || '23:59')
  const startMs = new Date(startStr).getTime()
  const endMs = new Date(endStr).getTime()
  if (isNaN(startMs) || isNaN(endMs)) return ''
  const totalMs = Math.max(0, endMs - startMs)
  const dayMs = 24 * 60 * 60 * 1000
  let d = Math.floor(totalMs / dayMs)
  let h = Math.round((totalMs % dayMs) / (60 * 60 * 1000))
  if (h === 24) { d += 1; h = 0 }
  const daysPart = d > 0 ? `${d} day${d === 1 ? '' : 's'}` : ''
  const hoursPart = h > 0 ? `${h} hour${h === 1 ? '' : 's'}` : ''
  if (daysPart && hoursPart) return `${daysPart} and ${hoursPart}`
  return daysPart || hoursPart || '0 hours'
})

/** Booking duration in hours (for min rental validation). */
const bookingDurationHours = computed(() => {
  if (!startDate.value || !endDate.value) return 0
  const startStr = startDate.value + 'T' + (pickupTime.value || '00:00')
  const endStr = endDate.value + 'T' + (returnTime.value || '23:59')
  const startMs = new Date(startStr).getTime()
  const endMs = new Date(endStr).getTime()
  if (isNaN(startMs) || isNaN(endMs)) return 0
  return Math.max(0, Math.round((endMs - startMs) / (60 * 60 * 1000)))
})

/** Vehicle minimum rental in hours (default 24 when not set). */
const minRentalHours = computed(() => vehicle.value?.minRentalPeriodHours ?? 24)

/** Display text for minimum rental (e.g. "24 hours" or "1 day"). */
const minRentalDisplayText = computed(() => {
  const h = minRentalHours.value
  if (h === 24) return '1 day'
  if (h < 24) return `${h} hours`
  if (h % 24 === 0) return `${h / 24} days`
  return `${h} hours`
})

const hasDuration = computed(() => bookingDurationText.value.length > 0)

const subtotal = computed(() => {
  if (!vehicle.value || days.value < 1) return 0
  return sanitizePrice(vehicle.value.pricePerDay) * days.value
})

/** BULOD10: 10% off 1 day only (not full rental). */
const discountAmount = computed(() => {
  if (!vehicle.value || discountPercent.value <= 0) return 0
  const code = promoCode.value?.toUpperCase().trim()
  if (code === 'BULOD10' && days.value >= 3) {
    return Math.round(sanitizePrice(vehicle.value!.pricePerDay) * 0.10)
  }
  return 0
})

const total = computed(() => {
  const sub = subtotal.value
  if (sub <= 0) return 0
  return Math.max(0, sub - discountAmount.value)
})

function applyPromo() {
  const code = promoCode.value?.toUpperCase().trim()
  if (code === 'BULOD10' && days.value >= 3) {
    discountPercent.value = sanitizeDiscountPercent(10)
  } else {
    discountPercent.value = 0
  }
}

const promoSuccessRef = ref<HTMLElement | null>(null)
watch(
  () => discountAmount.value,
  async (val) => {
    if (!val) return
    await nextTick()
    const el = promoSuccessRef.value
    if (!el || window.matchMedia('(prefers-reduced-motion: reduce)').matches) return
    const { default: gsap } = await import('gsap')
    gsap.fromTo(el, { opacity: 0, y: 6 }, { opacity: 1, y: 0, duration: 0.3, ease: 'power2.out' })
  }
)

const canProceed = computed(() => {
  if (!vehicle.value || !startDate.value || !endDate.value || !meetUp.value?.trim() || days.value < 1) return false
  return bookingDurationHours.value >= minRentalHours.value
})

const backTo = computed(() =>
  vehicleId.value ? { name: 'client-vehicle-detail', params: { id: vehicleId.value } } : { name: 'client-browse' }
)

const scheduleFormRef = ref<{ validate: () => Promise<{ valid: boolean }> } | null>(null)

const rules = {
  required: (v: unknown) => (v !== undefined && v !== null && String(v).trim() !== '') || 'Required',
  minLength: (min: number) => (v: unknown) =>
    !v || String(v).trim().length >= min || `At least ${min} characters`,
  endDateAfterStart: () => {
    if (!startDate.value || !endDate.value) return true
    const s = new Date(startDate.value).getTime()
    const e = new Date(endDate.value).getTime()
    return e >= s || 'End date must be on or after start date'
  },
  minRentalPeriod: () => {
    if (!startDate.value || !endDate.value) return true
    const durationH = bookingDurationHours.value
    const minH = minRentalHours.value
    return durationH >= minH || `Minimum rental for this vehicle is ${minRentalDisplayText.value}.`
  },
}

async function submitSchedule() {
  const { valid } = await scheduleFormRef.value?.validate() ?? { valid: false }
  if (!valid || !canProceed.value) return
  goToCheckout()
}

function goToCheckout() {
  if (!canProceed.value || !vehicle.value) return
  // Keep cart in sync: add or update this vehicle with selected dates so Cart shows correct dates
  cartStore.addItem({
    vehicleId: vehicle.value.id,
    vehicleName: vehicle.value.name,
    vehicleImage: vehicle.value.image,
    location: vehicle.value.location,
    pricePerDay: vehicle.value.pricePerDay,
    start: startDate.value,
    end: endDate.value,
    days: days.value,
  })
  const v = vehicle.value
  router.push({
    name: 'client-checkout',
    query: {
      vehicleId: v.id,
      start: startDate.value,
      end: endDate.value,
      pickupTime: pickupTime.value || undefined,
      returnTime: returnTime.value || undefined,
      passengers: passengers.value > 0 ? String(passengers.value) : undefined,
      contactPhone: contactPhone.value || undefined,
      meetUp: meetUp.value || undefined,
      specialRequests: specialRequests.value || undefined,
      promo: discountAmount.value > 0 ? 'BULOD10' : undefined,
    },
    state: {
      checkoutVehicle: {
        id: v.id,
        name: v.name,
        image: v.image,
        location: v.location,
        pricePerDay: v.pricePerDay,
        securityDeposit: (v as { securityDeposit?: number }).securityDeposit ?? 0,
        businessName: (v as { businessName?: string }).businessName ?? '—',
        hostName: (v as { hostName?: string }).hostName ?? '—',
      },
    },
  })
}
</script>

<style scoped>
.schedule-booking-card {
  overflow: hidden;
}
.schedule-booking__vehicle-link {
  display: flex;
  flex-direction: column;
  text-decoration: none;
  color: inherit;
}
.schedule-booking__vehicle {
  display: flex;
  flex-direction: column;
}
.schedule-booking__image-wrap {
  width: 100%;
  aspect-ratio: 16 / 9;
  min-height: 180px;
  max-height: 280px;
  overflow: hidden;
  background: var(--surface-2, #e2e8f0);
}
.schedule-booking__img {
  width: 100%;
  height: 100%;
  object-fit: cover;
}
.schedule-booking__vehicle-info {
  padding: 1rem 1.25rem 0.5rem;
}
.schedule-booking__vehicle-name {
  font-size: 1.25rem;
  font-weight: 700;
  margin: 0 0 0.25rem;
  color: var(--text-primary, #0f172a);
}
.schedule-booking__vehicle-meta {
  font-size: 0.9375rem;
  color: var(--text-secondary, #64748b);
  margin: 0;
}
.schedule-field {
  margin-bottom: 0;
}

/* Clear day & time indicator so clients see what they booked */
.booking-summary-indicator {
  padding: 1rem 1.25rem;
  background: var(--booking-summary-bg, rgba(30, 58, 95, 0.08));
  border: 1px solid var(--booking-summary-border, rgba(30, 58, 95, 0.2));
  border-radius: 12px;
}
.booking-summary-indicator__label {
  display: flex;
  align-items: center;
  font-size: 0.8125rem;
  font-weight: 600;
  color: var(--primary, #1e3a5f);
  text-transform: uppercase;
  letter-spacing: 0.02em;
  margin-bottom: 0.35rem;
}
.booking-summary-indicator__dates {
  font-size: 1.125rem;
  font-weight: 700;
  color: var(--text-primary, #0f172a);
  margin-bottom: 0.25rem;
}
.booking-summary-indicator__meta {
  font-size: 0.9375rem;
  color: var(--text-secondary, #64748b);
}
.booking-summary-indicator__sep {
  margin: 0 0.5rem;
  font-weight: 400;
}
.booking-summary-indicator__total {
  margin-top: 0.5rem;
  padding-top: 0.5rem;
  border-top: 1px solid var(--booking-summary-border, rgba(30, 58, 95, 0.2));
  font-size: 0.9375rem;
  color: var(--text-primary, #0f172a);
}
.booking-summary-indicator__total strong {
  color: var(--primary, #1e3a5f);
}

/* Promo / voucher container – marketable */
.promo-voucher-card {
  border: 1px dashed var(--price-promo-text, #1e40af);
  background: var(--price-promo-bg, rgba(96, 165, 250, 0.12));
}
.promo-voucher__header {
  display: flex;
  align-items: flex-start;
  gap: 0.75rem;
  margin-bottom: 1rem;
}
.promo-voucher__icon {
  color: var(--price-promo-text, #1e40af);
  flex-shrink: 0;
}
.promo-voucher__title {
  font-size: 1rem;
  font-weight: 700;
  margin: 0 0 0.25rem;
  color: var(--text-primary, #0f172a);
}
.promo-voucher__subtitle {
  font-size: 0.875rem;
  color: var(--text-secondary, #64748b);
  margin: 0;
}
.promo-voucher__input-row {
  display: flex;
  gap: 0.75rem;
  align-items: center;
}
.promo-voucher__input {
  flex: 1;
  max-width: 240px;
}
.promo-voucher__input :deep(.v-field) {
  margin-bottom: 0;
}
.promo-voucher__apply {
  flex-shrink: 0;
  min-height: 56px;
}
.promo-voucher__success {
  display: inline-flex;
  align-items: center;
  gap: 0.5rem;
  font-size: 0.875rem;
  font-weight: 600;
  color: var(--price-savings-color, #10B981);
}

/* Price summary container */
.price-summary-card {
  border-left: 4px solid var(--border-subtle, #e2e8f0);
}
.price-summary-card--voucher-applied {
  border-left-color: var(--price-savings-color, #10B981);
  background: linear-gradient(135deg, rgba(16, 185, 129, 0.06) 0%, transparent 50%);
}
.price-summary__title {
  font-size: 1rem;
  font-weight: 700;
  margin: 0 0 1rem;
  color: var(--text-primary, #0f172a);
}
.price-summary__rows {
  display: flex;
  flex-direction: column;
  gap: 0.5rem;
}
.price-summary__row {
  display: flex;
  justify-content: space-between;
  align-items: center;
  font-size: 0.9375rem;
  color: var(--text-primary, #0f172a);
}
.price-summary__row--discount {
  color: var(--price-savings-color, #10B981);
  font-weight: 600;
}
.price-summary__savings {
  font-weight: 700;
  color: var(--price-savings-color, #10B981);
}
.price-summary__total {
  display: flex;
  justify-content: space-between;
  align-items: center;
  font-size: 1.125rem;
  font-weight: 700;
  color: var(--text-primary, #0f172a);
}
.price-summary__total-amount {
  font-size: 1.375rem;
  color: var(--price-main-color, #0f172a);
}
.price-summary-card--voucher-applied .price-summary__total-amount {
  color: var(--price-savings-color, #10B981);
}
</style>
