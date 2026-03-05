<template>
  <HpaHelpView
    title="Help & FAQ"
    subtitle="How to book and rental policies"
    steps-title="How to use BulodPH"
    :steps="clientSteps"
    :faq-items="faqItems"
  >
    <template #support>
      <p class="mb-0">
        Need more help? <router-link to="/client/support" class="text-primary font-weight-medium">Contact support</router-link>.
      </p>
    </template>
  </HpaHelpView>
</template>

<script setup lang="ts">
import HpaHelpView from '@/components/HpaHelpView.vue'
import { CLIENT_FAQ_SEED } from '@/constants/helpSeed'

const clientSteps = [
  'Browse rides and pick a vehicle (or save favorites).',
  'Choose your dates and Book now or add to Cart.',
  'Pay at checkout with GCash or Maya.',
  'Meet the rental at pickup and enjoy your trip.',
  'Return the vehicle and complete the hand-off.',
]

const faqItems = CLIENT_FAQ_SEED
</script>
