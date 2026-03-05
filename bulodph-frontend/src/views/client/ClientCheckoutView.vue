<template>
  <div :class="{ 'checkout-page--sticky-bar': summary.vehicle && agreementAccepted }" class="checkout-page">
    <DashboardTemplate
      title="Checkout"
      subtitle="Review your booking and submit—you'll pay after we confirm."
      :animate="true"
      :back-to="{ name: 'client-booking-new' }"
      back-label="Back"
    >
      <!-- Full-width platform disclaimer strip -->
      <div class="checkout-disclaimer-strip">
        <span class="checkout-disclaimer-strip__inner">{{ platformDisclaimerShort }}</span>
      </div>

      <v-row v-if="summary.vehicle" class="checkout-row">
        <!-- Left: booking + promo (wider) -->
        <v-col cols="12" md="7" class="checkout-left pa-0 pa-md-2">
          <section class="checkout-section checkout-section--booking">
            <v-card elevation="0" rounded="xl" class="modern-card checkout-booking-card">
              <v-card-text class="checkout-booking__inner">
                <h2 class="checkout-booking__heading">
                  <v-icon icon="mdi-clipboard-list-outline" size="24" class="checkout-booking__heading-icon" />
                  Booking summary
                </h2>
                <div class="checkout-booking__vehicle">
                  <div class="checkout-booking__image-wrap">
                    <v-img
                      :src="summary.vehicle.image"
                      width="140"
                      height="94"
                      cover
                      rounded="lg"
                      class="checkout-booking__image"
                    />
                  </div>
                  <div class="checkout-booking__vehicle-info">
                    <h3 class="checkout-booking__vehicle-name">{{ summary.vehicle.name }}</h3>
                    <p class="checkout-booking__vehicle-meta">{{ summary.vehicle.location }}</p>
                    <div v-if="summary.vehicle.rentalMode || summary.vehicle.minRentalPeriodHours" class="d-flex flex-wrap gap-2 mb-1">
                      <v-chip v-if="summary.vehicle.rentalMode" size="x-small" variant="tonal" color="secondary" density="compact">{{ rentalModeLabel(summary.vehicle.rentalMode) }}</v-chip>
                      <v-chip v-if="minRentalChipText(summary.vehicle.minRentalPeriodHours)" size="x-small" variant="tonal" color="secondary" density="compact">{{ minRentalChipText(summary.vehicle.minRentalPeriodHours) }}</v-chip>
                    </div>
                    <p class="checkout-booking__vehicle-price">
                      {{ formatPrice(summary.vehicle.pricePerDay, { suffix: '/day' }) }} × {{ summary.days }} day(s)
                    </p>
                  </div>
                </div>
                <v-divider class="checkout-booking__divider" />
                <div class="checkout-booking__details">
                  <div class="checkout-booking__detail-row">
                    <span class="checkout-booking__detail-label">Start</span>
                    <span class="checkout-booking__detail-value">{{ summary.start }}</span>
                  </div>
                  <div class="checkout-booking__detail-row">
                    <span class="checkout-booking__detail-label">End</span>
                    <span class="checkout-booking__detail-value">{{ summary.end }}</span>
                  </div>
                  <div v-if="summary.meetUp" class="checkout-booking__detail-row">
                    <span class="checkout-booking__detail-label">Meet-up</span>
                    <span class="checkout-booking__detail-value">{{ summary.meetUp }}</span>
                  </div>
                </div>
              </v-card-text>
            </v-card>
          </section>

          <section class="checkout-section checkout-section--promo">
            <v-card elevation="0" rounded="xl" class="modern-card checkout-promo-card">
              <v-card-text class="checkout-promo__inner">
                <div class="checkout-promo__header">
                  <v-icon icon="mdi-tag-percent" size="22" class="checkout-promo__icon" />
                  <div>
                    <h3 class="checkout-promo__title">Voucher or promo code</h3>
                    <p class="checkout-promo__subtitle">Apply to get a discount</p>
                  </div>
                </div>
                <div class="checkout-promo__row">
                  <v-text-field
                    v-model="promoCode"
                    placeholder="e.g. BULOD10"
                    variant="outlined"
                    density="comfortable"
                    hide-details
                    class="checkout-promo__input"
                    :error-messages="promoError"
                    @update:model-value="promoError = ''"
                  >
                    <template #prepend-inner>
                      <v-icon icon="mdi-ticket-percent" size="20" class="text-medium-emphasis" />
                    </template>
                  </v-text-field>
                  <v-btn variant="tonal" color="primary" rounded="lg" @click="applyPromo">Apply</v-btn>
                </div>
                <div v-if="summary.discount" ref="promoSuccessRef" class="checkout-promo__success">
                  <v-icon icon="mdi-check-circle" size="18" color="success" />
                  <span>You're saving {{ formatPrice(summary.discount) }}</span>
                </div>
                <div v-else-if="promoError" class="checkout-promo__error">
                  <v-icon icon="mdi-alert-circle" size="18" color="error" />
                  <span>{{ promoError }}</span>
                </div>
              </v-card-text>
            </v-card>
          </section>
        </v-col>

        <!-- Right: payment + price + terms + CTA (sticky sidebar) -->
        <v-col cols="12" md="5" class="checkout-right pa-0 pa-md-2">
          <aside class="checkout-sidebar">
            <v-card
              elevation="0"
              rounded="xl"
              class="modern-card checkout-summary-card"
              :class="{ 'checkout-summary-card--voucher': summary.discount }"
            >
              <v-card-text class="checkout-summary__inner">
                <h3 class="checkout-summary__block-title">
                  <v-icon icon="mdi-credit-card-outline" size="20" />
                  Payment
                </h3>
                <v-radio-group v-model="paymentMethodId" hide-details class="checkout-payment-radios">
                  <v-radio
                    v-for="pm in paymentStore.methods"
                    :key="pm.id"
                    :value="pm.id"
                  >
                    <template #label>
                      <span class="d-inline-flex align-center gap-2">
                        <v-img :src="paymentLogo(pm.type)" height="22" width="32" contain class="flex-shrink-0 payment-logo" />
                        <span>{{ pm.type }} ··· {{ pm.masked }}</span>
                      </span>
                    </template>
                  </v-radio>
                </v-radio-group>
                <v-btn
                  variant="text"
                  size="small"
                  class="checkout-manage-payments"
                  prepend-icon="mdi-wallet-outline"
                  :to="{ name: 'client-payments' }"
                >
                  Manage payment methods
                </v-btn>

                <v-divider class="checkout-summary__divider" />

                <h3 class="checkout-summary__block-title">
                  <v-icon icon="mdi-cash-multiple" size="18" />
                  Price summary
                </h3>
                <div class="checkout-summary__rows">
                  <div class="checkout-summary__row">
                    <span>Subtotal</span>
                    <span>{{ formatPrice(summary.subtotal) }}</span>
                  </div>
                  <div v-if="summary.discount" class="checkout-summary__row checkout-summary__row--discount">
                    <span><v-icon icon="mdi-tag-check" size="16" class="mr-1" />Promo (10% off 1 day)</span>
                    <span class="checkout-summary__savings">-{{ formatPrice(summary.discount) }}</span>
                  </div>
                  <div v-if="summary.securityDeposit > 0" class="checkout-summary__row checkout-summary__row--deposit">
                    <span><v-icon icon="mdi-shield-account-outline" size="16" class="mr-1" />Security deposit <span class="text-caption">(held, refundable)</span></span>
                    <span class="text-medium-emphasis">{{ formatPrice(summary.securityDeposit) }}</span>
                  </div>
                </div>
                <v-divider class="checkout-summary__divider checkout-summary__divider--thin" />
                <div class="checkout-summary__total">
                  <span>Total</span>
                  <span class="checkout-summary__total-amount">{{ formatPrice(summary.total) }}</span>
                </div>

                <div class="checkout-summary__notices">
                  <p class="checkout-summary__notice">{{ INSURANCE_DISCLAIMER_SHORT }}</p>
                  <p class="checkout-summary__notice mb-0">
                    {{ CANCELLATION_POLICY_SHORT }}
                    <router-link to="/terms" class="text-primary font-weight-medium">Terms</router-link>.
                  </p>
                </div>

                <v-card variant="outlined" rounded="lg" class="checkout-terms-card">
                  <v-expansion-panels variant="accordion">
                    <v-expansion-panel>
                      <v-expansion-panel-title class="text-body-2 font-weight-medium">
                        Rental Terms & Platform Disclaimer
                      </v-expansion-panel-title>
                      <v-expansion-panel-text>
                        <p
                          v-for="(p, i) in clientAgreementParagraphs"
                          :key="i"
                          class="text-body-2 text-medium-emphasis mb-2"
                          v-html="renderAgreementParagraph(p)"
                        />
                      </v-expansion-panel-text>
                    </v-expansion-panel>
                  </v-expansion-panels>
                  <v-checkbox
                    v-model="agreementAccepted"
                    color="primary"
                    hide-details
                    density="compact"
                    class="checkout-terms-checkbox mt-2"
                  >
                    <template #label>
                      <span class="text-body-2">I have read and accept the rental terms and platform disclaimer above.</span>
                    </template>
                  </v-checkbox>
                </v-card>

                <p class="checkout-summary__hint text-caption text-medium-emphasis">
                  We'll confirm your booking quickly. Once approved, pay securely via <strong>Payments</strong> (GCash, Maya, or bank)—then you're all set.
                </p>
                <v-btn
                  color="primary"
                  block
                  size="large"
                  rounded="lg"
                  class="checkout-cta"
                  prepend-icon="mdi-send"
                  :loading="submitting"
                  :disabled="!agreementAccepted"
                  @click="confirmBooking"
                >
                  Submit & request approval
                </v-btn>
              </v-card-text>
            </v-card>
          </aside>
        </v-col>
      </v-row>

      <!-- Mobile sticky checkout bar -->
      <div
        v-if="summary.vehicle && agreementAccepted"
        class="checkout-sticky-bar d-md-none"
      >
        <div class="checkout-sticky-bar__content">
          <div class="checkout-sticky-bar__total">
            <span class="checkout-sticky-bar__label">Total</span>
            <span class="checkout-sticky-bar__amount">{{ formatPrice(summary.total) }}</span>
          </div>
          <v-btn
            color="primary"
            size="large"
            rounded="lg"
            class="checkout-sticky-bar__btn"
            prepend-icon="mdi-send"
            :loading="submitting"
            @click="confirmBooking"
          >
            Submit & request approval
          </v-btn>
        </div>
      </div>

      <!-- Empty state -->
      <div v-else class="checkout-empty">
        <div class="checkout-empty__icon-wrap">
          <v-icon icon="mdi-cart-outline" size="64" class="checkout-empty__icon" />
        </div>
        <h2 class="checkout-empty__title">No booking in progress</h2>
        <p class="checkout-empty__text">
          Pick a vehicle from Browse, choose your dates in Schedule booking, then come back here to submit.
        </p>
        <v-btn color="primary" rounded="lg" size="large" class="checkout-empty__cta" prepend-icon="mdi-car-search" :to="{ name: 'client-browse' }">
          Find your ride
        </v-btn>
      </div>
    </DashboardTemplate>

    <!-- Animated success modal after checkout -->
    <CheckoutSuccessModal
      v-model="showSuccessModal"
      :redirect-url="successRedirectUrl"
      @continue="onSuccessModalContinue"
    />
  </div>
