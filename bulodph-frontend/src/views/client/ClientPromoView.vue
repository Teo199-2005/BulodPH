<template>
  <DashboardTemplate title="Promos" subtitle="Discounts and offers." :animate="true">
    <!-- How to use -->
    <v-card elevation="0" rounded="lg" class="promo-how-card modern-card mb-5">
      <v-card-text class="pa-4">
        <div class="promo-how-header d-flex align-center mb-3">
          <div class="promo-how-icon">
            <v-icon icon="mdi-information-outline" size="24" />
          </div>
          <h3 class="text-subtitle-1 font-weight-bold mb-0">How to use</h3>
        </div>
        <div class="promo-steps">
          <div v-for="(step, i) in howToSteps" :key="i" class="promo-step">
            <span class="promo-step__num">{{ i + 1 }}</span>
            <span class="promo-step__text">{{ step }}</span>
          </div>
        </div>
      </v-card-text>
    </v-card>

    <!-- Active promos -->
    <h3 class="text-subtitle-1 font-weight-bold mb-3">Active promos</h3>
    <div v-if="activePromos.length" class="promo-grid">
      <v-card
        v-for="promo in activePromos"
        :key="promo.id"
        elevation="0"
        rounded="lg"
        class="promo-card modern-card"
      >
        <div class="promo-card__accent" />
        <v-card-text class="promo-card__body">
          <div class="d-flex align-center justify-space-between flex-wrap gap-2 mb-2">
            <v-chip
              color="primary"
              size="default"
              variant="flat"
              class="promo-card__code font-weight-bold"
              prepend-icon="mdi-ticket-percent"
            >
              {{ promo.code }}
            </v-chip>
            <v-tooltip location="bottom">
              <template #activator="{ props: tooltipProps }">
                <v-btn
                  v-bind="tooltipProps"
                  variant="tonal"
                  size="small"
                  icon="mdi-content-copy"
                  aria-label="Copy code"
                  class="promo-card__copy"
                  @click="copyCode(promo.code)"
                />
              </template>
              Copy code
            </v-tooltip>
          </div>
          <h4 class="promo-card__title text-body-1 font-weight-bold mb-1">{{ promo.title }}</h4>
          <p class="promo-card__desc text-body-2 text-medium-emphasis mb-2">{{ promo.description }}</p>
          <div class="promo-card__expiry text-caption text-medium-emphasis mb-3">
            <v-icon size="14" class="me-1">mdi-calendar-clock</v-icon>
            Valid until {{ promo.expiry }}
          </div>
          <v-expansion-panels variant="accordion" class="promo-card__terms">
            <v-expansion-panel>
              <v-expansion-panel-title class="text-body-2 py-2">
                Terms & conditions
              </v-expansion-panel-title>
              <v-expansion-panel-text>
                <p class="text-body-2 text-medium-emphasis mb-0">{{ promo.terms }}</p>
              </v-expansion-panel-text>
            </v-expansion-panel>
          </v-expansion-panels>
        </v-card-text>
      </v-card>
    </div>

    <v-card v-else elevation="0" rounded="lg" class="modern-card">
      <v-card-text class="pa-4">
        <p class="text-body-2 text-medium-emphasis mb-0">No active promos at the moment. Check back later.</p>
      </v-card-text>
    </v-card>
  </DashboardTemplate>
</template>

<script setup lang="ts">
import { computed } from 'vue'
import DashboardTemplate from '@/components/DashboardTemplate.vue'
import { useCopyToClipboard } from '@/composables/useCopyToClipboard'
import { getActivePromos } from '@/constants/promosSeed'

const howToSteps = [
  'Browse and select a vehicle.',
  'Schedule your booking and go to Checkout.',
  'Enter the promo code in the "Promo code" field.',
  'Discount will apply to your total.',
]

const { copy } = useCopyToClipboard('Promo code copied. Use it at checkout.')
const activePromos = computed(() => getActivePromos())

function copyCode(code: string) {
  copy(code)
}
</script>

<style scoped>
.promo-how-card {
  background: rgba(var(--v-theme-primary), 0.06);
  border: 1px solid rgba(var(--v-theme-primary), 0.12);
}

.promo-how-header {
  gap: var(--space-5, 20px);
}

.promo-how-icon {
  width: 40px;
  height: 40px;
  border-radius: 10px;
  background: rgb(var(--v-theme-primary));
  color: rgb(var(--v-theme-on-primary));
  display: flex;
  align-items: center;
  justify-content: center;
  flex-shrink: 0;
}

.promo-steps {
  display: flex;
  flex-direction: column;
  gap: 0.5rem;
}

.promo-step {
  display: flex;
  align-items: flex-start;
  gap: 0.75rem;
}

.promo-step__num {
  width: 22px;
  height: 22px;
  border-radius: 50%;
  background: rgb(var(--v-theme-primary));
  color: rgb(var(--v-theme-on-primary));
  font-size: 0.75rem;
  font-weight: 700;
  display: inline-flex;
  align-items: center;
  justify-content: center;
  flex-shrink: 0;
}

.promo-step__text {
  font-size: 0.875rem;
  color: rgba(var(--v-theme-on-surface), 0.8);
  line-height: 1.4;
}

.promo-grid {
  display: grid;
  grid-template-columns: repeat(auto-fill, minmax(320px, 1fr));
  gap: 1.25rem;
}

.promo-card {
  position: relative;
  overflow: hidden;
  border: 1px solid rgba(var(--v-border-color), var(--v-border-opacity));
  transition: box-shadow 0.2s ease, border-color 0.2s ease;
}

.promo-card:hover {
  box-shadow: 0 4px 20px rgba(0, 0, 0, 0.08);
  border-color: rgba(var(--v-theme-primary), 0.25);
}

.promo-card__accent {
  position: absolute;
  top: 0;
  left: 0;
  width: 4px;
  height: 100%;
  background: linear-gradient(to bottom, rgb(var(--v-theme-primary)), rgba(var(--v-theme-primary), 0.6));
  border-radius: 4px 0 0 4px;
}

.promo-card__body {
  padding-left: 1rem;
}

.promo-card__code {
  letter-spacing: 0.04em;
}

.promo-card__title {
  color: rgb(var(--v-theme-on-surface));
  line-height: 1.3;
}

.promo-card__desc {
  line-height: 1.45;
}

.promo-card__expiry {
  display: inline-flex;
  align-items: center;
}

.promo-card__terms {
  box-shadow: none;
}

.promo-card__terms :deep(.v-expansion-panel) {
  background: transparent;
}

.promo-card__terms :deep(.v-expansion-panel-title) {
  min-height: 40px;
  padding-inline-end: 0.5rem;
}

.promo-card__terms :deep(.v-expansion-panel-text__wrapper) {
  padding: 0 0 0.25rem 0;
}
</style>
