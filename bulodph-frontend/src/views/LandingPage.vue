<template>
  <PublicLayout>
    <div ref="landingRef" class="landing-page" v-auto-animate>


    <!-- Hero – reference layout: white left, blue right, split watermarks -->
    <section class="hero hero-with-content has-watermark" id="home">
      <div class="section-watermark hero-watermark-left" aria-hidden="true"></div>
      <div class="hero-watermark-right" aria-hidden="true"></div>
      <div class="hero-container">
        <div class="hero-content-col">
          <div class="hero-content-inner" :class="{ 'animate-in': heroVisible }">
            <div class="hero-logo">
              <img v-if="logoSrc" src="/logo.png" alt="BulodPH" class="hero-logo-img" @error="logoSrc = false" />
              <span v-else class="hero-logo-fallback text-h4 font-weight-bold">BulodPH</span>
            </div>
            <h1 class="hero-title">
              <span class="text-line">Verified Car Rentals throughout the region,</span>
              <span class="text-line">
                <span class="hero-title-accent-text text-wipe">Booked in Minutes</span>
              </span>
            </h1>
            <p class="hero-tagline">
              Transparent pricing, verified partners, and local support throughout the region.
            </p>
            <div class="hero-tags">
              <span class="hero-tag">
                <ShieldCheck :size="16" class="lucide-icon" aria-hidden="true" />
                Verified partners
              </span>
              <span class="hero-tag">
                <Lock :size="16" class="lucide-icon" aria-hidden="true" />
                Escrow payments
              </span>
              <span class="hero-tag">
                <LifeBuoy :size="16" class="lucide-icon" aria-hidden="true" />
                24/7 support
              </span>
            </div>
            <div class="hero-cta-group">
              <v-btn
                class="hero-cta hero-cta-primary"
                elevation="0"
                @click="$router.push('/login')"
              >
                <Car :size="22" class="lucide-icon lucide-icon-start" aria-hidden="true" />
                Browse Cars
              </v-btn>
              <v-btn
                class="hero-cta hero-cta-contact"
                variant="text"
                @click="$router.push('/register')"
              >
                <PhoneCall :size="22" class="lucide-icon lucide-icon-start" aria-hidden="true" />
                Become a Partner
              </v-btn>
            </div>
            <div class="hero-contact-row">
              <a :href="CONTACT.phoneHref" class="hero-phone">
                <Phone :size="20" class="lucide-icon" aria-hidden="true" />
                <span>{{ CONTACT.phone }}</span>
              </a>
              <span class="hero-contact-divider" aria-hidden="true">|</span>
              <div class="hero-socials">
                <a :href="SOCIAL.facebook" target="_blank" rel="noopener noreferrer" class="hero-social-link" aria-label="Facebook">
                  <v-icon icon="mdi-facebook" size="22" />
                </a>
                <a :href="SOCIAL.instagram" target="_blank" rel="noopener noreferrer" class="hero-social-link" aria-label="Instagram">
                  <v-icon icon="mdi-instagram" size="22" />
                </a>
                <a :href="SOCIAL.twitter" target="_blank" rel="noopener noreferrer" class="hero-social-link" aria-label="Twitter">
                  <v-icon icon="mdi-twitter" size="22" />
                </a>
              </div>
            </div>
          </div>
        </div>
        <div class="hero-image-col">
          <div ref="heroParallaxRef" class="hero-parallax">
            <div class="hero-parallax-layer" data-depth="0.15">
              <div class="hero-image-wrap-ref">
                <img
                  :src="heroImageSrc"
                  alt="BulodPH – Car rentals throughout the region"
                  class="hero-image-ref"
                  loading="eager"
                  decoding="async"
                  @error="heroImageSrc = IMAGES.hero.carScenic"
                />
              </div>
            </div>
          </div>
        </div>
      </div>
    </section>

    <!-- Promo strip – between Hero and About -->
    <LandingPromoStrip />

    <!-- About BulodPH – Safe Byahe, Always (restyled with safety focus) -->
    <BulodSection theme="light" id="about" :watermark="true" watermarkVariant="about" :padded="true" class="about-new-section about-safe-byahe">
      <BulodMetallicCard class="about-new-container section-container">
        <div class="about-new-inner scroll-reveal scroll-reveal-up gsap-custom" data-gsap="about">
          <div class="about-new-grid about-safe-byahe-grid">
            <div class="about-new-card about-safe-byahe-card">
              <div class="about-safe-byahe-image-wrap">
                <img
                  src="/images/about-safe-byahe.png"
                  alt="Nasa palad mo ang kotse. From searching to booking to driving—everything in one app. BulodPH."
                  class="about-new-image about-safe-byahe-image"
                  loading="lazy"
                  decoding="async"
                />
              </div>
              <div class="about-new-card-body about-safe-byahe-card-body">
                <span class="about-new-card-title">Why BulodPH</span>
                <ul class="about-new-list">
                  <li><v-icon icon="mdi-map-marker-outline" size="18" /> Local rental partners</li>
                  <li><v-icon icon="mdi-file-check-outline" size="18" /> Verified documents</li>
                  <li><v-icon icon="mdi-cash-check" size="18" /> Transparent pricing</li>
                  <li><v-icon icon="mdi-phone-outline" size="18" /> Human support</li>
                </ul>
              </div>
            </div>
            <div class="about-new-content about-safe-byahe-content">
              <span class="about-new-badge">About us</span>
              <h2 class="about-new-title about-safe-byahe-title">
                Safe byahe, <span class="title-accent title-accent-teal">always.</span>
              </h2>
              <p class="about-new-lead about-safe-byahe-lead">Every car is inspected. Every owner is verified. Your safety is our top priority.</p>
              <ul class="about-new-text about-new-bullets about-new-bullets-check">
                <li><CheckCircle :size="20" class="lucide-icon about-new-check" /> Instant Availability</li>
                <li><CheckCircle :size="20" class="lucide-icon about-new-check" /> Transparent Pricing</li>
                <li><CheckCircle :size="20" class="lucide-icon about-new-check" /> Verified Local Owners</li>
              </ul>
              <div class="about-new-stats">
                <div class="about-new-stat">
                  <span class="about-new-stat-value">500+</span>
                  <span class="about-new-stat-label">Rides shared</span>
                </div>
                <div class="about-new-stat">
                  <span class="about-new-stat-value">12</span>
                  <span class="about-new-stat-label">Cities served</span>
                </div>
              </div>
              <v-btn
                :to="ROUTES.fleet"
                color="primary"
                size="large"
                rounded="pill"
                class="about-safe-byahe-cta"
                elevation="0"
              >
                Drive with peace of mind
                <v-icon end icon="mdi-arrow-right" />
              </v-btn>
            </div>
          </div>
        </div>
      </BulodMetallicCard>
    </BulodSection>

    <!-- Late? No Problem. – last-minute booking (text + button left, image right) -->
    <section class="late-no-problem" id="late-no-problem">
      <div class="late-no-problem__inner">
        <div class="late-no-problem__grid scroll-reveal scroll-reveal-up gsap-custom" data-gsap="late">
          <div class="late-no-problem__content">
            <h2 class="late-no-problem__title">Late na? <span class="late-no-problem__accent">No problem.</span></h2>
            <p class="late-no-problem__lead">Late? No problem. Book a ride fast with BulodPH – 30 seconds. Find a ride in <strong>seconds</strong>, not hours.</p>
            <ul class="late-no-problem__features">
              <li><v-icon icon="mdi-car-side" size="20" /> Available 24/7</li>
              <li><v-icon icon="mdi-lightning-bolt" size="20" /> Super fast booking</li>
              <li><v-icon icon="mdi-check-circle" size="20" color="success" /> Verified drivers</li>
            </ul>
            <v-btn
              :to="ROUTES.fleet"
              class="late-no-problem__cta"
              size="x-large"
              rounded="pill"
              elevation="0"
            >
              Find a ride now
            </v-btn>
          </div>
          <div class="late-no-problem__media">
            <img
              src="/images/late-no-problem.png"
              alt="Late? No problem. Book a ride fast with BulodPH – 30 seconds, find a ride in seconds not hours."
              class="late-no-problem__img"
              loading="lazy"
              decoding="async"
            />
          </div>
        </div>
      </div>
    </section>

    <!-- Van / group travel – About-style layout (image left, content right, check bullets, stats) -->
    <BulodSection theme="light" id="adventure-awaits" :watermark="true" watermarkVariant="about" :padded="true" class="van-about-section">
      <BulodMetallicCard class="about-new-container section-container van-about-watermark">
        <div class="about-new-inner scroll-reveal scroll-reveal-up gsap-custom" data-gsap="van">
          <div class="about-new-grid van-about-grid">
            <div class="about-new-card about-new-card-frosted">
              <div class="about-new-image-wrap van-about-image-wrap">
                <img
                  src="/images/adventure-van.png"
                  alt="The squad's new favorite ride – 5- to 15-seaters. Find a van on BulodPH. 1000+ cars, secure &amp; instant, verified owners."
                  class="about-new-image"
                  loading="lazy"
                  decoding="async"
                />
              </div>
              <div class="about-new-card-body">
                <span class="about-new-card-title">What you get</span>
                <ul class="about-new-list">
                  <li><v-icon icon="mdi-map-marker-outline" size="18" /> Local rental partners</li>
                  <li><v-icon icon="mdi-file-check-outline" size="18" /> Verified documents</li>
                  <li><v-icon icon="mdi-cash-check" size="18" /> Transparent pricing</li>
                  <li><v-icon icon="mdi-phone-outline" size="18" /> Human support</li>
                  <li><v-icon icon="mdi-account-group-outline" size="18" /> Group &amp; family travel</li>
                  <li><v-icon icon="mdi-map-marker-radius-outline" size="18" /> The region &amp; beyond</li>
                </ul>
              </div>
            </div>
            <div class="about-new-content">
              <span class="about-new-badge">Group &amp; family travel</span>
              <span class="about-new-tag about-new-tag-van">The region &amp; beyond</span>
              <h2 class="about-new-title about-new-title-app">
                Your crew. <span class="title-accent title-accent-orange">One van.</span>
              </h2>
              <p class="about-new-lead">The squad's new favorite ride – 5- to 15-seaters. Find a van on BulodPH. 1000+ cars, secure &amp; instant, verified owners.</p>
              <p class="about-new-lead about-new-lead-sub">Same BulodPH trust—verified owners, secure payments—now for bigger groups.</p>
              <ul class="about-new-text about-new-bullets about-new-bullets-check">
                <li><CheckCircle :size="20" class="lucide-icon about-new-check" /> 5- to 15-seaters</li>
                <li><CheckCircle :size="20" class="lucide-icon about-new-check" /> Verified owners</li>
                <li><CheckCircle :size="20" class="lucide-icon about-new-check" /> Secure &amp; instant</li>
              </ul>
              <div class="about-new-stats">
                <div class="about-new-stat">
                  <span class="about-new-stat-value">500+</span>
                  <span class="about-new-stat-label">Rides shared</span>
                </div>
                <div class="about-new-stat">
                  <span class="about-new-stat-value">12</span>
                  <span class="about-new-stat-label">Cities served</span>
                </div>
              </div>
            </div>
          </div>
        </div>
      </BulodMetallicCard>
    </BulodSection>

    <!-- Rent without the drama – ghosting & scam risk (from posts / DMs) -->
    <BulodSection theme="light" id="rent-without-drama" :padded="true" class="drama-section">
      <div class="drama-section__inner">
        <div class="drama-section__grid scroll-reveal scroll-reveal-up gsap-custom" data-gsap="drama">
          <div class="drama-section__content">
            <span class="drama-section__badge">No more guesswork</span>
            <h2 class="drama-section__title">Rent without the <span class="drama-section__accent">drama</span></h2>
            <p class="drama-section__lead">When you reply to a random post or message an owner on social media, you risk being ghosted—no reply, no confirmation, no car. Or worse: “Deposit muna” to a personal GCash, then silence. That’s scam territory.</p>
            <p class="drama-section__sub">This is the reality we’re up against. BulodPH gives you verified owners, instant confirmation, and escrow so your money only releases when the trip starts. No chasing, no ghosting.</p>
            <ul class="drama-section__list">
              <li><ShieldCheck :size="18" class="lucide-icon" /> Verified owners, not random DMs</li>
              <li><CheckCircle :size="18" class="lucide-icon" /> Instant confirmation, no waiting on replies</li>
              <li><Lock :size="18" class="lucide-icon" /> Escrow hold—your payment is safe until you’re in the car</li>
            </ul>
          </div>
          <div class="drama-section__media">
            <img
              src="/images/bulod-rent-without-drama.png"
              alt="Rent without the drama – stop chasing unresponsive owners. Get instant confirmation on BulodPH. Verified Owner, Available Now."
              class="drama-section__img"
              loading="lazy"
              decoding="async"
            />
          </div>
        </div>
      </div>
    </BulodSection>

    <!-- Tap. Book. Drive. – app value section (image left, text + button right) -->
    <section class="tap-book-drive" id="tap-book-drive">
      <div class="tap-book-drive__inner">
        <div class="tap-book-drive__grid scroll-reveal scroll-reveal-up gsap-custom" data-gsap="tap">
          <div class="tap-book-drive__media">
            <img
              src="/images/tap-book-drive.png"
              alt="BulodPH app – Tap. Book. Drive. No more waiting. Book cars in minutes."
              class="tap-book-drive__img"
              loading="lazy"
              decoding="async"
            />
          </div>
          <div class="tap-book-drive__content">
            <p class="tap-book-drive__eyebrow">BulodPH app</p>
            <h2 class="tap-book-drive__title">Tap. Book. Drive.</h2>
            <p class="tap-book-drive__lead">No more waiting. Book cars in minutes.</p>
            <p class="tap-book-drive__sub">Just the cars you want, right when you need them.</p>
            <v-btn
              :to="ROUTES.fleet"
              class="tap-book-drive__cta"
              size="x-large"
              rounded="pill"
              elevation="0"
            >
              Book now
            </v-btn>
          </div>
        </div>
      </div>
    </section>

    <!-- Promo: 10% on 1-day booking (BULOD10) – between Tap. Book. Drive. and footer CTA -->
    <LandingPromoStrip extra-class="gsap-custom" data-gsap="promo" />

    </div>
  </PublicLayout>
</template>

<script setup lang="ts">
import { ref, onBeforeMount, onMounted, onUnmounted } from 'vue'
import PublicLayout from '@/layouts/PublicLayout.vue'
import BulodSection from '@/components/ui/BulodSection.vue'
import LandingPromoStrip from '@/components/landing/LandingPromoStrip.vue'
import BulodMetallicCard from '@/components/ui/BulodMetallicCard.vue'
import { gsap } from 'gsap'
import { ScrollTrigger } from 'gsap/ScrollTrigger'
import {
  CalendarCheck,
  Car,
  CheckCircle,
  LifeBuoy,
  Lock,
  Mail,
  MapPin,
  Phone,
  PhoneCall,
  ShieldCheck,
} from 'lucide-vue-next'
import { IMAGES } from '@/constants/images'
import { CONTACT, ROUTES, SOCIAL } from '@/constants/siteUrls'
import { useVanillaTilt } from '@/composables/useVanillaTilt'
import { useParallax } from '@/composables/useParallax'

// Reactive state
const landingRef = ref<HTMLElement | null>(null)
const heroParallaxRef = ref<HTMLElement | null>(null)
const heroImageSrc = ref('/images/hero-bulod-ph.png')
const heroVisible = ref(false)
const showBackToTop = ref(false)
const appBarHeight = ref(64)
let revealFallbackTimer: number | undefined
let animationsReady = false
// Removed unused mobileMenu logic here

// Helper to fix CSS variables for navbar height offsets
const updateAppBarHeight = () => {
  const appBar = document.querySelector('.v-app-bar')
  if (appBar) {
    appBarHeight.value = appBar.clientHeight
    document.documentElement.style.setProperty('--navbar-height', `${appBarHeight.value}px`)
  }
}

// Scroll detection logic
const handleScroll = () => {
  const scrollY = window.scrollY
  showBackToTop.value = scrollY > 500

  // Animate hero on scroll
  const heroSection = document.querySelector('.hero')
  if (heroSection) {
    const heroRect = heroSection.getBoundingClientRect()
    heroVisible.value = heroRect.top < window.innerHeight * 0.8
  }
}

// Scroll to top
const scrollToTop = () => {
  window.scrollTo({ top: 0, behavior: 'smooth' })
}


useVanillaTilt(landingRef)
useParallax(heroParallaxRef)

const revealStaticContent = () => {
  heroVisible.value = true
  document.querySelectorAll('.scroll-reveal').forEach((el) => el.classList.add('animate-in'))
}

const initGsapAnimations = () => {
  animationsReady = false
  if (window.matchMedia('(prefers-reduced-motion: reduce)').matches) {
    revealStaticContent()
    disableScrollRevealStyles()
    return
  }

  try {
    gsap.registerPlugin(ScrollTrigger)
    heroVisible.value = true
    animationsReady = true

    const wordRevealTargets = gsap.utils.toArray<HTMLElement>('[data-reveal="words"]')
    wordRevealTargets.forEach((el) => {
      if (el.dataset.split === 'true') return
      const text = el.textContent ?? ''
      const words = text.split(' ')
      el.textContent = ''
      words.forEach((word, idx) => {
        const span = document.createElement('span')
        span.className = 'word'
        span.textContent = word
        el.appendChild(span)
        if (idx < words.length - 1) {
          el.appendChild(document.createTextNode(' '))
        }
      })
      el.dataset.split = 'true'
    })

    // Hero timeline
    gsap
      .timeline({ defaults: { ease: 'power3.out', duration: 0.8 } })
      .from('.logo-wrap, .nav-link, .nav-cta, .mobile-menu-toggle', { y: -10, autoAlpha: 0, stagger: 0.05, duration: 0.5 })
      .from('.hero-image-ref', { scale: 0.96, autoAlpha: 0 }, '-=0.4')
      .from('.hero-logo', { y: 10, autoAlpha: 0 }, '-=0.2')
      .from('.text-line', { y: 28, autoAlpha: 0, stagger: 0.1 }, '-=0.2')
      .fromTo('.text-wipe', { clipPath: 'inset(0 100% 0 0)' }, { clipPath: 'inset(0 0% 0 0)', duration: 0.9 }, '-=0.4')
      .from('.hero-tagline', { y: 16, autoAlpha: 0 }, '-=0.2')
      .from('.hero-tags .hero-tag', { y: 10, autoAlpha: 0, stagger: 0.08 }, '-=0.2')
      .from('.hero-cta-group .v-btn', { y: 12, autoAlpha: 0, stagger: 0.1 }, '-=0.2')
      .from('.hero-contact-row', { y: 12, autoAlpha: 0 }, '-=0.2')

    wordRevealTargets.forEach((el) => {
      const words = el.querySelectorAll('.word')
      gsap.from(words, {
        y: 16,
        autoAlpha: 0,
        duration: 0.6,
        ease: 'power2.out',
        stagger: 0.02,
        scrollTrigger: {
          trigger: el,
          start: 'top 85%',
          toggleActions: 'play none none none',
        },
      })
    })

    gsap.utils.toArray<HTMLElement>('.scroll-reveal').forEach((el) => {
      if (el.classList.contains('gsap-custom')) return
      const y = el.classList.contains('scroll-reveal-up') ? 48 : 0
      gsap.from(el, {
        y,
        autoAlpha: 0,
        duration: 0.9,
        ease: 'power2.out',
        clearProps: 'all',
        scrollTrigger: {
          trigger: el,
          start: 'top 85%',
          toggleActions: 'play none none none',
          onEnter: () => el.classList.add('animate-in'),
        },
      })
    })

    // ——— Section-specific GSAP timelines (stagger, directional reveals) ———
    const stDefaults = { start: 'top 82%', toggleActions: 'play none none none' }
    const ease = 'power2.out'

    // About (Safe byahe): image from left, content stagger from right
    const aboutEl = document.querySelector('[data-gsap="about"]')
    if (aboutEl) {
      const tlAbout = gsap.timeline({
        scrollTrigger: { trigger: aboutEl, ...stDefaults },
        defaults: { ease, duration: 0.65 },
      })
      tlAbout
        .from(aboutEl, { y: 36, autoAlpha: 0, duration: 0.8, clearProps: 'transform,opacity' })
        .from(aboutEl.querySelector('.about-safe-byahe-card'), { x: -32, autoAlpha: 0, clearProps: 'transform,opacity' }, '-=0.5')
        .from(aboutEl.querySelectorAll('.about-new-badge, .about-safe-byahe-title, .about-safe-byahe-lead, .about-new-bullets-check, .about-new-stats, .about-safe-byahe-cta'), { y: 20, autoAlpha: 0, stagger: 0.08, clearProps: 'transform,opacity' }, '-=0.4')
      tlAbout.add(() => aboutEl.classList.add('animate-in'))
    }

    // Late? No Problem: media from left, content from right + stagger
    const lateEl = document.querySelector('[data-gsap="late"]')
    if (lateEl) {
      const tlLate = gsap.timeline({
        scrollTrigger: { trigger: lateEl, ...stDefaults },
        defaults: { ease, duration: 0.6 },
      })
      tlLate
        .from(lateEl, { y: 40, autoAlpha: 0, duration: 0.75, clearProps: 'transform,opacity' })
        .from(lateEl.querySelector('.late-no-problem__content'), { x: -40, autoAlpha: 0, clearProps: 'transform,opacity' }, '-=0.5')
        .from(lateEl.querySelector('.late-no-problem__media'), { x: 36, autoAlpha: 0, clearProps: 'transform,opacity' }, '-=0.6')
        .from(lateEl.querySelectorAll('.late-no-problem__title, .late-no-problem__lead, .late-no-problem__features, .late-no-problem__cta'), { y: 14, autoAlpha: 0, stagger: 0.07, clearProps: 'transform,opacity' }, '-=0.4')
      tlLate.add(() => lateEl.classList.add('animate-in'))
    }

    // Van (Your crew. One van.): card from left, content stagger
    const vanEl = document.querySelector('[data-gsap="van"]')
    if (vanEl) {
      const tlVan = gsap.timeline({
        scrollTrigger: { trigger: vanEl, ...stDefaults },
        defaults: { ease, duration: 0.6 },
      })
      const vanCard = vanEl.querySelector('.about-new-card')
      const vanContent = vanEl.querySelector('.about-new-content')
      tlVan
        .from(vanEl, { y: 36, autoAlpha: 0, duration: 0.75, clearProps: 'transform,opacity' })
        .from(vanCard, { x: -28, autoAlpha: 0, clearProps: 'transform,opacity' }, '-=0.5')
      if (vanContent) {
        tlVan.from(vanContent.querySelectorAll('.about-new-badge, .about-new-tag, .about-new-title, .about-new-lead, .about-new-bullets-check, .about-new-stats'), { y: 18, autoAlpha: 0, stagger: 0.07, clearProps: 'transform,opacity' }, '-=0.45')
      }
      tlVan.add(() => vanEl.classList.add('animate-in'))
    }

    // Rent without the drama: content from left, image from right
    const dramaEl = document.querySelector('[data-gsap="drama"]')
    if (dramaEl) {
      const tlDrama = gsap.timeline({
        scrollTrigger: { trigger: dramaEl, ...stDefaults },
        defaults: { ease, duration: 0.6 },
      })
      tlDrama
        .from(dramaEl, { y: 40, autoAlpha: 0, duration: 0.75, clearProps: 'transform,opacity' })
        .from(dramaEl.querySelector('.drama-section__content'), { x: -36, autoAlpha: 0, clearProps: 'transform,opacity' }, '-=0.5')
        .from(dramaEl.querySelectorAll('.drama-section__badge, .drama-section__title, .drama-section__lead, .drama-section__sub, .drama-section__list'), { y: 14, autoAlpha: 0, stagger: 0.06, clearProps: 'transform,opacity' }, '-=0.5')
        .from(dramaEl.querySelector('.drama-section__media'), { x: 36, autoAlpha: 0, clearProps: 'transform,opacity' }, '-=0.65')
      tlDrama.add(() => dramaEl.classList.add('animate-in'))
    }

    // Tap. Book. Drive.: content from left stagger, image from right
    const tapEl = document.querySelector('[data-gsap="tap"]')
    if (tapEl) {
      const tlTap = gsap.timeline({
        scrollTrigger: { trigger: tapEl, ...stDefaults },
        defaults: { ease, duration: 0.6 },
      })
      tlTap
        .from(tapEl, { y: 40, autoAlpha: 0, duration: 0.75, clearProps: 'transform,opacity' })
        .from(tapEl.querySelector('.tap-book-drive__media'), { x: -32, autoAlpha: 0, duration: 0.7, clearProps: 'transform,opacity' }, '-=0.5')
        .from(tapEl.querySelector('.tap-book-drive__content'), { x: 32, autoAlpha: 0, clearProps: 'transform,opacity' }, '-=0.6')
        .from(tapEl.querySelectorAll('.tap-book-drive__eyebrow, .tap-book-drive__title, .tap-book-drive__lead, .tap-book-drive__sub, .tap-book-drive__cta'), { y: 12, autoAlpha: 0, stagger: 0.07, clearProps: 'transform,opacity' }, '-=0.5')
      tlTap.add(() => tapEl.classList.add('animate-in'))
    }

    // Promo strip: fade + slight y when in view
    const promoEl = document.querySelector('[data-gsap="promo"]')
    if (promoEl) {
      gsap.from(promoEl, {
        y: 24,
        autoAlpha: 0,
        duration: 0.9,
        ease: 'power3.out',
        clearProps: 'transform,opacity',
        scrollTrigger: { trigger: promoEl, ...stDefaults },
      })
    }

    gsap.to('.divider-shine', {
      backgroundPositionX: '200%',
      duration: 2.6,
      ease: 'none',
      repeat: -1,
    })

    ScrollTrigger.refresh()
  } catch (e) {
    revealStaticContent()
    disableScrollRevealStyles()
    console.error('GSAP Setup Failed', e)
  }
}

const enableScrollRevealStyles = () => {
  document.documentElement.classList.add('scroll-reveal-ready')
}

const disableScrollRevealStyles = () => {
  document.documentElement.classList.remove('scroll-reveal-ready')
}

// Lifecycle hooks
onBeforeMount(() => {
  enableScrollRevealStyles()
})