</template>

<script setup lang="ts">
import { ref, computed, onMounted, watch, nextTick } from 'vue'
import { useRoute, useRouter } from 'vue-router'
import DashboardTemplate from '@/components/DashboardTemplate.vue'
import CheckoutSuccessModal from '@/components/client/CheckoutSuccessModal.vue'
import { formatPrice } from '@/utils/priceFormat'
import { useToastStore } from '@/stores/toast'
import { IMAGES } from '@/constants/images'
import { PLATFORM_DISCLAIMER_SHORT, CLIENT_RENTAL_AGREEMENT, INSURANCE_DISCLAIMER_SHORT, CANCELLATION_POLICY_SHORT } from '@/constants/platformAgreement'
import { useAgreementAcceptanceStore } from '@/stores/agreementAcceptance'

function paymentLogo(type: string): string {
  const map: Record<string, string> = {
    GCash: IMAGES.payments.gcash,
    Maya: IMAGES.payments.maya,
    Visa: IMAGES.payments.visa,
    Mastercard: IMAGES.payments.mastercard,
    BPI: IMAGES.payments.bpi,
  }
  return map[type] ?? ''
}

const route = useRoute()
const router = useRouter()
const toast = useToastStore()
const agreementStore = useAgreementAcceptanceStore()

const platformDisclaimerShort = PLATFORM_DISCLAIMER_SHORT
const clientAgreementParagraphs = CLIENT_RENTAL_AGREEMENT.paragraphs
const agreementAccepted = ref(false)
const showSuccessModal = ref(false)
const successRedirectUrl = ref<string | null>(null)

