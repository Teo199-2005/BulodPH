<template>
  <DashboardTemplate
    :animate="true"
    :breadcrumb-items="[{ label: 'Dashboard', to: '/client' }, { label: 'My bookings', to: '/client/bookings' }, { label: booking?.vehicleName || 'Booking' }]"
  >
    <template v-if="booking" #header>
      <div>
        <h1 class="page-title mb-1">{{ booking.vehicleName }}</h1>
        <p class="page-subtitle">{{ booking.start }} – {{ booking.end }} · <HpaStatusBadge :variant="getStatusVariant(booking.status)" :label="booking.status" :icon="getStatusIcon(booking.status)" /></p>
        <p v-if="booking.status === 'Pending approval'" class="text-body-2 text-warning mb-0 mt-2">
          Waiting for admin approval. You will be able to pay here once approved.
        </p>
        <p v-if="getStatusDescription(booking.status)" class="text-body-2 text-medium-emphasis mb-0 mt-2">
          {{ getStatusDescription(booking.status) }}
        </p>
      </div>
      <v-btn
        v-if="canPay(booking)"
        color="primary"
        rounded="lg"
        prepend-icon="mdi-wallet"
        @click="payNow"
      >
        Pay now (GCash, Maya, or bank)
      </v-btn>
      <v-btn
        v-if="canCancel(booking)"
        variant="outlined"
        color="error"
        rounded="lg"
        prepend-icon="mdi-close-circle-outline"
        @click="showCancelConfirm = true"
      >
        Cancel booking
      </v-btn>
    </template>

    <v-card v-if="booking" elevation="0" rounded="lg" class="modern-card mb-4">
      <v-card-text class="pa-4">
        <v-img :src="booking.vehicleImage" height="200" cover rounded="lg" class="mb-4" />
        <v-list density="compact" class="pa-0">
          <v-list-item>
            <template #prepend><v-icon>mdi-car-side</v-icon></template>
            <v-list-item-title>Vehicle</v-list-item-title>
            <v-list-item-subtitle>{{ booking.vehicleName }}</v-list-item-subtitle>
          </v-list-item>
          <v-list-item>
            <template #prepend><v-icon>mdi-calendar</v-icon></template>
            <v-list-item-title>Dates</v-list-item-title>
            <v-list-item-subtitle>{{ booking.start }} – {{ booking.end }}</v-list-item-subtitle>
          </v-list-item>
          <v-list-item>
            <template #prepend><v-icon>mdi-map-marker</v-icon></template>
            <v-list-item-title>Location</v-list-item-title>
            <v-list-item-subtitle>{{ booking.location }}</v-list-item-subtitle>
          </v-list-item>
          <v-list-item>
            <template #prepend><v-icon>mdi-account</v-icon></template>
            <v-list-item-title>Car rental</v-list-item-title>
            <v-list-item-subtitle>
              <a :href="`tel:${booking.hostPhone.replace(/\s/g, '')}`" class="text-primary">{{ booking.hostName }}</a>
              · <a :href="`tel:${booking.hostPhone.replace(/\s/g, '')}`" class="text-primary">{{ booking.hostPhone }}</a>
            </v-list-item-subtitle>
          </v-list-item>
          <v-divider class="my-2" />
          <v-list-item>
            <template #prepend><v-icon>mdi-cash</v-icon></template>
            <v-list-item-title>Total</v-list-item-title>
            <v-list-item-subtitle class="text-h6 font-weight-bold text-primary">{{ formatPrice(booking.total) }}</v-list-item-subtitle>
          </v-list-item>
        </v-list>
        <div class="d-flex flex-wrap gap-3 mt-3">
          <v-btn variant="outlined" size="small" rounded="lg" :href="directionsUrl" target="_blank" rel="noopener">
            <v-icon start size="18">mdi-map-marker</v-icon>
            Directions
          </v-btn>
          <v-btn variant="outlined" size="small" rounded="lg" :href="`tel:${booking.hostPhone?.replace(/\s/g, '') || ''}`">
            <v-icon start size="18">mdi-phone</v-icon>
            Contact rental
          </v-btn>
          <v-btn
            v-if="canMessageRental(booking)"
            variant="outlined"
            size="small"
            rounded="lg"
            prepend-icon="mdi-message-text-outline"
            @click="goToMessages(booking)"
          >
            Message rental
          </v-btn>
          <v-btn
            v-if="canOpenDispute(booking)"
            variant="outlined"
            size="small"
            rounded="lg"
            color="warning"
            prepend-icon="mdi-alert-circle-outline"
            :to="{ name: 'client-disputes', query: { bookingId: booking.id, open: '1' } }"
          >
            Open dispute
          </v-btn>
          <v-btn
            v-if="booking.status === 'Completed'"
            variant="tonal"
            size="small"
            rounded="lg"
            prepend-icon="mdi-star-outline"
            :to="{ name: 'client-reviews', query: { bookingId: booking.id, vehicleId: booking.vehicleId } }"
          >
            Leave review
          </v-btn>
          <v-btn
            v-if="booking.status === 'Completed'"
            variant="tonal"
            size="small"
            rounded="lg"
            prepend-icon="mdi-file-document-outline"
            @click="downloadReceipt"
          >
            Download receipt
          </v-btn>
        </div>
      </v-card-text>
    </v-card>

    <div v-else class="text-center py-8">
      <p class="text-medium-emphasis mb-3">Booking not found.</p>
      <v-btn variant="tonal" color="primary" rounded="lg" :to="{ name: 'client-bookings' }">Back to My bookings</v-btn>
    </div>

    <HpaConfirmModal
      v-model="showCancelConfirm"
      title="Request cancellation?"
      :message="cancelConfirmMessage"
      confirm-text="Yes, request cancellation"
      cancel-text="Keep my booking"
      variant="danger"
      :loading="cancelLoading"
      @confirm="confirmCancel"
    />
  </DashboardTemplate>
