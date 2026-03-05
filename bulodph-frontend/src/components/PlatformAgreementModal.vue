<template>
  <HpaModal
    :model-value="modelValue"
    :title="title"
    icon="mdi-file-document-outline"
    max-width="560"
    persistent
    scrollable
    :show-actions="true"
    @update:model-value="$emit('update:modelValue', $event)"
  >
    <div class="platform-agreement-body">
      <slot>
        <p
          v-for="(p, i) in paragraphs"
          :key="i"
          class="platform-agreement-p"
          v-html="renderParagraph(p)"
        />
      </slot>
    </div>
    <template #actions>
      <div class="d-flex flex-column align-stretch w-100 gap-2">
        <v-checkbox
          v-model="checked"
          color="primary"
          hide-details
          density="compact"
          class="platform-agreement-checkbox"
        >
          <template #label>
            <span class="text-body-2">I have read and accept the terms above.</span>
          </template>
        </v-checkbox>
        <v-btn
          color="primary"
          block
          rounded="lg"
          density="compact"
          :disabled="!checked"
          @click="onAccept"
        >
          Accept and continue
        </v-btn>
      </div>
    </template>
  </HpaModal>
</template>

<script setup lang="ts">
import { ref, watch } from 'vue'
import HpaModal from '@/components/base/HpaModal.vue'

const props = defineProps<{
  modelValue: boolean
  title: string
  paragraphs?: string[]
}>()

const emit = defineEmits<{
  'update:modelValue': [value: boolean]
  accept: []
}>()

const checked = ref(false)

watch(
  () => props.modelValue,
  (open) => {
    if (open) checked.value = false
  }
)

function renderParagraph(p: string): string {
  // Simple bold: **text** -> <strong>text</strong>
  return p.replace(/\*\*(.+?)\*\*/g, '<strong>$1</strong>')
}

function onAccept() {
  if (!checked.value) return
  emit('accept')
  emit('update:modelValue', false)
}
</script>

<style scoped>
.platform-agreement-body {
  max-height: 50vh;
  overflow-y: auto;
}

.platform-agreement-p {
  font-size: 0.9375rem;
  line-height: 1.55;
  color: var(--text-primary, #0f172a);
  margin-bottom: 1rem;
}

.platform-agreement-p:last-child {
  margin-bottom: 0;
}

.platform-agreement-p :deep(strong) {
  color: var(--role-primary);
}

.platform-agreement-checkbox {
  margin-bottom: 0.5rem;
}
</style>
