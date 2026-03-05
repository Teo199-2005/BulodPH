<template>
  <DashboardTemplate title="Payouts" subtitle="Payout requests and history" :animate="true">
    <v-row class="mb-4">
      <v-col cols="6" sm="6" lg="3">
        <HpaDashboardWidget role="admin" :loading="false" title="Pending" :value="payoutStats.pendingCount" icon="mdi-clock-outline" trend="neutral" :trend-value="String(payoutStats.pendingCount)" trend-label="requests" />
      </v-col>
      <v-col cols="6" sm="6" lg="3">
        <HpaDashboardWidget role="admin" :loading="false" title="Pending amount" :value="payoutStats.pendingAmount" icon="mdi-currency-php" trend="neutral" prefix="₱" trend-value="—" trend-label="to process" />
      </v-col>
      <v-col cols="6" sm="6" lg="3">
        <HpaDashboardWidget role="admin" :loading="false" title="Paid this month" :value="payoutStats.paidThisMonth" icon="mdi-check-circle" trend="neutral" :trend-value="String(payoutStats.paidThisMonth)" trend-label="payouts" />
      </v-col>
    </v-row>
    <v-tabs v-model="tab" color="primary" class="mb-4">
      <v-tab value="pending">Pending</v-tab>
      <v-tab value="history">History</v-tab>
    </v-tabs>

    <v-window v-model="tab">
      <v-window-item value="pending">
        <v-card v-for="p in pendingPayouts" :key="p.id" elevation="0" rounded="lg" class="modern-card mb-3">
          <v-card-text class="pa-4">
            <div class="d-flex align-center justify-space-between flex-wrap gap-3">
              <div>
                <div class="font-weight-bold">{{ p.recipientName }}</div>
                <div class="text-caption">{{ p.type }} · {{ p.method }} ··· {{ p.accountSuffix }}</div>
                <div class="text-body-2 text-primary font-weight-bold mt-1">{{ formatPrice(p.amount) }}</div>
              </div>
              <div class="d-flex gap-3">
                <v-btn color="success" size="small" rounded="lg" @click="approve(p.id)">Approve & pay</v-btn>
                <v-btn variant="outlined" color="error" size="small" rounded="lg" @click="reject(p.id)">Reject</v-btn>
              </div>
            </div>
          </v-card-text>
        </v-card>
        <v-card v-if="!pendingPayouts.length" elevation="0" rounded="lg" class="modern-card">
          <v-card-text class="pa-4">
            <HpaEmptyState title="No pending payouts" description="Payout requests from car rental companies and marketing partners will appear here." icon="mdi-bank-transfer-out" />
          </v-card-text>
        </v-card>
      </v-window-item>
      <v-window-item value="history">
        <v-card v-for="p in history" :key="p.id" elevation="0" rounded="lg" class="modern-card mb-3">
          <v-card-text class="pa-4">
            <div class="d-flex align-center justify-space-between flex-wrap gap-3">
              <div>
                <div class="font-weight-bold">{{ p.recipientName }}</div>
                <div class="text-caption">{{ p.date }} · {{ formatPrice(p.amount) }}</div>
                <v-chip :color="p.status === 'Paid' ? 'success' : 'error'" :prepend-icon="p.status === 'Paid' ? 'mdi-check-circle' : 'mdi-close-circle'" size="x-small" variant="tonal" class="mt-1">{{ p.status }}</v-chip>
              </div>
            </div>
          </v-card-text>
        </v-card>
        <v-card v-if="!history.length" elevation="0" rounded="lg" class="modern-card">
          <v-card-text class="pa-4">
            <HpaEmptyState title="No payout history yet" description="Approved and rejected payouts will appear here." icon="mdi-history" />
          </v-card-text>
        </v-card>
      </v-window-item>
    </v-window>

    <HpaConfirmModal
      v-model="showApproveConfirm"
      title="Approve & pay?"
      :message="approveConfirmMessage"
      confirm-text="Approve & pay"
      cancel-text="Cancel"
      variant="default"
      :loading="approving"
      @confirm="confirmApprove"
    />
    <HpaConfirmModal
      v-model="showRejectConfirm"
      title="Reject payout request?"
      message="The requester will be notified. They can submit a new request later."
      confirm-text="Reject"
      cancel-text="Cancel"
      variant="danger"
      :loading="rejecting"
      @confirm="confirmReject"
    />
  </DashboardTemplate>
</template>

