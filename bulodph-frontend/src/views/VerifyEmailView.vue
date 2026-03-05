<template>
  <div class="auth-page">
    <button type="button" class="auth-return-btn" aria-label="Back to login" @click="goToLoginWithDifferentAccount">
      <v-icon icon="mdi-arrow-left" size="22" />
      <span>Back</span>
    </button>

    <div class="auth-form-side auth-form-side-single">
      <div class="auth-form-bg" aria-hidden="true"></div>
      <div class="auth-panel">
        <div class="auth-form-card">
          <div class="auth-logo">
            <img src="/logo.png" alt="BulodPH" class="auth-logo-img" @error="logoSrc = false" />
            <span v-if="!logoSrc" class="auth-logo-fallback">BulodPH</span>
          </div>
          <h1 class="auth-title">Verify your email</h1>
          <p class="auth-subtitle">
            We sent a 6-digit code to <strong>{{ userEmail }}</strong>. Enter it below.
          </p>
          <v-form @submit.prevent="handleVerify">
            <v-text-field
              v-model="otp"
              label="Verification code"
              type="text"
              inputmode="numeric"
              pattern="[0-9]*"
              maxlength="6"
              prepend-inner-icon="mdi-email-check-outline"
              :error-messages="errors.otp"
              variant="outlined"
              class="auth-field mb-3"
              placeholder="000000"
              rounded="lg"
              density="comfortable"
              hide-details="auto"
              autocomplete="one-time-code"
              @input="onOtpInput"
            />
            <v-btn
              type="submit"
              color="primary"
              size="large"
              block
              rounded="lg"
              class="auth-submit mb-2"
              :loading="verifying"
              :disabled="otp.length !== 6"
            >
              Verify
            </v-btn>
            <v-btn
              type="button"
              variant="text"
              block
              rounded="lg"
              :loading="sending"
              :disabled="resendCooldown > 0"
              @click="sendOtp"
            >
              {{ resendCooldown > 0 ? `Resend code in ${resendCooldown}s` : 'Resend code' }}
            </v-btn>
          </v-form>
          <p class="auth-footer-hint mt-4">
            <button type="button" class="auth-link auth-link-btn" @click="goToLoginWithDifferentAccount">Use a different account</button>
          </p>
        </div>
      </div>
    </div>
  </div>
</template>

<script setup lang="ts">
import { ref, computed, onMounted } from 'vue'
import { useRouter } from 'vue-router'
import api from '@/lib/api'
import { useUserSessionStore } from '@/stores/userSession'
import { useToastStore } from '@/stores/toast'
import { getPrimaryRole, getDashboardRouteForRole } from '@/composables/useAuth'

const router = useRouter()
const userSession = useUserSessionStore()
const toast = useToastStore()

const logoSrc = ref(true)
const otp = ref('')
const errors = ref<{ otp?: string[] }>({})
const verifying = ref(false)
const sending = ref(false)
const resendCooldown = ref(0)
let cooldownTimer: ReturnType<typeof setInterval> | null = null

const userEmail = computed(() => userSession.user?.email ?? '')

function onOtpInput(e: Event) {
  const target = e.target as HTMLInputElement
  const v = target.value.replace(/\D/g, '').slice(0, 6)
  otp.value = v
}

async function sendOtp() {
  if (sending.value || resendCooldown.value > 0) return
  sending.value = true
  errors.value = {}
  try {
    await api.post('/email-verification/send-otp')
    toast.success('Verification code sent. Check your email.')
    resendCooldown.value = 60
    if (cooldownTimer) clearInterval(cooldownTimer)
    cooldownTimer = setInterval(() => {
      resendCooldown.value--
      if (resendCooldown.value <= 0 && cooldownTimer) {
        clearInterval(cooldownTimer)
        cooldownTimer = null
      }
    }, 1000)
  } catch (err: unknown) {
    const ax = err as { response?: { status?: number; data?: { message?: string; errors?: Record<string, string[]> } } }
    const msg = ax.response?.data?.message ?? ax.response?.data?.errors?.email?.[0] ?? 'Could not send code. Try again.'
    toast.error(msg)
  } finally {
    sending.value = false
  }
}

