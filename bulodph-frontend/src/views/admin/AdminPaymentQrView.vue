<template>
  <DashboardTemplate title="Payment collection (QR)" subtitle="GCash and Maya QR codes shown to clients when they pay for approved bookings (manual flow)." :back-to="{ name: 'admin-dashboard' }" back-label="Back to dashboard">
    <v-card class="modern-card section-card-accent" elevation="0" rounded="lg">
      <v-card-text class="pa-4">
        <p class="text-body-2 text-medium-emphasis mb-4">Upload your GCash and Maya QR code images. Clients will use <strong>Pay via QR</strong> on the Payments page to see these and scan with their app. You confirm receipt in the booking detail.</p>

        <v-row dense class="mb-4">
          <v-col cols="12" md="6">
            <p class="text-caption font-weight-medium mb-2">GCash QR</p>
            <v-file-input
              :model-value="gcashFile"
              label="Upload GCash QR image"
              prepend-icon=""
              prepend-inner-icon="mdi-upload"
              accept="image/*"
              variant="outlined"
              density="comfortable"
              hide-details
              clearable
              rounded="lg"
              class="payment-qr-upload"
              @update:model-value="onGcashFileSelect"
            />
            <v-expand-transition>
              <v-text-field
                v-show="showGcashUrl"
                v-model="form.gcashQrUrl"
                label="Or paste image URL"
                placeholder="https://..."
                density="compact"
                variant="outlined"
                hide-details
                class="mt-2"
                rounded="lg"
                @update:model-value="gcashFile = null"
              />
            </v-expand-transition>
            <v-img
              v-if="form.gcashQrUrl"
              :src="form.gcashQrUrl"
              alt="GCash QR"
              max-height="140"
              contain
              class="payment-qr-preview rounded-lg mt-2"
            />
          </v-col>
          <v-col cols="12" md="6">
            <p class="text-caption font-weight-medium mb-2">Maya QR</p>
            <v-file-input
              :model-value="mayaFile"
              label="Upload Maya QR image"
              prepend-icon=""
              prepend-inner-icon="mdi-upload"
              accept="image/*"
              variant="outlined"
              density="comfortable"
              hide-details
              clearable
              rounded="lg"
              class="payment-qr-upload"
              @update:model-value="onMayaFileSelect"
            />
            <v-expand-transition>
              <v-text-field
                v-show="showMayaUrl"
                v-model="form.mayaQrUrl"
                label="Or paste image URL"
                placeholder="https://..."
                density="compact"
                variant="outlined"
                hide-details
                class="mt-2"
                rounded="lg"
                @update:model-value="mayaFile = null"
              />
            </v-expand-transition>
            <v-img
              v-if="form.mayaQrUrl"
              :src="form.mayaQrUrl"
              alt="Maya QR"
              max-height="140"
              contain
              class="payment-qr-preview rounded-lg mt-2"
            />
          </v-col>
        </v-row>

        <div class="d-flex align-center gap-2 mb-4">
          <v-btn variant="text" size="small" color="primary" @click="showGcashUrl = !showGcashUrl">
            {{ showGcashUrl ? 'Hide' : 'Paste' }} GCash URL
          </v-btn>
          <v-btn variant="text" size="small" color="primary" @click="showMayaUrl = !showMayaUrl">
            {{ showMayaUrl ? 'Hide' : 'Paste' }} Maya URL
          </v-btn>
        </div>

        <v-btn color="primary" rounded="lg" :loading="saving" @click="save">Save</v-btn>
      </v-card-text>
    </v-card>
  </DashboardTemplate>
</template>

<script setup lang="ts">
import { ref, reactive, onMounted } from 'vue'
import DashboardTemplate from '@/components/DashboardTemplate.vue'
import { useToastStore } from '@/stores/toast'
import { getAdminPaymentQr, updatePaymentQr } from '@/services/paymentQr'

