<template>
  <DashboardTemplate
    title="Company profile"
    subtitle="Edit your car rental company details and logo."
    :animate="true"
    :back-to="{ name: 'car-owner-dashboard' }"
    back-label="Back to dashboard"
  >
    <v-card elevation="0" rounded="lg" class="modern-card section-card-accent mb-4">
      <div class="section-card-header">
        <div class="section-card-icon">
          <v-icon icon="mdi-storefront" size="20" />
        </div>
        <span class="section-card-title">Company details</span>
      </div>
      <v-divider class="settings-divider" />
      <v-card-text class="pa-4">
        <v-row dense align="start">
          <v-col cols="12" md="4" lg="3" class="d-flex justify-center justify-md-start">
            <div class="logo-upload-wrap">
              <v-avatar :size="100" rounded="lg" class="rental-logo">
                <v-img v-if="form.logoUrl" :src="resolveImageUrl(form.logoUrl) ?? form.logoUrl" cover />
                <v-icon v-else size="40" color="grey">mdi-storefront-outline</v-icon>
              </v-avatar>
              <input
                ref="logoInputRef"
                type="file"
                accept="image/*"
                class="logo-input-hidden"
                @change="onLogoChange"
              />
              <v-btn
                variant="outlined"
                size="small"
                class="mt-1"
                rounded="lg"
                prepend-icon="mdi-camera"
                block
                @click="logoInputRef?.click()"
              >
                Upload logo
              </v-btn>
            </div>
          </v-col>
          <v-col cols="12" md="8" lg="9">
            <div class="profile-fields">
              <v-text-field
                :model-value="form.businessName"
                @update:model-value="(v) => form.businessName = formatInput(v, 'address')"
                label="Company / Rental name *"
                placeholder="e.g. Juan's Car Rental"
                variant="outlined"
                density="comfortable"
                hide-details
                class="mb-3"
              />
              <HpaFormFieldHint hint="This name appears on your listings and when clients browse rentals." />
              <v-textarea
                v-model="form.bio"
                label="Bio / About your rental"
                placeholder="Tell clients about your fleet, service, and what makes you different."
                variant="outlined"
                density="comfortable"
                rows="3"
                hide-details
                class="mb-3"
              />
              <v-text-field
                :model-value="form.businessPermitNumber"
                @update:model-value="(v) => form.businessPermitNumber = formatInput(v, 'idNumber')"
                label="Business permit number"
                placeholder="e.g. BP-2024-001"
                variant="outlined"
                density="comfortable"
                hide-details
              />
            </div>
          </v-col>
        </v-row>
      </v-card-text>
    </v-card>

    <v-card elevation="0" rounded="lg" class="modern-card section-card-accent mb-4">
      <div class="section-card-header">
        <div class="section-card-icon">
          <v-icon icon="mdi-map-marker" size="20" />
        </div>
        <span class="section-card-title">Location & contact</span>
      </div>
      <v-divider class="settings-divider" />
      <v-card-text class="pa-4">
        <v-row dense>
          <v-col cols="12" md="6">
            <v-text-field
              :model-value="form.city"
              @update:model-value="(v) => form.city = formatInput(v, 'letters')"
              label="City"
              placeholder="e.g. Vigan, Cauayan"
              variant="outlined"
              density="comfortable"
              hide-details
              class="mb-3"
            />
          </v-col>
          <v-col cols="12" md="6">
            <v-text-field
              :model-value="form.province"
              @update:model-value="(v) => form.province = formatInput(v, 'letters')"
              label="Province / Region"
              placeholder="e.g. Ilocos Sur, Isabela"
              variant="outlined"
              density="comfortable"
              hide-details
              class="mb-3"
            />
          </v-col>
          <v-col cols="12">
            <v-text-field
              :model-value="form.address"
              @update:model-value="(v) => form.address = formatInput(v, 'address')"
              label="Full address"
              placeholder="Street, barangay, city, province"
              variant="outlined"
              density="comfortable"
              hide-details
              class="mb-3"
            />
          </v-col>
          <v-col cols="12" md="6">
            <v-text-field
              :model-value="form.phone"
              @update:model-value="(v) => form.phone = formatInput(v, 'phone')"
              label="Contact phone"
              placeholder="09XX XXX XXXX"
              variant="outlined"
              density="comfortable"
              hide-details
              class="mb-3"
            />
          </v-col>
          <v-col cols="12" md="6">
            <v-text-field
              v-model="form.email"
              label="Contact email"
              type="email"
              placeholder="hello@yourrental.com"
              variant="outlined"
              density="comfortable"
              hide-details
            />
          </v-col>
        </v-row>
      </v-card-text>
    </v-card>

    <div class="profile-actions d-flex flex-wrap">
      <v-btn
        color="primary"
        variant="flat"
        rounded="lg"
        prepend-icon="mdi-content-save"
        :loading="saving"
        class="profile-actions__btn"
        @click="saveProfile"
      >
        Save profile
      </v-btn>
      <v-btn
        variant="outlined"
        rounded="lg"
        prepend-icon="mdi-close"
        :disabled="saving"
        class="profile-actions__btn"
        :to="{ name: 'car-owner-dashboard' }"
      >
        Cancel
      </v-btn>
    </div>

    <p v-if="saved && savedToServer" class="text-body-2 text-success mt-3 mb-0">
      <v-icon size="18" color="success">mdi-check-circle</v-icon>
      Profile saved. Clients can now find you when browsing car rentals.
    </p>
    <p v-else-if="saved && !savedToServer" class="text-body-2 text-warning mt-3 mb-0">
      <v-icon size="18" color="warning">mdi-alert-circle</v-icon>
      Saved locally only. Start the backend (e.g. <code>php artisan serve</code>) and save again to store in the database.
    </p>
  </DashboardTemplate>
