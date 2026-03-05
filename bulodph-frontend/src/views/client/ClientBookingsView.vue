<template>
  <DashboardTemplate title="My bookings" subtitle="Your upcoming and past trips—pay, view details, or plan the next one." :animate="true">
    <v-tabs v-model="tab" color="primary" class="mb-4">
      <v-tab value="upcoming">
        <v-icon start size="18">mdi-calendar-clock</v-icon>
        Upcoming
      </v-tab>
      <v-tab value="past">
        <v-icon start size="18">mdi-history</v-icon>
        Past
      </v-tab>
    </v-tabs>

    <div ref="bookingsListRef" class="bookings-list-stagger">
    <v-window v-model="tab">
      <v-window-item value="upcoming">
        <v-card v-for="b in upcomingBookings" :key="b.id" elevation="0" rounded="lg" class="modern-card mb-3">
          <v-card-text class="pa-4">
            <div class="booking-card__row">
              <div class="booking-card__left">
                <div class="booking-card__img-wrap">
                  <v-img
                    :src="getBookingImageUrl(b)"
                    width="88"
                    height="64"
                    cover
                    rounded="lg"
                    class="booking-card__img"
                    :alt="b.vehicleName"
                  >
                    <template #placeholder>
                      <div class="booking-card__img-placeholder">
                        <v-icon icon="mdi-car-side" size="32" color="grey-lighten-1" />
                      </div>
                    </template>
                  </v-img>
                </div>
                <div class="booking-card__info">
                  <div class="d-flex align-center gap-3 flex-wrap">
                    <span class="font-weight-bold">{{ b.vehicleName }}</span>
                    <span class="text-caption text-medium-emphasis">#{{ b.id }}</span>
                  </div>
                  <div class="text-caption text-medium-emphasis booking-card__dates">{{ b.start }} – {{ b.end }} · {{ b.location }}</div>
                  <div class="d-flex align-center gap-3 flex-wrap booking-card__chips">
                    <v-chip :color="getStatusColor(b.status)" :prepend-icon="getStatusIcon(b.status)" size="small" variant="tonal" class="booking-card__chip">{{ b.status }}</v-chip>
                    <v-chip v-if="isPaid(b)" color="success" size="small" variant="tonal" prepend-icon="mdi-credit-card-check" class="booking-card__chip">Paid</v-chip>
                  </div>
                  <p v-if="getStatusDescription(b.status)" class="text-caption text-medium-emphasis mb-0 mt-1">{{ getStatusDescription(b.status) }}</p>
                </div>
              </div>
              <div class="booking-card__right">
                <span class="text-h6 font-weight-bold booking-card__amount">{{ formatPrice(b.total) }}</span>
                <div class="d-flex align-center gap-2 flex-wrap booking-card__btns">
                <template v-if="canPay(b)">
                  <v-tooltip location="bottom">
                    <template #activator="{ props: tooltipProps }">
                      <v-btn
                        v-bind="tooltipProps"
                        color="primary"
                        size="small"
                        icon="mdi-wallet"
                        aria-label="Pay"
                        :to="{ name: 'client-payments', query: { payBookingId: b.id } }"
                      />
                    </template>
                    Pay
                  </v-tooltip>
                </template>
                <template v-else-if="canCancel(b)">
                  <v-tooltip location="bottom">
                    <template #activator="{ props: tooltipProps }">
                      <v-btn
                        v-bind="tooltipProps"
                        variant="outlined"
                        color="error"
                        size="small"
                        icon="mdi-close-circle-outline"
                        aria-label="Cancel booking"
                        @click="openCancelConfirm(b.id)"
                      />
                    </template>
                    Cancel booking
                  </v-tooltip>
                  <v-tooltip location="bottom">
                    <template #activator="{ props: tooltipProps }">
                      <v-btn
                        v-bind="tooltipProps"
                        variant="outlined"
                        size="small"
                        icon="mdi-eye"
                        aria-label="View details"
                        :to="{ name: 'client-booking-detail', params: { id: b.id } }"
                      />
                    </template>
                    View details
                  </v-tooltip>
                </template>
                <template v-else>
                  <v-tooltip location="bottom">
                    <template #activator="{ props: tooltipProps }">
                      <v-btn
                        v-bind="tooltipProps"
                        variant="outlined"
                        size="small"
                        icon="mdi-eye"
                        aria-label="View details"
                        :to="{ name: 'client-booking-detail', params: { id: b.id } }"
                      />
                    </template>
                    View details
                  </v-tooltip>
                </template>
                </div>
              </div>
            </div>
          </v-card-text>
        </v-card>
        <v-card v-if="!upcomingBookings.length" elevation="0" rounded="lg" class="modern-card">
          <v-card-text class="pa-4">
            <HpaEmptyState
              title="No upcoming bookings"
              description="Book a ride from Browse or use a past trip to book again."
              icon="mdi-calendar-blank-outline"
              action-text="Browse rides"
              action-icon="mdi-car-search"
              @action="goToBrowse"
            />
          </v-card-text>
        </v-card>
      </v-window-item>
      <v-window-item value="past">
        <v-card v-for="b in pastBookings" :key="b.id" elevation="0" rounded="lg" class="modern-card mb-3">
          <v-card-text class="pa-4">
            <div class="booking-card__row">
              <div class="booking-card__left">
                <div class="booking-card__img-wrap">
                  <v-img
                    :src="getBookingImageUrl(b)"
                    width="88"
                    height="64"
                    cover
                    rounded="lg"
                    class="booking-card__img"
                    :alt="b.vehicleName"
                  >
                    <template #placeholder>
                      <div class="booking-card__img-placeholder">
                        <v-icon icon="mdi-car-side" size="32" color="grey-lighten-1" />
                      </div>
                    </template>
                  </v-img>
                </div>
                <div class="booking-card__info">
                  <div class="d-flex align-center gap-3 flex-wrap">
                    <span class="font-weight-bold">{{ b.vehicleName }}</span>
                    <span class="text-caption text-medium-emphasis">#{{ b.id }}</span>
                  </div>
                  <div class="text-caption text-medium-emphasis booking-card__dates">{{ b.start }} – {{ b.end }}</div>
                  <v-chip :color="getStatusColor(b.status)" :prepend-icon="getStatusIcon(b.status)" size="small" variant="tonal" class="booking-card__chip">{{ b.status }}</v-chip>
                </div>
              </div>
              <div class="d-flex align-center gap-2 booking-card__btns">
                <v-tooltip location="bottom">
                  <template #activator="{ props: tooltipProps }">
                    <v-btn
                      v-bind="tooltipProps"
                      variant="tonal"
                      size="small"
                      icon="mdi-calendar-plus"
                      aria-label="Book again"
                      @click="bookAgain(b)"
                    />
                  </template>
                  Book again
                </v-tooltip>
                <v-tooltip location="bottom">
                  <template #activator="{ props: tooltipProps }">
                    <v-btn
                      v-bind="tooltipProps"
                      variant="text"
                      size="small"
                      icon="mdi-eye"
                      aria-label="View details"
                      :to="{ name: 'client-booking-detail', params: { id: b.id } }"
                    />
                  </template>
                  View details
                </v-tooltip>
              </div>
            </div>
          </v-card-text>
        </v-card>
        <v-card v-if="!pastBookings.length" elevation="0" rounded="lg" class="modern-card">
          <v-card-text class="pa-4">
            <HpaEmptyState
              title="No past bookings"
              description="Your completed and cancelled trips will appear here."
              icon="mdi-history"
              action-text="Browse rides"
              action-icon="mdi-car-search"
              @action="goToBrowse"
            />
          </v-card-text>
        </v-card>
      </v-window-item>
    </v-window>
    </div>
    <HpaConfirmModal
      v-model="showCancelConfirm"
      title="Cancel this booking?"
      :message="cancelConfirmMessage"
      confirm-text="Yes, cancel"
      cancel-text="Keep my booking"
      variant="danger"
      :loading="cancelLoading"
      @confirm="confirmCancelBooking"
    />
  </DashboardTemplate>
