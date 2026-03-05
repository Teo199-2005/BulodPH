<template>
  <DashboardTemplate :animate="true">
    <template #header>
      <div>
        <h1 class="page-title mb-1">Marketing staff</h1>
        <p class="page-subtitle">Referral and marketing partners for BulodPH</p>
      </div>
      <v-btn color="primary" size="default" prepend-icon="mdi-plus" rounded="lg" @click="openAddDialog">
        Add marketing partner
      </v-btn>
    </template>

    <v-row class="mb-6">
      <v-col cols="6" sm="6" md="3">
        <HpaDashboardWidget
          role="marketing_staff"
          :loading="false"
          title="Total partners"
          :value="partners.length"
          icon="mdi-bullhorn-outline"
          trend="neutral"
          trend-value="—"
          trend-label="total"
        />
      </v-col>
      <v-col cols="6" sm="6" md="3">
        <HpaDashboardWidget
          role="marketing_staff"
          :loading="false"
          title="Active"
          :value="activeCount"
          icon="mdi-check-circle"
          trend="up"
          trend-value="active"
          trend-label="partners"
        />
      </v-col>
      <v-col cols="6" sm="6" md="3">
        <HpaDashboardWidget
          role="marketing_staff"
          :loading="false"
          title="With referrals"
          :value="withReferralsCount"
          icon="mdi-link-variant"
          trend="neutral"
          :trend-value="String(withReferralsCount)"
          trend-label="referrals"
        />
      </v-col>
      <v-col cols="6" sm="6" md="3">
        <HpaDashboardWidget
          role="marketing_staff"
          :loading="false"
          title="Pending"
          :value="pendingCount"
          icon="mdi-clock-alert"
          trend="neutral"
          :trend-value="String(pendingCount)"
          trend-label="pending"
        />
      </v-col>
    </v-row>

    <!-- Top referrers & Campaign snapshot -->
    <v-row class="mb-6">
      <v-col cols="12" lg="8">
        <v-card elevation="0" rounded="lg" class="modern-card h-100">
          <div class="section-card-header">
            <div class="section-card-icon">
              <v-icon icon="mdi-link-variant" size="20" />
            </div>
            <span class="section-card-title">Top referrers this month</span>
            <v-spacer />
            <v-btn variant="text" color="primary" size="small" to="/marketing/referral">Referral link</v-btn>
          </div>
          <v-divider class="settings-divider" />
          <v-card-text class="pa-4">
            <v-list density="compact" class="pa-0">
              <v-list-item v-for="r in topReferrers" :key="r.id" class="px-0">
                <template #prepend>
                  <v-avatar size="36" class="mr-3">
                    <v-img :src="getAvatarUrl(r.name)" />
                  </v-avatar>
                </template>
                <v-list-item-title class="text-body-2">{{ r.name }}</v-list-item-title>
                <v-list-item-subtitle class="text-caption">{{ r.signUps }} sign-ups · {{ formatPrice(r.earnings) }} earned</v-list-item-subtitle>
                <template #append>
                  <v-chip size="x-small" color="primary" variant="tonal" prepend-icon="mdi-medal">{{ r.rank }}</v-chip>
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
              <v-icon icon="mdi-bullhorn-outline" size="20" />
            </div>
            <span class="section-card-title">Campaign snapshot</span>
          </div>
          <v-divider class="settings-divider" />
          <v-card-text class="pa-4">
            <div class="d-flex justify-space-between align-center mb-2">
              <span class="text-body-2">Isabela Launch</span>
              <span class="text-body-2 font-weight-medium text-success">Active</span>
            </div>
            <div class="text-caption text-medium-emphasis mb-3">Clicks: 320 · Sign-ups: 48 · Conv. 15%</div>
            <div class="d-flex justify-space-between align-center">
              <span class="text-body-2">First Ride Free</span>
              <span class="text-body-2 font-weight-medium text-success">Active</span>
            </div>
            <div class="text-caption text-medium-emphasis mb-0">Clicks: 185 · Sign-ups: 22 · Conv. 12%</div>
          </v-card-text>
        </v-card>
      </v-col>
    </v-row>

    <HpaDataTable
      title="Marketing partners"
      icon="mdi-bullhorn-outline"
      :headers="headers"
      :items="partners"
      :loading="loading"
      searchable
      exportable
      selectable
    >
      <template #item.full_name="{ item }">
        <div class="d-flex align-center py-2">
          <v-avatar size="40" class="mr-3">
            <v-img :src="getAvatarUrl(item.full_name ?? item.name, item.avatar_url)" />
          </v-avatar>
          <div>
            <div class="font-weight-medium">{{ item.full_name }}</div>
            <div class="d-flex align-center flex-wrap gap-1">
              <span class="text-caption text-medium-emphasis">{{ item.email }}</span>
              <EmailVerifiedBadge :verified="!!(item as { email_verified?: boolean }).email_verified" />
            </div>
          </div>
        </div>
      </template>
      <template #item.status="{ item }">
        <v-chip :color="getStatusColor(item.status)" :prepend-icon="getStatusIcon(item.status)" size="small" variant="tonal">
          {{ item.status }}
        </v-chip>
      </template>
      <template #item.referral_code="{ item }">
        <code class="text-caption">{{ item.referral_code || '—' }}</code>
      </template>
      <template #item.actions="{ item }">
        <div class="d-flex gap-2 flex-wrap">
          <v-btn icon variant="text" size="small" color="action" aria-label="View details" @click="viewPartner(item)">
            <v-icon>mdi-eye</v-icon>
            <v-tooltip activator="parent" location="top">View details</v-tooltip>
          </v-btn>
          <v-btn icon variant="text" size="small" color="primary" aria-label="Edit" @click="openEditDialog(item)">
            <v-icon>mdi-pencil</v-icon>
            <v-tooltip activator="parent" location="top">Edit</v-tooltip>
          </v-btn>
          <v-btn icon variant="text" size="small" color="error" aria-label="Delete" @click="openDeleteConfirm(item)">
            <v-icon>mdi-delete-outline</v-icon>
            <v-tooltip activator="parent" location="top">Delete</v-tooltip>
          </v-btn>
        </div>
      </template>
      <template #bulk-actions="{ selected }">
        <v-btn variant="text" color="primary" prepend-icon="mdi-email" @click="sendBulkEmail(selected)">Send email</v-btn>
        <v-btn variant="text" color="action" prepend-icon="mdi-file-export" @click="exportSelected(selected)">Export</v-btn>
      </template>
    </HpaDataTable>

    <HpaModal
      v-model="showFormDialog"
      :title="editingId ? 'Edit marketing partner' : 'Add marketing partner'"
      :icon="editingId ? 'mdi-pencil' : 'mdi-account-plus'"
      max-width="600"
      @confirm="handleSave"
    >
      <v-form ref="formRef">
        <v-row>
          <v-col cols="12" md="6">
            <v-text-field :model-value="form.first_name" @update:model-value="(v) => form.first_name = formatInput(v, 'letters')" label="First name" prepend-inner-icon="mdi-account" />
          </v-col>
          <v-col cols="12" md="6">
            <v-text-field :model-value="form.last_name" @update:model-value="(v) => form.last_name = formatInput(v, 'letters')" label="Last name" prepend-inner-icon="mdi-account" />
          </v-col>
          <v-col cols="12" md="6">
            <v-text-field v-model="form.email" label="Email" type="email" prepend-inner-icon="mdi-email" />
          </v-col>
          <v-col cols="12" md="6">
            <v-text-field :model-value="form.phone" @update:model-value="(v) => form.phone = formatInput(v, 'phone')" label="Phone" prepend-inner-icon="mdi-phone" placeholder="09xx xxx xxxx" />
          </v-col>
          <v-col cols="12" md="6">
            <v-text-field :model-value="form.referral_code" @update:model-value="(v) => form.referral_code = formatInput(v, 'referralCode')" label="Referral code" prepend-inner-icon="mdi-link-variant" placeholder="e.g. BULOD-JUAN" />
          </v-col>
          <v-col cols="12" md="6">
            <v-select v-model="form.status" :items="statusOptions" label="Status" />
          </v-col>
          <v-col cols="12">
            <v-textarea v-model="form.notes" label="Notes" rows="2" prepend-inner-icon="mdi-note-text" />
          </v-col>
        </v-row>
      </v-form>
    </HpaModal>

    <HpaConfirmModal
      v-model="showDeleteConfirm"
      title="Delete marketing partner?"
      :message="deleteMessage"
      confirm-text="Delete"
      cancel-text="Cancel"
      variant="danger"
      @confirm="handleDeleteConfirm"
    />
  </DashboardTemplate>
