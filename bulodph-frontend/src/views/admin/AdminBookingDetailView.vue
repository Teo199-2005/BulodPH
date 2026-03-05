<template>
  <DashboardTemplate
      title="Booking"
      subtitle="Details and actions"
      :animate="true"
      :breadcrumb-items="[{ label: 'Dashboard', to: '/admin' }, { label: 'Bookings', to: '/admin/bookings' }, { label: booking?.vehicleName || 'Booking' }]"
    >
    <v-card v-if="booking" elevation="0" rounded="lg" class="modern-card mb-4">
      <v-card-text class="pa-4">
        <div class="d-flex align-center gap-2 flex-wrap mb-3">
          <v-chip :color="getStatusColor(booking.status)" :prepend-icon="getStatusIcon(booking.status)" size="small" variant="tonal">{{ booking.status }}</v-chip>
          <v-chip v-if="booking.paidAt" color="success" size="small" variant="tonal" prepend-icon="mdi-credit-card-check">Paid</v-chip>
        </div>
        <v-list density="compact" class="pa-0">
          <v-list-item>
            <template #prepend><v-icon>mdi-receipt-text</v-icon></template>
            <v-list-item-title>Transaction</v-list-item-title>
            <v-list-item-subtitle>{{ booking.transactionId }}</v-list-item-subtitle>
          </v-list-item>
          <v-list-item>
            <template #prepend><v-icon>mdi-car-side</v-icon></template>
            <v-list-item-title>Vehicle</v-list-item-title>
            <v-list-item-subtitle>{{ booking.vehicleName }} · {{ booking.businessName }}</v-list-item-subtitle>
          </v-list-item>
          <v-list-item>
            <template #prepend><v-icon>mdi-account</v-icon></template>
            <v-list-item-title>Client</v-list-item-title>
            <v-list-item-subtitle>{{ booking.clientName }} · {{ booking.clientEmail }}</v-list-item-subtitle>
          </v-list-item>
          <v-list-item>
            <template #prepend><v-icon>mdi-calendar-range</v-icon></template>
            <v-list-item-title>Rental Period</v-list-item-title>
            <v-list-item-subtitle>{{ booking.startDate }} to {{ booking.endDate }}</v-list-item-subtitle>
          </v-list-item>
          <v-list-item>
            <template #prepend><v-icon>mdi-cash</v-icon></template>
            <v-list-item-title>Amount</v-list-item-title>
            <v-list-item-subtitle class="text-primary font-weight-bold">{{ formatPrice(booking.amount) }}</v-list-item-subtitle>
          </v-list-item>
        </v-list>
        <v-divider class="my-3" />
        <div class="d-flex gap-3 flex-wrap">
          <template v-if="booking.status === 'Pending'">
            <v-btn color="success" rounded="lg" prepend-icon="mdi-check" @click="approveBooking">Approve</v-btn>
            <v-btn variant="outlined" color="error" rounded="lg" prepend-icon="mdi-close" @click="showRejectConfirm = true">Reject</v-btn>
          </template>
          <template v-else-if="booking.status === 'Pending cancellation'">
            <v-btn color="error" rounded="lg" prepend-icon="mdi-check" @click="showApproveCancelConfirm = true">Approve cancellation</v-btn>
            <v-btn variant="outlined" color="primary" rounded="lg" prepend-icon="mdi-close" @click="showRejectCancelConfirm = true">Reject cancellation</v-btn>
          </template>
          <template v-else-if="booking.status === 'Approved' && !booking.paidAt">
            <v-btn color="primary" rounded="lg" prepend-icon="mdi-cash-check" @click="confirmPaymentReceived">Mark as paid</v-btn>
            <v-btn v-if="!booking.archived" variant="outlined" color="primary" rounded="lg" prepend-icon="mdi-archive" @click="archiveBooking">Archive</v-btn>
          </template>
          <template v-else>
            <v-btn v-if="!booking.archived" variant="outlined" color="primary" rounded="lg" prepend-icon="mdi-archive" @click="archiveBooking">Archive</v-btn>
            <v-btn v-if="booking.status !== 'Completed' && booking.status !== 'Cancelled' && booking.status !== 'Rejected' && booking.status !== 'Active' && booking.status !== 'Pending cancellation'" variant="outlined" color="error" rounded="lg" prepend-icon="mdi-close-circle-outline" @click="showCancelConfirm = true">Cancel booking</v-btn>
          </template>
        </div>
      </v-card-text>
    </v-card>
    <div v-else class="text-center text-medium-emphasis py-10">
      <v-icon icon="mdi-file-document-outline" size="56" color="grey" class="mb-2" />
      <p class="mb-0">Booking not found.</p>
    </div>

    <HpaConfirmModal
      v-model="showCancelConfirm"
      title="Cancel booking?"
      message="This rental record will be marked as Cancelled. The client and car rental company can be notified."
      confirm-text="Yes, cancel"
      cancel-text="Keep"
      variant="danger"
      @confirm="confirmCancel"
    />
    <HpaConfirmModal
      v-model="showRejectConfirm"
      title="Reject booking?"
      message="The client will see this booking as rejected. They can submit a new request later."
      confirm-text="Yes, reject"
      cancel-text="Keep"
      variant="danger"
      @confirm="confirmReject"
    />
    <HpaConfirmModal
      v-model="showApproveCancelConfirm"
      title="Approve cancellation?"
      message="The booking will be marked as Cancelled. The client will see it as cancelled."
      confirm-text="Yes, approve cancellation"
      cancel-text="Keep"
      variant="danger"
      :loading="cancelActionLoading"
      @confirm="confirmApproveCancellation"
    />
    <HpaConfirmModal
      v-model="showRejectCancelConfirm"
      title="Reject cancellation request?"
      message="The booking will be restored to its previous status. The client can use or cancel it again later."
      confirm-text="Yes, reject cancellation"
      cancel-text="Keep"
      variant="warning"
      :loading="cancelActionLoading"
      @confirm="confirmRejectCancellation"
    />
  </DashboardTemplate>
