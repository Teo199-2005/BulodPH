<template>
  <DashboardTemplate title="ID Verification" subtitle="Upload your ID and driver's license to get verified." :animate="true">
    <v-row>
      <v-col cols="12" md="7">
        <v-card class="kyc-section modern-card" elevation="0" rounded="lg">
          <div class="kyc-section__accent" />
          <div class="kyc-section__header">
            <div class="kyc-section__icon"><v-icon icon="mdi-file-upload" size="22" /></div>
            <span class="kyc-section__title">Upload documents</span>
          </div>
          <v-divider class="mx-4" />
          <v-card-text class="pa-4">
            <v-form @submit.prevent="handleSubmit">
              <v-text-field
                v-model="idType"
                label="ID type *"
                placeholder="Passport, National ID, etc."
                variant="outlined"
                density="compact"
                :error-messages="errors.idType"
              />
              <v-text-field
                v-model="idNumber"
                label="ID number (optional)"
                variant="outlined"
                density="compact"
                class="mt-3"
                :error-messages="errors.idNumber"
              />
              <v-file-input
                v-model="idFront"
                label="ID front (optional)"
                variant="outlined"
                density="compact"
                class="mt-3"
                accept="image/*,application/pdf"
                :error-messages="errors.idFront"
              />
              <v-file-input
                v-model="idBack"
                label="ID back (optional)"
                variant="outlined"
                density="compact"
                class="mt-3"
                accept="image/*,application/pdf"
                :error-messages="errors.idBack"
              />
              <v-file-input
                v-model="driversLicense"
                label="Driver's license (optional)"
                variant="outlined"
                density="compact"
                class="mt-3"
                accept="image/*,application/pdf"
                :error-messages="errors.driversLicense"
              />
              <v-file-input
                v-model="selfie"
                label="Selfie (optional)"
                variant="outlined"
                density="compact"
                class="mt-3"
                accept="image/*"
                :error-messages="errors.selfie"
              />
              <v-btn
                color="primary"
                variant="flat"
                class="mt-3"
                rounded="lg"
                type="submit"
                :disabled="isSubmitting || !canSubmit"
                :loading="isSubmitting"
              >
                Submit verification
              </v-btn>
            </v-form>
          </v-card-text>
        </v-card>
      </v-col>
      <v-col cols="12" md="5">
        <v-card class="kyc-section modern-card" elevation="0" rounded="lg">
          <div class="kyc-section__accent kyc-section__accent--status" />
          <div class="kyc-section__header">
            <div class="kyc-section__icon kyc-section__icon--status"><v-icon icon="mdi-shield-check" size="22" /></div>
            <span class="kyc-section__title">Verification status</span>
          </div>
          <v-divider class="mx-4" />
          <v-card-text class="pa-4">
            <p v-if="loadingStatus" class="text-body-2 text-medium-emphasis mb-0">Loading…</p>
            <template v-else-if="kycStatus">
              <p class="text-body-2 font-weight-medium mb-1">Status: <v-chip :color="statusColor(kycStatus.status)" :prepend-icon="getStatusIcon(kycStatus.status)" size="small" variant="tonal">{{ kycStatus.status }}</v-chip></p>
              <p v-if="kycStatus.rejection_reason" class="text-body-2 text-error mb-0">{{ kycStatus.rejection_reason }}</p>
              <p v-else class="text-body-2 text-medium-emphasis mb-0">We will email you once verified.</p>
            </template>
            <p v-else class="text-body-2 text-medium-emphasis mb-0">No submission yet. Submit your documents above.</p>
          </v-card-text>
        </v-card>
      </v-col>
    </v-row>
  </DashboardTemplate>
</template>

<script setup lang="ts">
import { computed, ref, onMounted } from 'vue'
import DashboardTemplate from '@/components/DashboardTemplate.vue'
import { useToastStore } from '@/stores/toast'
import * as kycApi from '@/services/kyc'
import type { KycStatusRecord } from '@/services/kyc'
import {
  ID_NUMBER_REGEX,
  LETTERS_ONLY_REGEX,
  hasInjectionRisk,
  sanitizeBasicText,
  validateFiles,
} from '@/utils/inputValidation'

const toast = useToastStore()
const idType = ref('')
const idNumber = ref('')
const idFront = ref<File[] | File | null>(null)
const idBack = ref<File[] | File | null>(null)
const driversLicense = ref<File[] | File | null>(null)
const selfie = ref<File[] | File | null>(null)
const isSubmitting = ref(false)
const loadingStatus = ref(true)
const kycStatus = ref<KycStatusRecord | null>(null)
const errors = ref<{
  idType?: string
  idNumber?: string
  idFront?: string
  idBack?: string
  driversLicense?: string
  selfie?: string
}>({})

