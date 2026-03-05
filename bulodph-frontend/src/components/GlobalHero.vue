<template>
  <div class="global-hero">
    <div class="hero-bg-parallax">
      <img
        :src="imageUrl"
        :alt="altText"
        class="hero-bg-img"
      />
    </div>
    
    <div class="hero-overlay" aria-hidden="true"></div>

    <div class="hero-watermark">
      <img src="/logo.png" alt="BulodPH" class="watermark-img" />
    </div>

    <v-container class="hero-container">
      <div class="hero-content">
        <h1 class="hero-title text-reveal-words" data-reveal="words">{{ title }}</h1>
        <p v-if="subtitle" class="hero-subtitle text-line">
          <span>{{ subtitle }}</span>
        </p>
      </div>
    </v-container>
  </div>
</template>

<script setup lang="ts">
import { onMounted } from 'vue'
import gsap from 'gsap'

defineProps<{
  title: string
  subtitle?: string
  imageUrl: string
  altText: string
}>()

onMounted(() => {
  if (window.matchMedia('(prefers-reduced-motion: reduce)').matches) {
    gsap.set('.text-reveal-words', { opacity: 1, y: 0 })
    gsap.set('.text-line span', { opacity: 1, y: 0 })
    return
  }

  const tl = gsap.timeline({ defaults: { ease: 'power3.out', duration: 0.8 } })
  
  // Animate Background
  tl.from('.hero-bg-img', { scale: 1.05, duration: 1.5, ease: 'power2.out' }, 0)
  
  // Watermark fade
  tl.from('.hero-watermark', { opacity: 0, y: -20, duration: 0.8 }, 0.2)

  // Text reveals
  tl.from('.text-reveal-words', { y: 20, opacity: 0, duration: 0.8 }, 0.4)
  tl.from('.text-line span', { y: 20, opacity: 0, duration: 0.6 }, 0.6)
})
</script>

<style scoped>
.global-hero {
  position: relative;
  min-height: 50vh;
  display: flex;
  flex-direction: column;
  justify-content: center;
  overflow: hidden;
  background-color: var(--trust-blue, #0f172a);
  padding-top: 100px;
  padding-bottom: 4rem;
}

@media (min-width: 960px) {
  .global-hero {
    min-height: 60vh;
  }
}

.hero-bg-parallax {
  position: absolute;
  inset: 0;
  width: 100%;
  height: 100%;
  z-index: 0;
}

.hero-bg-img {
  width: 100%;
  height: 100%;
  object-fit: cover;
  object-position: center;
}

.hero-overlay {
  position: absolute;
  inset: 0;
  background: linear-gradient(135deg, rgba(15, 23, 42, 0.85) 0%, rgba(14, 165, 233, 0.4) 100%);
  z-index: 1;
}

.hero-watermark {
  position: absolute;
  top: 100px; /* Below Navbar */
  left: clamp(20px, 5vw, 60px);
  z-index: 2;
  opacity: 0.85;
}

.watermark-img {
  height: 48px;
  width: auto;
  filter: brightness(0) invert(1);
}

@media (max-width: 768px) {
  .hero-watermark {
    top: 80px;
    left: 20px;
  }
  .watermark-img {
    height: 36px;
  }
}

.hero-container {
  position: relative;
  z-index: 3;
  max-width: 1200px;
  margin: 0 auto;
  text-align: center;
}

.hero-content {
  display: flex;
  flex-direction: column;
  align-items: center;
  max-width: 800px;
  margin: 0 auto;
}

.hero-title {
  color: #ffffff;
  font-size: clamp(2.5rem, 5vw, 4rem);
  font-weight: 800;
  letter-spacing: -0.02em;
  margin-bottom: 1rem;
  line-height: 1.1;
  text-shadow: 0 4px 12px rgba(0, 0, 0, 0.3);
}

.hero-subtitle {
  color: rgba(255, 255, 255, 0.9);
  font-size: clamp(1.125rem, 2vw, 1.25rem);
  line-height: 1.6;
  max-width: 600px;
  text-shadow: 0 2px 8px rgba(0, 0, 0, 0.3);
}
</style>
