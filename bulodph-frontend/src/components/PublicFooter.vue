<template>
  <div>
    <!-- Footer CTA band -->
    <section class="footer-cta-band">
      <div class="footer-cta-inner">
        <div class="footer-cta-content">
          <span class="footer-cta-badge">Ready to book?</span>
          <h3 class="footer-cta-title">Secure your ride in minutes.</h3>
          <p class="footer-cta-subtitle">
            Book with confidence—escrow, verified partners, and support when you need it.
          </p>
        </div>
        <v-btn
          color="action"
          size="large"
          class="footer-cta-btn plate-btn"
          elevation="0"
          rounded="pill"
          @click="$router.push('/register')"
        >
          Get Started
        </v-btn>
      </div>
    </section>

    <!-- Footer main -->
    <footer class="footer-section" id="footer">
      <div class="footer-inner">
        <!-- Top: brand + contact + map -->
        <div class="footer-top">
          <div class="footer-brand-block">
            <router-link :to="ROUTES.home" class="footer-brand">
              <img src="/logo.png" alt="BulodPH" class="footer-logo-img" />
            </router-link>
            <p class="footer-tagline">
              Car rentals across the region. Find a ride or list your fleet.
            </p>
            <div class="footer-contact-block">
              <div class="footer-contact-row">
                <MapPin :size="18" class="footer-contact-icon" aria-hidden="true" />
                <span>{{ CONTACT.locationShort }}</span>
              </div>
              <div class="footer-contact-row">
                <Phone :size="18" class="footer-contact-icon" aria-hidden="true" />
                <a :href="CONTACT.phoneHref">{{ CONTACT.phone }}</a>
              </div>
              <div class="footer-contact-row">
                <Mail :size="18" class="footer-contact-icon" aria-hidden="true" />
                <a :href="CONTACT.emailHref">{{ CONTACT.email }}</a>
              </div>
            </div>
            <div class="footer-social">
              <a class="footer-social-btn" :href="SOCIAL.facebook" target="_blank" rel="noopener noreferrer" aria-label="Facebook">
                <v-icon icon="mdi-facebook" size="20" />
              </a>
              <a class="footer-social-btn" :href="SOCIAL.instagram" target="_blank" rel="noopener noreferrer" aria-label="Instagram">
                <v-icon icon="mdi-instagram" size="20" />
              </a>
              <a class="footer-social-btn" :href="SOCIAL.twitter" target="_blank" rel="noopener noreferrer" aria-label="Twitter">
                <v-icon icon="mdi-twitter" size="20" />
              </a>
            </div>
          </div>

          <div class="footer-map-wrap">
            <img
              :src="FOOTER_SHOWCASE_IMAGE"
              :srcset="`${FOOTER_SHOWCASE_IMAGE} 1x, ${FOOTER_SHOWCASE_IMAGE_2X} 2x`"
              alt="BulodPH – Dashboard on laptop and phone"
              class="footer-showcase-img"
              width="826"
              height="806"
              loading="lazy"
            />
          </div>
        </div>

        <!-- Links grid: full width -->
        <div class="footer-links-grid">
          <div class="footer-links-col">
            <h4 class="footer-heading">Product</h4>
            <ul class="footer-link-list">
              <li><router-link :to="ROUTES.fleet">Featured Rides</router-link></li>
              <li><router-link :to="ROUTES.register">Rent or List</router-link></li>
            </ul>
          </div>
          <div class="footer-links-col">
            <h4 class="footer-heading">For You</h4>
            <ul class="footer-link-list">
              <li><router-link :to="ROUTES.fleet">Find a Ride</router-link></li>
              <li><router-link :to="ROUTES.register">List Your Fleet</router-link></li>
            </ul>
          </div>
          <div class="footer-links-col">
            <h4 class="footer-heading">Resources</h4>
            <ul class="footer-link-list">
              <li><router-link :to="ROUTES.faq">Help Centre</router-link></li>
              <li><router-link :to="ROUTES.faq">FAQ</router-link></li>
              <li><router-link :to="ROUTES.contact">Contact</router-link></li>
            </ul>
          </div>
          <div class="footer-links-col">
            <h4 class="footer-heading">Company</h4>
            <ul class="footer-link-list">
              <li><router-link :to="ROUTES.about">About BulodPH</router-link></li>
              <li><router-link :to="ROUTES.blog">Blog</router-link></li>
            </ul>
          </div>
          <div class="footer-links-col">
            <h4 class="footer-heading">Legal</h4>
            <ul class="footer-link-list">
              <li><router-link :to="ROUTES.privacy">Privacy Policy</router-link></li>
              <li><router-link :to="ROUTES.terms">Terms of Service</router-link></li>
              <li><router-link :to="ROUTES.accessibility">Accessibility</router-link></li>
            </ul>
          </div>
          <div class="footer-links-col footer-newsletter-col">
            <h4 class="footer-heading">Stay updated</h4>
            <p class="footer-newsletter-desc">New cities, new rides, and BulodPH news.</p>
            <div class="footer-newsletter-form">
              <v-text-field
                density="compact"
                variant="outlined"
                placeholder="Your email"
                hide-details
                class="footer-newsletter-input"
                bg-color="rgba(255,255,255,0.06)"
              />
              <v-btn color="action" variant="flat" size="small" class="footer-newsletter-btn">
                Subscribe
              </v-btn>
            </div>
          </div>
        </div>

        <div class="footer-divider" />

        <div class="footer-disclaimer-strip">
          <p class="footer-disclaimer-strip-inner">{{ platformDisclaimerShort }}</p>
        </div>

        <div class="footer-bottom">
          <p class="footer-disclaimer">BulodPH is a platform only. We are not liable for vehicle theft, damage, loss, or disputes. See <router-link :to="ROUTES.terms">Terms of Service</router-link>.</p>
          <p class="footer-copyright">© 2026 BulodPH. Car rentals across the region. All rights reserved.</p>
          <div class="footer-badges">
            <span class="footer-badge"><v-icon icon="mdi-shield-check-outline" size="14" /> Verified by BulodPH</span>
            <span class="footer-badge"><v-icon icon="mdi-lock-outline" size="14" /> Secure Payments</span>
            <span class="footer-badge"><v-icon icon="mdi-flag-outline" size="14" /> Community-First</span>
          </div>
        </div>
      </div>

      <!-- Back to Top Button -->
      <v-btn
        v-show="showBackToTop"
        class="back-to-top"
        color="action"
        icon
        size="small"
        elevation="6"
        @click="scrollToTop"
      >
        <v-icon icon="mdi-chevron-up" size="24" />
      </v-btn>
    </footer>
  </div>
