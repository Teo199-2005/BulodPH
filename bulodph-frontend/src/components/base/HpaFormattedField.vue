<template>
  <v-text-field
    v-bind="$attrs"
    :model-value="displayValue"
    @update:model-value="onInput"
  />
</template>

<script setup lang="ts">
import { computed } from 'vue'
import { formatInput, type InputFormat } from '@/utils/inputFormatters'

const props = withDefaults(
  defineProps<{
    modelValue?: string | number | null
    format?: InputFormat
  }>(),
  { format: 'none' }
)

const emit = defineEmits<{ 'update:modelValue': [value: string] }>()

const displayValue = computed(() => String(props.modelValue ?? ''))

function onInput(v: string | number | null | undefined) {
  const formatted = formatInput(v, props.format)
  emit('update:modelValue', formatted)
}
</script>
