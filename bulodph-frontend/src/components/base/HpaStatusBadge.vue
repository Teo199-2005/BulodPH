<template>
  <span
    class="hpa-status-badge"
    :class="[`hpa-status-badge--${variant}`, { 'hpa-status-badge--dot': dot }]"
  >
    <v-icon v-if="icon" :icon="icon" size="14" class="hpa-status-badge__icon" />
    <span v-else-if="dot" class="hpa-status-badge__dot" />
    <slot>{{ label }}</slot>
  </span>
</template>

<script setup lang="ts">
export type StatusBadgeVariant =
  | 'success'
  | 'warning'
  | 'error'
  | 'info'
  | 'neutral'
  | 'pending'

withDefaults(
  defineProps<{
    variant?: StatusBadgeVariant
    label?: string
    dot?: boolean
    /** Material Design icon (e.g. mdi-check-circle). When set, shown instead of dot. */
    icon?: string
  }>(),
  { variant: 'neutral', dot: false, icon: undefined }
)
</script>

<style scoped>
.hpa-status-badge {
  display: inline-flex;
  align-items: center;
  gap: 0.375rem;
  padding: 0.25rem 0.625rem;
  font-size: var(--text-xs, 0.75rem);
  font-weight: 600;
  border-radius: 9999px;
  letter-spacing: 0.01em;
}

.hpa-status-badge__icon {
  flex-shrink: 0;
}

.hpa-status-badge--success {
  background: var(--chip-success-bg, rgba(16, 185, 129, 0.12));
  color: #059669;
}

.hpa-status-badge--warning {
  background: var(--chip-warning-bg, rgba(245, 158, 11, 0.12));
  color: #d97706;
}

.hpa-status-badge--error {
  background: var(--chip-error-bg, rgba(239, 68, 68, 0.12));
  color: #dc2626;
}

.hpa-status-badge--info {
  background: rgba(96, 165, 250, 0.12);
  color: #1e40af;
}

.hpa-status-badge--neutral {
  background: var(--surface-2, #f1f5f9);
  color: var(--text-secondary, #64748b);
}

.hpa-status-badge--pending {
  background: rgba(148, 163, 184, 0.15);
  color: var(--text-secondary, #64748b);
}

.hpa-status-badge__dot {
  width: 6px;
  height: 6px;
  border-radius: 50%;
  background: currentColor;
}

.hpa-status-badge--success .hpa-status-badge__dot {
  background: #059669;
}

.hpa-status-badge--warning .hpa-status-badge__dot {
  background: #d97706;
}

.hpa-status-badge--error .hpa-status-badge__dot {
  background: #dc2626;
}

.hpa-status-badge--info .hpa-status-badge__dot {
  background: #1e40af;
}
</style>
