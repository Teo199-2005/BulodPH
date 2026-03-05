<template>
  <DashboardTemplate title="Payout history" subtitle="Past payouts and status" :animate="true">
    <v-card elevation="0" rounded="lg" class="payout-history-card modern-card">
      <v-card-text class="payout-history-card__body">
        <div v-if="payouts.length" class="payout-history-list">
          <div
            v-for="p in payouts"
            :key="p.id"
            class="payout-history-item"
          >
            <div class="payout-history-item__method">
              <img
                v-if="getMethodLogo(p.method)"
                :src="getMethodLogo(p.method)"
                :alt="p.method"
                class="payout-history-item__logo"
              />
              <v-icon v-else size="28" class="payout-history-item__icon">mdi-bank-transfer-out</v-icon>
            </div>
            <div class="payout-history-item__main">
              <span class="payout-history-item__date">{{ p.date }}</span>
              <span class="payout-history-item__detail">{{ p.method }} ······ {{ p.accountSuffix }}</span>
            </div>
            <div class="payout-history-item__right">
              <span class="payout-history-item__amount">{{ formatPrice(p.amount) }}</span>
              <v-chip
                :color="p.status === 'Paid' ? 'success' : 'error'"
                size="small"
                variant="tonal"
                class="payout-history-item__status"
              >
                {{ p.status }}
              </v-chip>
            </div>
          </div>
        </div>
        <HpaEmptyState
          v-else
          title="No payouts yet"
          description="Complete trips and request a payout from Earnings."
          icon="mdi-bank-transfer-out"
          action-text="Go to Earnings"
          action-icon="mdi-wallet-outline"
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
import { CAR_OWNER_PAYOUT_HISTORY_SEED } from '@/constants/carOwnerPayoutsSeed'
import type { CarOwnerPayoutHistoryItem } from '@/constants/carOwnerPayoutsSeed'

const router = useRouter()
const payouts = ref<CarOwnerPayoutHistoryItem[]>([])

async function loadPayouts() {
  const data = await getPayoutHistory()
  if (data?.length) {
    const carOwner = data.filter(p => p.type === 'car_owner')
    payouts.value = carOwner.map(p => ({
      id: p.id,
      date: p.paidAt ? new Date(p.paidAt).toLocaleDateString('en-PH', { month: 'short', day: 'numeric', year: 'numeric' }) : (p.requestedAt ? new Date(p.requestedAt).toLocaleDateString('en-PH', { month: 'short', day: 'numeric', year: 'numeric' }) : '—'),
      amount: p.amount,
      method: p.method,
      accountSuffix: '****',
      status: p.status === 'paid' ? 'Paid' : 'Failed',
    }))
  } else {
    payouts.value = [...CAR_OWNER_PAYOUT_HISTORY_SEED]
  }
}

onMounted(() => loadPayouts())

const METHOD_LOGOS: Record<string, string> = {
  GCash: '/images/payments/gcash.svg',
  Maya: '/images/payments/maya.svg',
}

function getMethodLogo(method: string): string | undefined {
  return METHOD_LOGOS[method] ?? undefined
}

function goToEarnings() {
  router.push({ name: 'car-owner-earnings' })
}
</script>

<style scoped>
.payout-history-card__body {
  padding: 1rem 1.25rem;
}
.payout-history-list {
  display: flex;
  flex-direction: column;
  gap: 0.5rem;
}
.payout-history-item {
  display: flex;
  align-items: center;
  gap: 1rem;
  padding: 0.875rem 1rem;
  background: var(--surface-2, #f8fafc);
  border-radius: 12px;
  border: 1px solid rgba(30, 58, 95, 0.08);
  transition: background 0.15s ease;
}
.payout-history-item:hover {
  background: rgba(30, 58, 95, 0.04);
}
.payout-history-item__method {
  flex-shrink: 0;
  width: 44px;
  height: 44px;
  display: flex;
  align-items: center;
  justify-content: center;
  background: #fff;
  border-radius: 10px;
  border: 1px solid rgba(30, 58, 95, 0.1);
  box-shadow: 0 1px 2px rgba(0, 0, 0, 0.04);
}
.payout-history-item__logo {
  width: 32px;
  height: 32px;
  object-fit: contain;
}
.payout-history-item__icon {
  color: rgb(var(--v-theme-primary));
}
.payout-history-item__main {
  flex: 1;
  min-width: 0;
  display: flex;
  flex-direction: column;
  gap: 0.15rem;
}
.payout-history-item__date {
  font-size: 0.9375rem;
  font-weight: 600;
  color: var(--text-primary, #0f172a);
}
.payout-history-item__detail {
  font-size: 0.8125rem;
  color: var(--text-secondary, #64748b);
}
.payout-history-item__right {
  flex-shrink: 0;
  display: flex;
  align-items: center;
  gap: 0.5rem;
}
.payout-history-item__amount {
  font-size: 1.0625rem;
  font-weight: 700;
  color: var(--text-primary, #0f172a);
}
.payout-history-item__status {
  flex-shrink: 0;
}
</style>
