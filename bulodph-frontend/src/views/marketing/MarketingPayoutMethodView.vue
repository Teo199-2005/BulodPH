<template>
  <HpaPayoutMethodView
    :back-to="{ name: 'marketing-earnings' }"
    storage-key="hpa_marketing_payout_methods"
  />
</template>

<script setup lang="ts">
import HpaPayoutMethodView from '@/components/HpaPayoutMethodView.vue'
</script>
