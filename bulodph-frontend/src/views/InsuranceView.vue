<template>
  <DashboardTemplate title="Insurance" subtitle="Select coverage and track claims after your trip." :animate="true">
    <div class="insurance-grid">
      <v-card elevation="0" rounded="lg" class="insurance-section modern-card">
        <div class="insurance-section__accent" />
        <div class="insurance-section__header">
          <div class="insurance-section__icon">
            <v-icon icon="mdi-shield-check" size="22" />
          </div>
          <span class="insurance-section__title">Available plans</span>
        </div>
        <v-divider class="mx-4" />
        <v-card-text class="pa-4">
            <p v-if="loadingPlans" class="text-body-2 text-medium-emphasis mb-0">Loading…</p>
            <template v-else-if="plans.length">
              <v-list class="pa-0">
                <v-list-item v-for="p in plans" :key="p.id" class="px-0" rounded="lg">
                  <v-list-item-title class="text-body-2 font-weight-medium">{{ p.name }}</v-list-item-title>
                  <v-list-item-subtitle class="text-body-2">{{ p.description || '—' }}</v-list-item-subtitle>
                  <template #append>
                    <span class="font-weight-bold text-primary">₱{{ (p.price ?? 0).toLocaleString() }}</span>
                  </template>
                </v-list-item>
              </v-list>
              <p class="text-caption text-medium-emphasis mt-3 mb-0">Select a plan when booking, then you can file a claim below if needed.</p>
            </template>
            <p v-else class="text-body-2 text-medium-emphasis mb-0">No plans available yet.</p>
          </v-card-text>
        </v-card>

      <v-card elevation="0" rounded="lg" class="insurance-section modern-card">
        <div class="insurance-section__accent insurance-section__accent--selections" />
        <div class="insurance-section__header">
          <div class="insurance-section__icon insurance-section__icon--selections">
            <v-icon icon="mdi-clipboard-check" size="22" />
          </div>
          <span class="insurance-section__title">Your selections</span>
        </div>
        <v-divider class="mx-4" />
        <v-card-text class="pa-4">
            <p v-if="loadingSelections" class="text-body-2 text-medium-emphasis mb-0">Loading…</p>
            <template v-else-if="selections.length">
              <v-list class="pa-0">
                <v-list-item v-for="s in selections" :key="s.id" class="px-0" rounded="lg">
                  <v-list-item-title class="text-body-2">Plan {{ s.insurance_plan_id?.slice(0, 8) }} · {{ s.booking_reference || '—' }}</v-list-item-title>
                  <v-list-item-subtitle class="text-body-2">{{ s.status }}</v-list-item-subtitle>
                </v-list-item>
              </v-list>
            </template>
            <p v-else class="text-body-2 text-medium-emphasis mb-0">No selections yet. Select a plan when booking to file claims later.</p>
          </v-card-text>
        </v-card>

      <v-card elevation="0" rounded="lg" class="insurance-section modern-card">
        <div class="insurance-section__accent insurance-section__accent--claim" />
        <div class="insurance-section__header">
          <div class="insurance-section__icon insurance-section__icon--claim">
            <v-icon icon="mdi-file-document-edit" size="22" />
          </div>
          <span class="insurance-section__title">File a claim</span>
        </div>
        <v-divider class="mx-4" />
        <v-card-text class="pa-4">
            <p class="text-body-2 text-medium-emphasis mb-3">You need a plan selection (from a booking) before filing a claim. Select the coverage you used below.</p>
            <v-form @submit.prevent="handleSubmit">
              <v-select
                v-model="selectionId"
                :items="selections"
                item-title="id"
                item-value="id"
                label="Coverage selection *"
                variant="outlined"
                density="compact"
                class="mt-2"
                :error-messages="errors.selectionId"
                :disabled="!selections.length"
              >
                <template #item="{ item, props }">
                  <v-list-item v-bind="props" :title="`${item.raw.insurance_plan_id?.slice(0, 8)} · ${item.raw.booking_reference || '—'}`" />
                </template>
                <template #selection="{ item }">
                  {{ item.raw.insurance_plan_id?.slice(0, 8) }} · {{ item.raw.booking_reference || '—' }}
                </template>
              </v-select>
              <v-textarea
                v-model="claimDetails"
                label="Claim details"
                rows="3"
                variant="outlined"
                density="compact"
                class="mt-3"
                :error-messages="errors.claimDetails"
              />
              <v-text-field
                v-model.number="claimAmount"
                label="Claim amount (optional)"
                type="number"
                min="0"
                step="0.01"
                variant="outlined"
                density="compact"
                class="mt-2"
              />
              <v-file-input
                v-model="evidence"
                label="Evidence (optional)"
                variant="outlined"
                density="compact"
                class="mt-2"
                accept="image/*,application/pdf"
                :error-messages="errors.evidence"
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
                Submit claim
              </v-btn>
            </v-form>
          </v-card-text>
        </v-card>

      <v-card elevation="0" rounded="lg" class="insurance-section modern-card">
        <div class="insurance-section__accent insurance-section__accent--claims" />
        <div class="insurance-section__header">
          <div class="insurance-section__icon insurance-section__icon--claims">
            <v-icon icon="mdi-clipboard-list" size="22" />
          </div>
          <span class="insurance-section__title">Your claims</span>
        </div>
        <v-divider class="mx-4" />
        <v-card-text class="pa-4">
            <p v-if="loadingClaims" class="text-body-2 text-medium-emphasis mb-0">Loading…</p>
            <template v-else-if="claims.length">
              <v-list class="pa-0">
                <v-list-item v-for="c in claims" :key="c.id" class="px-0" rounded="lg">
                  <template #prepend>
                    <v-chip :color="c.status === 'approved' ? 'success' : c.status === 'rejected' ? 'error' : 'warning'" :prepend-icon="c.status === 'approved' ? 'mdi-check-circle' : c.status === 'rejected' ? 'mdi-close-circle' : 'mdi-clock-outline'" size="x-small" variant="tonal">{{ c.status }}</v-chip>
                  </template>
                  <v-list-item-title class="text-body-2">{{ c.description || 'Claim' }}</v-list-item-title>
                  <v-list-item-subtitle class="text-body-2">₱{{ (c.claim_amount ?? 0).toLocaleString() }} · {{ c.status }}</v-list-item-subtitle>
                </v-list-item>
              </v-list>
            </template>
            <p v-else class="text-body-2 text-medium-emphasis mb-0">No claims yet.</p>
          </v-card-text>
        </v-card>
    </div>
  </DashboardTemplate>
