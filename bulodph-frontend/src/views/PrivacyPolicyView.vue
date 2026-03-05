<template>
  <div ref="pageRef" class="legal-page">
    <v-container class="legal-container" max-width="800">
      <div class="legal-header">
        <h1 class="legal-title">Privacy Policy</h1>
        <p class="legal-updated">Last updated: {{ lastUpdated }}</p>
        <router-link to="/" class="legal-back-link">
          <v-icon icon="mdi-arrow-left" size="18" />
          Back to home
        </router-link>
      </div>

      <div class="legal-content">
        <section class="legal-section scroll-reveal">
          <h2 class="legal-section-title">Information We Collect</h2>
          <p class="legal-text">
            We collect information you provide directly, including name, email address, phone number, 
            payment details, and identification documents when you create an account, make a booking, 
            or list a vehicle. We also collect usage data such as IP address, device type, and browsing 
            activity to improve our services.
          </p>
        </section>

        <section class="legal-section scroll-reveal">
          <h2 class="legal-section-title">How We Use It</h2>
          <p class="legal-text">
            We use your information to process bookings, facilitate payments, verify identities, 
            communicate with you about your account and trips, send marketing with your consent, 
            improve our platform, prevent fraud, and comply with legal obligations.
          </p>
        </section>

        <section class="legal-section scroll-reveal">
          <h2 class="legal-section-title">Data Sharing</h2>
          <p class="legal-text">
            We may share your data with car owners and renters (as needed for bookings), payment 
            processors (GCash, Maya, banks), service providers who assist our operations, and 
            authorities when required by law. We do not sell your personal information to third parties.
          </p>
        </section>

        <section class="legal-section scroll-reveal">
          <h2 class="legal-section-title">Data Retention</h2>
          <p class="legal-text">
            We retain account, booking, and payment records only as long as necessary to provide our
            services, meet legal obligations, resolve disputes, and enforce our agreements. If you
            request deletion, we will remove or anonymize personal data unless retention is required
            by law or for legitimate business purposes (for example, fraud prevention or financial records).
          </p>
        </section>

        <section class="legal-section scroll-reveal">
          <h2 class="legal-section-title">Cookies</h2>
          <p class="legal-text">
            We use cookies and similar technologies to remember your preferences, keep you logged in, 
            analyze site traffic, and personalize content. You can control cookies through your browser 
            settings; some features may not work fully if you disable them.
          </p>
        </section>

        <section class="legal-section scroll-reveal">
          <h2 class="legal-section-title">Marketing Preferences</h2>
          <p class="legal-text">
            We send marketing or product updates only if you opt in. You can withdraw consent at any time
            by updating your preferences or using the unsubscribe links in our emails.
          </p>
        </section>

        <section class="legal-section scroll-reveal">
          <h2 class="legal-section-title">Security</h2>
          <p class="legal-text">
            We implement technical and organizational measures to protect your data, including 
            encryption, secure connections, and access controls. While we strive to safeguard your 
            information, no system is completely secure; use strong passwords and report any concerns.
          </p>
        </section>

        <section class="legal-section scroll-reveal">
          <h2 class="legal-section-title">Your Rights</h2>
          <p class="legal-text">
            Depending on your location, you may have the right to access, correct, delete, or port 
            your personal data, withdraw consent, object to processing, or lodge a complaint with a 
            supervisory authority. Contact us to exercise these rights.
          </p>
        </section>

        <section class="legal-section scroll-reveal">
          <h2 class="legal-section-title">Contact</h2>
          <p class="legal-text">
            For privacy-related questions or requests, contact us at 
            <a href="mailto:privacy@bulodph.com" class="legal-inline-link">privacy@bulodph.com</a> 
            or through the support channels on our website.
          </p>
        </section>
      </div>

      <div class="legal-footer-links">
        <router-link to="/" class="legal-link">Home</router-link>
        <span class="legal-sep">·</span>
        <router-link to="/login" class="legal-link">Login</router-link>
      </div>
    </v-container>
  </div>
</template>

<script setup lang="ts">
import { ref } from 'vue'
import { useGsapReveal } from '@/composables/useGsapReveal'

const lastUpdated = 'February 20, 2025'
const pageRef = ref<HTMLElement | null>(null)
useGsapReveal(pageRef, { selector: '.scroll-reveal', y: 24, duration: 0.5, stagger: 0.06, start: 'top 88%' })
</script>

<style scoped>
.legal-page {
  min-height: 100vh;
  background-color: var(--bg-light);
  padding: var(--space-8) var(--page-padding-x);
}

.legal-container {
  background: var(--surface-0);
  border-radius: var(--radius-lg);
  padding: var(--space-8) var(--space-10);
  box-shadow: var(--shadow-sm);
  border: 1px solid var(--border-subtle);
}

.legal-header {
  margin-bottom: var(--space-8);
  padding-bottom: var(--space-6);
  border-bottom: 1px solid var(--border-subtle);
}

.legal-title {
  font-size: var(--text-2xl);
  font-weight: 700;
  color: var(--text-primary);
  margin: 0 0 var(--space-2);
  letter-spacing: var(--tracking-tight);
}

.legal-updated {
  font-size: var(--text-sm);
  color: var(--text-secondary);
  margin: 0 0 var(--space-4);
}

.legal-back-link {
  display: inline-flex;
  align-items: center;
  gap: var(--space-2);
  font-size: var(--text-body-sm);
  font-weight: 600;
  color: var(--sky-600);
  text-decoration: none;
  transition: color var(--transition-fast);
}

.legal-back-link:hover {
  color: var(--sky-500);
}

.legal-content {
  display: flex;
  flex-direction: column;
  gap: var(--space-6);
}

.legal-section {
  margin: 0;
}

.legal-section-title {
  font-size: var(--text-lg);
  font-weight: 600;
  color: var(--text-primary);
  margin: 0 0 var(--space-3);
  letter-spacing: var(--tracking-tight);
}

.legal-text {
  font-size: var(--text-body);
  color: var(--text-secondary);
  line-height: var(--leading-relaxed);
  margin: 0;
}

.legal-inline-link {
  color: var(--sky-600);
  text-decoration: none;
  font-weight: 600;
}

.legal-inline-link:hover {
  text-decoration: underline;
}

.legal-footer-links {
  margin-top: var(--space-8);
  padding-top: var(--space-6);
  border-top: 1px solid var(--border-subtle);
  font-size: var(--text-body-sm);
  color: var(--text-muted);
}

.legal-link {
  color: var(--sky-600);
  text-decoration: none;
  font-weight: 600;
}

.legal-link:hover {
  text-decoration: underline;
}

.legal-sep {
  margin: 0 var(--space-2);
  color: var(--text-muted);
}

@media (max-width: 599px) {
  .legal-container {
    padding: var(--space-6) var(--space-4);
  }
}
</style>
