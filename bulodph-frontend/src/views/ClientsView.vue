<template>
  <DashboardTemplate :animate="true">
    <template #header>
      <div>
        <h1 class="page-title mb-1">Clients</h1>
        <p class="page-subtitle">Renters – view bookings and documents</p>
      </div>
      <v-btn color="primary" size="default" prepend-icon="mdi-plus" rounded="lg" @click="showAddClientDialog = true">
        Add Client
      </v-btn>
    </template>

    <!-- Stats Cards (template: HpaDashboardWidget) -->
    <v-row class="mb-6">
      <v-col cols="6" sm="6" md="3">
        <HpaDashboardWidget
          role="client"
          :loading="false"
          title="Total Clients"
          :value="clients.length"
          icon="mdi-account-group"
          trend="neutral"
          trend-value="—"
          trend-label="total"
        />
      </v-col>
      <v-col cols="6" sm="6" md="3">
        <HpaDashboardWidget
          role="client"
          :loading="false"
          title="Active"
          :value="activeClients"
          icon="mdi-check-circle"
          trend="up"
          trend-value="active"
          trend-label="clients"
        />
      </v-col>
      <v-col cols="6" sm="6" md="3">
        <HpaDashboardWidget
          role="client"
          :loading="false"
          title="New This Month"
          :value="5"
          icon="mdi-account-plus"
          trend="up"
          trend-value="+5"
          trend-label="new"
        />
      </v-col>
      <v-col cols="6" sm="6" md="3">
        <HpaDashboardWidget
          role="client"
          :loading="false"
          title="Pending Review"
          :value="3"
          icon="mdi-clock-alert"
          trend="neutral"
          trend-value="3"
          trend-label="pending"
        />
      </v-col>
    </v-row>

    <!-- Recent activity & By location -->
    <v-row class="mb-6">
      <v-col cols="12" lg="8">
        <v-card elevation="0" rounded="lg" class="modern-card h-100">
          <div class="section-card-header">
            <div class="section-card-icon">
              <v-icon icon="mdi-history" size="20" />
            </div>
            <span class="section-card-title">Recent activity</span>
            <v-spacer />
            <v-btn variant="text" color="primary" size="small" :to="{ name: 'admin-bookings' }">View bookings</v-btn>
          </div>
          <v-divider class="settings-divider" />
          <v-card-text class="pa-4">
            <v-list density="compact" class="pa-0">
              <v-list-item v-for="a in recentClientActivity" :key="a.id" class="px-0">
                <template #prepend>
                  <v-icon :icon="a.icon" size="20" :color="a.color" class="mr-2" />
                </template>
                <v-list-item-title class="text-body-2">{{ a.title }}</v-list-item-title>
                <v-list-item-subtitle class="text-caption">{{ a.detail }}</v-list-item-subtitle>
                <template #append>
                  <span class="text-caption text-medium-emphasis">{{ a.time }}</span>
                </template>
              </v-list-item>
            </v-list>
          </v-card-text>
        </v-card>
      </v-col>
      <v-col cols="12" lg="4">
        <v-card elevation="0" rounded="lg" class="modern-card h-100">
          <div class="section-card-header">
            <div class="section-card-icon">
              <v-icon icon="mdi-map-marker" size="20" />
            </div>
            <span class="section-card-title">Clients by location</span>
          </div>
          <v-divider class="settings-divider" />
          <v-card-text class="pa-4">
            <v-list density="compact" class="pa-0">
              <v-list-item v-for="loc in clientsByLocation" :key="loc.label" class="px-0">
                <v-list-item-title class="text-body-2">{{ loc.label }}</v-list-item-title>
                <template #append>
                  <span class="text-body-2 font-weight-medium">{{ loc.count }}</span>
                </template>
              </v-list-item>
            </v-list>
          </v-card-text>
        </v-card>
      </v-col>
    </v-row>

    <!-- Data Table -->
    <HpaDataTable
      title="Client Directory"
      icon="mdi-account-group"
      :headers="headers"
      :items="clients"
      :loading="loading"
      searchable
      exportable
      selectable
    >
      <template #actions>
        <v-btn
          variant="outlined"
          size="small"
          rounded="lg"
          prepend-icon="mdi-refresh"
          color="primary"
          :loading="loading"
          aria-label="Refresh list"
          @click="loadClients()"
        >
          Refresh
        </v-btn>
      </template>
      <!-- Custom column: Avatar -->
      <template #item.full_name="{ item }">
        <div class="d-flex align-center py-2">
          <v-avatar size="40" class="mr-3" color="primary">
            <v-img :key="`avatar-${item.id}-${lastClientsFetchTime}`" :src="clientAvatarSrc(item)" cover>
              <template #placeholder>
                <span class="text-white text-body-2">{{ clientInitials(item) }}</span>
              </template>
              <template #error>
                <span class="text-white text-body-2">{{ clientInitials(item) }}</span>
              </template>
            </v-img>
          </v-avatar>
          <div>
            <div class="font-weight-medium">{{ clientDisplayName(item) }}</div>
            <div class="d-flex align-center flex-wrap gap-1">
              <span class="text-caption text-medium-emphasis">{{ item.email }}</span>
              <EmailVerifiedBadge :verified="!!(item as { email_verified?: boolean }).email_verified" />
            </div>
          </div>
        </div>
      </template>

      <!-- Custom column: Status -->
      <template #item.status="{ item }">
        <v-chip
          :color="getStatusColor(item.status)"
          :prepend-icon="getStatusIcon(item.status)"
          size="small"
          variant="tonal"
        >
          {{ item.status }}
        </v-chip>
      </template>

      <!-- Custom column: Location -->
      <template #item.location="{ item }">
        <div class="d-flex align-center">
          <v-icon icon="mdi-map-marker" size="16" class="mr-1 text-medium-emphasis" />
          <span>{{ item.city }}, {{ item.province }}</span>
        </div>
      </template>

      <!-- Custom column: Actions -->
      <template #item.actions="{ item }">
        <div class="d-flex gap-2 flex-wrap">
          <v-btn
            icon="mdi-eye"
            variant="text"
            size="small"
            color="primary"
            @click="viewClient(item.id)"
          >
            <v-icon>mdi-eye</v-icon>
            <v-tooltip activator="parent" location="top">View Details</v-tooltip>
          </v-btn>
          <v-btn
            icon="mdi-pencil"
            variant="text"
            size="small"
            color="action"
            @click="editClient(item.id)"
          >
            <v-icon>mdi-pencil</v-icon>
            <v-tooltip activator="parent" location="top">Edit</v-tooltip>
          </v-btn>
          <v-btn
            icon="mdi-calendar-plus"
            variant="text"
            size="small"
            color="accent"
            @click="newBooking(item.id)"
          >
            <v-icon>mdi-calendar-plus</v-icon>
            <v-tooltip activator="parent" location="top">New booking</v-tooltip>
          </v-btn>
          <v-btn
            icon="mdi-delete-outline"
            variant="text"
            size="small"
            color="error"
            @click="openDeleteConfirm(item)"
          >
            <v-icon>mdi-delete-outline</v-icon>
            <v-tooltip activator="parent" location="top">Delete</v-tooltip>
          </v-btn>
        </div>
      </template>

      <!-- Bulk Actions -->
      <template #bulk-actions="{ selected }">
        <v-btn
          variant="text"
          color="primary"
          prepend-icon="mdi-email"
          @click="sendBulkEmail(selected)"
        >
          Send Email
        </v-btn>
        <v-btn
          variant="text"
          color="action"
          prepend-icon="mdi-file-export"
          @click="exportSelected(selected)"
        >
          Export
        </v-btn>
      </template>
    </HpaDataTable>

    <!-- Add / Edit Client Dialog -->
    <HpaModal
      v-model="showAddClientDialog"
      :title="editingClientId ? 'Edit client' : 'Add new client'"
      :icon="editingClientId ? 'mdi-pencil' : 'mdi-account-plus'"
      max-width="900"
      @confirm="handleAddClient"
    >
      <v-form ref="clientForm">
        <v-row>
          <v-col cols="12" md="6">
            <v-text-field
              :model-value="newClient.first_name"
              @update:model-value="(v) => newClient.first_name = formatInput(v, 'letters')"
              label="First name"
              prepend-inner-icon="mdi-account"
            />
          </v-col>
          <v-col cols="12" md="6">
            <v-text-field
              :model-value="newClient.last_name"
              @update:model-value="(v) => newClient.last_name = formatInput(v, 'letters')"
              label="Last name"
              prepend-inner-icon="mdi-account"
            />
          </v-col>
          <v-col cols="12" md="6">
            <v-text-field
              v-model="newClient.email"
              label="Email"
              type="email"
              prepend-inner-icon="mdi-email"
            />
          </v-col>
          <v-col cols="12" md="6">
            <v-text-field
              :model-value="newClient.phone"
              @update:model-value="(v) => newClient.phone = formatInput(v, 'phone')"
              label="Phone"
              prepend-inner-icon="mdi-phone"
              placeholder="09xx xxx xxxx"
            />
          </v-col>
          <v-col cols="12">
            <v-text-field
              :model-value="newClient.address"
              @update:model-value="(v) => newClient.address = formatInput(v, 'address')"
              label="Address"
              prepend-inner-icon="mdi-map-marker"
            />
          </v-col>
          <v-col cols="12" md="6">
            <v-text-field
              :model-value="newClient.city"
              @update:model-value="(v) => newClient.city = formatInput(v, 'letters')"
              label="City / Municipality"
              prepend-inner-icon="mdi-city"
            />
          </v-col>
          <v-col cols="12" md="6">
            <v-select
              v-model="newClient.province"
              :items="phProvinces"
              label="Province"
              prepend-inner-icon="mdi-map"
            />
          </v-col>
          <v-col cols="12">
            <v-textarea
              v-model="newClient.notes"
              label="Notes"
              rows="3"
              prepend-inner-icon="mdi-note-text"
            />
          </v-col>
        </v-row>
      </v-form>
    </HpaModal>

    <!-- Delete confirmation (template: HpaConfirmModal) -->
    <HpaConfirmModal
      v-model="showDeleteConfirm"
      title="Delete client?"
      :message="deleteConfirmMessage"
      confirm-text="Delete"
      cancel-text="Cancel"
      variant="danger"
      @confirm="handleDeleteConfirm"
    />
  </DashboardTemplate>
