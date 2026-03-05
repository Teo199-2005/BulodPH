<template>
  <DashboardTemplate
    :animate="true"
    :back-to="{ name: 'clients' }"
    back-label="Back to Clients"
  >
    <template #header>
      <div>
        <h1 class="page-title mb-1">Renter profile</h1>
        <p class="page-subtitle">Contact info and booking history for this renter</p>
      </div>
      <v-btn variant="outlined" color="primary" rounded="lg" class="mr-2" :to="editClientTo">
        <v-icon start>mdi-pencil</v-icon>
        Edit
      </v-btn>
    </template>

    <v-tabs v-model="activeTab" color="primary" class="client-details-tabs mb-4">
      <v-tab value="overview">Overview</v-tab>
      <v-tab value="bookings">Bookings</v-tab>
    </v-tabs>

    <v-window v-model="activeTab">
      <!-- Overview -->
      <v-window-item value="overview">
        <v-row>
          <v-col cols="12" lg="4">
            <v-card elevation="0" rounded="lg" class="modern-card mb-4">
              <v-card-text class="pa-4 text-center">
                <v-avatar size="80" class="mb-3" color="primary" variant="tonal">
                  <v-img v-if="clientAvatarUrl" :key="clientLoadedAt" :src="clientAvatarUrl" cover />
                  <v-icon v-else icon="mdi-account" size="40" />
                </v-avatar>
                <h3 class="text-h6 font-weight-bold mb-1">{{ clientName }}</h3>
                <p class="text-body-2 text-medium-emphasis mb-0">Renter</p>
                <v-chip :color="clientStatusColor" :prepend-icon="clientStatusIcon" size="small" variant="tonal" class="mt-3">{{ clientStatus }}</v-chip>
              </v-card-text>
            </v-card>
          </v-col>
          <v-col cols="12" lg="8">
            <v-card elevation="0" rounded="lg" class="modern-card mb-4">
              <div class="section-card-header">
                <div class="section-card-icon">
                  <v-icon icon="mdi-account-details" size="20" />
                </div>
                <span class="section-card-title">Contact & location</span>
              </div>
              <v-divider class="detail-divider" />
              <v-card-text class="pa-4">
                <v-row>
                  <v-col cols="12" sm="6">
                    <div class="detail-label">Email</div>
                    <div class="detail-value d-flex align-center gap-2 flex-wrap">
                      {{ clientEmail }}
                      <EmailVerifiedBadge :verified="!!clientDetail?.email_verified" />
                    </div>
                  </v-col>
                  <v-col cols="12" sm="6">
                    <div class="detail-label">Phone</div>
                    <div class="detail-value">{{ clientPhone }}</div>
                  </v-col>
                  <v-col cols="12">
                    <div class="detail-label">Address</div>
                    <div class="detail-value text-medium-emphasis">{{ clientAddress }}</div>
                  </v-col>
                </v-row>
              </v-card-text>
            </v-card>
            <v-card elevation="0" rounded="lg" class="modern-card">
              <div class="section-card-header">
                <div class="section-card-icon">
                  <v-icon icon="mdi-note-text" size="20" />
                </div>
                <span class="section-card-title">Notes</span>
              </div>
              <v-divider class="detail-divider" />
              <v-card-text class="pa-4">
                <p class="text-body-2 text-medium-emphasis mb-0">{{ generalNotes }}</p>
              </v-card-text>
            </v-card>
          </v-col>
        </v-row>
      </v-window-item>

      <!-- Bookings -->
      <v-window-item value="bookings">
        <v-card elevation="0" rounded="lg" class="modern-card">
          <div class="section-card-header d-flex align-center justify-space-between flex-wrap gap-2">
            <div class="d-flex align-center">
              <div class="section-card-icon">
                <v-icon icon="mdi-calendar-check" size="20" />
              </div>
              <span class="section-card-title">Booking history</span>
            </div>
            <v-btn
              color="primary"
              size="small"
              prepend-icon="mdi-open-in-new"
              rounded="lg"
              variant="tonal"
              :to="adminBookingsLink"
            >
              View in Bookings
            </v-btn>
          </div>
          <v-divider class="detail-divider" />
          <v-card-text class="pa-4">
            <p v-if="!clientId" class="text-body-2 text-medium-emphasis mb-0">Loading…</p>
            <template v-else>
              <div v-if="clientBookingsLoading" class="d-flex justify-center py-6">
                <v-progress-circular indeterminate color="primary" size="32" />
              </div>
              <template v-else-if="clientBookings.length">
                <p class="text-body-2 text-medium-emphasis mb-4">
                  {{ clientBookings.length }} booking{{ clientBookings.length === 1 ? '' : 's' }} for this renter.
                </p>
                <v-list class="pa-0" density="comfortable">
                  <v-list-item
                    v-for="b in clientBookings"
                    :key="b.id"
                    :to="{ name: 'admin-booking-detail', params: { id: b.id } }"
                    class="client-booking-item rounded-lg mb-2"
                    border
                  >
                    <template #prepend>
                      <v-icon icon="mdi-car-side" size="24" color="primary" class="mr-3" />
                    </template>
                    <v-list-item-title class="font-weight-medium">{{ b.vehicleName }}</v-list-item-title>
                    <v-list-item-subtitle class="text-body-2 mt-1">
                      {{ b.businessName }} · {{ formatBookingDates(b.startDate, b.endDate) }} · {{ formatBookingAmount(b.amount) }}
                    </v-list-item-subtitle>
                    <template #append>
                      <v-chip :color="bookingStatusColor(b.status)" :prepend-icon="bookingStatusIcon(b.status)" size="small" variant="tonal">
                        {{ b.status }}
                      </v-chip>
                    </template>
                  </v-list-item>
                </v-list>
              </template>
              <v-alert v-else type="info" variant="tonal" density="compact" class="mb-0" rounded="lg">
                No bookings yet for this renter. Bookings will appear here once they make a reservation.
              </v-alert>
            </template>
          </v-card-text>
        </v-card>
      </v-window-item>
    </v-window>
  </DashboardTemplate>
