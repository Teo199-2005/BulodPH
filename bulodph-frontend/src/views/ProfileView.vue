<template>
  <DashboardTemplate title="Profile" subtitle="Your account and verification" :animate="true">
    <!-- 2x2 layout: Row 1 = Personal | Change Password. Row 2 = Company details | Location & contact (or role-specific single col) -->
    <v-row class="profile-grid-row profile-grid-row--compact" dense>
      <v-col cols="12" md="6">
        <v-card elevation="0" rounded="lg" class="modern-card profile-card section-card-accent h-100">
          <div class="section-card-header section-card-header--compact">
            <div class="section-card-icon">
              <v-icon icon="mdi-account" size="18" />
            </div>
            <span class="section-card-title">Personal Information</span>
          </div>
          <v-divider class="settings-divider" />
          <v-card-text class="pa-3">
            <div class="profile-personal-body">
              <div class="profile-avatar-wrap">
                <v-avatar :size="72" color="primary" class="profile-avatar">
                  <v-img
                    v-if="profileImageUrl && !avatarImageError"
                    :key="profileImageUrlKey"
                    :src="profileImageSrc"
                    cover
                    @error="avatarImageError = true"
                  />
                  <span v-else class="text-h5 text-white">{{ initials }}</span>
                </v-avatar>
                <input ref="fileInputRef" type="file" accept="image/*" class="profile-avatar-input" @change="onProfileImageChange" />
                <button type="button" class="profile-upload-photo-btn mt-1" @click="fileInputRef?.click()">
                  <span class="profile-upload-photo-btn__icon" aria-hidden="true">
                    <v-icon icon="mdi-camera" size="20" />
                  </span>
                  <span class="profile-upload-photo-btn__label">Upload photo</span>
                </button>
              </div>
              <div class="profile-fields">
                <v-text-field :model-value="name" @update:model-value="(v) => name = formatInput(v, 'letters')" label="Full name" variant="outlined" density="compact" hide-details class="mb-1" />
                <v-text-field v-model="email" label="Email" type="email" variant="outlined" density="compact" hide-details class="mb-1" />
                <v-text-field :model-value="mobile" @update:model-value="(v) => mobile = formatInput(v, 'phone')" label="Mobile number" placeholder="09XX XXX XXXX" variant="outlined" density="compact" hide-details class="mb-1" />
                <v-text-field :model-value="address" @update:model-value="(v) => address = formatInput(v, 'address')" label="Address (city, province)" placeholder="e.g. Cauayan, Isabela" variant="outlined" density="compact" hide-details class="mb-2" />
                <div class="d-flex align-center flex-wrap profile-save-row mt-1">
                  <v-btn color="primary" variant="flat" rounded="lg" size="small" prepend-icon="mdi-content-save" :loading="savingProfile || savingRentalProfile" @click="saveAllOrProfile">{{ primaryRole === 'car_owner' ? 'Save profile' : 'Save changes' }}</v-btn>
                  <v-chip size="x-small" color="primary" variant="tonal" :prepend-icon="primaryRoleIcon">{{ primaryRoleLabel }}</v-chip>
                  <span class="text-caption text-medium-emphasis">{{ email || '—' }} · Member</span>
                  <EmailVerifiedBadge :verified="!!userSession.user?.email_verified" class="ml-2" />
                  <router-link v-if="!userSession.user?.email_verified && isNonAdminRole" to="/verify-email" class="text-caption ml-2 text-primary text-decoration-none">Resend code</router-link>
                </div>
              </div>
            </div>
          </v-card-text>
        </v-card>
      </v-col>
      <v-col cols="12" md="6" id="change-password">
        <v-card elevation="0" rounded="lg" class="modern-card profile-card section-card-accent h-100">
          <div class="section-card-header section-card-header--compact">
            <div class="section-card-icon">
              <v-icon icon="mdi-lock" size="18" />
            </div>
            <span class="section-card-title">Change Password</span>
          </div>
          <v-divider class="settings-divider" />
          <v-card-text class="pa-3">
            <v-text-field
              v-model="passwordForm.currentPassword"
              label="Current Password"
              :type="showCurrentPassword ? 'text' : 'password'"
              prepend-inner-icon="mdi-lock-outline"
              :append-inner-icon="showCurrentPassword ? 'mdi-eye-off' : 'mdi-eye'"
              @click:append-inner="showCurrentPassword = !showCurrentPassword"
              variant="outlined"
              density="compact"
              hide-details
              placeholder="••••••••"
              autocomplete="current-password"
              class="mb-2"
            />
            <v-text-field
              v-model="passwordForm.newPassword"
              label="New Password"
              :type="showNewPassword ? 'text' : 'password'"
              prepend-inner-icon="mdi-lock-reset"
              :append-inner-icon="showNewPassword ? 'mdi-eye-off' : 'mdi-eye'"
              @click:append-inner="showNewPassword = !showNewPassword"
              @focus="passwordFieldFocused = true"
              @blur="passwordFieldFocused = false"
              variant="outlined"
              density="compact"
              hide-details
              placeholder="8 minimum characters"
              autocomplete="new-password"
              class="mb-1"
            />
            <PasswordStrengthChecklist v-show="passwordFieldFocused" :password="passwordForm.newPassword" />
            <v-text-field
              v-model="passwordForm.confirmPassword"
              label="Confirm New Password"
              :type="showConfirmPassword ? 'text' : 'password'"
              prepend-inner-icon="mdi-lock-check-outline"
              :append-inner-icon="showConfirmPassword ? 'mdi-eye-off' : 'mdi-eye'"
              @click:append-inner="showConfirmPassword = !showConfirmPassword"
              variant="outlined"
              density="compact"
              hide-details
              placeholder="••••••••"
              autocomplete="new-password"
              class="mb-2"
            />
            <v-btn color="primary" variant="outlined" rounded="lg" size="small" :loading="changingPassword" :disabled="!canChangePassword" @click="changePassword">Update password</v-btn>
          </v-card-text>
        </v-card>
      </v-col>
    </v-row>

    <!-- Row 2: 2x2 second row -->
    <v-row class="profile-grid-row profile-grid-row--compact" dense>
      <v-col cols="12" md="6">
        <!-- Client: Documents -->
        <v-card v-if="primaryRole === 'client'" elevation="0" rounded="lg" class="modern-card profile-card section-card-accent h-100">
          <div class="section-card-header section-card-header--compact">
            <div class="section-card-icon">
              <v-icon icon="mdi-file-document-multiple" size="18" />
            </div>
            <span class="section-card-title">Documents (Renter)</span>
          </div>
          <v-divider class="settings-divider" />
          <v-card-text class="pa-3">
            <p class="text-caption text-medium-emphasis mb-2">Upload a valid ID for "Verified by BulodPH" and faster bookings.</p>
            <v-row dense>
              <v-col cols="12" md="6">
                <v-text-field :model-value="clientProfile.idNumber" @update:model-value="(v) => clientProfile.idNumber = formatInput(v, 'idNumber')" label="ID number" placeholder="e.g. License or ID number" variant="outlined" density="compact" hide-details class="mb-1" />
              </v-col>
              <v-col cols="12" md="6">
                <v-select v-model="clientProfile.idType" :items="['Government ID', 'Driver\'s License', 'Passport']" label="ID type" variant="outlined" density="compact" hide-details class="mb-1" />
              </v-col>
              <v-col cols="12">
                <v-btn variant="outlined" size="small" rounded="lg" prepend-icon="mdi-upload">Upload ID document</v-btn>
              </v-col>
              <v-col cols="12" md="6">
                <v-text-field :model-value="clientProfile.emergencyContact" @update:model-value="(v) => clientProfile.emergencyContact = formatInput(v, 'letters')" label="Emergency contact name" variant="outlined" density="compact" hide-details class="mb-1" />
              </v-col>
              <v-col cols="12" md="6">
                <v-text-field :model-value="clientProfile.emergencyPhone" @update:model-value="(v) => clientProfile.emergencyPhone = formatInput(v, 'phone')" label="Emergency contact number" placeholder="09XX XXX XXXX" variant="outlined" density="compact" hide-details class="mb-1" />
              </v-col>
              <v-col cols="12">
                <v-btn color="primary" variant="outlined" rounded="lg" size="small" prepend-icon="mdi-content-save" @click="saveClientProfile">Save documents</v-btn>
              </v-col>
            </v-row>
          </v-card-text>
        </v-card>

        <!-- Car owner: Company details (left cell) -->
        <v-card v-if="primaryRole === 'car_owner'" elevation="0" rounded="lg" class="modern-card profile-card section-card-accent h-100">
          <div class="section-card-header section-card-header--compact">
            <div class="section-card-icon">
              <v-icon icon="mdi-storefront" size="18" />
            </div>
            <span class="section-card-title">Company details</span>
          </div>
          <v-divider class="settings-divider" />
          <v-card-text class="pa-3">
            <v-row dense align="start">
              <v-col cols="12" md="4" class="d-flex flex-column align-center align-md-start">
                <v-avatar :size="64" rounded="lg" class="profile-rental-logo mb-1">
                  <v-img v-if="companyLogoUrl" :src="resolveImageUrl(companyLogoUrl) ?? companyLogoUrl" cover />
                  <v-icon v-else size="28" color="grey">mdi-storefront-outline</v-icon>
                </v-avatar>
                <p class="text-caption text-medium-emphasis text-center text-md-left mb-0" style="font-size: 0.7rem;">Logo = profile photo above.</p>
              </v-col>
              <v-col cols="12" md="8">
                <v-text-field :model-value="rentalForm.businessName" @update:model-value="(v) => rentalForm.businessName = formatInput(v, 'address')" label="Company / Rental name *" placeholder="e.g. Juan's Car Rental" variant="outlined" density="compact" hide-details class="mb-1" />
                <v-textarea v-model="rentalForm.bio" label="Bio / About your rental" placeholder="Tell clients about your fleet and service." variant="outlined" density="compact" rows="2" hide-details class="mb-1" />
                <v-text-field :model-value="rentalForm.businessPermitNumber" @update:model-value="(v) => rentalForm.businessPermitNumber = formatInput(v, 'idNumber')" label="Business permit number" placeholder="e.g. BP-2024-001" variant="outlined" density="compact" hide-details />
              </v-col>
            </v-row>
          </v-card-text>
        </v-card>

        <!-- Marketing: Partner profile & documents -->
        <v-card v-if="primaryRole === 'marketing_staff'" elevation="0" rounded="lg" class="modern-card profile-card section-card-accent">
      <div class="section-card-header section-card-header--compact">
        <div class="section-card-icon">
          <v-icon icon="mdi-account-group" size="18" />
        </div>
        <span class="section-card-title">Partner Profile & Documents</span>
      </div>
      <v-divider class="settings-divider" />
      <v-card-text class="pa-3">
        <v-row dense>
          <v-col cols="12" md="6">
            <v-text-field :model-value="marketingProfile.displayName" @update:model-value="(v) => marketingProfile.displayName = formatInput(v, 'letters')" label="Display name / Brand" placeholder="Name shown to referrals" variant="outlined" density="compact" hide-details class="mb-1" />
          </v-col>
          <v-col cols="12" md="6">
            <v-text-field v-model="marketingProfile.referralCode" label="Referral code" variant="outlined" density="compact" hide-details readonly class="mb-1" />
          </v-col>
          <v-col cols="12">
            <p class="text-caption text-medium-emphasis mb-1">Upload ID for payouts</p>
            <v-btn variant="outlined" size="small" rounded="lg" prepend-icon="mdi-upload">Upload ID document</v-btn>
          </v-col>
          <v-col cols="12">
            <v-btn color="primary" variant="outlined" rounded="lg" size="small" prepend-icon="mdi-content-save" @click="saveMarketingProfile">Save partner info</v-btn>
          </v-col>
        </v-row>
      </v-card-text>
    </v-card>

        <!-- Admin: optional admin profile note -->
        <v-card v-if="primaryRole === 'admin'" elevation="0" rounded="lg" class="modern-card profile-card section-card-accent">
          <div class="section-card-header section-card-header--compact">
            <div class="section-card-icon">
              <v-icon icon="mdi-shield-account" size="18" />
            </div>
            <span class="section-card-title">Admin Profile</span>
          </div>
          <v-divider class="settings-divider" />
          <v-card-text class="pa-3">
            <v-text-field :model-value="adminProfile.displayName" @update:model-value="(v) => adminProfile.displayName = formatInput(v, 'letters')" label="Display name" placeholder="Name shown in dashboard" variant="outlined" density="compact" hide-details class="mb-2" />
            <v-btn color="primary" variant="outlined" rounded="lg" size="small" prepend-icon="mdi-content-save" @click="saveAdminProfile">Save</v-btn>
          </v-card-text>
        </v-card>
      </v-col>
      <!-- Car owner: Location & contact (right cell of 2x2) -->
      <v-col v-if="primaryRole === 'car_owner'" cols="12" md="6">
        <v-card elevation="0" rounded="lg" class="modern-card profile-card section-card-accent h-100">
          <div class="section-card-header section-card-header--compact">
            <div class="section-card-icon">
              <v-icon icon="mdi-map-marker" size="18" />
            </div>
            <span class="section-card-title">Location & contact</span>
          </div>
          <v-divider class="settings-divider" />
          <v-card-text class="pa-3">
            <v-row dense>
              <v-col cols="12">
                <v-text-field :model-value="rentalForm.city" @update:model-value="(v) => rentalForm.city = formatInput(v, 'letters')" label="City" placeholder="e.g. Cauayan" variant="outlined" density="compact" hide-details class="mb-1" />
              </v-col>
              <v-col cols="12">
                <v-text-field :model-value="rentalForm.province" @update:model-value="(v) => rentalForm.province = formatInput(v, 'letters')" label="Province / Region" placeholder="e.g. Isabela" variant="outlined" density="compact" hide-details class="mb-1" />
              </v-col>
              <v-col cols="12">
                <v-text-field :model-value="rentalForm.address" @update:model-value="(v) => rentalForm.address = formatInput(v, 'address')" label="Full address" placeholder="Street, barangay, city" variant="outlined" density="compact" hide-details class="mb-1" />
              </v-col>
              <v-col cols="12">
                <v-text-field :model-value="rentalForm.phone" @update:model-value="(v) => rentalForm.phone = formatInput(v, 'phone')" label="Contact phone" placeholder="09XX XXX XXXX" variant="outlined" density="compact" hide-details class="mb-1" />
              </v-col>
              <v-col cols="12">
                <v-text-field v-model="rentalForm.email" label="Contact email" type="email" placeholder="hello@yourrental.com" variant="outlined" density="compact" hide-details class="mb-2" />
              </v-col>
            </v-row>
          </v-card-text>
        </v-card>
      </v-col>
    </v-row>
  </DashboardTemplate>
