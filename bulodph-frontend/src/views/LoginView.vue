<template>
  <div class="auth-page">
    <!-- Return to landing (top left) -->
    <router-link to="/" class="auth-return-btn" aria-label="Back to home">
      <v-icon icon="mdi-arrow-left" size="22" />
      <span>Back</span>
    </router-link>

    <!-- Form side: login only -->
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
          <h1 class="auth-title">Welcome back</h1>
          <p class="auth-subtitle">Sign in to find a ride or manage your listings.</p>
          <v-form @submit.prevent="handleLogin">
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
            <v-text-field
              v-model="password"
              label="Password"
              :type="showPassword ? 'text' : 'password'"
              prepend-inner-icon="mdi-lock-outline"
              :append-inner-icon="showPassword ? 'mdi-eye-off' : 'mdi-eye'"
              @click:append-inner="showPassword = !showPassword"
              :error-messages="errors.password"
              variant="outlined"
              class="auth-field mb-3"
              required
              rounded="lg"
              density="comfortable"
              hide-details="auto"
            />
            <div class="auth-options mb-4">
              <v-checkbox v-model="rememberMe" label="Remember me" density="compact" hide-details color="action" />
              <router-link to="/forgot-password" class="auth-link">Forgot password?</router-link>
            </div>
            <v-btn
              type="submit"
              block
              size="x-large"
              :loading="isLoading"
              elevation="0"
              rounded="lg"
              class="auth-submit-btn mb-4"
            >
              Sign in
              <v-icon end icon="mdi-arrow-right" />
            </v-btn>
            <p class="auth-legal-text">
              By signing in you agree to our <router-link to="/terms" class="auth-link">Terms</router-link> and <router-link to="/privacy" class="auth-link">Privacy Policy</router-link>.
            </p>
            <p class="auth-switch-text">
              Don't have an account?
              <router-link to="/register" class="auth-link auth-link-bold">Sign up</router-link>
            </p>
          </v-form>
        </div>
      </div>
    </div>

    <!-- Hero side: BulodPH background image -->
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
import { ref, onMounted } from 'vue'
import { useRouter } from 'vue-router'
import { useLogin } from '@/composables/useAuth'
import { useGsapAuthPanel } from '@/composables/useGsapAuthPanel'
import { hasInjectionRisk, sanitizeBasicText } from '@/utils/inputValidation'

const router = useRouter()
const authPanelRef = ref<HTMLElement | null>(null)
useGsapAuthPanel(authPanelRef, { y: 18, duration: 0.5, delay: 0.12 })
const loginMutation = useLogin()

const email = ref('')
const password = ref('')
const rememberMe = ref(false)
const showPassword = ref(false)
const errors = ref<{ email?: string; password?: string }>({})
const logoSrc = ref(true)
const isLoading = ref(false)

/* ── Login rate limiting ─────────────────────────────── */
const MAX_ATTEMPTS = 5
const LOCKOUT_SECONDS = 60
const failedAttempts = ref(0)
const lockedUntil = ref(0)
const lockRemaining = ref(0)
let lockInterval: ReturnType<typeof setInterval> | null = null

function startLockCountdown() {
  lockRemaining.value = Math.ceil((lockedUntil.value - Date.now()) / 1000)
  lockInterval = setInterval(() => {
    lockRemaining.value = Math.ceil((lockedUntil.value - Date.now()) / 1000)
    if (lockRemaining.value <= 0) {
      lockRemaining.value = 0
      if (lockInterval) { clearInterval(lockInterval); lockInterval = null }
    }
  }, 1000)
}

onMounted(() => {
  const params = new URLSearchParams(window.location.search)
  if (params.get('panel') === 'register') {
    router.replace({ path: '/register' })
  }
})

