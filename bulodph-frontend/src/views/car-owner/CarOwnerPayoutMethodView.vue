<template>
  <HpaPayoutMethodView
    :back-to="{ name: 'car-owner-earnings' }"
    storage-key="hpa_car_owner_payout_methods"
  />
</template>

<script setup lang="ts">
import HpaPayoutMethodView from '@/components/HpaPayoutMethodView.vue'
</script>