async function goToLoginWithDifferentAccount() {
  try {
    await api.post('/logout')
  } catch {
    // Ignore; we still clear local session
  }
  userSession.clearAuth()
  router.push({ name: 'login' })
}

async function handleVerify() {
  if (otp.value.length !== 6) return
  verifying.value = true
  errors.value = {}
  try {
    const { data } = await api.post<{ message: string; user: Record<string, unknown> }>('/email-verification/verify', { otp: otp.value })
    userSession.updateUser({
      email_verified: true,
      email_verified_at: (data.user as { email_verified_at?: string }).email_verified_at,
    })
    toast.success(data.message ?? 'Email verified.')
    const role = getPrimaryRole((userSession.user?.roles as string[]) ?? [])
    router.push({ name: getDashboardRouteForRole(role) })
  } catch (err: unknown) {
    const ax = err as { response?: { status?: number; data?: { errors?: Record<string, string[]> } } }
    const otpErrors = ax.response?.data?.errors?.otp
    errors.value = { otp: otpErrors ?? ['Invalid or expired code. Request a new one.'] }
  } finally {
    verifying.value = false
  }
}

onMounted(() => {
  if (!userSession.isAuthenticated || !userSession.user?.email) {
    router.replace({ name: 'login' })
    return
  }
  const primaryRole = userSession.user?.roles?.[0]?.toLowerCase?.() ?? ''
  if (primaryRole === 'admin' || userSession.user?.email_verified) {
    const role = getPrimaryRole(userSession.user.roles ?? [])
    router.replace({ name: getDashboardRouteForRole(role) })
    return
  }
  sendOtp()
})
</script>

<style scoped>
.auth-page {
  min-height: 100vh;
  position: relative;
  display: flex;
  align-items: center;
  justify-content: center;
  background: var(--bg-light, #f8fafc);
}
.auth-return-btn {
  position: fixed;
  top: 20px;
  left: 20px;
  display: inline-flex;
  align-items: center;
  gap: 8px;
  color: var(--trust-blue, #0f172a);
  text-decoration: none;
  font-size: 0.9rem;
  z-index: 10;
  cursor: pointer;
  background: none;
  border: none;
  padding: 0;
  font: inherit;
}
.auth-form-side {
  width: 100%;
  max-width: 420px;
  padding: 24px;
  position: relative;
}
.auth-form-bg {
  position: absolute;
  inset: 0;
  background: linear-gradient(135deg, #0f172a 0%, #1e40af 100%);
  border-radius: 24px;
  opacity: 0.03;
}
.auth-panel {
  position: relative;
}
.auth-form-card {
  background: #fff;
  border-radius: 20px;
  padding: 32px;
  box-shadow: 0 4px 24px rgba(15, 23, 42, 0.08);
}
.auth-logo {
  text-align: center;
  margin-bottom: 24px;
}
.auth-logo-img {
  height: 40px;
  width: auto;
}
.auth-logo-fallback {
  font-size: 1.5rem;
  font-weight: 700;
  color: #0f172a;
}
.auth-title {
  font-size: 1.5rem;
  font-weight: 700;
  color: #0f172a;
  margin: 0 0 8px 0;
}
.auth-subtitle {
  font-size: 0.95rem;
  color: #64748b;
  margin: 0 0 24px 0;
}
.auth-field :deep(.v-field) {
  border-radius: 12px;
}
.auth-submit {
  text-transform: none;
  font-weight: 600;
}
.auth-footer-hint {
  font-size: 0.85rem;
  color: #64748b;
  text-align: center;
  margin: 0;
}
.auth-link {
  color: #1e40af;
  text-decoration: none;
  font-weight: 500;
}
.auth-link-btn {
  background: none;
  border: none;
  padding: 0;
  cursor: pointer;
  font: inherit;
}
</style>
