<template>
  <DashboardTemplate title="Payout history" subtitle="Past payouts and status." :animate="true">
    <v-card elevation="0" rounded="lg" class="payout-history-section modern-card">
      <div class="payout-history-section__accent" />
      <div class="payout-history-section__header">
        <div class="payout-history-section__icon">
          <v-icon icon="mdi-bank-transfer-out" size="22" />
        </div>
        <span class="payout-history-section__title">Payout history</span>
      </div>
      <v-divider class="mx-4" />
      <v-card-text class="pa-4">
        <template v-if="payouts.length">
          <div class="payout-list">
            <div v-for="p in payouts" :key="p.id" class="payout-item">
              <v-icon size="20" class="payout-item__icon">mdi-bank-transfer-out</v-icon>
              <div class="payout-item__main">
                <span class="payout-item__line">{{ p.date }} · {{ p.method }} {{ p.accountSuffix }}</span>
                <span class="payout-item__status">{{ p.status }}</span>
              </div>
              <div class="payout-item__right">
                <span class="payout-item__amount">{{ formatPrice(p.amount) }}</span>
                <v-chip :color="p.status === 'Paid' ? 'success' : 'error'" :prepend-icon="p.status === 'Paid' ? 'mdi-check-circle' : 'mdi-close-circle'" size="small" variant="tonal" density="compact">{{ p.status }}</v-chip>
              </div>
            </div>
          </div>
        </template>
        <HpaEmptyState
          v-else
          title="No payouts yet"
          description="Earn from referrals and request a payout from Earnings."
          icon="mdi-bank-transfer-outline"
          action-text="Go to Earnings"
          action-icon="mdi-currency-usd"
          @action="goToEarnings"
        />
      </v-card-text>
    </v-card>
  </DashboardTemplate>
</template>

<script setup lang="ts">
import { ref, onMounted } from 'vue'
import { useRouter } from 'vue-router'
import DashboardTemplate from '@/components/DashboardTemplate.vue'
import HpaEmptyState from '@/components/base/HpaEmptyState.vue'
import { formatPrice } from '@/utils/priceFormat'
import { getPayoutHistory } from '@/services/payouts'
import { MARKETING_PAYOUT_HISTORY_SEED } from '@/constants/marketingPayoutsSeed'
import type { MarketingPayoutHistoryItem } from '@/constants/marketingPayoutsSeed'

const router = useRouter()
const payouts = ref<MarketingPayoutHistoryItem[]>([])

async function loadPayouts() {
  const data = await getPayoutHistory()
  if (data?.length) {
    const marketing = data.filter(p => p.type === 'marketing')
    payouts.value = marketing.map(p => ({
      id: p.id,
      date: p.paidAt ? new Date(p.paidAt).toLocaleDateString('en-PH', { month: 'short', day: 'numeric', year: 'numeric' }) : (p.requestedAt ? new Date(p.requestedAt).toLocaleDateString('en-PH', { month: 'short', day: 'numeric', year: 'numeric' }) : '—'),
      amount: p.amount,
      method: p.method,
      accountSuffix: '****',
      status: p.status === 'paid' ? 'Paid' : 'Failed',
    }))
  } else {
    payouts.value = [...MARKETING_PAYOUT_HISTORY_SEED]
  }
}

function goToEarnings() {
  router.push({ name: 'marketing-earnings' })
}

onMounted(() => loadPayouts())
</script>

<style scoped>
.payout-history-section {
  position: relative;
  overflow: hidden;
  border: 1px solid rgba(var(--v-border-color), var(--v-border-opacity));
}

.payout-history-section__accent {
  position: absolute;
  top: 0;
  left: 0;
  width: 4px;
  height: 100%;
  background: linear-gradient(to bottom, rgb(76, 175, 80), rgba(76, 175, 80, 0.5));
  border-radius: 4px 0 0 4px;
}

.payout-history-section__header {
  display: flex;
  align-items: center;
  gap: 0.75rem;
  padding: 1rem 1rem 0.5rem;
}

.payout-history-section__icon {
  width: 40px;
  height: 40px;
  border-radius: 10px;
  background: rgba(76, 175, 80, 0.12);
  color: rgb(76, 175, 80);
  display: flex;
  align-items: center;
  justify-content: center;
}

.payout-history-section__title {
  font-size: 1rem;
  font-weight: 700;
  color: rgb(var(--v-theme-on-surface));
}

.payout-list {
  display: flex;
  flex-direction: column;
  gap: 0.5rem;
}

.payout-item {
  display: flex;
  align-items: center;
  gap: 0.75rem;
  padding: 0.625rem 0.75rem;
  border-radius: 10px;
  border: 1px solid rgba(var(--v-border-color), var(--v-border-opacity));
  background: rgba(0, 0, 0, 0.02);
}

.payout-item__icon {
  color: rgb(var(--v-theme-primary));
  flex-shrink: 0;
}

.payout-item__main {
  flex: 1;
  min-width: 0;
}

.payout-item__line {
  display: block;
  font-size: 0.875rem;
  font-weight: 500;
  color: rgb(var(--v-theme-on-surface));
}

.payout-item__status {
  display: block;
  font-size: 0.75rem;
  color: rgba(var(--v-theme-on-surface), 0.65);
  margin-top: 2px;
}

.payout-item__right {
  display: flex;
  align-items: center;
  gap: 0.5rem;
  flex-shrink: 0;
}

.payout-item__amount {
  font-size: 0.9375rem;
  font-weight: 700;
  color: rgb(var(--v-theme-on-surface));
}
</style>
