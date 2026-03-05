<template>
  <DashboardTemplate title="Earnings" subtitle="Payouts and balance" :animate="true">
    <v-row class="mb-4">
      <v-col cols="12" sm="4">
        <HpaDashboardWidget
          role="car_owner"
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
          role="car_owner"
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
          role="car_owner"
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
        <div class="d-flex align-center justify-space-between mb-3">
          <h3 class="text-subtitle-1 font-weight-bold d-flex align-center gap-2">
            <v-icon icon="mdi-wallet-outline" size="22" />
            Payout method
          </h3>
          <v-tooltip location="bottom">
            <template #activator="{ props: tooltipProps }">
              <v-btn v-bind="tooltipProps" variant="outlined" size="small" rounded="lg" icon="mdi-pencil" aria-label="Edit payout method" :to="{ name: 'car-owner-payout-method' }" />
            </template>
            Edit payout method
          </v-tooltip>
        </div>
        <div class="earnings-payout-method">
          <div class="earnings-payout-method__logo-wrap">
            <img src="/images/payments/gcash.svg" alt="GCash" class="earnings-payout-method__logo" />
          </div>
          <div>
            <p class="text-body-2 font-weight-medium mb-0">GCash ··· 4567 · Default</p>
            <p class="text-body-2 text-medium-emphasis mt-2 mb-0"><router-link :to="{ name: 'car-owner-payout-history' }">View payout history</router-link></p>
          </div>
        </div>
      </v-card-text>
    </v-card>

    <v-card elevation="0" rounded="lg" class="modern-card">
      <v-card-title class="text-subtitle-1 font-weight-bold d-flex align-center gap-2">
        <v-icon icon="mdi-history" size="22" />
        Earnings history
      </v-card-title>
      <v-list v-if="history.length">
        <v-list-item v-for="e in history" :key="e.id">
          <template #prepend><v-icon>mdi-calendar-check</v-icon></template>
          <v-list-item-title>{{ e.label }}</v-list-item-title>
          <v-list-item-subtitle>{{ e.date }}</v-list-item-subtitle>
          <template #append><span class="font-weight-bold text-primary">+{{ formatPrice(e.amount) }}</span></template>
        </v-list-item>
      </v-list>
      <v-card-text v-else class="pa-4">
        <HpaEmptyState
          title="No earnings yet"
          description="Completed trips will show here. List a vehicle and accept bookings to earn."
          icon="mdi-currency-php"
          action-text="Add vehicle"
          action-icon="mdi-plus"
          @action="goToAddVehicle"
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
import { CAR_OWNER_EARNINGS_SEED } from '@/constants/earningsSeed'

const router = useRouter()
const toast = useToastStore()

function goToAddVehicle() {
  router.push({ name: 'car-owner-vehicle-new' })
}

const availableBalance = ref(CAR_OWNER_EARNINGS_SEED.availableBalance)
const thisMonth = ref(CAR_OWNER_EARNINGS_SEED.thisMonth)
const totalEarned = ref(CAR_OWNER_EARNINGS_SEED.totalEarned)
const history = ref([...CAR_OWNER_EARNINGS_SEED.history])

async function loadEarnings() {
  const kpis = await getDashboardKpis('car_owner')
  if (kpis?.earningsMonth != null) thisMonth.value = kpis.earningsMonth
  if (kpis?.totalRevenue != null) totalEarned.value = kpis.totalRevenue
}

onMounted(() => loadEarnings())

const requestingPayout = ref(false)
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

<style scoped>
.earnings-payout-method {
  display: flex;
  align-items: center;
  gap: 1rem;
}
.earnings-payout-method__logo-wrap {
  flex-shrink: 0;
  width: 48px;
  height: 48px;
  display: flex;
  align-items: center;
  justify-content: center;
  background: #fff;
  border-radius: 12px;
  border: 1px solid rgba(30, 58, 95, 0.1);
  box-shadow: 0 1px 3px rgba(0, 0, 0, 0.06);
}
.earnings-payout-method__logo {
  width: 32px;
  height: 32px;
  object-fit: contain;
}
</style>