const handleLogin = async () => {
  errors.value = {}

  // Rate-limit check
  if (lockedUntil.value > Date.now()) {
    errors.value.email = `Too many failed attempts. Try again in ${lockRemaining.value}s.`
    return
  }

  email.value = sanitizeBasicText(email.value)
  if (!email.value.trim()) {
    errors.value.email = 'Email is required'
    return
  }
  if (hasInjectionRisk(email.value)) {
    errors.value.email = 'Email contains unsafe characters'
    return
  }
  if (!password.value) {
    errors.value.password = 'Password is required'
    return
  }
  isLoading.value = true
  try {
    await loginMutation.mutateAsync({ email: email.value.trim(), password: password.value })
    // Success — reset rate limiter
    failedAttempts.value = 0
    lockedUntil.value = 0
    // Redirect is handled in useLogin onSuccess (to role-specific dashboard)
  } catch (error: unknown) {
    // Increment rate limiter
    failedAttempts.value++
    if (failedAttempts.value >= MAX_ATTEMPTS) {
      lockedUntil.value = Date.now() + LOCKOUT_SECONDS * 1000
      startLockCountdown()
      failedAttempts.value = 0
    }

    const err = error as { response?: { data?: { message?: string; errors?: Record<string, string[]> } }; code?: string }
    const res = err?.response?.data
    const errMap = res?.errors
    if (errMap) {
      if (Array.isArray(errMap.email)) errors.value.email = errMap.email[0]
      else if (errMap.email) errors.value.email = errMap.email as unknown as string
      if (Array.isArray(errMap.password)) errors.value.password = errMap.password[0]
      else if (errMap.password) errors.value.password = errMap.password as unknown as string
    }
    if (!errors.value.email && !errors.value.password) {
      if (!err.response) {
        errors.value.email = 'Cannot reach the server. Start the backend (e.g. in bulodph-backend run: php artisan serve) and try again.'
      } else {
        errors.value.email = res?.message ?? 'Invalid email or password.'
      }
    }
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

.auth-return-btn {
  position: fixed;
  top: 1rem;
  left: 1rem;
  z-index: 100;
  display: inline-flex;
  align-items: center;
  gap: 0.5rem;
  padding: 0.5rem 1rem;
  font-size: 0.9375rem;
  font-weight: 600;
  color: var(--auth-trust, #0f172a);
  text-decoration: none;
  background: rgba(255, 255, 255, 0.75);
  backdrop-filter: blur(16px);
  -webkit-backdrop-filter: blur(16px);
  border-radius: 12px;
  border: 1px solid rgba(255, 255, 255, 0.6);
  box-shadow: 0 4px 20px rgba(0, 0, 0, 0.08), 0 1px 3px rgba(255, 255, 255, 0.5) inset;
  transition: background 0.2s, transform 0.15s, box-shadow 0.2s;
}
.auth-return-btn:hover {
  background: rgba(255, 255, 255, 0.9);
  transform: translateX(-2px);
  box-shadow: 0 6px 24px rgba(0, 0, 0, 0.1);
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

.auth-form-card::after {
  content: '';
  position: absolute;
  top: 0;
  left: -100%;
  width: 50%;
  height: 100%;
  background: linear-gradient(90deg, transparent, rgba(255, 255, 255, 0.25), transparent);
  animation: authShine 5s ease-in-out 2s infinite;
  pointer-events: none;
  z-index: 0;
}

@keyframes authShine {
  0% { left: -100%; opacity: 0; }
  20% { opacity: 1; }
  80% { opacity: 1; }
  100% { left: 150%; opacity: 0; }
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
.auth-field :deep(.v-label.v-field-label--floating) {
  color: var(--auth-sky-600);
}

.auth-options {
  display: flex;
  align-items: center;
  justify-content: space-between;
  flex-wrap: wrap;
  gap: 0.5rem;
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

.auth-legal-text {
  font-size: 0.8125rem;
  color: var(--text-secondary, #64748b);
  margin: 0 0 1rem;
  text-align: center;
  font-weight: 500;
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
  background-image: url('/images/login-hero.png');
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

@media (max-width: 600px) {
  .auth-page {
    min-height: 100vh;
  }
  .auth-return-btn {
    top: 0.75rem;
    left: 0.75rem;
    padding: 0.45rem 0.75rem;
    font-size: 0.85rem;
    border-radius: 10px;
  }
  .auth-form-side-single {
    min-height: 100vh;
    padding: 1.25rem 1rem 2rem;
  }
  .auth-panel {
    padding: 1rem 0;
  }
  .auth-form-card {
    padding: 1.5rem 1.25rem;
    border-radius: 18px;
  }
  .auth-title {
    font-size: 1.45rem;
  }
  .auth-subtitle {
    font-size: 0.95rem;
    margin-bottom: 1.5rem;
  }
  .auth-options {
    flex-direction: column;
    align-items: flex-start;
    gap: 0.5rem;
  }
  .auth-hero-side {
    display: none;
  }
}
</style>
