<template>
  <div ref="pageRef" class="public-page public-page--light">
    <section class="public-hero">
      <div class="public-hero__content">
        <span class="public-hero__badge">Trust & Safety Center</span>
        <h1 class="public-hero__title">Trust and Safety at BulodPH</h1>
        <p class="public-hero__subtitle">
          Clear policies that protect renters and rental partners across every trip.
        </p>
      </div>
    </section>

    <section class="public-section">
      <div class="public-card scroll-reveal">
        <h2>Insurance coverage</h2>
        <p>
          Overview of what is covered, optional protection plans, and how to file a claim after a trip.
        </p>
      </div>
      <div class="public-card scroll-reveal">
        <h2>ID verification process</h2>
        <p>
          We verify government ID and driver’s license to ensure safer rentals for both sides.
        </p>
      </div>
      <div class="public-card scroll-reveal">
        <h2>Damage policy</h2>
        <p>
          How inspections work, what happens if damage is reported, and the dispute flow.
        </p>
      </div>
      <div class="public-card scroll-reveal">
        <h2>Cancellation policy</h2>
        <p>
          Clear time windows for cancellations and refunds before or after pickup.
        </p>
      </div>
      <div class="public-card scroll-reveal">
        <h2>Safety guidelines</h2>
        <p>
          Best practices for handoffs, documentation, and emergency contact guidance.
        </p>
      </div>
    </section>
  </div>
</template>

<script setup lang="ts">
import { ref } from 'vue'
import { useGsapReveal } from '@/composables/useGsapReveal'

const pageRef = ref<HTMLElement | null>(null)
useGsapReveal(pageRef, { selector: '.scroll-reveal', y: 24, duration: 0.5, stagger: 0.06, start: 'top 88%' })
</script>

<style scoped>
.public-page {
  min-height: 100vh;
  background: #f8fafc;
}
.public-hero {
  padding: 5rem 2rem 2rem;
  background: linear-gradient(135deg, #e0f2fe 0%, #f8fafc 70%);
}
.public-hero__content {
  max-width: 860px;
  margin: 0 auto;
}
.public-hero__badge {
  display: inline-block;
  font-weight: 700;
  letter-spacing: 0.12em;
  font-size: 0.6875rem;
  text-transform: uppercase;
  color: #0369a1;
  background: rgba(14, 165, 233, 0.12);
  padding: 0.35rem 0.75rem;
  border-radius: 999px;
}
.public-hero__title {
  font-size: clamp(2rem, 3.5vw, 3rem);
  margin: 1rem 0 0.5rem;
  color: #0f172a;
}
.public-hero__subtitle {
  color: #475569;
  margin: 0;
  font-size: 1.125rem;
}
.public-section {
  display: grid;
  gap: 1.5rem;
  max-width: 960px;
  margin: 2rem auto 4rem;
  padding: 0 2rem;
}
.public-card {
  background: #ffffff;
  border-radius: 16px;
  padding: 1.5rem;
  box-shadow: 0 6px 18px rgba(15, 23, 42, 0.06);
}
.public-card h2 {
  margin: 0 0 0.5rem;
  font-size: 1.125rem;
  color: #0f172a;
}
.public-card p {
  margin: 0;
  color: #475569;
}
</style>
