<template>
  <div class="bulod-watermark" :class="[variantClass, opacityClass]" aria-hidden="true" :style="customStyle"></div>
</template>

<script setup lang="ts">
import { computed } from 'vue'

const props = defineProps({
  variant: {
    type: String,
    default: 'default', // 'default', 'hero-left', 'hero-right', 'explore', 'about', 'receipt'
  },
  opacity: {
    type: String,
    default: 'normal', // 'normal', 'low', 'high'
  },
  scale: {
    type: Number,
    default: 1
  }
})

const variantClass = computed(() => `watermark-${props.variant}`)
const opacityClass = computed(() => {
  if (props.opacity === 'low') return 'opacity-low'
  if (props.opacity === 'high') return 'opacity-high'
  return ''
})

const customStyle = computed(() => {
  return props.scale !== 1 ? { transform: `scale(${props.scale})` } : {}
})
</script>

<style scoped>
.bulod-watermark {
  position: absolute;
  top: 0;
  left: 0;
  right: 0;
  bottom: 0;
  /* Centralized background image that affects across all instances site-wide */
  background-image: url('/logo.png');
  background-repeat: no-repeat;
  background-position: center;
  background-size: min(22%, 160px);
  opacity: 0.06;
  pointer-events: none;
  z-index: 0;
}

.opacity-low { opacity: 0.03 !important; }
.opacity-high { opacity: 0.12 !important; }

/* Variants mapping to specific complex backgrounds */
.watermark-hero-left {
  background-image: url('/logo.png'), url('/logo.png'), url('/logo.png'), url('/logo.png');
  background-position: 10% 15%, 40% 10%, 70% 18%, 85% 45%;
  background-size: min(14%, 100px), min(18%, 120px), min(12%, 80px), min(16%, 110px);
  opacity: 0.16;
  filter: brightness(0);
  -webkit-mask-image: linear-gradient(to right, black 50%, transparent 65%);
  mask-image: linear-gradient(to right, black 50%, transparent 65%);
}

.watermark-hero-right {
  background-image: url('/logo.png'), url('/logo.png'), url('/logo.png'), url('/logo.png');
  background-position: 85% 85%, 60% 80%, 25% 75%, 5% 90%;
  background-size: min(16%, 120px), min(12%, 90px), min(18%, 130px), min(14%, 100px);
  opacity: 0.15;
}

.watermark-explore {
  background-image: url('/logo.png'), url('/logo.png');
  background-position: -5% -5%, 105% 105%;
  background-size: 35%, 45%;
  opacity: 0.03;
  filter: grayscale(100%) brightness(200%);
}

.watermark-about {
  background-image: url('/logo.png'), url('/logo.png'), url('/logo.png'), url('/logo.png');
  background-position: -10% -10%, 110% 110%, 50% 5%, 50% 95%;
  background-size: 40%, 30%, 25%, 25%;
  background-repeat: no-repeat;
  opacity: 0.1;
  filter: grayscale(100%) brightness(180%);
}

/* Receipt of Truth – watermark throughout the section */
.watermark-receipt {
  background-image: url('/logo.png'), url('/logo.png'), url('/logo.png'), url('/logo.png'), url('/logo.png'), url('/logo.png');
  background-position: 8% 15%, 50% 8%, 92% 18%, 15% 55%, 50% 85%, 88% 60%;
  background-size: min(18%, 100px), min(20%, 110px), min(16%, 90px), min(14%, 85px), min(18%, 100px), min(16%, 90px);
  background-repeat: no-repeat;
  opacity: 0.18;
  filter: grayscale(100%) brightness(180%);
}
</style>
