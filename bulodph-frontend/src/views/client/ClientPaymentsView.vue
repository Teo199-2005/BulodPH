<template>
  <DashboardTemplate title="Payments" subtitle="Pay with GCash, Maya, or bank—quick and secure." :animate="true">
    <v-card elevation="0" rounded="lg" class="payments-intro modern-card mb-4">
      <v-card-text class="pa-4">
        <p class="text-body-2 text-medium-emphasis mb-0">Pay for approved bookings via GCash, Maya, or bank. Add payment methods below; they are saved on this device.</p>
      </v-card-text>
    </v-card>

    <v-card v-if="unpaidBookings.length" elevation="0" rounded="lg" class="payments-section modern-card mb-4">
      <div class="payments-section__accent" />
      <div class="payments-section__header">
        <div class="payments-section__icon">
          <v-icon icon="mdi-wallet-clock-outline" size="22" />
        </div>
        <span class="payments-section__title">Unpaid bookings</span>
      </div>
      <v-divider class="mx-4" />
      <v-card-text class="pa-4">
        <p class="text-body-2 text-medium-emphasis mb-3">Admin has approved these. Pay with GCash, Maya, or bank to confirm your trip.</p>
        <v-list class="pa-0 payments-list" density="compact">
          <v-list-item v-for="b in unpaidBookings" :key="b.id" class="px-0 payments-list-item">
            <template #prepend><v-icon size="small">mdi-car-side</v-icon></template>
            <v-list-item-title class="text-body-2">{{ b.vehicleName }} · {{ b.start }} – {{ b.end }}</v-list-item-title>
            <v-list-item-subtitle class="text-body-2">{{ formatPrice(b.total) }}</v-list-item-subtitle>
            <template #append>
              <v-btn
                color="primary"
                size="small"
                rounded="lg"
                prepend-icon="mdi-qrcode"
                @click="openPayViaQr(b)"
              >
                Pay via QR
              </v-btn>
            </template>
          </v-list-item>
        </v-list>
        <p class="text-caption text-medium-emphasis mt-2 mb-0">Click &quot;Pay via QR&quot; to see payment instructions and scan GCash or Maya. Admin will confirm once payment is received.</p>
      </v-card-text>
    </v-card>

    <v-card v-if="billingHistory.length" elevation="0" rounded="lg" class="payments-section modern-card mb-4">
      <div class="payments-section__accent payments-section__accent--history" />
      <div class="payments-section__header">
        <div class="payments-section__icon payments-section__icon--history">
          <v-icon icon="mdi-receipt-text-clock-outline" size="22" />
        </div>
        <span class="payments-section__title">Billing history</span>
      </div>
      <v-divider class="mx-4" />
      <v-card-text class="pa-4">
        <v-list class="pa-0 payments-list" density="compact">
          <v-list-item v-for="item in billingHistory" :key="item.id" class="px-0 payments-list-item">
            <template #prepend><v-icon size="small">mdi-receipt-text</v-icon></template>
            <v-list-item-title class="text-body-2">{{ item.vehicleName }} · {{ item.start }} – {{ item.end }}</v-list-item-title>
            <v-list-item-subtitle class="text-body-2">Paid {{ item.paidDate }}</v-list-item-subtitle>
            <template #append>
              <span class="font-weight-medium text-primary">{{ formatPrice(item.total) }}</span>
            </template>
          </v-list-item>
        </v-list>
      </v-card-text>
    </v-card>

    <v-card elevation="0" rounded="lg" class="payments-section modern-card mb-4">
      <div class="payments-section__accent payments-section__accent--info" />
      <div class="payments-section__header">
        <div class="payments-section__icon payments-section__icon--info">
          <v-icon icon="mdi-information-outline" size="22" />
        </div>
        <span class="payments-section__title">How to pay</span>
      </div>
      <v-divider class="mx-4" />
      <v-card-text class="pa-4">
        <p class="text-body-2 text-medium-emphasis mb-0">
          Use <strong>Pay via QR</strong> above for each unpaid booking. Scan with GCash or Maya; admin will confirm payment. Saved payment methods and adding new ones are <strong>coming soon</strong>.
        </p>
      </v-card-text>
    </v-card>

    <v-card elevation="0" rounded="lg" class="payments-section modern-card mb-4">
      <div class="payments-section__accent payments-section__accent--add" />
      <div class="payments-section__header">
        <div class="payments-section__icon payments-section__icon--add">
          <v-icon icon="mdi-credit-card-plus-outline" size="22" />
        </div>
        <span class="payments-section__title">Add payment method</span>
      </div>
      <v-divider class="mx-4" />
      <v-card-text class="pa-4">
        <p class="text-body-2 text-medium-emphasis mb-0">
          Coming soon. For now, pay using the Pay via QR button above.
        </p>
      </v-card-text>
    </v-card>


    <HpaConfirmModal
      v-model="showRemoveMethodConfirm"
      title="Remove payment method?"
      message="This payment method will be removed. You can add it again later."
      confirm-text="Remove"
      cancel-text="Cancel"
      variant="danger"
      @confirm="confirmRemoveMethod"
    />

    <HpaModal
      v-model="showPayViaQrDialog"
      title="Pay for booking"
      icon="mdi-qrcode"
      max-width="480"
      persistent
      :show-actions="true"
      confirm-text="Close"
      hide-cancel
      @confirm="showPayViaQrDialog = false"
    >
      <template v-if="payViaQrBooking">
        <p class="text-h6 font-weight-bold text-primary mb-3">Amount due: {{ formatPrice(payViaQrBooking.total) }}</p>
        <p class="text-body-2 text-medium-emphasis mb-3">Scan with GCash or Maya and pay the amount above. Admin will confirm your payment; your booking will then be confirmed.</p>
        <v-row dense>
          <v-col cols="12" sm="6">
            <p class="text-caption font-weight-medium mb-1">GCash</p>
            <v-img
              v-if="paymentQr.gcashQrUrl"
              :src="resolveImageUrl(paymentQr.gcashQrUrl) ?? paymentQr.gcashQrUrl"
              alt="GCash QR"
              max-height="160"
              contain
              class="payment-qr-img rounded-lg"
            />
            <p v-else class="text-caption text-medium-emphasis">QR not set. Admin can add it in Payment collection (QR).</p>
          </v-col>
          <v-col cols="12" sm="6">
            <p class="text-caption font-weight-medium mb-1">Maya</p>
            <v-img
              v-if="paymentQr.mayaQrUrl"
              :src="resolveImageUrl(paymentQr.mayaQrUrl) ?? paymentQr.mayaQrUrl"
              alt="Maya QR"
              max-height="160"
              contain
              class="payment-qr-img rounded-lg"
            />
            <p v-else class="text-caption text-medium-emphasis">QR not set. Admin can add it in Payment collection (QR).</p>
          </v-col>
        </v-row>
      </template>
    </HpaModal>

    <HpaModal
      v-model="showMaintenanceModal"
      title="Why isn't this available?"
      icon="mdi-wrench-clock-outline"
      max-width="440"
      persistent
      :show-actions="true"
      confirm-text="Got it"
      hide-cancel
      @confirm="showMaintenanceModal = false"
    >
      <p class="text-body-2 mb-0">
        Saved payment methods and adding GCash, Maya, or cards are currently <strong>under maintenance</strong>. We're working on full payment gateway integration.
      </p>
      <p class="text-body-2 mt-3 mb-0">
        For now, please use <strong>Pay via QR</strong> above to pay for your approved bookings—click the button, then scan the QR code with your GCash or Maya app. Admin will confirm once payment is received.
      </p>
    </HpaModal>
  </DashboardTemplate>