</template>

<script setup lang="ts">
import { ref, computed, onMounted } from 'vue'
import { useRouter } from 'vue-router'
import HpaDataTable from '@/components/base/HpaDataTable.vue'
import HpaDashboardWidget from '@/components/base/HpaDashboardWidget.vue'
import HpaModal from '@/components/base/HpaModal.vue'
import HpaConfirmModal from '@/components/base/HpaConfirmModal.vue'
import DashboardTemplate from '@/components/DashboardTemplate.vue'
import { formatPrice } from '@/utils/priceFormat'
import { useToastStore } from '@/stores/toast'
import { getAvatarUrl } from '@/constants/images'
import { createMarketingPartner, deleteMarketingPartner, getMarketingStaff, updateMarketingPartner } from '@/services/marketingStaff'
import { MARKETING_PARTNERS_SEED, TOP_REFERRERS_SEED } from '@/constants/marketingSeed'
import type { TopReferrerItem } from '@/constants/marketingSeed'
import { hasInjectionRisk, isSafeText, sanitizeBasicText } from '@/utils/inputValidation'
import { formatInput } from '@/utils/inputFormatters'
import { getUserScopedItem, setUserScopedItem } from '@/utils/userScopedStorage'
import EmailVerifiedBadge from '@/components/shared/EmailVerifiedBadge.vue'

