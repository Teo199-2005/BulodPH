<template>
  <div class="promo-strip-wrap" :class="extraClass" :data-gsap="dataGsap ?? undefined">
    <div class="promo-strip-divider promo-strip-divider-top divider-shine" aria-hidden="true" />
    <div class="promo-strip">
      <div class="promo-strip-marquee">
        <div class="promo-strip-track">
          <!-- Duplicated set so -50% translate loops seamlessly with no empty gap -->
          <template v-for="(_, setIndex) in 2" :key="setIndex">
            <div class="promo-strip-item promo-strip-logo">
              <img v-if="logoSrc" src="/logo.png" :alt="setIndex === 0 ? 'BulodPH' : ''" class="promo-strip-logo-img" :aria-hidden="setIndex !== 0" @error="logoSrc = false" />
              <span v-else class="promo-strip-logo-fallback">BulodPH</span>
            </div>
            <span class="promo-strip-sep" aria-hidden="true">•</span>
            <div class="promo-strip-item promo-strip-verse">
              <em>"The LORD will watch over your coming and going both now and forevermore."</em>
              <span class="promo-strip-ref">— Psalm 121:8</span>
            </div>
            <span class="promo-strip-sep" aria-hidden="true">•</span>
            <div class="promo-strip-item promo-strip-soon">Coming soon April 2026</div>
            <span class="promo-strip-sep" aria-hidden="true">•</span>
            <div class="promo-strip-item promo-strip-offer">10% off on 3-day minimum booking • Use code <strong>BULOD10</strong></div>
            <span class="promo-strip-sep" aria-hidden="true">•</span>
          </template>
        </div>
      </div>
    </div>
    <div class="promo-strip-divider promo-strip-divider-bottom divider-shine" aria-hidden="true" />
  </div>
</template>

<script setup lang="ts">
import { ref } from 'vue'

defineProps<{
  /** Optional extra class (e.g. gsap-custom for animations) */
  extraClass?: string
  /** Optional data-gsap value for scroll triggers */
  dataGsap?: string
}>()

const logoSrc = ref(true)
</script>

<style scoped>
/* Promo strip – gold/black dividers, marquee (self-contained so it works when used inside scoped parent) */
.promo-strip-wrap {
  --black-accent: #0a0a0c;
  box-sizing: border-box;
  width: 100vw;
  min-width: 100%;
  position: relative;
  left: 50%;
  right: 50%;
  margin-left: -50vw;
  margin-right: -50vw;
}
.promo-strip-divider {
  height: 2px;
  width: 100%;
  min-width: 100vw;
  background: linear-gradient(90deg, var(--black-accent) 0%, rgba(212, 175, 55, 0.5) 20%, rgba(218, 165, 32, 0.7) 50%, rgba(212, 175, 55, 0.5) 80%, var(--black-accent) 100%);
  box-shadow: 0 1px 0 rgba(255, 255, 255, 0.06);
}
.divider-shine {
  background-size: 200% 100%;
  background-position-x: 0%;
}
.promo-strip-divider-bottom {
  background: linear-gradient(90deg, var(--black-accent) 0%, rgba(212, 175, 55, 0.45) 25%, rgba(218, 165, 32, 0.65) 50%, rgba(212, 175, 55, 0.45) 75%, var(--black-accent) 100%);
  box-shadow: 0 -1px 0 rgba(255, 255, 255, 0.05);
}
.promo-strip {
  width: 100%;
  min-width: 100%;
  padding: 0.75rem 0;
  background: linear-gradient(90deg, #0b1220 0%, #0f172a 50%, #0b1220 100%);
  box-shadow: inset 0 1px 0 rgba(255,255,255,0.12), inset 0 -1px 0 rgba(0, 0, 0, 0.35);
  overflow: hidden;
  position: relative;
}
.promo-strip::before {
  content: '';
  position: absolute;
  inset: 0;
  background: linear-gradient(90deg, transparent, rgba(255, 255, 255, 0.12), transparent);
  opacity: 0.6;
  pointer-events: none;
}
.promo-strip-marquee {
  width: 100%;
  overflow: hidden;
  /* Light edge fade so loop is less noticeable; content fills the strip */
  mask-image: linear-gradient(90deg, transparent 0%, black 4%, black 96%, transparent 100%);
  -webkit-mask-image: linear-gradient(90deg, transparent 0%, black 4%, black 96%, transparent 100%);
}
.promo-strip-track {
  display: flex;
  align-items: center;
  gap: 1.5rem;
  padding: 0 2rem;
  width: max-content;
  animation: promoSlide 50s linear infinite;
}
.promo-strip-track:hover {
  animation-play-state: paused;
}
@media (prefers-reduced-motion: reduce) {
  .promo-strip-track {
    animation: none;
  }
}
@keyframes promoSlide {
  0% { transform: translateX(0); }
  100% { transform: translateX(-50%); }
}
.promo-strip-item {
  flex-shrink: 0;
  white-space: nowrap;
  display: inline-flex;
  align-items: center;
  gap: 0.35rem;
  font-size: 0.9375rem;
  color: rgba(255, 255, 255, 0.95);
  font-weight: 500;
}
.promo-strip-logo {
  display: inline-flex;
  align-items: center;
}
.promo-strip-logo-img {
  height: 28px;
  width: auto;
  max-width: 100px;
  object-fit: contain;
  filter: brightness(0) invert(1);
  opacity: 0.95;
}
.promo-strip-logo-fallback {
  font-weight: 700;
  font-size: 1rem;
  letter-spacing: 0.02em;
  color: #fff;
}
.promo-strip-verse {
  font-style: italic;
  flex-direction: column;
  align-items: flex-start;
  gap: 0;
  white-space: normal;
  max-width: 280px;
}
.promo-strip-verse em {
  font-size: 0.875rem;
  color: rgba(255, 255, 255, 0.9);
  font-style: italic;
}
.promo-strip-ref {
  font-size: 0.75rem;
  color: rgba(212, 175, 55, 0.9);
  font-style: normal;
  margin-top: 0.15rem;
}
.promo-strip-soon {
  font-weight: 700;
  color: #d4af37;
  letter-spacing: 0.04em;
}
.promo-strip-offer {
  font-weight: 600;
}
.promo-strip-offer strong {
  color: #d4af37;
  font-weight: 700;
}
.promo-strip-sep {
  color: rgba(212, 175, 55, 0.5);
  font-size: 0.75rem;
  user-select: none;
}
</style>
