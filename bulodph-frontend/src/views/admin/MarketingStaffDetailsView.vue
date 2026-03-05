<template>
  <DashboardTemplate
    :animate="true"
    :back-to="{ name: 'marketing-staff' }"
    back-label="Back to Marketing staff"
  >
    <template #header>
      <div>
        <h1 class="page-title mb-1">Marketing partner</h1>
        <p class="page-subtitle">Referral partner profile and activity</p>
      </div>
      <v-btn
        v-if="partner"
        variant="outlined"
        color="primary"
        rounded="lg"
        class="mr-2"
        @click="goToEdit"
      >
        <v-icon start>mdi-pencil</v-icon>
        Edit
      </v-btn>
    </template>

    <template v-if="!partner">
      <v-alert type="warning" variant="tonal" rounded="lg" class="mb-4">
        Partner details are only available when opened from the Marketing staff list. Use the back button and click “View details” on a partner.
      </v-alert>
    </template>

    <template v-else>
      <v-row>
        <v-col cols="12" lg="4">
          <v-card elevation="0" rounded="lg" class="modern-card mb-4">
            <v-card-text class="pa-4 text-center">
              <v-avatar size="96" color="primary" variant="tonal" class="mb-3">
                <v-img v-if="partnerAvatarUrl" :src="partnerAvatarUrl" cover />
                <v-icon v-else icon="mdi-account" size="48" />
              </v-avatar>
              <h3 class="text-h6 font-weight-bold mb-1">{{ partner.full_name }}</h3>
              <p class="text-body-2 text-medium-emphasis mb-2">Marketing partner</p>
              <v-chip :color="statusColor" :prepend-icon="getStatusIcon(partner.status)" size="small" variant="tonal">{{ partner.status }}</v-chip>
              <div v-if="partner.referral_code" class="mt-3">
                <div class="detail-label">Referral code</div>
                <code class="text-body-2">{{ partner.referral_code }}</code>
              </div>
            </v-card-text>
          </v-card>
        </v-col>
        <v-col cols="12" lg="8">
          <v-card elevation="0" rounded="lg" class="modern-card mb-4">
            <div class="section-card-header">
              <div class="section-card-icon">
                <v-icon icon="mdi-account-details" size="20" />
              </div>
              <span class="section-card-title">Contact</span>
            </div>
            <v-divider class="detail-divider" />
            <v-card-text class="pa-4">
              <v-row>
                <v-col cols="12" sm="6">
                  <div class="detail-label">Email</div>
                  <div class="detail-value d-flex align-center gap-2 flex-wrap">
                    {{ partner.email || '—' }}
                    <EmailVerifiedBadge :verified="!!(partner as { email_verified?: boolean }).email_verified" />
                  </div>
                </v-col>
                <v-col cols="12" sm="6">
                  <div class="detail-label">Phone</div>
                  <div class="detail-value">{{ partner.phone || '—' }}</div>
                </v-col>
                <v-col cols="12" sm="6">
                  <div class="detail-label">City</div>
                  <div class="detail-value">{{ partner.city || '—' }}</div>
                </v-col>
                <v-col cols="12" sm="6">
                  <div class="detail-label">Province</div>
                  <div class="detail-value">{{ partner.province || '—' }}</div>
                </v-col>
              </v-row>
            </v-card-text>
          </v-card>
          <v-card elevation="0" rounded="lg" class="modern-card">
            <div class="section-card-header">
              <div class="section-card-icon">
                <v-icon icon="mdi-link-variant" size="20" />
              </div>
              <span class="section-card-title">Referrals</span>
            </div>
            <v-divider class="detail-divider" />
            <v-card-text class="pa-4">
              <p class="text-body-2 text-medium-emphasis mb-0">
                This partner has <strong>{{ partner.referrals_count ?? 0 }}</strong> referral(s). They can share their referral link to bring new renters and car owners to BulodPH.
              </p>
              <p v-if="partner.notes" class="text-body-2 text-medium-emphasis mt-3 mb-0"><strong>Notes:</strong> {{ partner.notes }}</p>
            </v-card-text>
          </v-card>
        </v-col>
      </v-row>
    </template>
  </DashboardTemplate>
</template>

<script setup lang="ts">
import { ref, computed, onMounted } from 'vue'
import { useRoute, useRouter } from 'vue-router'
import DashboardTemplate from '@/components/DashboardTemplate.vue'
import { getAvatarUrl } from '@/constants/images'
import EmailVerifiedBadge from '@/components/shared/EmailVerifiedBadge.vue'

interface PartnerRow {
  id: number | string
  full_name: string
  email?: string
  phone?: string
  city?: string
  province?: string
  referral_code?: string
  status?: string
  referrals_count?: number
  notes?: string
  avatar_url?: string | null
}

const route = useRoute()
const router = useRouter()
const partner = ref<PartnerRow | null>(null)

function loadFromState() {
  const state = window.history.state as { partner?: PartnerRow } | undefined
  if (state?.partner) {
    partner.value = state.partner
    return
  }
  partner.value = null
}

function goToEdit() {
  if (!partner.value) return
  router.push({ name: 'marketing-staff', query: { edit: String(partner.value.id) } })
}

onMounted(() => loadFromState())

const partnerAvatarUrl = computed(() =>
  getAvatarUrl(partner.value?.full_name, partner.value?.avatar_url ?? undefined)
)

const statusColor = computed(() => {
  const s = partner.value?.status
  if (s === 'Active') return 'success'
  if (s === 'Pending') return 'warning'
  return 'grey'
})

function getStatusIcon(s: string): string {
  const map: Record<string, string> = { Active: 'mdi-check-circle', Pending: 'mdi-clock-outline', Inactive: 'mdi-account-off-outline' }
  return map[s] ?? 'mdi-circle-outline'
}
</script>

<style scoped>
.section-card-header {
  padding: 1rem 1.25rem;
}
.section-card-icon {
  margin-right: 0.75rem;
  display: flex;
  align-items: center;
}
.detail-divider {
  border-color: rgba(30, 58, 95, 0.08);
}
.detail-label {
  font-size: var(--text-sm);
  font-weight: 600;
  color: var(--text-secondary);
  text-transform: uppercase;
  letter-spacing: 0.05em;
  margin-bottom: 4px;
}
.detail-value {
  font-size: var(--text-body-lg);
  font-weight: 500;
  color: var(--text-primary);
}
</style>
