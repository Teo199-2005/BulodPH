<template>
  <div class="pwd-strength" :class="{ 'pwd-strength--valid': isValid }">
    <!-- Progress bar -->
    <div class="pwd-strength-bar-track">
      <div
        class="pwd-strength-bar-fill"
        :style="{ width: strengthPercent + '%' }"
        :class="barColorClass"
      />
    </div>
    <span class="pwd-strength-label">{{ strengthLabel }}</span>

    <!-- Rules checklist -->
    <ul class="pwd-strength-rules">
      <li
        v-for="rule in rules"
        :key="rule.key"
        class="pwd-strength-rule"
        :class="{ 'pwd-strength-rule--met': rule.met }"
      >
        <v-icon
          :icon="rule.met ? 'mdi-check-circle' : 'mdi-circle-outline'"
          :size="16"
          class="pwd-strength-rule-icon"
        />
        <span class="pwd-strength-rule-text">{{ rule.label }}</span>
      </li>
    </ul>
  </div>
</template>

<script setup lang="ts">
import { computed, toRef } from 'vue'
import { usePasswordValidation } from '@/composables/usePasswordValidation'

const props = defineProps<{ password: string }>()

const passwordRef = toRef(props, 'password')
const { rules, isValid, strengthPercent } = usePasswordValidation(passwordRef)

const barColorClass = computed(() => {
  if (strengthPercent.value <= 25) return 'pwd-bar--weak'
  if (strengthPercent.value <= 50) return 'pwd-bar--fair'
  if (strengthPercent.value <= 75) return 'pwd-bar--good'
  return 'pwd-bar--strong'
})

const strengthLabel = computed(() => {
  if (!props.password) return ''
  if (strengthPercent.value <= 25) return 'Weak'
  if (strengthPercent.value <= 50) return 'Fair'
  if (strengthPercent.value <= 75) return 'Good'
  return 'Strong'
})

defineExpose({ isValid })
</script>

<style scoped>
.pwd-strength {
  margin-top: 0.25rem;
  margin-bottom: 0.75rem;
  padding: 0.75rem 0.875rem;
  border-radius: 14px;
  background: rgba(241, 245, 249, 0.7);
  border: 1px solid rgba(226, 232, 240, 0.6);
  backdrop-filter: blur(8px);
  transition: border-color 0.3s, background 0.3s;
}
.pwd-strength--valid {
  border-color: rgba(34, 197, 94, 0.35);
  background: rgba(240, 253, 244, 0.7);
}

/* Progress bar */
.pwd-strength-bar-track {
  height: 5px;
  border-radius: 999px;
  background: rgba(203, 213, 225, 0.5);
  overflow: hidden;
  margin-bottom: 0.35rem;
}
.pwd-strength-bar-fill {
  height: 100%;
  border-radius: 999px;
  transition: width 0.35s ease, background 0.35s ease;
}
.pwd-bar--weak   { background: #ef4444; }
.pwd-bar--fair   { background: #f59e0b; }
.pwd-bar--good   { background: #3b82f6; }
.pwd-bar--strong { background: #22c55e; }

.pwd-strength-label {
  display: block;
  font-size: 0.7rem;
  font-weight: 700;
  letter-spacing: 0.04em;
  text-transform: uppercase;
  margin-bottom: 0.5rem;
  color: #64748b;
  min-height: 0.9rem;
}

/* Rules list */
.pwd-strength-rules {
  list-style: none;
  margin: 0;
  padding: 0;
  display: flex;
  flex-direction: column;
  gap: 0.3rem;
}
.pwd-strength-rule {
  display: flex;
  align-items: center;
  gap: 0.45rem;
  font-size: 0.8125rem;
  font-weight: 500;
  color: #94a3b8;
  transition: color 0.25s;
}
.pwd-strength-rule--met {
  color: #22c55e;
}
.pwd-strength-rule--met .pwd-strength-rule-text {
  text-decoration: line-through;
  text-decoration-color: rgba(34, 197, 94, 0.4);
}
.pwd-strength-rule-icon {
  flex-shrink: 0;
  transition: color 0.25s;
}
.pwd-strength-rule--met .pwd-strength-rule-icon {
  color: #22c55e !important;
}
</style>