</template>

<script setup lang="ts">
import { ref, computed, onMounted, nextTick } from 'vue'
import DashboardTemplate from '@/components/DashboardTemplate.vue'
import HpaModal from '@/components/base/HpaModal.vue'
import HpaConfirmModal from '@/components/base/HpaConfirmModal.vue'
import { formatPrice } from '@/utils/priceFormat'
import { useToastStore } from '@/stores/toast'
import { usePaymentMethodsStore } from '@/stores/paymentMethods'
import { useRouter, useRoute } from 'vue-router'
import { useClientBookingsStore } from '@/stores/clientBookings'
import { getPaymentQr } from '@/services/paymentQr'
import type { ClientBooking } from '@/stores/clientBookings'
import { IMAGES, resolveImageUrl } from '@/constants/images'
import { useCleave } from '@/composables/useCleave'
import { formatInput } from '@/utils/inputFormatters'

const router = useRouter()
const route = useRoute()
const toast = useToastStore()
const paymentStore = usePaymentMethodsStore()
const clientBookings = useClientBookingsStore()

const unpaidBookings = computed(() =>
  clientBookings.upcomingBookings.filter(b => b.status === 'Pending payment' || b.status === 'Approved')
)

const showPayViaQrDialog = ref(false)
const showMaintenanceModal = ref(false)
const payViaQrBooking = ref<ClientBooking | null>(null)
const paymentQr = ref<{ gcashQrUrl: string | null; mayaQrUrl: string | null }>({ gcashQrUrl: null, mayaQrUrl: null })
const showRemoveMethodConfirm = ref(false)
const removeMethodId = ref<string | null>(null)
const ewalletFieldRef = ref<HTMLElement | null>(null)
const cardNumberFieldRef = ref<HTMLElement | null>(null)
const cardExpiryFieldRef = ref<HTMLElement | null>(null)
const ewalletInputRef = ref<HTMLInputElement | null>(null)
const cardNumberInputRef = ref<HTMLInputElement | null>(null)
const cardExpiryInputRef = ref<HTMLInputElement | null>(null)