</template>

<script setup lang="ts">
import { ref, computed, onMounted } from 'vue'
import { useRouter } from 'vue-router'
import DashboardTemplate from '@/components/DashboardTemplate.vue'
import HpaEmptyState from '@/components/base/HpaEmptyState.vue'
import HpaConfirmModal from '@/components/base/HpaConfirmModal.vue'
import { formatPrice } from '@/utils/priceFormat'
import { resolveImageUrl, IMAGES } from '@/constants/images'
import { useClientBookingsStore } from '@/stores/clientBookings'
import type { ClientBooking } from '@/stores/clientBookings'

/** Fallback image when vehicle has no image or URL fails to load. */
const BOOKING_PLACEHOLDER_IMAGE = IMAGES.cars.family
import { useToastStore } from '@/stores/toast'
import * as bookingsApi from '@/services/bookings'
import { useGsapStagger } from '@/composables/useGsapStagger'

const router = useRouter()
const bookingsListRef = ref<HTMLElement | null>(null)
useGsapStagger(bookingsListRef, { selector: '.modern-card.mb-3', y: 12, duration: 0.4, stagger: 0.05 })
const toast = useToastStore()
const tab = ref('upcoming')
const clientBookings = useClientBookingsStore()
const showCancelConfirm = ref(false)
const cancelBookingId = ref<string | null>(null)
const cancelLoading = ref(false)
const upcomingBookings = computed(() => clientBookings.upcomingBookings)
const pastBookings = computed(() => clientBookings.pastBookings)

const cancelConfirmMessage = computed(() => {
  if (!cancelBookingId.value) return 'Submit a cancellation request? An admin will review and approve it. You can book again once cancelled.'
  const b = clientBookings.getById(cancelBookingId.value)
  if (b?.status === 'Approved') return 'Submit a cancellation request? An admin will approve it. You have not paid yet, so no refund is needed.'
  if (b?.status === 'Confirmed') return 'Submit a cancellation request? An admin will approve it. Refunds (if any) follow our policy—see Cancellations & Refunds.'
  return 'Submit a cancellation request? An admin will review and approve it.'
})

