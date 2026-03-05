<template>
  <span class="email-verified-badge" :class="verified ? 'email-verified-badge--verified' : 'email-verified-badge--unverified'">
    <v-icon :icon="verified ? 'mdi-email-check' : 'mdi-email-alert-outline'" size="14" class="email-verified-badge__icon" />
    {{ verified ? 'Email verified' : 'Unverified' }}
  </span>
</template>

<script setup lang="ts">
withDefaults(
  defineProps<{
    verified: boolean
  }>(),
  { verified: false }
)
</script>

<style scoped>
.email-verified-badge {
  display: inline-flex;
  align-items: center;
  gap: 0.375rem;
  padding: 0.25rem 0.625rem;
  font-size: var(--text-xs, 0.75rem);
  font-weight: 600;
  border-radius: 9999px;
  letter-spacing: 0.01em;
}

.email-verified-badge__icon {
  flex-shrink: 0;
}

.email-verified-badge--verified {
  background: var(--chip-success-bg, rgba(16, 185, 129, 0.12));
  color: #059669;
}

.email-verified-badge--unverified {
  background: var(--surface-2, #f1f5f9);
  color: var(--text-secondary, #64748b);
}
</style>