<script setup lang="ts">
import { ref, computed, onMounted } from 'vue'
import DashboardTemplate from '@/components/DashboardTemplate.vue'
import HpaDashboardWidget from '@/components/base/HpaDashboardWidget.vue'
import HpaEmptyState from '@/components/base/HpaEmptyState.vue'
import HpaConfirmModal from '@/components/base/HpaConfirmModal.vue'
import { formatPrice } from '@/utils/priceFormat'
import { useToastStore } from '@/stores/toast'
import { getPendingPayouts, getPayoutHistory, approvePayout as apiApprovePayout, rejectPayout as apiRejectPayout } from '@/services/payouts'
import { PENDING_PAYOUTS_SEED, PAYOUT_HISTORY_SEED } from '@/constants/payoutsSeed'
import type { PayoutRequestSeed, PayoutHistorySeed } from '@/constants/payoutsSeed'

const toast = useToastStore()
const tab = ref('pending')
const showApproveConfirm = ref(false)
const showRejectConfirm = ref(false)
const approvePayoutId = ref<string | null>(null)
const rejectPayoutId = ref<string | null>(null)
const approving = ref(false)
const rejecting = ref(false)
const loading = ref(false)

const pendingPayouts = ref<PayoutRequestSeed[]>([])
const history = ref<PayoutHistorySeed[]>([])

function mapPendingFromApi(item: { id: string; payeeName: string; type: string; method: string; amount: number }): PayoutRequestSeed {
  return {
    id: item.id,
    recipientName: item.payeeName,
    type: item.type === 'car_owner' ? 'Car rental owner' : item.type === 'marketing' ? 'Marketing' : item.type,
    method: item.method,
    accountSuffix: '****',
    amount: item.amount,
  }
}

function mapHistoryFromApi(item: { id: string; payeeName: string; amount: number; status: string; paidAt?: string; requestedAt: string }): PayoutHistorySeed {
  const dateStr = item.paidAt || item.requestedAt || ''
  const date = dateStr ? new Date(dateStr).toLocaleDateString('en-PH', { month: 'short', day: 'numeric', year: 'numeric' }) : '—'
  return {
    id: item.id,
    recipientName: item.payeeName,
    date,
    amount: item.amount,
    status: item.status === 'paid' ? 'Paid' : 'Failed',
  }
}

async function loadPayouts() {
  loading.value = true
  const [pendingData, historyData] = await Promise.all([getPendingPayouts(), getPayoutHistory()])
  if (pendingData?.length) {
    pendingPayouts.value = pendingData.map(mapPendingFromApi)
  } else {
    pendingPayouts.value = [...PENDING_PAYOUTS_SEED]
  }
  if (historyData?.length) {
    history.value = historyData.map(mapHistoryFromApi)
  } else {
    history.value = [...PAYOUT_HISTORY_SEED]
  }
  loading.value = false
}

onMounted(() => loadPayouts())

const payoutStats = computed(() => {
  const pending = pendingPayouts.value
  const hist = history.value
  const now = new Date()
  const thisMonth = now.getFullYear() * 100 + now.getMonth()
  const paidThisMonth = hist.filter(p => {
    const d = new Date(p.date)
    return d.getFullYear() * 100 + d.getMonth() === thisMonth && p.status === 'Paid'
  }).length
  return {
    pendingCount: pending.length,
    pendingAmount: pending.reduce((s, p) => s + p.amount, 0),
    paidThisMonth,
  }
})

const approveConfirmMessage = ref('')

function approve(id: string) {
  const p = pendingPayouts.value.find(x => x.id === id)
  if (p) {
    approvePayoutId.value = id
    approveConfirmMessage.value = `Send ${formatPrice(p.amount)} to ${p.recipientName}? This will process the payout.`
    showApproveConfirm.value = true
  }
}

function reject(id: string) {
  rejectPayoutId.value = id
  showRejectConfirm.value = true
}

async function confirmApprove() {
  if (!approvePayoutId.value) return
  approving.value = true
  const ok = await apiApprovePayout(approvePayoutId.value)
  if (ok) {
    toast.success('Payout approved and sent.')
    await loadPayouts()
  } else {
    toast.error('Could not approve payout. Please try again.')
  }
  approving.value = false
  approvePayoutId.value = null
  showApproveConfirm.value = false
}

async function confirmReject() {
  if (!rejectPayoutId.value) return
  rejecting.value = true
  const ok = await apiRejectPayout(rejectPayoutId.value)
  if (ok) {
    toast.warning('Payout request rejected.')
    await loadPayouts()
  } else {
    toast.error('Could not reject payout. Please try again.')
  }
  rejecting.value = false
  rejectPayoutId.value = null
  showRejectConfirm.value = false
}
</script>