</template>

<script setup lang="ts">
import { ref, computed, watch, onMounted } from 'vue'
import { useRoute, useRouter } from 'vue-router'
import HpaDataTable from '@/components/base/HpaDataTable.vue'
import HpaDashboardWidget from '@/components/base/HpaDashboardWidget.vue'
import HpaModal from '@/components/base/HpaModal.vue'
import HpaConfirmModal from '@/components/base/HpaConfirmModal.vue'
import DashboardTemplate from '@/components/DashboardTemplate.vue'
import { useToastStore } from '@/stores/toast'
import { DEMO_CLIENT_EMAIL, DEMO_CLIENT_DISPLAY_NAME } from '@/constants/app'
import { getAvatarUrl, IMAGES } from '@/constants/images'
import { createClient, deleteClient, getClientById, getClients, updateClient } from '@/services/clients'
import { useRentalBookings } from '@/composables/useRentalBookings'
import { CLIENTS_SEED, CLIENT_ACTIVITY_SEED } from '@/constants/clientsSeed'
import { hasInjectionRisk, isSafeText, sanitizeBasicText } from '@/utils/inputValidation'
import { formatInput } from '@/utils/inputFormatters'
import { getUserScopedItem, setUserScopedItem } from '@/utils/userScopedStorage'
import EmailVerifiedBadge from '@/components/shared/EmailVerifiedBadge.vue'

