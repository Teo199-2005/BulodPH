<template>
  <div class="legal-page">
    <v-container class="legal-container" max-width="800">
      <div class="legal-header">
        <h1 class="legal-title">Accessibility Statement</h1>
        <p class="legal-updated">Last updated: February 22, 2026</p>
        <router-link to="/" class="legal-back-link">
          <v-icon icon="mdi-arrow-left" size="18" />
          Back to home
        </router-link>
      </div>

      <div class="legal-content">
        <section class="legal-section">
          <h2 class="legal-section-title">Our Commitment</h2>
          <p class="legal-text">
            BulodPH is committed to providing an accessible experience for all users, including people
            with disabilities. We aim to align with WCAG 2.1 AA standards where feasible.
          </p>
        </section>

        <section class="legal-section">
          <h2 class="legal-section-title">Accessibility Features</h2>
          <p class="legal-text">
            We work to maintain clear navigation, readable typography, and sufficient contrast. We also
            support keyboard navigation and screen reader compatibility where possible.
          </p>
        </section>

        <section class="legal-section">
          <h2 class="legal-section-title">Feedback</h2>
          <p class="legal-text">
            If you encounter any accessibility issues, please contact us at
            <a href="mailto:accessibility@bulodph.com" class="legal-inline-link">accessibility@bulodph.com</a>.
            We welcome feedback and will make reasonable efforts to improve.
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
</style>
