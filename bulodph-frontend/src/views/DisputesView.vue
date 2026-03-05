<template>
  <DashboardTemplate title="Disputes & Resolution" subtitle="Report issues, upload evidence, and track resolution status.">
    <v-row>
      <v-col cols="12" md="6">
        <v-card class="modern-card" elevation="0" rounded="lg">
          <div class="section-card-header">
            <span class="section-card-title">File a dispute</span>
          </div>
          <v-divider class="dashboard-divider" />
          <v-card-text class="pa-4">
            <v-form @submit.prevent="handleSubmit">
              <v-text-field
                v-model="bookingRef"
                label="Booking reference"
                placeholder="e.g. booking ID (optional)"
                variant="outlined"
                density="compact"
                :error-messages="errors.bookingRef"
              />
              <v-text-field
                v-model="reason"
                label="Reason"
                placeholder="Damage, late return, etc."
                variant="outlined"
                density="compact"
                class="mt-3"
                :error-messages="errors.reason"
                required
              />
              <v-textarea
                v-model="details"
                label="Details"
                variant="outlined"
                rows="4"
                class="mt-3"
                :error-messages="errors.details"
                required
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
                Submit dispute
              </v-btn>
            </v-form>
          </v-card-text>
        </v-card>
      </v-col>
      <v-col cols="12" md="6">
        <v-card class="modern-card" elevation="0" rounded="lg">
          <div class="section-card-header">
            <span class="section-card-title">Your disputes</span>
          </div>
          <v-divider class="dashboard-divider" />
          <v-card-text class="pa-4">
            <p v-if="loading" class="text-body-2 text-medium-emphasis mb-0">Loading…</p>
            <template v-else-if="disputes.length">
              <v-list class="pa-0">
                <v-list-item
                  v-for="d in disputes"
                  :key="d.id"
                  :to="disputeDetailTo(d.id)"
                  class="px-0"
                  rounded="lg"
                >
                  <template #prepend>
                    <v-icon :color="d.status === 'resolved' ? 'success' : 'warning'">mdi-alert-circle-outline</v-icon>
                  </template>
                  <v-list-item-title class="text-body-2">{{ d.reason }}</v-list-item-title>
                  <v-list-item-subtitle class="text-body-2">
                    {{ d.booking_reference ? `Booking ${d.booking_reference}` : 'No booking ref' }} · {{ d.status }}
                  </v-list-item-subtitle>
                  <template #append>
                    <v-icon size="small">mdi-chevron-right</v-icon>
                  </template>
                </v-list-item>
              </v-list>
            </template>
            <p v-else class="text-body-2 text-medium-emphasis mb-0">No disputes yet. File one using the form if you have an issue with a booking.</p>
          </v-card-text>
        </v-card>
      </v-col>
    </v-row>
  </DashboardTemplate>
</template>

<script setup lang="ts">
import { computed, ref, onMounted, watch } from 'vue'
import { useRoute } from 'vue-router'
import DashboardTemplate from '@/components/DashboardTemplate.vue'
import { useToastStore } from '@/stores/toast'
import * as disputesApi from '@/services/disputes'
import type { DisputeRecord } from '@/services/disputes'
import {
  BOOKING_REF_REGEX,
  hasInjectionRisk,
  isSafeText,
  sanitizeBasicText,
} from '@/utils/inputValidation'

const route = useRoute()
const toast = useToastStore()
const bookingRef = ref('')
const reason = ref('')
const details = ref('')
const isSubmitting = ref(false)
const loading = ref(true)
const disputes = ref<DisputeRecord[]>([])
const errors = ref<{ bookingRef?: string; reason?: string; details?: string }>({})

const canSubmit = computed(() => reason.value.trim().length > 0 && details.value.trim().length > 0)

function disputeDetailTo(id: string) {
  const name = route.path.startsWith('/car-owner') ? 'car-owner-dispute-detail' : 'client-dispute-detail'
  return { name, params: { id } }
}

async function loadDisputes() {
  loading.value = true
  try {
    disputes.value = await disputesApi.getDisputes()
  } catch {
    disputes.value = []
  } finally {
    loading.value = false
  }
}

onMounted(() => {
  loadDisputes()
  const bid = route.query.bookingId as string | undefined
  if (bid) bookingRef.value = bid
})
watch(() => route.query.bookingId, (bid) => {
  if (bid) bookingRef.value = String(bid)
})

async function handleSubmit() {
  errors.value = {}
  bookingRef.value = sanitizeBasicText(bookingRef.value)
  reason.value = sanitizeBasicText(reason.value)
  details.value = sanitizeBasicText(details.value)

  if (bookingRef.value) {
    if (!BOOKING_REF_REGEX.test(bookingRef.value)) {
      errors.value.bookingRef = 'Use letters, numbers, dashes, or underscores only'
    } else if (hasInjectionRisk(bookingRef.value)) {
      errors.value.bookingRef = 'Please remove unsafe characters'
    }
  }

  if (!reason.value.trim()) {
    errors.value.reason = 'Reason is required'
  } else if (!isSafeText(reason.value) || hasInjectionRisk(reason.value)) {
    errors.value.reason = 'Reason contains unsafe characters'
  }

  if (!details.value.trim()) {
    errors.value.details = 'Details are required'
  } else if (!isSafeText(details.value) || hasInjectionRisk(details.value)) {
    errors.value.details = 'Details contain unsafe characters'
  }

  if (Object.keys(errors.value).length) return

  isSubmitting.value = true
  try {
    await disputesApi.createDispute({
      booking_reference: bookingRef.value || undefined,
      reason: reason.value,
      description: details.value,
    })
    toast.success('Dispute submitted. Our support team will review it.')
    reason.value = ''
    details.value = ''
    await loadDisputes()
  } catch (e) {
    toast.error(e instanceof Error ? e.message : 'Could not submit dispute.')
  } finally {
    isSubmitting.value = false
  }
}
</script>