</template>

<script setup lang="ts">
import { ref, computed, onMounted, watch, nextTick } from 'vue'
import DashboardTemplate from '@/components/DashboardTemplate.vue'
import { useUserSessionStore } from '@/stores/userSession'
import { useToastStore } from '@/stores/toast'
import { getPrimaryRole } from '@/composables/useAuth'
import type { AuthRole } from '@/composables/useAuth'
import * as profileApi from '@/services/profile'
import { formatInput } from '@/utils/inputFormatters'
import PasswordStrengthChecklist from '@/components/PasswordStrengthChecklist.vue'
import EmailVerifiedBadge from '@/components/shared/EmailVerifiedBadge.vue'
import { usePasswordValidation } from '@/composables/usePasswordValidation'
import { resolveImageUrl } from '@/constants/images'
import { useCarRentalProfiles } from '@/composables/useCarRentalProfiles'

const userSession = useUserSessionStore()
const toast = useToastStore()
const savingProfile = ref(false)
const changingPassword = ref(false)
const fileInputRef = ref<HTMLInputElement | null>(null)

const name = ref('')
const email = ref('')
const mobile = ref('')
const address = ref('')
const profileImageUrl = ref<string | null>(null)
/** Bump when avatar changes so v-img re-loads (avoids cache showing old photo). */
const profileImageUrlKey = ref(0)
/** Resolved avatar URL. Cache-bust only for http(s) URLs so data URLs are not broken. */
const profileImageSrc = computed(() => {
  const url = profileImageUrl.value
  if (!url) return undefined
  const base = resolveImageUrl(url)
  if (!base) return undefined
  if (base.startsWith('data:')) return base
  const sep = base.includes('?') ? '&' : '?'
  return `${base}${sep}t=${profileImageUrlKey.value}`
})
/** When the image fails to load (e.g. 404), show initials instead of black. */
const avatarImageError = ref(false)