</template>

<script setup lang="ts">
import { ref, computed } from 'vue'
import { useRoute, useRouter } from 'vue-router'
import DashboardTemplate from '@/components/DashboardTemplate.vue'
import HpaConfirmModal from '@/components/base/HpaConfirmModal.vue'
import HpaStatusBadge from '@/components/base/HpaStatusBadge.vue'
import { formatPrice } from '@/utils/priceFormat'
import { useToastStore } from '@/stores/toast'
import { useClientBookingsStore } from '@/stores/clientBookings'
import { generateReceiptPdf } from '@/utils/receiptPdf'
import * as bookingsApi from '@/services/bookings'
import * as messagesApi from '@/services/messages'
import { useUserSessionStore } from '@/stores/userSession'

const route = useRoute()
const router = useRouter()
const toast = useToastStore()
const clientBookings = useClientBookingsStore()
const userSession = useUserSessionStore()
const showCancelConfirm = ref(false)
const cancelLoading = ref(false)

const booking = computed(() => {
  const id = route.params.id as string
  return clientBookings.getById(id) ?? null
})

const cancelConfirmMessage = computed(() => {
  const b = booking.value
  if (!b) return 'Submit a cancellation request? An admin will review and approve it.'
  if (b.status === 'Approved') return 'Submit a cancellation request? An admin will approve it. You have not paid yet, so no refund is needed.'
  if (b.status === 'Confirmed') return 'Submit a cancellation request? An admin will approve it. Refunds (if any) follow our policy—see Cancellations & Refunds.'
  return 'Submit a cancellation request? An admin will review and approve it.'
})

const payNowTo = computed(() => ({
  name: 'client-payments',
  query: { payBookingId: booking.value?.id },
}))

function canPay(b: { status: string } | null): boolean {
  return b?.status === 'Pending payment' || b?.status === 'Approved'
}