function renderAgreementParagraph(p: string): string {
  return p.replace(/\*\*(.+?)\*\*/g, '<strong>$1</strong>')
}

import { rentalModeLabel, minRentalChipText } from '@/constants/vehicleSeed'
import { useVehicles } from '@/composables/useVehicles'
import { useRentalBookings } from '@/composables/useRentalBookings'
import { useCartStore } from '@/stores/cart'
import { useClientBookingsStore } from '@/stores/clientBookings'
import { usePaymentMethodsStore } from '@/stores/paymentMethods'
import { useUserSessionStore } from '@/stores/userSession'
import { createPaymentSession, PaymentUnavailableError } from '@/services/payments'
import { createRentalBookingFromCheckout } from '@/services/bookings'
import { sanitizePrice, sanitizeDiscountPercent } from '@/utils/numericValidation'

const { vehicles: vehiclesList, fetchFromApi: fetchVehicles } = useVehicles()
const cartStore = useCartStore()
const clientBookings = useClientBookingsStore()
const paymentStore = usePaymentMethodsStore()
const userSession = useUserSessionStore()
const { add: addRentalRecord } = useRentalBookings()
const vehicles = computed(() => Object.fromEntries(
  vehiclesList.value.map(v => [v.id, {
    id: v.id,
    name: v.name,
    location: v.location,
    pricePerDay: v.pricePerDay,
    image: v.image,
    securityDeposit: v.securityDeposit,
    businessName: v.businessName ?? v.hostName ?? '—',
    hostName: v.hostName ?? '—',
  }])
))