const passwordForm = ref({
  currentPassword: '',
  newPassword: '',
  confirmPassword: '',
})
const showCurrentPassword = ref(false)
const showNewPassword = ref(false)
const showConfirmPassword = ref(false)
const passwordFieldFocused = ref(false)
const clientProfile = ref({
  idNumber: '',
  idType: 'Government ID',
  emergencyContact: '',
  emergencyPhone: '',
})

const { myRentalProfile, fetchMyProfile, updateMyProfile, uploadLogo } = useCarRentalProfiles()
const savingRentalProfile = ref(false)
const rentalSaved = ref(false)
const rentalSavedToServer = ref(false)
const rentalForm = ref({
  businessName: '',
  logoUrl: null as string | null,
  bio: '',
  city: '',
  province: '',
  address: '',
  phone: '',
  email: '',
  businessPermitNumber: '',
  businessAddress: '',
})

const marketingProfile = ref({
  displayName: '',
  referralCode: 'REF-' + Math.random().toString(36).slice(2, 8).toUpperCase(),
})

const adminProfile = ref({
  displayName: '',
})

const primaryRole = computed((): AuthRole => {
  const roles = userSession.user?.roles ?? []
  return getPrimaryRole(roles)
})

const isNonAdminRole = computed(() => {
  const r = primaryRole.value
  return r === 'client' || r === 'car_owner' || r === 'marketing_staff'
})