function canCancel(b: { status: string } | null): boolean {
  if (!b) return false
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

function payNow() {
  const b = booking.value
  if (!b || !canPay(b)) return
  router.push({ name: 'client-payments', query: { payBookingId: b.id } })
}

const directionsUrl = computed(() => {
  const b = booking.value
  if (!b?.location) return '#'
  return `https://www.google.com/maps/search/?api=1&query=${encodeURIComponent(b.location)}`
})

function getStatusVariant(s: string): 'success' | 'warning' | 'error' | 'info' | 'neutral' | 'pending' {
  const map: Record<string, 'success' | 'warning' | 'error' | 'info' | 'neutral' | 'pending'> = {
    'Pending approval': 'pending', 'Pending cancellation': 'warning', 'Pending payment': 'warning', 'Approved': 'info', 'Confirmed': 'success', 'Completed': 'neutral', 'Cancelled': 'error',
  }
  return map[s] ?? 'neutral'
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

function canMessageRental(b: { status: string; ownerId?: string | null } | null): boolean {
  if (!b) return false
  if (b.status === 'Completed' || b.status === 'Cancelled') return false
  return !!b.ownerId
}

function canOpenDispute(b: { status: string } | null): boolean {
  if (!b) return false
  return b.status === 'Confirmed' || b.status === 'Completed'
}

async function goToMessages(booking: { id: string; ownerId?: string | null }) {
  const userId = userSession.user?.id
  if (!userId || !booking.ownerId) {
    router.push({ name: 'client-messages' })
    return
  }
  try {
    const thread = await messagesApi.createThread({
      booking_reference: booking.id,
      client_id: userId,
      owner_id: booking.ownerId,
    })
    router.push({ name: 'client-messages', query: { threadId: thread.id } })
  } catch {
    router.push({ name: 'client-messages' })
  }
}

async function confirmCancel() {
  const b = booking.value
  if (!b) return
  cancelLoading.value = true
  try {
    const updated = await bookingsApi.cancelClientBooking(b.id)
    clientBookings.setStatus(b.id, updated.status)
    showCancelConfirm.value = false
    toast.success('Cancellation requested. An admin will review shortly.')
    router.push({ name: 'client-bookings' })
  } catch (e) {
    toast.error(e instanceof Error ? e.message : 'Could not request cancellation.')
  } finally {
    cancelLoading.value = false
  }
}

function escapeReceiptHtml(s: string): string {
  return String(s)
    .replace(/&/g, '&amp;')
    .replace(/</g, '&lt;')
    .replace(/>/g, '&gt;')
    .replace(/"/g, '&quot;')
    .replace(/'/g, '&#39;')
}

function downloadReceipt() {
  const b = booking.value
  if (!b) return
  try {
    generateReceiptPdf(b)
    toast.success('Receipt downloaded as PDF.')
  } catch {
    // Fallback: open printable HTML in new window (escape all dynamic data to prevent XSS)
    const e = escapeReceiptHtml
    const html = `<!DOCTYPE html><html><head><meta charset="UTF-8"><title>BulodPH Receipt - ${e(b.id)}</title><style>body{font-family:system-ui;padding:2rem;max-width:480px;margin:0 auto;color:#1e293b}.receipt-header{background:#1e3a5f;color:#fff;padding:1.5rem;text-align:center;margin:-2rem -2rem 1.5rem}.receipt-row{display:flex;justify-content:space-between;padding:.5rem 0;border-bottom:1px solid #e2e8f0}.receipt-total{margin-top:1rem;padding-top:1rem;border-top:2px solid #e2e8f0;font-weight:700}</style></head><body><div class="receipt-header"><h1>BulodPH</h1><p>Rental Receipt</p></div><div class="receipt-row"><span>Booking ID</span><span>${e(b.id)}</span></div><div class="receipt-row"><span>Vehicle</span><span>${e(b.vehicleName ?? '')}</span></div><div class="receipt-row"><span>Dates</span><span>${e(b.start)} – ${e(b.end)}</span></div><div class="receipt-row"><span>Location</span><span>${e(b.location ?? '')}</span></div><div class="receipt-row"><span>Car rental</span><span>${e(b.hostName ?? '—')}</span></div><div class="receipt-row receipt-total"><span>Total paid</span><span>${e(formatPrice(b.total))}</span></div><div class="receipt-row"><span>Status</span><span>${e(b.status)}</span></div><p style="margin-top:2rem;font-size:.75rem;color:#64748b;text-align:center">Generated ${e(new Date().toLocaleString('en-PH'))} · BulodPH</p></body></html>`
    const w = window.open('', '_blank', 'noopener,noreferrer')
    if (w) {
      w.document.write(html)
      w.document.close()
      w.focus()
      setTimeout(() => { w.print(); w.onafterprint = () => w.close() }, 250)
    }
    toast.success('Receipt opened. Use Print → Save as PDF.')
  }
}
</script>