const paymentMethodId = ref('')
const promoCode = ref('')
const discountPercent = ref(0)
onMounted(async () => {
  if (!paymentMethodId.value && paymentStore.defaultId) paymentMethodId.value = paymentStore.defaultId
  const queryPromo = route.query.promo as string
  if (queryPromo?.toUpperCase() === 'BULOD10') {
    promoCode.value = 'BULOD10'
    if (days.value >= 3) discountPercent.value = 10
  }
  // Ensure vehicle list is populated when we have a vehicleId (fixes blank checkout when coming from Schedule)
  const vid = route.query.vehicleId as string
  if (vid && !vehicles.value[vid]) {
    await fetchVehicles()
  }
})
const promoSuccessRef = ref<HTMLElement | null>(null)
const submitting = ref(false)
const promoError = ref('')

const vehicleId = computed(() => route.query.vehicleId as string)
const start = computed(() => route.query.start as string)
const end = computed(() => route.query.end as string)
const meetUp = computed(() => route.query.meetUp as string)

const vehicle = computed(() => vehicleId.value ? vehicles.value[vehicleId.value] ?? null : null)

/** Fallback: build a minimal vehicle from cart when coming from Schedule (vehicle list may not have it yet). */
const vehicleFromCart = computed(() => {
  if (!vehicleId.value) return null
  const exact = cartStore.cart.find(
    (i) => i.vehicleId === vehicleId.value && i.start === start.value && i.end === end.value
  )
  const item = exact ?? cartStore.cart.find((i) => i.vehicleId === vehicleId.value)
  if (!item) return null
  return {
    id: item.vehicleId,
    name: item.vehicleName,
    location: item.location ?? '—',
    pricePerDay: item.pricePerDay,
    image: item.vehicleImage,
    securityDeposit: 0,
    businessName: '—' as string,
    hostName: '—' as string,
  }
})