const MARKETING_STORAGE_KEY = 'bulodph_admin_marketing_staff'
const router = useRouter()
const toast = useToastStore()
const loading = ref(false)
const showFormDialog = ref(false)
const showDeleteConfirm = ref(false)
const editingId = ref<number | string | null>(null)
const partnerToDelete = ref<{ id: number | string; full_name: string } | null>(null)
const formRef = ref<{ validate: () => Promise<{ valid: boolean }> } | null>(null)

const statusOptions = ['Active', 'Pending', 'Inactive']

const form = ref({
  first_name: '',
  last_name: '',
  email: '',
  phone: '',
  referral_code: '',
  status: 'Active',
  notes: '',
})

const headers = [
  { title: 'Name', key: 'full_name', sortable: true },
  { title: 'Phone', key: 'phone', sortable: true },
  { title: 'Referral code', key: 'referral_code', sortable: true },
  { title: 'Referrals', key: 'referrals_count', sortable: true },
  { title: 'Status', key: 'status', sortable: true },
  { title: 'Actions', key: 'actions', sortable: false },
]

const partners = ref<any[]>([])

function mapApiPartner(item: any) {
  const name = item.full_name || item.name || 'Unnamed'
  const id = item.id
  return {
    id: typeof id === 'number' ? id : String(id ?? ''),
    full_name: String(name),
    email: String(item.email ?? ''),
    phone: String(item.phone ?? ''),
    city: item.city ?? '',
    province: item.province ?? '',
    referral_code: item.referral_code ?? '',
    status: (item.status as 'Active' | 'Pending' | 'Inactive') ?? 'Active',
    referrals_count: Number(item.referrals_count ?? 0),
    notes: item.notes ?? '',
  }
}

async function loadPartners() {
  loading.value = true
  const data = await getMarketingStaff()
  if (data?.length) {
    partners.value = data.map(mapApiPartner)
    setUserScopedItem(MARKETING_STORAGE_KEY, partners.value)
  } else {
    const stored = getUserScopedItem<any[]>(MARKETING_STORAGE_KEY)
    partners.value = Array.isArray(stored) && stored.length ? stored : JSON.parse(JSON.stringify(MARKETING_PARTNERS_SEED))
  }
  loading.value = false
}

onMounted(() => {
  loadPartners()
})

/** Top referrers from live partners (by referrals_count); fallback to seed when none. */
const topReferrers = computed((): TopReferrerItem[] => {
  const withReferrals = partners.value
    .filter(p => (p.referrals_count ?? 0) > 0)
    .sort((a, b) => (b.referrals_count ?? 0) - (a.referrals_count ?? 0))
  const top = withReferrals.slice(0, 5)
  if (!top.length) return [...TOP_REFERRERS_SEED]
  return top.map((p, i) => ({
    id: typeof p.id === 'number' ? p.id : i + 1,
    name: p.full_name ?? p.name ?? 'Unnamed',
    signUps: p.referrals_count ?? 0,
    earnings: (p.referrals_count ?? 0) * 200,
    rank: `#${i + 1}`,
  }))
})

const activeCount = computed(() => partners.value.filter(p => p.status === 'Active').length)
const withReferralsCount = computed(() => partners.value.filter(p => p.referrals_count > 0).length)
const pendingCount = computed(() => partners.value.filter(p => p.status === 'Pending').length)
const deleteMessage = computed(() =>
  partnerToDelete.value ? `Remove "${partnerToDelete.value.full_name}"? This cannot be undone.` : ''
)

function getStatusIcon(status: string): string {
  const map: Record<string, string> = {
    Active: 'mdi-check-circle',
    Pending: 'mdi-clock-outline',
    Inactive: 'mdi-account-off-outline',
  }
  return map[status] ?? 'mdi-circle-outline'
}

function getStatusColor(status: string) {
  const map: Record<string, string> = { Active: 'success', Pending: 'warning', Inactive: 'grey' }
  return map[status] || 'grey'
}

function viewPartner(item: (typeof partners.value)[0]) {
  router.push({
    name: 'marketing-staff-details',
    params: { id: String(item.id) },
    state: { partner: item },
  })
}