</template>

<script setup lang="ts">
import { ref, computed, watch, onMounted } from 'vue'
import { useRoute } from 'vue-router'
import DashboardTemplate from '@/components/DashboardTemplate.vue'
import { DEMO_CLIENT_EMAIL, DEMO_CLIENT_DISPLAY_NAME } from '@/constants/app'
import { getAvatarUrl, IMAGES } from '@/constants/images'
import { getClientById as getClientByIdSeed } from '@/constants/clientsSeed'
import { formatRentalAmount, type RentalBookingRecord } from '@/constants/rentalBookingsSeed'
import { getClientById as getClientByIdApi } from '@/services/clients'
import { getBookingsForClient } from '@/services/bookings'
import EmailVerifiedBadge from '@/components/shared/EmailVerifiedBadge.vue'

const route = useRoute()
const clientId = computed(() => (route.params as { id: string }).id)
const editClientTo = computed(() => ({ name: 'clients', query: { edit: clientId.value } }))
const adminBookingsLink = computed(() => ({ name: 'admin-bookings', query: clientId.value ? { clientId: clientId.value } : {} }))

const clientLoadedAt = ref<number>(0)

// Client from API or seed
const apiClient = ref<{
  id: string
  full_name: string
  email: string
  phone: string
  address?: string
  city?: string
  province?: string
  notes?: string
  status?: string
  avatar_url?: string | null
  email_verified?: boolean
} | null>(null)

async function loadClient() {
  const id = clientId.value
  if (!id) return
  const fromApi = await getClientByIdApi(id, { cacheBust: true })
  if (fromApi) {
    clientLoadedAt.value = Date.now()
    apiClient.value = {
      id: String(fromApi.id),
      full_name: fromApi.full_name ?? '',
      email: fromApi.email ?? '',
      phone: fromApi.phone ?? '',
      address: fromApi.address ?? ([fromApi.city, fromApi.province].filter(Boolean).join(', ') || undefined),
      city: fromApi.city,
      province: fromApi.province,
      notes: fromApi.notes,
      status: (fromApi as { status?: string }).status,
      avatar_url: (fromApi as { avatar_url?: string | null }).avatar_url ?? null,
      email_verified: (fromApi as { email_verified?: boolean }).email_verified,
    }
    return
  }
  const numId = Number(id)
  if (!Number.isNaN(numId)) {
    const fromSeed = getClientByIdSeed(numId)
    if (fromSeed) {
      apiClient.value = {
        id: String(fromSeed.id),
        full_name: fromSeed.full_name,
        email: fromSeed.email,
        phone: fromSeed.phone,
        address: fromSeed.address,
        notes: (fromSeed as { generalNotes?: string }).generalNotes,
      }
      return
    }
  }
  apiClient.value = null
}
onMounted(() => { loadClient(); loadClientBookings() })
watch(clientId, () => { loadClient(); loadClientBookings() })