</template>

<script setup lang="ts">
import { ref, computed, onMounted, watch, nextTick } from 'vue'
import DashboardTemplate from '@/components/DashboardTemplate.vue'
import HpaFormFieldHint from '@/components/base/HpaFormFieldHint.vue'
import { useCarRentalProfiles } from '@/composables/useCarRentalProfiles'
import { useToastStore } from '@/stores/toast'
import { fileToDataUrl } from '@/composables/useImageUpload'
import { formatInput } from '@/utils/inputFormatters'
import { resolveImageUrl } from '@/constants/images'

const { myRentalProfile, fetchMyProfile, updateMyProfile, uploadLogo } = useCarRentalProfiles()
const toast = useToastStore()

const logoInputRef = ref<HTMLInputElement | null>(null)
const saving = ref(false)
const saved = ref(false)
const savedToServer = ref(false)

const form = ref({
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

const profileSlug = computed(() => {
  const name = form.value.businessName?.trim()
  if (!name) return ''
  return name.toLowerCase().replace(/[^a-z0-9]+/g, '-').replace(/^-|-$/g, '')
})

watch(
  myRentalProfile,
  (p) => {
    if (p) {
      form.value = {
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

onMounted(async () => {
  await fetchMyProfile()
  await nextTick()
  const p = myRentalProfile.value
  if (p) {
    form.value = {
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
})

async function onLogoChange(e: Event) {
  const input = e.target as HTMLInputElement
  const file = input.files?.[0]
  if (!file || !file.type.startsWith('image/')) return
  try {
    const url = await uploadLogo(file)
    if (url) {
      form.value.logoUrl = url
      toast.success('Logo uploaded.')
    } else {
      const dataUrl = await fileToDataUrl(file)
      form.value.logoUrl = dataUrl
      toast.success('Logo saved.')
    }
    // Persist immediately so logo is not lost when navigating away
    await persistFormAfterLogoUpload()
  } catch {
    toast.error('Failed to upload logo.')
  }
  input.value = ''
}

/** Save current form to storage/API after logo change so it persists across navigation. */
async function persistFormAfterLogoUpload() {
  const payload = {
    businessName: form.value.businessName?.trim() || undefined,
    logoUrl: form.value.logoUrl,
    bio: form.value.bio || undefined,
    city: form.value.city || undefined,
    province: form.value.province || undefined,
    address: form.value.address || undefined,
    phone: form.value.phone || undefined,
    email: form.value.email || undefined,
    businessPermitNumber: form.value.businessPermitNumber || undefined,
    businessAddress: form.value.businessAddress || undefined,
  }
  const { profile: result } = await updateMyProfile(payload)
  if (result) {
    // Sync form from updated profile so storedProfile and form stay in sync
    form.value.logoUrl = result.logoUrl ?? form.value.logoUrl
  }
}

async function saveProfile() {
  if (!form.value.businessName?.trim()) {
    toast.error('Please enter your company name.')
    return
  }
  saving.value = true
  saved.value = false
  savedToServer.value = false
  try {
    const { profile: result, savedToServer: toServer } = await updateMyProfile({
      businessName: form.value.businessName.trim(),
      logoUrl: form.value.logoUrl,
      bio: form.value.bio || undefined,
      city: form.value.city || undefined,
      province: form.value.province || undefined,
      address: form.value.address || undefined,
      phone: form.value.phone || undefined,
      email: form.value.email || undefined,
      businessPermitNumber: form.value.businessPermitNumber || undefined,
      businessAddress: form.value.businessAddress || undefined,
    })
    if (result) {
      saved.value = true
      savedToServer.value = toServer
      if (toServer) {
        toast.success('Profile saved.')
      } else {
        toast.warning('Saved locally only. Server could not be updated. Check that the backend is running and you are logged in.')
      }
    } else {
      toast.error('Could not save profile.')
    }
  } finally {
    saving.value = false
  }
}
</script>

<style scoped>
.logo-upload-wrap {
  width: 120px;
  flex-shrink: 0;
}
.profile-fields {
  min-width: 0;
}
.rental-logo {
  background: rgba(var(--v-theme-surface-variant), 0.3);
}
.logo-input-hidden {
  position: absolute;
  width: 0;
  height: 0;
  opacity: 0;
  pointer-events: none;
}
.settings-divider {
  border-color: rgba(0, 0, 0, 0.06);
}
.profile-actions {
  gap: 1rem;
}
</style>
