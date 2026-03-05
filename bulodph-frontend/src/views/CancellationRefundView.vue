<template>
  <DashboardTemplate title="Cancellations & Refunds" subtitle="Cancel a booking and track refund status." :animate="true">
    <v-alert type="info" variant="tonal" density="compact" class="mb-4" border="start" rounded="lg">
      <p class="text-body-2 mb-1"><strong>Cancellation:</strong> Free cancellation up to 24 hours before pickup. Late cancellations may be subject to fees—see <router-link to="/terms" class="font-weight-medium">Terms</router-link>.</p>
      <p class="text-body-2 mb-0"><strong>Refunds:</strong> If you paid and then cancel, refunds (if any) are processed per our policy. For refund status or disputes, contact support or the car rental directly.</p>
    </v-alert>
    <v-alert type="warning" variant="tonal" density="compact" class="mb-4" border="start" rounded="lg">
      <p class="text-body-2 mb-0"><strong>Overdue rentals:</strong> If you have not returned the vehicle by the end date, contact the car rental and BulodPH support as soon as possible to avoid extra charges or disputes.</p>
    </v-alert>
    <v-row>
      <v-col cols="12" md="6">
        <v-card class="cancel-section modern-card" elevation="0" rounded="lg">
          <div class="cancel-section__accent" />
          <div class="cancel-section__header">
            <div class="cancel-section__icon"><v-icon icon="mdi-cancel" size="22" /></div>
            <span class="cancel-section__title">Request cancellation</span>
          </div>
          <v-divider class="mx-4" />
          <v-card-text class="pa-4">
            <p class="text-body-2 text-medium-emphasis mb-3">You can also cancel from <strong>My bookings</strong> → open a booking → <strong>Cancel booking</strong>. Or submit a cancellation request below (e.g. if you need a record).</p>
            <v-form @submit.prevent="handleSubmit">
              <v-text-field
                v-model="bookingRef"
                label="Booking reference (optional)"
                placeholder="e.g. booking ID"
                variant="outlined"
                density="compact"
                :error-messages="errors.bookingRef"
              />
              <v-textarea
                v-model="reason"
                label="Reason (optional)"
                variant="outlined"
                rows="4"
                class="mt-3"
                :error-messages="errors.reason"
              />
              <v-btn
                color="primary"
                variant="flat"
                class="mt-3"
                rounded="lg"
                type="submit"
                :disabled="isSubmitting"
                :loading="isSubmitting"
              >
                Request cancellation
              </v-btn>
            </v-form>
          </v-card-text>
        </v-card>
      </v-col>
      <v-col cols="12" md="6">
        <v-card class="cancel-section modern-card" elevation="0" rounded="lg">
          <div class="cancel-section__accent cancel-section__accent--list" />
          <div class="cancel-section__header">
            <div class="cancel-section__icon cancel-section__icon--list"><v-icon icon="mdi-format-list-bulleted" size="22" /></div>
            <span class="cancel-section__title">Your cancellation requests</span>
          </div>
          <v-divider class="mx-4" />
          <v-card-text class="pa-4">
            <p v-if="loadingCancellations" class="text-body-2 text-medium-emphasis mb-0">Loading…</p>
            <template v-else-if="cancellations.length">
              <v-list class="pa-0">
                <v-list-item v-for="c in cancellations" :key="c.id" class="px-0" rounded="lg">
                  <template #prepend>
                    <v-icon :color="c.status === 'approved' || c.status === 'refunded' ? 'success' : 'warning'">mdi-cancel</v-icon>
                  </template>
                  <v-list-item-title class="text-body-2">{{ c.booking_reference || 'No booking ref' }} · {{ c.status }}</v-list-item-title>
                  <v-list-item-subtitle class="text-body-2">{{ c.reason || '—' }}</v-list-item-subtitle>
                </v-list-item>
              </v-list>
            </template>
            <p v-else class="text-body-2 text-medium-emphasis mb-0">No cancellation requests yet.</p>
          </v-card-text>
        </v-card>
      </v-col>
    </v-row>
    <v-row>
      <v-col cols="12">
        <v-card class="cancel-section modern-card" elevation="0" rounded="lg">
          <div class="cancel-section__accent cancel-section__accent--refund" />
          <div class="cancel-section__header">
            <div class="cancel-section__icon cancel-section__icon--refund"><v-icon icon="mdi-cash-refund" size="22" /></div>
            <span class="cancel-section__title">Refund status</span>
          </div>
          <v-divider class="mx-4" />
          <v-card-text class="pa-4">
            <p class="text-body-2 text-medium-emphasis mb-3">Refunds for cancelled paid bookings. Processed per our Terms.</p>
            <p v-if="loadingRefunds" class="text-body-2 text-medium-emphasis mb-0">Loading…</p>
            <template v-else-if="refunds.length">
              <v-list class="pa-0">
                <v-list-item v-for="r in refunds" :key="r.id" class="px-0" rounded="lg">
                  <template #prepend>
                    <v-icon :color="r.status === 'paid' ? 'success' : 'warning'">mdi-cash-refund</v-icon>
                  </template>
                  <v-list-item-title class="text-body-2">₱{{ (r.amount ?? 0).toLocaleString() }} · {{ r.status }}</v-list-item-title>
                  <v-list-item-subtitle class="text-body-2">{{ r.reference || '—' }}</v-list-item-subtitle>
                </v-list-item>
              </v-list>
            </template>
            <p v-else class="text-body-2 text-medium-emphasis mb-0">No refunds yet.</p>
          </v-card-text>
        </v-card>
      </v-col>
    </v-row>
  </DashboardTemplate>