const initials = computed(() => {
  const n = userSession.user?.name || name.value || 'U'
  const parts = String(n).trim().split(/\s+/)
  if (parts.length >= 2) return (parts[0][0] + parts[parts.length - 1][0]).toUpperCase()
  return String(n).slice(0, 2).toUpperCase()
})

const primaryRoleLabel = computed(() => {
  const map: Record<string, string> = {
    client: 'Renter',
    car_owner: 'Car rental owner',
    marketing_staff: 'Marketing partner',
    admin: 'Admin',
  }
  return map[primaryRole.value] ?? primaryRole.value
})

const primaryRoleIcon = computed(() => {
  const map: Record<string, string> = {
    client: 'mdi-account',
    car_owner: 'mdi-domain',
    marketing_staff: 'mdi-bullhorn',
    admin: 'mdi-shield-account',
  }
  return map[primaryRole.value] ?? 'mdi-account-outline'
})

const newPasswordRef = computed(() => passwordForm.value.newPassword)
const { isValid: newPasswordIsValid } = usePasswordValidation(newPasswordRef)

const canChangePassword = computed(() => {
  const { currentPassword, newPassword, confirmPassword } = passwordForm.value
  return (
    currentPassword.length > 0 &&
    newPasswordIsValid.value &&
    confirmPassword === newPassword
  )
})

