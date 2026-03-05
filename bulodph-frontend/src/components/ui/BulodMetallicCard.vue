<template>
  <div class="bulod-metallic-card" :class="[{'hover-effect': hover}, elevationClass, roundedClass]" :style="customStyle">
    <BulodWatermark v-if="innerWatermark" opacity="low" />
    <div class="position-relative z-index-2" :class="paddingClass">
      <slot></slot>
    </div>
  </div>
</template>

<script setup lang="ts">
import { computed } from 'vue'
import BulodWatermark from './BulodWatermark.vue'

const props = defineProps({
  hover: { type: Boolean, default: false },
  innerWatermark: { type: Boolean, default: true },
  elevation: { type: Number, default: 8 },
  padding: { type: String, default: 'pa-6 pa-md-10' },
  rounded: { type: String, default: 'rounded-xl' }
})

const elevationClass = computed(() => `elevation-${props.elevation}`)
const roundedClass = computed(() => props.rounded)
const paddingClass = computed(() => props.padding)
const customStyle = computed(() => ({}))
</script>

<style scoped>
.bulod-metallic-card {
  background: linear-gradient(
    145deg,
    rgba(255, 255, 255, 0.95) 0%,
    rgba(241, 245, 249, 0.85) 50%,
    rgba(226, 232, 240, 0.9) 100%
  );
  backdrop-filter: blur(12px);
  border: 1px solid rgba(255, 255, 255, 0.8);
  box-shadow:
    inset 0 1px 1px rgba(255, 255, 255, 0.9),
    inset 0 -1px 2px rgba(0, 0, 0, 0.05),
    0 10px 25px rgba(0, 0, 0, 0.08);
  position: relative;
  overflow: hidden;
  transition: transform 0.3s cubic-bezier(0.175, 0.885, 0.32, 1.275), box-shadow 0.3s ease;
}

.bulod-metallic-card.hover-effect:hover {
  transform: translateY(-8px);
  box-shadow: 
    inset 0 1px 1px rgba(255, 255, 255, 0.9),
    0 20px 40px rgba(0, 0, 0, 0.12);
  border-color: rgba(14, 165, 233, 0.3);
}

.z-index-2 {
  z-index: 2;
  position: relative;
}
</style>
