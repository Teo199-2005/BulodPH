<template>
  <Transition name="inline-success">
    <div
      v-if="visible"
      class="hpa-inline-success"
      role="status"
      aria-live="polite"
    >
      <v-icon icon="mdi-check-circle" color="success" size="20" />
      <span>{{ message }}</span>
    </div>
  </Transition>
</template>

<script setup lang="ts">
defineProps<{
  visible: boolean
  message?: string
}>()
</script>

<style scoped>
.hpa-inline-success {
  display: inline-flex;
  align-items: center;
  gap: 0.5rem;
  padding: 0.5rem 0.75rem;
  background: var(--feedback-success-bg, rgba(16, 185, 129, 0.08));
  border: 1px solid var(--feedback-success-border, rgba(16, 185, 129, 0.35));
  border-radius: var(--radius-md, 12px);
  font-size: var(--text-sm, 0.8125rem);
  font-weight: 600;
  color: var(--accent-green, #10b981);
}

.inline-success-enter-active,
.inline-success-leave-active {
  transition: opacity 0.2s ease, transform 0.2s ease;
}

.inline-success-enter-from,
.inline-success-leave-to {
  opacity: 0;
  transform: translateY(-4px);
}
</style>
