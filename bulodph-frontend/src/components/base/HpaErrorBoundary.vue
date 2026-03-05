<template>
  <div v-if="error" class="hpa-error-boundary">
    <div class="hpa-error-boundary__content">
      <v-icon icon="mdi-alert-circle-outline" size="48" color="error" class="mb-4" />
      <h3 class="hpa-error-boundary__title">Something went wrong</h3>
      <p class="hpa-error-boundary__message">
        {{ error.message }}
      </p>
      <v-btn
        color="primary"
        variant="flat"
        @click="reset"
      >
        Try again
      </v-btn>
    </div>
  </div>
  <slot v-else />
</template>

<script setup lang="ts">
import { ref, onErrorCaptured } from 'vue'

const error = ref<Error | null>(null)

onErrorCaptured((err) => {
  error.value = err
  return false // prevent propagation
})

function reset() {
  error.value = null
}
</script>

<style scoped>
.hpa-error-boundary {
  padding: var(--space-8, 32px);
  display: flex;
  align-items: center;
  justify-content: center;
  min-height: 200px;
}

.hpa-error-boundary__content {
  text-align: center;
  max-width: 400px;
}

.hpa-error-boundary__title {
  font-size: var(--text-lg, 1.25rem);
  font-weight: 600;
  color: var(--text-primary, #1f2937);
  margin: 0 0 var(--space-2, 8px);
}

.hpa-error-boundary__message {
  font-size: var(--text-body, 0.9375rem);
  color: var(--text-secondary, #64748b);
  margin: 0 0 var(--space-4, 16px);
}
</style>
