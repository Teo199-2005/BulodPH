<template>
  <DashboardTemplate title="Earnings" subtitle="Referral earnings and payouts" :animate="true">
    <v-row class="mb-4">
      <v-col cols="12" sm="4">
        <HpaDashboardWidget
          role="marketing_staff"
          title="Available balance"
          :value="availableBalance"
          prefix="₱"
          icon="mdi-wallet-outline"
          trend="neutral"
          trend-value=""
          trend-label="Ready to withdraw"
        />
        <v-btn
          variant="tonal"
          color="primary"
          size="small"
          rounded="lg"
          class="mt-3"
          block
          prepend-icon="mdi-bank-transfer-out"
          :disabled="availableBalance < 100 || requestingPayout"
          :loading="requestingPayout"
          @click="requestPayout"
        >
          Request payout
        </v-btn>
      </v-col>
      <v-col cols="12" sm="4">
        <HpaDashboardWidget
          role="marketing_staff"
          title="This month"
          :value="thisMonth"
          prefix="₱"
          icon="mdi-calendar-month"
          trend="neutral"
          trend-value=""
          trend-label="Current month"
        />
      </v-col>
      <v-col cols="12" sm="4">
        <HpaDashboardWidget
          role="marketing_staff"
          title="Total earned"
          :value="totalEarned"
          prefix="₱"
          icon="mdi-currency-php"
          trend="neutral"
          trend-value=""
          trend-label="All time"
        />
      </v-col>
    </v-row>

    <v-card elevation="0" rounded="lg" class="modern-card mb-4">
      <v-card-text class="pa-4">
        <h3 class="text-subtitle-1 font-weight-bold mb-3 d-flex align-center gap-2">
          <v-icon icon="mdi-chart-pie" size="22" />
          Breakdown
        </h3>
        <v-list class="pa-0" density="compact">
          <v-list-item>
            <v-list-item-title class="text-body-2">Available (ready to withdraw)</v-list-item-title>
            <template #append><span class="font-weight-bold text-primary">{{ formatPrice(availableBalance) }}</span></template>
          </v-list-item>
          <v-list-item>
            <v-list-item-title class="text-body-2">Pending (next payout run)</v-list-item-title>
            <template #append><span class="font-weight-medium">{{ formatPrice(pendingBalance) }}</span></template>
          </v-list-item>
        </v-list>
        <p class="text-body-2 text-medium-emphasis mt-2 mb-0">Next payout date: <strong>{{ nextPayoutDate }}</strong>. <router-link :to="{ name: 'marketing-payout-history' }">View payout history</router-link></p>
      </v-card-text>
    </v-card>

    <v-card elevation="0" rounded="lg" class="modern-card mb-4">
      <v-card-text class="pa-4">
        <div class="d-flex align-center justify-space-between mb-3">
          <h3 class="text-subtitle-1 font-weight-bold">Payout method</h3>
          <v-tooltip location="bottom">
            <template #activator="{ props: tooltipProps }">
              <v-btn v-bind="tooltipProps" variant="outlined" size="small" rounded="lg" icon="mdi-pencil" aria-label="Edit payout method" :to="{ name: 'marketing-payout-method' }" />
            </template>
            Edit payout method
          </v-tooltip>
        </div>
        <p class="text-body-2 text-medium-emphasis mb-0">GCash ··· 4567 · Default</p>
      </v-card-text>
    </v-card>

    <v-card elevation="0" rounded="lg" class="modern-card">
      <v-card-title class="text-subtitle-1 font-weight-bold d-flex align-center gap-2">
        <v-icon icon="mdi-history" size="22" />
        Earnings history
      </v-card-title>
      <v-list v-if="history.length">
        <v-list-item v-for="e in history" :key="e.id">
          <template #prepend><v-icon>mdi-link-variant</v-icon></template>
          <v-list-item-title>{{ e.label }}</v-list-item-title>
          <v-list-item-subtitle>{{ e.date }}</v-list-item-subtitle>
          <template #append><span class="font-weight-bold text-primary">+{{ formatPrice(e.amount) }}</span></template>
        </v-list-item>
      </v-list>
      <v-card-text v-else class="pa-4">
        <HpaEmptyState
          title="No earnings yet"
          description="Refer clients to earn. When they book, you'll see earnings here."
          icon="mdi-currency-php"
          action-text="How you earn"
          action-icon="mdi-help-circle-outline"
          @action="goToHowYouEarn"
        />
      </v-card-text>
    </v-card>
  </DashboardTemplate>
</template>

<script setup lang="ts">
import { ref, onMounted } from 'vue'
import { useRouter } from 'vue-router'
import DashboardTemplate from '@/components/DashboardTemplate.vue'
import HpaDashboardWidget from '@/components/base/HpaDashboardWidget.vue'
import HpaEmptyState from '@/components/base/HpaEmptyState.vue'
import { formatPrice } from '@/utils/priceFormat'
import { useToastStore } from '@/stores/toast'
import { getDashboardKpis } from '@/services/dashboard'
import { requestPayout as apiRequestPayout } from '@/services/payouts'
import { MARKETING_EARNINGS_SEED } from '@/constants/earningsSeed'

const router = useRouter()
const toast = useToastStore()
const availableBalance = ref(MARKETING_EARNINGS_SEED.availableBalance)
const thisMonth = ref(MARKETING_EARNINGS_SEED.thisMonth)
const totalEarned = ref(MARKETING_EARNINGS_SEED.totalEarned)
const pendingBalance = ref(400)
const nextPayoutDate = ref('Friday, Feb 7, 2026')
const history = ref([...MARKETING_EARNINGS_SEED.history])

async function loadEarnings() {
  const kpis = await getDashboardKpis('marketing_staff')
  if (kpis?.referralEarnings != null) thisMonth.value = kpis.referralEarnings
}

onMounted(() => loadEarnings())

const requestingPayout = ref(false)
function goToHowYouEarn() {
  router.push({ name: 'marketing-how-you-earn' })
}

async function requestPayout() {
  const amount = availableBalance.value
  if (amount < 100) return
  requestingPayout.value = true
  const result = await apiRequestPayout(amount, 'GCash')
  if (result) {
    toast.success('Payout requested. You will receive within 3-5 business days.')
    availableBalance.value = 0
  } else {
    toast.error('Could not submit payout request. Please try again.')
  }
  requestingPayout.value = false
}
</script>
