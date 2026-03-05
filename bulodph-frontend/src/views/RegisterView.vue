<template>
  <div class="auth-page auth-page-register">
    <RegisterRoleModal v-model="showChoiceModal" @select="onRoleSelect" />

    <!-- Return to landing (top left) -->
    <router-link to="/" class="auth-return-btn" aria-label="Back to home">
      <v-icon icon="mdi-arrow-left" size="22" />
      <span>Back</span>
    </router-link>

    <!-- Hero side (left) -->
    <div class="auth-hero-side">
      <div class="auth-hero-image" aria-hidden="true"></div>
      <div class="auth-hero-bg" aria-hidden="true"></div>
      <div class="auth-hero-watermark" aria-hidden="true"></div>
      <div class="auth-hero-floating">
        <img src="/logo.png" alt="BulodPH" class="auth-hero-floating-logo" />
        <p class="auth-hero-floating-detail">Rent a ride or list your vehicle — secure payments with GCash & Maya.</p>
      </div>
    </div>

    <!-- Form side (right) -->
    <div class="auth-form-side auth-form-side-single">
      <div class="auth-form-bg" aria-hidden="true"></div>
      <div ref="authPanelRef" class="auth-panel">
        <div
          class="auth-form-card auth-form-card-register"
          :class="{
            'auth-form-card--renter': accountType === 'renter',
            'auth-form-card--car-owner': accountType === 'car_owner',
            'auth-form-card--marketing-partner': accountType === 'marketing_partner',
          }"
        >
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
          <h1 class="auth-title">Create account</h1>
          <p class="auth-subtitle">Sign up to find a ride or list your vehicle.</p>
          <div v-if="accountType" class="auth-role-indicator-row">
            <div class="auth-role-indicator" :class="`auth-role-indicator--${accountType}`">
              <v-icon :icon="roleIndicatorIcon" size="20" />
              <span>{{ roleIndicatorLabel }}</span>
            </div>
            <button type="button" class="auth-role-change" @click="openChangeRoleModal">
              Change role
            </button>
          </div>
          <v-form @submit.prevent="handleRegister" class="auth-form-grid">
            <!-- Personal & contact -->
            <div class="auth-form-section">
              <h3 class="auth-form-section-title">Personal & contact</h3>
              <v-row dense class="auth-form-row">
                <v-col cols="12" md="6">
                  <v-text-field
                    v-model="fullName"
                    label="Full name"
                    prepend-inner-icon="mdi-account-outline"
                    :error-messages="errors.fullName"
                    variant="outlined"
                    class="auth-field"
                    required
                    rounded="lg"
                    density="comfortable"
                    hide-details="auto"
                    placeholder="Letters and spaces only"
                    @input="onFullNameInput"
                    @blur="validateField('fullName')"
                  />
                </v-col>
                <v-col cols="12" md="6">
                  <v-text-field
                    v-model="email"
                    label="Email"
                    type="email"
                    prepend-inner-icon="mdi-email-outline"
                    :error-messages="errors.email"
                    variant="outlined"
                    class="auth-field"
                    required
                    rounded="lg"
                    density="comfortable"
                    hide-details="auto"
                    @blur="validateField('email')"
                  />
                </v-col>
              </v-row>
              <v-row dense class="auth-form-row">
                <v-col cols="12" md="6">
                  <v-text-field
                    :model-value="phone"
                    @update:model-value="(v) => phone = formatInput(v, 'phone')"
                    label="Phone number"
                    type="tel"
                    :error-messages="errors.phone"
                    placeholder="09XX XXX XXXX"
                    variant="outlined"
                    class="auth-field auth-field-phone"
                    rounded="lg"
                    density="comfortable"
                    hide-details="auto"
                    maxlength="13"
                    @blur="validateField('phone')"
                  >
                    <template #prepend-inner>
                      <span class="auth-phone-prefix" aria-hidden="true">🇵🇭 +63</span>
                    </template>
                  </v-text-field>
                </v-col>
              </v-row>
            </div>

            <!-- Address -->
            <div class="auth-form-section">
              <h3 class="auth-form-section-title">Address</h3>
              <v-row dense class="auth-form-row">
                <v-col cols="12" md="6">
                  <v-select
                    v-model="selectedProvince"
                    :items="provinces"
                    item-title="name"
                    item-value="code"
                    label="Province"
                    prepend-inner-icon="mdi-map-marker"
                    :error-messages="errors.province"
                    :loading="loadingProvinces"
                    variant="outlined"
                    class="auth-field"
                    rounded="lg"
                    density="comfortable"
                    hide-details="auto"
                    placeholder="Select province"
                    @update:model-value="onProvinceChange"
                  />
                </v-col>
                <v-col cols="12" md="6">
                  <v-select
                    v-model="selectedCity"
                    :items="cities"
                    item-title="name"
                    item-value="code"
                    label="City / Municipality"
                    prepend-inner-icon="mdi-city"
                    :error-messages="errors.city"
                    :loading="loadingCities"
                    :disabled="!selectedProvince"
                    variant="outlined"
                    class="auth-field"
                    rounded="lg"
                    density="comfortable"
                    hide-details="auto"
                    placeholder="Select province first"
                  />
                </v-col>
              </v-row>
              <v-row dense class="auth-form-row">
                <v-col cols="12" md="6">
                  <v-text-field
                    :model-value="barangay"
                    @update:model-value="(v) => barangay = formatInput(v, 'letters')"
                    label="Barangay"
                    prepend-inner-icon="mdi-home-map-marker"
                    :error-messages="errors.barangay"
                    placeholder="e.g. Poblacion"
                    variant="outlined"
                    class="auth-field"
                    rounded="lg"
                    density="comfortable"
                    hide-details="auto"
                  />
                </v-col>
                <v-col cols="12" md="6">
                  <v-text-field
                    :model-value="street"
                    @update:model-value="(v) => street = formatInput(v, 'address')"
                    label="Street address"
                    prepend-inner-icon="mdi-map-marker-outline"
                    :error-messages="errors.street"
                    placeholder="Building, street, subdivision"
                    variant="outlined"
                    class="auth-field"
                    rounded="lg"
                    density="comfortable"
                    hide-details="auto"
                  />
                </v-col>
              </v-row>
            </div>

            <!-- Rental company details (car owner only) -->
            <div v-if="accountType === 'car_owner'" class="auth-form-section">
              <h3 class="auth-form-section-title">Rental company details</h3>
              <p class="auth-form-section-desc text-body-2 text-medium-emphasis mb-3">Your car rental business info so clients can find you.</p>
              <v-row dense class="auth-form-row">
                <v-col cols="12">
                  <v-text-field
                    v-model="businessName"
                    label="Company / Rental name *"
                    prepend-inner-icon="mdi-storefront-outline"
                    :error-messages="errors.businessName"
                    placeholder="e.g. Juan's Car Rental"
                    variant="outlined"
                    class="auth-field"
                    rounded="lg"
                    density="comfortable"
                    hide-details="auto"
                    @blur="validateField('businessName')"
                  />
                </v-col>
              </v-row>
              <v-row dense class="auth-form-row">
                <v-col cols="12">
                  <v-textarea
                    v-model="rentalBio"
                    label="Bio / About your rental (optional)"
                    placeholder="Tell clients about your fleet and service."
                    variant="outlined"
                    class="auth-field"
                    rounded="lg"
                    density="comfortable"
                    rows="2"
                    hide-details="auto"
                  />
                </v-col>
              </v-row>
              <v-row dense class="auth-form-row">
                <v-col cols="12" md="6">
                  <v-text-field
                    :model-value="rentalCity"
                    @update:model-value="(v) => rentalCity = formatInput(v, 'letters')"
                    label="City (optional)"
                    placeholder="e.g. Cauayan"
                    variant="outlined"
                    class="auth-field"
                    rounded="lg"
                    density="comfortable"
                    hide-details="auto"
                  />
                </v-col>
                <v-col cols="12" md="6">
                  <v-text-field
                    :model-value="rentalProvince"
                    @update:model-value="(v) => rentalProvince = formatInput(v, 'letters')"
                    label="Province / Region (optional)"
                    placeholder="e.g. Isabela"
                    variant="outlined"
                    class="auth-field"
                    rounded="lg"
                    density="comfortable"
                    hide-details="auto"
                  />
                </v-col>
              </v-row>
              <v-row dense class="auth-form-row">
                <v-col cols="12">
                  <v-text-field
                    :model-value="rentalAddress"
                    @update:model-value="(v) => rentalAddress = formatInput(v, 'address')"
                    label="Full address (optional)"
                    placeholder="Street, barangay, city"
                    variant="outlined"
                    class="auth-field"
                    rounded="lg"
                    density="comfortable"
                    hide-details="auto"
                  />
                </v-col>
              </v-row>
              <v-row dense class="auth-form-row">
                <v-col cols="12" md="6">
                  <v-text-field
                    :model-value="businessPermitNumber"
                    @update:model-value="(v) => businessPermitNumber = formatInput(v, 'idNumber')"
                    label="Business permit number (optional)"
                    placeholder="e.g. BP-2024-001"
                    variant="outlined"
                    class="auth-field"
                    rounded="lg"
                    density="comfortable"
                    hide-details="auto"
                  />
                </v-col>
                <v-col cols="12" md="6">
                  <v-text-field
                    :model-value="businessAddress"
                    @update:model-value="(v) => businessAddress = formatInput(v, 'address')"
                    label="Business address (optional)"
                    placeholder="If different from above"
                    variant="outlined"
                    class="auth-field"
                    rounded="lg"
                    density="comfortable"
                    hide-details="auto"
                  />
                </v-col>
              </v-row>
            </div>

            <!-- Password -->
            <div class="auth-form-section">
              <h3 class="auth-form-section-title">Password</h3>
              <v-row dense class="auth-form-row">
                <v-col cols="12" md="6">
                  <v-text-field
                    v-model="password"
                    label="Password"
                    :type="showPassword ? 'text' : 'password'"
                    prepend-inner-icon="mdi-lock-outline"
                    :append-inner-icon="showPassword ? 'mdi-eye-off' : 'mdi-eye'"
                    @click:append-inner="showPassword = !showPassword"
                    @focus="passwordFieldFocused = true"
                    @blur="passwordFieldFocused = false"
                    :error-messages="errors.password"
                    variant="outlined"
                    class="auth-field"
                    required
                    rounded="lg"
                    density="comfortable"
                    hide-details="auto"
                  />
                </v-col>
                <v-col cols="12" md="6">
                  <v-text-field
                    v-model="confirmPassword"
                    label="Confirm password"
                    :type="showConfirmPassword ? 'text' : 'password'"
                    prepend-inner-icon="mdi-lock-check-outline"
                    :append-inner-icon="showConfirmPassword ? 'mdi-eye-off' : 'mdi-eye'"
                    @click:append-inner="showConfirmPassword = !showConfirmPassword"
                    :error-messages="errors.confirmPassword"
                    variant="outlined"
                    class="auth-field"
                    required
                    rounded="lg"
                    density="comfortable"
                    hide-details="auto"
                  />
                </v-col>
              </v-row>
              <PasswordStrengthChecklist v-show="passwordFieldFocused" :password="password" />
            </div>
            <v-checkbox
              v-model="acceptedTerms"
              color="primary"
              hide-details
              density="compact"
              class="auth-checkbox-spacing"
              :error-messages="errors.terms"
            >
              <template #label>
                <span class="text-body-2">I agree to the <router-link to="/terms" class="auth-link" target="_blank">Terms of Service</router-link> and <router-link to="/privacy" class="auth-link" target="_blank">Privacy Policy</router-link>.</span>
              </template>
            </v-checkbox>
            <v-checkbox
              v-model="marketingConsent"
              color="primary"
              hide-details
              density="compact"
              class="auth-checkbox-spacing"
            >
              <template #label>
                <span class="text-body-2">I agree to receive product updates and marketing messages from BulodPH (optional).</span>
              </template>
            </v-checkbox>
            <v-btn
              type="submit"
              block
              size="x-large"
              :loading="isLoading"
              elevation="0"
              rounded="lg"
              class="auth-submit-btn auth-submit-btn-spacing"
              :disabled="!acceptedTerms"
            >
              Create account
              <v-icon end icon="mdi-arrow-right" />
            </v-btn>
            <p class="auth-switch-text">
              Already have an account?
              <router-link to="/login" class="auth-link auth-link-bold">Sign in</router-link>
            </p>
          </v-form>
        </div>
      </div>
    </div>
  </div>