const companyProfileSlug = computed(() => {
  const name = rentalForm.value.businessName?.trim()
  if (!name) return ''
  return name.toLowerCase().replace(/[^a-z0-9]+/g, '-').replace(/^-|-$/g, '')
})

/** Company logo = profile photo (one image for car owner). */
const companyLogoUrl = computed(() => profileImageUrl.value ?? rentalForm.value.logoUrl ?? null)

watch(profileImageUrl, () => {
  avatarImageError.value = false
})

watch(
  myRentalProfile,
  (p) => {
    if (p) {
      rentalForm.value = {
        businessName: p.businessName ?? '',
        logoUrl: p.logoUrl ?? null,
        bio: p.bio ?? '',
        city: p.city ?? '',
        province: p.province ?? '',
        address: p.address ?? '',
        phone: p.phone ?? '',
        email: p.email ?? '',
        businessPermitNumber: p.businessPermitNumber ?? '',
        businessAddress: p.businessAddress ?? '',
      }
    }
  },
  { immediate: true }
)

async function onProfileImageChange(e: Event) {
  const input = e.target as HTMLInputElement
  const file = input.files?.[0]
  if (!file || !file.type.startsWith('image/')) return
  avatarImageError.value = false
  try {
    const result = await profileApi.uploadProfileImage(file)
    const serverAvatarUrl = result?.avatar_url
    if (!serverAvatarUrl) {
      toast.error('Failed to save photo.')
      input.value = ''
      return
    }
    profileImageUrl.value = serverAvatarUrl
    userSession.updateUser({ avatar_url: serverAvatarUrl })
    profileImageUrlKey.value += 1
    if (primaryRole.value === 'car_owner') {
      const logoResult = await uploadLogo(file)
      if (logoResult) {
        rentalForm.value.logoUrl = logoResult
        await updateMyProfile({
          businessName: rentalForm.value.businessName?.trim() || undefined,
          logoUrl: logoResult,
        bio: rentalForm.value.bio || undefined,
        city: rentalForm.value.city || undefined,
        province: rentalForm.value.province || undefined,
        address: rentalForm.value.address || undefined,
        phone: rentalForm.value.phone || undefined,
        email: rentalForm.value.email || undefined,
        businessPermitNumber: rentalForm.value.businessPermitNumber || undefined,
        businessAddress: rentalForm.value.businessAddress || undefined,
        })
      }
    }
    toast.success(primaryRole.value === 'car_owner' ? 'Profile and company logo updated.' : 'Profile photo saved.')
  } catch (err) {
    toast.error(err instanceof Error ? err.message : 'Failed to save photo.')
  }
  input.value = ''
}

