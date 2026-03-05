<template>
  <div v-if="hint || error" class="hpa-form-field-hint">
    <p v-if="error" class="hpa-form-field-hint__error">
      {{ error }}
    </p>
    <p v-else-if="hint" class="hpa-form-field-hint__hint">
      {{ hint }}
    </p>
  </div>
</template>

<script setup lang="ts">
defineProps<{
  hint?: string
  error?: string
}>()
</script>

<style scoped>
.hpa-form-field-hint {
  margin-top: 0.375rem;
}

.hpa-form-field-hint__hint {
  margin: 0;
  font-size: var(--text-xs, 0.75rem);
  color: var(--text-secondary, #64748b);
}

.hpa-form-field-hint__error {
  margin: 0;
  font-size: var(--text-xs, 0.75rem);
  color: rgb(var(--v-theme-error));
}
</style>
