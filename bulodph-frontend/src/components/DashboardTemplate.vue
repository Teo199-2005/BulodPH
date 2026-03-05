<template>
  <div ref="rootRef" class="page-template" :class="{ 'page-template--animate': animate }" @click.capture="handleDebouncedClick">
    <!-- Optional breadcrumbs -->
    <HpaBreadcrumb v-if="breadcrumbItems?.length" :items="breadcrumbItems" />

    <!-- Optional back link (e.g. from detail view to list) -->
    <router-link
      v-if="backTo && !breadcrumbItems?.length"
      :to="backTo"
      class="page-back"
    >
      <v-icon size="18">mdi-arrow-left</v-icon>
      <span>{{ backLabel }}</span>
    </router-link>

    <!-- Optional header slot: title, subtitle, actions -->
    <header v-if="$slots.header" class="page-header page-header--with-actions page-header--glass">
      <slot name="header" />
    </header>
    <!-- Optional simple header (title + subtitle only, no actions) -->
    <header v-else-if="title" class="page-header page-header--glass">
      <h1 class="page-title">{{ title }}</h1>
      <p v-if="subtitle" class="page-subtitle">{{ subtitle }}</p>
    </header>

    <v-progress-linear
      v-if="requestStatus.isLoading"
      indeterminate
      color="primary"
      height="3"
      class="page-loading-bar"
    />

    <!-- Main content -->
    <div class="page-template__body" v-auto-animate>
      <slot />
    </div>
  </div>
</template>

<script setup lang="ts">
import { ref } from 'vue'
import HpaBreadcrumb from '@/components/base/HpaBreadcrumb.vue'
import { useGsapReveal } from '@/composables/useGsapReveal'
import { useRequestStatusStore } from '@/stores/requestStatus'

withDefaults(
  defineProps<{
    /** Page title when using simple header (no header slot) */
    title?: string
    /** Page subtitle when using simple header */
    subtitle?: string
    /** Enable fade-in animation */
    animate?: boolean
    /** Route path or name for back link (e.g. '/shifts' or { name: 'shifts' }) */
    backTo?: string | object
    /** Label for back link */
    backLabel?: string
    /** Breadcrumb items (e.g. [{ label: 'Dashboard', to: '/client' }, { label: 'Booking' }]). When set, back link is hidden. */
    breadcrumbItems?: { label: string; to?: string }[]
  }>(),
  { title: '', subtitle: '', animate: true, backTo: undefined, backLabel: 'Back', breadcrumbItems: undefined }
)

const rootRef = ref<HTMLElement | null>(null)
useGsapReveal(rootRef, {
  selector: '.page-header, .modern-card, .vehicle-card, .hpa-data-table, .hpa-stats-card, .v-list-item, .v-data-table__tbody .v-data-table__tr, .booking-summary-indicator, .price-summary-card, .promo-voucher-card, .checkout-summary-card, .checkout-promo-card, [data-gsap-reveal]',
  y: 14,
  duration: 0.45,
  stagger: 0.055,
  start: 'top 88%',
})

const requestStatus = useRequestStatusStore()
const lastClickMap = new WeakMap<Element, number>()
const debounceWindowMs = 600

function handleDebouncedClick(event: MouseEvent) {
  const target = event.target as HTMLElement | null
  if (!target) return
  const actionEl = target.closest('button, a, .v-btn') as HTMLElement | null
  if (!actionEl) return
  if (actionEl.dataset.debounce === 'false') return
  if (actionEl.getAttribute('aria-disabled') === 'true') return
  if ((actionEl as HTMLButtonElement).disabled) return

  const now = Date.now()
  const last = lastClickMap.get(actionEl) ?? 0
  if (now - last < debounceWindowMs) {
    event.preventDefault()
    event.stopImmediatePropagation()
    return
  }
  lastClickMap.set(actionEl, now)
}
</script>

<style scoped>
.page-template {
  width: 100%;
  min-height: 100%;
}

.page-back {
  display: inline-flex;
  align-items: center;
  gap: 0.5rem;
  padding: 0.5rem 0.75rem;
  margin-bottom: 0.5rem;
  font-size: var(--text-body, 0.9375rem);
  font-weight: 600;
  color: var(--text-secondary, #64748b);
  text-decoration: none;
  border-radius: var(--radius-md, 12px);
  transition: color 0.2s ease, background 0.2s ease;
  min-height: 44px;
}

.page-back:hover {
  color: var(--role-primary, #1e3a5f);
  background: var(--hover-overlay);
}

.page-template__body {
  width: 100%;
}

.page-loading-bar {
  margin: -4px 0 12px;
  border-radius: 999px;
}
</style>
