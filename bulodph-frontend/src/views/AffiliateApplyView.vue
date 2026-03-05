<template>
  <div ref="pageRef" class="public-page public-page--light">
    <section class="public-hero">
      <div class="public-hero__content">
        <span class="public-hero__badge">Affiliate Program</span>
        <h1 class="public-hero__title">Become a BulodPH Partner</h1>
        <p class="public-hero__subtitle">
          Share BulodPH and earn with referrals. Apply below to join our partner program.
        </p>
      </div>
    </section>

    <section class="public-section">
      <form class="public-card public-form scroll-reveal">
        <label>
          Full name
          <input type="text" placeholder="Your name" />
        </label>
        <label>
          Email address
          <input type="email" placeholder="you@email.com" />
        </label>
        <label>
          Company / page (optional)
          <input type="text" placeholder="Your business or page" />
        </label>
        <label>
          Tell us about your audience
          <textarea rows="4" placeholder="Short description"></textarea>
        </label>
        <button type="button">Submit application</button>
      </form>
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
  max-width: 700px;
  margin: 2rem auto 4rem;
  padding: 0 2rem;
}
.public-card {
  background: #ffffff;
  border-radius: 16px;
  padding: 1.5rem;
  box-shadow: 0 6px 18px rgba(15, 23, 42, 0.06);
}
.public-form {
  display: grid;
  gap: 1rem;
}
.public-form label {
  display: grid;
  gap: 0.5rem;
  font-size: 0.875rem;
  color: #475569;
}
.public-form input,
.public-form textarea {
  border: 1px solid #e2e8f0;
  border-radius: 10px;
  padding: 0.75rem;
  font-size: 0.95rem;
}
.public-form button {
  background: linear-gradient(180deg, #0ea5e9 0%, #0284c7 100%);
  border: none;
  color: #fff;
  border-radius: 12px;
  padding: 0.75rem 1.5rem;
  font-weight: 600;
  cursor: pointer;
}
</style>
