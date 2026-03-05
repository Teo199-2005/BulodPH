<template>
  <div class="hpa-pagination" :class="{ 'hpa-pagination--compact': compact }">
    <span v-if="showTotal" class="hpa-pagination__total">
      {{ totalLabel }}
    </span>
    <v-pagination
      :model-value="modelValue"
      :length="totalPages"
      :total-visible="visibleNumbers"
      density="compact"
      rounded="lg"
      variant="flat"
      class="hpa-pagination__nav"
      @update:model-value="$emit('update:modelValue', $event)"
    />
  </div>
</template>

<script setup lang="ts">
import { computed } from 'vue'

const props = withDefaults(
  defineProps<{
    modelValue: number
    totalItems: number
    itemsPerPage?: number
    compact?: boolean
    showTotal?: boolean
    totalVisible?: number
  }>(),
  { itemsPerPage: 10, compact: false, showTotal: true, totalVisible: 5 }
)

defineEmits<{ 'update:modelValue': [value: number] }>()

const totalPages = computed(() =>
  Math.max(1, Math.ceil(props.totalItems / props.itemsPerPage))
)

const totalLabel = computed(() => {
  const from = (props.modelValue - 1) * props.itemsPerPage + 1
  const to = Math.min(props.modelValue * props.itemsPerPage, props.totalItems)
  return `${from}-${to} of ${props.totalItems}`
})

const visibleNumbers = computed(() =>
  props.totalVisible ?? (props.compact ? 3 : 5)
)
</script>

<style scoped>
.hpa-pagination {
  display: flex;
  align-items: center;
  justify-content: space-between;
  flex-wrap: wrap;
  gap: var(--space-4, 16px);
}

.hpa-pagination--compact {
  justify-content: center;
}

.hpa-pagination__total {
  font-size: var(--text-sm, 0.8125rem);
  color: var(--text-secondary, #64748b);
}

.hpa-pagination__nav :deep(.v-pagination__item) {
  min-width: 36px;
}

.hpa-pagination__nav :deep(.v-pagination__prev),
.hpa-pagination__nav :deep(.v-pagination__next) {
  margin: 0 2px;
}
</style>