onMounted(() => {
  updateAppBarHeight()
  window.addEventListener('resize', updateAppBarHeight, { passive: true })
  window.addEventListener('scroll', handleScroll, { passive: true })
  handleScroll() // Initial check
  initGsapAnimations()
  revealFallbackTimer = window.setTimeout(() => {
    const hidden = document.querySelectorAll('.scroll-reveal:not(.animate-in)')
    if (hidden.length || !animationsReady) {
      revealStaticContent()
      disableScrollRevealStyles()
    }
  }, 1800)
})

onUnmounted(() => {
  window.removeEventListener('scroll', handleScroll)
  window.removeEventListener('resize', updateAppBarHeight)
  ScrollTrigger.getAll().forEach((trigger) => trigger.kill())
  disableScrollRevealStyles()
  if (revealFallbackTimer) window.clearTimeout(revealFallbackTimer)
})

</script>

<style scoped>
/* Full-width layout so section backgrounds wrap edge to edge */
.landing-page {
  width: 100%;
  overflow-x: hidden;
  font-family: 'Inter', system-ui, -apple-system, 'Segoe UI', Roboto, 'Helvetica Neue', Arial, sans-serif;
  background-color: #ffffff;
  background-image: url("data:image/svg+xml,%3Csvg width='80' height='80' viewBox='0 0 80 80' xmlns='http://www.w3.org/2000/svg'%3E%3Crect width='80' height='80' fill='%23FFFFFF'/%3E%3Cpath d='M0 10h80M0 30h80M0 50h80M0 70h80' stroke='%23E5E7EB' stroke-width='1'/%3E%3Cpath d='M10 0v80M30 0v80M50 0v80M70 0v80' stroke='%23E5E7EB' stroke-width='1'/%3E%3C/svg%3E");
}

.lucide-icon {
  display: inline-block;
  vertical-align: middle;
  color: currentColor;
  stroke-width: 1.8;
}

.lucide-icon-start {
  margin-right: 0.5rem;
}

/* Subtle logo watermark / trademark on all sections */
.has-watermark {
  position: relative;
}
.section-watermark {
  position: absolute;
  top: 0;
  left: 0;
  right: 0;
  bottom: 0;
  background-image: url('/logo.png');
  background-repeat: no-repeat;
  background-position: center;
  background-size: min(22%, 160px);
  opacity: 0.06;
  pointer-events: none;
  z-index: 0;
}

/* Hero: watermarks – dark on white left, light on blue right */
.hero .hero-watermark-left {
  background-image:
    url('/logo.png'), url('/logo.png'), url('/logo.png'),
    url('/logo.png');
  background-repeat: no-repeat;
  background-position:
    10% 15%, 40% 10%, 70% 18%, 85% 45%;
  background-size:
    min(14%, 100px), min(18%, 120px), min(12%, 80px), min(16%, 110px);
  opacity: 0.16;
  filter: brightness(0);
  -webkit-mask-image: linear-gradient(to right, black 50%, transparent 65%);
  mask-image: linear-gradient(to right, black 50%, transparent 65%);
}
.hero .hero-watermark-right {
  position: absolute;
  inset: 0;
  pointer-events: none;
  z-index: 2;
  background-image:
    url('/logo.png'), url('/logo.png'), url('/logo.png'),
    url('/logo.png'), url('/logo.png'), url('/logo.png'),
    url('/images/hero-dot-fade.png');
  background-repeat: no-repeat;
  background-position:
    72% 10%, 84% 6%, 92% 14%,
    76% 22%, 88% 24%, 96% 20%,
    right bottom;
  background-size:
    min(11%, 85px), min(9%, 72px), min(10%, 78px),
    min(12%, 90px), min(9%, 70px), min(8%, 64px),
    48% 60%;
  opacity: 0.45;
  filter: grayscale(1) brightness(1.25);
  mix-blend-mode: soft-light;
}
.has-watermark > .v-container,
.has-watermark > .hero-container,
.has-watermark .adventure-billboard-top,
.has-watermark .adventure-billboard-bottom,
.has-watermark .adventure-billboard-bg,
.has-watermark .adventure-billboard-overlay,
.has-watermark .footer-container,
.has-watermark .features-container,
.has-watermark .testimonials-container {
  position: relative;
  z-index: 1;
}

/* White containers: metallic finish + shine (aligned with dashboard radius) */
.container-metallic {
  position: relative;
  overflow: hidden;
  border-radius: var(--radius-lg, 16px);
  border: 1px solid rgba(200, 210, 220, 0.4);
  box-shadow:
    inset 0 1px 0 rgba(255, 255, 255, 0.7),
    inset 0 -1px 0 rgba(0, 0, 0, 0.04),
    0 2px 8px rgba(0, 0, 0, 0.06);
}
.container-metallic::before {
  content: '';
  position: absolute;
  top: 0;
  left: -100%;
  width: 60%;
  height: 100%;
  background: linear-gradient(90deg, transparent, rgba(255, 255, 255, 0.2), transparent);
  animation: containerShine 4s ease-in-out 1s infinite;
  pointer-events: none;
  z-index: 0;
}
@keyframes containerShine {
  0% { left: -100%; opacity: 0; }
  15% { opacity: 1; }
  85% { opacity: 1; }
  100% { left: 120%; opacity: 0; }
}

/* Sketch SVG baseline */
.sketch-svg {
  width: 100%;
  height: 100%;
  fill: none;
  stroke: currentColor;
  stroke-width: 1.2;
  stroke-linecap: round;
  stroke-linejoin: round;
}

.sketch-icon {
  display: inline-flex;
  width: 20px;
  height: 20px;
  color: #111;
}

/* Manila folder tab navigation */

/* Hero open books */
.hero-open-books .hero-container {
  display: grid;
  grid-template-columns: minmax(0, 1fr) minmax(0, 1.1fr);
  gap: 3rem;
  align-items: center;
}

.hero-open-books .hero-content-col {
  order: 2;
}

.hero-open-books .hero-receipt-col {
  order: 1;
}

@media (max-width: 960px) {
  .hero-open-books .hero-container {
    grid-template-columns: 1fr;
  }
  .hero-open-books .hero-content-col,
  .hero-open-books .hero-receipt-col {
    order: unset;
  }
}

.hero-title,
.section-title,
.trust-step h3 {
  font-family: 'Archivo Black', 'Inter', sans-serif;
  letter-spacing: 0.01em;
}

.hero-tagline {
  font-size: 1.15rem;
  max-width: 520px;
}

/* License plate button */
.plate-btn {
  background: #fff !important;
  color: #111 !important;
  border: 2px solid #111 !important;
  border-radius: 6px !important;
  text-transform: none !important;
  font-weight: 800 !important;
  letter-spacing: 0.04em !important;
  box-shadow:
    inset 0 2px 0 rgba(255, 255, 255, 0.8),
    inset 0 -2px 0 rgba(0, 0, 0, 0.15),
    0 6px 12px rgba(0, 0, 0, 0.2) !important;
}

.plate-btn-ghost {
  background: rgba(255, 255, 255, 0.7) !important;
}

/* Receipt artifact */
.receipt-float {
  display: flex;
  justify-content: center;
}

