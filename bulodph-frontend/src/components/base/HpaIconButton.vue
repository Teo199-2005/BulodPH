<template>
  <v-tooltip :location="location" :delay="200">
    <template #activator="{ props: tooltipProps }">
      <v-btn
        v-bind="{ ...tooltipProps, ...$attrs }"
        :icon="icon"
        :variant="variant"
        :color="color"
        :size="computedSize"
        :disabled="disabled"
        :loading="loading"
        :aria-label="label"
        :to="to"
        :href="href"
        class="hpa-icon-button"
        @click="($event) => emit('click', $event)"
      >
        <v-icon v-if="icon" :icon="icon" :size="iconSize" />
        <slot v-else />
      </v-btn>
    </template>
    {{ label }}
  </v-tooltip>
</template>

<script setup lang="ts">
import { computed } from 'vue'

interface Props {
  icon?: string
  label: string
  variant?: 'text' | 'flat' | 'outlined' | 'tonal' | 'plain'
  color?: string
  size?: 'x-small' | 'small' | 'default' | 'large'
  location?: 'top' | 'bottom' | 'start' | 'end'
  disabled?: boolean
  loading?: boolean
  /** Ensures min 44px touch target on mobile */
  touchTarget?: boolean
  to?: string | object
  href?: string
}

const props = withDefaults(defineProps<Props>(), {
  variant: 'text',
  size: 'small',
  location: 'bottom',
  touchTarget: true,
})

const emit = defineEmits<{
  click: [event: MouseEvent]
}>()

const computedSize = computed(() => props.size)
const iconSize = computed(() => {
  const map: Record<string, string | number> = {
    'x-small': 18,
    small: 20,
    default: 22,
    large: 24,
  }
  return map[props.size] ?? 20
})
</script>

<style scoped>
.hpa-icon-button {
  transition: var(--transition-fast);
  min-width: 44px;
  min-height: 44px;
}

.hpa-icon-button:hover:not(:disabled) {
  transform: scale(1.05);
}

.hpa-icon-button:active:not(:disabled) {
  transform: scale(0.98);
}
</style>