/** Fallback: vehicle snapshot passed via router state when navigating from Schedule (avoids empty checkout if list/cart are not in sync). */
const vehicleFromState = (() => {
  if (typeof window === 'undefined') return ref<Record<string, unknown> | null>(null)
  const s = history.state?.checkoutVehicle
  if (!s || typeof s !== 'object' || !(s as Record<string, unknown>).id) return ref<Record<string, unknown> | null>(null)
  const v = s as Record<string, unknown>
  return ref({
    id: String(v.id),
    name: String(v.name ?? '—'),
    image: String(v.image ?? ''),
    location: String(v.location ?? '—'),
    pricePerDay: Number(v.pricePerDay) || 0,
    securityDeposit: Number(v.securityDeposit) || 0,
    businessName: String(v.businessName ?? '—'),
    hostName: String(v.hostName ?? '—'),
  } as Record<string, unknown>)
})()

/** Use vehicle from list, cart, or router state so checkout is never blank when coming from Schedule. */
const effectiveVehicle = computed(() => {
  const vid = vehicleId.value
  const fromState = vehicleFromState.value && vid && vehicleFromState.value.id === vid ? vehicleFromState.value : null
  return vehicle.value ?? vehicleFromCart.value ?? fromState
})

const days = computed(() => {
  if (!start.value || !end.value) return 0
  const s = new Date(start.value).getTime()
  const e = new Date(end.value).getTime()
  return Math.max(1, Math.ceil((e - s) / (24 * 60 * 60 * 1000)) + 1)
})

const summary = computed(() => {
  if (!effectiveVehicle.value) return { vehicle: null, days: 0, subtotal: 0, discount: 0, total: 0, securityDeposit: 0, start: '', end: '', meetUp: '' }
  const safePrice = sanitizePrice(effectiveVehicle.value.pricePerDay)
  const subtotal = safePrice * days.value
  // BULOD10: 10% off 1 day only (not full rental)
  const isBulod10 = promoCode.value?.trim().toUpperCase() === 'BULOD10' && discountPercent.value === 10
  const discount = isBulod10 ? Math.round(safePrice * 0.10) : Math.round(subtotal * (sanitizeDiscountPercent(discountPercent.value) / 100))
  const total = Math.max(0, subtotal - discount)
  const securityDeposit = sanitizePrice(effectiveVehicle.value.securityDeposit ?? 0)
  return {
    vehicle: effectiveVehicle.value,
    days: days.value,
    subtotal,
    discount,
    total,
    securityDeposit,
    start: start.value || '—',
    end: end.value || '—',
    meetUp: meetUp.value || '—',
  }
})

watch(
  () => summary.value?.discount,
  async (discount) => {
    if (!discount) return
    await nextTick()
    const el = promoSuccessRef.value
    if (!el || window.matchMedia('(prefers-reduced-motion: reduce)').matches) return
    const { default: gsap } = await import('gsap')
    gsap.fromTo(el, { opacity: 0, y: 6 }, { opacity: 1, y: 0, duration: 0.3, ease: 'power2.out' })
  }
)

function applyPromo() {
  promoError.value = ''
  const code = promoCode.value?.trim().toUpperCase()
  if (!code) {
    discountPercent.value = 0
    return
  }
  if (code === 'BULOD10') {
    if (days.value >= 3) {
      discountPercent.value = sanitizeDiscountPercent(10)
      return
    }
    promoError.value = 'BULOD10 is valid for 3-day minimum bookings. Book at least 3 days to get 10% off.'
    discountPercent.value = 0
    return
  }
  discountPercent.value = 0
  promoError.value = 'Invalid or expired promo code. Try BULOD10 for 10% off on 3-day minimum booking.'
}

function toYmd(value: string): string {
  const d = new Date(value)
  return isNaN(d.getTime()) ? value : d.toISOString().slice(0, 10)
}