</template>

<script setup lang="ts">
import { ref, computed, onMounted } from 'vue'
import { useRouter } from 'vue-router'
import RegisterRoleModal from '@/components/RegisterRoleModal.vue'
import PasswordStrengthChecklist from '@/components/PasswordStrengthChecklist.vue'
import { usePhilippineLocations } from '@/composables/usePhilippineLocations'
import { useRegister } from '@/composables/useAuth'
import { usePasswordValidation } from '@/composables/usePasswordValidation'
import { hasInjectionRisk, isSafeText, sanitizeBasicText } from '@/utils/inputValidation'
import { formatInput } from '@/utils/inputFormatters'
import { useGsapAuthPanel } from '@/composables/useGsapAuthPanel'

const router = useRouter()
const registerMutation = useRegister()
const authPanelRef = ref<HTMLElement | null>(null)
useGsapAuthPanel(authPanelRef, { y: 18, duration: 0.5, delay: 0.12 })

const {
  provinces,
  cities,
  loadingProvinces,
  loadingCities,
  loadProvinces,
  loadCities,
} = usePhilippineLocations()

const fullName = ref('')
const email = ref('')
const phone = ref('')
const selectedProvince = ref<string | null>(null)
const selectedCity = ref<string | null>(null)
const barangay = ref('')
const street = ref('')
const password = ref('')
const confirmPassword = ref('')
const { isValid: passwordIsValid } = usePasswordValidation(password)
const showPassword = ref(false)
const showConfirmPassword = ref(false)
const passwordFieldFocused = ref(false)
const isLoading = ref(false)
const acceptedTerms = ref(false)
const marketingConsent = ref(false)
const errors = ref<{
  fullName?: string
  email?: string
  phone?: string
  province?: string
  city?: string
  barangay?: string
  street?: string
  businessName?: string
  password?: string
  confirmPassword?: string
  terms?: string
}>({})
const businessName = ref('')
const rentalBio = ref('')
const rentalCity = ref('')
const rentalProvince = ref('')
const rentalAddress = ref('')
const businessPermitNumber = ref('')
const businessAddress = ref('')
const logoSrc = ref(true)
const showChoiceModal = ref(true)
const accountType = ref<'renter' | 'car_owner' | 'marketing_partner' | null>(null)

