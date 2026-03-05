<template>
  <v-card elevation="0" rounded="lg" class="modern-card promos-offers-box" :class="{ 'promos-offers-box--fill-height': fillHeight }">
    <div class="section-card-header">
      <div class="section-card-icon">
        <v-icon icon="mdi-image-multiple" size="20" />
      </div>
      <span class="section-card-title">Promos & offers</span>
    </div>
    <v-divider class="dashboard-divider" />
    <v-card-text class="promos-offers-box__body">
      <template v-if="firstPromo">
        <a
          v-if="firstPromo.linkUrl?.startsWith('http')"
          :href="firstPromo.linkUrl"
          class="promos-offers-box__link"
          target="_blank"
          rel="noopener"
        >
          <div class="promos-offers-box__image-wrap" :style="imageWrapStyle">
            <v-img :src="firstPromo.imageUrl" :alt="firstPromo.title || 'Promo'" cover class="promos-offers-box__img" />
          </div>
          <p v-if="firstPromo.title" class="promos-offers-box__title">{{ firstPromo.title }}</p>
          </a>
        <router-link
          v-else-if="firstPromo.linkUrl"
          :to="firstPromo.linkUrl"
          class="promos-offers-box__link"
        >
          <div class="promos-offers-box__image-wrap" :style="imageWrapStyle">
            <v-img :src="firstPromo.imageUrl" :alt="firstPromo.title || 'Promo'" cover class="promos-offers-box__img" />
          </div>
          <p v-if="firstPromo.title" class="promos-offers-box__title">{{ firstPromo.title }}</p>
        </router-link>
        <div v-else class="promos-offers-box__link">
          <div class="promos-offers-box__image-wrap" :style="imageWrapStyle">
            <v-img :src="firstPromo.imageUrl" :alt="firstPromo.title || 'Promo'" cover class="promos-offers-box__img" />
          </div>
          <p v-if="firstPromo.title" class="promos-offers-box__title">{{ firstPromo.title }}</p>
        </div>
      </template>
      <p v-else class="text-body-2 text-medium-emphasis mb-0">No promos at the moment.</p>
    </v-card-text>
  </v-card>
</template>

<script setup lang="ts">
import { computed } from 'vue'
import type { DashboardPromo } from '@/stores/dashboardPromos'

const props = withDefaults(
  defineProps<{
    promos: DashboardPromo[]
    /** Stretch to fill parent height (e.g. when in dashboard side-by-side layout) */
    fillHeight?: boolean
  }>(),
  { fillHeight: false }
)

const firstPromo = computed(() => props.promos[0] ?? null)

const imageWrapStyle = computed(() => {
  const p = firstPromo.value
  if (p?.imageWidth && p?.imageHeight) {
    return { aspectRatio: `${p.imageWidth} / ${p.imageHeight}` }
  }
  return {}
})
</script>

<style scoped>
.promos-offers-box {
  display: flex;
  flex-direction: column;
  background: var(--surface-2, #e2e8f0);
  overflow: hidden;
}

.promos-offers-box--fill-height {
  flex: 1;
  width: 100%;
  min-height: 0;
  display: flex;
  flex-direction: column;
}
.promos-offers-box--fill-height .promos-offers-box__body {
  flex: 1;
  display: flex;
  flex-direction: column;
  min-height: 0;
}
.promos-offers-box--fill-height .promos-offers-box__link {
  flex: 1;
  display: flex;
  flex-direction: column;
  min-height: 0;
}
.promos-offers-box--fill-height .promos-offers-box__image-wrap {
  flex: 0 1 auto;
  min-height: 280px;
  max-height: 420px;
}

.promos-offers-box__body {
  padding: 0.75rem;
  display: flex;
  flex-direction: column;
}

.promos-offers-box__link {
  display: block;
  text-decoration: none;
  color: inherit;
  border-radius: 12px;
  overflow: hidden;
  background: var(--surface-2, #e2e8f0);
  transition: box-shadow 0.2s ease, transform 0.2s ease;
}

.promos-offers-box__link:hover {
  box-shadow: 0 4px 16px rgba(0, 0, 0, 0.12);
  transform: translateY(-2px);
}

/* Image frame: use stored dimensions for aspect ratio; taller height for dashboard promos */
.promos-offers-box__image-wrap {
  position: relative;
  width: 100%;
  min-height: 160px;
  max-height: 420px;
  aspect-ratio: 16 / 9;
  overflow: hidden;
  border-radius: 12px;
  background: var(--surface-2, #e2e8f0);
}

.promos-offers-box__img {
  position: absolute;
  inset: 0;
  width: 100%;
  height: 100%;
}

/* Fill container: stretch on X axis, cover height so no empty sides */
.promos-offers-box__img :deep(.v-img__img),
.promos-offers-box__img :deep(img) {
  position: absolute;
  inset: 0;
  width: 100%;
  height: 100%;
  object-fit: cover;
  object-position: center center;
}

.promos-offers-box__title {
  flex-shrink: 0;
  margin: 0;
  padding: 0.5rem 0 0;
  font-size: 0.875rem;
  font-weight: 600;
  color: var(--text-primary, #0f172a);
}

.promos-offers-box__dims {
  margin: 0.25rem 0 0;
  font-size: 0.7rem;
  color: var(--text-secondary, #64748b);
}
</style>
