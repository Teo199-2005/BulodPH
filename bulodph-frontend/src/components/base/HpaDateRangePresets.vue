<template>
  <div class="hpa-date-range-presets">
    <v-btn-toggle v-model="active" mandatory variant="outlined" density="compact" divided>
      <v-btn
        v-for="p in presets"
        :key="p.key"
        size="small"
        :value="p.key"
        class="text-none"
      >
        {{ p.label }}
      </v-btn>
    </v-btn-toggle>
    <div v-if="showCustom" class="hpa-date-range-presets__custom mt-3">
      <v-row dense>
        <v-col cols="12" sm="6">
          <v-text-field
            :model-value="formatDate(customStart)"
            label="Start"
            type="date"
            density="compact"
            variant="outlined"
            hide-details
            @update:model-value="(v: string) => emit('update:customStart', v ? new Date(v) : null)"
          />
        </v-col>
        <v-col cols="12" sm="6">
          <v-text-field
            :model-value="formatDate(customEnd)"
            label="End"
            type="date"
            density="compact"
            variant="outlined"
            hide-details
            @update:model-value="(v: string) => emit('update:customEnd', v ? new Date(v) : null)"
          />
        </v-col>
      </v-row>
    </div>
  </div>
</template>

<script setup lang="ts">
import { computed, watch } from 'vue'

export interface DateRangePreset {
  key: string
  label: string
  getRange: () => { start: Date; end: Date }
}

const PRESETS: DateRangePreset[] = [
  {
    key: 'today',
    label: 'Today',
    getRange: () => {
      const d = new Date()
      d.setHours(0, 0, 0, 0)
      return { start: d, end: new Date() }
    },
  },
  {
    key: 'last7',
    label: 'Last 7 days',
    getRange: () => {
      const end = new Date()
      const start = new Date()
      start.setDate(start.getDate() - 6)
      start.setHours(0, 0, 0, 0)
      return { start, end }
    },
  },
  {
    key: 'last30',
    label: 'Last 30 days',
    getRange: () => {
      const end = new Date()
      const start = new Date()
      start.setDate(start.getDate() - 29)
      start.setHours(0, 0, 0, 0)
      return { start, end }
    },
  },
  {
    key: 'thisMonth',
    label: 'This month',
    getRange: () => {
      const now = new Date()
      const start = new Date(now.getFullYear(), now.getMonth(), 1)
      return { start, end: now }
    },
  },
  {
    key: 'custom',
    label: 'Custom',
    getRange: () => ({ start: new Date(), end: new Date() }),
  },
]

const props = defineProps<{
  modelValue: string
  customStart?: Date | null
  customEnd?: Date | null
}>()

const emit = defineEmits<{
  'update:modelValue': [value: string]
  'update:customStart': [value: Date | null]
  'update:customEnd': [value: Date | null]
  'range': [range: { start: Date; end: Date }]
}>()

const active = computed({
  get: () => props.modelValue,
  set: (v) => emit('update:modelValue', v),
})

const presets = computed(() => PRESETS)

const showCustom = computed(() => props.modelValue === 'custom')

function formatDate(d: Date | null | undefined): string {
  if (!d) return ''
  return d.toISOString().slice(0, 10)
}

// Emit range when preset changes
watch(
  () => [props.modelValue, props.customStart, props.customEnd],
  () => {
    if (props.modelValue === 'custom' && props.customStart && props.customEnd) {
      emit('range', { start: props.customStart, end: props.customEnd })
    } else {
      const p = PRESETS.find((x) => x.key === props.modelValue)
      if (p && p.key !== 'custom') {
        emit('range', p.getRange())
      }
    }
  },
  { immediate: true }
)
</script>

<style scoped>
.hpa-date-range-presets {
  width: 100%;
}

.hpa-date-range-presets__custom {
  padding-top: var(--space-2, 8px);
}
</style>