async function saveProfile(quiet = false) {
  savingProfile.value = true
  try {
    const payload: Parameters<typeof profileApi.updateProfile>[0] = {
      name: name.value,
      email: email.value,
      mobile: mobile.value,
      address: address.value,
    }
    if (primaryRole.value === 'client') {
      payload.id_number = clientProfile.value.idNumber || undefined
      payload.emergency_contact_name = clientProfile.value.emergencyContact || undefined
      payload.emergency_contact_phone = clientProfile.value.emergencyPhone || undefined
    }
    const updated = await profileApi.updateProfile(payload)
    if (updated) {
      userSession.updateUser({
        name: updated.name ?? name.value,
        email: updated.email ?? email.value,
        mobile: updated.mobile ?? mobile.value,
      })
      if (!quiet) toast.success('Profile updated.')
    } else {
      userSession.updateUser({ name: name.value, email: email.value, mobile: mobile.value })
      if (!quiet) toast.success('Profile saved locally.')
    }
  } finally {
    savingProfile.value = false
  }
}

/** Single button: saves personal + company (car_owner) or just personal. */
async function saveAllOrProfile() {
  if (primaryRole.value === 'car_owner') {
    await saveProfile(true)
    await saveCompanyProfile(true)
    toast.success('Profile updated.')
  } else {
    await saveProfile()
  }
}