const clientDetail = computed(() => apiClient.value)
const clientName = computed(() => clientDetail.value?.full_name ?? 'Renter')
const clientAvatarUrl = computed(() => {
  const c = clientDetail.value
  if (!c) return getAvatarUrl('Renter', undefined)
  const avatar = c.avatar_url
  if (avatar && avatar.trim()) {
    const base = getAvatarUrl('', avatar)
    const sep = base.includes('?') ? '&' : '?'
    return `${base}${sep}_=${clientLoadedAt.value || Date.now()}`
  }
  const name = (c.full_name ?? '').trim()
  const email = (c.email ?? '').toString().toLowerCase().trim()
  if (email === DEMO_CLIENT_EMAIL || name === DEMO_CLIENT_DISPLAY_NAME) return IMAGES.placeholders.demoClientAvatar
  return getAvatarUrl(name || 'Renter', undefined)
})
const clientEmail = computed(() => clientDetail.value?.email ?? '—')
const clientPhone = computed(() => clientDetail.value?.phone ?? '—')
const clientAddress = computed(() => clientDetail.value?.address ?? '—')
const generalNotes = computed(() => clientDetail.value?.notes ?? 'No notes on file.')
const clientStatus = computed(() => clientDetail.value?.status ?? 'Active')
const clientStatusColor = computed(() => (clientStatus.value === 'Active' ? 'success' : clientStatus.value === 'Pending' ? 'warning' : 'grey'))

const activeTab = ref('overview')

// Client bookings (renter profile tab)
const clientBookings = ref<RentalBookingRecord[]>([])
const clientBookingsLoading = ref(false)

async function loadClientBookings() {
  const id = clientId.value
  if (!id) return
  clientBookingsLoading.value = true
  try {
    clientBookings.value = await getBookingsForClient(id)
  } finally {
    clientBookingsLoading.value = false
  }
}

function formatBookingDates(startDate: string, endDate: string): string {
  try {
    const parse = (s: string) => {
      if (/^\d{4}-\d{2}-\d{2}$/.test(s)) return new Date(s + 'T00:00:00')
      const [a, b, c] = s.split(/[/-]/).map(Number)
      if (c && c > 1000) return new Date(c, (b ?? 1) - 1, a ?? 1)
      if (a && a > 1000) return new Date(a, (b ?? 1) - 1, c ?? 1)
      return new Date(s)
    }
    const start = parse(startDate)
    const end = parse(endDate)
    return `${start.toLocaleDateString('en-PH', { month: 'short', day: 'numeric', year: 'numeric' })} – ${end.toLocaleDateString('en-PH', { month: 'short', day: 'numeric', year: 'numeric' })}`
  } catch {
    return `${startDate} – ${endDate}`
  }
}

function formatBookingAmount(amount: number): string {
  return formatRentalAmount(amount)
}

const clientStatusIcon = computed(() => (clientStatus.value === 'Active' ? 'mdi-check-circle' : clientStatus.value === 'Pending' ? 'mdi-clock-outline' : 'mdi-account-outline'))

function bookingStatusColor(status: string): string {
  switch (status) {
    case 'Pending': return 'warning'
    case 'Approved':
    case 'Active': return 'primary'
    case 'Completed': return 'success'
    case 'Cancelled':
    case 'Rejected':
    case 'Overdue': return 'grey'
    default: return 'grey'
  }
}

function bookingStatusIcon(status: string): string {
  const map: Record<string, string> = {
    Pending: 'mdi-clock-outline',
    Approved: 'mdi-check-circle-outline',
    Active: 'mdi-play-circle',
    Completed: 'mdi-flag-checkered',
    Cancelled: 'mdi-close-circle',
    Rejected: 'mdi-cancel',
    Overdue: 'mdi-alert-circle',
  }
  return map[status] ?? 'mdi-circle-outline'
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