async function openPayViaQr(booking: ClientBooking) {
  payViaQrBooking.value = booking
  showPayViaQrDialog.value = true
  try {
    paymentQr.value = await getPaymentQr()
  } catch {
    paymentQr.value = { gcashQrUrl: null, mayaQrUrl: null }
  }
}

const billingHistory = computed(() =>
  clientBookings.pastBookings
    .filter(b => b.status === 'Completed')
    .map(b => ({
      id: b.id,
      vehicleName: b.vehicleName,
      start: b.start,
      end: b.end,
      total: b.total,
      paidDate: b.end,
    }))
    .slice(0, 20)
)

onMounted(async () => {
  paymentStore.reload()
  await clientBookings.fetchFromApi()
  if (route.query.payBookingId) {
    const b = clientBookings.getById(route.query.payBookingId as string)
    if (b && (b.status === 'Pending payment' || b.status === 'Approved')) openPayViaQr(b)
  }
  await nextTick()
  ewalletInputRef.value = ewalletFieldRef.value?.querySelector('input') ?? null
  cardNumberInputRef.value = cardNumberFieldRef.value?.querySelector('input') ?? null
  cardExpiryInputRef.value = cardExpiryFieldRef.value?.querySelector('input') ?? null
})

useCleave(ewalletInputRef, { phone: true, phoneRegionCode: 'PH' })
useCleave(cardNumberInputRef, { creditCard: true })
useCleave(cardExpiryInputRef, { date: true, datePattern: ['m', 'y'] })

function setDefault(id: string) {
  paymentStore.setDefault(id)
  toast.success('Default payment method updated.')
}

function openRemoveConfirm(id: string) {
  removeMethodId.value = id
  showRemoveMethodConfirm.value = true
}

function confirmRemoveMethod() {
  if (removeMethodId.value) {
    paymentStore.remove(removeMethodId.value)
    toast.success('Payment method removed.')
    removeMethodId.value = null
    showRemoveMethodConfirm.value = false
  }
}

type PaymentType = 'GCash' | 'Maya' | 'Visa' | 'Mastercard' | 'BPI'
const newType = ref<PaymentType>('GCash')
const newNumber = ref('')
const newCardNumber = ref('')
const newCardExpiry = ref('')
const newAccountNumber = ref('')
const newAccountName = ref('')

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

function isEwallet(t: PaymentType) { return t === 'GCash' || t === 'Maya' }
function isCard(t: PaymentType) { return t === 'Visa' || t === 'Mastercard' }

/** GCash/Maya: 11 digits starting with 09 (e.g. 09XXXXXXXXX) */
const PH_MOBILE_REGEX = /^09\d{9}$/
const newNumberError = computed(() => {
  if (!isEwallet(newType.value) || !newNumber.value) return []
  const digits = newNumber.value.replace(/\D/g, '')
  if (digits.length === 0) return []
  if (!PH_MOBILE_REGEX.test(digits)) return ['Enter a valid PH mobile number (09XX XXX XXXX)']
  return []
})

