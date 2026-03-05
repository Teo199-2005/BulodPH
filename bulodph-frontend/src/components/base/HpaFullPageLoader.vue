<template>
  <div
    class="hpa-full-page-loader"
    role="status"
    aria-live="polite"
    :aria-label="message || 'Loading'"
  >
    <div class="hpa-full-page-loader__pattern" aria-hidden="true"></div>

    <div class="hpa-full-page-loader__content">
      <!-- Wide-diameter spinner with logo centered inside -->
      <div class="hpa-full-page-loader__spinner-wrap">
        <div class="hpa-full-page-loader__spinner-ring"></div>
        <div class="hpa-full-page-loader__spinner-ring hpa-full-page-loader__spinner-ring--2"></div>
        <div class="hpa-full-page-loader__spinner-ring hpa-full-page-loader__spinner-ring--3"></div>
        <div class="hpa-full-page-loader__logo-inner">
          <img
            v-show="logoSrc"
            src="/logo.png"
            alt="BulodPH"
            class="hpa-full-page-loader__logo"
            @error="logoSrc = false"
          />
          <span v-show="!logoSrc" class="hpa-full-page-loader__fallback">BulodPH</span>
        </div>
      </div>

      <p v-if="message" class="hpa-full-page-loader__message">{{ message }}</p>
    </div>
  </div>
</template>

<script setup lang="ts">
import { ref } from 'vue'

defineProps<{
  message?: string
}>()

const logoSrc = ref(true)
</script>

<style scoped>
.hpa-full-page-loader {
  position: fixed;
  inset: 0;
  z-index: 9999;
  background: linear-gradient(165deg, #f8fafc 0%, #f1f5f9 50%, #e2e8f0 100%);
  display: flex;
  align-items: center;
  justify-content: center;
  overflow: hidden;
}

/* Subtle logo watermark across full-page loader background */
.hpa-full-page-loader__pattern {
  position: absolute;
  inset: 0;
  background-image: url('/logo.png');
  background-repeat: repeat;
  background-size: min(28%, 200px);
  background-position: 0 0;
  opacity: 0.055;
  pointer-events: none;
}

.hpa-full-page-loader__content {
  display: flex;
  flex-direction: column;
  align-items: center;
  justify-content: center;
  gap: 1.5rem;
  position: relative;
  z-index: 1;
  padding: 2rem;
}

/* Wide-diameter spinner with logo inside */
.hpa-full-page-loader__spinner-wrap {
  position: relative;
  width: 180px;
  height: 180px;
  display: flex;
  align-items: center;
  justify-content: center;
}

.hpa-full-page-loader__spinner-ring {
  position: absolute;
  inset: 0;
  border: 5px solid transparent;
  border-top-color: var(--v-theme-action, #60a5fa);
  border-radius: 50%;
  animation: hpa-loader-spin 1.2s linear infinite;
}

.hpa-full-page-loader__spinner-ring--2 {
  inset: 14px;
  border-top-color: var(--v-theme-action-lighten-1, #93c5fd);
  opacity: 0.7;
  animation-duration: 1s;
  animation-direction: reverse;
}

.hpa-full-page-loader__spinner-ring--3 {
  inset: 28px;
  border-top-color: var(--v-theme-primary, #0f172a);
  opacity: 0.5;
  animation-duration: 0.85s;
}

/* Logo centered inside the spinner */
.hpa-full-page-loader__logo-inner {
  position: relative;
  z-index: 2;
  display: flex;
  align-items: center;
  justify-content: center;
  width: 100px;
  height: 100px;
  flex-shrink: 0;
}

.hpa-full-page-loader__logo {
  width: 100%;
  height: 100%;
  object-fit: contain;
  display: block;
}

.hpa-full-page-loader__fallback {
  font-size: 1.25rem;
  font-weight: 800;
  color: var(--trust-blue, #1e3a5f);
  letter-spacing: 0.02em;
}

.hpa-full-page-loader__message {
  font-size: 1rem;
  font-weight: 600;
  color: #1f2937;
  margin: 0;
  letter-spacing: 0.02em;
}

@keyframes hpa-loader-spin {
  0% { transform: rotate(0deg); }
  100% { transform: rotate(360deg); }
}

@media (max-width: 480px) {
  .hpa-full-page-loader__spinner-wrap {
    width: 150px;
    height: 150px;
  }

  .hpa-full-page-loader__spinner-ring--2 {
    inset: 12px;
  }

  .hpa-full-page-loader__spinner-ring--3 {
    inset: 24px;
  }

  .hpa-full-page-loader__logo-inner {
    width: 80px;
    height: 80px;
  }
}
</style>