const CLIENTS_STORAGE_KEY = 'bulodph_admin_clients'
const route = useRoute()
const router = useRouter()
const toast = useToastStore()
const { records: rentalRecords, fetchFromApi: fetchRentalBookings } = useRentalBookings()

// State
const loading = ref(false)
const showAddClientDialog = ref(false)
const showDeleteConfirm = ref(false)
const editingClientId = ref<number | string | null>(null)
const clientToDelete = ref<{ id: number | string; full_name: string } | null>(null)

const deleteConfirmMessage = computed(() =>
  clientToDelete.value
    ? `Remove "${clientToDelete.value.full_name}" from clients? This cannot be undone.`
    : ''
)

// Form data
const newClient = ref({
  first_name: '',
  last_name: '',
  email: '',
  phone: '',
  address: '',
  city: '',
  province: 'Isabela',
  notes: '',
})

// Table configuration
const headers = [
  { title: 'Client name', key: 'full_name', sortable: true },
  { title: 'Phone', key: 'phone', sortable: true },
  { title: 'Location', key: 'location', sortable: false },
  { title: 'Status', key: 'status', sortable: true },
  { title: 'Bookings', key: 'bookings_count', sortable: true },
  { title: 'Actions', key: 'actions', sortable: false },
]

const phProvinces = ['Isabela', 'Cagayan', 'Nueva Vizcaya', 'Quirino', 'Metro Manila', 'Other']