</template>

<script setup lang="ts">
import { ref, onMounted, onUnmounted } from 'vue'
import { MapPin, Phone, Mail } from 'lucide-vue-next'
import { ROUTES, CONTACT, SOCIAL, FOOTER_SHOWCASE_IMAGE, FOOTER_SHOWCASE_IMAGE_2X } from '@/constants/siteUrls'
import { PLATFORM_DISCLAIMER_SHORT } from '@/constants/platformAgreement'

const platformDisclaimerShort = PLATFORM_DISCLAIMER_SHORT

const showBackToTop = ref(false)

const handleScroll = () => {
  showBackToTop.value = window.scrollY > 500
}

const scrollToTop = () => {
  window.scrollTo({ top: 0, behavior: 'smooth' })
}

onMounted(() => {
  window.addEventListener('scroll', handleScroll, { passive: true })
})

onUnmounted(() => {
  window.removeEventListener('scroll', handleScroll)
})
</script>

<style scoped>
/* —— Footer CTA band: clean gradient, no external image —— */
.footer-cta-band {
  position: relative;
  padding: 56px 20px 64px;
  overflow: hidden;
  display: flex;
  align-items: center;
  justify-content: center;
  background: linear-gradient(160deg, var(--navy-dark, #020617) 0%, var(--trust-blue, #0f172a) 40%, #1e3a5f 100%);
  border-bottom: 1px solid rgba(96, 165, 250, 0.18);
}

.footer-cta-band::before {
  content: '';
  position: absolute;
  inset: 0;
  background-image: linear-gradient(90deg, transparent 0%, rgba(96, 165, 250, 0.03) 50%, transparent 100%);
  background-size: 120px 100%;
  pointer-events: none;
  z-index: 1;
}

.footer-cta-inner {
  display: flex;
  flex-direction: column;
  align-items: center;
  text-align: center;
  gap: 28px;
  width: 100%;
  max-width: 100%;
  position: relative;
  z-index: 2;
  padding: 0 clamp(24px, 6vw, 80px);
  margin: 0 auto;
  box-sizing: border-box;
}

@media (min-width: 960px) {
  .footer-cta-band {
    padding: 72px 0 80px;
  }
  .footer-cta-inner {
    flex-direction: row;
    justify-content: space-between;
    text-align: left;
    gap: 48px;
  }
}

.footer-cta-content {
  flex: 1;
}

.footer-cta-badge {
  display: inline-block;
  font-weight: 600;
  letter-spacing: 0.12em;
  font-size: 0.7rem;
  text-transform: uppercase;
  color: var(--primary-cyan, #60a5fa);
  background: rgba(96, 165, 250, 0.12);
  padding: 0.4rem 1rem;
  border-radius: 999px;
  margin-bottom: 14px;
  border: 1px solid rgba(96, 165, 250, 0.25);
}

.footer-cta-title {
  color: #fff;
  font-size: clamp(1.75rem, 3.5vw, 2.5rem);
  font-weight: 700;
  line-height: 1.15;
  margin-bottom: 10px;
  letter-spacing: -0.02em;
}

.footer-cta-subtitle {
  color: rgba(255, 255, 255, 0.82);
  font-size: 1rem;
  max-width: 480px;
  line-height: 1.55;
}

.footer-cta-btn {
  padding: 0 36px !important;
  font-weight: 600;
  letter-spacing: 0.02em;
  background: linear-gradient(135deg, var(--primary-cyan) 0%, var(--sky-600, #1e40af) 100%) !important;
  color: #fff !important;
  box-shadow: var(--shadow-md), 0 0 0 1px rgba(255,255,255,0.1) !important;
  transition: transform var(--transition-base), box-shadow var(--transition-base) !important;
}

.footer-cta-btn:hover {
  transform: translateY(-2px);
  box-shadow: var(--shadow-lg), 0 0 0 1px rgba(255,255,255,0.15) !important;
}

/* —— Main footer: navy base + subtle pattern —— */
.footer-section {
  background: var(--trust-blue, #0f172a);
  color: #f8fafc;
  padding: 0;
  position: relative;
  overflow: hidden;
}

.footer-section::before {
  content: '';
  position: absolute;
  inset: 0;
  background-image: radial-gradient(circle at 1px 1px, rgba(255, 255, 255, 0.06) 1px, transparent 0);
  background-size: 20px 20px;
  pointer-events: none;
  z-index: 0;
}

.footer-section .footer-inner {
  position: relative;
  z-index: 1;
}

.footer-inner {
  width: 100%;
  max-width: 100%;
  margin: 0 auto;
  padding: clamp(40px, 6vw, 72px) clamp(24px, 6vw, 80px) 0;
  box-sizing: border-box;
}

.footer-top {
  display: grid;
  grid-template-columns: 1fr;
  gap: 44px;
  margin-bottom: 52px;
  align-items: start;
}

@media (min-width: 960px) {
  .footer-top {
    grid-template-columns: minmax(280px, 1fr) minmax(320px, 440px);
    justify-content: space-between;
    gap: 56px;
  }
}

.footer-brand-block {
  display: flex;
  flex-direction: column;
  gap: 22px;
  max-width: 400px;
}

.footer-brand {
  text-decoration: none;
  display: inline-flex;
  align-items: center;
  justify-content: center;
  width: fit-content;
  max-width: 100%;
  transition: opacity var(--transition-fast), transform var(--transition-fast);
  background: #fff;
  padding: 6px 10px;
  border-radius: var(--radius-md, 12px);
  box-sizing: border-box;
  box-shadow: var(--shadow-sm);
}

.footer-brand:hover {
  opacity: 0.95;
  transform: translateY(-1px);
}

.footer-logo-img {
  height: 28px;
  width: auto;
  max-width: 100px;
  object-fit: contain;
  display: block;
  vertical-align: middle;
}

.footer-tagline {
  color: rgba(255, 255, 255, 0.72);
  line-height: 1.6;
  font-size: 0.9375rem;
  font-weight: 400;
  letter-spacing: 0.01em;
}

.footer-contact-block {
  display: flex;
  flex-direction: column;
  gap: 12px;
}

.footer-contact-row {
  display: flex;
  align-items: center;
  gap: 12px;
  color: rgba(255, 255, 255, 0.9);
  font-size: 0.9375rem;
}

.footer-contact-row a {
  color: inherit;
  text-decoration: none;
  transition: color var(--transition-fast);
}

.footer-contact-row a:hover {
  color: var(--primary-cyan, #60a5fa);
}

.footer-contact-icon {
  color: var(--primary-cyan, #60a5fa);
  flex-shrink: 0;
  opacity: 0.95;
}

.footer-social {
  display: flex;
  gap: 10px;
  margin-top: 2px;
}

.footer-social-btn {
  display: inline-flex;
  align-items: center;
  justify-content: center;
  width: 42px;
  height: 42px;
  border-radius: 50%;
  color: rgba(255, 255, 255, 0.75);
  background: rgba(255, 255, 255, 0.07);
  border: 1px solid rgba(255, 255, 255, 0.08);
  transition: color var(--transition-base), background var(--transition-base), transform var(--transition-base);
  text-decoration: none;
}

.footer-social-btn:hover {
  color: #fff;
  background: rgba(96, 165, 250, 0.2);
  border-color: rgba(96, 165, 250, 0.3);
  transform: translateY(-2px);
}

.footer-map-wrap {
  position: relative;
  border-radius: var(--radius-lg, 16px);
  overflow: hidden;
  box-shadow: var(--shadow-lg), 0 0 0 1px rgba(255, 255, 255, 0.08);
  width: 100%;
  aspect-ratio: 826 / 806;
  max-height: 200px;
  min-height: 100px;
  background: var(--surface-2, #f1f5f9);
}

@media (min-width: 960px) {
  .footer-map-wrap {
    max-width: 260px;
    max-height: 260px;
    justify-self: end;
  }
}

.footer-showcase-img {
  position: absolute;
  inset: 0;
  width: 100%;
  height: 100%;
  object-fit: contain;
  object-position: center;
  display: block;
  image-rendering: -webkit-optimize-contrast;
  image-rendering: crisp-edges;
}

/* —— Links grid —— */
.footer-links-grid {
  display: grid;
  grid-template-columns: repeat(2, 1fr);
  gap: 28px 20px;
  margin-bottom: 44px;
}

@media (min-width: 600px) {
  .footer-links-grid {
    grid-template-columns: repeat(3, 1fr);
  }
}

@media (min-width: 960px) {
  .footer-links-grid {
    grid-template-columns: repeat(6, 1fr);
    gap: 24px 20px;
    margin-bottom: 40px;
  }
}

.footer-links-col {
  min-width: 0;
}

.footer-heading {
  color: #fff;
  font-weight: 600;
  font-size: 0.75rem;
  letter-spacing: 0.1em;
  text-transform: uppercase;
  margin: 0 0 14px 0;
  padding-bottom: 6px;
  border-bottom: 1px solid rgba(255, 255, 255, 0.1);
  display: inline-block;
}

.footer-link-list {
  list-style: none;
  padding: 0;
  margin: 0;
  display: flex;
  flex-direction: column;
  gap: 8px;
}

.footer-link-list a {
  color: rgba(255, 255, 255, 0.62);
  text-decoration: none;
  font-size: 0.9rem;
  transition: color var(--transition-fast);
  display: inline-block;
}

.footer-link-list a:hover {
  color: var(--primary-cyan, #60a5fa);
}

.footer-newsletter-col {
  grid-column: 1 / -1;
}

@media (min-width: 960px) {
  .footer-newsletter-col {
    grid-column: span 1;
  }
}

.footer-newsletter-desc {
  color: rgba(255, 255, 255, 0.62);
  font-size: 0.875rem;
  margin: 0 0 14px 0;
  line-height: 1.5;
}

.footer-newsletter-form {
  display: flex;
  flex-direction: column;
  gap: 10px;
}

@media (min-width: 400px) {
  .footer-newsletter-form {
    flex-direction: row;
    max-width: 340px;
  }
}

.footer-newsletter-input :deep(.v-field__input) {
  color: #fff !important;
}

.footer-newsletter-input :deep(.v-field__outline__start),
.footer-newsletter-input :deep(.v-field__outline__end) {
  border-color: rgba(255, 255, 255, 0.12) !important;
}

.footer-newsletter-btn {
  height: 40px !important;
  font-weight: 600;
  background: var(--primary-cyan, #60a5fa) !important;
  color: #fff !important;
  flex-shrink: 0;
  border-radius: var(--radius-sm, 8px) !important;
}

/* —— Disclaimer strip: full-width band —— */
.footer-disclaimer-strip {
  width: 100vw;
  position: relative;
  left: 50%;
  right: 50%;
  margin-left: -50vw;
  margin-right: -50vw;
  margin-bottom: 0;
  padding: 14px clamp(24px, 6vw, 80px);
  background: rgba(0, 0, 0, 0.2);
  border-top: 1px solid rgba(255, 255, 255, 0.08);
  border-bottom: 1px solid rgba(255, 255, 255, 0.04);
}

.footer-disclaimer-strip-inner {
  display: block;
  max-width: 900px;
  margin: 0 auto;
  color: rgba(255, 255, 255, 0.7);
  font-size: 0.8125rem;
  line-height: 1.5;
  text-align: center;
  letter-spacing: 0.02em;
}

/* —— Bottom bar: darker strip —— */
.footer-divider {
  height: 0;
  border: none;
  margin: 0;
}

.footer-bottom {
  display: flex;
  flex-direction: column;
  gap: 20px;
  align-items: center;
  text-align: center;
  padding: 24px clamp(24px, 6vw, 80px) 32px;
  margin: 0 calc(-1 * clamp(24px, 6vw, 80px));
  background: var(--navy-dark, #020617);
  border-top: 1px solid rgba(255, 255, 255, 0.06);
}

@media (min-width: 768px) {
  .footer-bottom {
    flex-direction: row;
    justify-content: space-between;
    text-align: left;
    padding: 20px clamp(24px, 6vw, 80px) 24px;
  }
}

.footer-disclaimer {
  color: rgba(255, 255, 255, 0.5);
  font-size: 0.75rem;
  margin: 0 0 4px;
  letter-spacing: 0.02em;
  max-width: 560px;
}

.footer-disclaimer a {
  color: rgba(255, 255, 255, 0.85);
  text-decoration: underline;
  text-underline-offset: 2px;
}

.footer-disclaimer a:hover {
  color: #fff;
}

.footer-copyright {
  color: rgba(255, 255, 255, 0.4);
  font-size: 0.8125rem;
  margin: 0;
  letter-spacing: 0.02em;
}

.footer-badges {
  display: flex;
  gap: 10px;
  flex-wrap: wrap;
  justify-content: center;
}

.footer-badge {
  display: inline-flex;
  align-items: center;
  gap: 6px;
  color: rgba(255, 255, 255, 0.5);
  font-size: 0.75rem;
  font-weight: 500;
  background: rgba(255, 255, 255, 0.05);
  padding: 8px 14px;
  border-radius: var(--radius-sm, 8px);
  border: 1px solid rgba(255, 255, 255, 0.06);
  letter-spacing: 0.02em;
  transition: color var(--transition-fast), background var(--transition-fast);
}

.footer-badge:hover {
  color: rgba(255, 255, 255, 0.7);
  background: rgba(255, 255, 255, 0.08);
}

.back-to-top {
  position: absolute;
  bottom: 28px;
  right: 28px;
  z-index: 10;
  background: rgba(255, 255, 255, 0.08) !important;
  backdrop-filter: blur(10px);
  border: 1px solid rgba(255, 255, 255, 0.12);
  color: #fff !important;
  border-radius: 50% !important;
  transition: transform var(--transition-base), box-shadow var(--transition-base);
}

.back-to-top:hover {
  background: var(--primary-cyan, #60a5fa) !important;
  transform: translateY(-3px);
  box-shadow: 0 6px 16px rgba(96, 165, 250, 0.35);
}

@media (max-width: 768px) {
  .back-to-top {
    bottom: 18px;
    right: 18px;
  }
}
</style>
