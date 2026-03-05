<template>
  <div class="price-display" :class="[`price-display--${variant}`, { 'price-display--has-discount': hasDiscount }]">
    <div class="price-display__main">
      <span class="price-display__amount price-display__amount--current">{{ formattedPrice }}</span>
      <span v-if="suffix" class="price-display__suffix">{{ suffix }}</span>
    </div>
    <template v-if="hasDiscount">
      <div class="price-display__row">
        <div class="price-display__original">
          <span class="price-display__amount price-display__amount--original">{{ formattedOriginal }}</span>
          <span v-if="suffix" class="price-display__suffix">{{ suffix }}</span>
        </div>
        <span v-if="percentOff > 0" class="price-display__off-badge">{{ percentOff }}% off</span>
      </div>
      <div class="price-display__savings">
        <span class="price-display__savings-text">{{ savingsText }}</span>
      </div>
    </template>
    <div v-else-if="promoLabel" class="price-display__promo-badge">
      {{ promoLabel }}
    </div>
  </div>
</template>

<script setup lang="ts">
import { computed } from 'vue'
import { formatPrice, discountPercent, savingsAmount } from '@/utils/priceFormat'

const props = withDefaults(
  defineProps<{
    pricePerDay: number
    originalPricePerDay?: number
    /** e.g. "10% on 1-day with BULOD10" */
    promoLabel?: string
    /** card = listing card; detail = vehicle detail / booking bar; inline = minimal */
    variant?: 'card' | 'detail' | 'inline'
    suffix?: string
  }>(),
  { variant: 'card', suffix: '/day' }
)

const hasDiscount = computed(
  () =>
    props.originalPricePerDay != null &&
    props.originalPricePerDay > 0 &&
    props.originalPricePerDay > props.pricePerDay
)

const formattedPrice = computed(() =>
  formatPrice(props.pricePerDay, { suffix: '' })
)

const formattedOriginal = computed(() =>
  props.originalPricePerDay != null ? formatPrice(props.originalPricePerDay, { suffix: '' }) : ''
)

const percentOff = computed(() =>
  hasDiscount.value && props.originalPricePerDay != null
    ? discountPercent(props.originalPricePerDay, props.pricePerDay)
    : 0
)

const savings = computed(() =>
  hasDiscount.value && props.originalPricePerDay != null
    ? savingsAmount(props.originalPricePerDay, props.pricePerDay)
    : 0
)

const savingsText = computed(() => {
  if (savings.value <= 0) return ''
  const formatted = formatPrice(savings.value, { suffix: '' })
  if (percentOff.value > 0) return `Save ${formatted} (${percentOff.value}% off)`
  return `Save ${formatted}`
})
</script>

<style scoped>
.price-display {
  display: flex;
  flex-direction: column;
  align-items: flex-start;
  gap: 2px;
}

.price-display__main {
  display: flex;
  align-items: baseline;
  flex-wrap: wrap;
  gap: 2px;
}

.price-display__amount {
  font-family: var(--font-mono, ui-monospace, monospace);
  font-weight: 700;
  font-variant-numeric: tabular-nums;
  color: var(--price-main-color);
}

.price-display__amount--current {
  font-size: 1.125rem;
  letter-spacing: 0.02em;
}

.price-display__amount--original {
  font-size: 0.8125rem;
  font-weight: 500;
  color: var(--price-original-color);
  text-decoration: line-through;
}

.price-display__row {
  display: flex;
  align-items: center;
  gap: 8px;
  flex-wrap: wrap;
}

.price-display__original {
  display: flex;
  align-items: baseline;
  gap: 2px;
}

.price-display__off-badge {
  font-size: 0.6875rem;
  font-weight: 700;
  text-transform: uppercase;
  letter-spacing: 0.03em;
  padding: 2px 6px;
  border-radius: 6px;
  background: var(--price-badge-bg);
  color: var(--price-badge-text);
}

.price-display__suffix {
  font-size: 0.875rem;
  font-weight: 600;
  color: var(--text-secondary, #64748b);
}

.price-display__savings {
  margin-top: 6px;
}

.price-display__savings-text {
  font-size: 0.75rem;
  font-weight: 600;
  color: var(--price-savings-color);
}

.price-display__promo-badge {
  display: inline-block;
  margin-top: 4px;
  padding: 2px 8px;
  font-size: 0.6875rem;
  font-weight: 600;
  text-transform: uppercase;
  letter-spacing: 0.04em;
  border-radius: 999px;
  background: var(--price-promo-bg);
  color: var(--price-promo-text);
}

/* Detail variant: larger price */
.price-display--detail .price-display__amount--current {
  font-size: 1.375rem;
}

.price-display--detail .price-display__suffix {
  font-size: 1rem;
}

/* Inline: compact */
.price-display--inline .price-display__amount--current {
  font-size: 1rem;
}

.price-display--inline .price-display__savings-text {
  font-size: 0.6875rem;
}
</style>
