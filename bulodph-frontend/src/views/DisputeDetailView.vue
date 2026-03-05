<template>
  <DashboardTemplate
    title="Dispute details"
    subtitle="Track status and upload evidence."
    :breadcrumb-items="breadcrumbs"
  >
    <v-row v-if="dispute">
      <v-col cols="12" md="7">
        <v-card class="modern-card" elevation="0" rounded="lg">
          <div class="section-card-header">
            <span class="section-card-title">Dispute status</span>
          </div>
          <v-divider class="dashboard-divider" />
          <v-card-text class="pa-4">
            <p class="text-body-2"><strong>Status:</strong> <v-chip :color="statusColor" :prepend-icon="getStatusIcon(dispute.status)" size="small" variant="tonal">{{ dispute.status }}</v-chip></p>
            <p v-if="dispute.booking_reference" class="text-body-2 text-medium-emphasis mb-1">Booking ref: {{ dispute.booking_reference }}</p>
            <p class="text-body-2 font-weight-medium mb-1">Reason: {{ dispute.reason }}</p>
            <p v-if="dispute.description" class="text-body-2 text-medium-emphasis mb-0">{{ dispute.description }}</p>
            <div v-if="dispute.evidence?.length" class="mt-3">
              <p class="text-caption font-weight-medium mb-2">Evidence ({{ dispute.evidence.length }})</p>
              <ul class="text-body-2 text-medium-emphasis pl-4 mb-0">
                <li v-for="e in dispute.evidence" :key="e.id">File uploaded</li>
              </ul>
            </div>
          </v-card-text>
        </v-card>
      </v-col>
      <v-col cols="12" md="5">
        <v-card class="modern-card" elevation="0" rounded="lg">
          <div class="section-card-header">
            <span class="section-card-title">Upload evidence</span>
          </div>
          <v-divider class="dashboard-divider" />
          <v-card-text class="pa-4">
            <v-form @submit.prevent="handleSubmit">
              <v-file-input
                v-model="evidence"
                label="Add photos or files (max 5MB)"
                variant="outlined"
                density="compact"
                accept="image/*,application/pdf"
                :error-messages="errors.evidence"
                :disabled="dispute.status === 'resolved'"
              />
              <v-btn
                color="primary"
                variant="flat"
                class="mt-3"
                rounded="lg"
                type="submit"
                :disabled="isSubmitting || !canSubmit || dispute.status === 'resolved'"
                :loading="isSubmitting"
              >
                Upload
              </v-btn>
            </v-form>
          </v-card-text>
        </v-card>
      </v-col>
    </v-row>
    <div v-else class="text-center py-8" data-gsap-reveal>
      <p class="text-medium-emphasis mb-3">{{ loadError || 'Dispute not found.' }}</p>
      <v-btn variant="tonal" color="primary" rounded="lg" :to="backTo">Back to disputes</v-btn>
    </div>
  </DashboardTemplate>
</template>

<script setup lang="ts">
import { computed, ref, onMounted, watch } from 'vue'
import { useRoute } from 'vue-router'
import DashboardTemplate from '@/components/DashboardTemplate.vue'
import { useToastStore } from '@/stores/toast'
import * as disputesApi from '@/services/disputes'
import type { DisputeRecord } from '@/services/disputes'
import { validateFiles } from '@/utils/inputValidation'

const route = useRoute()
const toast = useToastStore()
const dispute = ref<DisputeRecord | null>(null)
const loadError = ref('')
const evidence = ref<File[] | File | null>(null)
const isSubmitting = ref(false)
const errors = ref<{ evidence?: string }>({})

const disputeId = computed(() => route.params.id as string)
const isCarOwner = computed(() => route.path.startsWith('/car-owner'))
const backTo = computed(() => (isCarOwner.value ? { name: 'car-owner-disputes' } : { name: 'client-disputes' }))
const breadcrumbs = computed(() => [
  { label: isCarOwner.value ? 'Dashboard' : 'Dashboard', to: isCarOwner.value ? '/car-owner' : '/client' },
  { label: 'Disputes', to: isCarOwner.value ? '/car-owner/disputes' : '/client/disputes' },
  { label: dispute.value ? `#${dispute.value.id.slice(0, 8)}` : 'Details' },
])

const statusColor = computed(() => {
  const s = dispute.value?.status?.toLowerCase()
  if (s === 'resolved') return 'success'
  if (s === 'filed' || s === 'open') return 'warning'
  return 'info'
})

function getStatusIcon(status: string): string {
  const s = status?.toLowerCase()
  if (s === 'resolved') return 'mdi-check-circle'
  if (s === 'filed' || s === 'open') return 'mdi-clock-outline'
  return 'mdi-alert-circle-outline'
}

const canSubmit = computed(() => {
  const v = evidence.value
  return Array.isArray(v) ? v.length > 0 : !!v
})

async function loadDispute() {
  if (!disputeId.value) return
  loadError.value = ''
  try {
    dispute.value = await disputesApi.getDisputeById(disputeId.value)
  } catch (e) {
    loadError.value = e instanceof Error ? e.message : 'Could not load dispute.'
    dispute.value = null
  }
}

onMounted(loadDispute)
watch(disputeId, loadDispute)

async function handleSubmit() {
  errors.value = {}
  const file = Array.isArray(evidence.value) ? evidence.value[0] : evidence.value
  const fileError = validateFiles(file, {
    required: true,
    maxSizeMb: 5,
    allowedTypes: ['image/png', 'image/jpeg', 'image/webp', 'application/pdf'],
    label: 'Evidence',
  })
  if (fileError) {
    errors.value.evidence = fileError
    return
  }
  if (!dispute.value || !file) return
  isSubmitting.value = true
  try {
    await disputesApi.addDisputeEvidence(dispute.value.id, file as File)
    toast.success('Evidence uploaded.')
    evidence.value = null
    await loadDispute()
  } catch (e) {
    toast.error(e instanceof Error ? e.message : 'Upload failed.')
  } finally {
    isSubmitting.value = false
  }
}
</script>