// Data from API only (no stale storage for list so avatars stay fresh)
const clients = ref<any[]>([])
const lastClientsFetchTime = ref<number>(0)

/** Recent activity derived from rental bookings (live); falls back to seed when no bookings. */
const recentClientActivity = computed(() => {
  const list = rentalRecords.value.filter(r => !r.archived)
  const sorted = [...list].sort((a, b) => {
    const da = parseDate(a.startDate)?.getTime() ?? 0
    const db = parseDate(b.startDate)?.getTime() ?? 0
    return db - da
  })
  const recent = sorted.slice(0, 5)
  if (!recent.length) return [...CLIENT_ACTIVITY_SEED]
  const statusColor: Record<string, string> = { Completed: 'success', Pending: 'warning', Approved: 'info', Cancelled: 'grey', Rejected: 'error', Active: 'primary', Overdue: 'error' }
  return recent.map((r, i) => ({
    id: `activity-${r.id}-${i}`,
    icon: 'mdi-calendar-check',
    color: statusColor[r.status] ?? 'action',
    title: `Booking ${r.status}`,
    detail: `${r.vehicleName} · ${r.clientName}`,
    time: formatRelativeTime(r.startDate),
  }))
})

function parseDate(s: string): Date | null {
  if (!s) return null
  const d = new Date(s)
  return isNaN(d.getTime()) ? null : d
}

function formatRelativeTime(dateStr: string): string {
  const d = parseDate(dateStr)
  if (!d) return dateStr
  const now = new Date()
  const diffMs = now.getTime() - d.getTime()
  const days = Math.floor(diffMs / (24 * 60 * 60 * 1000))
  if (days === 0) return 'Today'
  if (days === 1) return 'Yesterday'
  if (days < 7) return `${days} days ago`
  if (days < 30) return `${Math.floor(days / 7)} weeks ago`
  return d.toLocaleDateString()
}

/** Avatar image URL. Use uploaded avatar_url when present (with cache-bust so browser shows latest); else placeholder/initials. */
function clientAvatarSrc(item: { full_name?: string; fullName?: string; email?: string; avatar_url?: string | null; avatarUrl?: string | null }): string {
  const avatar = item.avatar_url ?? item.avatarUrl
  if (avatar && avatar.trim()) {
    const base = getAvatarUrl('', avatar)
    const sep = base.includes('?') ? '&' : '?'
    return `${base}${sep}_=${lastClientsFetchTime.value || Date.now()}`
  }
  const name = (item.full_name ?? item.fullName ?? '').trim()
  const email = (item.email ?? '').toString().toLowerCase().trim()
  const isDemoClient = email === DEMO_CLIENT_EMAIL || name === DEMO_CLIENT_DISPLAY_NAME
  if (isDemoClient) return IMAGES.placeholders.demoClientAvatar
  return getAvatarUrl(name || 'Client', undefined)
}

/** Initials for avatar fallback (e.g. "Demo Client" → "DC"). */
function clientInitials(item: { full_name?: string; fullName?: string }): string {
  const name = (item.full_name ?? item.fullName ?? '').trim() || '?'
  const parts = name.split(/\s+/).filter(Boolean)
  if (parts.length >= 2) return (parts[0][0] + parts[parts.length - 1][0]).toUpperCase().slice(0, 2)
  return name.slice(0, 2).toUpperCase()
}

