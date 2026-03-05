<template>
  <DashboardTemplate
    :animate="true"
    :back-to="{ name: 'car-owners' }"
    back-label="Back to Car rental owners"
  >
    <template #header>
      <div>
        <h1 class="page-title mb-1">Car rental company</h1>
        <p class="page-subtitle">Company profile and listing summary</p>
      </div>
      <v-btn
        v-if="owner"
        variant="outlined"
        color="primary"
        rounded="lg"
        class="mr-2"
        :to="{ name: 'car-owners', query: { edit: owner.id } }"
      >
        <v-icon start>mdi-pencil</v-icon>
        Edit
      </v-btn>
    </template>

    <template v-if="loading">
      <p class="text-body-2 text-medium-emphasis">Loading company details…</p>
    </template>
    <template v-else-if="!owner">
      <v-alert type="warning" variant="tonal" rounded="lg" class="mb-4">
        Company not found. The link may be invalid or the company may have been removed. Use the back button “View details” to return to the Car rental owners list.
      </v-alert>
    </template>

    <template v-else>
      <v-row>
        <v-col cols="12" lg="4">
          <v-card elevation="0" rounded="lg" class="modern-card mb-4">
            <v-card-text class="pa-4 text-center">
              <v-avatar size="96" rounded="lg" class="mb-3">
                <v-img v-if="ownerLogoOrAvatar" :src="ownerLogoOrAvatar" cover />
                <v-icon v-else icon="mdi-domain" size="48" color="primary" />
              </v-avatar>
              <h3 class="text-h6 font-weight-bold mb-1">{{ owner.business_name || owner.full_name }}</h3>
              <p class="text-body-2 text-medium-emphasis mb-2">{{ owner.full_name }}</p>
              <v-chip :color="statusColor" :prepend-icon="getStatusIcon(owner.status)" size="small" variant="tonal" class="mb-2">{{ owner.status }}</v-chip>
              <v-chip v-if="owner.account_status" :color="owner.account_status === 'Approved' ? 'success' : 'warning'" :prepend-icon="owner.account_status === 'Approved' ? 'mdi-check-circle' : 'mdi-clock-outline'" size="small" variant="tonal" class="ms-1">{{ owner.account_status }}</v-chip>
            </v-card-text>
          </v-card>
        </v-col>
        <v-col cols="12" lg="8">
          <v-card elevation="0" rounded="lg" class="modern-card mb-4">
            <div class="section-card-header">
              <div class="section-card-icon">
                <v-icon icon="mdi-map-marker" size="20" />
              </div>
              <span class="section-card-title">Location & contact</span>
            </div>
            <v-divider class="detail-divider" />
            <v-card-text class="pa-4">
              <v-row>
                <v-col cols="12" sm="6">
                  <div class="detail-label">Email</div>
                  <div class="detail-value d-flex align-center gap-2 flex-wrap">
                    {{ owner.email || '—' }}
                    <EmailVerifiedBadge :verified="!!(owner as { email_verified?: boolean }).email_verified" />
                  </div>
                </v-col>
                <v-col cols="12" sm="6">
                  <div class="detail-label">Phone</div>
                  <div class="detail-value">{{ owner.phone || '—' }}</div>
                </v-col>
                <v-col cols="12" sm="6">
                  <div class="detail-label">City</div>
                  <div class="detail-value">{{ owner.city || '—' }}</div>
                </v-col>
                <v-col cols="12" sm="6">
                  <div class="detail-label">Province</div>
                  <div class="detail-value">{{ owner.province || '—' }}</div>
                </v-col>
                <v-col cols="12">
                  <div class="detail-label">Address</div>
                  <div class="detail-value text-medium-emphasis">{{ owner.address || '—' }}</div>
                </v-col>
              </v-row>
            </v-card-text>
          </v-card>
          <v-card elevation="0" rounded="lg" class="modern-card">
            <div class="section-card-header d-flex align-center justify-space-between flex-wrap gap-2">
              <div class="d-flex align-center">
                <div class="section-card-icon">
                  <v-icon icon="mdi-car-multiple" size="20" />
                </div>
                <span class="section-card-title">Listings</span>
              </div>
              <v-btn
                variant="tonal"
                color="primary"
                size="small"
                rounded="lg"
                :to="{ name: 'admin-listings' }"
              >
                View all listings
              </v-btn>
            </div>
            <v-divider class="detail-divider" />
            <v-card-text class="pa-4">
              <p class="text-body-2 text-medium-emphasis mb-0">
                This company has <strong>{{ owner.listings_count ?? 0 }}</strong> vehicle listing(s) on the platform. Verified: {{ owner.verified ? 'Yes' : 'No' }} · Business permit: {{ owner.has_permit ? 'On file' : 'Not provided' }}.
              </p>
              <p v-if="owner.notes" class="text-body-2 text-medium-emphasis mt-3 mb-0"><strong>Notes:</strong> {{ owner.notes }}</p>
            </v-card-text>
          </v-card>
        </v-col>
      </v-row>
    </template>
  </DashboardTemplate>
</template>

<script setup lang="ts">
import { ref, computed, onMounted, watch } from 'vue'
import { useRoute } from 'vue-router'
import DashboardTemplate from '@/components/DashboardTemplate.vue'
import { resolveImageUrl } from '@/constants/images'
import { getCarRentalById } from '@/services/carRentalProfile'
import EmailVerifiedBadge from '@/components/shared/EmailVerifiedBadge.vue'

interface OwnerRow {
  id: number | string
  full_name: string
  business_name?: string
  logo_url?: string
  avatar_url?: string
  email?: string
  phone?: string
  city?: string
  province?: string
  address?: string
  status?: string
  account_status?: string
  verified?: boolean
  has_permit?: boolean
  listings_count?: number
  notes?: string
}

const route = useRoute()
const owner = ref<OwnerRow | null>(null)
const loading = ref(true)
const ownerLogoOrAvatar = computed(() => {
  const o = owner.value
  const raw = o?.logo_url || o?.avatar_url
  return raw ? (resolveImageUrl(raw) ?? raw) : null
})

function profileToOwnerRow(profile: { id: string; businessName?: string; logoUrl?: string | null; email?: string; phone?: string; city?: string; province?: string; address?: string; businessPermitNumber?: string; vehicleCount?: number }): OwnerRow {
  const name = (profile.businessName ?? 'Rental').trim() || 'Unnamed'
  return {
    id: profile.id,
    full_name: name,
    business_name: name,
    logo_url: profile.logoUrl ?? undefined,
    avatar_url: profile.logoUrl ?? undefined,
    email: String(profile.email ?? ''),
    phone: String(profile.phone ?? ''),
    city: String(profile.city ?? ''),
    province: String(profile.province ?? ''),
    address: String(profile.address ?? ''),
    status: 'Active',
    account_status: 'Approved',
    verified: true,
    has_permit: Boolean(profile.businessPermitNumber),
    listings_count: Number(profile.vehicleCount ?? 0),
    notes: '',
  }
}

async function loadOwner() {
  loading.value = true
  owner.value = null
  const state = window.history.state as { owner?: OwnerRow } | undefined
  if (state?.owner) {
    owner.value = state.owner
    loading.value = false
    return
  }
  const id = route.params.id as string
  if (!id) {
    loading.value = false
    return
  }
  const profile = await getCarRentalById(id)
  if (profile) {
    owner.value = profileToOwnerRow(profile)
  }
  loading.value = false
}

onMounted(() => loadOwner())
watch(() => route.params.id, () => loadOwner())

const statusColor = computed(() => {
  const s = owner.value?.status
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
