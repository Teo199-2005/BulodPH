<template>
  <DashboardTemplate title="How you earn" subtitle="Commission rules and payout schedule" :animate="true">
    <v-card elevation="0" rounded="lg" class="modern-card mb-4">
      <v-card-text class="pa-4">
        <h3 class="text-subtitle-1 font-weight-bold mb-3 d-flex align-center gap-2">
          <v-icon icon="mdi-percent" size="22" />
          Commission structure
        </h3>
        <v-list class="pa-0" density="compact">
          <v-list-item>
            <template #prepend><v-icon color="success">mdi-account-plus</v-icon></template>
            <v-list-item-title>When someone signs up with your link</v-list-item-title>
            <template #append><span class="font-weight-bold text-primary">{{ formatPrice(200) }}</span></template>
          </v-list-item>
          <v-list-item>
            <template #prepend><v-icon color="primary">mdi-car-side</v-icon></template>
            <v-list-item-title>When they complete their first booking</v-list-item-title>
            <template #append><span class="font-weight-bold text-primary">{{ formatPrice(400) }}</span></template>
          </v-list-item>
        </v-list>
        <p class="text-body-2 text-medium-emphasis mt-3 mb-0">You earn both when a referred user signs up and again when they complete their first rental. No cap on referrals.</p>
      </v-card-text>
    </v-card>

    <v-card elevation="0" rounded="lg" class="modern-card mb-4">
      <v-card-text class="pa-4">
        <h3 class="text-subtitle-1 font-weight-bold mb-2 d-flex align-center gap-2">
          <v-icon icon="mdi-calendar-clock" size="20" />
          Payout schedule
        </h3>
        <p class="text-body-2 text-medium-emphasis mb-2">Payouts run every <strong>Friday</strong>. Earnings from Monday–Sunday are processed the following week.</p>
        <p class="text-body-2 text-medium-emphasis mb-0">Minimum payout: <strong>{{ formatPrice(100) }}</strong>. Balance below minimum will roll over to the next week.</p>
      </v-card-text>
    </v-card>

    <v-card elevation="0" rounded="lg" class="modern-card">
      <v-card-text class="pa-4">
        <h3 class="text-subtitle-1 font-weight-bold mb-2 d-flex align-center gap-2">
          <v-icon icon="mdi-wallet-outline" size="20" />
          Getting paid
        </h3>
        <p class="text-body-2 text-medium-emphasis mb-0">Set your payout method in <router-link :to="{ name: 'marketing-payout-method' }">Payout method</router-link>. We send to GCash, Maya, or bank. Usually 1–3 business days after payout run.</p>
      </v-card-text>
    </v-card>
  </DashboardTemplate>
</template>

<script setup lang="ts">
import DashboardTemplate from '@/components/DashboardTemplate.vue'
import { formatPrice } from '@/utils/priceFormat'
</script>