const canSubmit = computed(() => idType.value.trim().length > 0)

function statusColor(s: string): string {
  const lower = s?.toLowerCase() ?? ''
  if (lower === 'approved' || lower === 'verified') return 'success'
  if (lower === 'rejected') return 'error'
  return 'warning'
}

function getStatusIcon(s: string): string {
  const lower = s?.toLowerCase() ?? ''
  if (lower === 'approved' || lower === 'verified') return 'mdi-check-circle'
  if (lower === 'rejected') return 'mdi-close-circle'
  return 'mdi-clock-outline'
}

async function loadStatus() {
  loadingStatus.value = true
  try {
    kycStatus.value = await kycApi.getKycStatus()
  } catch {
    kycStatus.value = null
  } finally {
    loadingStatus.value = false
  }
}

onMounted(loadStatus)

async function handleSubmit() {
  errors.value = {}
  idType.value = sanitizeBasicText(idType.value)
  idNumber.value = sanitizeBasicText(idNumber.value)

  if (!idType.value.trim()) {
    errors.value.idType = 'ID type is required'
  } else if (hasInjectionRisk(idType.value)) {
    errors.value.idType = 'Please remove unsafe characters'
  }
  if (idNumber.value && (hasInjectionRisk(idNumber.value) || !ID_NUMBER_REGEX.test(idNumber.value))) {
    errors.value.idNumber = 'ID number: letters/numbers only'
  }

  const fileOpt = { maxSizeMb: 5, allowedTypes: ['image/png', 'image/jpeg', 'image/webp', 'application/pdf'] }
  errors.value.idFront = validateFiles(idFront.value, { ...fileOpt, required: false, label: 'ID front' }) || undefined
  errors.value.idBack = validateFiles(idBack.value, { ...fileOpt, required: false, label: 'ID back' }) || undefined
  errors.value.driversLicense = validateFiles(driversLicense.value, { ...fileOpt, required: false, label: "Driver's license" }) || undefined
  errors.value.selfie = validateFiles(selfie.value, { maxSizeMb: 5, allowedTypes: ['image/png', 'image/jpeg', 'image/webp'], required: false, label: 'Selfie' }) || undefined

  if (Object.values(errors.value).some(Boolean)) return

  const front = Array.isArray(idFront.value) ? idFront.value[0] : idFront.value
  const back = Array.isArray(idBack.value) ? idBack.value[0] : idBack.value
  const license = Array.isArray(driversLicense.value) ? driversLicense.value[0] : driversLicense.value
  const selfieFile = Array.isArray(selfie.value) ? selfie.value[0] : selfie.value

  isSubmitting.value = true
  try {
    await kycApi.submitKyc({
      id_type: idType.value,
      id_number: idNumber.value || undefined,
      id_front: front as File | undefined,
      id_back: back as File | undefined,
      license: license as File | undefined,
      selfie: selfieFile as File | undefined,
    })
    toast.success('Verification submitted. We will email you once verified.')
    await loadStatus()
  } catch (e) {
    toast.error(e instanceof Error ? e.message : 'Could not submit verification.')
  } finally {
    isSubmitting.value = false
  }
}
</script>

<style scoped>
.kyc-section {
  position: relative;
  overflow: hidden;
  border: 1px solid rgba(var(--v-border-color), var(--v-border-opacity));
}

.kyc-section__accent {
  position: absolute;
  top: 0;
  left: 0;
  width: 4px;
  height: 100%;
  background: rgb(var(--v-theme-primary));
  border-radius: 4px 0 0 4px;
}

.kyc-section__accent--status {
  background: linear-gradient(to bottom, rgb(76, 175, 80), rgba(76, 175, 80, 0.5));
}

.kyc-section__header {
  display: flex;
  align-items: center;
  gap: 0.75rem;
  padding: 1rem 1rem 0.5rem;
}

.kyc-section__icon {
  width: 40px;
  height: 40px;
  border-radius: 10px;
  background: rgba(var(--v-theme-primary), 0.1);
  color: rgb(var(--v-theme-primary));
  display: flex;
  align-items: center;
  justify-content: center;
}

.kyc-section__icon--status {
  background: rgba(76, 175, 80, 0.12);
  color: rgb(76, 175, 80);
}

.kyc-section__title {
  font-size: 1rem;
  font-weight: 700;
  color: rgb(var(--v-theme-on-surface));
}
</style>