function openAddDialog() {
  editingId.value = null
  form.value = { first_name: '', last_name: '', email: '', phone: '', referral_code: '', status: 'Active', notes: '' }
  showFormDialog.value = true
}

function openEditDialog(item: (typeof partners.value)[0]) {
  editingId.value = item.id
  const [first = '', ...rest] = item.full_name.split(' ')
  form.value = {
    first_name: first,
    last_name: rest.join(' ') || '',
    email: item.email,
    phone: item.phone,
    referral_code: item.referral_code || '',
    status: item.status,
    notes: item.notes || '',
  }
  showFormDialog.value = true
}

async function handleSave() {
  const firstName = sanitizeBasicText(form.value.first_name)
  const lastName = sanitizeBasicText(form.value.last_name)
  const full_name = [firstName, lastName].filter(Boolean).join(' ') || 'Unnamed'
  const email = sanitizeBasicText(form.value.email)
  const phone = sanitizeBasicText(form.value.phone)
  const referral_code = sanitizeBasicText(form.value.referral_code)
  const notes = sanitizeBasicText(form.value.notes)

  if (hasInjectionRisk(full_name) || (notes && (!isSafeText(notes) || hasInjectionRisk(notes)))) {
    toast.error('Please remove unsafe characters from the form.')
    return
  }

  const payload = {
    name: full_name,
    full_name,
    email,
    phone,
    referral_code,
    status: form.value.status,
    notes,
  }

  if (editingId.value) {
    const updated = await updateMarketingPartner(editingId.value, payload)
    if (updated) {
      const idx = partners.value.findIndex(x => x.id == editingId.value)
      if (idx !== -1) partners.value[idx] = mapApiPartner(updated)
      else partners.value.unshift(mapApiPartner(updated))
      toast.success('Marketing partner updated')
    } else {
      const p = partners.value.find(x => x.id == editingId.value)
      if (p) {
        p.full_name = full_name
        p.email = email
        p.phone = phone
        p.referral_code = referral_code
        p.status = form.value.status
        p.notes = notes
      }
      setUserScopedItem(MARKETING_STORAGE_KEY, partners.value)
      toast.warning('Update failed on server. Saved locally for now.')
    }
  } else {
    const created = await createMarketingPartner(payload)
    if (created) {
      partners.value.unshift(mapApiPartner(created))
      toast.success('Marketing partner added')
    } else {
      const id = Math.max(0, ...partners.value.map(x => (typeof x.id === 'number' ? x.id : 0))) + 1
      partners.value.push({
        id,
        full_name,
        email,
        phone,
        referral_code,
        status: form.value.status,
        referrals_count: 0,
        notes,
      })
      setUserScopedItem(MARKETING_STORAGE_KEY, partners.value)
      toast.warning('Create failed on server. Saved locally for now.')
    }
  }
  showFormDialog.value = false
}

function openDeleteConfirm(item: { id: number | string; full_name: string }) {
  partnerToDelete.value = item
  showDeleteConfirm.value = true
}

async function handleDeleteConfirm() {
  if (!partnerToDelete.value) return
  const { id, full_name } = partnerToDelete.value
  const ok = await deleteMarketingPartner(id)
  partners.value = partners.value.filter(p => p.id !== id)
  partnerToDelete.value = null
  if (ok) {
    toast.success(`"${full_name}" removed`)
  } else {
    setUserScopedItem(MARKETING_STORAGE_KEY, partners.value)
    toast.warning('Delete failed on server. Removed locally for now.')
  }
}

function sendBulkEmail(selected: { name?: string; email?: string }[]) {
  const emails = selected.map(p => (p as { email?: string }).email).filter(Boolean).join(',')
  if (emails) {
    window.location.href = `mailto:${emails}`
  } else {
    toast.info('No email addresses for selected partners.')
  }
}

function exportSelected(selected: Record<string, unknown>[]) {
  if (!selected.length) {
    toast.info('Select at least one partner to export.')
    return
  }
  const headers = ['name', 'email', 'phone', 'city', 'province', 'status', 'referrals_count']
  const rows = selected.map(row => headers.map(h => row[h] ?? ''))
  const csv = [headers.join(','), ...rows.map(r => r.map(c => `"${String(c).replace(/"/g, '""')}"`).join(','))].join('\n')
  const blob = new Blob(['\ufeff' + csv], { type: 'text/csv;charset=utf-8;' })
  const url = URL.createObjectURL(blob)
  const a = document.createElement('a')
  a.href = url
  a.download = `marketing-staff-export-${new Date().toISOString().slice(0, 10)}.csv`
  a.click()
  URL.revokeObjectURL(url)
  toast.success('Export downloaded.')
}
</script>
