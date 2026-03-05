<template>
  <div class="auth-page">
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
          <h1 class="auth-title">{{ success ? 'Password reset' : 'Set new password' }}</h1>
          <p class="auth-subtitle">
            {{ success
              ? 'Your password has been reset. You can now log in.'
              : 'Enter your new password below.' }}
          </p>

          <template v-if="!success && hasToken">
            <v-form @submit.prevent="handleSubmit">
              <v-text-field
                v-model="password"
                label="New password"
                :type="showPassword ? 'text' : 'password'"
                prepend-inner-icon="mdi-lock-outline"
                :append-inner-icon="showPassword ? 'mdi-eye-off' : 'mdi-eye'"
                @click:append-inner="showPassword = !showPassword"
                @focus="passwordFieldFocused = true"
                @blur="passwordFieldFocused = false"
                :error-messages="errors.password"
                variant="outlined"
                class="auth-field mb-2"
                required
                rounded="lg"
                density="comfortable"
                hide-details="auto"
                autocomplete="new-password"
              />
              <PasswordStrengthChecklist v-show="passwordFieldFocused" :password="password" />
              <v-text-field
                v-model="confirmPassword"
                label="Confirm password"
                :type="showConfirm ? 'text' : 'password'"
                prepend-inner-icon="mdi-lock-check-outline"
                :append-inner-icon="showConfirm ? 'mdi-eye-off' : 'mdi-eye'"
                @click:append-inner="showConfirm = !showConfirm"
                :error-messages="errors.confirmPassword"
                variant="outlined"
                class="auth-field mb-3"
                required
                rounded="lg"
                density="comfortable"
                hide-details="auto"
                autocomplete="new-password"
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
                Reset password
                <v-icon end icon="mdi-key" />
              </v-btn>
            </v-form>
          </template>

          <template v-else-if="!hasToken">
            <p class="auth-success-message mb-4">
              This reset link is invalid or has expired. Please
              <router-link to="/forgot-password" class="auth-link">request a new one</router-link>.
            </p>
          </template>

          <template v-else>
            <div ref="successBlockRef" class="auth-success-block">
              <v-btn
                block
                size="x-large"
                elevation="0"
                rounded="lg"
                class="auth-submit-btn mb-4"
                :to="{ name: 'login' }"
              >
                Go to login
              </v-btn>
            </div>
          </template>

          <p class="auth-switch-text">
            <router-link to="/login" class="auth-link auth-link-bold">Back to login</router-link>
          </p>
        </div>
      </div>
    </div>

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
import { ref, computed, onMounted, watch, nextTick } from 'vue'
import { useRoute } from 'vue-router'
import { resetPassword } from '@/services/auth'
import PasswordStrengthChecklist from '@/components/PasswordStrengthChecklist.vue'
import { usePasswordValidation } from '@/composables/usePasswordValidation'
import { useGsapAuthPanel } from '@/composables/useGsapAuthPanel'

const route = useRoute()
const authPanelRef = ref<HTMLElement | null>(null)
const successBlockRef = ref<HTMLElement | null>(null)
useGsapAuthPanel(authPanelRef, { y: 18, duration: 0.5, delay: 0.12 })

watch(success, async (ok) => {
  if (!ok) return
  await nextTick()
  const el = successBlockRef.value
  if (!el || window.matchMedia('(prefers-reduced-motion: reduce)').matches) return
  const { default: gsap } = await import('gsap')
  gsap.fromTo(el, { opacity: 0, y: 8 }, { opacity: 1, y: 0, duration: 0.35, ease: 'power2.out' })
})

const password = ref('')
const confirmPassword = ref('')
const success = ref(false)
const showPassword = ref(false)
const showConfirm = ref(false)
const passwordFieldFocused = ref(false)
const errors = ref<{ password?: string; confirmPassword?: string }>({})
const logoSrc = ref(true)
const isLoading = ref(false)

const token = computed(() => (route.query.token as string) ?? '')
const email = computed(() => (route.query.email as string) ?? '')
const hasToken = computed(() => !!token.value && !!email.value)

onMounted(() => {
  if (!hasToken.value) {
    errors.value.confirmPassword = 'Invalid or missing reset link.'
  }
})

const { isValid: passwordIsValid } = usePasswordValidation(password)

const handleSubmit = async () => {
  errors.value = {}
  if (!password.value) {
    errors.value.password = 'Password is required'
    return
  }
  if (!passwordIsValid.value) {
    errors.value.password = 'Password must meet all requirements below'
    return
  }
  if (password.value !== confirmPassword.value) {
    errors.value.confirmPassword = 'Passwords do not match'
    return
  }
  isLoading.value = true
  try {
    await resetPassword(email.value, token.value, password.value)
    success.value = true
  } catch (err: unknown) {
    const res = (err as { response?: { data?: { errors?: Record<string, string[]> } } })?.response?.data
    const errMap = res?.errors
    if (errMap?.email) {
      errors.value.password = Array.isArray(errMap.email) ? errMap.email[0] : errMap.email
    } else {
      errors.value.password = (res as { message?: string })?.message ?? 'Something went wrong. Please try again.'
    }
  } finally {
    isLoading.value = false
  }
}
</script>

