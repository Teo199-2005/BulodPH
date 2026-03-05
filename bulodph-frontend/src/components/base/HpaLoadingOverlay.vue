<template>
  <Teleport to="body">
    <Transition name="overlay-fade">
      <div
        v-if="visible"
        class="hpa-loading-overlay"
        role="status"
        aria-live="polite"
        :aria-label="message || 'Loading'"
      >
        <div class="hpa-loading-overlay__backdrop">
          <div class="hpa-loading-overlay__watermark" aria-hidden="true"></div>
        </div>
        <div class="hpa-loading-overlay__content">
          <v-progress-circular
            indeterminate
            color="primary"
            size="56"
            width="4"
            class="hpa-loading-overlay__spinner"
          />
          <p v-if="message" class="hpa-loading-overlay__message">{{ message }}</p>
        </div>
      </div>
    </Transition>
  </Teleport>
</template>

<script setup lang="ts">
defineProps<{
  visible: boolean
  message?: string
}>()
</script>

<style scoped>
.hpa-loading-overlay {
  position: fixed;
  inset: 0;
  z-index: 9998;
  display: flex;
  align-items: center;
  justify-content: center;
}

.hpa-loading-overlay__backdrop {
  position: absolute;
  inset: 0;
  background: rgba(15, 23, 42, 0.25);
  backdrop-filter: blur(4px);
  -webkit-backdrop-filter: blur(4px);
}

.hpa-loading-overlay__watermark {
  position: absolute;
  inset: 0;
  background-image: url('/logo.png');
  background-repeat: no-repeat;
  background-position: center;
  background-size: min(35%, 220px);
  opacity: 0.06;
  pointer-events: none;
}

.hpa-loading-overlay__content {
  position: relative;
  display: flex;
  flex-direction: column;
  align-items: center;
  gap: var(--space-4, 16px);
  padding: var(--space-6, 24px);
  background: var(--glass-bg-strong, rgba(255, 255, 255, 0.95));
  border-radius: var(--radius-lg, 16px);
  box-shadow: var(--shadow-lg);
}

.hpa-loading-overlay__spinner {
  flex-shrink: 0;
}

.hpa-loading-overlay__message {
  margin: 0;
  font-size: var(--text-body, 0.9375rem);
  font-weight: 500;
  color: var(--text-primary, #1f2937);
}

.overlay-fade-enter-active,
.overlay-fade-leave-active {
  transition: opacity 0.2s ease;
}

.overlay-fade-enter-from,
.overlay-fade-leave-to {
  opacity: 0;
}
</style>
