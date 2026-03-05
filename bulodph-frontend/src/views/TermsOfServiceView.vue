<template>
  <div ref="pageRef" class="legal-page">
    <v-container class="legal-container" max-width="800">
      <div class="legal-header">
        <h1 class="legal-title">Terms of Service</h1>
        <p class="legal-updated">Last updated: {{ lastUpdated }}</p>
        <router-link to="/" class="legal-back-link">
          <v-icon icon="mdi-arrow-left" size="18" />
          Back to home
        </router-link>
      </div>

      <div class="legal-content">
        <section class="legal-section scroll-reveal">
          <h2 class="legal-section-title">Acceptance of Terms</h2>
          <p class="legal-text">
            By accessing or using BulodPH, you agree to be bound by these Terms of Service. If you do 
            not agree, do not use our platform. Your use of the platform (including account creation, 
            checkbox acceptance where presented, or continued use after the effective date) constitutes 
            your acceptance. We may record such acceptance as evidence of agreement. We may update these 
            terms from time to time; continued use after changes constitutes acceptance of the updated terms.
          </p>
        </section>

        <section class="legal-section scroll-reveal">
          <h2 class="legal-section-title">Description of Service</h2>
          <p class="legal-text">
            BulodPH provides a car rental marketplace showcasing listings from rental partners 
            throughout the region and across the Philippines. We facilitate bookings, payments, and communications 
            but do not own the vehicles or employ the car owners. Use of the platform is at your own risk.
          </p>
        </section>

        <section class="legal-section scroll-reveal">
          <h2 class="legal-section-title">User Accounts</h2>
          <p class="legal-text">
            You must provide accurate information when creating an account and keep it up to date. 
            You are responsible for maintaining the confidentiality of your credentials and for all 
            activity under your account. You must be at least 18 years old to use our services.
          </p>
        </section>

        <section class="legal-section scroll-reveal">
          <h2 class="legal-section-title">Booking and Payments</h2>
          <p class="legal-text">
            Bookings are subject to availability and confirmation. You agree to pay all fees, including 
            rental charges, platform fees, and applicable taxes. Payments are processed via GCash, Maya, 
            or other supported methods. Refunds follow our cancellation policy.
          </p>
        </section>

        <section class="legal-section scroll-reveal">
          <h2 class="legal-section-title">Cancellations</h2>
          <p class="legal-text">
            Cancellation policies vary by booking. Renters and car owners must comply with the policy 
            applicable to their reservation. Late cancellations or no-shows may result in fees. Contact 
            support for dispute resolution.
          </p>
        </section>

        <section class="legal-section scroll-reveal">
          <h2 class="legal-section-title">Platform Role Only</h2>
          <p class="legal-text">
            BulodPH is a technology platform that connects vehicle owners or rental companies with renters. 
            We do not own, operate, insure, or take possession of any vehicle. We are not a rental company. 
            The actual rental or use of a vehicle is a contract between the vehicle owner (or rental company) 
            and the renter. BulodPH is not a party to that contract. Use of the platform and any vehicle 
            booked through it is at your own risk.
          </p>
        </section>

        <section class="legal-section scroll-reveal legal-section--highlight">
          <h2 class="legal-section-title">Limitation of Liability — No Liability for Theft, Damage, or Loss</h2>
          <p class="legal-text">
            <strong>To the fullest extent permitted by law, BulodPH, its officers, directors, employees, and 
            affiliates shall not be liable</strong> for any direct, indirect, incidental, special, consequential, 
            or punitive damages arising from or related to:
          </p>
          <ul class="legal-list">
            <li><strong>Vehicle theft</strong> — We are not liable for the theft of any vehicle listed or booked through the platform, whether before, during, or after a rental period.</li>
            <li><strong>Damage to vehicles</strong> — We are not liable for any damage to vehicles (including vandalism, accidents, or wear and tear) arising from use by renters or third parties.</li>
            <li><strong>Loss of property</strong> — We are not liable for loss or theft of personal property left in or related to a vehicle, or any property of the vehicle owner or renter.</li>
            <li><strong>Accidents and personal injury</strong> — We are not liable for any accidents, injuries, or fatalities involving vehicles or users of the platform.</li>
            <li><strong>Disputes between users</strong> — Disputes regarding the condition of a vehicle, handover, return, payment, or any other matter are solely between the vehicle owner (or rental company) and the renter. You must resolve such disputes directly or through your own insurance or legal remedies.</li>
          </ul>
          <p class="legal-text">
            Insurance (including comprehensive, collision, and third-party coverage) is the responsibility of 
            the vehicle owner and/or renter. BulodPH does not provide or guarantee any insurance. By using 
            the platform, you acknowledge and agree that BulodPH has no liability for the above and that you 
            use the service and any vehicle at your own risk.
          </p>
          <p class="legal-text">
            To the maximum extent permitted by applicable law, in no event shall BulodPH’s aggregate 
            liability to you for any claim arising out of or relating to these Terms or the platform 
            exceed the amount you paid to BulodPH in the twelve (12) months preceding the claim, or 
            one hundred Philippine pesos (PHP 100), whichever is greater.
          </p>
        </section>

        <section class="legal-section scroll-reveal">
          <h2 class="legal-section-title">Indemnification</h2>
          <p class="legal-text">
            You agree to indemnify, defend, and hold harmless BulodPH, its officers, directors, 
            employees, and affiliates from and against any and all claims, damages, losses, liabilities, 
            and expenses (including reasonable attorneys’ fees) arising out of or related to your use 
            of the platform, your breach of these Terms, or any dispute between you and another user 
            (including but not limited to claims related to vehicle theft, damage, loss, handover, 
            return, or payment). This obligation survives termination of your account or these Terms.
          </p>
        </section>

        <section class="legal-section scroll-reveal">
          <h2 class="legal-section-title">Dispute Resolution</h2>
          <p class="legal-text">
            We encourage users to resolve disputes directly. If you cannot reach an agreement, contact 
            our support team. Disputes may be escalated to mediation or arbitration in accordance 
            with Philippine law. Our decisions in platform disputes are final where permitted.
          </p>
        </section>

        <section class="legal-section scroll-reveal">
          <h2 class="legal-section-title">Governing Law and Jurisdiction</h2>
          <p class="legal-text">
            These Terms are governed by the laws of the Republic of the Philippines, without regard 
            to its conflict-of-law principles. Any dispute arising from these Terms or your use of the 
            platform shall be subject to the exclusive jurisdiction of the courts of the Philippines, 
            and you consent to the personal jurisdiction of such courts. Nothing in these Terms limits 
            either party’s right to seek injunctive or other equitable relief in any court of competent 
            jurisdiction.
          </p>
        </section>

        <section class="legal-section scroll-reveal">
          <h2 class="legal-section-title">Severability</h2>
          <p class="legal-text">
            If any provision of these Terms is held invalid or unenforceable by a court of competent 
            jurisdiction, the remaining provisions shall remain in full force and effect. The invalid or 
            unenforceable provision shall be modified to the minimum extent necessary to make it valid 
            and enforceable while preserving the parties’ intent, or if that is not possible, severed.
          </p>
        </section>

        <section class="legal-section scroll-reveal">
          <h2 class="legal-section-title">Changes</h2>
          <p class="legal-text">
            We may modify these terms, our policies, or the platform at any time. Material changes 
            will be communicated via email or in-app notice. Your continued use after the effective 
            date constitutes acceptance of the updated terms.
          </p>
        </section>

        <section class="legal-section scroll-reveal">
          <h2 class="legal-section-title">Contact</h2>
          <p class="legal-text">
            For questions about these Terms of Service, contact us at 
            <a href="mailto:support@bulodph.com" class="legal-inline-link">support@bulodph.com</a> 
            or through the contact form on our website.
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

const lastUpdated = 'March 1, 2026'
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

.legal-section--highlight {
  background: var(--surface-1, #f8fafc);
  border: 1px solid var(--border-subtle);
  border-radius: var(--radius-md);
  padding: var(--space-5);
  margin: 0;
}

.legal-list {
  font-size: var(--text-body);
  color: var(--text-secondary);
  line-height: var(--leading-relaxed);
  margin: var(--space-3) 0 var(--space-4);
  padding-left: var(--space-6);
}

.legal-list li {
  margin-bottom: var(--space-2);
}

.legal-list li:last-child {
  margin-bottom: 0;
}

@media (max-width: 599px) {
  .legal-container {
    padding: var(--space-6) var(--space-4);
  }
}
</style>