onMounted(() => {
  clientBookings.fetchFromApi()
})

function canPay(b: ClientBooking): boolean {
  return b.status === 'Pending payment' || b.status === 'Approved'
}

function isPaid(b: ClientBooking): boolean {
  return b.status === 'Confirmed' || !!b.paidAt
}

function canCancel(b: ClientBooking): boolean {
  return ['Pending approval', 'Approved', 'Confirmed'].includes(b.status)
}

function getStatusDescription(status: string): string {
  const map: Record<string, string> = {
    'Pending approval': 'Waiting for admin to approve your request.',
    'Pending cancellation': 'Cancellation requested – waiting for admin to approve.',
    'Pending payment': 'Pay now to confirm your rental.',
    'Approved': 'Approved – pay to confirm your rental.',
    'Confirmed': 'Confirmed – see you at pickup. Contact the rental if you need to change plans.',
    'Completed': 'Trip completed. Thanks for booking with BulodPH.',
    'Cancelled': 'This booking was cancelled.',
  }
  return map[status] ?? ''
}

function getStatusColor(s: string) {
  const map: Record<string, string> = {
    'Pending approval': 'warning',
    'Pending cancellation': 'warning',
    'Pending payment': 'warning',
    'Approved': 'info',
    'Confirmed': 'success',
    'Completed': 'grey',
    'Cancelled': 'error',
  }
  return map[s] ?? 'grey'
}

function getStatusIcon(s: string): string {
  const map: Record<string, string> = {
    'Pending approval': 'mdi-clock-outline',
    'Pending cancellation': 'mdi-clock-alert-outline',
    'Pending payment': 'mdi-wallet-outline',
    'Approved': 'mdi-check-circle-outline',
    'Confirmed': 'mdi-check-circle',
    'Completed': 'mdi-flag-checkered',
    'Cancelled': 'mdi-close-circle',
  }
  return map[s] ?? 'mdi-circle-outline'
}

/** Vehicle image: resolve backend-relative URLs and use placeholder when missing. */
function getBookingImageUrl(b: ClientBooking): string {
  const raw = (b as { vehicleImage?: string; vehicle_image?: string }).vehicleImage
    ?? (b as { vehicle_image?: string }).vehicle_image
    ?? ''
  const url = (typeof raw === 'string' && raw.trim()) ? raw.trim() : ''
  const resolved = url ? (resolveImageUrl(url) ?? url) : ''
  return resolved || BOOKING_PLACEHOLDER_IMAGE
}

function goToBrowse() {
  router.push({ name: 'client-browse' })
}

function openCancelConfirm(id: string) {
  cancelBookingId.value = id
  showCancelConfirm.value = true
}

async function confirmCancelBooking() {
  if (!cancelBookingId.value) {
    showCancelConfirm.value = false
    return
  }
  cancelLoading.value = true
  try {
    const updated = await bookingsApi.cancelClientBooking(cancelBookingId.value)
    clientBookings.setStatus(cancelBookingId.value, updated.status)
    toast.success('Cancellation requested. An admin will review shortly.')
    cancelBookingId.value = null
    showCancelConfirm.value = false
  } catch (e) {
    toast.error(e instanceof Error ? e.message : 'Could not request cancellation.')
  } finally {
    cancelLoading.value = false
  }
}

function bookAgain(booking: { vehicleId?: string; start: string; end: string }) {
  if (booking.vehicleId) {
    router.push({ name: 'client-booking-new', query: { vehicleId: booking.vehicleId, start: booking.start, end: booking.end } })
  } else {
    router.push({ name: 'client-browse' })
  }
}
</script>

<style scoped>
/* Booking card: image, text, amount and buttons with comfortable spacing */
.booking-card__row {
  display: flex;
  align-items: center;
  justify-content: space-between;
  flex-wrap: wrap;
  gap: 20px 24px;
}
.booking-card__left {
  display: flex;
  align-items: center;
  gap: 20px;
  min-width: 0;
}
.booking-card__img-wrap {
  flex-shrink: 0;
  width: 88px;
  height: 64px;
  border-radius: var(--radius-lg, 8px);
  overflow: hidden;
  background: var(--surface-2, #f1f5f9);
}
.booking-card__img {
  flex-shrink: 0;
}
.booking-card__img-placeholder {
  width: 100%;
  height: 100%;
  display: flex;
  align-items: center;
  justify-content: center;
  background: var(--surface-2, #f1f5f9);
}
.booking-card__info {
  display: flex;
  flex-direction: column;
  gap: 6px;
}
.booking-card__dates {
  margin: 0;
}
.booking-card__chips {
  gap: 0.75rem;
}
.booking-card__chip {
  align-self: flex-start;
  margin-top: 2px;
}
.booking-card__right {
  display: flex;
  flex-direction: column;
  align-items: flex-end;
  gap: 12px;
}
.booking-card__amount {
  margin: 0;
}
.booking-card__btns {
  flex-shrink: 0;
  gap: 14px !important;
}
</style>
