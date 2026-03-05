<template>
  <DashboardTemplate title="Campaigns" subtitle="Active campaigns and materials" :animate="true">
    <v-card elevation="0" rounded="lg" class="modern-card mb-4" v-for="c in campaigns" :key="c.id">
      <v-card-text class="pa-4">
        <div class="d-flex align-center justify-space-between flex-wrap gap-3 mb-2">
          <h3 class="text-subtitle-1 font-weight-bold">{{ c.name }}</h3>
          <v-chip size="small" :color="c.active ? 'success' : 'default'" :prepend-icon="c.active ? 'mdi-play-circle' : 'mdi-stop-circle-outline'" variant="tonal">{{ c.active ? 'Active' : 'Ended' }}</v-chip>
        </div>
        <p class="text-body-2 text-medium-emphasis mb-3">{{ c.description }}</p>
        <div class="d-flex gap-3 flex-wrap">
          <span class="text-caption">Clicks: <strong>{{ c.clicks }}</strong></span>
          <span class="text-caption">Sign-ups: <strong>{{ c.signUps }}</strong></span>
          <span class="text-caption">Earnings: <strong>{{ formatPrice(c.earnings) }}</strong></span>
        </div>
        <v-btn v-if="c.active" variant="tonal" size="small" rounded="lg" class="mt-2">Get materials</v-btn>
      </v-card-text>
    </v-card>

    <v-card v-if="!campaigns.length" elevation="0" rounded="lg" class="modern-card">
      <v-card-text class="text-center text-medium-emphasis py-8">No campaigns yet. New campaigns will appear here.</v-card-text>
    </v-card>
  </DashboardTemplate>
</template>

<script setup lang="ts">
import { ref } from 'vue'
import DashboardTemplate from '@/components/DashboardTemplate.vue'
import { formatPrice } from '@/utils/priceFormat'

const campaigns = ref([
  { id: '1', name: 'Isabela Launch', description: 'Promote BulodPH throughout the region. Use hashtag #BulodPH.', active: true, clicks: 120, signUps: 18, earnings: 2400 },
  { id: '2', name: 'First Ride Free', description: 'First-time users get one free day. Share your link.', active: true, clicks: 85, signUps: 12, earnings: 1500 },
])
</script>