function onRoleSelect(role: 'renter' | 'car_owner' | 'marketing_partner') {
  accountType.value = role
  showChoiceModal.value = false
}

function openChangeRoleModal() {
  showChoiceModal.value = true
}

const roleIndicatorIcon = computed(() => {
  if (accountType.value === 'renter') return 'mdi-car-search'
  if (accountType.value === 'car_owner') return 'mdi-car-side'
  if (accountType.value === 'marketing_partner') return 'mdi-handshake-outline'
  return 'mdi-account'
})

const roleIndicatorLabel = computed(() => {
  if (accountType.value === 'renter') return 'Signing up to rent a car'
  if (accountType.value === 'car_owner') return 'Signing up as Car rental owner'
  if (accountType.value === 'marketing_partner') return 'Signing up as Marketing partner'
  return ''
})

onMounted(() => {
  loadProvinces()
})

function onProvinceChange(provinceCode: string | null) {
  selectedCity.value = null
  if (provinceCode) {
    loadCities(provinceCode)
  }
}

/** Restrict full name to letters, spaces, hyphens, apostrophes */
function onFullNameInput() {
  fullName.value = fullName.value.replace(/[^a-zA-Z\u00C0-\u024F\u1E00-\u1EFF\s\-']/g, '')
}

function validateField(field: string) {
  switch (field) {
    case 'fullName':
      fullName.value = sanitizeBasicText(fullName.value)
      if (!fullName.value.trim()) errors.value.fullName = 'Full name is required'
      else if (!validateFullName(fullName.value)) errors.value.fullName = 'Use only letters, spaces, hyphens, or apostrophes'
      else if (hasInjectionRisk(fullName.value)) errors.value.fullName = 'Please remove unsafe characters'
      else delete errors.value.fullName
      break
    case 'email':
      email.value = sanitizeBasicText(email.value)
      if (!email.value.trim()) errors.value.email = 'Email is required'
      else if (hasInjectionRisk(email.value)) errors.value.email = 'Email contains unsafe characters'
      else delete errors.value.email
      break
    case 'phone':
      phone.value = sanitizeBasicText(phone.value)
      if (!phone.value.trim()) errors.value.phone = 'Philippine phone number is required'
      else if (!validatePhone(phone.value)) errors.value.phone = 'Enter a valid PH number (e.g. 0917 123 4567)'
      else if (hasInjectionRisk(phone.value)) errors.value.phone = 'Phone contains unsafe characters'
      else delete errors.value.phone
      break
    case 'businessName':
      businessName.value = sanitizeBasicText(businessName.value)
      if (!businessName.value.trim()) errors.value.businessName = 'Company name is required for car rental owners'
      else if (hasInjectionRisk(businessName.value)) errors.value.businessName = 'Please remove unsafe characters'
      else delete errors.value.businessName
      break
  }
}

/** Full name: only letters, spaces, hyphens, apostrophes */
function validateFullName(value: string): boolean {
  return /^[\p{L}\s\-']+$/u.test(value.trim()) && value.trim().length >= 2
}

/** Philippine mobile: 10 digits starting with 9 (stored as 63 + 9XX...) */
function validatePhone(value: string): boolean {
  const digits = value.replace(/\D/g, '').replace(/^0+/, '').replace(/^63/, '')
  return digits.length === 10 && digits.startsWith('9')
}

function normalizePhoneForApi(value: string): string {
  const digits = value.replace(/\D/g, '').replace(/^0+/, '').replace(/^63/, '')
  return digits.length === 10 && digits.startsWith('9') ? `63${digits}` : ''
}

const handleRegister = async () => {
  errors.value = {}
  fullName.value = sanitizeBasicText(fullName.value)
  email.value = sanitizeBasicText(email.value)
  phone.value = sanitizeBasicText(phone.value)
  barangay.value = sanitizeBasicText(barangay.value)
  street.value = sanitizeBasicText(street.value)
  businessName.value = sanitizeBasicText(businessName.value)
  rentalBio.value = sanitizeBasicText(rentalBio.value)
  rentalCity.value = sanitizeBasicText(rentalCity.value)
  rentalProvince.value = sanitizeBasicText(rentalProvince.value)
  rentalAddress.value = sanitizeBasicText(rentalAddress.value)
  businessPermitNumber.value = sanitizeBasicText(businessPermitNumber.value)
  businessAddress.value = sanitizeBasicText(businessAddress.value)

  if (!accountType.value) {
    errors.value.email = 'Please choose how you want to use BulodPH above.'
    return
  }
  if (!acceptedTerms.value) {
    errors.value.terms = 'You must agree to the Terms of Service and Privacy Policy.'
    return
  }
  if (accountType.value === 'car_owner' && !businessName.value.trim()) {
    errors.value.businessName = 'Company name is required for car rental owners'
  }
  if (!fullName.value.trim()) errors.value.fullName = 'Full name is required'
  else if (!validateFullName(fullName.value)) errors.value.fullName = 'Use only letters, spaces, hyphens, or apostrophes'
  else if (hasInjectionRisk(fullName.value)) errors.value.fullName = 'Please remove unsafe characters'
  if (!email.value.trim()) errors.value.email = 'Email is required'
  else if (hasInjectionRisk(email.value)) errors.value.email = 'Email contains unsafe characters'
  if (!phone.value.trim()) errors.value.phone = 'Philippine phone number is required'
  else if (!validatePhone(phone.value)) errors.value.phone = 'Enter a valid PH number (e.g. 0917 123 4567)'
  else if (hasInjectionRisk(phone.value)) errors.value.phone = 'Phone contains unsafe characters'
  if (!selectedProvince.value) errors.value.province = 'Select your province'
  if (!selectedCity.value) errors.value.city = 'Select your city or municipality'
  if (!barangay.value.trim()) errors.value.barangay = 'Barangay is required'
  else if (!isSafeText(barangay.value) || hasInjectionRisk(barangay.value)) errors.value.barangay = 'Barangay contains unsafe characters'
  if (!street.value.trim()) errors.value.street = 'Street address is required'
  else if (!isSafeText(street.value) || hasInjectionRisk(street.value)) errors.value.street = 'Street address contains unsafe characters'
  if (!password.value) errors.value.password = 'Password is required'
  else if (!passwordIsValid.value) errors.value.password = 'Password must meet all requirements below'
  if (password.value !== confirmPassword.value) errors.value.confirmPassword = 'Passwords do not match'
  if (Object.keys(errors.value).length) return

  isLoading.value = true
  try {
    const phoneNormalized = normalizePhoneForApi(phone.value)
    const payload = {
      full_name: fullName.value.trim(),
      email: email.value.trim().toLowerCase(),
      phone: phoneNormalized,
      province_code: selectedProvince.value!,
      city_code: selectedCity.value!,
      barangay: barangay.value.trim(),
      street_address: street.value.trim(),
      password: password.value,
      account_type: accountType.value,
      marketing_consent: marketingConsent.value,
      ...(accountType.value === 'car_owner' && businessName.value.trim()
        ? {
            business_name: businessName.value.trim(),
            ...(rentalBio.value.trim() && { bio: rentalBio.value.trim() }),
            ...(rentalCity.value.trim() && { city: rentalCity.value.trim() }),
            ...(rentalProvince.value.trim() && { province: rentalProvince.value.trim() }),
            ...(rentalAddress.value.trim() && { address: rentalAddress.value.trim() }),
            ...(businessPermitNumber.value.trim() && { business_permit_number: businessPermitNumber.value.trim() }),
            ...(businessAddress.value.trim() && { business_address: businessAddress.value.trim() }),
          }
        : {}),
    }
    await registerMutation.mutateAsync(payload)
  } catch (err: unknown) {
    const res = (err as { response?: { data?: { errors?: Record<string, string[]> } } })?.response?.data
    const errMap = res?.errors
    if (errMap) {
      for (const [key, messages] of Object.entries(errMap)) {
        const k = key === 'full_name' ? 'fullName' : key === 'street_address' ? 'street' : key
        ;(errors.value as Record<string, string>)[k] = Array.isArray(messages) ? messages[0] : String(messages)
      }
    } else {
      errors.value.email = (res as { message?: string })?.message ?? 'Registration failed. Please try again.'
    }
  } finally {
    isLoading.value = false
  }
}
</script>

<style scoped>
/* Reuse same tokens and layout as LoginView – single panel, no strip */
.auth-page {
  --auth-trust: #0f172a;
  --auth-trust-dark: #052e42;
  --auth-black: #0a0a0c;
  --auth-cyan: #0ea5e9;
  --auth-sky: #0284c7;
  --auth-sky-600: #1e40af;
  --auth-metal-border: linear-gradient(135deg, rgba(255,255,255,0.35) 0%, rgba(200,210,220,0.2) 50%, rgba(0,0,0,0.15) 100%);
  --auth-metal-badge: linear-gradient(180deg, rgba(255,255,255,0.18) 0%, rgba(240,245,250,0.12) 40%, rgba(20,25,35,0.2) 100%);
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
  padding: 1.25rem 1.5rem;
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
  max-width: 580px;
  display: flex;
  align-items: center;
  justify-content: center;
  padding: 1rem 0;
  box-sizing: border-box;
  position: relative;
  z-index: 1;
}

.auth-form-card {
  width: 100%;
  max-width: 540px;
  padding: 1.35rem 1.5rem;
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
  margin-bottom: 0.6rem;
  display: block;
  text-align: center;
}
.auth-logo-img {
  height: 44px;
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
  font-size: 0.8125rem;
  color: var(--text-secondary, #64748b);
  margin: 0 0 0.5rem;
  line-height: 1.4;
  font-weight: 500;
}

.auth-title {
  font-size: 1.5rem;
  font-weight: 800;
  letter-spacing: -0.03em;
  margin: 0 0 0.2rem;
  line-height: 1.2;
  background: linear-gradient(135deg, var(--auth-trust) 0%, #1e3a5f 100%);
  -webkit-background-clip: text;
  background-clip: text;
  -webkit-text-fill-color: transparent;
  color: var(--auth-trust);
}

.auth-subtitle {
  font-size: 0.9375rem;
  color: var(--text-secondary, #64748b);
  margin: 0 0 0.5rem;
  font-weight: 500;
  line-height: 1.45;
}

.auth-role-indicator-row {
  display: flex;
  align-items: center;
  gap: 0.5rem;
  margin-bottom: 0.6rem;
  flex-wrap: wrap;
}
.auth-role-indicator {
  display: inline-flex;
  align-items: center;
  gap: 0.4rem;
  padding: 0.35rem 0.75rem;
  border-radius: 999px;
  font-size: 0.8125rem;
  font-weight: 600;
  letter-spacing: 0.02em;
}
.auth-role-indicator--renter {
  background: rgba(30, 58, 95, 0.12);
  color: var(--role-primary);
  border: 1px solid rgba(30, 58, 95, 0.35);
}
.auth-role-indicator--car-owner {
  background: rgba(4, 120, 87, 0.12);
  color: #047857;
  border: 1px solid rgba(4, 120, 87, 0.35);
}
.auth-role-indicator--marketing-partner {
  background: rgba(91, 33, 182, 0.12);
  color: #5b21b6;
  border: 1px solid rgba(91, 33, 182, 0.35);
}
.auth-role-change {
  font-size: 0.875rem;
  font-weight: 600;
  color: #0284c7;
  background: none;
  border: none;
  padding: 0.35rem 0;
  cursor: pointer;
  text-decoration: underline;
  text-underline-offset: 2px;
}
.auth-role-change:hover {
  color: #0369a1;
}

.auth-form-card--renter::before {
  background: linear-gradient(90deg, var(--role-primary-dark), var(--role-primary));
}
.auth-form-card--renter {
  border-color: rgba(30, 58, 95, 0.25);
  box-shadow:
    0 3px 0 0 rgba(30, 58, 95, 0.2),
    0 1px 0 rgba(255, 255, 255, 0.95) inset,
    0 0 0 1px rgba(255, 255, 255, 0.6) inset,
    0 4px 24px rgba(30, 58, 95, 0.08),
    0 24px 48px -12px rgba(15, 23, 42, 0.14);
}
.auth-form-card--renter .auth-form-section-title {
  color: var(--role-primary);
  border-bottom-color: rgba(30, 58, 95, 0.25);
}

.auth-form-card--car-owner::before {
  background: linear-gradient(90deg, #059669, #047857);
}
.auth-form-card--car-owner {
  border-color: rgba(4, 120, 87, 0.25);
  box-shadow:
    0 3px 0 0 rgba(4, 120, 87, 0.2),
    0 1px 0 rgba(255, 255, 255, 0.95) inset,
    0 0 0 1px rgba(255, 255, 255, 0.6) inset,
    0 4px 24px rgba(4, 120, 87, 0.08),
    0 24px 48px -12px rgba(15, 23, 42, 0.14);
}
.auth-form-card--car-owner .auth-form-section-title {
  color: #047857;
  border-bottom-color: rgba(4, 120, 87, 0.25);
}

.auth-form-card--marketing-partner::before {
  background: linear-gradient(90deg, #6d28d9, #5b21b6);
}
.auth-form-card--marketing-partner {
  border-color: rgba(91, 33, 182, 0.25);
  box-shadow:
    0 3px 0 0 rgba(91, 33, 182, 0.2),
    0 1px 0 rgba(255, 255, 255, 0.95) inset,
    0 0 0 1px rgba(255, 255, 255, 0.6) inset,
    0 4px 24px rgba(91, 33, 182, 0.08),
    0 24px 48px -12px rgba(15, 23, 42, 0.14);
}
.auth-form-card--marketing-partner .auth-form-section-title {
  color: #5b21b6;
  border-bottom-color: rgba(91, 33, 182, 0.25);
}

.auth-form-grid {
  width: 100%;
}
.auth-form-section {
  margin-bottom: 0.75rem;
}
.auth-form-section:last-of-type {
  margin-bottom: 0.25rem;
}
.auth-form-section-title {
  font-size: 0.75rem;
  font-weight: 700;
  letter-spacing: 0.04em;
  text-transform: uppercase;
  color: var(--auth-sky-600, #0284c7);
  margin: 0 0 0.35rem;
  padding-bottom: 0.15rem;
  border-bottom: 1px solid rgba(14, 165, 233, 0.2);
}
.auth-form-row {
  margin-bottom: 0.1rem;
}
.auth-form-row .v-col {
  padding-top: 0.15rem;
  padding-bottom: 0.15rem;
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
.auth-phone-prefix {
  display: inline-flex;
  align-items: center;
  gap: 0.25rem;
  font-size: 0.875rem;
  font-weight: 600;
  color: var(--text-secondary);
  margin-right: 0.25rem;
  white-space: nowrap;
}
.auth-field-phone :deep(.v-field__input) {
  padding-inline-start: 0.25rem;
}

.auth-form-section :deep(.pwd-strength) {
  margin-top: 0.15rem;
  margin-bottom: 0.5rem;
  padding: 0.5rem 0.65rem;
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
.auth-checkbox-spacing {
  margin-bottom: 0.35rem !important;
}
.auth-submit-btn-spacing {
  margin-bottom: 0.75rem !important;
}

.auth-switch-text {
  font-size: 0.875rem;
  color: var(--text-secondary, #64748b);
  margin: 0.25rem 0 0;
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
  background-image: url('/images/register-hero.png');
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
    padding: 1.35rem 1.5rem;
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
    padding: 1.25rem 1.25rem;
    border-radius: 18px;
  }
  .auth-title {
    font-size: 1.45rem;
  }
  .auth-subtitle {
    font-size: 0.95rem;
    margin-bottom: 0.5rem;
  }
  .auth-form-section-title {
    font-size: 0.75rem;
  }
  .auth-role-indicator-row {
    flex-direction: column;
    align-items: flex-start;
    gap: 0.5rem;
  }
  .auth-hero-side {
    display: none;
  }
}
</style>