function clientDisplayName(item: { full_name?: string; fullName?: string }): string {
  return (item.full_name ?? item.fullName ?? '—').trim() || '—'
}

// Computed
const activeClients = computed(() => {
  return clients.value.filter(c => c.status === 'Active').length
})

const clientsByLocation = computed(() => {
  const map = new Map<string, number>()
  clients.value.forEach(c => {
    const key = `${c.city}, ${c.province}`
    map.set(key, (map.get(key) ?? 0) + 1)
  })
  return Array.from(map.entries()).map(([label, count]) => ({ label, count })).sort((a, b) => b.count - a.count)
})

// Methods
const getStatusColor = (status: string) => {
  const colors: Record<string, string> = {
    Active: 'success',
    Pending: 'warning',
    Inactive: 'grey',
  }
  return colors[status] || 'grey'
}

const getStatusIcon = (status: string) => {
  const icons: Record<string, string> = {
    Active: 'mdi-check-circle',
    Pending: 'mdi-clock-outline',
    Inactive: 'mdi-account-off-outline',
  }
  return icons[status] || 'mdi-circle-outline'
}

const viewClient = (id: number | string) => {
  router.push({ name: 'client-details', params: { id: String(id) } })
}

async function editClient(id: number | string) {
  let c = clients.value.find(x => x.id == id)
  if (!c) {
    const fetched = await getClientById(String(id))
    if (!fetched) return
    c = fetched
    if (!clients.value.some(x => x.id == id)) {
      clients.value = [{ ...c, id: c.id, full_name: c.full_name ?? '', email: c.email ?? '', phone: c.phone ?? '', address: c.address ?? '', city: c.city ?? '', province: c.province ?? '', notes: c.notes ?? '', status: (c as { status?: string }).status ?? 'Active', bookings_count: (c as { bookings_count?: number }).bookings_count ?? 0 }, ...clients.value]
    }
  }
  editingClientId.value = c.id
  const [first = '', ...rest] = (c.full_name ?? '').split(' ')
  newClient.value = {
    first_name: first,
    last_name: rest.join(' ') || '',
    email: c.email ?? '',
    phone: c.phone ?? '',
    address: c.address ?? '',
    city: c.city ?? '',
    province: c.province ?? 'Isabela',
    notes: c.notes ?? '',
  }
  showAddClientDialog.value = true
}

watch(() => route.query.edit, (editId) => {
  if (editId != null && editId !== '') {
    const id = typeof editId === 'string' ? (editId.trim().match(/^\d+$/) ? parseInt(editId, 10) : editId) : editId
    if (id !== undefined && id !== '') editClient(id as number | string)
  }
}, { immediate: true })

async function loadClients() {
  loading.value = true
  const data = await getClients({ _: String(Date.now()) })
  if (data && Array.isArray(data)) {
    clients.value = data
    lastClientsFetchTime.value = Date.now()
    setUserScopedItem(CLIENTS_STORAGE_KEY, clients.value)
  } else {
    const stored = getUserScopedItem<any[]>(CLIENTS_STORAGE_KEY)
    clients.value = Array.isArray(stored) && stored.length ? stored : []
    if (clients.value.length === 0) toast.warning('Could not load clients. Click Refresh to try again.')
  }
  loading.value = false
}

onMounted(() => {
  fetchRentalBookings()
})

// Refetch client list whenever admin navigates to this page so avatars (e.g. after profile upload) are up to date
watch(
  () => route.name,
  (name) => {
    if (name === 'clients') loadClients()
  },
  { immediate: true }
)

const newBooking = (id: number) => {
  router.push({ name: 'admin-bookings', query: { clientId: String(id) } })
}

const openDeleteConfirm = (item: { id: number; full_name: string }) => {
  clientToDelete.value = item
  showDeleteConfirm.value = true
}