</template>

<script setup lang="ts">
import { computed, ref, onMounted } from 'vue'
import DashboardTemplate from '@/components/DashboardTemplate.vue'
import { useToastStore } from '@/stores/toast'
import * as insuranceApi from '@/services/insurance'
import type { InsurancePlanRecord, InsuranceSelectionRecord, InsuranceClaimRecord } from '@/services/insurance'
import { isSafeText, hasInjectionRisk, sanitizeBasicText, validateFiles } from '@/utils/inputValidation'

const toast = useToastStore()
const plans = ref<InsurancePlanRecord[]>([])
const selections = ref<InsuranceSelectionRecord[]>([])
const claims = ref<InsuranceClaimRecord[]>([])
const loadingPlans = ref(true)
const loadingSelections = ref(true)
const loadingClaims = ref(true)
const selectionId = ref<string>('')
const claimDetails = ref('')
const claimAmount = ref<number | ''>('')
const evidence = ref<File[] | File | null>(null)
const isSubmitting = ref(false)
const errors = ref<{ selectionId?: string; claimDetails?: string; evidence?: string }>({})

const canSubmit = computed(() => !!selectionId.value)

async function loadPlans() {
  loadingPlans.value = true
  try {
    plans.value = await insuranceApi.getInsurancePlans()
  } catch {
    plans.value = []
  } finally {
    loadingPlans.value = false
  }
}

