<template>
  <DashboardTemplate title="Dispute Resolution" subtitle="Review disputes and update resolution status.">
    <v-row class="mb-4">
      <v-col cols="6" sm="3">
        <v-card class="modern-card section-card-accent" elevation="0" rounded="lg">
          <v-card-text class="pa-4 text-center">
            <p class="text-h5 font-weight-bold mb-0">{{ openCount }}</p>
            <p class="text-caption text-medium-emphasis">Open</p>
          </v-card-text>
        </v-card>
      </v-col>
      <v-col cols="6" sm="3">
        <v-card class="modern-card section-card-accent" elevation="0" rounded="lg">
          <v-card-text class="pa-4 text-center">
            <p class="text-h5 font-weight-bold mb-0">{{ inProgressCount }}</p>
            <p class="text-caption text-medium-emphasis">In progress</p>
          </v-card-text>
        </v-card>
      </v-col>
      <v-col cols="6" sm="3">
        <v-card class="modern-card section-card-accent" elevation="0" rounded="lg">
          <v-card-text class="pa-4 text-center">
            <p class="text-h5 font-weight-bold text-success mb-0">{{ resolvedCount }}</p>
            <p class="text-caption text-medium-emphasis">Resolved</p>
          </v-card-text>
        </v-card>
      </v-col>
      <v-col cols="6" sm="3">
        <v-card class="modern-card section-card-accent" elevation="0" rounded="lg">
          <v-card-text class="pa-4 text-center">
            <p class="text-h5 font-weight-bold mb-0">{{ disputes.length }}</p>
            <p class="text-caption text-medium-emphasis">Total</p>
          </v-card-text>
        </v-card>
      </v-col>
    </v-row>

    <v-card class="modern-card section-card-accent" elevation="0" rounded="lg">
      <div class="section-card-header">
        <div class="section-card-icon"><v-icon icon="mdi-gavel" size="20" /></div>
        <span class="section-card-title">All disputes</span>
        <v-spacer />
        <v-select v-model="statusFilter" :items="['All', 'Open', 'In progress', 'Resolved', 'Closed']" density="compact" variant="outlined" hide-details class="max-w-160" rounded="lg" />
      </div>
      <v-divider class="dashboard-divider" />
      <v-data-table
        v-model:model-value="selectedDisputes"
        :headers="headers"
        :items="filtered"
        :items-per-page="10"
        density="comfortable"
        class="elevation-0"
        show-select
        item-value="id"
      >
        <template #top>
          <v-toolbar v-if="selectedDisputes.length" density="compact" class="px-3 py-2">
            <span class="text-body-2">{{ selectedDisputes.length }} selected</span>
            <v-spacer />
            <v-btn size="small" color="primary" variant="tonal" rounded="lg" @click="bulkMarkInProgress">Investigate</v-btn>
            <v-btn size="small" color="success" variant="tonal" rounded="lg" class="ms-2" @click="bulkResolve">Resolve</v-btn>
          </v-toolbar>
        </template>
        <template #item.status="{ item }">
          <v-chip :color="statusColor(item.status)" :prepend-icon="statusIcon(item.status)" size="small" variant="tonal">{{ item.status }}</v-chip>
        </template>
        <template #item.priority="{ item }">
          <v-chip :color="item.priority === 'High' ? 'error' : item.priority === 'Medium' ? 'warning' : 'default'" :prepend-icon="item.priority === 'High' ? 'mdi-alert-circle' : item.priority === 'Medium' ? 'mdi-alert' : 'mdi-minus-circle-outline'" size="x-small" variant="tonal">{{ item.priority }}</v-chip>
        </template>
        <template #item.actions="{ item }">
          <v-btn v-if="item.status === 'Open'" size="x-small" color="primary" variant="tonal" rounded="lg" @click="markInProgress(item)">Investigate</v-btn>
          <v-btn v-else-if="item.status === 'In progress'" size="x-small" color="success" variant="tonal" rounded="lg" @click="resolve(item)">Resolve</v-btn>
          <v-chip v-else size="x-small" variant="outlined">Done</v-chip>
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
interface Dispute { id: string; date: string; renter: string; owner: string; reason: string; status: string; priority: string }

const statusFilter = ref('All')
const selectedDisputes = ref<string[]>([])
const loading = ref(false)
const headers = [
  { title: 'ID', key: 'id', width: '100px' },
  { title: 'Date', key: 'date', width: '110px' },
  { title: 'Renter', key: 'renter' },
  { title: 'Owner', key: 'owner' },
  { title: 'Reason', key: 'reason' },
  { title: 'Priority', key: 'priority', width: '100px' },
  { title: 'Status', key: 'status', width: '120px' },
  { title: '', key: 'actions', width: '120px', sortable: false },
]

