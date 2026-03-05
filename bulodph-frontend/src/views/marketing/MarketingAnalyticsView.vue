<template>
  <DashboardTemplate title="Analytics" subtitle="Referral performance over time" :animate="true">
    <v-row class="mb-4">
      <v-col cols="6" sm="3">
        <HpaDashboardWidget
          role="marketing_staff"
          title="Link clicks"
          :value="stats.clicks"
          icon="mdi-cursor-default-click"
          trend="neutral"
          trend-value=""
          trend-label="This month"
        />
      </v-col>
      <v-col cols="6" sm="3">
        <HpaDashboardWidget
          role="marketing_staff"
          title="Sign-ups"
          :value="stats.signUps"
          icon="mdi-account-plus"
          trend="neutral"
          trend-value=""
          trend-label="From your link"
        />
      </v-col>
      <v-col cols="6" sm="3">
        <HpaDashboardWidget
          role="marketing_staff"
          title="First bookings"
          :value="stats.firstBookings"
          icon="mdi-car-side"
          trend="neutral"
          trend-value=""
          trend-label="Completed"
        />
      </v-col>
      <v-col cols="6" sm="3">
        <HpaDashboardWidget
          role="marketing_staff"
          title="Earnings"
          :value="stats.earnings"
          prefix="₱"
          icon="mdi-currency-php"
          trend="neutral"
          trend-value=""
          trend-label="This month"
        />
      </v-col>
    </v-row>

    <v-card elevation="0" rounded="lg" class="modern-card mb-4">
      <v-card-text class="pa-4">
        <h3 class="text-subtitle-1 font-weight-bold mb-3">Performance over time</h3>
        <v-table density="compact" class="analytics-table">
          <thead>
            <tr>
              <th>Period</th>
              <th class="text-end">Clicks</th>
              <th class="text-end">Sign-ups</th>
              <th class="text-end">First bookings</th>
              <th class="text-end">Earnings</th>
            </tr>
          </thead>
          <tbody>
            <tr v-for="row in timeSeries" :key="row.period">
              <td>{{ row.period }}</td>
              <td class="text-end">{{ row.clicks }}</td>
              <td class="text-end">{{ row.signUps }}</td>
              <td class="text-end">{{ row.firstBookings }}</td>
              <td class="text-end font-weight-medium">{{ formatPrice(row.earnings) }}</td>
            </tr>
          </tbody>
        </v-table>
      </v-card-text>
    </v-card>

    <v-card elevation="0" rounded="lg" class="modern-card">
      <v-card-text class="pa-4">
        <h3 class="text-subtitle-1 font-weight-bold mb-2">Tips</h3>
        <p class="text-body-2 text-medium-emphasis mb-0">Share your link and QR code on social media and in person. You earn {{ formatPrice(200) }} per sign-up and {{ formatPrice(400) }} when they complete their first booking. See <router-link :to="{ name: 'marketing-how-you-earn' }">How you earn</router-link> for details.</p>
      </v-card-text>
    </v-card>
  </DashboardTemplate>
</template>

<script setup lang="ts">
import { ref } from 'vue'
import DashboardTemplate from '@/components/DashboardTemplate.vue'
import HpaDashboardWidget from '@/components/base/HpaDashboardWidget.vue'
import { formatPrice } from '@/utils/priceFormat'
import { REFERRAL_STATS_SEED } from '@/constants/marketingSeed'

const stats = ref({
  clicks: REFERRAL_STATS_SEED.clicks ?? 42,
  signUps: REFERRAL_STATS_SEED.signUps ?? 8,
  firstBookings: 3,
  earnings: 1400,
})

const timeSeries = ref([
  { period: 'Feb 2026', clicks: 42, signUps: 8, firstBookings: 3, earnings: 1400 },
  { period: 'Jan 2026', clicks: 68, signUps: 12, firstBookings: 5, earnings: 2800 },
  { period: 'Dec 2025', clicks: 55, signUps: 9, firstBookings: 4, earnings: 2200 },
])
</script>

<style scoped>
.analytics-table th { font-weight: 600; }
</style>