async function loadSelections() {
  loadingSelections.value = true
  try {
    selections.value = await insuranceApi.getInsuranceSelections()
  } catch {
    selections.value = []
  } finally {
    loadingSelections.value = false
  }
}

async function loadClaims() {
  loadingClaims.value = true
  try {
    claims.value = await insuranceApi.getInsuranceClaims()
  } catch {
    claims.value = []
  } finally {
    loadingClaims.value = false
  }
}

onMounted(() => {
  loadPlans()
  loadSelections()
  loadClaims()
})

async function handleSubmit() {
  errors.value = {}
  claimDetails.value = sanitizeBasicText(claimDetails.value)

  if (!selectionId.value) {
    errors.value.selectionId = 'Select a coverage (from a booking) to file a claim'
  }
  if (claimDetails.value && (!isSafeText(claimDetails.value) || hasInjectionRisk(claimDetails.value))) {
    errors.value.claimDetails = 'Details contain unsafe characters'
  }
  const file = Array.isArray(evidence.value) ? evidence.value[0] : evidence.value
  const fileErr = validateFiles(file, { required: false, maxSizeMb: 5, allowedTypes: ['image/png', 'image/jpeg', 'image/webp', 'application/pdf'], label: 'Evidence' })
  if (fileErr) errors.value.evidence = fileErr

  if (Object.values(errors.value).some(Boolean)) return

  isSubmitting.value = true
  try {
    await insuranceApi.createInsuranceClaim({
      insurance_selection_id: selectionId.value,
      description: claimDetails.value || undefined,
      claim_amount: typeof claimAmount.value === 'number' && claimAmount.value >= 0 ? claimAmount.value : undefined,
      evidence: file as File | undefined,
    })
    toast.success('Claim submitted. We will review and update you via email.')
    claimDetails.value = ''
    claimAmount.value = ''
    evidence.value = null
    await loadClaims()
  } catch (e) {
    toast.error(e instanceof Error ? e.message : 'Could not submit claim.')
  } finally {
    isSubmitting.value = false
  }
}
</script>

<style scoped>
.insurance-grid {
  display: grid;
  grid-template-columns: 1fr;
  gap: 1.25rem;
}

@media (min-width: 960px) {
  .insurance-grid {
    grid-template-columns: 1fr 1fr;
  }
}

.insurance-section {
  position: relative;
  overflow: hidden;
  border: 1px solid rgba(var(--v-border-color), var(--v-border-opacity));
}

.insurance-section__accent {
  position: absolute;
  top: 0;
  left: 0;
  width: 4px;
  height: 100%;
  background: rgb(var(--v-theme-primary));
  border-radius: 4px 0 0 4px;
}

.insurance-section__accent--selections {
  background: rgb(76, 175, 80);
}

.insurance-section__accent--claim {
  background: linear-gradient(to bottom, rgb(var(--v-theme-primary)), rgba(var(--v-theme-primary), 0.5));
}

.insurance-section__accent--claims {
  background: linear-gradient(to bottom, rgb(255, 152, 0), rgba(255, 152, 0, 0.5));
}

.insurance-section__header {
  display: flex;
  align-items: center;
  gap: 0.75rem;
  padding: 1rem 1rem 0.5rem;
}

.insurance-section__icon {
  width: 40px;
  height: 40px;
  border-radius: 10px;
  background: rgba(var(--v-theme-primary), 0.1);
  color: rgb(var(--v-theme-primary));
  display: flex;
  align-items: center;
  justify-content: center;
}

.insurance-section__icon--selections {
  background: rgba(76, 175, 80, 0.12);
  color: rgb(76, 175, 80);
}

.insurance-section__icon--claim {
  background: rgba(var(--v-theme-primary), 0.12);
}

.insurance-section__icon--claims {
  background: rgba(255, 152, 0, 0.12);
  color: rgb(255, 152, 0);
}

.insurance-section__title {
  font-size: 1rem;
  font-weight: 700;
  color: rgb(var(--v-theme-on-surface));
}
</style>
