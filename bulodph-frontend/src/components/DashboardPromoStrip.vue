<template>
  <div class="dashboard-promo-strip-wrap" data-gsap-reveal>
    <div class="dashboard-promo-strip-divider dashboard-promo-strip-divider--top" aria-hidden="true"></div>
    <div class="dashboard-promo-strip">
      <div class="dashboard-promo-strip-marquee">
        <div class="dashboard-promo-strip-track">
          <div v-for="(_, idx) in 8" :key="idx" class="dashboard-promo-strip-set">
            <div class="dashboard-promo-strip-item dashboard-promo-strip-logo">
              <img src="/logo.png" alt="BulodPH" class="dashboard-promo-strip-logo-img" />
            </div>
            <span class="dashboard-promo-strip-sep" aria-hidden="true">•</span>
            <div class="dashboard-promo-strip-item dashboard-promo-strip-verse">
              <em>"The LORD will watch over your coming and going both now and forevermore."</em>
              <span class="dashboard-promo-strip-ref">— Psalm 121:8</span>
            </div>
            <span class="dashboard-promo-strip-sep" aria-hidden="true">•</span>
            <div class="dashboard-promo-strip-item dashboard-promo-strip-offer">10% off on 3-day minimum booking • Use code <strong>BULOD10</strong></div>
            <span class="dashboard-promo-strip-sep" aria-hidden="true">•</span>
          </div>
        </div>
      </div>
    </div>
    <div class="dashboard-promo-strip-divider dashboard-promo-strip-divider--bottom" aria-hidden="true"></div>
  </div>
</template>

<script setup lang="ts">
</script>

<style scoped>
.dashboard-promo-strip-wrap {
  width: 100%;
  position: relative;
  margin-bottom: 0.5rem;
}

.dashboard-promo-strip-divider {
  height: 1px;
  width: 100%;
  background: linear-gradient(90deg, rgba(15, 23, 42, 0.4) 0%, rgba(212, 175, 55, 0.4) 30%, rgba(218, 165, 32, 0.5) 50%, rgba(212, 175, 55, 0.4) 70%, rgba(15, 23, 42, 0.4) 100%);
}

.dashboard-promo-strip-divider--bottom {
  background: linear-gradient(90deg, rgba(15, 23, 42, 0.4) 0%, rgba(212, 175, 55, 0.35) 30%, rgba(218, 165, 32, 0.45) 50%, rgba(212, 175, 55, 0.35) 70%, rgba(15, 23, 42, 0.4) 100%);
}

.dashboard-promo-strip {
  padding: 0.4rem 0;
  background: linear-gradient(90deg, rgba(15, 23, 42, 0.65) 0%, rgba(15, 23, 42, 0.85) 50%, rgba(15, 23, 42, 0.65) 100%);
  border-radius: 8px;
  overflow: hidden;
  box-shadow: inset 0 1px 0 rgba(255, 255, 255, 0.05);
}

.dashboard-promo-strip-marquee {
  overflow: hidden;
  padding: 0 0.75rem;
}

.dashboard-promo-strip-track {
  display: flex;
  align-items: center;
  gap: 0;
  width: max-content;
  animation: dashboardPromoSlide 50s linear infinite;
  will-change: transform;
}

.dashboard-promo-strip-set {
  display: flex;
  align-items: center;
  gap: 0.75rem;
  flex-shrink: 0;
}

.dashboard-promo-strip-track:hover {
  animation-play-state: paused;
}

@media (prefers-reduced-motion: reduce) {
  .dashboard-promo-strip-track {
    animation: none;
  }
}

@keyframes dashboardPromoSlide {
  0% { transform: translateX(0); }
  100% { transform: translateX(-12.5%); }
}

.dashboard-promo-strip-item {
  flex-shrink: 0;
  white-space: nowrap;
  display: inline-flex;
  align-items: center;
  gap: 0.25rem;
  font-size: 0.75rem;
  color: rgba(255, 255, 255, 0.92);
  font-weight: 500;
}

.dashboard-promo-strip-logo {
  display: inline-flex;
  align-items: center;
}

.dashboard-promo-strip-logo-img {
  height: 18px;
  width: auto;
  max-width: 60px;
  object-fit: contain;
  filter: brightness(0) invert(1);
  opacity: 0.9;
}

.dashboard-promo-strip-verse {
  font-style: italic;
  flex-direction: column;
  align-items: flex-start;
  gap: 0;
  white-space: normal;
  width: 180px;
  min-width: 180px;
}

.dashboard-promo-strip-verse em {
  font-size: 0.6875rem;
  color: rgba(255, 255, 255, 0.88);
  font-style: italic;
  line-height: 1.3;
}

.dashboard-promo-strip-ref {
  font-size: 0.625rem;
  color: rgba(212, 175, 55, 0.9);
  font-style: normal;
  margin-top: 0.1rem;
}

.dashboard-promo-strip-offer {
  font-weight: 600;
  font-size: 0.6875rem;
}

.dashboard-promo-strip-offer strong {
  color: #d4af37;
  font-weight: 700;
}

.dashboard-promo-strip-sep {
  color: rgba(212, 175, 55, 0.45);
  font-size: 0.5rem;
  user-select: none;
}
</style>