const SEED: Dispute[] = [
  { id: 'DSP-001', date: '2026-02-22', renter: 'Maria Santos', owner: 'JRC Rentals', reason: 'Vehicle not as described', status: 'Open', priority: 'High' },
  { id: 'DSP-002', date: '2026-02-20', renter: 'Juan Cruz', owner: 'Isabela Cars', reason: 'Late pickup', status: 'In progress', priority: 'Medium' },
  { id: 'DSP-003', date: '2026-02-18', renter: 'Ana Reyes', owner: 'Prime Auto', reason: 'Damage claim disagreement', status: 'Resolved', priority: 'High' },
  { id: 'DSP-004', date: '2026-02-15', renter: 'Pedro Garcia', owner: 'JRC Rentals', reason: 'Overcharge on fuel', status: 'Closed', priority: 'Low' },
  { id: 'DSP-005', date: '2026-02-12', renter: 'Lisa Tan', owner: 'Cagayan Wheels', reason: 'Cancelled without refund', status: 'Open', priority: 'High' },
]

const disputes = ref<Dispute[]>([])

function mapDispute(row: { id: string; created_at?: string; reason?: string; status?: string }): Dispute {
  const status = row.status === 'filed' ? 'Open' : row.status === 'in_progress' ? 'In progress' : row.status === 'resolved' ? 'Resolved' : String(row.status ?? 'Open')
  return {
    id: row.id,
    date: row.created_at ? new Date(row.created_at).toISOString().slice(0, 10) : '',
    renter: '—',
    owner: '—',
    reason: row.reason ?? '',
    status,
    priority: 'Medium',
  }
}

async function loadDisputes() {
  loading.value = true
  try {
    const { data } = await api.get<{ data?: { id: string; created_at?: string; reason?: string; status?: string }[] }>('/disputes')
    const list = Array.isArray(data) ? data : (data as { data?: unknown[] })?.data
    if (Array.isArray(list) && list.length) {
      disputes.value = list.map(mapDispute)
    } else {
      disputes.value = [...SEED]
    }
  } catch {
    disputes.value = [...SEED]
  }
  loading.value = false
}

onMounted(() => loadDisputes())

const filtered = computed(() => statusFilter.value === 'All' ? disputes.value : disputes.value.filter(d => d.status === statusFilter.value))
const openCount = computed(() => disputes.value.filter(d => d.status === 'Open').length)
const inProgressCount = computed(() => disputes.value.filter(d => d.status === 'In progress').length)
const resolvedCount = computed(() => disputes.value.filter(d => d.status === 'Resolved' || d.status === 'Closed').length)

function statusColor(s: string) { return s === 'Open' ? 'error' : s === 'In progress' ? 'warning' : s === 'Resolved' ? 'success' : 'default' }
function statusIcon(s: string): string { return s === 'Open' ? 'mdi-alert-circle-outline' : s === 'In progress' ? 'mdi-clock-outline' : s === 'Resolved' || s === 'Closed' ? 'mdi-check-circle' : 'mdi-circle-outline' }

async function markInProgress(d: Dispute) {
  const prev = d.status
  d.status = 'In progress'
  const isSeedId = /^DSP-\d+$/.test(d.id)
  try {
    await api.patch(`/disputes/${d.id}/status`, { status: 'in_progress' })
    toast.success(`Dispute ${d.id} set to In progress.`)
  } catch {
    if (!isSeedId) {
      d.status = prev
      toast.error('Failed to update dispute.')
    } else {
      toast.success(`Dispute ${d.id} set to In progress (demo).`)
    }
  }
}

async function resolve(d: Dispute) {
  const prev = d.status
  d.status = 'Resolved'
  const isSeedId = /^DSP-\d+$/.test(d.id)
  try {
    await api.patch(`/disputes/${d.id}/status`, { status: 'resolved' })
    toast.success(`Dispute ${d.id} resolved.`)
  } catch {
    if (!isSeedId) {
      d.status = prev
      toast.error('Failed to update dispute.')
    } else {
      toast.success(`Dispute ${d.id} resolved (demo).`)
    }
  }
}

function bulkMarkInProgress() {
  const ids = Array.isArray(selectedDisputes.value) ? selectedDisputes.value : []
  const open = filtered.value.filter((d) => ids.includes(d.id) && d.status === 'Open')
  open.forEach((d) => { markInProgress(d) })
  toast.success(open.length ? `${open.length} marked In progress` : 'Select Open disputes to investigate.')
  selectedDisputes.value = []
}

function bulkResolve() {
  const ids = Array.isArray(selectedDisputes.value) ? selectedDisputes.value : []
  const inProgress = filtered.value.filter((d) => ids.includes(d.id) && d.status === 'In progress')
  inProgress.forEach((d) => { resolve(d) })
  toast.success(inProgress.length ? `${inProgress.length} resolved` : 'Select In progress disputes to resolve.')
  selectedDisputes.value = []
}
</script>
