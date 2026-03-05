<template>
  <div class="page-template page-template--animate agreement-page">
    <header class="page-header">
      <h1 class="page-title">Car Rental Owner Platform Agreement</h1>
      <p class="page-subtitle">Please read and accept before using the Car rental owner dashboard.</p>
    </header>

    <v-card elevation="0" rounded="lg" class="modern-card mb-4">
      <v-card-text class="agreement-content pa-4">
        <p
          v-for="(p, i) in CAR_OWNER_AGREEMENT.paragraphs"
          :key="i"
          class="agreement-p"
          v-html="renderParagraph(p)"
        />
      </v-card-text>
      <v-divider />
      <v-card-actions class="pa-4 flex-column align-stretch">
        <v-checkbox
          v-model="checked"
          color="primary"
          hide-details
          density="compact"
        >
          <template #label>
            <span class="text-body-2">I have read and accept the Car Rental Owner Platform Agreement above.</span>
          </template>
        </v-checkbox>
        <v-btn
          color="primary"
          block
          size="large"
          rounded="lg"
          :disabled="!checked"
          @click="acceptAndContinue"
        >
          Accept and continue to dashboard
        </v-btn>
      </v-card-actions>
    </v-card>

    <p class="text-caption text-medium-emphasis">
      By accepting, you acknowledge that BulodPH is a platform only and is not liable for theft, damage, or disputes involving your vehicle.
    </p>
  </div>
</template>

<script setup lang="ts">
import { ref } from 'vue'
import { useRouter } from 'vue-router'
import { CAR_OWNER_AGREEMENT } from '@/constants/platformAgreement'
import { useAgreementAcceptanceStore } from '@/stores/agreementAcceptance'

const router = useRouter()
const agreementStore = useAgreementAcceptanceStore()
const checked = ref(false)

function renderParagraph(p: string): string {
  return p.replace(/\*\*(.+?)\*\*/g, '<strong>$1</strong>')
}

function acceptAndContinue() {
  if (!checked.value) return
  agreementStore.acceptCarOwnerAgreement()
  router.replace({ name: 'car-owner-dashboard' })
}
</script>

<style scoped>
.agreement-page {
  max-width: 640px;
  margin: 0 auto;
}

.agreement-content {
  max-height: 60vh;
  overflow-y: auto;
}

.agreement-p {
  font-size: 0.9375rem;
  line-height: 1.55;
  color: var(--text-primary, #0f172a);
  margin-bottom: 1rem;
}

.agreement-p:last-child {
  margin-bottom: 0;
}

.agreement-p :deep(strong) {
  color: var(--role-primary);
}
</style>