const toast = useToastStore()
const saving = ref(false)
const gcashFile = ref<File | null>(null)
const mayaFile = ref<File | null>(null)
const showGcashUrl = ref(false)
const showMayaUrl = ref(false)
const form = reactive<{ gcashQrUrl: string; mayaQrUrl: string }>({
  gcashQrUrl: '',
  mayaQrUrl: '',
})

onMounted(async () => {
  try {
    const data = await getAdminPaymentQr()
    form.gcashQrUrl = data.gcashQrUrl ?? ''
    form.mayaQrUrl = data.mayaQrUrl ?? ''
  } catch {
    // API may not be available; leave form empty so admin can still upload/save
  }
})

function readFileAsDataUrl(file: File): Promise<string> {
  return new Promise((resolve, reject) => {
    const reader = new FileReader()
    reader.onload = () => resolve(reader.result as string)
    reader.onerror = () => reject(reader.error)
    reader.readAsDataURL(file)
  })
}

async function readImageAsCompressedDataUrl(file: File): Promise<string> {
  // Keep payloads small enough for API/storage; fallback to raw data URL if anything fails.
  try {
    const bitmap = await createImageBitmap(file)
    const maxDim = 900
    const scale = Math.min(1, maxDim / Math.max(bitmap.width, bitmap.height))
    const w = Math.max(1, Math.round(bitmap.width * scale))
    const h = Math.max(1, Math.round(bitmap.height * scale))
    const canvas = document.createElement('canvas')
    canvas.width = w
    canvas.height = h
    const ctx = canvas.getContext('2d')
    if (!ctx) return await readFileAsDataUrl(file)
    ctx.drawImage(bitmap, 0, 0, w, h)
    const quality = 0.85
    const jpeg = canvas.toDataURL('image/jpeg', quality)
    return jpeg.length > 0 ? jpeg : await readFileAsDataUrl(file)
  } catch {
    return await readFileAsDataUrl(file)
  }
}

function firstFile(input: File | File[] | null): File | null {
  if (!input) return null
  return Array.isArray(input) ? (input[0] ?? null) : input
}

async function onGcashFileSelect(input: File | File[] | null) {
  const file = firstFile(input)
  gcashFile.value = file
  if (file) {
    try {
      form.gcashQrUrl = await readImageAsCompressedDataUrl(file)
    } catch {
      toast.error('Could not read image.')
    }
  } else {
    form.gcashQrUrl = ''
  }
}

async function onMayaFileSelect(input: File | File[] | null) {
  const file = firstFile(input)
  mayaFile.value = file
  if (file) {
    try {
      form.mayaQrUrl = await readImageAsCompressedDataUrl(file)
    } catch {
      toast.error('Could not read image.')
    }
  } else {
    form.mayaQrUrl = ''
  }
}

async function save() {
  saving.value = true
  try {
    await updatePaymentQr({
      gcashQrUrl: form.gcashQrUrl.trim() || null,
      mayaQrUrl: form.mayaQrUrl.trim() || null,
    })
    toast.success('Payment QR settings saved.')
  } catch (err: unknown) {
    const ax = err as { response?: { status?: number; data?: { message?: string; errors?: Record<string, string[]> } } }
    const status = ax.response?.status
    const data = ax.response?.data
    const msg = data?.message
    const errors = data?.errors
    if (status === 401) {
      toast.error('Please log in again.')
    } else if (status === 403) {
      toast.error('Admin access required. You don’t have permission to change payment QR settings.')
    } else if (status === 422 && errors) {
      const first = Object.values(errors).flat()[0]
      toast.error(first ?? 'Validation failed.')
    } else if (msg && typeof msg === 'string') {
      toast.error(msg)
    } else {
      toast.error('Could not save. Check your connection and try again.')
    }
  } finally {
    saving.value = false
  }
}
</script>

<style scoped>
.payment-qr-preview {
  background: #f5f5f5;
}
</style>
