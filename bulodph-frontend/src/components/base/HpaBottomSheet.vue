<template>
  <v-bottom-sheet
    :model-value="modelValue"
    :persistent="persistent"
    scrollable
    transition="sheet-transition"
    content-class="hpa-bottom-sheet"
    @update:model-value="$emit('update:modelValue', $event)"
  >
    <div class="hpa-bottom-sheet__handle" />
    <div class="hpa-bottom-sheet__header" v-if="title || $slots.header">
      <slot name="header">
        <h3 class="hpa-bottom-sheet__title">{{ title }}</h3>
      </slot>
    </div>
    <div class="hpa-bottom-sheet__body">
      <slot />
    </div>
    <div v-if="$slots.actions" class="hpa-bottom-sheet__actions">
      <slot name="actions" />
    </div>
  </v-bottom-sheet>
</template>

<script setup lang="ts">
withDefaults(
  defineProps<{
    modelValue: boolean
    title?: string
    persistent?: boolean
  }>(),
  { persistent: false }
)

defineEmits<{ 'update:modelValue': [v: boolean] }>()
</script>

<style scoped>
.hpa-bottom-sheet__handle {
  width: 40px;
  height: 4px;
  border-radius: 2px;
  background: var(--text-muted, #94a3b8);
  margin: 8px auto 12px;
}

.hpa-bottom-sheet__header {
  padding: 0 1.25rem 1rem;
  border-bottom: 1px solid var(--border-subtle, #e2e8f0);
}

.hpa-bottom-sheet__title {
  font-size: var(--text-lg, 1.25rem);
  font-weight: 600;
  color: var(--text-primary, #1f2937);
  margin: 0;
}

.hpa-bottom-sheet__body {
  padding: 1.25rem;
  max-height: 70vh;
  overflow-y: auto;
}

.hpa-bottom-sheet__actions {
  padding: 1rem 1.25rem;
  border-top: 1px solid var(--border-subtle, #e2e8f0);
  display: flex;
  gap: 0.5rem;
  justify-content: flex-end;
}
</style>

<style>
.hpa-bottom-sheet {
  border-radius: var(--radius-xl, 20px) var(--radius-xl, 20px) 0 0 !important;
  box-shadow: 0 -4px 24px rgba(0, 0, 0, 0.12) !important;
}
</style>