</template>

<script setup lang="ts">
import { ref, onMounted } from 'vue'
import DashboardTemplate from '@/components/DashboardTemplate.vue'
import { useToastStore } from '@/stores/toast'
import * as cancellationsApi from '@/services/cancellations'
import type { CancellationRecord, RefundRecord } from '@/services/cancellations'
import { BOOKING_REF_REGEX, hasInjectionRisk, isSafeText, sanitizeBasicText } from '@/utils/inputValidation'

const toast = useToastStore()
const bookingRef = ref('')
const reason = ref('')
const isSubmitting = ref(false)
const loadingCancellations = ref(true)
const loadingRefunds = ref(true)
const cancellations = ref<CancellationRecord[]>([])
const refunds = ref<RefundRecord[]>([])
const errors = ref<{ bookingRef?: string; reason?: string }>({})

async function loadCancellations() {
  loadingCancellations.value = true
  try {
    cancellations.value = await cancellationsApi.getCancellations()
  } catch {
    cancellations.value = []
  } finally {
    loadingCancellations.value = false
  }
}

async function loadRefunds() {
  loadingRefunds.value = true
  try {
    refunds.value = await cancellationsApi.getRefunds()
  } catch {
    refunds.value = []
  } finally {
    loadingRefunds.value = false
  }
}

onMounted(() => {
  loadCancellations()
  loadRefunds()
})

async function handleSubmit() {
  errors.value = {}
  bookingRef.value = sanitizeBasicText(bookingRef.value)
  reason.value = sanitizeBasicText(reason.value)

  if (bookingRef.value && (!BOOKING_REF_REGEX.test(bookingRef.value) || hasInjectionRisk(bookingRef.value))) {
    errors.value.bookingRef = 'Use letters, numbers, dashes, or underscores only'
  }
  if (reason.value && (!isSafeText(reason.value) || hasInjectionRisk(reason.value))) {
    errors.value.reason = 'Reason contains unsafe characters'
  }
  if (Object.keys(errors.value).length) return

  isSubmitting.value = true
  try {
    await cancellationsApi.createCancellation({
      booking_reference: bookingRef.value || undefined,
      reason: reason.value || undefined,
    })
    toast.success('Cancellation request submitted. We will process it and email you.')
    bookingRef.value = ''
    reason.value = ''
    await loadCancellations()
  } catch (e) {
    toast.error(e instanceof Error ? e.message : 'Could not submit request.')
  } finally {
    isSubmitting.value = false
  }
}
</script>

<style scoped>
.cancel-section {
  position: relative;
  overflow: hidden;
  border: 1px solid rgba(var(--v-border-color), var(--v-border-opacity));
}

.cancel-section__accent {
  position: absolute;
  top: 0;
  left: 0;
  width: 4px;
  height: 100%;
  background: rgb(var(--v-theme-primary));
  border-radius: 4px 0 0 4px;
}

.cancel-section__accent--list {
  background: rgb(76, 175, 80);
}

.cancel-section__accent--refund {
  background: linear-gradient(to bottom, rgb(255, 152, 0), rgba(255, 152, 0, 0.5));
}

.cancel-section__header {
  display: flex;
  align-items: center;
  gap: 0.75rem;
  padding: 1rem 1rem 0.5rem;
}

.cancel-section__icon {
  width: 40px;
  height: 40px;
  border-radius: 10px;
  background: rgba(var(--v-theme-primary), 0.1);
  color: rgb(var(--v-theme-primary));
  display: flex;
  align-items: center;
  justify-content: center;
}

.cancel-section__icon--list {
  background: rgba(76, 175, 80, 0.12);
  color: rgb(76, 175, 80);
}

.cancel-section__icon--refund {
  background: rgba(255, 152, 0, 0.12);
  color: rgb(255, 152, 0);
}

.cancel-section__title {
  font-size: 1rem;
  font-weight: 700;
  color: rgb(var(--v-theme-on-surface));
}
</style>