const handleDeleteConfirm = async () => {
  if (!clientToDelete.value) return
  const name = clientToDelete.value.full_name
  const id = clientToDelete.value.id
  const ok = await deleteClient(id)
  if (ok) {
    clients.value = clients.value.filter(c => c.id !== id)
    toast.success(`"${name}" removed`)
  } else {
    setUserScopedItem(CLIENTS_STORAGE_KEY, clients.value)
    toast.warning('Delete failed on server. Removed locally for now.')
    clients.value = clients.value.filter(c => c.id !== id)
  }
  clientToDelete.value = null
}

function sendBulkEmail(selected: { full_name?: string; email?: string }[]) {
  const emails = selected.map(c => c.email).filter(Boolean).join(',')
  if (emails) {
    window.location.href = `mailto:${emails}`
  } else {
    toast.info('No email addresses for selected clients.')
  }
}

function exportSelected(selected: Record<string, unknown>[]) {
  if (!selected.length) {
    toast.info('Select at least one client to export.')
    return
  }
  const headers = ['full_name', 'email', 'phone', 'city', 'province', 'status', 'bookings_count']
  const rows = selected.map(row => headers.map(h => row[h] ?? ''))
  const csv = [headers.join(','), ...rows.map(r => r.map(c => `"${String(c).replace(/"/g, '""')}"`).join(','))].join('\n')
  const blob = new Blob(['\ufeff' + csv], { type: 'text/csv;charset=utf-8;' })
  const url = URL.createObjectURL(blob)
  const a = document.createElement('a')
  a.href = url
  a.download = `clients-export-${new Date().toISOString().slice(0, 10)}.csv`
  a.click()
  URL.revokeObjectURL(url)
  toast.success('Export downloaded.')
}

const handleAddClient = async () => {
  const firstName = sanitizeBasicText(newClient.value.first_name)
  const lastName = sanitizeBasicText(newClient.value.last_name)
  const email = sanitizeBasicText(newClient.value.email)
  const phone = sanitizeBasicText(newClient.value.phone)
  const address = sanitizeBasicText(newClient.value.address)
  const city = sanitizeBasicText(newClient.value.city)
  const province = sanitizeBasicText(newClient.value.province)
  const notes = sanitizeBasicText(newClient.value.notes)
  const full_name = [firstName, lastName].filter(Boolean).join(' ') || 'Unnamed'

  if (!full_name.trim()) {
    toast.warning('Client name is required.')
    return
  }
  if (hasInjectionRisk(full_name) || (notes && (!isSafeText(notes) || hasInjectionRisk(notes)))) {
    toast.error('Please remove unsafe characters from the form.')
    return
  }

  const payload = {
    full_name,
    email,
    phone,
    address,
    city,
    province,
    notes,
  }

  if (editingClientId.value) {
    const updated = await updateClient(editingClientId.value, payload)
    if (updated) {
      const idx = clients.value.findIndex(x => x.id == editingClientId.value)
      if (idx !== -1) clients.value[idx] = updated
      else clients.value.unshift(updated)
      toast.success('Client updated')
    } else {
      const c = clients.value.find(x => x.id == editingClientId.value)
      if (c) {
        c.full_name = full_name
        c.email = email
        c.phone = phone
        c.address = address
        c.city = city
        c.province = province
        c.notes = notes
      }
      setUserScopedItem(CLIENTS_STORAGE_KEY, clients.value)
      toast.warning('Update failed on server. Saved locally for now.')
    }
  } else {
    const created = await createClient(payload)
    if (created) {
      clients.value.unshift(created)
      toast.success('Client added')
    } else {
      const id = Math.max(0, ...clients.value.map(x => x.id)) + 1
      clients.value.push({
        id,
        full_name,
        email,
        phone,
        city,
        province,
        address,
        status: 'Active',
        bookings_count: 0,
        notes,
      })
      setUserScopedItem(CLIENTS_STORAGE_KEY, clients.value)
      toast.warning('Create failed on server. Saved locally for now.')
    }
  }
  showAddClientDialog.value = false
  editingClientId.value = null
  newClient.value = { first_name: '', last_name: '', email: '', phone: '', address: '', city: '', province: 'Isabela', notes: '' }
}
</script>

<style scoped>
/* View-specific overrides only; page header/card styles are global */
</style>