const canAddNew = computed(() => {
  if (isEwallet(newType.value)) return PH_MOBILE_REGEX.test(newNumber.value.replace(/\D/g, ''))
  if (isCard(newType.value)) return (newCardNumber.value.replace(/\s/g, '').length >= 15 && newCardExpiry.value.length >= 4)
  if (newType.value === 'BPI') return newAccountNumber.value.length >= 10 && newAccountName.value.length > 0
  return false
})

function addMethod() {
  let masked = ''
  if (isEwallet(newType.value)) {
    masked = newNumber.value.slice(0, 4) + ' *** ' + newNumber.value.slice(-4)
    newNumber.value = ''
  } else if (isCard(newType.value)) {
    masked = '**** ' + newCardNumber.value.slice(-4)
    newCardNumber.value = ''
    newCardExpiry.value = ''
  } else {
    masked = '**** ' + newAccountNumber.value.slice(-4)
    newAccountNumber.value = ''
    newAccountName.value = ''
  }
  paymentStore.add({
    type: newType.value,
    masked,
    isDefault: paymentStore.methods.length === 0,
  })
  toast.success(`${newType.value} added.`)
}
</script>

<style scoped>
.payment-logo-wrap {
  display: flex;
  align-items: center;
  min-width: 44px;
  margin-right: 12px;
}

/* Comfortable spacing in payment lists */
.payments-list-item {
  padding-top: 14px !important;
  padding-bottom: 14px !important;
  min-height: 72px !important;
}
.payments-list-item :deep(.v-list-item__prepend) {
  margin-right: 16px !important;
}
.payments-intro {
  border: 1px solid rgba(var(--v-border-color), var(--v-border-opacity));
  background: rgba(var(--v-theme-primary), 0.04);
}

.payments-section {
  position: relative;
  overflow: hidden;
  border: 1px solid rgba(var(--v-border-color), var(--v-border-opacity));
}

.payments-section__accent {
  position: absolute;
  top: 0;
  left: 0;
  width: 4px;
  height: 100%;
  background: rgb(var(--v-theme-primary));
  border-radius: 4px 0 0 4px;
}

.payments-section__accent--history {
  background: rgb(76, 175, 80);
}

.payments-section__accent--info {
  background: linear-gradient(to bottom, rgb(var(--v-theme-primary)), rgba(var(--v-theme-primary), 0.5));
}

.payments-section__accent--add {
  background: linear-gradient(to bottom, rgb(255, 152, 0), rgba(255, 152, 0, 0.5));
}

.payments-section__header {
  display: flex;
  align-items: center;
  gap: 0.75rem;
  padding: 1rem 1rem 0.5rem;
}

.payments-section__icon {
  width: 40px;
  height: 40px;
  border-radius: 10px;
  background: rgba(var(--v-theme-primary), 0.1);
  color: rgb(var(--v-theme-primary));
  display: flex;
  align-items: center;
  justify-content: center;
}

.payments-section__icon--history {
  background: rgba(76, 175, 80, 0.12);
  color: rgb(76, 175, 80);
}

.payments-section__icon--info {
  background: rgba(var(--v-theme-primary), 0.12);
}

.payments-section__icon--add {
  background: rgba(255, 152, 0, 0.12);
  color: rgb(255, 152, 0);
}

.payments-section__title {
  font-size: 1rem;
  font-weight: 700;
  color: rgb(var(--v-theme-on-surface));
}

.payments-list-item :deep(.v-list-item__append) {
  margin-left: 16px !important;
}

.payment-qr-img {
  background: #f5f5f5;
}

/* Maintenance: gray out and overlay */
.payment-maintenance-wrap {
  position: relative;
}
.payment-maintenance-card {
  position: relative;
  filter: grayscale(0.7);
  opacity: 0.88;
  pointer-events: none;
}
.payment-maintenance-card .payment-maintenance-overlay {
  pointer-events: auto;
}
.payment-maintenance-overlay {
  position: absolute;
  inset: 0;
  background: rgba(255, 255, 255, 0.7);
  border-radius: inherit;
  display: flex;
  align-items: center;
  justify-content: center;
  gap: 0.75rem;
  padding: 0.5rem;
}
.payment-maintenance-chip {
  flex-shrink: 0;
}
.payment-maintenance-help {
  flex-shrink: 0;
}
</style>