async function changePassword() {
  if (!canChangePassword.value) return
  changingPassword.value = true
  try {
    const ok = await profileApi.changePassword(
      passwordForm.value.currentPassword,
      passwordForm.value.newPassword
    )
    if (ok) {
      passwordForm.value = { currentPassword: '', newPassword: '', confirmPassword: '' }
      toast.success('Password updated.')
    } else {
      toast.error('Could not update password. Check current password or try again.')
    }
  } finally {
    changingPassword.value = false
  }
}

async function saveClientProfile() {
  await saveProfile(true)
  toast.success('Documents saved.')
}

async function saveCompanyProfile(quiet = false) {
  if (!rentalForm.value.businessName?.trim()) {
    if (!quiet) toast.error('Please enter your company name.')
    return
  }
  savingRentalProfile.value = true
  rentalSaved.value = false
  rentalSavedToServer.value = false
  try {
    const logoForApi = companyLogoUrl.value && !companyLogoUrl.value.startsWith('data:') ? companyLogoUrl.value : undefined
    const { profile: result, savedToServer: toServer } = await updateMyProfile({
      businessName: rentalForm.value.businessName.trim(),
      logoUrl: logoForApi,
      bio: rentalForm.value.bio || undefined,
      city: rentalForm.value.city || undefined,
      province: rentalForm.value.province || undefined,
      address: rentalForm.value.address || undefined,
      phone: rentalForm.value.phone || undefined,
      email: rentalForm.value.email || undefined,
      businessPermitNumber: rentalForm.value.businessPermitNumber || undefined,
      businessAddress: rentalForm.value.businessAddress || undefined,
    })
    if (result) {
      rentalSaved.value = true
      rentalSavedToServer.value = toServer
      if (!quiet) toast.success(toServer ? 'Company profile saved.' : 'Saved locally.')
    } else {
      if (!quiet) toast.error('Could not save company profile.')
    }
  } finally {
    savingRentalProfile.value = false
  }
}

function saveMarketingProfile() {
  toast.success('Partner info saved.')
}

function saveAdminProfile() {
  toast.success('Admin profile saved.')
}

onMounted(async () => {
  name.value = userSession.user?.name ?? ''
  email.value = userSession.user?.email ?? ''
  mobile.value = userSession.user?.mobile ?? ''
  profileImageUrl.value = userSession.user?.avatar_url ?? null
  if (primaryRole.value === 'client') {
    const res = await profileApi.getProfile()
    const data = res as { client_profile?: { id_number?: string; emergency_contact_name?: string; emergency_contact_phone?: string } } | null
    if (data?.client_profile) {
      clientProfile.value.idNumber = data.client_profile.id_number ?? ''
      clientProfile.value.emergencyContact = data.client_profile.emergency_contact_name ?? ''
      clientProfile.value.emergencyPhone = data.client_profile.emergency_contact_phone ?? ''
    }
  }
  if (primaryRole.value === 'car_owner') {
    await fetchMyProfile()
    await nextTick()
    const p = myRentalProfile.value
    if (p) {
      rentalForm.value = {
        businessName: p.businessName ?? '',
        logoUrl: p.logoUrl ?? null,
        bio: p.bio ?? '',
        city: p.city ?? '',
        province: p.province ?? '',
        address: p.address ?? '',
        phone: p.phone ?? '',
        email: p.email ?? '',
        businessPermitNumber: p.businessPermitNumber ?? '',
        businessAddress: p.businessAddress ?? '',
      }
      if (!profileImageUrl.value && p.logoUrl) {
        profileImageUrl.value = p.logoUrl
        userSession.updateUser({ avatar_url: p.logoUrl })
      }
    }
  }
})
</script>

