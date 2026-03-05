<template>
  <div class="hpa-notification-badge" :class="{ 'hpa-notification-badge--dot': dot && !count }">
    <slot />
    <span
      v-if="count !== undefined && count > 0"
      class="hpa-notification-badge__count"
    >
      {{ count > max ? `${max}+` : count }}
    </span>
    <span
      v-else-if="dot"
      class="hpa-notification-badge__dot"
    />
  </div>
</template>

<script setup lang="ts">
withDefaults(
  defineProps<{
    count?: number
    max?: number
    dot?: boolean
  }>(),
  { max: 99 }
)
</script>

<style scoped>
.hpa-notification-badge {
  position: relative;
  display: inline-flex;
  align-items: center;
  justify-content: center;
}

.hpa-notification-badge__count {
  position: absolute;
  top: -6px;
  right: -6px;
  min-width: 18px;
  height: 18px;
  padding: 0 5px;
  font-size: 0.7rem;
  font-weight: 700;
  line-height: 18px;
  text-align: center;
  color: #fff;
  background: rgb(var(--v-theme-error));
  border-radius: 9999px;
  border: 2px solid var(--surface-0, #fff);
}

.hpa-notification-badge__dot {
  position: absolute;
  top: 2px;
  right: 2px;
  width: 8px;
  height: 8px;
  border-radius: 50%;
  background: rgb(var(--v-theme-error));
  border: 2px solid var(--surface-0, #fff);
}

.hpa-notification-badge--dot :deep(.v-btn) {
  padding: 8px;
}
</style>