async function confirmBooking() {
  if (!summary.value.vehicle || !agreementAccepted.value) return
  agreementStore.acceptClientRentalAgreement()
  submitting.value = true
  try {
    const v = summary.value.vehicle!
    const startStr = start.value || summary.value.start
    const endStr = end.value || summary.value.end
    const clientName = userSession.user?.name ?? 'Client'
    const clientEmail = userSession.user?.email ?? ''
    const businessName = v.businessName ?? v.hostName ?? '—'
    const total = summary.value.total

    let bookingId: string
    try {
      const created = await createRentalBookingFromCheckout({
        vehicle_id: v.id,
        vehicle_name: v.name,
        business_name: businessName,
        client_name: clientName,
        client_email: clientEmail,
        start_date: toYmd(startStr),
        end_date: toYmd(endStr),
        amount: total,
      })
      bookingId = created.id
      clientBookings.add({
        vehicleName: created.vehicleName,
        vehicleImage: v.image,
        vehicleId: v.id,
        start: startStr,
        end: endStr,
        location: v.location,
        total: created.amount,
        status: 'Pending approval',
        hostName: v.hostName ?? 'Rental',
        hostPhone: '—',
      }, bookingId)
      addRentalRecord({
        transactionId: created.transactionId,
        vehicleName: created.vehicleName,
        businessName: created.businessName,
        clientName: created.clientName,
        clientEmail: created.clientEmail,
        startDate: created.startDate,
        endDate: created.endDate,
        amount: created.amount,
        status: created.status,
      }, bookingId)
    } catch {
      bookingId = String(Date.now())
      clientBookings.add({
        vehicleName: v.name,
        vehicleImage: v.image,
        vehicleId: v.id,
        start: startStr,
        end: endStr,
        location: v.location,
        total,
        status: 'Pending approval',
        hostName: v.hostName ?? 'Rental',
        hostPhone: '—',
      }, bookingId)
      addRentalRecord({
        transactionId: 'T' + bookingId.slice(-8),
        vehicleName: v.name,
        businessName,
        clientName,
        clientEmail,
        startDate: startStr,
        endDate: endStr,
        amount: total,
        status: 'Pending',
      }, bookingId)
    }

    const methodType = paymentStore.methods.find(m => m.id === paymentMethodId.value)?.type ?? 'GCash'
    const payment = await createPaymentSession({
      bookingId,
      vehicleId: v.id,
      startDate: startStr,
      endDate: endStr,
      amount: total,
      method: methodType.toLowerCase().replace(/\s/g, '_'),
      promoCode: promoCode.value || undefined,
      returnUrl: window.location.origin + '/client/bookings',
      cancelUrl: window.location.origin + '/client/checkout',
    })
    if (payment?.redirect_url || payment?.checkout_url) {
      const url = payment.redirect_url ?? payment.checkout_url
      successRedirectUrl.value = url ?? null
      showSuccessModal.value = true
      return
    }
    successRedirectUrl.value = null
    showSuccessModal.value = true
  } catch (err) {
    if (err instanceof PaymentUnavailableError) {
      toast.info(err.message)
      successRedirectUrl.value = null
      showSuccessModal.value = true
      return
    }
    toast.error('Could not submit booking. Please check your connection and try again.')
  } finally {
    submitting.value = false
  }
}

function onSuccessModalContinue() {
  showSuccessModal.value = false
  if (successRedirectUrl.value) {
    window.location.href = successRedirectUrl.value
    successRedirectUrl.value = null
  } else {
    router.push({ name: 'client-bookings' })
  }
}
</script>

<style scoped>
/* Page & layout */
.checkout-page {
  padding-bottom: var(--space-8);
}
.checkout-disclaimer-strip {
  max-width: 56rem;
  margin-left: auto;
  margin-right: auto;
  margin-bottom: var(--space-6);
  padding: var(--space-3) var(--space-4);
  background: var(--surface-1);
  border-radius: var(--radius-lg);
  border-top: 1px solid rgba(15, 23, 42, 0.08);
  border-bottom: 1px solid rgba(15, 23, 42, 0.06);
}