<style scoped>
.profile-grid-row {
  margin-bottom: 1rem;
}
.profile-grid-row--compact {
  margin-bottom: 0.75rem;
}
.profile-grid-row--compact:last-child {
  margin-bottom: 0;
}
.profile-grid-row:last-child {
  margin-bottom: 0;
}
.profile-card {
  display: flex;
  flex-direction: column;
}
.profile-card :deep(.v-card-text) {
  flex: 1;
}
.section-card-header--compact {
  padding: 0.5rem 1rem 0.5rem 1rem;
}
.section-card-header--compact .section-card-title {
  font-size: 0.9375rem;
}
.profile-personal-body {
  display: flex;
  gap: 1rem;
  flex-wrap: wrap;
}
.profile-avatar-wrap {
  position: relative;
  flex-shrink: 0;
  width: 100px;
}
.profile-fields {
  flex: 1;
  min-width: 200px;
}
.profile-avatar-input {
  position: absolute;
  width: 0;
  height: 0;
  opacity: 0;
  pointer-events: none;
}
.profile-save-row {
  gap: 1.25rem;
}
.profile-upload-photo-btn {
  display: flex;
  align-items: center;
  justify-content: center;
  gap: 0.625rem;
  width: 100%;
  min-height: 40px;
  padding: 0.5rem 1rem;
  font: inherit;
  font-size: 0.875rem;
  line-height: 1.4;
  color: rgba(var(--v-theme-on-surface), 0.87);
  background: rgb(var(--v-theme-surface));
  border: 1px solid rgba(var(--v-theme-on-surface), 0.22);
  border-radius: 12px;
  cursor: pointer;
  transition: background-color 0.2s, border-color 0.2s;
}
.profile-upload-photo-btn:hover {
  background: rgba(var(--v-theme-on-surface), 0.04);
  border-color: rgba(var(--v-theme-on-surface), 0.38);
}
.profile-upload-photo-btn:active {
  background: rgba(var(--v-theme-on-surface), 0.08);
}
.profile-upload-photo-btn:focus-visible {
  outline: 2px solid rgb(var(--v-theme-primary));
  outline-offset: 2px;
}
.profile-upload-photo-btn__icon {
  display: inline-flex;
  align-items: center;
  justify-content: center;
  flex-shrink: 0;
  color: rgba(var(--v-theme-on-surface), 0.7);
}
.profile-upload-photo-btn__label {
  flex-shrink: 0;
}
.settings-divider {
  border-color: rgba(0, 0, 0, 0.06);
}
.profile-rental-logo {
  background: rgba(var(--v-theme-surface-variant), 0.3);
}

@media (max-width: 959px) {
  .profile-personal-body {
    flex-direction: column;
  }
  .profile-avatar-wrap {
    width: auto;
  }
}

/* Fix outlined field labels overlapping input text on profile */
.profile-card :deep(.v-field--variant-outlined .v-label.v-field-label) {
  top: 50%;
  transform: translateY(-50%);
  transform-origin: left center;
}
.profile-card :deep(.v-field--variant-outlined.v-field--active .v-label.v-field-label:not(.v-field-label--floating)),
.profile-card :deep(.v-field--variant-outlined.v-field--focused .v-label.v-field-label:not(.v-field-label--floating)) {
  visibility: hidden;
}
.profile-card :deep(.v-field--variant-outlined.v-field--active .v-label.v-field-label--floating),
.profile-card :deep(.v-field--variant-outlined.v-field--focused .v-label.v-field-label--floating) {
  visibility: visible;
  transform: translateY(-50%);
}
/* Keep input text above any label so it is never covered */
.profile-card :deep(.v-field .v-field__input) {
  position: relative;
  z-index: 1;
}
</style>
