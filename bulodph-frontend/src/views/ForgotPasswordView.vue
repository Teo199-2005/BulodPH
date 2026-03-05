<template>
  <div class="auth-page">
    <!-- Form side -->
    <div class="auth-form-side auth-form-side-single">
      <div class="auth-form-bg" aria-hidden="true"></div>
      <div ref="authPanelRef" class="auth-panel">
        <div class="auth-form-card">
          <div class="auth-logo">
            <img
              v-if="logoSrc"
              src="/logo.png"
              alt="BulodPH"
              class="auth-logo-img"
              @error="logoSrc = false"
            />
            <span v-else class="auth-logo-fallback">BulodPH</span>
          </div>
          <h1 class="auth-title">{{ success ? 'Check your email' : 'Reset password' }}</h1>
          <p class="auth-subtitle">
            {{ success
              ? 'If an account exists for that email, we sent a reset link.'
              : 'Enter your email and we’ll send you a link to reset your password.' }}
          </p>

          <template v-if="!success">
            <v-form @submit.prevent="handleSubmit">
              <v-text-field
                v-model="email"
                label="Email"
                type="email"
                prepend-inner-icon="mdi-email-outline"
                :error-messages="errors.email"
                variant="outlined"
                class="auth-field mb-3"
                required
                rounded="lg"
                density="comfortable"
                hide-details="auto"
              />
              <v-btn
                type="submit"
                block
                size="x-large"
                :loading="isLoading"
                elevation="0"
                rounded="lg"
                class="auth-submit-btn mb-4"
              >
                Send reset link
                <v-icon end icon="mdi-email-send" />
              </v-btn>
            </v-form>
          </template>

          <template v-else>
            <div ref="successBlockRef" class="auth-success-block">
              <p class="auth-success-message mb-4">
              Check your email for the reset link. It may take a few minutes to arrive. 
              If you don’t see it, check your spam folder.
            </p>
            <v-btn
              block
              size="x-large"
              elevation="0"
              rounded="lg"
              class="auth-submit-btn mb-4"
              @click="success = false; email = ''"
            >
              Try another email
            </v-btn>
            </div>
          </template>

          <p class="auth-switch-text">
            <router-link to="/login" class="auth-link auth-link-bold">Back to login</router-link>
          </p>
        </div>
      </div>
    </div>

    <!-- Hero side -->
    <div class="auth-hero-side">
      <div class="auth-hero-image" aria-hidden="true"></div>
      <div class="auth-hero-bg" aria-hidden="true"></div>
      <div class="auth-hero-watermark" aria-hidden="true"></div>
      <div class="auth-hero-floating">
        <img src="/logo.png" alt="BulodPH" class="auth-hero-floating-logo" />
        <p class="auth-hero-floating-detail">Rent a ride or list your vehicle — secure payments with GCash & Maya.</p>
      </div>
    </div>
  </div>
</template>

<script setup lang="ts">
import { ref, watch, nextTick } from 'vue'
import { requestPasswordReset } from '@/services/auth'
import { hasInjectionRisk, sanitizeBasicText } from '@/utils/inputValidation'
import { useGsapAuthPanel } from '@/composables/useGsapAuthPanel'

const authPanelRef = ref<HTMLElement | null>(null)
const successBlockRef = ref<HTMLElement | null>(null)
const email = ref('')
const success = ref(false)
const errors = ref<{ email?: string }>({})
const logoSrc = ref(true)
const isLoading = ref(false)

useGsapAuthPanel(authPanelRef, { y: 18, duration: 0.5, delay: 0.12 })

watch(success, async (ok) => {
  if (!ok) return
  await nextTick()
  const el = successBlockRef.value
  if (!el || window.matchMedia('(prefers-reduced-motion: reduce)').matches) return
  const { default: gsap } = await import('gsap')
  gsap.fromTo(el, { opacity: 0, y: 8 }, { opacity: 1, y: 0, duration: 0.35, ease: 'power2.out' })
})

const handleSubmit = async () => {
  errors.value = {}
  email.value = sanitizeBasicText(email.value)
  if (!email.value.trim()) {
    errors.value.email = 'Email is required'
    return
  }
  if (hasInjectionRisk(email.value)) {
    errors.value.email = 'Email contains unsafe characters'
    return
  }
  isLoading.value = true
  try {
    const result = await requestPasswordReset(email.value.trim())
    if (result.ok) {
      success.value = true
    } else {
      errors.value.email = result.message ?? 'Something went wrong. Please try again.'
    }
  } catch {
    errors.value.email = 'Something went wrong. Please try again.'
  } finally {
    isLoading.value = false
  }
}
</script>

