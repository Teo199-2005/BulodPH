<template>
  <DashboardTemplate title="Fraud & Risk Dashboard" subtitle="Monitor suspicious activity and high-risk bookings.">
    <v-row class="mb-4">
      <v-col cols="6" sm="3">
        <v-card class="modern-card section-card-accent" elevation="0" rounded="lg">
          <v-card-text class="pa-4 text-center">
            <v-icon icon="mdi-alert-circle" size="28" color="error" class="mb-1" />
            <p class="text-h5 font-weight-bold mb-0">{{ highRisk }}</p>
            <p class="text-caption text-medium-emphasis">High risk</p>
          </v-card-text>
        </v-card>
      </v-col>
      <v-col cols="6" sm="3">
        <v-card class="modern-card section-card-accent" elevation="0" rounded="lg">
          <v-card-text class="pa-4 text-center">
            <v-icon icon="mdi-alert" size="28" color="warning" class="mb-1" />
            <p class="text-h5 font-weight-bold mb-0">{{ mediumRisk }}</p>
            <p class="text-caption text-medium-emphasis">Medium risk</p>
          </v-card-text>
        </v-card>
      </v-col>
      <v-col cols="6" sm="3">
        <v-card class="modern-card section-card-accent" elevation="0" rounded="lg">
          <v-card-text class="pa-4 text-center">
            <v-icon icon="mdi-shield-check" size="28" color="success" class="mb-1" />
            <p class="text-h5 font-weight-bold mb-0">{{ cleared }}</p>
            <p class="text-caption text-medium-emphasis">Cleared</p>
          </v-card-text>
        </v-card>
      </v-col>
      <v-col cols="6" sm="3">
        <v-card class="modern-card section-card-accent" elevation="0" rounded="lg">
          <v-card-text class="pa-4 text-center">
            <v-icon icon="mdi-account-cancel" size="28" color="error" class="mb-1" />
            <p class="text-h5 font-weight-bold mb-0">{{ blocked }}</p>
            <p class="text-caption text-medium-emphasis">Blocked</p>
          </v-card-text>
        </v-card>
      </v-col>
    </v-row>

    <v-card class="modern-card section-card-accent" elevation="0" rounded="lg">
      <div class="section-card-header">
        <div class="section-card-icon"><v-icon icon="mdi-shield-alert" size="20" /></div>
        <span class="section-card-title">Risk flags</span>
        <v-spacer />
        <v-select v-model="riskFilter" :items="['All', 'High', 'Medium', 'Cleared', 'Blocked']" density="compact" variant="outlined" hide-details class="max-w-150" rounded="lg" />
      </div>
      <v-divider class="dashboard-divider" />
      <v-data-table v-model:model-value="selectedRisks" :headers="headers" :items="filtered" :items-per-page="10" density="comfortable" class="elevation-0" show-select item-value="id">
        <template #item.risk="{ item }">
          <v-chip :color="riskColor(item.risk)" :prepend-icon="riskIcon(item.risk)" size="small" variant="tonal">{{ item.risk }}</v-chip>
        </template>
        <template #item.actions="{ item }">
          <div class="action-buttons-gap">
            <v-btn v-if="item.risk !== 'Cleared' && item.risk !== 'Blocked'" size="x-small" color="success" variant="tonal" rounded="lg" @click="clear(item)">Clear</v-btn>
            <v-btn v-if="item.risk !== 'Blocked'" size="x-small" color="error" variant="tonal" rounded="lg" @click="block(item)">Block</v-btn>
          </div>
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
interface RiskFlag { id: string; date: string; user: string; type: string; details: string; risk: string }

const riskFilter = ref('All')
const selectedRisks = ref<string[]>([])
const headers = [
  { title: 'ID', key: 'id', width: '90px' },
  { title: 'Date', key: 'date', width: '110px' },
  { title: 'User', key: 'user' },
  { title: 'Type', key: 'type' },
  { title: 'Details', key: 'details' },
  { title: 'Risk', key: 'risk', width: '100px' },
  { title: '', key: 'actions', width: '160px', sortable: false },
]

