<template>
  <HpaHelpView
    title="Help & getting started"
    subtitle="How to list and hand off"
    steps-title="Quick start"
    :steps="carOwnerSteps"
    :faq-items="faqItems"
  >
    <template #support>
      <p class="mb-0">
        Need more help? Contact BulodPH support from your dashboard or email support@bulodph.com.
      </p>
    </template>
  </HpaHelpView>
</template>

<script setup lang="ts">
import HpaHelpView from '@/components/HpaHelpView.vue'
import { CAR_OWNER_FAQ_SEED } from '@/constants/helpSeed'

const carOwnerSteps = [
  'Add your vehicle in <strong>My vehicles</strong> (photos, price, location).',
  'Set your <strong>availability</strong> and check the <strong>Calendar</strong> to avoid double-booking.',
  'When a booking comes in, Accept or Decline from <strong>Bookings</strong>.',
  'At hand-off: use the checklist (keys, fuel, damage). At return: do the return checklist.',
  'Get paid via <strong>Earnings</strong> and your chosen payout method.',
]

const faqItems = CAR_OWNER_FAQ_SEED
</script>