<style scoped>
.auth-page {
  --auth-trust: #0f172a;
  --auth-trust-dark: #052e42;
  --auth-black: #0a0a0c;
  --auth-cyan: #0ea5e9;
  --auth-sky: #0284c7;
  --auth-sky-600: #1e40af;
  --auth-metal-shadow: inset 0 1px 0 rgba(255,255,255,0.2), 0 2px 8px rgba(0,0,0,0.2);
  --auth-metal-btn: inset 0 1px 0 rgba(255,255,255,0.25), 0 4px 12px rgba(0,0,0,0.25);
}

.auth-page {
  display: flex;
  width: 100%;
  min-height: 100vh;
  overflow: hidden;
}

.auth-form-side-single {
  flex: 0 0 50%;
  width: 50%;
  min-height: 100vh;
  position: relative;
  display: flex;
  align-items: center;
  justify-content: center;
  padding: 2rem;
  box-sizing: border-box;
  background-color: var(--bg-light, #f8fafc);
  background-image:
    url("/images/climpek.svg"),
    linear-gradient(180deg, rgba(240, 249, 255, 1) 0%, rgba(224, 242, 254, 1) 35%, rgba(241, 245, 249, 1) 100%);
  background-repeat: repeat, repeat;
  background-position: 0 0, 0 0;
  z-index: 2;
}

.auth-form-bg {
  position: absolute;
  inset: 0;
  z-index: 0;
  pointer-events: none;
}

.auth-panel {
  width: 100%;
  max-width: 420px;
  display: flex;
  align-items: center;
  justify-content: center;
  padding: 2rem 0;
  box-sizing: border-box;
  position: relative;
  z-index: 1;
}

.auth-form-card {
  width: 100%;
  padding: 2.25rem 2rem;
  background: rgba(255, 255, 255, 0.75);
  backdrop-filter: blur(20px);
  -webkit-backdrop-filter: blur(20px);
  border-radius: 24px;
  border: 1px solid rgba(255, 255, 255, 0.6);
  box-shadow:
    0 3px 0 0 rgba(14, 165, 233, 0.12),
    0 1px 0 rgba(255, 255, 255, 0.8) inset,
    0 0 0 1px rgba(255, 255, 255, 0.5) inset,
    0 4px 24px rgba(14, 165, 233, 0.08),
    0 24px 48px -12px rgba(15, 23, 42, 0.12);
  position: relative;
  overflow: hidden;
}
.auth-form-card::before {
  content: '';
  position: absolute;
  top: 0;
  left: 0;
  right: 0;
  height: 4px;
  background: linear-gradient(90deg, var(--auth-cyan), var(--auth-sky));
  border-radius: 24px 24px 0 0;
  z-index: 1;
}

.auth-logo {
  margin-bottom: 1.25rem;
  display: block;
  text-align: center;
}
.auth-logo-img {
  height: 56px;
  width: auto;
  max-width: 200px;
  object-fit: contain;
  display: inline-block;
  vertical-align: middle;
}
.auth-logo-fallback {
  font-size: 1.75rem;
  font-weight: 800;
  color: var(--auth-trust);
  letter-spacing: -0.02em;
}

.auth-tagline {
  font-size: 0.875rem;
  color: var(--text-secondary, #64748b);
  margin: 0 0 1.5rem;
  line-height: 1.45;
  font-weight: 500;
}

.auth-title {
  font-size: 1.75rem;
  font-weight: 800;
  letter-spacing: -0.03em;
  margin: 0 0 0.35rem;
  line-height: 1.2;
  background: linear-gradient(135deg, var(--auth-trust) 0%, var(--role-primary) 100%);
  -webkit-background-clip: text;
  background-clip: text;
  -webkit-text-fill-color: transparent;
  color: var(--auth-trust);
}

.auth-subtitle {
  font-size: 1rem;
  color: var(--text-secondary, #64748b);
  margin: 0 0 1.75rem;
  font-weight: 500;
  line-height: 1.5;
}

.auth-field :deep(.v-field) {
  border-radius: 14px;
  --v-field-border-opacity: 0.45;
  background: rgba(255, 255, 255, 0.7) !important;
}
.auth-field :deep(.v-field--focused) {
  --v-field-border-opacity: 1;
  background: #fff !important;
  box-shadow: 0 0 0 2px rgba(14, 165, 233, 0.35);
}

.auth-success-message {
  font-size: var(--text-body);
  color: var(--text-secondary, #64748b);
  line-height: 1.5;
  margin: 0;
}

.auth-link {
  color: var(--auth-sky) !important;
  text-decoration: none;
  font-weight: 600;
  font-size: 0.9375rem;
}
.auth-link:hover {
  text-decoration: underline;
  color: var(--auth-sky-600) !important;
}
.auth-link-bold { font-weight: 700; }

.auth-submit-btn {
  background: linear-gradient(180deg, var(--auth-cyan) 0%, var(--auth-sky) 100%) !important;
  color: #fff !important;
  font-weight: 700 !important;
  letter-spacing: 0.02em;
  text-transform: none !important;
  border: 1px solid rgba(255, 255, 255, 0.3) !important;
  box-shadow: var(--auth-metal-btn), 0 4px 14px rgba(0, 0, 0, 0.2) !important;
}
.auth-submit-btn:hover {
  box-shadow: inset 0 1px 0 rgba(255,255,255,0.3), 0 6px 20px rgba(0, 0, 0, 0.25) !important;
}

.auth-switch-text {
  font-size: 0.9375rem;
  color: var(--text-secondary, #64748b);
  margin: 0;
  text-align: center;
  font-weight: 500;
}

.auth-hero-side {
  flex: 0 0 50%;
  width: 50%;
  min-height: 100vh;
  position: relative;
  display: flex;
  align-items: center;
  justify-content: center;
  padding: 3rem 2.5rem;
  box-sizing: border-box;
  background: linear-gradient(180deg, var(--trust-blue) 0%, #052e42 50%, #0a0a0c 100%);
  z-index: 1;
  overflow: hidden;
}

.auth-hero-image {
  position: absolute;
  inset: 0;
  z-index: 0;
  background-image: url('/images/auth-hero.png');
  background-size: cover;
  background-position: center;
  background-repeat: no-repeat;
  pointer-events: none;
}

.auth-hero-bg {
  position: absolute;
  inset: 0;
  z-index: 1;
  background: linear-gradient(135deg, rgba(15, 23, 42, 0.45) 0%, rgba(5, 46, 66, 0.4) 45%, rgba(10, 10, 12, 0.55) 100%);
  pointer-events: none;
}

.auth-hero-watermark {
  position: absolute;
  inset: 0;
  z-index: 1;
  background-image: url('/logo.png'), url('/logo.png'), url('/logo.png');
  background-repeat: no-repeat;
  background-position: 20% 30%, 60% 60%, 85% 20%;
  background-size: min(18%, 140px), min(22%, 160px), min(16%, 120px);
  opacity: 0.04;
  filter: brightness(0) invert(1);
  pointer-events: none;
}

.auth-hero-floating {
  position: absolute;
  inset: 0;
  z-index: 2;
  display: flex;
  flex-direction: column;
  align-items: center;
  justify-content: flex-start;
  padding: 3rem 2.5rem 2.5rem;
  padding-top: min(4rem, 12vh);
  pointer-events: none;
}

.auth-hero-floating-logo {
  height: 44px;
  width: auto;
  max-width: 160px;
  object-fit: contain;
  filter: brightness(0) invert(1) drop-shadow(0 1px 2px rgba(0, 0, 0, 0.4));
  opacity: 0.95;
  margin-bottom: 1.25rem;
}

.auth-hero-floating-tagline {
  font-size: 1rem;
  line-height: 1.5;
  color: rgba(255, 255, 255, 0.95);
  margin: 0 0 0.5rem;
  text-align: center;
  max-width: 360px;
  text-shadow: 0 1px 3px rgba(0, 0, 0, 0.5);
  font-weight: 500;
}

.auth-hero-floating-detail {
  font-size: 0.875rem;
  line-height: 1.5;
  color: rgba(255, 255, 255, 0.8);
  margin: 0;
  text-align: center;
  max-width: 320px;
  text-shadow: 0 1px 2px rgba(0, 0, 0, 0.5);
  font-weight: 400;
}

@media (max-width: 960px) {
  .auth-page { flex-direction: column; }
  .auth-form-side-single,
  .auth-hero-side {
    flex: none;
    width: 100%;
    min-height: auto;
  }
  .auth-form-side-single {
    min-height: 100vh;
    padding: 1.5rem 1.25rem;
  }
  .auth-hero-side {
    min-height: 50vh;
    padding: 2rem 1.5rem;
  }
  .auth-form-card {
    max-width: 100%;
    padding: 1.75rem 1.5rem;
  }
  .auth-title { font-size: 1.5rem; }
  .auth-hero-floating { padding: min(3rem, 10vh) 1.25rem 1.5rem; }
  .auth-hero-floating-logo { height: 38px; margin-bottom: 1rem; }
  .auth-hero-floating-tagline { font-size: 0.9375rem; }
  .auth-hero-floating-detail { font-size: 0.8125rem; }
}
</style>
