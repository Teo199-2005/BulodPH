<template>
  <div class="hpa-stepper" :class="{ 'hpa-stepper--vertical': vertical }">
    <div
      v-for="(step, index) in steps"
      :key="step.key"
      class="hpa-stepper__step"
      :class="{
        'hpa-stepper__step--completed': index < currentIndex,
        'hpa-stepper__step--current': index === currentIndex,
        'hpa-stepper__step--upcoming': index > currentIndex,
      }"
    >
      <div class="hpa-stepper__indicator">
        <v-icon v-if="index < currentIndex" icon="mdi-check" size="18" />
        <span v-else class="hpa-stepper__number">{{ index + 1 }}</span>
      </div>
      <div class="hpa-stepper__content">
        <span class="hpa-stepper__label">{{ step.label }}</span>
        <span v-if="step.description" class="hpa-stepper__desc">{{ step.description }}</span>
      </div>
      <div v-if="index < steps.length - 1" class="hpa-stepper__connector" />
    </div>
  </div>
</template>

<script setup lang="ts">
export interface StepperStep {
  key: string
  label: string
  description?: string
}

withDefaults(
  defineProps<{
    steps: StepperStep[]
    currentIndex: number
    vertical?: boolean
  }>(),
  { vertical: false }
)
</script>

<style scoped>
.hpa-stepper {
  display: flex;
  align-items: flex-start;
  gap: 0;
}

.hpa-stepper--vertical {
  flex-direction: column;
}

.hpa-stepper__step {
  display: flex;
  align-items: flex-start;
  gap: var(--space-3, 12px);
  position: relative;
}

.hpa-stepper__indicator {
  width: 32px;
  height: 32px;
  border-radius: 50%;
  display: flex;
  align-items: center;
  justify-content: center;
  flex-shrink: 0;
  font-weight: 600;
  font-size: var(--text-sm, 0.8125rem);
  transition: background var(--transition-base), color var(--transition-base);
}

.hpa-stepper__step--completed .hpa-stepper__indicator {
  background: var(--accent-green, #10b981);
  color: #fff;
}

.hpa-stepper__step--current .hpa-stepper__indicator {
  background: var(--primary-cyan, #60a5fa);
  color: #fff;
  box-shadow: 0 0 0 3px rgba(96, 165, 250, 0.3);
}

.hpa-stepper__step--upcoming .hpa-stepper__indicator {
  background: var(--surface-2, #f1f5f9);
  color: var(--text-muted, #94a3b8);
}

.hpa-stepper__number {
  line-height: 1;
}

.hpa-stepper__content {
  display: flex;
  flex-direction: column;
  gap: 0.125rem;
}

.hpa-stepper__label {
  font-size: var(--text-body, 0.9375rem);
  font-weight: 600;
  color: var(--text-primary, #1f2937);
}

.hpa-stepper__step--upcoming .hpa-stepper__label {
  color: var(--text-muted, #94a3b8);
}

.hpa-stepper__desc {
  font-size: var(--text-xs, 0.75rem);
  color: var(--text-secondary, #64748b);
}

.hpa-stepper__connector {
  position: absolute;
  top: 32px;
  left: 15px;
  width: 2px;
  height: calc(100% + 16px);
  background: var(--border-subtle, #e2e8f0);
}

.hpa-stepper__step--completed .hpa-stepper__connector {
  background: var(--accent-green, #10b981);
}

.hpa-stepper:not(.hpa-stepper--vertical) .hpa-stepper__connector {
  top: 15px;
  left: 32px;
  width: calc(100% + 16px);
  height: 2px;
}

@media (max-width: 599px) {
  .hpa-stepper {
    flex-direction: column;
  }

  .hpa-stepper__connector {
    top: 32px;
    left: 15px;
    width: 2px;
    height: calc(100% + 16px);
  }
}
</style>