.checkout-disclaimer-strip__inner {
  display: block;
  max-width: 52ch;
  margin: 0 auto;
  font-size: 0.8125rem;
  line-height: 1.5;
  color: var(--text-secondary, #64748b);
  text-align: center;
}
.checkout-row {
  margin-bottom: 0;
}
.checkout-row > .v-col {
  margin-bottom: var(--space-5);
}
@media (min-width: 960px) {
  .checkout-row > .v-col {
    margin-bottom: 0;
  }
}
.checkout-left {
  display: flex;
  flex-direction: column;
  gap: var(--space-5);
}
.checkout-right {
  display: flex;
  flex-direction: column;
}
.checkout-section {
  margin-bottom: 0;
}
.checkout-section--booking {
  margin-bottom: 0;
}
.checkout-section--promo {
  margin-bottom: 0;
}

/* Sticky sidebar (desktop) */
@media (min-width: 960px) {
  .checkout-sidebar {
    position: sticky;
    top: calc(var(--space-4) + 8px);
    align-self: start;
  }
}

/* Booking summary card */
.checkout-booking-card .v-card-text {
  padding: var(--space-6) !important;
}
.checkout-booking__heading {
  font-size: var(--text-lg);
  font-weight: 700;
  color: var(--text-primary);
  margin: 0 0 var(--space-5);
  display: flex;
  align-items: center;
  gap: var(--space-3);
}
.checkout-booking__heading-icon {
  color: var(--role-primary, #1e3a5f);
}
.checkout-booking__vehicle {
  display: flex;
  align-items: flex-start;
  gap: var(--space-5);
  margin-bottom: var(--space-5);
}
.checkout-booking__image-wrap {
  flex-shrink: 0;
}
.checkout-booking__image {
  border: 1px solid var(--border-subtle);
}
.checkout-booking__vehicle-name {
  font-size: var(--text-base);
  font-weight: 700;
  color: var(--text-primary);
  margin: 0 0 var(--space-1);
}
.checkout-booking__vehicle-meta {
  font-size: var(--text-sm);
  color: var(--text-secondary);
  margin: 0 0 var(--space-2);
}
.checkout-booking__vehicle-price {
  font-size: var(--text-body);
  color: var(--text-primary);
  margin: 0;
}
.checkout-booking__divider {
  margin: var(--space-4) 0 !important;
}
.checkout-booking__details {
  display: flex;
  flex-direction: column;
  gap: var(--space-2);
}
.checkout-booking__detail-row {
  display: flex;
  justify-content: space-between;
  align-items: center;
  font-size: var(--text-body);
  color: var(--text-primary);
}
.checkout-booking__detail-label {
  color: var(--text-secondary);
  font-weight: 500;
}
.checkout-booking__detail-value {
  font-weight: 600;
}

/* Promo card */
.checkout-promo-card {
  border: 1px dashed var(--price-promo-text, #1e40af);
  background: var(--price-promo-bg, rgba(96, 165, 250, 0.12));
}
.checkout-promo__inner {
  padding: var(--space-5) !important;
}
.checkout-promo__header {
  display: flex;
  align-items: flex-start;
  gap: var(--space-3);
  margin-bottom: var(--space-4);
}
.checkout-promo__icon {
  color: var(--price-promo-text, #1e40af);
  flex-shrink: 0;
}
.checkout-promo__title {
  font-size: var(--text-body-lg);
  font-weight: 700;
  margin: 0 0 2px;
  color: var(--text-primary);
}
.checkout-promo__subtitle {
  font-size: var(--text-sm);
  color: var(--text-secondary);
  margin: 0;
}
.checkout-promo__row {
  display: flex;
  align-items: center;
  gap: var(--space-3);
  margin-bottom: var(--space-2);
}
.checkout-promo__row .checkout-promo__input {
  flex: 1;
  margin-bottom: 0;
}
.checkout-promo__success {
  display: inline-flex;
  align-items: center;
  gap: var(--space-2);
  font-size: var(--text-body-sm);
  font-weight: 600;
  color: var(--price-savings-color, #10B981);
}
.checkout-promo__error {
  display: inline-flex;
  align-items: center;
  gap: var(--space-2);
  font-size: var(--text-body-sm);
  color: rgb(var(--v-theme-error));
}

/* Sidebar summary card */
.checkout-summary-card .v-card-text {
  padding: var(--space-6) !important;
}
.checkout-summary-card--voucher {
  border-left: 4px solid var(--price-savings-color, #10B981);
  background: linear-gradient(135deg, rgba(16, 185, 129, 0.06) 0%, transparent 50%);
}
.checkout-summary__block-title {
  font-size: var(--text-body-lg);
  font-weight: 700;
  color: var(--text-primary);
  margin: 0 0 var(--space-3);
  display: flex;
  align-items: center;
  gap: var(--space-2);
}
.checkout-payment-radios {
  margin-bottom: var(--space-2);
}
.checkout-manage-payments {
  margin-bottom: var(--space-4);
}
.checkout-summary__divider {
  margin: var(--space-4) 0 !important;
}
.checkout-summary__divider--thin {
  margin: var(--space-3) 0 !important;
}
.checkout-summary__rows {
  display: flex;
  flex-direction: column;
  gap: var(--space-2);
}
.checkout-summary__row {
  display: flex;
  justify-content: space-between;
  align-items: center;
  font-size: var(--text-body);
  color: var(--text-primary);
}
.checkout-summary__row--discount {
  color: var(--price-savings-color, #10B981);
  font-weight: 600;
}
.checkout-summary__savings {
  font-weight: 700;
  color: var(--price-savings-color, #10B981);
}
.checkout-summary__total {
  display: flex;
  justify-content: space-between;
  align-items: center;
  font-size: var(--text-base);
  font-weight: 700;
  color: var(--text-primary);
  padding-top: var(--space-2);
}
.checkout-summary__total-amount {
  font-size: var(--text-xl);
  color: var(--price-main-color, #0f172a);
}
.checkout-summary-card--voucher .checkout-summary__total-amount {
  color: var(--price-savings-color, #10B981);
}
.checkout-summary__notices {
  margin-top: var(--space-4);
  padding: var(--space-3) var(--space-4);
  background: var(--surface-1);
  border-radius: var(--radius-md);
  border-left: 4px solid var(--primary-cyan, #60a5fa);
}
.checkout-summary__notice {
  font-size: var(--text-body-sm);
  color: var(--text-secondary);
  margin: 0 0 var(--space-2);
}
.checkout-terms-card {
  margin-top: var(--space-4);
  padding: var(--space-3) !important;
}
.checkout-terms-checkbox {
  margin-top: var(--space-2);
}
.checkout-summary__hint {
  margin-top: var(--space-4);
  margin-bottom: 0;
}
.checkout-cta {
  margin-top: var(--space-5);
}
.payment-logo {
  flex-shrink: 0;
}

/* Empty state */
.checkout-empty {
  text-align: center;
  padding: var(--space-16) var(--space-6);
  max-width: 420px;
  margin: 0 auto;
}
.checkout-empty__icon-wrap {
  width: 112px;
  height: 112px;
  margin: 0 auto var(--space-6);
  border-radius: 50%;
  background: var(--surface-2);
  display: flex;
  align-items: center;
  justify-content: center;
  border: 2px dashed var(--border-subtle);
}
.checkout-empty__icon {
  color: var(--text-muted) !important;
}
.checkout-empty__title {
  font-size: var(--text-xl);
  font-weight: 700;
  color: var(--text-primary);
  margin: 0 0 var(--space-3);
}
.checkout-empty__text {
  font-size: var(--text-body);
  color: var(--text-secondary);
  margin: 0 0 var(--space-6);
  line-height: var(--leading-relaxed);
}
.checkout-empty__cta {
  min-width: 200px;
}

/* Mobile sticky bar */
.checkout-sticky-bar {
  position: fixed;
  bottom: 0;
  left: 0;
  right: 0;
  z-index: 100;
  background: var(--glass-bg-strong, rgba(255, 255, 255, 0.95));
  backdrop-filter: blur(var(--glass-blur));
  -webkit-backdrop-filter: blur(var(--glass-blur));
  border-top: 1px solid var(--border-subtle);
  box-shadow: 0 -4px 20px rgba(0, 0, 0, 0.08);
  padding: var(--space-3) var(--page-padding-x);
  padding-bottom: calc(var(--space-3) + env(safe-area-inset-bottom));
}
.checkout-sticky-bar__content {
  display: flex;
  align-items: center;
  justify-content: space-between;
  gap: var(--space-4);
  max-width: var(--page-max-width);
  margin: 0 auto;
}
.checkout-sticky-bar__total {
  display: flex;
  flex-direction: column;
  gap: 2px;
}
.checkout-sticky-bar__label {
  font-size: var(--text-xs);
  font-weight: 600;
  color: var(--text-secondary);
  text-transform: uppercase;
  letter-spacing: 0.05em;
}
.checkout-sticky-bar__amount {
  font-size: var(--text-lg);
  font-weight: 700;
  color: var(--text-primary);
}
.checkout-sticky-bar__btn {
  flex-shrink: 0;
}
@media (max-width: 959px) {
  .checkout-page--sticky-bar {
    padding-bottom: 100px;
  }
  .checkout-promo__row {
    flex-direction: column;
    align-items: stretch;
  }
  .checkout-promo__row .v-btn {
    width: 100%;
  }
}
</style>