<style scoped>
.auth-page {
  --auth-trust: #0f172a;
  --auth-cyan: #0ea5e9;
  --auth-sky: #0284c7;
  --auth-sky-600: #1e40af;
  --auth-metal-btn: inset 0 1px 0 rgba(255,255,255,0.25), 0 4px 12px rgba(0, 0, 0, 0.25);
}

.auth-page {
  display: flex;
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

.auth-form-bg { position: absolute; inset: 0; z-index: 0; pointer-events: none; }
.auth-panel { width: 100%; max-width: 420px; position: relative; z-index: 1; }
.auth-form-card {
  width: 100%;
  padding: 2.25rem 2rem;
  background: rgba(255, 255, 255, 0.75);
  backdrop-filter: blur(20px);
  border-radius: 24px;
  border: 1px solid rgba(255, 255, 255, 0.6);
  box-shadow: 0 4px 24px rgba(14, 165, 233, 0.08), 0 24px 48px -12px rgba(15, 23, 42, 0.12);
}
.auth-form-card::before {
  content: '';
  position: absolute;
  top: 0; left: 0; right: 0;
  height: 4px;
  background: linear-gradient(90deg, var(--auth-cyan), var(--auth-sky));
  border-radius: 24px 24px 0 0;
}
.auth-logo { margin-bottom: 1.25rem; text-align: center; }
.auth-logo-img { height: 56px; width: auto; max-width: 200px; object-fit: contain; }
.auth-logo-fallback { font-size: 1.75rem; font-weight: 800; color: var(--auth-trust); }
.auth-tagline { font-size: 0.875rem; color: #64748b; margin: 0 0 1.5rem; }
.auth-title { font-size: 1.75rem; font-weight: 800; margin: 0 0 0.35rem; }
.auth-subtitle { font-size: 1rem; color: #64748b; margin: 0 0 1.75rem; }
.auth-field :deep(.v-field) { border-radius: 14px; background: rgba(255, 255, 255, 0.7) !important; }
.auth-success-message { font-size: 0.9375rem; color: #64748b; margin: 0 0 1rem; }
.auth-link { color: var(--auth-sky) !important; text-decoration: none; font-weight: 600; }
.auth-link:hover { text-decoration: underline; color: var(--auth-sky-600) !important; }
.auth-link-bold { font-weight: 700; }
.auth-switch-text { font-size: 0.9375rem; color: #64748b; margin: 0; text-align: center; }
.auth-submit-btn {
  background: linear-gradient(180deg, var(--auth-cyan) 0%, var(--auth-sky) 100%) !important;
  color: #fff !important;
  font-weight: 700 !important;
  text-transform: none !important;
  box-shadow: var(--auth-metal-btn) !important;
}
.auth-hero-side {
  flex: 0 0 50%;
  width: 50%;
  min-height: 100vh;
  position: relative;
  display: flex;
  align-items: center;
  justify-content: center;
  padding: 3rem;
  background: linear-gradient(180deg, #0f172a 0%, #052e42 50%, #0a0a0c 100%);
  z-index: 1;
}
.auth-hero-image { position: absolute; inset: 0; background-image: url('/images/auth-hero.png'); background-size: cover; }
.auth-hero-bg { position: absolute; inset: 0; background: linear-gradient(135deg, rgba(15, 23, 42, 0.45) 0%, rgba(5, 46, 66, 0.4) 45%, rgba(10, 10, 12, 0.55) 100%); }
.auth-hero-watermark { position: absolute; inset: 0; opacity: 0.04; }
.auth-hero-floating { position: absolute; inset: 0; display: flex; flex-direction: column; align-items: center; justify-content: flex-start; padding: 4rem 3rem; }
.auth-hero-floating-logo { height: 44px; margin-bottom: 1.25rem; }
.auth-hero-floating-tagline { font-size: 1rem; color: rgba(255,255,255,0.95); margin: 0 0 0.5rem; text-align: center; }
.auth-hero-floating-detail { font-size: 0.875rem; color: rgba(255,255,255,0.8); margin: 0; text-align: center; }

@media (max-width: 960px) {
  .auth-page { flex-direction: column; }
  .auth-form-side-single, .auth-hero-side { flex: none; width: 100%; min-height: auto; }
  .auth-form-side-single { min-height: 100vh; }
  .auth-hero-side { min-height: 50vh; }
}
</style>
