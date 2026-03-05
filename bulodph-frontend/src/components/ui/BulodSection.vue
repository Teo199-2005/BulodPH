<template>
  <section class="bulod-section" :class="[themeClass, { 'py-16': padded, 'mb-16': padded }]" :id="id">
    <BulodWatermark v-if="watermark" :variant="watermarkVariant" :opacity="watermarkOpacity" />
    <v-container v-if="container" class="position-relative z-index-2" :class="containerClass">
      <slot></slot>
    </v-container>
    <slot v-else></slot>
  </section>
</template>

<script setup lang="ts">
import { computed } from 'vue'
import BulodWatermark from './BulodWatermark.vue'

const props = defineProps({
  id: { type: String, default: undefined },
  theme: {
    type: String,
    default: 'light', // 'light', 'navy', 'white'
  },
  watermark: {
    type: Boolean,
    default: false
  },
  watermarkVariant: {
    type: String,
    default: 'default'
  },
  watermarkOpacity: {
    type: String,
    default: 'normal'
  },
  padded: {
    type: Boolean,
    default: true
  },
  container: {
    type: Boolean,
    default: true
  },
  containerClass: {
    type: String,
    default: ''
  }
})

const themeClass = computed(() => {
  if (props.theme === 'light') return 'section-light'
  if (props.theme === 'navy') return 'bg-navy'
  if (props.theme === 'white') return 'bg-white'
  return ''
})
</script>

<style scoped>
.bulod-section {
  position: relative;
  overflow: hidden;
}
.section-light {
  background: linear-gradient(135deg, #f8fafc 0%, #e2e8f0 100%);
}
.bg-navy {
  background-color: var(--trust-blue, #0f172a);
  color: white;
}
.bg-white {
  background-color: white;
}
.z-index-2 {
  z-index: 2;
  position: relative;
}
</style>
