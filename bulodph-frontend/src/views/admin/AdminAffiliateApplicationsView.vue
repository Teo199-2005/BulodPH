<template>
  <DashboardTemplate title="Affiliate Applications" subtitle="Review partner applications and approvals.">
    <v-card class="modern-card section-card-accent" elevation="0" rounded="lg">
      <div class="section-card-header">
        <div class="section-card-icon"><v-icon icon="mdi-account-check" size="20" /></div>
        <span class="section-card-title">Applications</span>
        <v-spacer />
        <v-select v-model="statusFilter" :items="['All', 'Pending', 'Approved', 'Rejected']" density="compact" variant="outlined" hide-details class="max-w-150" rounded="lg" />
      </div>
      <v-divider class="dashboard-divider" />
      <v-data-table
        v-model:model-value="selectedApps"
        :headers="headers"
        :items="filtered"
        :items-per-page="10"
        density="comfortable"
        class="elevation-0"
        show-select
        item-value="id"
      >
        <template #top>
          <v-toolbar v-if="selectedApps.length" density="compact" class="px-3 py-2">
            <span class="text-body-2">{{ selectedApps.length }} selected</span>
            <v-spacer />
            <v-btn size="small" color="success" variant="tonal" rounded="lg" @click="bulkApprove">Approve</v-btn>
            <v-btn size="small" color="error" variant="tonal" rounded="lg" class="ms-2" @click="bulkReject">Reject</v-btn>
          </v-toolbar>
        </template>
        <template #item.status="{ item }">
          <v-chip :color="item.status === 'Approved' ? 'success' : item.status === 'Rejected' ? 'error' : 'warning'" :prepend-icon="item.status === 'Approved' ? 'mdi-check-circle' : item.status === 'Rejected' ? 'mdi-close-circle' : 'mdi-clock-outline'" size="small" variant="tonal">{{ item.status }}</v-chip>
        </template>
        <template #item.actions="{ item }">
          <template v-if="item.status === 'Pending'">
            <div class="action-buttons-gap">
              <v-btn size="x-small" color="success" variant="tonal" rounded="lg" @click="approve(item)">Approve</v-btn>
              <v-btn size="x-small" color="error" variant="tonal" rounded="lg" @click="reject(item)">Reject</v-btn>
            </div>
          </template>
          <v-chip v-else size="x-small" variant="tonal" :prepend-icon="item.status === 'Approved' ? 'mdi-check-circle' : 'mdi-close-circle'">{{ item.status }}</v-chip>
        </template>
      </v-data-table>
    </v-card>
  </DashboardTemplate>
</template>

<script setup lang="ts">
import { ref, computed, onMounted } from 'vue'
import DashboardTemplate from '@/components/DashboardTemplate.vue'
import { useToastStore } from '@/stores/toast'
import api from '@/lib/api'

const toast = useToastStore()
interface Application { id: string; date: string; name: string; email: string; phone: string; reason: string; status: string }
const statusFilter = ref('All')
const headers = [
  { title: 'ID', key: 'id', width: '90px' },
  { title: 'Date', key: 'date', width: '110px' },
  { title: 'Name', key: 'name' },
  { title: 'Email', key: 'email' },
  { title: 'Reason', key: 'reason' },
  { title: 'Status', key: 'status', width: '110px' },
  { title: '', key: 'actions', width: '180px', sortable: false },
]

const SEED: Application[] = [
  { id: 'AFF-001', date: '2026-02-22', name: 'Maria Santos', email: 'maria@example.com', phone: '09171234567', reason: 'Social media influencer', status: 'Pending' },
  { id: 'AFF-002', date: '2026-02-20', name: 'Carlos Reyes', email: 'carlos@example.com', phone: '09181234567', reason: 'Travel blogger', status: 'Approved' },
  { id: 'AFF-003', date: '2026-02-18', name: 'Ana Lim', email: 'ana@example.com', phone: '09191234567', reason: 'Car dealership referral', status: 'Pending' },
  { id: 'AFF-004', date: '2026-02-15', name: 'Test Account', email: 'test@test.com', phone: '09001234567', reason: 'Spam', status: 'Rejected' },
]

const apps = ref<Application[]>([])
const selectedApps = ref<string[]>([])

function mapApp(row: { id: string; created_at?: string; name?: string; email?: string; company?: string; notes?: string; status?: string }): Application {
  const status = String(row.status ?? 'pending').replace(/^pending$/i, 'Pending').replace(/^approved$/i, 'Approved').replace(/^rejected$/i, 'Rejected') || (row.status ?? 'Pending')
  return {
    id: row.id,
    date: row.created_at ? new Date(row.created_at).toISOString().slice(0, 10) : '',
    name: row.name ?? '—',
    email: row.email ?? '—',
    phone: '—',
    reason: row.company ?? row.notes ?? '—',
    status,
  }
}

async function loadApps() {
  try {
    const { data } = await api.get<{ data?: { id: string; created_at?: string; name?: string; email?: string; company?: string; notes?: string; status?: string }[] }>('/admin/affiliate-applications')
    const list = Array.isArray(data) ? data : (data as { data?: unknown[] })?.data
    if (Array.isArray(list) && list.length) {
      apps.value = list.map(mapApp)
      return
    }
  } catch {
    // fallback
  }
  apps.value = [...SEED]
}

onMounted(() => loadApps())

const filtered = computed(() => statusFilter.value === 'All' ? apps.value : apps.value.filter(a => a.status === statusFilter.value))

async function approve(a: Application) {
  const prev = a.status
  a.status = 'Approved'
  try {
    await api.patch(`/admin/affiliate-applications/${a.id}`, { status: 'approved' })
    toast.success(`Application ${a.id} approved.`)
  } catch {
    a.status = prev
    toast.error('Failed to update application.')
  }
}

async function reject(a: Application) {
  const prev = a.status
  a.status = 'Rejected'
  try {
    await api.patch(`/admin/affiliate-applications/${a.id}`, { status: 'rejected' })
    toast.success(`Application ${a.id} rejected.`)
  } catch {
    a.status = prev
    toast.error('Failed to update application.')
  }
}

function bulkApprove() {
  const ids = selectedApps.value
  const pending = filtered.value.filter((a) => ids.includes(a.id) && a.status === 'Pending')
  pending.forEach((a) => approve(a))
  toast.success(pending.length ? `${pending.length} approved` : 'Select Pending applications to approve.')
  selectedApps.value = []
}

function bulkReject() {
  const ids = selectedApps.value
  const pending = filtered.value.filter((a) => ids.includes(a.id) && a.status === 'Pending')
  pending.forEach((a) => reject(a))
  toast.success(pending.length ? `${pending.length} rejected` : 'Select Pending applications to reject.')
  selectedApps.value = []
}
</script>