</template>

<script setup lang="ts">
import { ref, computed } from 'vue'
import { useRoute, useRouter } from 'vue-router'
import DashboardTemplate from '@/components/DashboardTemplate.vue'
import { formatPrice } from '@/utils/priceFormat'
import HpaConfirmModal from '@/components/base/HpaConfirmModal.vue'
import { useToastStore } from '@/stores/toast'
import { useRentalBookings } from '@/composables/useRentalBookings'
import { useClientBookingsStore } from '@/stores/clientBookings'
import { useCarOwnerBookingsStore } from '@/stores/carOwnerBookings'
import * as bookingsApi from '@/services/bookings'

const route = useRoute()
const router = useRouter()
const toast = useToastStore()
const { getById, setArchived, setStatus, markAsPaid, applyRecordUpdate } = useRentalBookings()
const clientBookings = useClientBookingsStore()
const carOwnerBookings = useCarOwnerBookingsStore()
const showCancelConfirm = ref(false)
const showRejectConfirm = ref(false)
const showApproveCancelConfirm = ref(false)
const showRejectCancelConfirm = ref(false)
const cancelActionLoading = ref(false)

const booking = computed(() => getById(route.params.id as string) ?? null)

function getStatusColor(s: string) {
  const map: Record<string, string> = {
    Active: 'success',
    Pending: 'warning',
    'Pending cancellation': 'warning',
    Approved: 'info',
    Completed: 'grey',
    Cancelled: 'error',
    Rejected: 'error',
    Overdue: 'error',
  }
  return map[s] ?? 'grey'
}

function getStatusIcon(s: string): string {
  const map: Record<string, string> = {
    Active: 'mdi-play-circle',
    Pending: 'mdi-clock-outline',
    'Pending cancellation': 'mdi-clock-alert-outline',
    Approved: 'mdi-check-circle-outline',
    Completed: 'mdi-flag-checkered',
    Cancelled: 'mdi-close-circle',
    Rejected: 'mdi-cancel',
    Overdue: 'mdi-alert-circle',
  }
  return map[s] ?? 'mdi-circle-outline'
}

function archiveBooking() {
  const b = booking.value
  if (!b) return
  setArchived(b.id, true)
  toast.success('Record archived.')
}

function confirmCancel() {
  const b = booking.value
  if (!b) return
  setStatus(b.id, 'Cancelled')
  clientBookings.setStatus(b.id, 'Cancelled')
  showCancelConfirm.value = false
  toast.success('Booking cancelled.')
  router.push({ name: 'admin-bookings' })
}

function approveBooking() {
  const b = booking.value
  if (!b) return
  setStatus(b.id, 'Approved')
  clientBookings.setStatus(b.id, 'Approved')
  carOwnerBookings.add({
    vehicleName: b.vehicleName,
    renterName: b.clientName,
    renterPhone: '',
    start: b.startDate,
    end: b.endDate,
    meetUp: '',
    status: 'Requested',
    earnings: Math.round(b.amount * 0.85),
  }, b.id)
  toast.success('Booking approved. Client can pay via QR; confirm when payment is received.')
  router.push({ name: 'admin-bookings' })
}

async function confirmPaymentReceived() {
  const b = booking.value
  if (!b || b.status !== 'Approved' || b.paidAt) return
  try {
    await markAsPaid(b.id)
    clientBookings.setStatus(b.id, 'Confirmed')
    carOwnerBookings.setStatus(b.id, 'Confirmed')
    toast.success('Marked as paid. The client will see this booking as confirmed.')
    router.push({ name: 'admin-bookings' })
  } catch {
    toast.error('Could not mark as paid. Please try again.')
  }
}

function confirmReject() {
  const b = booking.value
  if (!b) return
  setStatus(b.id, 'Rejected')
  clientBookings.setStatus(b.id, 'Cancelled')
  showRejectConfirm.value = false
  toast.success('Booking rejected.')
  router.push({ name: 'admin-bookings' })
}

async function confirmApproveCancellation() {
  const b = booking.value
  if (!b) return
  cancelActionLoading.value = true
  try {
    const updated = await bookingsApi.adminApproveCancellationRequest(b.id)
    applyRecordUpdate(b.id, { status: updated.status })
    clientBookings.setStatus(b.id, 'Cancelled')
    showApproveCancelConfirm.value = false
    toast.success('Cancellation approved. Booking is now cancelled.')
    router.push({ name: 'admin-bookings' })
  } catch (e) {
    toast.error(e instanceof Error ? e.message : 'Could not approve cancellation.')
  } finally {
    cancelActionLoading.value = false
  }
}

async function confirmRejectCancellation() {
  const b = booking.value
  if (!b) return
  cancelActionLoading.value = true
  try {
    const updated = await bookingsApi.adminRejectCancellationRequest(b.id)
    applyRecordUpdate(b.id, { status: updated.status })
    const clientStatus = updated.status === 'Pending' ? 'Pending approval' : updated.status
    clientBookings.setStatus(b.id, clientStatus)
    showRejectCancelConfirm.value = false
    toast.success('Cancellation request rejected. Booking restored.')
    router.push({ name: 'admin-bookings' })
  } catch (e) {
    toast.error(e instanceof Error ? e.message : 'Could not reject cancellation.')
  } finally {
    cancelActionLoading.value = false
  }
}
</script>