const SEED: RiskFlag[] = [
  { id: 'RF-001', date: '2026-02-23', user: 'unknown@mail.test', type: 'Multiple failed logins', details: '12 failed attempts in 5 min from 203.0.113.50', risk: 'High' },
  { id: 'RF-002', date: '2026-02-22', user: 'juan@example.com', type: 'Suspicious booking', details: '3 bookings in 10 min, different vehicles', risk: 'Medium' },
  { id: 'RF-003', date: '2026-02-20', user: 'ana@example.com', type: 'Payment mismatch', details: 'GCash name does not match account', risk: 'High' },
  { id: 'RF-004', date: '2026-02-18', user: 'pedro@example.com', type: 'Duplicate account', details: 'Same phone on 2 accounts', risk: 'Medium' },
  { id: 'RF-005', date: '2026-02-15', user: 'lisa@example.com', type: 'Review investigation', details: 'Cleared after manual review', risk: 'Cleared' },
]

const flags = ref<RiskFlag[]>([])

function mapFlag(row: { id: string; created_at?: string; user_id?: string; reason?: string; booking_reference?: string; severity?: string; status?: string }): RiskFlag {
  const risk = row.status === 'cleared' ? 'Cleared' : row.status === 'blocked' ? 'Blocked' : row.severity === 'high' ? 'High' : row.severity === 'medium' ? 'Medium' : 'Medium'
  return {
    id: row.id,
    date: row.created_at ? new Date(row.created_at).toISOString().slice(0, 10) : '',
    user: row.user_id ?? '—',
    type: row.reason ?? '—',
    details: [row.reason, row.booking_reference].filter(Boolean).join(' · ') || '—',
    risk,
  }
}

async function loadFlags() {
  try {
    const { data } = await api.get<{ data?: { id: string; created_at?: string; user_id?: string; reason?: string; booking_reference?: string; severity?: string; status?: string }[] }>('/admin/fraud-flags')
    const list = Array.isArray(data) ? data : (data as { data?: unknown[] })?.data
    if (Array.isArray(list) && list.length) {
      flags.value = list.map(mapFlag)
      return
    }
  } catch {
    // fallback
  }
  flags.value = [...SEED]
}

onMounted(() => loadFlags())

const filtered = computed(() => riskFilter.value === 'All' ? flags.value : flags.value.filter(f => f.risk === riskFilter.value))
const highRisk = computed(() => flags.value.filter(f => f.risk === 'High').length)
const mediumRisk = computed(() => flags.value.filter(f => f.risk === 'Medium').length)
const cleared = computed(() => flags.value.filter(f => f.risk === 'Cleared').length)
const blocked = computed(() => flags.value.filter(f => f.risk === 'Blocked').length)

function riskColor(r: string) { return r === 'High' ? 'error' : r === 'Medium' ? 'warning' : r === 'Cleared' ? 'success' : 'grey-darken-1' }
function riskIcon(r: string): string { return r === 'High' ? 'mdi-alert-circle' : r === 'Medium' ? 'mdi-alert' : r === 'Cleared' ? 'mdi-check-circle' : 'mdi-shield-off-outline' }

async function clear(f: RiskFlag) {
  const prev = f.risk
  f.risk = 'Cleared'
  const isSeedId = /^RF-\d+$/.test(f.id)
  try {
    await api.patch(`/admin/fraud-flags/${f.id}`, { status: 'cleared' })
    toast.success(`Flag ${f.id} cleared.`)
  } catch {
    if (!isSeedId) {
      f.risk = prev
      toast.error('Failed to update flag.')
    } else {
      toast.success(`Flag ${f.id} cleared (demo).`)
    }
  }
}

async function block(f: RiskFlag) {
  const prev = f.risk
  f.risk = 'Blocked'
  const isSeedId = /^RF-\d+$/.test(f.id)
  try {
    await api.patch(`/admin/fraud-flags/${f.id}`, { status: 'blocked' })
    toast.success(`Flag ${f.id} blocked.`)
  } catch {
    if (!isSeedId) {
      f.risk = prev
      toast.error('Failed to update flag.')
    } else {
      toast.success(`Flag ${f.id} blocked (demo).`)
    }
  }
}
</script>
