<template>
  <HpaModal
    :model-value="modelValue"
    :title="title"
    :icon="confirmIcon"
    :max-width="480"
    :persistent="persistent"
    :loading="loading"
    :show-actions="true"
    :confirm-text="confirmText"
    :cancel-text="cancelText"
    :variant="variant"
    :role="role"
    @update:model-value="$emit('update:modelValue', $event)"
    @confirm="onConfirm"
    @cancel="onCancel"
  >
    <p class="hpa-confirm-modal__message">{{ message }}</p>
  </HpaModal>
</template>

<script setup lang="ts">
import { computed } from 'vue'
import HpaModal from './HpaModal.vue'
import type { ModalVariant } from './HpaModal.vue'

interface Props {
  modelValue: boolean
  title: string
  message: string
  confirmText?: string
  cancelText?: string
  variant?: ModalVariant
  persistent?: boolean
  loading?: boolean
  /** When set, header accent and confirm button use role colors */
  role?: string
}

const props = withDefaults(defineProps<Props>(), {
  confirmText: 'Confirm',
  cancelText: 'Cancel',
  variant: 'default',
  persistent: false,
  loading: false,
})

const emit = defineEmits<{
  'update:modelValue': [value: boolean]
  'confirm': []
  'cancel': []
}>()

const confirmIcon = computed(() => {
  switch (props.variant) {
    case 'danger': return 'mdi-alert-circle-outline'
    case 'success': return 'mdi-check-circle-outline'
    default: return 'mdi-help-circle-outline'
  }
})

const onConfirm = () => {
  emit('confirm')
  emit('update:modelValue', false)
}

const onCancel = () => {
  emit('cancel')
  emit('update:modelValue', false)
}
</script>

<style scoped>
.hpa-confirm-modal__message {
  margin: 0;
  font-size: var(--text-body, 0.875rem);
  line-height: 1.5;
  color: var(--text-secondary, #64748b);
  padding: 0;
}
</style>