.receipt-card {
  position: relative;
  background: linear-gradient(180deg, #fff 0%, #fff8e6 100%);
  border: 1px dashed rgba(0, 0, 0, 0.4);
  padding: 2rem 1.75rem 2.5rem;
  width: min(340px, 90%);
  box-shadow: 0 20px 40px rgba(0, 0, 0, 0.18);
  transform: rotate(-2deg);
}

.receipt-jagged {
  position: absolute;
  top: -14px;
  left: 0;
  right: 0;
  height: 14px;
  background: repeating-linear-gradient(135deg, #fff, #fff 8px, #e9e0d5 8px, #e9e0d5 12px);
}

.receipt-header {
  display: flex;
  justify-content: space-between;
  font-weight: 700;
  margin-bottom: 1rem;
}

.receipt-line,
.receipt-total {
  display: flex;
  justify-content: space-between;
  padding: 0.35rem 0;
  border-bottom: 1px dotted rgba(0, 0, 0, 0.2);
  font-weight: 600;
}

.receipt-total {
  font-size: 1.15rem;
  border-bottom: 2px solid rgba(0, 0, 0, 0.3);
}

.receipt-footnote {
  margin-top: 0.75rem;
  font-size: 0.85rem;
  color: #3f3f46;
}

/* Stamp */
.stamp {
  position: absolute;
  right: -10px;
  bottom: 14px;
  padding: 0.4rem 0.8rem;
  border: 2px solid currentColor;
  font-weight: 800;
  letter-spacing: 0.08em;
  text-transform: uppercase;
  transform: rotate(-15deg) scale(0.9);
  opacity: 0.7;
  filter: drop-shadow(0 4px 6px rgba(0, 0, 0, 0.2));
}

.stamp-blue {
  color: rgba(0, 71, 171, 0.8);
}

.stamp-red {
  color: rgba(185, 28, 28, 0.75);
}

.stamp-slam {
  opacity: 0;
  transform: rotate(-15deg) scale(1.2);
}

.stamp-slam.animate-in {
  animation: stampSlam 0.6s ease-out forwards;
}

@keyframes stampSlam {
  0% { opacity: 0; transform: rotate(-15deg) scale(1.3); }
  60% { opacity: 0.9; transform: rotate(-15deg) scale(0.95); }
  100% { opacity: 0.8; transform: rotate(-15deg) scale(1); }
}

/* Receipt of Truth */
.receipt-truth-section {
  padding: 4.5rem 0;
  position: relative;
}
.receipt-truth-section.receipt-truth-watermark::before {
  content: '';
  position: absolute;
  inset: 0;
  background-image: url('/logo.png');
  background-repeat: repeat;
  background-size: min(14%, 80px);
  background-position: 0 0;
  opacity: 0.12;
  pointer-events: none;
  z-index: 0;
  filter: grayscale(100%) brightness(200%);
}
.receipt-truth-section .container-metallic,
.receipt-truth-section .receipt-truth-header,
.receipt-truth-section .evidence-board {
  position: relative;
  z-index: 1;
}
.receipt-truth-section .container-metallic {
  padding: 3.5rem 2.75rem;
  background: rgba(255, 255, 255, 0.94);
}

/* Rent without the drama – ghosting / scam risk section */
.drama-section {
  padding: 4rem 0;
}
.drama-section__inner {
  max-width: 1200px;
  margin: 0 auto;
  padding: 0 1.5rem;
}
.drama-section__grid {
  display: grid;
  grid-template-columns: 1fr 1fr;
  gap: 3rem;
  align-items: center;
}
.drama-section__badge {
  display: inline-block;
  font-size: 0.7rem;
  font-weight: 700;
  letter-spacing: 0.14em;
  text-transform: uppercase;
  color: #0ea5e9;
  background: rgba(14, 165, 233, 0.1);
  border: 1px solid rgba(14, 165, 233, 0.3);
  padding: 0.4rem 0.85rem;
  border-radius: 999px;
  margin-bottom: 0.75rem;
}
.drama-section__title {
  font-size: clamp(1.75rem, 3.2vw, 2.35rem);
  font-weight: 800;
  letter-spacing: -0.02em;
  line-height: 1.2;
  color: #0f172a;
  margin: 0 0 1rem 0;
}
.drama-section__accent {
  color: #0ea5e9;
}
.drama-section__lead {
  font-size: 1rem;
  line-height: 1.6;
  color: #334155;
  margin: 0 0 0.75rem 0;
}
.drama-section__sub {
  font-size: 0.9375rem;
  line-height: 1.55;
  color: #64748b;
  margin: 0 0 1.25rem 0;
}
.drama-section__list {
  list-style: none;
  padding: 0;
  margin: 0;
  display: grid;
  gap: 0.5rem;
}
.drama-section__list li {
  display: flex;
  align-items: center;
  gap: 0.5rem;
  font-size: 0.9375rem;
  font-weight: 600;
  color: #1e293b;
}
.drama-section__list li .lucide-icon {
  flex-shrink: 0;
  color: #0ea5e9;
}
.drama-section__media {
  border-radius: 16px;
  overflow: hidden;
  background: #f8fafc;
  box-shadow: 0 20px 40px -12px rgba(15, 23, 42, 0.15);
  max-width: 420px;
  margin-left: auto;
}
.drama-section__img {
  width: 100%;
  height: auto;
  display: block;
  vertical-align: middle;
}
@media (max-width: 900px) {
  .drama-section__grid {
    grid-template-columns: 1fr;
    gap: 2rem;
  }
  .drama-section__media {
    order: -1;
    margin-left: auto;
    margin-right: auto;
  }
}
@media (max-width: 600px) {
  .drama-section {
    padding: 2.5rem 0;
  }
  .drama-section__title {
    font-size: clamp(1.5rem, 5.5vw, 1.9rem);
  }
  .drama-section__lead,
  .drama-section__sub {
    font-size: 0.9375rem;
  }
}

.section-badge {
  display: inline-block;
  padding: 0.35rem 0.85rem;
  border: 1px solid rgba(0, 0, 0, 0.35);
  background: #ffffff;
  font-weight: 700;
  letter-spacing: 0.08em;
  text-transform: uppercase;
}

.section-subtitle {
  max-width: 560px;
  margin: 0.75rem auto 0;
  color: #3f3f46;
}

.evidence-board {
  display: grid;
  gap: 2rem;
  grid-template-columns: repeat(auto-fit, minmax(240px, 1fr));
  margin-top: 2rem;
  position: relative;
}
.evidence-board::before {
  content: '';
  position: absolute;
  inset: -20px;
  background: radial-gradient(circle at 50% 30%, rgba(14, 165, 233, 0.12), transparent 55%);
  pointer-events: none;
  z-index: 0;
}

.evidence-panel {
  position: relative;
  padding: 1.75rem;
  border-radius: 18px;
  border: 1px solid rgba(17, 24, 39, 0.18);
  min-height: 280px;
  box-shadow: 0 10px 24px rgba(15, 23, 42, 0.08);
  background: #ffffff;
  z-index: 1;
}
.evidence-pin {
  position: absolute;
  top: 16px;
  right: 16px;
  width: 14px;
  height: 14px;
  border-radius: 999px;
  background: radial-gradient(circle at 30% 30%, #fff, #d1d5db 60%, #9ca3af 100%);
  box-shadow: 0 4px 10px rgba(0, 0, 0, 0.2);
}

.evidence-red {
  background: linear-gradient(180deg, rgba(248, 113, 113, 0.08), rgba(255, 255, 255, 0.85));
}

.evidence-blue {
  background: linear-gradient(180deg, rgba(191, 219, 254, 0.16), rgba(255, 255, 255, 0.9));
}

.evidence-label {
  font-weight: 800;
  margin-bottom: 1rem;
  text-transform: uppercase;
  letter-spacing: 0.08em;
  color: #111827;
}

.evidence-collage {
  display: grid;
  gap: 0.6rem;
}

.chat-bubble {
  padding: 0.65rem 0.85rem;
  background: #ffffff;
  border: 1px solid rgba(148, 163, 184, 0.4);
  border-radius: 10px;
  font-size: 0.95rem;
  color: #374151;
}

.contract-card {
  background: #ffffff;
  padding: 1rem 1.1rem;
  border-radius: 12px;
  border: 1px solid rgba(148, 163, 184, 0.4);
}

.contract-line {
  padding: 0.4rem 0;
  border-bottom: 1px dashed rgba(0, 0, 0, 0.2);
  color: #1f2937;
}

.contract-sig {
  display: flex;
  justify-content: space-between;
  font-weight: 700;
  margin-top: 0.75rem;
}

.contract-tag {
  color: rgba(0, 71, 171, 0.9);
}

@media (prefers-reduced-motion: reduce) {
  .stamp-slam,
  .stamp-slam.animate-in,
  .trust-step.animate-in .bell-icon,
  .flip-digit {
    animation: none !important;
  }
}

/* Footer: no shine effect */
.footer-section .container-metallic::before {
  display: none;
}

/* Section-light containers often have no visible box; soften border on light bg */
.section-light .container-metallic {
  border-color: rgba(200, 210, 220, 0.35);
  box-shadow: inset 0 1px 0 rgba(255, 255, 255, 0.85), 0 2px 12px rgba(15, 23, 42, 0.05);
}

/* Cards and inner white boxes: metallic shine sweep */
.stats-bar-inner {
  position: relative;
  overflow: hidden;
}
.stats-bar-inner::after {
  content: '';
  position: absolute;
  top: 0;
  left: -100%;
  width: 50%;
  height: 100%;
  background: linear-gradient(90deg, transparent, rgba(255, 255, 255, 0.25), transparent);
  animation: containerShine 5s ease-in-out 2s infinite;
  pointer-events: none;
  z-index: 0;
}
.featured-card-metallic,
.testimonial-card-inner {
  position: relative;
  overflow: hidden;
}
.featured-card-metallic::after,
.testimonial-card-inner::after {
  content: '';
  position: absolute;
  top: 0;
  left: -100%;
  width: 50%;
  height: 100%;
  background: linear-gradient(90deg, transparent, rgba(255, 255, 255, 0.2), transparent);
  animation: containerShine 5.5s ease-in-out 1.5s infinite;
  pointer-events: none;
  z-index: 0;
}

/* Metallic + black accent tokens (used navbar → footer) */
.landing-page {
  --metal-light: linear-gradient(180deg, rgba(255,255,255,0.25) 0%, rgba(255,255,255,0.06) 50%, rgba(0,0,0,0.04) 100%);
  --metal-border: linear-gradient(135deg, rgba(255,255,255,0.35) 0%, rgba(200,210,220,0.2) 50%, rgba(0,0,0,0.15) 100%);
  --metal-badge: linear-gradient(180deg, rgba(255,255,255,0.18) 0%, rgba(240,245,250,0.12) 40%, rgba(20,25,35,0.2) 100%);
  --black-accent: #0a0a0c;
  --black-soft: rgba(10, 12, 15, 0.5);
  --metal-shadow: inset 0 1px 0 rgba(255,255,255,0.2), 0 2px 8px rgba(0,0,0,0.2);
  --metal-shadow-btn: inset 0 1px 0 rgba(255,255,255,0.25), 0 4px 12px rgba(0,0,0,0.25);
}

/* Section backgrounds – full-width wrap, textured (aligned with dashboard app-dots-bg) */
.section-light {
  width: 100vw;
  min-height: 1px;
  box-sizing: border-box;
  margin-left: calc(50% - 50vw);
  margin-right: calc(50% - 50vw);
  padding-left: 0;
  padding-right: 0;
  background-color: var(--bg-light, #f8fafc);
  background-image:
    url("/images/climpek.svg"),
    linear-gradient(165deg, rgba(248, 250, 252, 1) 0%, rgba(241, 245, 249, 1) 40%, rgba(226, 232, 240, 1) 100%);
  background-repeat: repeat, repeat;
  background-position: 0 0, 0 0;
}

.section-dark {
  width: 100vw;
  min-height: 1px;
  box-sizing: border-box;
  margin-left: calc(50% - 50vw);
  margin-right: calc(50% - 50vw);
  padding-left: 0;
  padding-right: 0;
  background-color: var(--surface-2, #f1f5f9);
  background-image:
    url("/images/climpek.svg"),
    linear-gradient(165deg, rgba(241, 245, 249, 1) 0%, rgba(226, 232, 240, 1) 100%);
  background-repeat: repeat, repeat;
  background-position: 0 0, 0 0;
}

/* Global Animations */
@keyframes heroShift {
  0%, 100% { transform: translate(0, 0) scale(1); }
  50% { transform: translate(-2%, -1%) scale(1.02); }
}
@keyframes metalShine {
  0% { left: -100%; }
  100% { left: 100%; }
}
@keyframes slideUp {
  from {
    opacity: 0;
    transform: translateY(30px);
  }
  to {
    opacity: 1;
    transform: translateY(0);
  }
}


@keyframes pulse {
  0%, 100% {
    opacity: 1;
  }
  50% {
    opacity: 0.5;
  }
}

@keyframes rotate {
  from {
    transform: rotate(0deg);
  }
  to {
    transform: rotate(360deg);
  }
}

/* Navigation – light theme to match hero */
.navbar-modern {
  background: rgba(255, 255, 255, 0.95) !important;
  backdrop-filter: blur(12px);
  -webkit-backdrop-filter: blur(12px);
  border-bottom: 1px solid rgba(226, 232, 240, 0.8);
  transition: background-color 0.25s ease, box-shadow 0.25s ease, border-color 0.25s ease;
  box-shadow: 0 1px 3px rgba(0, 0, 0, 0.04);
  position: relative;
  will-change: background-color, box-shadow;
}

.navbar-modern::after {
  content: '';
  position: absolute;
  left: 0;
  right: 0;
  bottom: 0;
  height: 2px;
  background: linear-gradient(90deg, transparent, rgba(14, 165, 233, 0.5), rgba(212, 175, 55, 0.4), transparent);
  opacity: 0.6;
  pointer-events: none;
}

.navbar-scrolled {
  background: rgba(255, 255, 255, 0.98) !important;
  box-shadow: 0 4px 20px rgba(0, 0, 0, 0.08);
}

.navbar-modern .v-app-bar__content .v-btn .v-btn__content {
  color: inherit;
}

.navbar-modern .mobile-menu-toggle {
  display: inline-flex;
  align-items: center;
  justify-content: center;
  min-width: 44px;
  width: 44px;
  height: 44px;
  border-radius: 14px;
  border: 1px solid rgba(15, 23, 42, 0.14);
  background: rgba(248, 250, 252, 0.95);
  box-shadow: 0 10px 20px rgba(15, 23, 42, 0.12), 0 0 0 1px rgba(255, 255, 255, 0.5) inset;
  color: #0f172a;
  cursor: pointer;
  transition: transform 0.2s ease, box-shadow 0.2s ease, border-color 0.2s ease, background-color 0.2s ease;
}

.navbar-modern .mobile-menu-toggle .v-icon {
  color: currentColor !important;
}

.navbar-modern .mobile-menu-toggle:hover {
  background: #ffffff;
  border-color: rgba(15, 23, 42, 0.24);
  box-shadow: 0 14px 28px rgba(15, 23, 42, 0.16), 0 0 0 1px rgba(255, 255, 255, 0.7) inset;
  transform: translateY(-1px);
}

.navbar-modern .mobile-menu-toggle:active {
  transform: scale(0.98);
}

.navbar-modern .mobile-menu-toggle.is-open {
  background: rgba(15, 23, 42, 0.08);
  border-color: rgba(15, 23, 42, 0.28);
  box-shadow: 0 8px 18px rgba(15, 23, 42, 0.12), 0 0 0 1px rgba(255, 255, 255, 0.6) inset;
}

.mobile-menu-modal {
  border-radius: 20px;
  overflow: hidden;
  background: rgba(255, 255, 255, 0.96);
  border: 1px solid rgba(226, 232, 240, 0.9);
  box-shadow: 0 24px 50px rgba(15, 23, 42, 0.2);
}

.mobile-menu-modal__header {
  display: flex;
  align-items: center;
  justify-content: space-between;
  padding: 16px 18px 10px;
}

.mobile-menu-modal__title {
  font-weight: 700;
  font-size: 1rem;
  color: var(--trust-blue, #0f172a);
}

.mobile-menu-modal__close {
  width: 36px;
  height: 36px;
  border-radius: 12px;
  border: 1px solid rgba(15, 23, 42, 0.12);
  background: #fff;
  color: var(--trust-blue, #0f172a);
  display: inline-flex;
  align-items: center;
  justify-content: center;
  cursor: pointer;
  transition: transform 0.2s ease, box-shadow 0.2s ease, border-color 0.2s ease;
}

.mobile-menu-modal__close:hover {
  transform: translateY(-1px);
  border-color: rgba(15, 23, 42, 0.22);
  box-shadow: 0 8px 16px rgba(15, 23, 42, 0.12);
}

.mobile-menu-modal__grid {
  display: grid;
  grid-template-columns: repeat(2, minmax(0, 1fr));
  gap: 12px;
  padding: 10px 16px 18px;
}

.mobile-menu-tile {
  display: flex;
  flex-direction: column;
  gap: 6px;
  align-items: center;
  justify-content: center;
  text-decoration: none;
  border-radius: 16px;
  padding: 14px 8px;
  min-height: 76px;
  border: 1px solid rgba(226, 232, 240, 0.9);
  background: rgba(248, 250, 252, 0.9);
  color: var(--trust-blue, #0f172a);
  font-weight: 600;
  font-size: 0.85rem;
  cursor: pointer;
  transition: transform 0.2s ease, box-shadow 0.2s ease, border-color 0.2s ease, background-color 0.2s ease;
}

.mobile-menu-tile:hover {
  transform: translateY(-1px);
  border-color: rgba(15, 23, 42, 0.2);
  background: #ffffff;
  box-shadow: 0 12px 22px rgba(15, 23, 42, 0.12);
}


.navbar-modern .nav-link,
.navbar-scrolled .nav-link,
.navbar-modern .nav-links .nav-link,
.navbar-scrolled .nav-links .nav-link {
  color: #334155 !important;
  font-weight: 600;
}

.navbar-modern .nav-link .v-btn__content,
.navbar-scrolled .nav-link .v-btn__content,
.navbar-modern .nav-links .nav-link .v-btn__content,
.navbar-scrolled .nav-links .nav-link .v-btn__content {
  color: inherit !important;
}

.navbar-modern .nav-link:hover,
.navbar-scrolled .nav-link:hover,
.navbar-modern .nav-links .nav-link:hover,
.navbar-scrolled .nav-links .nav-link:hover {
  color: var(--sky-600) !important;
}

.navbar-modern .nav-links .nav-link:hover .v-btn__content,
.navbar-scrolled .nav-links .nav-link:hover .v-btn__content {
  color: var(--sky-600) !important;
}

.navbar-modern .login-btn,
.navbar-scrolled .login-btn {
  background: transparent !important;
  border: 1.5px solid #334155 !important;
  color: #0f172a !important;
  box-shadow: none;
}

.navbar-modern .login-btn .v-btn__content,
.navbar-scrolled .login-btn .v-btn__content {
  color: #0f172a !important;
}

.navbar-modern .login-btn:hover,
.navbar-scrolled .login-btn:hover {
  background: #f8fafc !important;
  border-color: #0f172a !important;
  box-shadow: 0 2px 8px rgba(0, 0, 0, 0.06);
}

.navbar-modern .trial-btn,
.navbar-scrolled .trial-btn {
  background: linear-gradient(180deg, var(--primary-cyan) 0%, var(--sky-600) 100%) !important;
  color: #ffffff !important;
  border: none !important;
  box-shadow: 0 2px 10px rgba(14, 165, 233, 0.35), 0 1px 3px rgba(0, 0, 0, 0.08);
}

.navbar-modern .trial-btn .v-btn__content,
.navbar-scrolled .trial-btn .v-btn__content {
  color: #ffffff !important;
}

.navbar-modern .trial-btn:hover,
.navbar-scrolled .trial-btn:hover {
  box-shadow: 0 4px 16px rgba(14, 165, 233, 0.4), 0 2px 6px rgba(0, 0, 0, 0.1);
}

.navbar-modern .list-vehicle-btn,
.navbar-scrolled .list-vehicle-btn {
  border: 1.5px solid #334155 !important;
  color: #0f172a !important;
  background: transparent !important;
}

.navbar-modern .list-vehicle-btn .v-btn__content,
.navbar-scrolled .list-vehicle-btn .v-btn__content {
  color: #0f172a !important;
}

.navbar-modern .list-vehicle-btn:hover,
.navbar-scrolled .list-vehicle-btn:hover {
  background: #f8fafc !important;
  border-color: #0f172a !important;
}

.logo-link {
  text-decoration: none;
  color: inherit;
}

/* Logo area – light navbar */
.logo-wrap {
  padding: 6px 12px;
  border-radius: 10px;
  background: transparent;
  align-items: center;
  display: inline-flex;
}

.logo-img {
  height: 44px;
  width: auto;
  max-width: 120px;
  object-fit: contain;
  display: block;
  filter: none;
}

.logo-fallback {
  font-size: 1.25rem;
  letter-spacing: 0.02em;
  color: #0f172a;
}

.logo-link-drawer {
  text-decoration: none;
  color: inherit;
}

.logo-img-drawer {
  height: 48px;
  width: auto;
  max-width: 140px;
  object-fit: contain;
  display: block;
}

.logo-container {
  transition: transform 0.3s cubic-bezier(0.4, 0, 0.2, 1);
}

.logo-container:hover {
  transform: scale(1.02);
}

/* Nav Links – light text when inside navbar (navbar-modern overrides below); dark only on light backgrounds elsewhere */
.nav-links {
  gap: 0.25rem 0.5rem;
}

.nav-links .nav-link {
  font-weight: 600;
  text-transform: none;
  letter-spacing: 0.025em;
  transition: all 0.3s ease;
  position: relative;
}

.landing-page .navbar-modern .nav-links .nav-link::after,
.landing-page .navbar-scrolled .nav-links .nav-link::after {
  background: var(--sky-600);
}

.nav-links .nav-link:hover::after {
  transform: translateX(-50%) scaleX(1);
}

.nav-links .nav-link::after {
  content: '';
  position: absolute;
  bottom: 8px;
  left: 50%;
  transform: translateX(-50%) scaleX(0);
  width: 80%;
  height: 2px;
  background: var(--sky-600);
  transition: transform 0.3s ease;
}

/* Login Button - Outlined sky blue */
.nav-cta {
  gap: 0.5rem;
}

@media (max-width: 1279px) {
  .nav-cta .list-vehicle-btn { display: none !important; }
}

.login-btn {
  font-weight: 600;
  transition: all 0.3s ease;
}

.login-btn:hover {
  transform: translateY(-2px);
}

.trial-btn {
  font-weight: 700;
  transition: all 0.3s ease;
}

.trial-btn:hover {
  transform: translateY(-2px);
}

.list-vehicle-btn {
  font-weight: 600;
  transition: all 0.3s ease;
}

.list-vehicle-btn:hover {
  transform: translateY(-2px);
}

/* Hero – reference layout: white left half, blue right, angled panel */
.hero {
  position: relative;
  min-height: 100vh;
  display: flex;
  flex-direction: column;
  justify-content: center;
  overflow: hidden;
  background: linear-gradient(90deg, #ffffff 0%, #ffffff 48%, var(--sky-700) 52%, var(--sky-800) 100%);
  padding-top: 100px;
  padding-bottom: 4rem;
}

.hero::before {
  content: '';
  position: absolute;
  top: 0;
  right: 0;
  width: 55%;
  height: 100%;
  background: linear-gradient(135deg, var(--sky-700) 0%, var(--sky-800) 100%);
  clip-path: polygon(25% 0%, 100% 0%, 100% 100%, 0% 100%);
  z-index: 0;
  animation: heroShift 15s ease-in-out infinite;
}
.hero::after {
  content: '';
  position: absolute;
  top: 0;
  right: 0;
  width: 53%;
  height: 100%;
  background: linear-gradient(135deg, rgba(3, 105, 161, 0.75) 0%, rgba(0, 189, 236, 0.9) 100%);
  backdrop-filter: blur(10px);
  -webkit-backdrop-filter: blur(10px);
  clip-path: polygon(28% 0%, 100% 0%, 100% 100%, 2% 100%);
  z-index: 1;
  pointer-events: none;
}

/* Hero with content: 2-col grid (overrides later .hero-container flex) */
.hero.hero-with-content .hero-container {
  position: relative;
  z-index: 2;
  max-width: 1600px;
  width: 100%;
  margin: 0 auto;
  padding-left: 40px;
  padding-right: 40px;
  display: grid;
  grid-template-columns: minmax(0, 1.05fr) minmax(0, 0.95fr);
  grid-template-areas: "content image";
  gap: 6rem;
  align-items: center;
  flex: none;
}

.hero.hero-with-content .hero-content-col {
  display: flex;
  align-items: center;
  min-width: 0;
  grid-area: content;
}
.hero.hero-with-content .hero-image-col {
  display: flex;
  align-items: center;
  justify-content: center;
  min-width: 0;
  grid-area: image;
}
.hero-content-inner {
  opacity: 0;
  transform: translateY(28px);
  transition: opacity 0.6s ease, transform 0.6s ease;
}
.hero-content-inner.animate-in {
  opacity: 1;
  transform: translateY(0);
}

.hero-logo {
  margin-bottom: 1.25rem;
  display: flex;
  align-items: center;
}
.hero-logo-img {
  height: 56px;
  width: auto;
  max-width: 180px;
  object-fit: contain;
  display: block;
  filter: brightness(0) saturate(100%) invert(28%) sepia(70%) saturate(600%) hue-rotate(195deg) brightness(0.92) drop-shadow(0 1px 2px rgba(14, 165, 233, 0.15));
}
.hero-logo-fallback {
  color: var(--sky-700);
  letter-spacing: 0.02em;
}

.hero-title {
  font-size: clamp(2.5rem, 5vw, 4rem);
  font-weight: 900;
  line-height: 1.1;
  letter-spacing: -0.02em;
  color: var(--sky-800);
  margin-bottom: 1rem;
  position: relative;
}

.text-line {
  display: block;
  overflow: hidden;
}

.text-line > span {
  display: inline-block;
}

.text-wipe {
  display: inline-block;
  will-change: clip-path;
}

.text-reveal-words .word {
  display: inline-block;
  will-change: transform, opacity;
}
.hero-title-accent-text {
  display: inline-block;
  background: linear-gradient(135deg, var(--sky-500) 0%, var(--sky-600) 100%);
  -webkit-background-clip: text;
  background-clip: text;
  -webkit-text-fill-color: transparent;
}

.hero-tagline {
  font-size: 1.25rem;
  color: var(--sky-700);
  max-width: 90%;
  line-height: 1.7;
  margin-bottom: 2rem;
}

.hero-cta-group {
  display: flex;
  flex-wrap: wrap;
  gap: 1rem;
  align-items: center;
}
.hero-cta {
  border-radius: 12px !important;
  font-weight: 700 !important;
  letter-spacing: 0.02em !important;
  text-transform: none !important;
  padding: 0.75rem 1.75rem !important;
  min-height: 52px !important;
  transition: transform 0.2s ease, box-shadow 0.2s ease !important;
  position: relative;
  overflow: hidden;
}
.hero-cta:hover {
  transform: translateY(-3px);
}
.hero-cta-primary {
  background: linear-gradient(180deg, var(--primary-cyan) 0%, var(--sky-600) 100%) !important;
  color: #fff !important;
  border: 1px solid rgba(255, 255, 255, 0.25) !important;
  box-shadow: inset 0 1px 0 rgba(255, 255, 255, 0.2), 0 4px 14px rgba(14, 165, 233, 0.35), 0 2px 6px rgba(0, 0, 0, 0.1) !important;
}
.hero-cta-primary:hover {
  box-shadow: inset 0 1px 0 rgba(255, 255, 255, 0.25), 0 6px 24px rgba(14, 165, 233, 0.4), 0 4px 12px rgba(0, 0, 0, 0.12) !important;
}
.hero-cta-primary .v-icon {
  color: #fff !important;
}
.hero-cta-primary::before {
  content: '';
  position: absolute;
  top: 0;
  left: -100%;
  width: 100%;
  height: 100%;
  background: linear-gradient(90deg, transparent, rgba(255, 255, 255, 0.25), transparent);
  transition: left 0.5s ease;
}
.hero-cta-primary:hover::before {
  left: 100%;
}
.hero-cta-secondary {
  background: #f8fafc !important;
  border: 1.5px solid var(--sky-600) !important;
  color: var(--sky-800) !important;
  box-shadow: 0 1px 3px rgba(14, 165, 233, 0.08) !important;
}
.hero-cta-secondary:hover {
  border-color: var(--sky-700) !important;
  background: #e0f2fe !important;
  box-shadow: 0 2px 8px rgba(14, 165, 233, 0.12) !important;
}
.hero-cta-secondary .v-icon {
  color: var(--sky-700) !important;
}
.hero-cta-contact {
  color: var(--sky-800) !important;
  border: 1px solid transparent !important;
}
.hero-cta-contact:hover {
  color: var(--sky-600) !important;
  background: rgba(14, 165, 233, 0.06) !important;
}
.hero-cta-contact .v-icon {
  color: inherit !important;
}


/* Hero contact row + socials (navy/blue on white) */
.hero .hero-contact-row {
  margin-top: 1.75rem;
}
.hero .hero-phone {
  color: var(--sky-700);
}
.hero .hero-phone:hover {
  color: var(--sky-600);
}
.hero .hero-phone .v-icon {
  color: var(--sky-600);
}
.hero .hero-contact-divider {
  color: var(--sky-400);
}
.hero .hero-social-link {
  color: var(--sky-700);
  background: rgba(14, 165, 233, 0.1);
}
.hero .hero-social-link:hover {
  background: var(--sky-500);
  color: #fff;
}
.hero .hero-social-link .v-icon {
  color: inherit;
}

/* Hero image: hero-bulod-ph.png — container (portrait 1024×1526) */
.hero-image-wrap-ref {
  position: relative;
  width: 100%;
  max-width: 500px;
  aspect-ratio: 1024 / 1526;
  border-radius: 12px;
  overflow: hidden;
  box-shadow: 0 20px 40px rgba(0, 0, 0, 0.35), 0 8px 16px rgba(15, 23, 42, 0.15);
  border: 2px solid rgba(255, 255, 255, 0.2);
  margin-left: auto;
  margin-right: auto;
}
.hero-image-wrap-ref::before {
  content: '';
  position: absolute;
  inset: -16px;
  background: radial-gradient(circle at 60% 40%, rgba(14, 165, 233, 0.35), transparent 60%);
  opacity: 0.8;
  z-index: 0;
  pointer-events: none;
}
.hero-image-wrap-ref::after {
  content: '';
  position: absolute;
  inset: 0;
  background: linear-gradient(135deg, rgba(15, 23, 42, 0.1), rgba(14, 165, 233, 0.08));
  z-index: 1;
  pointer-events: none;
}
.hero-image-ref {
  width: 100%;
  height: 100%;
  display: block;
  object-fit: contain; /* Prevents awkward cropping when scaled */
  object-position: center;
}
/* Vuetify v-img override */
.hero-image-wrap-ref :deep(.v-img),
.hero-image-wrap-ref :deep(.v-img__img),
.hero-image-wrap-ref :deep(img) {
  width: 100%;
  height: 100%;
  object-fit: contain; /* Match root setting */
  object-position: center;
  display: block;
  position: relative;
  z-index: 2;
}

@media (max-width: 768px) {
  .hero {
    min-height: auto;
    padding-top: 88px;
    padding-bottom: 48px;
    background: linear-gradient(180deg, #ffffff 0%, #f8fafc 55%, #e2e8f0 100%);
  }
  .hero::before {
    width: 100%;
    clip-path: none;
    opacity: 0.18;
  }
  .hero::after {
    width: 100%;
    clip-path: none;
    opacity: 0.12;
  }
  .hero.hero-with-content .hero-container {
    grid-template-columns: 1fr;
    grid-template-areas:
      "image"
      "content";
    gap: 2.5rem;
    padding-left: 24px;
    padding-right: 24px;
    text-align: center;
  }
  .hero.hero-with-content .hero-content-col {
    order: 1;
    justify-content: center;
  }
  .hero.hero-with-content .hero-content-inner {
    display: flex;
    flex-direction: column;
    align-items: center;
  }
  .hero .hero-logo-img {
    height: 48px;
    max-width: 160px;
  }
  .hero .hero-title {
    font-size: 2.5rem;
  }
  .hero .hero-tagline {
    font-size: 1.05rem;
    max-width: 100%;
  }
  .hero .hero-cta-group {
    justify-content: center;
  }
  .hero.hero-with-content .hero-image-col {
    order: 0;
  }
  .hero-image-wrap-ref {
    max-width: 320px;
    margin: 0 auto;
  }
  .hero-parallax,
  .hero-parallax-layer {
    transform: none !important;
  }
  .hero-image-ref {
    image-rendering: -webkit-optimize-contrast;
    backface-visibility: hidden;
  }
}
@media (max-width: 480px) {
  .hero.hero-with-content .hero-container {
    padding-left: 20px;
    padding-right: 20px;
    gap: 2rem;
  }
  .hero .hero-logo-img {
    height: 44px;
    max-width: 140px;
  }
  .hero .hero-title {
    font-size: 2rem;
  }
  .hero .hero-tagline {
    font-size: 0.98rem;
  }
}

@media (max-width: 600px) {
  .hero-image-wrap-ref {
    aspect-ratio: 1024 / 1526;
    width: min(80vw, 280px);
    max-width: 280px;
    height: auto;
  }
}

/* Promo strip styles live in LandingPromoStrip.vue (scoped in parent did not apply to child component). */

/* Consistent section width */
.section-container {
  max-width: 1320px;
  width: 100%;
  margin-left: auto;
  margin-right: auto;
  padding-left: clamp(20px, 3vw, 40px);
  padding-right: clamp(20px, 3vw, 40px);
}

/* Hero trust tags */
.hero-tags {
  display: flex;
  flex-wrap: wrap;
  gap: 0.6rem 1rem;
  align-items: center;
  margin-bottom: 1.5rem;
}

.hero-tag {
  display: inline-flex;
  align-items: center;
  gap: 0.35rem;
  font-size: 0.8125rem;
  font-weight: 600;
  color: var(--trust-blue);
  background: rgba(5, 113, 151, 0.08);
  padding: 0.4rem 0.75rem;
  border-radius: 9999px;
  border: 1px solid rgba(5, 113, 151, 0.15);
}

.hero-tag .v-icon {
  color: var(--sky-500);
  flex-shrink: 0;
}

.hero-tag .lucide-icon {
  color: var(--sky-500);
  flex-shrink: 0;
}

/* Hero contact + socials */
.hero-contact-row {
  display: flex;
  flex-wrap: wrap;
  align-items: center;
  gap: 0.75rem 1rem;
}

.hero-phone {
  display: inline-flex;
  align-items: center;
  gap: 0.4rem;
  font-size: 1rem;
  font-weight: 600;
  color: var(--trust-blue);
  text-decoration: none;
  transition: color 0.2s ease;
}

.hero-phone:hover {
  color: var(--sky-500);
}

.hero-phone .v-icon {
  color: var(--sky-500);
}

.hero-contact-divider {
  color: rgba(55, 65, 81, 0.4);
  font-size: 0.875rem;
  user-select: none;
}

.hero-socials {
  display: flex;
  align-items: center;
  gap: 0.5rem;
}

.hero-social-link {
  display: inline-flex;
  align-items: center;
  justify-content: center;
  width: 40px;
  height: 40px;
  border-radius: 50%;
  background: rgba(5, 113, 151, 0.1);
  color: var(--trust-blue);
  transition: background 0.2s ease, color 0.2s ease, transform 0.2s ease;
}

.hero-social-link:hover {
  background: var(--trust-blue);
  color: white;
  transform: translateY(-2px);
}

/* Trust bar at bottom of hero – full width, below main content */
.hero-trust-bar {
  width: 100%;
  margin-top: auto;
  padding-top: 2rem;
  padding-bottom: 0.5rem;
  border-top: 1px solid rgba(15, 23, 42, 0.1);
  flex-shrink: 0;
}

.hero-trust-bar-inner {
  display: flex;
  flex-wrap: wrap;
  justify-content: center;
  align-items: center;
  gap: 1.5rem 2.5rem;
}

.hero-trust-item {
  display: flex;
  align-items: center;
  gap: 0.6rem;
}

.hero-trust-item.hero-trust-payments {
  flex-wrap: wrap;
  gap: 0.5rem 0.75rem;
}

.hero-trust-logos {
  display: inline-flex;
  align-items: center;
  gap: 0.75rem;
  flex-shrink: 0;
}

.hero-trust-logo {
  height: 26px;
  width: auto;
  max-width: none;
  object-fit: contain;
  object-position: center;
  display: block;
  vertical-align: middle;
}

.hero-trust-logo-icon {
  height: 28px;
  width: 28px;
  flex-shrink: 0;
}

.hero-trust-logo-gcash {
  height: 24px;
}

.hero-trust-logo-maya {
  height: 22px;
}

.hero-trust-icon {
  color: var(--trust-blue) !important;
}

.hero-trust-label {
  font-size: 0.9375rem;
  font-weight: 600;
  color: var(--text-main);
}

@media (max-width: 480px) {
  .hero-contact-divider {
    display: none;
  }

  .hero-cta-btn {
    min-height: 48px !important;
    padding: 0.6rem 1.25rem !important;
  }

  .hero-trust-bar {
    margin-top: 1.5rem;
    padding-top: 1.25rem;
  }

  .hero-trust-bar-inner {
    gap: 1rem 1.5rem;
  }

  .hero-trust-label {
    font-size: 0.875rem;
  }

  .hero-trust-logo-gcash {
    height: 20px;
  }

  .hero-trust-logo-maya {
    height: 20px;
  }
}

/* Stats bar – premium social proof strip + metallic */
.stats-bar-section {
  padding: 2.75rem 0;
  background: linear-gradient(180deg, #f0f9ff 0%, #e0f2fe 50%, #f0f9ff 100%);
  border-top: 1px solid rgba(14, 165, 233, 0.12);
  border-bottom: 1px solid rgba(14, 165, 233, 0.1);
  box-shadow: inset 0 1px 0 rgba(255, 255, 255, 0.8);
}

.stats-bar-inner {
  display: flex;
  flex-wrap: wrap;
  justify-content: center;
  align-items: center;
  gap: 2rem 3rem;
  max-width: 900px;
  margin: 0 auto;
}

.stats-bar-item {
  display: flex;
  flex-direction: column;
  align-items: center;
  gap: 0.35rem;
  padding: 0.5rem 0.75rem;
  border-radius: 12px;
  transition: background 0.2s ease;
  min-width: 140px;
}
.stats-bar-icon {
  color: var(--sky-600);
}

.stats-bar-item:hover {
  background: rgba(255, 255, 255, 0.6);
}

.stats-bar-number {
  font-size: 2rem;
  font-weight: 800;
  font-variant-numeric: tabular-nums;
  letter-spacing: -0.03em;
  color: var(--trust-blue);
  line-height: 1;
  text-shadow: 0 1px 2px rgba(15, 23, 42, 0.04);
}

.stats-bar-label {
  font-size: 0.8125rem;
  font-weight: 600;
  letter-spacing: 0.06em;
  text-transform: uppercase;
  color: #0c4a6e;
  opacity: 0.85;
}

.stats-bar-divider {
  width: 1px;
  height: 40px;
  background: linear-gradient(180deg, transparent, rgba(14, 165, 233, 0.25), transparent);
  flex-shrink: 0;
}

@media (max-width: 600px) {
  .stats-bar-section {
    padding: 2rem 0;
  }

  .stats-bar-divider {
    display: none;
  }

  .stats-bar-inner {
    display: grid;
    grid-template-columns: repeat(2, minmax(0, 1fr));
    gap: 1rem;
  }

  .stats-bar-item {
    background: rgba(255, 255, 255, 0.75);
    border: 1px solid rgba(148, 163, 184, 0.35);
    box-shadow: 0 6px 18px rgba(15, 23, 42, 0.06);
    padding: 0.75rem 1rem;
    min-width: 0;
  }

  .stats-bar-number {
    font-size: 1.75rem;
  }

  .stats-bar-label {
    font-size: 0.75rem;
  }
}

/* Logo wall / Available in (Stripe-style) */
.logo-wall-section {
  padding: 1.5rem 0;
  background: #f8fafc;
  border-bottom: 1px solid rgba(15, 23, 42, 0.06);
}

.logo-wall-label {
  font-size: 0.6875rem;
  font-weight: 700;
  letter-spacing: 0.12em;
  text-transform: uppercase;
  color: var(--text-secondary);
  text-align: center;
  margin: 0 0 0.75rem 0;
}

.logo-wall-inner {
  display: flex;
  flex-wrap: wrap;
  justify-content: center;
  align-items: center;
  gap: 1rem 1.5rem;
}

.logo-wall-city {
  font-size: 0.9375rem;
  font-weight: 600;
  color: var(--trust-blue);
  opacity: 0.9;
}

.logo-wall-city:last-child {
  opacity: 0.7;
  font-weight: 500;
}

/* Ribbon / banner strip (angled) */
.ribbon-wrap {
  overflow: hidden;
  padding: 0.5rem 0;
}

.ribbon-band {
  display: flex;
  flex-wrap: wrap;
  align-items: center;
  justify-content: center;
  gap: 0.75rem 1rem;
  padding: 0.875rem 1.5rem;
  background: linear-gradient(135deg, var(--trust-blue) 0%, var(--sky-600) 100%);
  color: #fff;
  transform: skewY(-0.6deg);
  box-shadow: 0 4px 12px rgba(15, 23, 42, 0.2);
}

.ribbon-band > * {
  transform: skewY(0.6deg);
}

.ribbon-icon {
  display: inline-flex;
  opacity: 0.95;
}

.ribbon-text {
  font-size: 0.9375rem;
  font-weight: 600;
  letter-spacing: 0.02em;
}

.ribbon-text strong {
  font-weight: 800;
  letter-spacing: 0.04em;
}

.ribbon-cta {
  border-color: rgba(255, 255, 255, 0.8) !important;
  color: #fff !important;
  font-weight: 600 !important;
  font-size: 0.8125rem !important;
}

.ribbon-cta:hover {
  background: rgba(255, 255, 255, 0.15) !important;
  border-color: #fff !important;
}

/* Single-column – editorial “Why peer-to-peer?” card */
.single-col-section {
  padding: 5.5rem 0 6rem;
  background: linear-gradient(180deg, #f8fafc 0%, #f1f5f9 100%);
}

.single-col-inner {
  max-width: 720px;
  margin: 0 auto;
  text-align: center;
  position: relative;
  padding: 3rem 2.5rem;
  background: #fff;
  border-radius: 20px;
  box-shadow: 0 4px 24px rgba(15, 23, 42, 0.06), 0 1px 3px rgba(15, 23, 42, 0.04);
  border: 1px solid rgba(15, 23, 42, 0.06);
}

.single-col-accent {
  width: 64px;
  height: 4px;
  background: linear-gradient(90deg, var(--black-accent), var(--trust-blue), var(--sky-400));
  box-shadow: inset 0 1px 0 rgba(255,255,255,0.25);
  border-radius: 2px;
  margin: 0 auto 1.75rem;
}

.single-col-title {
  font-size: clamp(2rem, 4vw, 2.5rem);
  font-weight: 800;
  letter-spacing: -0.03em;
  color: #0f172a;
  margin: 0 0 1.25rem 0;
  line-height: 1.2;
}

.single-col-body {
  font-size: 1.25rem;
  line-height: 1.75;
  color: #475569;
  margin: 0 0 2rem 0;
}

.single-col-cta {
  font-weight: 700 !important;
  letter-spacing: 0.02em !important;
  text-transform: none !important;
  box-shadow: var(--metal-shadow-btn), 0 4px 14px rgba(0,0,0,0.15) !important;
  border: 1px solid rgba(255,255,255,0.25) !important;
}

.single-col-cta:hover {
  box-shadow: inset 0 1px 0 rgba(255,255,255,0.35), 0 6px 20px rgba(0,0,0,0.2) !important;
}

@media (max-width: 600px) {
  .single-col-section {
    padding: 3rem 0 4rem;
  }

  .single-col-inner {
    padding: 2rem 1.5rem;
    border-radius: 16px;
  }

  .single-col-body {
    font-size: 1.125rem;
  }
}

.hero-bg-image {
  position: absolute;
  inset: 0;
  z-index: 0;
}

.hero-bg-image .hero-bg-img {
  width: 100%;
  height: 100%;
  object-fit: cover;
}

.hero-overlay {
  position: absolute;
  inset: 0;
  background: linear-gradient(180deg, rgba(15, 23, 42, 0.6) 0%, rgba(2, 6, 23, 0.8) 100%);
  z-index: 1;
}

.hero-accent-bar {
  position: absolute;
  top: 0;
  left: 0;
  right: 0;
  height: 3px;
  background: linear-gradient(90deg, var(--primary-cyan), var(--sky-500));
  z-index: 3;
}

.hero-container {
  position: relative;
  z-index: 2;
  flex: 1;
  display: flex;
  align-items: center;
}

.hero-container-center {
  justify-content: center;
  text-align: center;
}

.hero-center-content {
  max-width: 640px;
  margin: 0 auto;
}

.hero-title-light {
  color: #fff !important;
  -webkit-text-fill-color: #fff;
  background: none;
  text-shadow: 0 2px 12px rgba(0, 0, 0, 0.2);
}

.hero-subtitle-light {
  color: rgba(255, 255, 255, 0.9) !important;
  margin-bottom: 1.5rem;
}

/* Glassmorphism search bar */
.glass-card {
  background: rgba(255, 255, 255, 0.15);
  backdrop-filter: blur(16px);
  -webkit-backdrop-filter: blur(16px);
  border: 1px solid rgba(255, 255, 255, 0.25);
  border-radius: var(--radius);
  padding: 0.5rem;
  margin-bottom: 1.5rem;
  display: flex;
  align-items: center;
  gap: 0.75rem;
  flex-wrap: wrap;
}

.hero-search-wrap {
  max-width: 520px;
  margin-left: auto;
  margin-right: auto;
}

.hero-search-field {
  flex: 1;
  min-width: 200px;
}

.hero-search-field :deep(.v-field) {
  border-radius: 12px;
  background: rgba(255, 255, 255, 0.95);
}

.hero-search-btn {
  border-radius: var(--radius) !important;
  flex-shrink: 0;
}

.cta-secondary-hero {
  border-color: rgba(255, 255, 255, 0.8) !important;
  color: #fff !important;
  background: transparent !important;
}

.cta-secondary-hero:hover {
  background: rgba(255, 255, 255, 0.15) !important;
  border-color: #fff !important;
}

.hero-cta-row {
  justify-content: center;
}

/* Van section – two-column layout; bg ties into image (teal sky, green landscape, warm yellow) */
.van-section {
  position: relative;
  padding: 4rem 1.5rem;
  overflow: hidden;
  /* Gradient: sky blue (left) → soft teal/green (right) to match illustration */
  background: linear-gradient(
    120deg,
    #f0f9ff 0%,
    #e0f2fe 22%,
    #ccfbf1 45%,
    #ecfdf5 65%,
    #fefce8 85%,
    #f8fafc 100%
  );
}
/* Soft teal glow behind image area so graphic doesn’t sit on flat bg */
.van-section::before {
  content: '';
  position: absolute;
  top: 50%;
  left: 55%;
  width: 90%;
  height: 120%;
  transform: translate(-50%, -50%);
  background: radial-gradient(
    ellipse 70% 60% at 60% 50%,
    rgba(20, 184, 166, 0.12) 0%,
    rgba(14, 165, 233, 0.06) 40%,
    transparent 70%
  );
  pointer-events: none;
}
/* Subtle warm halo (yellow) near image for “sun” feel */
.van-section::after {
  content: '';
  position: absolute;
  top: 60%;
  right: 10%;
  width: 50%;
  height: 80%;
  background: radial-gradient(
    ellipse 50% 40% at 80% 60%,
    rgba(250, 204, 21, 0.07) 0%,
    transparent 55%
  );
  pointer-events: none;
}
/* Black & yellow logo watermarks */
.van-section__watermark {
  position: absolute;
  inset: 0;
  pointer-events: none;
  z-index: 0;
  background-repeat: no-repeat;
  background-image:
    url('/logo.png'), url('/logo.png'), url('/logo.png'),
    url('/logo.png'), url('/logo.png'), url('/logo.png'),
    url('/logo.png'), url('/logo.png'), url('/logo.png'),
    url('/logo.png'), url('/logo.png'), url('/logo.png');
  background-position:
    5% 15%, 22% 8%, 42% 18%, 62% 6%, 82% 14%, 96% 22%,
    8% 38%, 28% 48%, 52% 42%, 72% 52%, 90% 38%, 4% 62%,
    18% 72%, 38% 78%, 58% 68%, 78% 74%, 94% 65%;
  background-size:
    min(14%, 100px), min(12%, 90px), min(16%, 110px), min(14%, 95px), min(12%, 88px), min(14%, 100px),
    min(13%, 92px), min(15%, 105px), min(14%, 98px), min(12%, 85px), min(16%, 112px), min(14%, 96px),
    min(12%, 88px), min(14%, 100px), min(15%, 108px), min(13%, 94px), min(14%, 98px);
}
.van-section__watermark--black {
  filter: brightness(0);
  opacity: 0.07;
}
.van-section__watermark--yellow {
  filter: sepia(1) hue-rotate(35deg) saturate(4) brightness(1.1);
  opacity: 0.09;
}

.van-section__inner {
  position: relative;
  z-index: 1;
  max-width: 1200px;
  margin: 0 auto;
}
.van-section__grid {
  display: grid;
  grid-template-columns: 1fr 1fr;
  gap: 3rem;
  align-items: center;
  min-height: 0;
}
.van-section__content {
  padding: 2rem 2.25rem 2rem 2rem;
  background: rgba(255, 255, 255, 0.6);
  backdrop-filter: blur(12px);
  -webkit-backdrop-filter: blur(12px);
  border-radius: 20px;
  border: 1px solid rgba(255, 255, 255, 0.7);
  box-shadow: 0 4px 24px rgba(14, 165, 233, 0.06);
}
.van-section__label {
  font-size: 0.7rem;
  font-weight: 700;
  letter-spacing: 0.2em;
  text-transform: uppercase;
  color: #64748b;
  margin: 0 0 0.75rem 0;
}
.van-section__tag {
  display: inline-block;
  font-size: 0.75rem;
  font-weight: 700;
  letter-spacing: 0.06em;
  text-transform: uppercase;
  color: #0f172a;
  background: #e0f2fe;
  border: 1px solid rgba(14, 165, 233, 0.35);
  padding: 0.35rem 0.9rem;
  border-radius: 999px;
  margin-bottom: 1.25rem;
}
.van-section__title {
  font-size: clamp(1.75rem, 3.5vw, 2.5rem);
  font-weight: 800;
  letter-spacing: -0.03em;
  line-height: 1.15;
  color: #0f172a;
  margin: 0 0 1.25rem 0;
}
.van-section__accent {
  color: #0ea5e9;
}
.van-section__lead {
  font-size: 1rem;
  line-height: 1.6;
  color: #334155;
  margin: 0 0 1rem 0;
}
.van-section__sub {
  font-size: 0.9375rem;
  line-height: 1.55;
  color: #64748b;
  margin: 0;
}
/* Image native ratio 1024×1526 (portrait) – no crop */
.van-section__media {
  position: relative;
  border-radius: 20px;
  overflow: hidden;
  background: #e0f2fe;
  box-shadow:
    0 25px 50px -12px rgba(15, 23, 42, 0.2),
    0 0 0 1px rgba(0, 0, 0, 0.04);
  aspect-ratio: 1024 / 1526;
  max-width: 420px;
  margin-left: 0;
  margin-right: auto;
}
.van-section__img {
  width: 100%;
  height: 100%;
  object-fit: contain;
  object-position: center;
  display: block;
}

@media (max-width: 900px) {
  .van-section__grid {
    grid-template-columns: 1fr;
    gap: 2rem;
  }
  .van-section__content {
    padding: 1.5rem 1.25rem;
    text-align: center;
  }
  .van-section__tag {
    margin-left: auto;
    margin-right: auto;
  }
  .van-section__media {
    aspect-ratio: 1024 / 1526;
    max-width: 100%;
    max-height: none;
    margin-left: auto;
    margin-right: auto;
    order: -1;
  }
}

@media (max-width: 600px) {
  .van-section {
    padding: 2.5rem 1rem;
  }
  .van-section__content {
    padding: 1.25rem 1rem;
  }
  .van-section__title {
    font-size: clamp(1.5rem, 6vw, 2rem);
  }
  .van-section__lead,
  .van-section__sub {
    font-size: 0.9375rem;
  }
  .van-section__media {
    max-width: 320px;
    margin-left: auto;
    margin-right: auto;
    border-radius: 16px;
  }
}

/* Legacy adventure-billboard (kept for ref; no longer used in markup) */
.adventure-section.adventure-billboard {
  position: relative;
  padding: 2rem 1.5rem 0;
  overflow: hidden;
  background: linear-gradient(180deg, #f0f9ff 0%, #e0f2fe 30%, #f8fafc 70%, #f1f5f9 100%);
}

.adventure-billboard-wrap {
  display: flex;
  flex-direction: column;
  align-items: center;
  gap: 0;
  max-width: 1280px;
  margin: 0 auto;
  position: relative;
  z-index: 1;
}

.adventure-watermark .section-watermark {
  background-image:
    url('/logo.png'), url('/logo.png'), url('/logo.png'),
    url('/logo.png'), url('/logo.png'), url('/logo.png'),
    url('/logo.png'), url('/logo.png'), url('/logo.png'),
    url('/logo.png'), url('/logo.png'), url('/logo.png');
  background-repeat: no-repeat;
  background-position:
    6% 12%, 26% 8%, 50% 14%, 74% 6%, 92% 18%,
    8% 40%, 30% 46%, 54% 42%, 78% 48%, 94% 44%,
    12% 72%, 40% 76%, 70% 70%;
  background-size:
    min(18%, 130px), min(14%, 110px), min(16%, 120px), min(15%, 110px), min(18%, 130px),
    min(16%, 120px), min(14%, 110px), min(16%, 120px), min(15%, 110px), min(14%, 110px),
    min(18%, 130px), min(14%, 110px), min(16%, 120px);
  opacity: 0.18;
}

.adventure-billboard-top {
  text-align: center;
  padding-bottom: 0.65rem;
  position: relative;
  z-index: 1;
  max-width: 640px;
  margin: 0 auto;
}

.adventure-billboard-label {
  display: block;
  font-size: 0.65rem;
  font-weight: 700;
  letter-spacing: 0.16em;
  text-transform: uppercase;
  color: #64748b;
  margin: 0 0 0.25rem 0;
  opacity: 0.95;
}

.adventure-location-tag {
  display: inline-flex;
  align-items: center;
  justify-content: center;
  font-size: 0.7rem;
  font-weight: 700;
  letter-spacing: 0.04em;
  text-transform: uppercase;
  color: #0f172a;
  background: linear-gradient(135deg, rgba(14, 165, 233, 0.12) 0%, rgba(14, 165, 233, 0.06) 100%);
  border: 1px solid rgba(14, 165, 233, 0.3);
  padding: 0.25rem 0.7rem;
  border-radius: 999px;
  margin: 0 auto 0.4rem;
  box-shadow: 0 1px 2px rgba(14, 165, 233, 0.08);
}

.adventure-billboard .adventure-section-heading {
  font-size: clamp(1.5rem, 3.2vw, 2.1rem);
  font-weight: 800;
  letter-spacing: -0.04em;
  line-height: 1.1;
  color: #0f172a;
  margin: 0;
  text-shadow: 0 1px 2px rgba(255, 255, 255, 0.8);
}

.adventure-billboard .adventure-section-heading .title-accent {
  color: var(--sky-600);
}

.adventure-billboard-bg {
  position: relative;
  width: 100%;
  max-width: 1000px;
  min-height: 180px;
  aspect-ratio: 16 / 10;
  border-radius: 16px;
  overflow: hidden;
  background: #e0f2fe;
  box-shadow:
    0 8px 24px rgba(14, 165, 233, 0.12),
    0 20px 40px -8px rgba(15, 23, 42, 0.15),
    0 0 0 1px rgba(255, 255, 255, 0.8);
}

.adventure-billboard-bg img {
  width: 100%;
  height: 100%;
  position: absolute;
  inset: 0;
  object-fit: contain;
  object-position: center;
  animation: billboardFloat 18s ease-in-out infinite;
  transform: scale(1);
  will-change: transform;
}

.adventure-billboard-overlay {
  position: absolute;
  inset: 0;
  border-radius: 16px;
  background: linear-gradient(180deg, rgba(255, 255, 255, 0.05) 0%, rgba(15, 23, 42, 0.12) 100%);
}

.adventure-billboard-bottom {
  text-align: center;
  padding-top: 0.65rem;
  position: relative;
  z-index: 1;
  max-width: 580px;
  margin: 0 auto;
}

.adventure-billboard-line {
  width: 80px;
  height: 4px;
  background: linear-gradient(90deg, transparent, var(--sky-400), var(--sky-500), var(--sky-400), transparent);
  margin: 0 auto 1.5rem;
  border-radius: 2px;
  box-shadow: 0 1px 2px rgba(14, 165, 233, 0.2);
}

.adventure-billboard-sub {
  font-size: 0.875rem;
  line-height: 1.5;
  color: #334155;
  margin: 0 auto;
  font-weight: 500;
  max-width: 540px;
  letter-spacing: 0.01em;
}

.adventure-cta {
  font-weight: 700 !important;
  letter-spacing: 0.04em !important;
  text-transform: none !important;
  padding: 0.75rem 2rem !important;
  font-size: 1.0625rem !important;
  background: linear-gradient(180deg, var(--primary-cyan) 0%, var(--sky-600) 100%) !important;
  color: #fff !important;
  border: 1px solid rgba(255, 255, 255, 0.35) !important;
  box-shadow:
    inset 0 1px 0 rgba(255, 255, 255, 0.25),
    0 4px 14px rgba(14, 165, 233, 0.35),
    0 8px 24px -4px rgba(0, 0, 0, 0.2) !important;
  transition: transform 0.2s ease, box-shadow 0.2s ease !important;
}

.adventure-cta:hover {
  transform: translateY(-2px) !important;
  box-shadow:
    inset 0 1px 0 rgba(255, 255, 255, 0.3),
    0 6px 20px rgba(14, 165, 233, 0.4),
    0 12px 32px -4px rgba(0, 0, 0, 0.25) !important;
}

.adventure-cta-van {
  margin-top: 1.25rem !important;
  text-transform: uppercase !important;
  letter-spacing: 0.08em !important;
  border-radius: 12px !important;
  background: linear-gradient(180deg, #facc15 0%, #eab308 100%) !important;
  color: #0f172a !important;
  border: 1px solid rgba(255, 255, 255, 0.5) !important;
  box-shadow:
    inset 0 1px 0 rgba(255, 255, 255, 0.4),
    0 4px 16px rgba(234, 179, 8, 0.4),
    0 8px 24px -4px rgba(0, 0, 0, 0.2) !important;
}
.adventure-cta-van:hover {
  box-shadow:
    inset 0 1px 0 rgba(255, 255, 255, 0.5),
    0 6px 20px rgba(234, 179, 8, 0.5),
    0 12px 32px -4px rgba(0, 0, 0, 0.25) !important;
}

.adventure-trust-strip {
  display: flex;
  flex-wrap: wrap;
  align-items: center;
  justify-content: center;
  gap: 0.35rem 0.5rem;
  width: 100%;
  max-width: 1000px;
  margin: 2rem auto 0;
  padding: 0.85rem 1.25rem;
  background: linear-gradient(135deg, #0f766e 0%, #115e59 50%, #134e4a 100%);
  border-radius: 12px;
  box-shadow: 0 4px 12px rgba(15, 118, 110, 0.25);
  position: relative;
  z-index: 1;
}
.adventure-trust-item {
  display: inline-flex;
  align-items: center;
  gap: 0.4rem;
  font-size: 0.8125rem;
  font-weight: 600;
  color: rgba(255, 255, 255, 0.95);
  letter-spacing: 0.02em;
}
.adventure-trust-item .lucide-icon {
  flex-shrink: 0;
  opacity: 0.95;
}
.adventure-trust-sep {
  color: rgba(255, 255, 255, 0.4);
  font-weight: 700;
  user-select: none;
}

@keyframes billboardFloat {
  0%, 100% {
    transform: scale(1.02) translateY(0);
  }
  50% {
    transform: scale(1.04) translateY(-6px);
  }
}

@media (max-width: 768px) {
  .adventure-billboard-bg {
    aspect-ratio: 1696 / 608;
    min-height: 240px;
  }
}

@media (max-width: 600px) {
  .adventure-section.adventure-billboard {
    padding: 0.875rem 1rem 1rem;
  }

  .adventure-billboard-top {
    padding-bottom: 0.5rem;
  }

  .adventure-billboard-bottom {
    padding-top: 0.5rem;
  }

  .adventure-billboard-bg {
    aspect-ratio: 1696 / 608;
    min-height: clamp(180px, 38vw, 280px);
  }

  .adventure-billboard-bg img {
    object-position: center;
    transform: none;
    animation: none;
  }

  .adventure-billboard-label {
    font-size: 0.75rem;
    letter-spacing: 0.1em;
  }

  .adventure-billboard .adventure-section-heading {
    font-size: clamp(1.75rem, 6vw, 2.25rem);
  }

  .adventure-billboard-sub {
    font-size: 1rem;
    margin-bottom: 0.5rem;
  }

  .adventure-trust-strip {
    margin-top: 1.5rem;
    padding: 0.7rem 1rem;
    gap: 0.25rem 0.4rem;
  }
  .adventure-trust-item {
    font-size: 0.75rem;
  }
}

@media (max-width: 600px) {
  .adventure-location-tag {
    margin: 0 0 0.75rem;
    justify-content: flex-start;
  }
  .adventure-trust-strip {
    margin-top: 1.25rem;
    padding: 0.6rem 0.85rem;
  }
  .adventure-trust-item {
    font-size: 0.7rem;
  }
}

@media (max-width: 600px) {
  .receipt-truth-section {
    padding: 3rem 0;
  }

  .receipt-truth-section .container-metallic {
    padding: 2rem 1.25rem;
  }

  .evidence-board {
    grid-template-columns: 1fr;
    gap: 1.25rem;
  }

  .evidence-panel {
    padding: 1.25rem;
    min-height: auto;
  }

  .evidence-label {
    font-size: 0.85rem;
  }

  .chat-bubble {
    font-size: 0.9rem;
  }

  .contract-line {
    font-size: 0.9rem;
  }

  .contract-sig {
    flex-direction: column;
    gap: 0.35rem;
    align-items: flex-start;
  }

  .stamp {
    right: 8px;
    bottom: 10px;
    transform: rotate(-12deg) scale(0.85);
  }
}

/* Trust Bar – slim strip, no huge gap, flows into next section */
.trust-bar-section {
  background: #f8fafc;
  padding: 1.25rem 0;
  border-top: 1px solid rgba(15, 23, 42, 0.06);
  border-bottom: 1px solid rgba(15, 23, 42, 0.06);
}

.trust-bar-inner {
  display: flex;
  flex-wrap: wrap;
  justify-content: center;
  align-items: center;
  gap: 1.5rem 2.5rem;
}

.trust-bar-item {
  display: flex;
  align-items: center;
  gap: 0.6rem;
}

.trust-bar-icon {
  color: var(--trust-blue) !important;
}

.trust-bar-label {
  font-size: 0.9375rem;
  font-weight: 600;
  color: var(--text-main);
}

/* Join CTA – Deep Blue background */
.join-cta-section {
  background: linear-gradient(180deg, var(--trust-blue) 0%, #020617 100%);
  padding: 4rem 0;
}

.join-cta-inner {
  text-align: center;
  max-width: 560px;
  margin: 0 auto;
}

.join-cta-title {
  font-size: clamp(1.75rem, 3vw, 2.25rem);
  font-weight: 800;
  color: #fff;
  margin: 0 0 0.75rem 0;
  line-height: 1.2;
}

.join-cta-sub {
  font-size: 1.125rem;
  color: rgba(255, 255, 255, 0.9);
  margin: 0 0 1.5rem 0;
  line-height: 1.5;
}

.join-cta-btn {
  border-radius: var(--radius) !important;
  font-weight: 700;
}

.hero-row {
  width: 100%;
}

.hero-content {
  padding-right: 2rem;
}

.hero-content-inner {
  opacity: 0;
  transform: translateY(28px);
  transition: opacity 0.7s cubic-bezier(0.4, 0, 0.2, 1), transform 0.7s cubic-bezier(0.4, 0, 0.2, 1);
}

.hero-content-inner.animate-in {
  opacity: 1;
  transform: translateY(0);
}

/* Hero badge */
.hero-badge-wrap {
  display: inline-block;
}

.hero-badge {
  display: inline-flex;
  align-items: center;
  gap: 0.5rem;
  padding: 0.5rem 1rem;
  font-size: 0.8125rem;
  font-weight: 600;
  letter-spacing: 0.02em;
  color: var(--sky-600);
  background: var(--sky-50);
  border: 1px solid var(--sky-200);
  border-radius: 999px;
  box-shadow: 0 1px 4px rgba(14, 165, 233, 0.08);
  margin-bottom: 1.25rem;
}

.hero-badge-icon {
  color: var(--sky-500) !important;
}

.hero-title {
  font-size: clamp(2.75rem, 6vw, 4.25rem);
  line-height: 1.12;
  font-weight: 800;
  letter-spacing: -0.03em;
  color: #111;
  margin-bottom: 0.75rem;
}

.hero-title-accent {
  width: 64px;
  height: 4px;
  background: linear-gradient(90deg, var(--sky-400), var(--sky-500));
  border-radius: 2px;
  margin-bottom: 1.5rem;
}

/* Hero accent text - near-white (no gradient abuse) */
.gradient-text {
  color: rgba(255, 255, 255, 0.95);
}

/* Gradient text – hero only (sections use .title-accent) */
.gradient-text-dark {
  background: linear-gradient(135deg, var(--trust-blue) 0%, var(--sky-500) 100%);
  -webkit-background-clip: text;
  -webkit-text-fill-color: transparent;
  background-clip: text;
}

/* Section titles: first part = default color, second part = solid color2 (no gradient) */
.title-accent {
  color: var(--sky-600);
}

.hero-subtitle {
  font-size: clamp(1.125rem, 2vw, 1.375rem);
  line-height: 1.7;
  color: #374151;
  max-width: 560px;
  margin-bottom: 2rem;
}

/* Trust: compact pills, no heavy circles */
.trust-badges {
  margin-top: 0;
}

.trust-row {
  display: flex;
  flex-wrap: wrap;
  align-items: center;
  gap: 1rem 1.5rem;
}

.trust-pill {
  display: inline-flex;
  align-items: center;
  gap: 0.35rem;
  font-size: 0.8125rem;
  font-weight: 500;
  letter-spacing: 0.01em;
  color: var(--text-secondary);
}

.trust-pill .v-icon {
  color: var(--sky-500);
}

.trust-pill-accent .v-icon {
  color: var(--sky-600) !important;
}

.trust-subtext {
  margin-top: 0.75rem;
  font-size: 0.8125rem;
  color: var(--text-secondary);
  text-align: center;
}

.trust-subtext::before {
  content: '✓ ';
  display: inline;
  margin-right: 0.25rem;
}

/* Hero image */
.hero-image-wrap {
  position: relative;
  width: 100%;
  max-width: 880px;
  margin-left: auto;
  margin-right: 0;
}

.hero-image {
  width: 100%;
  border-radius: 16px;
  box-shadow: 0 12px 48px rgba(14, 165, 233, 0.15);
  overflow: hidden;
  border: 3px solid;
  border-image: linear-gradient(135deg, #0ea5e9 0%, #0369a1 50%, #1e40af 100%) 1;
  border-image-slice: 1;
}

.hero-image-tag {
  position: absolute;
  bottom: calc(1rem - 8px);
  right: calc(1rem - 8px);
  display: inline-flex;
  align-items: center;
  gap: 0.5rem;
  padding: 0.625rem 1rem;
  background: linear-gradient(135deg, rgba(255, 255, 255, 0.98) 0%, rgba(240, 249, 255, 0.98) 100%);
  backdrop-filter: blur(12px);
  border-radius: 999px;
  font-size: 0.875rem;
  font-weight: 700;
  color: #0369a1;
  box-shadow: 0 4px 20px rgba(14, 165, 233, 0.25), 0 2px 8px rgba(3, 105, 161, 0.15);
  border: 1.5px solid rgba(14, 165, 233, 0.3);
  letter-spacing: 0.01em;
}

.hero-image-tag .v-icon {
  color: #0ea5e9;
}

/* Hero dashboard card (legacy – kept for features fallback) */
.hero-dashboard-wrap {
  position: relative;
  padding-left: 0.5rem;
}

.hero-dashboard-card {
  background: #ffffff !important;
  border: 1px solid var(--sky-200) !important;
  border-radius: 16px !important;
  box-shadow: 0 8px 32px rgba(14, 165, 233, 0.12), 0 2px 8px rgba(0, 0, 0, 0.04) !important;
  overflow: hidden;
  transition: box-shadow 0.3s ease, transform 0.3s ease;
}

.hero-dashboard-card:hover {
  box-shadow: 0 16px 48px rgba(14, 165, 233, 0.16), 0 4px 12px rgba(0, 0, 0, 0.06) !important;
  transform: translateY(-2px);
}

.hero-dashboard-header {
  display: flex;
  align-items: center;
  justify-content: space-between;
  padding: 12px 16px;
  background: var(--sky-50);
  border-bottom: 1px solid var(--sky-200);
}

.hero-dashboard-dots {
  display: flex;
  gap: 6px;
}

.hero-dashboard-dots .dot {
  width: 10px;
  height: 10px;
  border-radius: 50%;
}

.hero-dashboard-dots .dot-red {
  background: #f87171;
}

.hero-dashboard-dots .dot-yellow {
  background: #fbbf24;
}

.hero-dashboard-dots .dot-green {
  background: #4ade80;
}

.hero-dashboard-url {
  display: inline-flex;
  align-items: center;
  gap: 6px;
  font-size: 0.75rem;
  color: var(--text-secondary);
}

.hero-dashboard-img {
  display: block;
}

.hero-stats-row {
  display: flex;
  flex-wrap: wrap;
  gap: 1rem 1.5rem;
  padding: 1rem 1.25rem;
  background: #ffffff;
  border-top: 1px solid var(--sky-100);
}

.hero-stat {
  display: inline-flex;
  align-items: center;
  gap: 0.5rem;
  font-size: 0.9375rem;
  color: var(--text-secondary);
}

.hero-stat strong {
  color: var(--text-primary);
}

.hero-stat-icon {
  color: var(--sky-500) !important;
}

/* Browser Mockup */
.mockup-browser {
  background: #1a1a1a;
  border-radius: 12px;
  padding: 8px;
}

.browser-header {
  background: #2a2a2a;
  border-radius: 8px 8px 0 0;
  padding: 8px 12px;
}

.browser-dot {
  width: 12px;
  height: 12px;
  border-radius: 50%;
}

.bg-red {
  background: #ff5f56;
}

.bg-yellow {
  background: #ffbd2e;
}

.bg-green {
  background: #27c93f;
}

.browser-url {
  background: #3a3a3a;
  color: #999;
  font-size: 0.75rem;
}

/* Scroll Indicator */
/* Hero Visual */
.hero-visual {
  position: relative;
  display: flex;
  align-items: center;
  justify-content: center;
}

.hero-visual .animate-fade-in {
  width: 100%;
  max-width: 880px;
  margin-left: auto;
  margin-right: 0;
}

.floating-card {
  position: relative;
}

.glass-card {
  background: rgba(255, 255, 255, 0.95) !important;
  border: 1px solid var(--sky-200);
  box-shadow: 0 8px 32px rgba(14, 165, 233, 0.12);
}

.mockup-image {
  filter: drop-shadow(0 20px 40px rgba(0, 0, 0, 0.3));
}

.floating-stats {
  position: absolute;
  z-index: 10;
}

.floating-stats-1 {
  bottom: -20px;
  right: -20px;
}

.floating-stats-2 {
  top: -20px;
  left: -20px;
}

.stat-card {
  background: #FFFFFF !important;
  border: 1px solid var(--sky-200);
  box-shadow: 0 4px 20px rgba(14, 165, 233, 0.1) !important;
}

/* Background Shapes */
.hero-bg-shapes {
  position: absolute;
  top: 0;
  left: 0;
  width: 100%;
  height: 100%;
  overflow: hidden;
  z-index: 1;
}

.shape {
  position: absolute;
  border-radius: 50%;
  background: rgba(14, 165, 233, 0.08);
  animation: pulse 4s ease-in-out infinite;
}

.shape-1 {
  width: 400px;
  height: 400px;
  top: -100px;
  right: -100px;
  animation-delay: 0s;
}

.shape-2 {
  width: 300px;
  height: 300px;
  bottom: -50px;
  left: -50px;
  animation-delay: 1s;
}

.shape-3 {
  width: 200px;
  height: 200px;
  top: 50%;
  left: 50%;
  animation-delay: 2s;
}

/* Section accent bar */
.section-with-bar {
  position: relative;
}

.section-accent-bar {
  position: absolute;
  top: 0;
  left: 0;
  right: 0;
  height: 3px;
  background: linear-gradient(90deg, var(--black-accent) 0%, var(--trust-blue) 25%, var(--sky-500) 50%, var(--trust-blue) 75%, var(--black-accent) 100%);
  box-shadow: inset 0 1px 0 rgba(255,255,255,0.2), 0 1px 2px rgba(0,0,0,0.2);
  z-index: 2;
}

/* Features section – How It Works */
.features-section {
  padding: 5rem 0;
  position: relative;
}

.features-section.section-light::before {
  display: none;
}

.features-header {
  max-width: 720px;
  margin: 0 auto;
  text-align: center;
  position: relative;
  padding-bottom: 1rem;
}

.features-header::after {
  content: '';
  position: absolute;
  bottom: 0;
  left: 50%;
  transform: translateX(-50%);
  width: 48px;
  height: 3px;
  background: linear-gradient(90deg, var(--black-accent), var(--sky-400));
  box-shadow: inset 0 1px 0 rgba(255,255,255,0.25);
  border-radius: 2px;
}

.features-badge {
  display: inline-block;
  font-size: 0.6875rem;
  font-weight: 700;
  letter-spacing: 0.12em;
  text-transform: uppercase;
  color: var(--trust-blue);
  margin-bottom: 0.75rem;
  padding: 0.35rem 0.75rem;
  background: var(--metal-badge);
  border-radius: 9999px;
  border: 1px solid rgba(15, 23, 42, 0.12);
  box-shadow: inset 0 1px 0 rgba(255,255,255,0.35), 0 1px 3px rgba(0,0,0,0.08);
}

.features-title {
  font-size: clamp(1.875rem, 3.5vw, 2.75rem);
  font-weight: 800;
  letter-spacing: -0.02em;
  color: #0f172a;
  margin: 0 0 0.75rem 0;
  line-height: 1.2;
}

.features-subtitle {
  font-size: 1.125rem;
  color: #475569;
  margin: 0;
  max-width: 560px;
  margin-left: auto;
  margin-right: auto;
}

/* section-dark: headers use two solid colors, badge pill */
.features-section.section-dark .features-badge,
.why-section.section-dark .features-badge {
  color: var(--sky-300);
  letter-spacing: 0.12em;
  padding: 0.35rem 0.75rem;
  background: linear-gradient(180deg, rgba(255,255,255,0.12) 0%, rgba(15, 23, 42, 0.25) 100%);
  border-radius: 9999px;
  border: 1px solid rgba(255,255,255,0.1);
  box-shadow: inset 0 1px 0 rgba(255,255,255,0.15), 0 1px 4px rgba(0,0,0,0.2);
}

.features-section.section-dark .features-title,
.why-section.section-dark .features-title {
  color: #f1f5f9;
}

.features-section.section-dark .features-subtitle,
.why-section.section-dark .features-subtitle {
  color: rgba(255, 255, 255, 0.75);
}

.features-section.section-dark .title-accent,
.why-section.section-dark .title-accent {
  color: var(--sky-400);
}

/* Explore the Philippines – title + text + tags left, image right */
.explore-section {
  padding: 4.5rem 0 5rem;
  position: relative;
  background: #f3f4f6;
}
.explore-watermark .section-watermark {
  background-image:
    url('/logo.png'), url('/logo.png'), url('/logo.png'),
    url('/logo.png'), url('/logo.png'), url('/logo.png'),
    url('/logo.png'), url('/logo.png'), url('/logo.png'),
    url('/logo.png'), url('/logo.png'), url('/logo.png');
  background-repeat: no-repeat;
  background-position:
    6% 14%, 26% 10%, 50% 16%, 74% 8%, 92% 20%,
    8% 42%, 30% 48%, 54% 44%, 78% 50%, 94% 46%,
    12% 74%, 40% 78%, 70% 72%;
  background-size:
    min(18%, 130px), min(14%, 110px), min(16%, 120px), min(15%, 110px), min(18%, 130px),
    min(16%, 120px), min(14%, 110px), min(16%, 120px), min(15%, 110px), min(14%, 110px),
    min(18%, 130px), min(14%, 110px), min(16%, 120px);
  opacity: 0.1;
}
.explore-section .section-container {
  max-width: 1400px;
  padding-left: clamp(16px, 2vw, 32px);
  padding-right: clamp(16px, 2vw, 32px);
}

.explore-section.section-light::before {
  display: none;
}

/* Card container for Explore the Philippines – premium */
.explore-card {
  background: #ffffff;
  border-radius: 20px;
  box-shadow: 0 6px 16px rgba(15, 23, 42, 0.08), 0 24px 40px -16px rgba(15, 23, 42, 0.16);
  border: 2px solid rgba(148, 163, 184, 0.6);
  padding: 2.5rem;
  max-width: none;
  width: 100%;
  margin: 0 auto;
  position: relative;
  overflow: hidden;
}
.explore-card::before,
.explore-card::after {
  content: '';
  position: absolute;
  top: 50%;
  width: 34px;
  height: 34px;
  border-radius: 999px;
  background: #f3f4f6;
  border: 2px solid rgba(148, 163, 184, 0.6);
  transform: translateY(-50%);
  z-index: 2;
}
.explore-card::before {
  left: -20px;
}
.explore-card::after {
  right: -20px;
}
.ticket-perf {
  position: absolute;
  top: 12px;
  bottom: 12px;
  left: 52%;
  width: 2px;
  background-image: repeating-linear-gradient(
    to bottom,
    rgba(148, 163, 184, 0.7),
    rgba(148, 163, 184, 0.7) 6px,
    transparent 6px,
    transparent 12px
  );
  opacity: 0.9;
  z-index: 1;
}

@media (max-width: 600px) {
  .explore-card {
    padding: 1.25rem;
    border-radius: 12px;
  }
}

.explore-grid {
  display: grid;
  grid-template-columns: 1fr 1fr;
  gap: 3rem;
  align-items: center;
}

.explore-content {
  display: flex;
  flex-direction: column;
  align-items: flex-start;
  gap: 1.25rem;
}

.explore-title {
  font-size: clamp(1.875rem, 3.5vw, 2.5rem);
  font-weight: 800;
  letter-spacing: -0.02em;
  color: #0f172a;
  margin: 0 0 0.5rem 0;
  line-height: 1.2;
  padding-bottom: 0.75rem;
  border-bottom: 3px solid var(--sky-300);
  display: inline-block;
}

.explore-title .title-accent {
  color: var(--sky-600);
}

.explore-text {
  font-size: 1.125rem;
  color: #374151;
  line-height: 1.6;
  margin: 0;
  max-width: 480px;
}
.explore-highlights {
  list-style: none;
  padding: 0;
  margin: 0;
  display: grid;
  gap: 0.5rem;
}
.explore-highlights li {
  display: flex;
  align-items: center;
  gap: 0.5rem;
  font-size: 0.95rem;
  color: #1f2937;
  font-weight: 600;
}
.explore-highlight-icon {
  color: var(--sky-600);
}

.explore-tags {
  display: flex;
  flex-wrap: wrap;
  gap: 0.5rem;
}

.explore-tag {
  display: inline-block;
  font-size: 0.8125rem;
  font-weight: 600;
  letter-spacing: 0.04em;
  color: var(--trust-blue);
  background: var(--metal-badge);
  padding: 0.45rem 0.9rem;
  border-radius: 9999px;
  border: 1px solid rgba(15, 23, 42, 0.1);
  box-shadow: inset 0 1px 0 rgba(255,255,255,0.3), 0 1px 2px rgba(0,0,0,0.06);
}

.explore-tag-promo {
  background: var(--primary-cyan);
  color: var(--trust-blue);
  border-color: transparent;
  box-shadow: 0 2px 8px rgba(96, 165, 250, 0.3);
}

.explore-cta {
  font-weight: 700 !important;
  letter-spacing: 0.02em !important;
  text-transform: none !important;
  background: linear-gradient(180deg, var(--primary-cyan) 0%, var(--sky-600) 100%) !important;
  color: #fff !important;
  border: 1px solid rgba(255, 255, 255, 0.25) !important;
  box-shadow: var(--metal-shadow-btn), 0 4px 14px rgba(0, 0, 0, 0.2) !important;
  margin-top: 0.25rem;
}

.explore-visual {
  display: flex;
  justify-content: center;
  align-items: center;
}

/* Image is 1024×1024 – square container, full image visible */
.explore-image-wrap {
  position: relative;
  border-radius: var(--radius, 12px);
  overflow: hidden;
  box-shadow: 0 12px 40px rgba(15, 23, 42, 0.1), 0 4px 16px rgba(0, 0, 0, 0.06);
  aspect-ratio: 1 / 1;
  width: 100%;
  max-width: 480px;
  background: #e2e8f0;
}

.explore-image,
.explore-image-wrap :deep(img) {
  width: 100%;
  height: 100%;
  object-fit: contain;
  object-position: center;
  transition: transform 0.5s ease;
}

.explore-image-wrap:hover .explore-image,
.explore-image-wrap:hover :deep(img) {
  transform: scale(1.03);
}

@media (max-width: 960px) {
  .explore-grid {
    grid-template-columns: 1fr;
    gap: 2rem;
  }

  .explore-content {
    align-items: center;
    text-align: center;
  }

  .explore-text {
    max-width: 560px;
    margin-left: auto;
    margin-right: auto;
  }

  .explore-tags {
    justify-content: center;
  }
}

@media (max-width: 600px) {
  .explore-section {
    padding: 3rem 0 3.5rem;
  }

  .explore-grid {
    gap: 1.5rem;
  }

  .explore-title {
    font-size: clamp(1.5rem, 6vw, 2rem);
  }

  .explore-text {
    font-size: 1rem;
  }

  .explore-image-wrap {
    max-width: 100%;
    aspect-ratio: 1 / 1;
    border-radius: 12px;
    margin: 0 auto;
  }
}

/* Beat the Traffic – full width like other sections */
.traffic-section {
  padding: 5.5rem 0 6rem;
  position: relative;
}

.traffic-grid {
  display: grid;
  grid-template-columns: 1fr 1fr;
  gap: 4rem;
  align-items: center;
  max-width: 1280px;
  margin: 0 auto;
}

.traffic-visual {
  order: 1;
  display: flex;
  justify-content: center;
  align-items: center;
}

.traffic-content {
  order: 2;
  display: flex;
  flex-direction: column;
  align-items: flex-start;
  gap: 1.25rem;
}

.traffic-label {
  font-size: 0.875rem;
  font-weight: 700;
  letter-spacing: 0.12em;
  text-transform: uppercase;
  color: var(--trust-blue);
  opacity: 0.95;
}

.traffic-title {
  font-size: clamp(2.25rem, 4.5vw, 3rem);
  font-weight: 800;
  letter-spacing: -0.03em;
  color: #0f172a;
  margin: 0 0 0.75rem 0;
  line-height: 1.15;
  padding-bottom: 0.75rem;
  border-bottom: 4px solid var(--sky-300);
  display: inline-block;
}

.traffic-title .title-accent {
  color: var(--sky-600);
}

.traffic-text {
  font-size: 1.25rem;
  color: #374151;
  line-height: 1.65;
  margin: 0;
  max-width: 100%;
}

.traffic-benefits {
  list-style: none;
  margin: 0;
  padding: 0;
  display: flex;
  flex-direction: column;
  gap: 0.875rem;
}

.traffic-benefits li {
  display: flex;
  align-items: center;
  gap: 0.5rem;
  font-size: 1.0625rem;
  font-weight: 500;
  color: #374151;
}

.traffic-benefit-icon {
  color: var(--primary-cyan);
  flex-shrink: 0;
}

.traffic-tags {
  display: flex;
  flex-wrap: wrap;
  gap: 0.5rem;
}

.traffic-tag {
  display: inline-block;
  font-size: 0.875rem;
  font-weight: 600;
  letter-spacing: 0.03em;
  color: var(--trust-blue);
  background: transparent;
  padding: 0.45rem 0.9rem;
  border-radius: 9999px;
  border: 1.5px solid rgba(15, 23, 42, 0.25);
}

.traffic-cta {
  font-weight: 700 !important;
  letter-spacing: 0.04em !important;
  text-transform: uppercase !important;
  background: linear-gradient(180deg, rgba(255,255,255,0.95) 0%, rgba(240,248,255,0.9) 100%) !important;
  color: var(--trust-blue) !important;
  border: 1px solid rgba(255, 255, 255, 0.5) !important;
  box-shadow: var(--metal-shadow-btn), 0 4px 14px rgba(0, 0, 0, 0.15) !important;
  margin-top: 0.25rem;
}

.traffic-cta:hover {
  box-shadow: inset 0 1px 0 rgba(255,255,255,0.4), 0 6px 18px rgba(0, 0, 0, 0.2) !important;
}

/* Matches beat-the-traffic image */
.traffic-image-wrap {
  position: relative;
  border-radius: 20px;
  overflow: hidden;
  box-shadow: 0 8px 24px rgba(15, 23, 42, 0.06), 0 24px 48px -12px rgba(15, 23, 42, 0.1);
  border: 1px solid rgba(15, 23, 42, 0.06);
  aspect-ratio: 16 / 9;
  width: 100%;
  max-width: 560px;
}

.traffic-image-wrap::before {
  content: '';
  position: absolute;
  top: 0;
  left: 0;
  right: 0;
  height: 3px;
  background: linear-gradient(90deg, var(--trust-blue), var(--sky-500));
  z-index: 1;
}

.traffic-image {
  width: 100%;
  height: 100%;
  object-fit: cover;
  object-position: center;
  transition: transform 0.5s ease;
}

.traffic-image-wrap:hover .traffic-image {
  transform: scale(1.03);
}

@media (max-width: 960px) {
  .traffic-grid {
    grid-template-columns: 1fr;
    gap: 2rem;
  }

  .traffic-visual {
    order: 1;
  }

  .traffic-content {
    order: 2;
    align-items: center;
    text-align: center;
  }

  .traffic-text {
    max-width: 560px;
    margin-left: auto;
    margin-right: auto;
  }

  .traffic-benefits {
    align-items: center;
  }

  .traffic-benefits li {
    justify-content: center;
  }

  .traffic-tags {
    justify-content: center;
  }
}

@media (max-width: 600px) {
  .traffic-section {
    padding: 3rem 0 3.5rem;
  }

  .traffic-grid {
    gap: 1.5rem;
  }

  .traffic-title {
    font-size: clamp(1.5rem, 6vw, 2rem);
  }

  .traffic-text {
    font-size: 1.0625rem;
  }

  .traffic-image-wrap {
    max-width: 100%;
    aspect-ratio: 1 / 1;
    border-radius: 12px;
    margin: 0 auto;
  }
}

/* Partners / Trusted by – horizontal sliding loop */
.partners-section {
  padding: 3rem 0;
  overflow: hidden;
}

.partners-header {
  margin-bottom: 2rem;
}

.partners-subtitle {
  font-size: 1rem;
  color: var(--text-secondary);
  margin-top: 0.5rem;
  max-width: 560px;
  margin-left: auto;
  margin-right: auto;
}

.partners-title {
  font-size: clamp(1.875rem, 3.5vw, 2.75rem);
  font-weight: 800;
  letter-spacing: -0.02em;
  color: var(--text-primary);
  margin: 0;
  line-height: 1.2;
}

.partners-marquee-wrap {
  overflow: hidden;
  mask-image: linear-gradient(to right, transparent, black 5%, black 95%, transparent);
  -webkit-mask-image: linear-gradient(to right, transparent, black 5%, black 95%, transparent);
}

.partners-marquee {
  display: flex;
  width: max-content;
  animation: partnersSlide 40s linear infinite;
}

.partners-track {
  display: flex;
  align-items: center;
  gap: 3rem;
  padding: 0 2rem;
  flex-shrink: 0;
}

.partner-item {
  display: flex;
  align-items: center;
  justify-content: center;
  flex-shrink: 0;
  padding: 1.25rem 2rem;
  background: white;
  border-radius: 12px;
  border: 1px solid rgba(14, 165, 233, 0.1);
  box-shadow: 0 2px 12px rgba(14, 165, 233, 0.06);
  transition: all 0.3s ease;
}

.partner-item:hover {
  border-color: rgba(14, 165, 233, 0.25);
  box-shadow: 0 4px 20px rgba(14, 165, 233, 0.12);
}

.partner-logo-img {
  max-height: 72px;
  max-width: 180px;
  width: auto;
  height: auto;
  object-fit: contain;
  opacity: 0.9;
  filter: grayscale(10%);
  transition: opacity 0.3s ease, filter 0.3s ease;
}

.partner-item:hover .partner-logo-img {
  opacity: 1;
  filter: grayscale(0%);
}

.trust-badge-item {
  flex-direction: column;
  gap: 0.5rem;
  min-width: 140px;
}

.trust-badge-icon {
  color: var(--sky-500) !important;
}

.trust-badge-label {
  font-size: 0.8125rem;
  font-weight: 600;
  color: var(--text-primary);
  text-align: center;
}

@keyframes partnersSlide {
  0% { transform: translateX(0); }
  100% { transform: translateX(-50%); }
}

/* Human Impact section */
.human-impact-section {
  padding: 5rem 0;
}

.human-impact-row {
  align-items: center;
}

.human-impact-img-wrap {
  border-radius: 50%;
  overflow: hidden;
  aspect-ratio: 1;
  max-width: 360px;
  box-shadow: 0 16px 48px rgba(14, 165, 233, 0.12);
  border: 4px solid rgba(255, 255, 255, 0.9);
}

.human-impact-img {
  width: 100%;
  height: 100%;
  object-fit: cover;
}

.human-impact-badge {
  display: inline-block;
  font-size: 0.8125rem;
  font-weight: 600;
  letter-spacing: 0.06em;
  text-transform: uppercase;
  color: var(--sky-600);
  margin-bottom: 1rem;
}

.human-impact-title {
  font-size: clamp(1.75rem, 3vw, 2.5rem);
  font-weight: 800;
  letter-spacing: -0.02em;
  color: var(--text-primary);
  margin: 0 0 1rem 0;
  line-height: 1.2;
}

.human-impact-desc {
  font-size: 1.125rem;
  color: var(--text-secondary);
  line-height: 1.7;
  margin: 0 0 1.5rem 0;
}

.human-impact-features {
  display: flex;
  flex-direction: column;
  gap: 1rem;
}

.human-impact-item {
  display: flex;
  align-items: center;
  gap: 1rem;
  font-size: 1rem;
  font-weight: 500;
  color: var(--text-primary);
}

.human-impact-icon {
  color: var(--sky-500);
  flex-shrink: 0;
}

/* Testimonials inclusivity visual */

.app-phone-3 {
  transform: rotate(-2deg);
  margin-top: 1rem;
}

/* Features – full width like other sections */
.features-container {
  padding: 5rem 1rem 6rem;
  max-width: 1200px;
  margin: 0 auto;
}

.features-section .features-header {
  margin-bottom: 3.25rem;
}

.features-section .features-title {
  font-size: clamp(2rem, 4.5vw, 2.875rem);
}

.features-section .features-subtitle {
  font-size: 1.125rem;
  max-width: 560px;
  margin-left: auto;
  margin-right: auto;
}

/* How It Works – wider grid, larger type */
.how-it-works-grid {
  display: grid;
  grid-template-columns: repeat(3, 1fr);
  gap: 2rem;
  margin-top: 2.5rem;
  max-width: 1100px;
  margin-left: auto;
  margin-right: auto;
}

@media (max-width: 960px) {
  .how-it-works-grid {
    grid-template-columns: 1fr;
    gap: 1.5rem;
  }
}

.how-step-card {
  position: relative;
  padding: 2.25rem 2rem;
  background: linear-gradient(180deg, #fff 0%, #f8fafc 100%);
  border-radius: 20px;
  border: 1px solid rgba(15, 23, 42, 0.08);
  box-shadow: inset 0 1px 0 rgba(255,255,255,0.9), 0 2px 12px rgba(15, 23, 42, 0.04), 0 12px 36px -8px rgba(0,0,0,0.08);
  transition: transform 0.25s ease, box-shadow 0.25s ease;
  text-align: center;
}

.how-step-card:hover {
  transform: translateY(-3px);
  box-shadow: inset 0 1px 0 rgba(255,255,255,0.95), 0 12px 28px rgba(15, 23, 42, 0.06), 0 24px 48px -12px rgba(0,0,0,0.1);
}

.how-step-num {
  display: block;
  font-size: 3rem;
  font-weight: 800;
  font-variant-numeric: tabular-nums;
  color: var(--sky-200);
  line-height: 1;
  margin-bottom: 1.25rem;
  letter-spacing: -0.04em;
}

.how-step-icon-wrap {
  width: 56px;
  height: 56px;
  margin: 0 auto 1.25rem;
  display: flex;
  align-items: center;
  justify-content: center;
  background: linear-gradient(135deg, var(--sky-50), #fff);
  color: var(--trust-blue) !important;
  border-radius: 14px;
  border: 1px solid rgba(14, 165, 233, 0.12);
}

.how-step-icon {
  color: var(--trust-blue) !important;
}

.how-step-title {
  font-size: 1.25rem;
  font-weight: 800;
  color: var(--text-primary);
  margin: 0 0 0.5rem 0;
  line-height: 1.3;
  letter-spacing: -0.02em;
}

.how-step-desc {
  font-size: 0.9375rem;
  color: var(--text-secondary);
  margin: 0 0 1rem 0;
  line-height: 1.55;
}

.how-step-list {
  list-style: none;
  padding: 0;
  margin: 0;
  text-align: left;
}

.how-step-list li {
  display: flex;
  align-items: center;
  gap: 0.5rem;
  font-size: 0.875rem;
  color: var(--text-primary);
  margin-bottom: 0.45rem;
}

.how-step-check {
  color: var(--sky-500) !important;
  flex-shrink: 0;
}

/* Line divider between Beat the Traffic and Featured Rides */
.section-line-divider {
  width: 100%;
  padding: 0;
  margin: 0;
  display: flex;
  justify-content: center;
  align-items: center;
  background: transparent;
}

.section-line-divider-inner {
  display: block;
  width: 100%;
  height: 1px;
  background: linear-gradient(90deg, transparent 0%, rgba(15, 23, 42, 0.12) 5%, rgba(15, 23, 42, 0.2) 50%, rgba(15, 23, 42, 0.12) 95%, transparent 100%);
  box-shadow: 0 1px 0 rgba(255, 255, 255, 0.04);
}

/* How it works – 3 steps */
/* How it Works: no border, no shadow on container */
.how-it-works-section .container-metallic {
  border: none !important;
  border-image: none !important;
  box-shadow: none !important;
}

/* Explore: no border, no shadow on container */
.explore-section .container-metallic {
  border: none !important;
  border-image: none !important;
  box-shadow: none !important;
}

/* Featured: no border, no shadow on container */
.featured-section .container-metallic {
  border: none !important;
  border-image: none !important;
  box-shadow: none !important;
}

.how-it-works-section {
  padding: 4.5rem 0 5rem;
  position: relative;
}
.how-it-works-section.section-light::before {
  display: none;
}
.how-it-works-header {
  max-width: 640px;
  margin: 0 auto 2.5rem;
}
.how-it-works-badge {
  display: inline-block;
  font-size: 0.75rem;
  font-weight: 700;
  letter-spacing: 0.12em;
  text-transform: uppercase;
  color: var(--trust-blue);
  margin-bottom: 0.5rem;
  padding: 0.4rem 0.875rem;
  background: var(--metal-badge, rgba(241, 245, 249, 0.9));
  border-radius: 9999px;
  border: 1px solid rgba(15, 23, 42, 0.08);
}
.how-it-works-title {
  font-size: clamp(1.875rem, 3.5vw, 2.5rem);
  font-weight: 800;
  letter-spacing: -0.02em;
  color: #0f172a;
  margin: 0 0 0.5rem 0;
  line-height: 1.2;
}
.how-it-works-title .title-accent {
  color: var(--sky-600);
}
.how-it-works-subtitle {
  font-size: 1.125rem;
  color: #64748b;
  margin: 0;
  line-height: 1.5;
}
.how-it-works-grid {
  display: grid;
  grid-template-columns: repeat(3, 1fr);
  gap: 2rem;
  max-width: 1000px;
  margin: 0 auto;
  position: relative;
}
.how-it-works-grid::before {
  content: '';
  position: absolute;
  left: 6%;
  right: 6%;
  top: 40px;
  height: 2px;
  background: linear-gradient(90deg, transparent, rgba(14, 165, 233, 0.3), rgba(14, 165, 233, 0.2), transparent);
  z-index: 0;
}
@media (max-width: 768px) {
  .how-it-works-grid {
    grid-template-columns: 1fr;
  }
  .how-it-works-grid::before {
    display: none;
  }
}
.how-it-works-card {
  padding: 2rem 1.5rem;
  background: #fff;
  border-radius: 16px;
  border: 1px solid rgba(15, 23, 42, 0.06);
  box-shadow: 0 4px 12px rgba(15, 23, 42, 0.04);
  text-align: center;
  transition: box-shadow 0.3s ease, transform 0.2s ease;
  position: relative;
  z-index: 1;
}
.how-it-works-card:nth-child(2) {
  margin-top: 12px;
}
.how-it-works-card:nth-child(3) {
  margin-top: 24px;
}
@media (max-width: 768px) {
  .how-it-works-card:nth-child(2),
  .how-it-works-card:nth-child(3) {
    margin-top: 0;
  }
}
.how-it-works-card:hover {
  box-shadow: 0 8px 24px rgba(15, 23, 42, 0.08);
  transform: translateY(-2px);
}
.how-it-works-icon-wrap {
  width: 72px;
  height: 72px;
  margin: 0 auto 1rem;
  display: flex;
  align-items: center;
  justify-content: center;
  background: linear-gradient(135deg, rgba(14, 165, 233, 0.1) 0%, rgba(14, 165, 233, 0.05) 100%);
  border-radius: 16px;
  color: var(--sky-600);
}
.how-it-works-step {
  display: inline-block;
  font-size: 0.6875rem;
  font-weight: 700;
  letter-spacing: 0.1em;
  text-transform: uppercase;
  color: var(--sky-500);
  margin-bottom: 0.5rem;
}
.how-it-works-card-title {
  font-size: 1.25rem;
  font-weight: 700;
  color: #0f172a;
  margin: 0 0 0.75rem 0;
}
.how-it-works-card-desc {
  font-size: 0.9375rem;
  color: #64748b;
  line-height: 1.55;
  margin: 0;
}

/* Tap. Book. Drive. – app value section (matches ad: dark bg, yellow headline, BOOK NOW) */
.tap-book-drive {
  position: relative;
  padding: 4rem 1.5rem;
  background: linear-gradient(145deg, #0c4a6e 0%, #0f172a 35%, #134e4a 70%, #0f172a 100%);
  overflow: hidden;
}
.tap-book-drive__inner {
  max-width: 1200px;
  margin: 0 auto;
  position: relative;
  z-index: 1;
}
.tap-book-drive__grid {
  display: grid;
  grid-template-columns: 1fr 1fr;
  gap: 3rem;
  align-items: center;
}
.tap-book-drive__content {
  padding: 1rem 0;
}
.tap-book-drive__eyebrow {
  font-size: 0.9rem;
  font-weight: 600;
  color: rgba(255, 255, 255, 0.85);
  margin: 0 0 0.5rem 0;
  letter-spacing: 0.06em;
  text-transform: uppercase;
}
.tap-book-drive__title {
  font-size: clamp(2rem, 4.5vw, 3rem);
  font-weight: 800;
  letter-spacing: -0.03em;
  line-height: 1.1;
  color: #fbbf24;
  margin: 0 0 1.25rem 0;
  text-transform: uppercase;
}
.tap-book-drive__lead {
  font-size: 1.15rem;
  font-weight: 600;
  color: #fff;
  margin: 0 0 0.35rem 0;
}
.tap-book-drive__sub {
  font-size: 1rem;
  line-height: 1.5;
  color: rgba(255, 255, 255, 0.9);
  margin: 0 0 1.5rem 0;
}
.tap-book-drive__cta {
  background: linear-gradient(180deg, #fbbf24 0%, #f59e0b 100%) !important;
  color: #0f172a !important;
  font-weight: 700 !important;
  text-transform: uppercase !important;
  letter-spacing: 0.08em !important;
  padding: 0.85rem 2rem !important;
  box-shadow: 0 4px 20px rgba(251, 191, 36, 0.4) !important;
}
.tap-book-drive__cta:hover {
  box-shadow: 0 6px 24px rgba(251, 191, 36, 0.5) !important;
}
.tap-book-drive__media {
  border-radius: 20px;
  overflow: hidden;
  box-shadow: 0 24px 48px rgba(0, 0, 0, 0.4);
  background: #1e293b;
  max-width: 380px;
  margin-right: auto;
}
.tap-book-drive__img {
  width: 100%;
  max-width: 100%;
  height: auto;
  display: block;
  vertical-align: middle;
}
@media (max-width: 900px) {
  .tap-book-drive__grid {
    grid-template-columns: 1fr;
    gap: 2rem;
  }
  .tap-book-drive__media {
    max-width: 320px;
    margin: 0 auto;
  }
}
@media (max-width: 600px) {
  .tap-book-drive {
    padding: 2.5rem 1rem;
  }
  .tap-book-drive__title {
    font-size: clamp(1.75rem, 7vw, 2.25rem);
  }
}

/* Late? No Problem. – last-minute booking (dark dynamic bg, yellow accent) */
.late-no-problem {
  position: relative;
  padding: 4rem 1.5rem;
  background: linear-gradient(160deg, #0f172a 0%, #1e3a5f 40%, #0c4a6e 70%, #0f172a 100%);
  overflow: hidden;
}
.late-no-problem__inner {
  max-width: 1200px;
  margin: 0 auto;
  position: relative;
  z-index: 1;
}
.late-no-problem__grid {
  display: grid;
  grid-template-columns: 1fr 1fr;
  gap: 3rem;
  align-items: center;
}
.late-no-problem__media {
  border-radius: 20px;
  overflow: hidden;
  box-shadow: 0 24px 48px rgba(0, 0, 0, 0.35);
  background: #1e293b;
  max-width: 380px;
  margin-left: auto;
}
.late-no-problem__img {
  width: 100%;
  max-width: 100%;
  height: auto;
  display: block;
  vertical-align: middle;
}
.late-no-problem__content {
  padding: 1rem 0;
}
.late-no-problem__title {
  font-size: clamp(2rem, 4.2vw, 2.75rem);
  font-weight: 800;
  letter-spacing: -0.02em;
  line-height: 1.15;
  color: #fff;
  margin: 0 0 1rem 0;
}
.late-no-problem__accent {
  color: #fbbf24;
}
.late-no-problem__lead {
  font-size: 1.05rem;
  line-height: 1.6;
  color: rgba(255, 255, 255, 0.92);
  margin: 0 0 1.25rem 0;
}
.late-no-problem__lead strong {
  color: #fbbf24;
}
.late-no-problem__features {
  list-style: none;
  padding: 0;
  margin: 0 0 1.5rem 0;
  display: grid;
  gap: 0.5rem;
}
.late-no-problem__features li {
  display: flex;
  align-items: center;
  gap: 0.5rem;
  font-size: 1rem;
  font-weight: 600;
  color: #fff;
}
.late-no-problem__cta {
  background: linear-gradient(180deg, #fbbf24 0%, #f59e0b 100%) !important;
  color: #0f172a !important;
  font-weight: 700 !important;
  text-transform: none !important;
  letter-spacing: 0.04em !important;
  padding: 0.85rem 2rem !important;
  box-shadow: 0 4px 20px rgba(251, 191, 36, 0.4) !important;
}
.late-no-problem__cta:hover {
  box-shadow: 0 6px 24px rgba(251, 191, 36, 0.5) !important;
}
@media (max-width: 900px) {
  .late-no-problem__grid {
    grid-template-columns: 1fr;
    gap: 2rem;
  }
  .late-no-problem__media {
    max-width: 320px;
    margin: 0 auto;
  }
}
@media (max-width: 600px) {
  .late-no-problem {
    padding: 2.5rem 1rem;
  }
  .late-no-problem__title {
    font-size: clamp(1.6rem, 6.5vw, 2rem);
  }
}

/* About BulodPH – Safe Byahe, Always (restyled) */
.about-new-section.about-safe-byahe {
  padding: 4.5rem 0 5rem;
  background: linear-gradient(165deg, #f0fdfa 0%, #ecfeff 20%, #f0f9ff 50%, #f8fafc 85%, #f1f5f9 100%);
}
.about-safe-byahe-grid {
  grid-template-columns: minmax(0, 0.9fr) minmax(0, 1fr);
  gap: 2.5rem;
  align-items: center;
}
.about-safe-byahe-content {
  background: linear-gradient(180deg, rgba(255, 255, 255, 0.95) 0%, rgba(248, 250, 252, 0.98) 100%);
  border-color: rgba(20, 184, 166, 0.2);
  box-shadow: inset 0 1px 0 rgba(255, 255, 255, 0.95), 0 12px 28px rgba(15, 23, 42, 0.08);
}
.about-safe-byahe-title {
  font-size: clamp(1.85rem, 3.8vw, 2.5rem);
  color: #0f172a;
  margin-bottom: 0.75rem;
}
.about-safe-byahe-title .title-accent-teal {
  color: #0d9488;
  font-weight: 800;
}
.about-safe-byahe-lead {
  font-size: 1.05rem;
  line-height: 1.55;
  color: #475569;
  margin-bottom: 1.25rem;
  font-weight: 500;
}
.about-safe-byahe-cta {
  margin-top: 1rem;
  background: linear-gradient(180deg, #fbbf24 0%, #f59e0b 100%) !important;
  color: #0f172a !important;
  font-weight: 700 !important;
  text-transform: none !important;
  letter-spacing: 0.02em !important;
  box-shadow: 0 4px 14px rgba(245, 158, 11, 0.35) !important;
}
.about-safe-byahe-cta:hover {
  box-shadow: 0 6px 20px rgba(245, 158, 11, 0.45) !important;
}
.about-safe-byahe-card {
  display: flex;
  flex-direction: column;
  gap: 0;
  border-radius: 20px;
  overflow: hidden;
  border: 1px solid rgba(20, 184, 166, 0.25);
  box-shadow: 0 16px 40px rgba(15, 23, 42, 0.12), 0 0 0 1px rgba(255, 255, 255, 0.5) inset;
}
.about-safe-byahe-image-wrap {
  aspect-ratio: 9 / 12;
  max-height: 420px;
  overflow: hidden;
  background: linear-gradient(180deg, #ccfbf1 0%, #e0f2fe 100%);
}
.about-safe-byahe-image-wrap .about-safe-byahe-image {
  width: 100%;
  height: 100%;
  object-fit: contain;
  object-position: center;
}
.about-safe-byahe-card-body {
  padding: 1.25rem 1.5rem;
  background: rgba(255, 255, 255, 0.9);
  border-top: 1px solid rgba(148, 163, 184, 0.2);
}

/* About BulodPH – legacy (Every Ride. One App. / van) */
.about-new-section {
  padding: 4.75rem 0 5.25rem;
  position: relative;
  background: linear-gradient(180deg, #fffefb 0%, #fff8ed 25%, #f8fafc 60%, #f1f5f9 100%);
}
.about-new-section .section-watermark {
  background-image: url('/logo.png'), url('/logo.png'), url('/logo.png'), url('/logo.png');
  background-repeat: no-repeat;
  background-position: 12% 20%, 50% 15%, 85% 25%, 70% 75%;
  background-size: min(18%, 140px), min(14%, 110px), min(16%, 120px), min(18%, 140px);
  opacity: 0.08;
}
.about-watermark .section-watermark {
  background-image:
    url('/logo.png'), url('/logo.png'), url('/logo.png'),
    url('/logo.png'), url('/logo.png'), url('/logo.png'),
    url('/logo.png'), url('/logo.png'), url('/logo.png'),
    url('/logo.png'), url('/logo.png'), url('/logo.png');
  background-repeat: no-repeat;
  background-position:
    6% 12%, 26% 8%, 50% 14%, 74% 6%, 92% 18%,
    8% 40%, 30% 46%, 54% 42%, 78% 48%, 94% 44%,
    12% 72%, 40% 76%, 70% 70%;
  background-size:
    min(18%, 130px), min(14%, 110px), min(16%, 120px), min(15%, 110px), min(18%, 130px),
    min(16%, 120px), min(14%, 110px), min(16%, 120px), min(15%, 110px), min(14%, 110px),
    min(18%, 130px), min(14%, 110px), min(16%, 120px);
  opacity: 0.18;
}
.about-new-container {
  max-width: none;
  position: relative;
}
.about-container-watermark::before {
  content: '';
  position: absolute;
  inset: 0;
  background-image: url('/logo.png');
  background-repeat: repeat;
  background-size: min(14%, 80px);
  background-position: 0 0;
  opacity: 0.08;
  pointer-events: none;
  z-index: 0;
  filter: grayscale(100%) brightness(200%);
}
.about-container-watermark .position-relative.z-index-2,
.about-new-inner {
  position: relative;
  z-index: 1;
}
.about-new-inner {
  max-width: none;
  width: 100%;
  margin: 0 auto;
  padding: 2rem 2.25rem;
  background: linear-gradient(180deg, #ffffff 0%, #f8fafc 100%);
  border-radius: 20px;
  border: 1px solid rgba(148, 163, 184, 0.3);
  box-shadow: 0 20px 45px rgba(15, 23, 42, 0.1);
  min-height: 520px;
  position: relative;
}
.about-new-inner::before {
  content: '';
  position: absolute;
  top: 0;
  left: 24px;
  right: 24px;
  height: 3px;
  background: linear-gradient(90deg, #0f172a, #ea580c, #f59e0b);
  border-radius: 999px;
}
.about-new-grid {
  display: grid;
  grid-template-columns: minmax(0, 1.35fr) minmax(0, 0.65fr);
  gap: 2.25rem;
  align-items: stretch;
}
/* Van section: equal columns, image left */
.van-about-grid {
  grid-template-columns: 1fr 1fr;
}
.van-about-image-wrap {
  aspect-ratio: 1024 / 1526;
  max-height: 420px;
}
.van-about-image-wrap .about-new-image {
  object-fit: contain;
  object-position: center;
}
.about-new-content {
  display: flex;
  flex-direction: column;
  height: 100%;
  background: linear-gradient(180deg, #f8fafc 0%, #ffffff 100%);
  border: 1px solid rgba(148, 163, 184, 0.2);
  border-radius: 18px;
  padding: 1.4rem 1.5rem;
  box-shadow: inset 0 1px 0 rgba(255, 255, 255, 0.9), 0 10px 24px rgba(15, 23, 42, 0.06);
}
.about-new-text {
  flex: 1;
}
.about-new-title-app {
  text-transform: none;
  letter-spacing: -0.03em;
}
.about-new-title-app .title-accent-orange {
  color: #ea580c;
  font-weight: 800;
}
.about-new-lead {
  font-size: 1rem;
  line-height: 1.6;
  color: #374151;
  margin: 0 0 1.25rem 0;
  max-width: 32em;
}
.about-new-bullets-check {
  list-style: none;
  padding: 0;
  margin: 0 0 1.5rem 0;
  display: grid;
  gap: 0.6rem;
}
.about-new-bullets-check li {
  display: flex;
  align-items: center;
  gap: 0.6rem;
  font-size: 1rem;
  font-weight: 600;
  color: #0f172a;
  padding-left: 0;
}
.about-new-bullets-check li::before {
  display: none;
}
.about-new-check {
  flex-shrink: 0;
  color: #16a34a;
}
.about-new-badge {
  display: inline-flex;
  align-items: center;
  gap: 0.4rem;
  font-size: 0.7rem;
  font-weight: 700;
  letter-spacing: 0.14em;
  text-transform: uppercase;
  color: var(--trust-blue);
  background: rgba(14, 165, 233, 0.08);
  border: 1px solid rgba(14, 165, 233, 0.25);
  padding: 0.4rem 0.85rem;
  border-radius: 999px;
  margin-bottom: 0.75rem;
}
.about-new-tag {
  display: inline-block;
  font-size: 0.75rem;
  font-weight: 700;
  letter-spacing: 0.06em;
  text-transform: uppercase;
  color: #0f172a;
  background: #e0f2fe;
  border: 1px solid rgba(14, 165, 233, 0.35);
  padding: 0.35rem 0.9rem;
  border-radius: 999px;
  margin-bottom: 0.85rem;
}
.about-new-tag-van {
  margin-right: 0.5rem;
}
.about-new-lead-sub {
  margin-top: -0.35rem;
  font-size: 0.9375rem;
  color: #64748b;
}
.about-new-title {
  font-size: clamp(1.9rem, 3.6vw, 2.6rem);
  font-weight: 800;
  letter-spacing: -0.02em;
  color: #0f172a;
  margin: 0 0 1rem 0;
}
.about-new-title .title-accent {
  color: var(--sky-600);
}
.about-new-text {
  font-size: 1.05rem;
  line-height: 1.7;
  color: #374151;
  margin: 0 0 1.25rem 0;
}
.about-new-bullets {
  list-style: none;
  padding: 0;
  margin: 0 0 1.25rem 0;
  display: grid;
  gap: 0.75rem;
}
.about-new-bullets li {
  position: relative;
  padding-left: 2rem;
  line-height: 1.6;
}
.about-new-bullets li::before {
  content: '';
  position: absolute;
  left: 0;
  top: 0.25rem;
  width: 1rem;
  height: 1rem;
  border-radius: 999px;
  background: rgba(56, 189, 248, 0.15);
  border: 2px solid rgba(56, 189, 248, 0.6);
  box-shadow: inset 0 0 0 2px #ffffff;
}
.about-new-stats {
  display: grid;
  grid-template-columns: repeat(3, minmax(0, 1fr));
  gap: 0.75rem;
  margin-bottom: 1.25rem;
}
.about-new-stat {
  background: #ffffff;
  border: 1px solid rgba(148, 163, 184, 0.25);
  border-radius: 14px;
  padding: 0.75rem 0.9rem;
  text-align: center;
  box-shadow: 0 8px 16px rgba(15, 23, 42, 0.05);
}
.about-new-stat-value {
  display: block;
  font-size: 1.2rem;
  font-weight: 800;
  color: var(--trust-blue);
}
.about-new-stat-label {
  display: block;
  font-size: 0.7rem;
  text-transform: uppercase;
  letter-spacing: 0.08em;
  color: #64748b;
  margin-top: 0.2rem;
}
.about-new-values {
  display: grid;
  grid-template-columns: repeat(3, minmax(0, 1fr));
  gap: 0.5rem;
  margin-top: 0.25rem;
}
.about-new-icon-row {
  display: grid;
  grid-template-columns: repeat(3, minmax(0, 1fr));
  gap: 0.75rem;
  margin: 1rem 0 1.25rem;
}
.about-new-icon-card {
  display: flex;
  align-items: center;
  gap: 0.6rem;
  padding: 0.65rem 0.75rem;
  background: #ffffff;
  border: 1px solid rgba(148, 163, 184, 0.25);
  border-radius: 14px;
  box-shadow: 0 8px 16px rgba(15, 23, 42, 0.05);
  font-weight: 600;
  color: #0f172a;
}
.about-new-icon-card .v-icon {
  color: var(--sky-600);
}
.about-new-value {
  display: inline-flex;
  align-items: center;
  gap: 0.5rem;
  font-size: 0.85rem;
  font-weight: 600;
  color: #0f172a;
  background: #f8fafc;
  border: 1px solid rgba(148, 163, 184, 0.25);
  border-radius: 999px;
  padding: 0.45rem 0.75rem;
  justify-content: center;
}
.about-new-value .v-icon {
  color: var(--sky-600);
}
.about-new-card {
  background: #ffffff;
  border: 1px solid rgba(148, 163, 184, 0.25);
  border-radius: 18px;
  padding: 1rem 1.1rem;
  box-shadow: 0 16px 30px rgba(15, 23, 42, 0.1);
  display: flex;
  flex-direction: column;
  gap: 0.75rem;
  height: 100%;
}
.about-new-card-frosted {
  background: rgba(255, 255, 255, 0.75);
  backdrop-filter: blur(12px);
  -webkit-backdrop-filter: blur(12px);
  border: 1px solid rgba(255, 255, 255, 0.6);
  box-shadow:
    0 4px 24px rgba(15, 23, 42, 0.08),
    0 0 0 1px rgba(234, 88, 12, 0.08);
}
.about-new-image-wrap {
  width: 100%;
  border-radius: 14px;
  overflow: hidden;
  aspect-ratio: 4 / 3;
  box-shadow: 0 12px 24px rgba(15, 23, 42, 0.12), 0 0 0 1px rgba(0, 0, 0, 0.04);
}
.about-new-card-frosted .about-new-image-wrap {
  aspect-ratio: 16 / 10;
}
.about-new-image {
  width: 100%;
  height: 100%;
  object-fit: cover;
  display: block;
  object-position: center top;
}
.about-new-card-title {
  font-size: 0.75rem;
  font-weight: 700;
  letter-spacing: 0.12em;
  text-transform: uppercase;
  color: var(--trust-blue);
}
.about-new-list {
  list-style: none;
  margin: 0;
  padding: 0;
  display: grid;
  gap: 0.6rem;
}
.about-new-list li {
  display: flex;
  align-items: center;
  gap: 0.55rem;
  font-size: 0.92rem;
  font-weight: 600;
  color: #1f2937;
}
@media (max-width: 960px) {
  .about-new-grid {
    grid-template-columns: 1fr;
  }
  .about-safe-byahe-grid {
    grid-template-columns: 1fr;
    gap: 1.75rem;
  }
  .about-safe-byahe-card {
    order: -1;
  }
  .about-safe-byahe-image-wrap {
    max-height: 340px;
  }
  .about-new-values {
    grid-template-columns: repeat(2, minmax(0, 1fr));
  }
}
@media (max-width: 600px) {
  .about-new-inner {
    padding: 1.25rem;
    border-radius: 16px;
    box-shadow: 0 14px 28px rgba(15, 23, 42, 0.08);
  }
  .about-new-grid {
    gap: 1.5rem;
  }
  .about-new-content {
    padding: 1rem;
    border-radius: 14px;
    background: #ffffff;
    border: 1px solid rgba(226, 232, 240, 0.9);
  }
  .about-new-title {
    font-size: clamp(1.55rem, 6.5vw, 1.95rem);
  }
  .about-safe-byahe-title {
    font-size: clamp(1.6rem, 6.5vw, 2rem);
  }
  .about-new-lead {
    font-size: 0.94rem;
  }
  .about-safe-byahe-image-wrap {
    max-height: 280px;
  }
  .about-new-bullets-check li {
    font-size: 0.94rem;
  }
  .about-new-text {
    font-size: 0.98rem;
    line-height: 1.65;
  }
  .about-new-bullets {
    gap: 0.55rem;
  }
  .about-new-bullets li {
    padding-left: 1.5rem;
  }
  .about-new-bullets li::before {
    width: 0.85rem;
    height: 0.85rem;
  }
  .about-new-banner {
    display: none;
  }
  .about-new-banner-track {
    animation: none;
    flex-wrap: wrap;
    white-space: normal;
    justify-content: flex-start;
    gap: 0.4rem;
    padding: 0.5rem;
  }
  .about-new-banner-group {
    flex-wrap: wrap;
  }
  .about-new-banner-group[aria-hidden="true"] {
    display: none;
  }
  .about-new-chip {
    font-size: 0.72rem;
    padding: 0.25rem 0.55rem;
    box-shadow: none;
    background: #ffffff;
    border-color: rgba(203, 213, 225, 0.8);
  }
  .about-new-icon-row {
    grid-template-columns: 1fr;
    gap: 0.5rem;
  }
  .about-new-icon-card {
    padding: 0.55rem 0.7rem;
    font-size: 0.84rem;
    border-radius: 12px;
    justify-content: flex-start;
  }
  .about-new-image-wrap {
    aspect-ratio: auto;
    height: 210px;
    max-height: none;
    background: #eef2f7;
  }
  .about-new-image {
    object-fit: contain;
    object-position: center bottom;
  }
  .about-new-stats {
    grid-template-columns: repeat(3, minmax(0, 1fr));
    gap: 0.5rem;
  }
  .about-new-stat {
    padding: 0.5rem 0.4rem;
    border-radius: 10px;
  }
  .about-new-stat-value {
    font-size: 1.05rem;
  }
  .about-new-stat-label {
    font-size: 0.6rem;
    letter-spacing: 0.06em;
  }
  .about-new-values {
    display: none;
  }
  .about-new-value {
    font-size: 0.8rem;
    padding: 0.4rem 0.6rem;
  }
  .about-new-card {
    padding: 0.85rem 0.95rem;
    border-radius: 14px;
    box-shadow: 0 10px 24px rgba(15, 23, 42, 0.08);
    background: #ffffff;
  }
  .about-new-card-title {
    font-size: 0.68rem;
    letter-spacing: 0.16em;
  }
  .about-new-list li {
    font-size: 0.88rem;
    line-height: 1.35;
  }
}
.about-inner::before {
  content: '';
  position: absolute;
  left: 0;
  top: 24px;
  bottom: 24px;
  width: 6px;
  background: linear-gradient(180deg, #1d4ed8 0%, #60a5fa 100%);
  border-radius: 999px;
}
.about-badge {
  display: inline-block;
  font-size: 0.75rem;
  font-weight: 700;
  letter-spacing: 0.12em;
  text-transform: uppercase;
  color: var(--trust-blue);
  margin-bottom: 0.75rem;
}
.about-title {
  font-size: clamp(1.75rem, 3vw, 2.25rem);
  font-weight: 800;
  letter-spacing: -0.02em;
  color: #0f172a;
  margin: 0 0 1rem 0;
  line-height: 1.25;
}
.about-title .title-accent {
  color: var(--sky-600);
}
.about-text {
  font-size: 1.05rem;
  color: #4b5563;
  line-height: 1.8;
  margin: 0 0 1.75rem 0;
}
.about-values {
  display: grid;
  grid-template-columns: repeat(auto-fit, minmax(160px, 1fr));
  gap: 0.75rem 1rem;
}
.about-value {
  display: inline-flex;
  align-items: center;
  justify-content: center;
  font-size: 0.95rem;
  font-weight: 700;
  color: #1f2937;
  padding: 0.65rem 0.85rem;
  background: #f8fafc;
  border: 1px solid rgba(148, 163, 184, 0.4);
  border-radius: 12px;
  gap: 0.5rem;
}
.about-value-icon {
  width: 18px;
  height: 18px;
  color: #1d4ed8;
}

/* Featured Rides – full width, larger type */
.featured-section {
  padding: 5rem 0 5.5rem;
  position: relative;
}

.featured-section.section-light::before {
  display: none;
}

.featured-section .section-container {
  max-width: 1480px;
}

.featured-header {
  max-width: 680px;
  margin: 0 auto 2.5rem;
  text-align: center;
  position: relative;
  padding-bottom: 0.75rem;
}

.featured-header::after {
  content: '';
  position: absolute;
  bottom: 0;
  left: 50%;
  transform: translateX(-50%);
  width: 48px;
  height: 4px;
  background: linear-gradient(90deg, var(--black-accent), var(--sky-400));
  box-shadow: inset 0 1px 0 rgba(255,255,255,0.25);
  border-radius: 2px;
}

.featured-badge {
  display: inline-block;
  font-size: 0.75rem;
  font-weight: 700;
  letter-spacing: 0.12em;
  text-transform: uppercase;
  color: var(--trust-blue);
  margin-bottom: 0.5rem;
  padding: 0.4rem 0.875rem;
  background: var(--metal-badge);
  border-radius: 9999px;
  border: 1px solid rgba(15, 23, 42, 0.1);
  box-shadow: inset 0 1px 0 rgba(255,255,255,0.4), 0 1px 3px rgba(0,0,0,0.06);
}

.featured-title {
  font-size: clamp(2rem, 4vw, 2.5rem);
  font-weight: 800;
  letter-spacing: -0.03em;
  color: #0f172a;
  margin: 0 0 0.75rem 0;
  line-height: 1.2;
}

.featured-title .title-accent {
  color: var(--sky-600);
}

.featured-subtitle {
  font-size: 1.125rem;
  color: #64748b;
  margin: 0;
  line-height: 1.55;
}

.featured-grid {
  display: grid;
  grid-template-columns: repeat(4, 1fr);
  gap: 1.75rem;
  max-width: none;
  width: 100%;
  margin: 0;
}

.featured-card {
  background: linear-gradient(180deg, #fff 0%, #fafbfd 100%);
  border-radius: 20px;
  overflow: hidden;
  border: 1px solid rgba(15, 23, 42, 0.08);
  box-shadow: inset 0 1px 0 rgba(255,255,255,0.8), 0 2px 12px rgba(15, 23, 42, 0.06), 0 8px 32px -8px rgba(0,0,0,0.08);
  transition: transform 0.3s ease, box-shadow 0.3s ease;
  display: flex;
  flex-direction: column;
  position: relative;
}

.featured-card::before {
  content: '';
  position: absolute;
  top: 0;
  left: 0;
  right: 0;
  height: 4px;
  background: linear-gradient(90deg, var(--black-accent), var(--trust-blue), var(--sky-400));
  box-shadow: inset 0 1px 0 rgba(255,255,255,0.2);
  z-index: 1;
}

/* Metallic card finish */
.featured-card-metallic {
  box-shadow: inset 0 1px 0 rgba(255,255,255,0.85), 0 2px 0 rgba(200,210,220,0.2), 0 4px 12px rgba(15, 23, 42, 0.06), 0 12px 32px -8px rgba(0,0,0,0.1) !important;
  border: 1px solid rgba(200, 210, 220, 0.35) !important;
}
.featured-card-metallic:hover {
  box-shadow: inset 0 1px 0 rgba(255,255,255,0.95), 0 2px 0 rgba(200,210,220,0.25), 0 12px 28px rgba(15, 23, 42, 0.08), 0 24px 48px -12px rgba(0,0,0,0.12) !important;
}

.featured-card:hover {
  transform: translateY(-4px);
  box-shadow: inset 0 1px 0 rgba(255,255,255,0.9), 0 12px 28px rgba(15, 23, 42, 0.08), 0 24px 48px -12px rgba(0,0,0,0.12);
}

.featured-card-image-wrap {
  position: relative;
  overflow: hidden;
  aspect-ratio: 16 / 10;
}
.featured-top-pick {
  position: absolute;
  top: 12px;
  left: 12px;
  padding: 0.35rem 0.75rem;
  background: rgba(15, 23, 42, 0.9);
  color: #fff;
  font-size: 0.7rem;
  font-weight: 700;
  letter-spacing: 0.08em;
  text-transform: uppercase;
  border-radius: 999px;
  z-index: 2;
  border: 1px solid rgba(255, 255, 255, 0.3);
}

.featured-card-image {
  width: 100%;
  height: 100%;
  object-fit: cover;
  object-position: center;
  transition: transform 0.4s ease;
}

.featured-card:hover .featured-card-image {
  transform: scale(1.05);
}

.featured-card-type {
  position: absolute;
  top: 0.875rem;
  left: 0.875rem;
  display: inline-flex;
  align-items: center;
  gap: 0.35rem;
  padding: 0.4rem 0.75rem;
  border-radius: 9999px;
  color: #fff;
  font-size: 0.75rem;
  font-weight: 700;
  letter-spacing: 0.04em;
  text-transform: uppercase;
  box-shadow: 0 2px 10px rgba(0, 0, 0, 0.2);
}
.featured-location {
  position: absolute;
  left: 0.875rem;
  bottom: 0.875rem;
  padding: 0.3rem 0.6rem;
  background: rgba(15, 23, 42, 0.85);
  color: #fff;
  font-size: 0.75rem;
  font-weight: 700;
  letter-spacing: 0.04em;
  border-radius: 999px;
}

.featured-card-body {
  padding: 1.5rem 1.25rem 1.5rem;
  display: flex;
  flex-direction: column;
  gap: 0.5rem;
  flex: 1;
}

.featured-card-vehicles {
  font-size: 0.9375rem;
  color: var(--sky-600);
  font-weight: 600;
  margin: 0;
  line-height: 1.4;
  letter-spacing: 0.01em;
}

.featured-card-desc {
  font-size: 1rem;
  color: #475569;
  line-height: 1.52;
  margin: 0;
  flex: 1;
}

.featured-card-price {
  margin: 0.75rem 0 0.5rem;
}
.featured-price-row {
  display: flex;
  align-items: baseline;
  gap: 0.5rem;
  flex-wrap: wrap;
}
.featured-price-badge {
  font-size: 0.75rem;
  font-weight: 700;
  letter-spacing: 0.06em;
  text-transform: uppercase;
  color: #0f172a;
  background: #fde68a;
  border: 1px solid #f59e0b;
  padding: 0.2rem 0.5rem;
  border-radius: 999px;
}
.featured-price-original {
  display: flex;
  align-items: center;
  gap: 0.5rem;
  margin-top: 0.25rem;
}
.featured-price-old {
  font-size: 0.9rem;
  color: #94a3b8;
  text-decoration: line-through;
}
.featured-price-save {
  font-size: 0.85rem;
  font-weight: 600;
  color: #16a34a;
}

.featured-price-amount {
  font-size: 1.625rem;
  font-weight: 800;
  font-variant-numeric: tabular-nums;
  color: var(--trust-blue);
  letter-spacing: -0.02em;
}

.featured-price-period {
  font-size: 0.9375rem;
  color: #64748b;
  margin-left: 0.2rem;
}

.featured-card-btn {
  font-weight: 700 !important;
  margin-top: 0.25rem !important;
  letter-spacing: 0.02em !important;
  background: linear-gradient(180deg, var(--primary-cyan) 0%, var(--sky-600) 100%) !important;
  color: #fff !important;
  border: 1px solid rgba(255, 255, 255, 0.3) !important;
  box-shadow: var(--metal-shadow-btn), 0 4px 12px rgba(0,0,0,0.2) !important;
  height: 36px !important;
  min-height: 36px !important;
  padding: 0 1.25rem !important;
  font-size: 0.9rem !important;
  text-transform: uppercase !important;
  width: 100% !important;
  min-width: 100% !important;
  box-sizing: border-box !important;
  display: inline-flex !important;
  justify-content: center !important;
}

.featured-card-btn:hover {
  box-shadow: inset 0 1px 0 rgba(255,255,255,0.35), 0 6px 18px rgba(0,0,0,0.25) !important;
}

@media (max-width: 960px) {
  .featured-grid {
    grid-template-columns: repeat(2, 1fr);
  }
}

@media (max-width: 600px) {
  .featured-section {
    padding: 3rem 0;
  }

  .featured-header {
    margin-bottom: 1.75rem;
  }

  .featured-grid {
    grid-template-columns: repeat(2, minmax(0, 1fr));
    gap: 1.25rem;
  }

  .featured-card-image-wrap {
    aspect-ratio: 4 / 3;
  }

  .featured-card-body {
    padding: 1rem 1rem 1.25rem;
  }
}

/* Why BulodPH – premium pillar cards */
.why-section {
  padding: 5rem 0;
}

/* Bento grid (Notion/Linear-style) */
.why-bento {
  display: grid;
  grid-template-columns: 1fr 1fr;
  grid-template-rows: auto auto;
  gap: 1rem;
  margin-top: 2.5rem;
  max-width: 900px;
  margin-left: auto;
  margin-right: auto;
}

.why-bento-cell {
  min-width: 0;
}

.why-bento-cell--tall {
  grid-row: span 2;
}

.why-bento-cell .why-card {
  height: 100%;
  min-height: 160px;
}

.why-bento-cell--tall .why-card {
  min-height: 100%;
}

@media (max-width: 768px) {
  .why-bento {
    grid-template-columns: 1fr;
    grid-template-rows: auto;
  }

  .why-bento-cell--tall {
    grid-row: span 1;
  }
}

.why-card {
  padding: 1.75rem 1.75rem 1.75rem 2rem;
  background: #fff;
  border-radius: 16px;
  border: 1px solid rgba(15, 23, 42, 0.06);
  border-left: 3px solid var(--trust-blue);
  height: 100%;
  transition: all 0.3s ease;
  box-shadow: 0 4px 6px rgba(15, 23, 42, 0.03), 0 10px 30px -10px rgba(15, 23, 42, 0.06);
}

.why-card:hover {
  border-left-color: var(--sky-500);
  box-shadow: 0 8px 16px rgba(15, 23, 42, 0.04), 0 20px 40px -12px rgba(15, 23, 42, 0.08);
}

.why-card-icon {
  width: 52px;
  height: 52px;
  display: flex;
  align-items: center;
  justify-content: center;
  background: rgba(15, 23, 42, 0.05);
  color: var(--trust-blue) !important;
  border-radius: 12px;
  margin-bottom: 1.25rem;
}

.why-card-title {
  font-size: 1.125rem;
  font-weight: 700;
  color: var(--text-primary);
  margin: 0 0 0.5rem 0;
}

.why-card-desc {
  font-size: 0.9375rem;
  color: var(--text-secondary);
  margin: 0;
  line-height: 1.5;
}

.features-grid {
  display: flex;
  flex-direction: row;
  gap: 1.5rem;
  overflow-x: auto;
  padding: 0.5rem 0 1.5rem;
  scroll-snap-type: x mandatory;
  -webkit-overflow-scrolling: touch;
}

.features-grid::-webkit-scrollbar {
  height: 8px;
}

.features-grid::-webkit-scrollbar-track {
  background: rgba(14, 165, 233, 0.08);
  border-radius: 4px;
}

.features-grid::-webkit-scrollbar-thumb {
  background: rgba(14, 165, 233, 0.3);
  border-radius: 4px;
}

.feature-card-h {
  flex-shrink: 0;
  width: 360px;
  scroll-snap-align: start;
}

.feature-card-h-inner {
  background: white;
  border-radius: 24px;
  padding: 2rem;
  height: 100%;
  border: 1px solid rgba(14, 165, 233, 0.12);
  box-shadow: 0 4px 24px rgba(14, 165, 233, 0.08);
  transition: all 0.4s cubic-bezier(0.4, 0, 0.2, 1);
  position: relative;
  overflow: hidden;
}

.feature-card-h-inner::before {
  content: '';
  position: absolute;
  top: 0;
  left: 0;
  right: 0;
  height: 4px;
  background: linear-gradient(90deg, var(--feature-color, #0369a1), #0ea5e9);
  opacity: 0;
  transition: opacity 0.3s ease;
}

.feature-card-h:hover .feature-card-h-inner {
  transform: translateY(-8px);
  box-shadow: 0 16px 48px rgba(14, 165, 233, 0.18);
  border-color: rgba(14, 165, 233, 0.25);
}

.feature-card-h:hover .feature-card-h-inner::before {
  opacity: 1;
}

.feature-card-h-icon {
  width: 64px;
  height: 64px;
  border-radius: 16px;
  display: flex;
  align-items: center;
  justify-content: center;
  margin-bottom: 1.25rem;
  position: relative;
  overflow: hidden;
}

.feature-card-h-icon::before {
  content: '';
  position: absolute;
  inset: 0;
  background: var(--feature-color, #0369a1);
  opacity: 0.12;
  border-radius: 16px;
}

.feature-card-h-icon-svg {
  color: var(--feature-color, #0369a1) !important;
  position: relative;
  z-index: 1;
}

.feature-card-h-title {
  font-size: 1.375rem;
  font-weight: 700;
  color: var(--text-primary);
  margin: 0 0 0.5rem 0;
  line-height: 1.3;
}

.feature-card-h-desc {
  font-size: 0.9375rem;
  color: var(--text-secondary);
  line-height: 1.55;
  margin: 0 0 1rem 0;
}

.feature-card-h-list {
  list-style: none;
  padding: 0;
  margin: 0 0 1rem 0;
  font-size: 0.8125rem;
  color: var(--text-secondary);
  font-weight: 500;
}

.feature-card-h-list li {
  display: flex;
  align-items: center;
  gap: 0.5rem;
  margin-bottom: 0.35rem;
}

.feature-card-h-check {
  color: #059669 !important;
  flex-shrink: 0;
}

.feature-card-h-img {
  height: 200px;
  border-radius: 12px;
  overflow: hidden;
  border: 1px solid rgba(14, 165, 233, 0.1);
}

.feature-card-h-img .v-img {
  width: 100%;
  height: 100%;
}

/* Responsive features – horizontal layout */
@media (max-width: 960px) {
  .feature-card-h {
    width: 320px;
  }
}

@media (max-width: 600px) {
  .feature-card-h {
    width: 280px;
  }
}

/* Responsive features */
@media (max-width: 960px) {
  .footer-top {
    grid-template-columns: 1fr;
  }

  .footer-map-wrap {
    min-height: 240px;
  }

  .footer-map {
    height: 240px;
  }

  .app-showcase-features-grid {
    grid-template-columns: repeat(2, 1fr);
  }

  .app-showcase-phones {
    flex-direction: column;
    min-height: auto;
    padding: 2rem 0;
    gap: 1rem;
  }

  .app-phone-img {
    max-width: 220px;
  }

  .app-phone-1,
  .app-phone-2,
  .app-phone-3 {
    transform: none;
    margin: 0.5rem 0;
  }

  .human-impact-section .human-impact-row {
    flex-direction: column-reverse;
  }

  .human-impact-img-wrap {
    max-width: 280px;
    margin: 0 auto;
  }

  .partners-logos {
    gap: 1.5rem 2rem;
  }

  .partner-logo-img {
    max-height: 56px;
    max-width: 140px;
  }
}

@media (max-width: 600px) {
  .app-showcase-features-grid {
    grid-template-columns: 1fr;
    gap: 1rem;
  }

  .app-showcase-visual-wrap {
    padding: 1.5rem;
  }

  .testimonials-grid {
    grid-template-columns: 1fr;
    gap: 1rem;
  }

  .feature-block {
    padding: 1.75rem 1.25rem;
  }

  .feature-block-app-img {
    width: 100%;
    height: 140px;
  }

  .feature-block-title {
    font-size: 1.25rem;
  }

  .feature-block-desc {
    font-size: 0.9375rem;
  }
}

.stat-num {
  color: var(--sky-600) !important;
}

/* App Showcase Section – restyled */
.app-showcase-section {
  padding: 5rem 0;
  position: relative;
  overflow: hidden;
  background: linear-gradient(180deg, #f0f9ff 0%, #e0f2fe 40%, #bae6fd 100%);
}

.app-showcase-bg {
  position: absolute;
  inset: 0;
  background-image:
    radial-gradient(circle at 20% 30%, rgba(14, 165, 233, 0.08) 0%, transparent 50%),
    radial-gradient(circle at 80% 70%, rgba(6, 182, 212, 0.06) 0%, transparent 50%);
  pointer-events: none;
}

.app-showcase-container {
  margin: 0 auto;
  position: relative;
  z-index: 1;
}

.app-showcase-header {
  margin-bottom: 3rem;
}

.app-showcase-badge {
  display: inline-block;
  font-size: 0.8125rem;
  font-weight: 600;
  letter-spacing: 0.08em;
  text-transform: uppercase;
  color: #0369a1;
  margin-bottom: 1rem;
}

.app-showcase-title {
  font-size: clamp(1.875rem, 3.5vw, 2.5rem);
  font-weight: 800;
  letter-spacing: -0.02em;
  color: #111;
  margin: 0 0 1rem 0;
  line-height: 1.2;
}

.app-showcase-desc {
  font-size: 1.125rem;
  color: var(--text-secondary);
  line-height: 1.6;
  margin: 0;
  max-width: 560px;
  margin-left: auto;
  margin-right: auto;
}

.app-showcase-body {
  display: flex;
  flex-direction: column;
  gap: 3rem;
}

.app-showcase-features-grid {
  display: grid;
  grid-template-columns: repeat(4, 1fr);
  gap: 1.25rem;
}

.app-feature-card {
  background: white;
  border-radius: 16px;
  padding: 1.5rem;
  border: 1px solid rgba(14, 165, 233, 0.12);
  box-shadow: 0 4px 20px rgba(14, 165, 233, 0.06);
  transition: all 0.3s ease;
  min-width: 0;
}

.app-feature-card:hover {
  transform: translateY(-4px);
  box-shadow: 0 12px 32px rgba(14, 165, 233, 0.12);
  border-color: rgba(14, 165, 233, 0.2);
}

.app-feature-icon {
  width: 52px;
  height: 52px;
  display: flex;
  align-items: center;
  justify-content: center;
  background: linear-gradient(135deg, #e0f2fe 0%, #bae6fd 100%);
  border-radius: 14px;
  color: #0369a1;
  margin-bottom: 1rem;
}

.app-feature-title {
  font-size: 0.9375rem;
  font-weight: 700;
  color: var(--text-primary);
  margin: 0 0 0.35rem 0;
  line-height: 1.3;
}

.app-feature-desc {
  font-size: 0.8125rem;
  color: var(--text-secondary);
  margin: 0;
  line-height: 1.4;
}

.app-showcase-visual-wrap {
  background: white;
  border-radius: 24px;
  padding: 2.5rem;
  border: 1px solid rgba(14, 165, 233, 0.12);
  box-shadow: 0 8px 40px rgba(14, 165, 233, 0.1);
}

.app-showcase-phones {
  display: flex;
  justify-content: center;
  align-items: center;
  gap: 1.5rem;
  min-height: 320px;
  margin-bottom: 2rem;
}

.app-phone-img {
  max-width: 260px;
  border-radius: 20px;
  box-shadow: 0 20px 48px rgba(14, 165, 233, 0.18);
  border: 3px solid rgba(255, 255, 255, 0.95);
}

.app-phone-1 { transform: rotate(-5deg); }
.app-phone-2 { transform: rotate(3deg); margin-top: 1.5rem; }
.app-phone-3 { transform: rotate(-2deg); margin-top: 1rem; }

.app-showcase-cta {
  text-align: center;
}

.app-download-btn {
  min-height: 52px;
}

.app-showcase-availability {
  font-size: 0.875rem;
  color: var(--text-secondary);
  margin: 0.75rem 0 0 0;
}

/* Testimonials section – restyled editorial cards */
.testimonials-section.testimonials-restyled {
  padding: 5rem 0;
  position: relative;
  width: 100vw;
  min-height: 1px;
  box-sizing: border-box;
  margin-left: calc(50% - 50vw);
  margin-right: calc(50% - 50vw);
  padding-left: 0;
  padding-right: 0;
  background: linear-gradient(165deg, #f8fafc 0%, #eef2f7 50%, #e2e8f0 100%);
  overflow: hidden;
}
.testimonials-watermark .section-watermark {
  background-image:
    url('/logo.png'), url('/logo.png'), url('/logo.png'),
    url('/logo.png'), url('/logo.png'), url('/logo.png'),
    url('/logo.png'), url('/logo.png'), url('/logo.png'),
    url('/logo.png'), url('/logo.png'), url('/logo.png');
  background-repeat: no-repeat;
  background-position:
    6% 12%, 26% 8%, 50% 14%, 74% 6%, 92% 18%,
    8% 40%, 30% 46%, 54% 42%, 78% 48%, 94% 44%,
    12% 72%, 40% 76%, 70% 70%;
  background-size:
    min(18%, 130px), min(14%, 110px), min(16%, 120px), min(15%, 110px), min(18%, 130px),
    min(16%, 120px), min(14%, 110px), min(16%, 120px), min(15%, 110px), min(14%, 110px),
    min(18%, 130px), min(14%, 110px), min(16%, 120px);
  opacity: 0.1;
}
.testimonials-section.testimonials-restyled::before {
  content: '';
  position: absolute;
  top: 20%;
  right: -10%;
  width: 60%;
  height: 60%;
  background: linear-gradient(135deg, rgba(14, 165, 233, 0.08), rgba(148, 163, 184, 0.1));
  transform: rotate(-6deg);
  border-radius: 40px;
}

.testimonials-ph-ribbon {
  position: absolute;
  top: 0;
  left: 0;
  right: 0;
  height: 5px;
  display: flex;
  z-index: 1;
}

.testimonials-ph-bar {
  flex: 1;
  height: 100%;
}

.testimonials-ph-blue { background: var(--ph-blue); }
.testimonials-ph-red { background: var(--ph-red); }
.testimonials-ph-gold { background: var(--ph-gold); }

.testimonials-container {
  margin: 0 auto;
  position: relative;
  z-index: 1;
}

.testimonials-header {
  text-align: center;
  margin-bottom: 3rem;
  position: relative;
  padding-bottom: 1rem;
}

.testimonials-header::after {
  content: '';
  position: absolute;
  bottom: 0;
  left: 50%;
  transform: translateX(-50%);
  width: 56px;
  height: 4px;
  background: linear-gradient(90deg, var(--ph-blue), var(--ph-red), var(--ph-gold));
  border-radius: 2px;
}

.testimonials-badge {
  display: inline-block;
  font-size: 0.6875rem;
  font-weight: 700;
  letter-spacing: 0.14em;
  text-transform: uppercase;
  color: var(--trust-blue);
  margin-bottom: 1rem;
  padding: 0.4rem 1rem;
  background: rgba(255, 255, 255, 0.9);
  border-radius: 9999px;
  border: 1px solid rgba(14, 165, 233, 0.2);
  box-shadow: 0 2px 8px rgba(15, 23, 42, 0.06);
}

.testimonials-title {
  font-size: clamp(1.875rem, 3.5vw, 2.5rem);
  font-weight: 800;
  letter-spacing: -0.03em;
  color: #0f172a;
  margin: 0 0 0.75rem 0;
  line-height: 1.2;
}

.testimonials-title-accent {
  color: var(--sky-600);
}

.testimonials-subtitle {
  font-size: 1.0625rem;
  color: var(--text-secondary);
  margin: 0 0 1.5rem 0;
  max-width: 480px;
  margin-left: auto;
  margin-right: auto;
}

.testimonials-grid {
  display: grid;
  grid-template-columns: repeat(3, 1fr);
  gap: 2rem;
}

.testimonial-card-restyled {
  display: flex;
  flex-direction: column;
  align-items: stretch;
  transition: transform 0.3s ease, box-shadow 0.3s ease;
  position: relative;
}

.testimonial-card-restyled:hover {
  transform: translateY(-4px);
}

.testimonial-card-body {
  flex: 1;
  padding: 1.75rem 1.5rem 1.5rem;
  background: #fff;
  border-radius: 16px;
  border: 1px solid rgba(226, 232, 240, 0.9);
  box-shadow: 0 4px 20px rgba(15, 23, 42, 0.06), 0 1px 3px rgba(0, 0, 0, 0.04);
  position: relative;
  overflow: hidden;
}
.testimonial-card-body::after {
  content: '“';
  position: absolute;
  top: 10px;
  right: 16px;
  font-size: 4rem;
  color: rgba(148, 163, 184, 0.25);
  font-family: 'Archivo Black', 'Inter', sans-serif;
  line-height: 1;
}
.testimonial-stars {
  display: inline-flex;
  gap: 0.25rem;
  color: #f59e0b;
  margin-bottom: 0.6rem;
}
.testimonial-star {
  width: 16px;
  height: 16px;
  display: inline-flex;
}

.testimonial-card-restyled:hover .testimonial-card-body {
  box-shadow: 0 12px 32px rgba(15, 23, 42, 0.1), 0 4px 12px rgba(0, 0, 0, 0.06);
}

.testimonial-card-accent {
  position: absolute;
  left: 0;
  top: 0;
  bottom: 0;
  width: 4px;
  background: linear-gradient(180deg, var(--ph-blue), var(--ph-red), var(--ph-gold));
  border-radius: 4px 0 0 4px;
}

.testimonial-stars {
  display: flex;
  gap: 3px;
  margin-bottom: 1rem;
}

.testimonial-star {
  color: #f59e0b !important;
}

.testimonial-quote {
  font-size: 0.9375rem;
  line-height: 1.65;
  color: #334155;
  margin: 0 0 1rem 0;
  font-style: normal;
}

.testimonial-result-pill {
  display: inline-flex;
  align-items: center;
  gap: 0.4rem;
  background: transparent;
  color: var(--trust-blue);
  font-size: 0.8125rem;
  font-weight: 600;
  padding: 0.45rem 0.9rem;
  border-radius: 999px;
  margin-top: 0.5rem;
  border: 1.5px solid rgba(14, 165, 233, 0.35);
}

.testimonial-result-pill .v-icon {
  color: var(--trust-blue);
}

.testimonial-author {
  display: flex;
  align-items: center;
  gap: 0.875rem;
  margin-top: 1.25rem;
}

.testimonial-avatar {
  flex-shrink: 0;
  border: 2px solid rgba(14, 165, 233, 0.2);
}

.testimonial-meta {
  display: flex;
  flex-direction: column;
  gap: 0.2rem;
}

.testimonial-name {
  font-weight: 700;
  font-size: 0.9375rem;
  color: var(--text-primary);
}

.testimonial-role {
  font-size: 0.8125rem;
  color: var(--text-secondary);
}

.testimonial-location {
  font-size: 0.75rem;
  color: var(--text-secondary);
}

@media (max-width: 960px) {
  .testimonials-grid {
    grid-template-columns: 1fr;
    gap: 1.5rem;
  }
}

/* Pricing section */
.pricing-section {
  padding: 4.5rem 0;
  position: relative;
}

.pricing-section.section-light::before {
  display: none;
}

.pricing-header {
  max-width: 640px;
  margin: 0 auto;
}

.pricing-badge {
  display: inline-block;
  font-size: 0.8125rem;
  font-weight: 600;
  letter-spacing: 0.06em;
  text-transform: uppercase;
  color: var(--sky-600);
  margin-bottom: 1rem;
}

.pricing-title {
  font-size: clamp(1.875rem, 3.5vw, 2.75rem);
  font-weight: 800;
  letter-spacing: -0.02em;
  color: #111;
  margin: 0 0 0.75rem 0;
  line-height: 1.2;
}

.pricing-subtitle {
  font-size: 1.125rem;
  color: #374151;
  margin: 0;
}

.pricing-grid {
  margin-top: 2.5rem;
}

.pricing-card {
  background: #fff !important;
  border-radius: 24px !important;
  border: 2px solid rgba(14, 165, 233, 0.1);
  transition: all 0.4s cubic-bezier(0.4, 0, 0.2, 1);
  position: relative;
  overflow: hidden;
  animation: slideUp 0.5s ease-out both;
  box-shadow: 0 4px 24px rgba(14, 165, 233, 0.06) !important;
}

.pricing-card:hover {
  transform: translateY(-10px);
  box-shadow: 0 24px 48px rgba(0, 0, 0, 0.1) !important;
  border-color: rgba(14, 165, 233, 0.3);
}

.pricing-card-popular {
  border-color: #0ea5e9 !important;
  border-width: 2px;
  transform: scale(1.03);
  box-shadow: 0 16px 48px rgba(14, 165, 233, 0.2) !important;
  z-index: 2;
}

.pricing-card-popular:hover {
  transform: scale(1.03) translateY(-10px);
  box-shadow: 0 24px 60px rgba(14, 165, 233, 0.25) !important;
}

.popular-badge {
  position: absolute;
  top: -1px;
  left: 50%;
  transform: translateX(-50%);
  z-index: 2;
  font-size: 0.75rem;
  font-weight: 600;
  letter-spacing: 0.03em;
  padding: 0.35rem 1rem;
  background: var(--sky-500);
  color: #fff;
  border-radius: 0 0 10px 10px;
}

.pricing-card-inner {
  padding: 2rem 1.75rem 1.5rem !important;
  text-align: center;
}

.pricing-plan-users {
  font-size: 0.8125rem;
  font-weight: 600;
  letter-spacing: 0.02em;
  color: var(--text-secondary);
  margin-bottom: 0.5rem;
}

.pricing-amount {
  display: flex;
  align-items: baseline;
  justify-content: center;
  gap: 0.15rem;
  margin-bottom: 0.25rem;
}

.currency {
  font-size: 1.5rem;
  font-weight: 600;
  color: var(--text-secondary);
}

.price {
  font-size: 3.25rem;
  font-weight: 800;
  line-height: 1;
  background: linear-gradient(135deg, var(--sky-600), var(--sky-500));
  -webkit-background-clip: text;
  -webkit-text-fill-color: transparent;
  background-clip: text;
}

.period {
  font-size: 1.125rem;
  color: var(--text-secondary);
}

.pricing-annual {
  font-size: 0.8125rem;
  color: var(--text-secondary);
  margin: 0 0 1.5rem 0;
}

.pricing-divider {
  margin: 0 0 1.5rem 0 !important;
  border-color: var(--sky-200) !important;
}

.pricing-features-ul {
  list-style: none;
  padding: 0;
  margin: 0;
  text-align: left;
  font-size: 0.9375rem;
  color: var(--text-primary);
}

.pricing-features-ul li {
  position: relative;
  padding-left: 1.5rem;
  margin-bottom: 0.5rem;
}

.pricing-features-ul li::before {
  content: '';
  position: absolute;
  left: 0;
  top: 0.45em;
  width: 6px;
  height: 6px;
  border-radius: 50%;
  background: var(--sky-500);
}

.pricing-actions {
  padding: 0 1.75rem 1.75rem !important;
}

.pricing-cta {
  font-weight: 600;
  letter-spacing: 0.02em;
  text-transform: none;
  transition: all 0.25s ease;
  border: 2px solid var(--sky-300) !important;
  color: var(--sky-600) !important;
  background: transparent !important;
}

.pricing-cta:hover {
  transform: translateY(-2px);
  border-color: var(--sky-500) !important;
  background: var(--sky-50) !important;
}

.pricing-cta-primary {
  background: var(--sky-500) !important;
  border-color: var(--sky-500) !important;
  color: #fff !important;
}

.pricing-cta-primary:hover {
  background: var(--sky-600) !important;
  border-color: var(--sky-600) !important;
  color: #fff !important;
  box-shadow: 0 6px 20px rgba(14, 165, 233, 0.35);
}

.pricing-card-glow {
  position: absolute;
  top: -50%;
  left: -50%;
  width: 200%;
  height: 200%;
  background: radial-gradient(circle, rgba(14, 165, 233, 0.06), transparent 50%);
  animation: rotate 20s linear infinite;
  pointer-events: none;
}

/* Scroll Animations */
.scroll-animate {
  opacity: 0;
  transform: translateY(50px);
  transition: all 0.8s cubic-bezier(0.4, 0, 0.2, 1);
}

.scroll-animate.animate-in {
  opacity: 1;
  transform: translateY(0);
}

/* Scroll reveal – keep content visible unless JS enables animations */
.scroll-reveal {
  opacity: 1;
  transform: none;
}
:global(.scroll-reveal-ready) .scroll-reveal {
  opacity: 0;
  transition: opacity 0.7s cubic-bezier(0.4, 0, 0.2, 1), transform 0.7s cubic-bezier(0.4, 0, 0.2, 1);
}
:global(.scroll-reveal-ready) .scroll-reveal.animate-in {
  opacity: 1;
}
:global(.scroll-reveal-ready) .scroll-reveal-up {
  transform: translateY(48px);
}
:global(.scroll-reveal-ready) .scroll-reveal-up.animate-in {
  transform: translateY(0);
}
.scroll-reveal-shine {
  position: relative;
  overflow: hidden;
}
.scroll-reveal-shine::after {
  content: '';
  position: absolute;
  top: 0;
  left: -100%;
  width: 50%;
  height: 100%;
  background: linear-gradient(90deg, transparent, rgba(255, 255, 255, 0.15), transparent);
  pointer-events: none;
  z-index: 1;
  opacity: 0;
}
.scroll-reveal-shine.animate-in::after {
  animation: sectionShine 2.2s ease-in-out 0.3s forwards;
}
@keyframes sectionShine {
  0% { left: -100%; opacity: 0; }
  20% { opacity: 1; }
  80% { opacity: 1; }
  100% { left: 150%; opacity: 0; }
}
.scroll-reveal-metallic.animate-in {
  box-shadow: var(--metal-shadow), 0 8px 32px rgba(0, 0, 0, 0.12);
  border: 1px solid rgba(200, 210, 220, 0.25);
}

.animate-fade-in {
  opacity: 0;
  animation: fadeInUp 0.8s cubic-bezier(0.4, 0, 0.2, 1) forwards;
}

@keyframes fadeInUp {
  from {
    opacity: 0;
    transform: translateY(30px);
  }
  to {
    opacity: 1;
    transform: translateY(0);
  }
}

/* Contact Us – metallic + black accent */
.contact-section {
  padding: 100px 0;
  background: #1e2128;
  position: relative;
  overflow: hidden;
  background-image:
    radial-gradient(ellipse 80% 50% at 20% 40%, rgba(2, 132, 199, 0.12) 0%, transparent 50%),
    radial-gradient(ellipse 60% 40% at 80% 60%, rgba(14, 165, 233, 0.08) 0%, transparent 50%),
    repeating-linear-gradient(
      -12deg,
      transparent,
      transparent 2px,
      rgba(255, 255, 255, 0.02) 2px,
      rgba(255, 255, 255, 0.02) 4px
    );
}
.contact-inner {
  max-width: 1200px;
  margin: 0 auto;
  padding-left: 24px;
  padding-right: 24px;
}
.contact-header {
  text-align: center;
  margin-bottom: 3rem;
}
.contact-title {
  font-size: 2.25rem;
  font-weight: 800;
  color: #fff;
  margin: 0 0 0.75rem 0;
  letter-spacing: -0.02em;
}
.contact-title-line {
  width: 80px;
  height: 4px;
  background: linear-gradient(90deg, var(--black-accent), var(--sky-500), var(--sky-600));
  box-shadow: inset 0 1px 0 rgba(255,255,255,0.25);
  margin: 0 auto 1rem;
  border-radius: 2px;
}
.contact-subtitle {
  font-size: 1.125rem;
  color: #b0b0b0;
  max-width: 520px;
  margin: 0 auto;
  line-height: 1.6;
}
.contact-content {
  display: grid;
  grid-template-columns: 1fr 1fr;
  gap: 4rem;
  align-items: start;
}
.contact-info {
  display: flex;
  flex-direction: column;
  gap: 1.5rem;
}
.contact-item {
  display: flex;
  align-items: flex-start;
  gap: 1.25rem;
  padding: 2.5rem;
  background: linear-gradient(145deg, rgba(40, 40, 45, 0.95) 0%, rgba(30, 30, 35, 0.98) 100%);
  border: 1px solid rgba(14, 165, 233, 0.2);
  border-radius: 12px;
  box-shadow: inset 0 1px 0 rgba(255, 255, 255, 0.04), 0 8px 24px rgba(0, 0, 0, 0.25);
  transition: transform 0.25s ease, box-shadow 0.25s ease;
  position: relative;
  overflow: hidden;
}
.contact-item::before {
  content: '';
  position: absolute;
  left: 0;
  top: 0;
  bottom: 0;
  width: 4px;
  background: linear-gradient(180deg, var(--sky-500), var(--sky-600));
  transform: scaleY(0);
  transform-origin: center top;
  transition: transform 0.25s ease;
  border-radius: 0 4px 4px 0;
}
.contact-item:hover {
  transform: translateX(12px);
  box-shadow: inset 0 1px 0 rgba(255, 255, 255, 0.06), 0 12px 32px rgba(0, 0, 0, 0.3);
}
.contact-item:hover::before {
  transform: scaleY(1);
}
.contact-item::after {
  content: '';
  position: absolute;
  top: 0;
  left: -100%;
  width: 100%;
  height: 100%;
  background: linear-gradient(90deg, transparent, rgba(255, 255, 255, 0.04), transparent);
  transition: left 0.4s ease;
}
.contact-item:hover::after {
  left: 100%;
}
.contact-icon-wrap {
  flex-shrink: 0;
  width: 52px;
  height: 52px;
  display: flex;
  align-items: center;
  justify-content: center;
  background: linear-gradient(145deg, var(--sky-500) 0%, var(--sky-600) 50%, var(--sky-800) 100%);
  border-radius: 10px;
  border: 1px solid rgba(255,255,255,0.2);
  box-shadow: inset 0 1px 0 rgba(255, 255, 255, 0.35), 0 4px 14px rgba(0,0,0,0.25);
  transition: transform 0.25s ease, box-shadow 0.25s ease;
}
.contact-item:hover .contact-icon-wrap {
  box-shadow: inset 0 1px 0 rgba(255, 255, 255, 0.4), 0 6px 20px rgba(0,0,0,0.3);
}
.contact-icon {
  color: #fff !important;
}
.contact-details-heading {
  font-size: 1rem;
  font-weight: 700;
  color: #fff;
  margin: 0 0 0.35rem 0;
}
.contact-details-text {
  font-size: 0.9375rem;
  color: #b0b0b0;
  margin: 0;
  line-height: 1.5;
}
.contact-details-text a {
  color: var(--sky-300);
  text-decoration: none;
  transition: color 0.2s ease;
}
.contact-details-text a:hover {
  color: var(--sky-200);
}
.contact-map {
  border-radius: 8px;
  overflow: hidden;
  box-shadow: 0 12px 40px rgba(0, 0, 0, 0.35);
  border: 1px solid rgba(255, 255, 255, 0.06);
  min-height: 300px;
}
.contact-map-iframe {
  width: 100%;
  height: 300px;
  border: none;
  display: block;
}
@media (max-width: 768px) {
  .contact-content {
    grid-template-columns: 1fr;
  }
  .contact-section {
    padding: 60px 0;
  }
}

/* Footer – full width */
.footer-section {
  color: rgba(255, 255, 255, 0.95);
  position: relative;
  overflow: hidden;
  width: 100%;
  padding: 3rem 0 1.5rem;
  background: linear-gradient(180deg, #0f172a 0%, #020617 70%, var(--black-accent) 100%);
  box-shadow: inset 0 1px 0 rgba(255,255,255,0.04);
}
.footer-cta-band {
  width: 100%;
  background: linear-gradient(90deg, #0b1220, #111827, #0b1220);
  border-top: 1px solid rgba(148, 163, 184, 0.2);
  border-bottom: 1px solid rgba(148, 163, 184, 0.2);
  padding: 2.5rem 0;
}
.footer-cta-inner {
  display: flex;
  align-items: center;
  justify-content: space-between;
  gap: 2rem;
  max-width: 1100px;
  margin: 0 auto;
}
.footer-cta-content {
  color: #fff;
}
.footer-cta-badge {
  display: inline-block;
  font-size: 0.75rem;
  letter-spacing: 0.12em;
  text-transform: uppercase;
  font-weight: 700;
  color: #e2e8f0;
  margin-bottom: 0.75rem;
}
.footer-cta-title {
  font-size: clamp(1.5rem, 3vw, 2rem);
  margin: 0 0 0.5rem 0;
  font-weight: 800;
  letter-spacing: -0.02em;
}
.footer-cta-subtitle {
  margin: 0;
  color: rgba(226, 232, 240, 0.8);
  max-width: 520px;
}
.footer-cta-btn {
  min-width: 180px;
}
@media (max-width: 900px) {
  .footer-cta-inner {
    flex-direction: column;
    text-align: center;
  }
}

.footer-section::before {
  content: '';
  position: absolute;
  top: 0;
  left: 0;
  right: 0;
  height: 3px;
  background: linear-gradient(90deg, var(--black-accent), var(--primary-cyan), var(--sky-500), var(--black-accent));
  box-shadow: inset 0 1px 0 rgba(255,255,255,0.2);
  opacity: 1;
}

.footer-container {
  position: relative;
  z-index: 1;
  max-width: none !important;
  width: 100% !important;
  padding-left: 2rem !important;
  padding-right: 2rem !important;
}

@media (min-width: 1280px) {
  .footer-container {
    padding-left: 3rem !important;
    padding-right: 3rem !important;
  }
}

.footer-top {
  display: grid;
  grid-template-columns: 1fr minmax(320px, 480px);
  gap: 3rem;
  margin-bottom: 2.5rem;
  padding-bottom: 2rem;
  border-bottom: 1px solid rgba(255, 255, 255, 0.12);
}

@media (max-width: 960px) {
  .footer-top {
    grid-template-columns: 1fr;
  }

  .footer-map-wrap {
    order: -1;
  }
}

.footer-brand-block {
  max-width: 480px;
}

.footer-brand {
  display: inline-flex;
  align-items: center;
  text-decoration: none;
  color: white;
  margin-bottom: 0.75rem;
}

.footer-logo-img {
  height: 56px;
  width: auto;
  max-width: 180px;
  object-fit: contain;
  filter: brightness(0) invert(1);
}

.footer-brand-text {
  font-size: 1.375rem;
  font-weight: 700;
  letter-spacing: 0.02em;
}

.footer-tagline {
  font-size: 0.9375rem;
  line-height: 1.5;
  color: rgba(255, 255, 255, 0.8);
  margin: 0 0 1.25rem 0;
}

.footer-contact-block {
  margin-bottom: 1rem;
}

.footer-contact-row {
  display: flex;
  align-items: center;
  gap: 0.5rem;
  font-size: 0.875rem;
  color: rgba(255, 255, 255, 0.9);
  margin-bottom: 0.4rem;
}

.footer-contact-icon {
  color: #7dd3fc;
  flex-shrink: 0;
}

.footer-contact-row a {
  color: #bae6fd;
  text-decoration: none;
  transition: color 0.2s ease;
}

.footer-contact-row a:hover {
  color: white;
}

.footer-social {
  display: flex;
  gap: 0.5rem;
}

.footer-social-btn {
  color: white !important;
  background: rgba(255, 255, 255, 0.1) !important;
  transition: all 0.3s ease !important;
}

.footer-social-btn:hover {
  background: rgba(255, 255, 255, 0.2) !important;
  transform: translateY(-2px);
}

.footer-map-wrap {
  border-radius: 12px;
  overflow: hidden;
  box-shadow: 0 8px 32px rgba(0, 0, 0, 0.3);
  border: 2px solid rgba(255, 255, 255, 0.15);
  width: 100%;
  aspect-ratio: 16 / 9;
  min-height: 200px;
}

.footer-map {
  width: 100%;
  height: 100%;
  border: none;
  display: block;
}

.footer-links-col {
  padding-bottom: 1rem;
}

.footer-links-row {
  margin-bottom: 2rem;
}

.footer-heading {
  font-size: 0.8125rem;
  font-weight: 700;
  text-transform: uppercase;
  letter-spacing: 0.08em;
  color: rgba(255, 255, 255, 0.95);
  margin: 0 0 1rem 0;
}

.footer-link-list {
  list-style: none;
  padding: 0;
  margin: 0;
}

.footer-link-list li {
  margin-bottom: 0.4rem;
}

.footer-link-list a {
  font-size: 0.875rem;
  color: rgba(255, 255, 255, 0.75);
  text-decoration: none;
  transition: color 0.2s ease;
}

.footer-link-list a:hover,
.footer-link-list .footer-link:hover {
  color: white;
}
.footer-link-list .footer-link {
  font-size: 0.875rem;
  color: rgba(255, 255, 255, 0.75);
  text-decoration: none;
  transition: color 0.2s ease;
}

.footer-newsletter-col .footer-heading {
  margin-bottom: 0.25rem;
}

.footer-newsletter-desc {
  font-size: 0.875rem;
  color: rgba(255, 255, 255, 0.8);
  margin: 0 0 0.75rem 0;
}

.footer-newsletter-form {
  display: flex;
  flex-wrap: wrap;
  gap: 0.5rem;
  align-items: stretch;
  background: rgba(255, 255, 255, 0.06);
  padding: 0.75rem;
  border-radius: 14px;
  border: 1px solid rgba(148, 163, 184, 0.25);
}

@media (max-width: 400px) {
  .footer-newsletter-form {
    flex-direction: column;
  }

  .footer-newsletter-btn {
    width: 100%;
  }
}

.footer-newsletter-input {
  flex: 1;
  min-width: 0;
}

.footer-newsletter-input :deep(.v-field) {
  background: rgba(255, 255, 255, 0.1) !important;
  color: #fff !important;
}

.footer-newsletter-input :deep(.v-field__outline) {
  --v-field-border-opacity: 0.3;
}

.footer-newsletter-btn {
  flex-shrink: 0;
}

.footer-divider {
  border-color: rgba(255, 255, 255, 0.15) !important;
  margin: 0 0 1.5rem 0;
}

.footer-bottom {
  display: flex;
  flex-wrap: wrap;
  justify-content: space-between;
  align-items: center;
  gap: 1rem;
}

.footer-copyright {
  font-size: 0.8125rem;
  color: rgba(255, 255, 255, 0.7);
  margin: 0;
}

.footer-badges {
  display: flex;
  flex-wrap: wrap;
  gap: 1rem;
  align-items: center;
}

.footer-badge {
  display: inline-flex;
  align-items: center;
  gap: 0.35rem;
  font-size: 0.75rem;
  color: rgba(255, 255, 255, 0.75);
}

.footer-badge .v-icon {
  color: #7dd3fc;
}

/* Floating Stats */
.floating-stat {
  position: absolute;
  background: white;
  padding: 1rem 1.25rem;
  border-radius: 16px;
  box-shadow: 0 8px 32px rgba(14, 165, 233, 0.15);
  border: 1px solid rgba(14, 165, 233, 0.1);
  display: flex;
  align-items: center;
  gap: 0.75rem;
  z-index: 10;
  animation: float 4s ease-in-out infinite;
}

.floating-stat-1 {
  top: 10%;
  right: -8%;
  animation-delay: 0s;
}

.floating-stat-2 {
  bottom: 20%;
  left: -5%;
  animation-delay: 2s;
}

@keyframes float {
  0%, 100% { transform: translateY(0); }
  50% { transform: translateY(-12px); }
}

.floating-stat-content {
  display: flex;
  flex-direction: column;
}

.floating-stat-value {
  font-size: 1.25rem;
  font-weight: 700;
  color: #0369a1;
  line-height: 1.2;
}

.floating-stat-label {
  font-size: 0.75rem;
  color: var(--text-secondary);
}

/* FAQ Section */
.faq-section {
  padding: 5rem 0;
}

.faq-header {
  max-width: 640px;
  margin: 0 auto 3rem;
}

.faq-badge {
  display: inline-block;
  font-size: 0.8125rem;
  font-weight: 600;
  letter-spacing: 0.06em;
  text-transform: uppercase;
  color: var(--sky-600);
  margin-bottom: 1rem;
}

.faq-title {
  font-size: clamp(1.875rem, 3.5vw, 2.75rem);
  font-weight: 800;
  letter-spacing: -0.02em;
  color: #111;
  margin: 0 0 0.75rem 0;
  line-height: 1.2;
}

.faq-subtitle {
  font-size: 1.125rem;
  color: #374151;
  margin: 0;
}

.faq-grid {
  margin: 0 auto;
}

.faq-panels {
  gap: 1rem;
}

.faq-panel {
  background: white !important;
  border: 1px solid rgba(14, 165, 233, 0.15) !important;
  border-radius: 16px !important;
  margin-bottom: 1rem;
  overflow: hidden;
  box-shadow: 0 2px 8px rgba(14, 165, 233, 0.04);
  transition: all 0.3s ease;
}

.faq-panel:hover {
  border-color: rgba(14, 165, 233, 0.3) !important;
  box-shadow: 0 4px 16px rgba(14, 165, 233, 0.08);
}

.faq-question {
  font-weight: 600 !important;
  color: var(--text-primary) !important;
  padding: 1.25rem 1.5rem !important;
}

.faq-icon {
  color: var(--sky-500);
  margin-right: 0.75rem;
}

.faq-answer {
  color: var(--text-secondary);
  line-height: 1.7;
  padding: 0 1.5rem 1.25rem !important;
}

/* Testimonial Location & Result */
.testimonial-location {
  display: inline-flex;
  align-items: center;
  gap: 0.25rem;
  font-size: 0.75rem;
  color: var(--text-secondary);
  margin-top: 0.25rem;
}

.testimonial-location .v-icon {
  color: var(--sky-500);
}

/* Pricing Plan Name */
.pricing-plan-name {
  font-size: 1.25rem;
  font-weight: 700;
  color: var(--text-primary);
  margin-bottom: 0.25rem;
}

.pricing-sub {
  font-size: 0.9375rem;
  color: var(--text-secondary);
  margin: 0;
  line-height: 1.5;
}

/* Pricing Guarantee */
.pricing-guarantee {
  display: flex;
  align-items: center;
  justify-content: center;
  gap: 0.75rem;
  margin-top: 3rem;
  padding: 1.25rem 2rem;
  background: rgba(16, 185, 129, 0.08);
  border: 1px solid rgba(16, 185, 129, 0.2);
  border-radius: 16px;
  max-width: 600px;
  margin-left: auto;
  margin-right: auto;
}

.pricing-guarantee .v-icon {
  color: #059669;
}

.pricing-guarantee-text {
  font-size: 0.9375rem;
  font-weight: 500;
  color: #059669;
}

/* Back to Top Button */
.back-to-top {
  position: fixed;
  bottom: 32px;
  right: 32px;
  z-index: 1000;
  animation: fadeInUp 0.3s ease-out;
}

.back-to-top:hover {
  transform: translateY(-4px) scale(1.1);
}

/* Responsive */
@media (max-width: 960px) {
  .hero-content {
    padding-right: 0;
    text-align: center;
  }

  .hero-title-accent {
    margin-left: auto;
    margin-right: auto;
  }

  .hero-subtitle {
    margin-left: auto;
    margin-right: auto;
  }

  .trust-row {
    justify-content: center;
  }

  .hero-visual .animate-fade-in {
    margin-left: auto;
    margin-right: auto;
  }

  .hero-title {
    font-size: 2.5rem;
  }

  .hero-subtitle {
    font-size: 1.125rem;
  }

  .pricing-card-popular {
    transform: scale(1);
  }

  .pricing-card-popular:hover {
    transform: translateY(-8px);
  }

  .floating-stat {
    display: none;
  }
  
  .testimonials-grid {
    grid-template-columns: repeat(2, 1fr);
  }

}

@media (max-width: 600px) {
  .hero-title {
    font-size: 2rem;
  }

  .features-title,
  .testimonials-title,
  .pricing-title {
    font-size: 1.75rem;
  }

  .price {
    font-size: 2.75rem;
  }
}

/* Section Dividers – subtle navy */
.section-divider-wrap {
  width: 100%;
  margin: 3rem 0;
  padding: 0;
  display: flex;
  flex-direction: column;
  gap: 0.25rem;
}

.section-divider-thick {
  height: 2px;
  width: 100%;
  max-width: 120px;
  margin: 0 auto;
  background: linear-gradient(90deg, transparent, rgba(15, 23, 42, 0.15), transparent);
  border-radius: 2px;
}

.section-divider-thin {
  height: 1px;
  width: 100%;
  max-width: 80px;
  margin: 0 auto;
  background: rgba(15, 23, 42, 0.08);
}

.section-divider {
  border-color: rgba(10, 12, 15, 0.12) !important;
  border-width: 1px !important;
  box-shadow: 0 1px 0 rgba(255,255,255,0.04);
}

/* Smooth Scrolling */
html {
  scroll-behavior: smooth;
}

/* Custom Scrollbar */
::-webkit-scrollbar {
  width: 10px;
}

::-webkit-scrollbar-track {
  background: #EFF6FF;
}

::-webkit-scrollbar-thumb {
  background: linear-gradient(180deg, #3B82F6 0%, #60A5FA 100%);
  border-radius: 5px;
}

::-webkit-scrollbar-thumb:hover {
  background: linear-gradient(180deg, #2563EB 0%, #3B82F6 100%);
}

.landing-page {
  --ph-blue: #0038a8;
  --ph-red: #ce1126;
  --ph-gold: #fcd116;
}
</style>

