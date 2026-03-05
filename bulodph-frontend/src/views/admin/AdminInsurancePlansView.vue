<template>
  <DashboardTemplate title="Insurance Plans" subtitle="Create and manage insurance options.">
    <v-card class="modern-card section-card-accent" elevation="0" rounded="lg">
      <div class="section-card-header">
        <div class="section-card-icon"><v-icon icon="mdi-shield-car" size="20" /></div>
        <span class="section-card-title">Plans</span>
        <v-spacer />
        <v-btn size="small" color="primary" variant="tonal" rounded="lg" prepend-icon="mdi-plus" @click="openAddPlan">Add plan</v-btn>
      </div>
      <v-divider class="dashboard-divider" />
      <v-data-table :headers="headers" :items="plans" :items-per-page="10" density="comfortable" class="elevation-0">
        <template #item.price="{ item }">
          <span class="font-weight-medium">₱{{ item.price.toLocaleString() }}</span>
        </template>
        <template #item.coverage="{ item }">
          <span class="text-body-2">₱{{ item.coverage.toLocaleString() }}</span>
        </template>
        <template #item.status="{ item }">
          <v-chip :color="item.status === 'Active' ? 'success' : 'default'" :prepend-icon="item.status === 'Active' ? 'mdi-check-circle' : 'mdi-pause-circle-outline'" size="small" variant="tonal">{{ item.status }}</v-chip>
        </template>
        <template #item.actions="{ item }">
          <v-btn size="x-small" variant="text" icon="mdi-pencil" @click="editPlan(item)" />
          <v-btn size="x-small" variant="text" :icon="item.status === 'Active' ? 'mdi-eye-off' : 'mdi-eye'" @click="togglePlan(item)" />
        </template>
      </v-data-table>
    </v-card>

    <HpaModal
      v-model="addPlanDialog"
      title="Add insurance plan"
      icon="mdi-shield-plus-outline"
      max-width="480"
      persistent
      confirm-text="Save"
      cancel-text="Cancel"
      @confirm="submitAddPlan"
    >
      <v-text-field v-model="newPlan.name" label="Plan name" density="compact" variant="outlined" hide-details class="mb-2" />
      <v-select v-model="newPlan.type" :items="planTypes" label="Type" density="compact" variant="outlined" hide-details class="mb-2" />
      <v-text-field v-model.number="newPlan.price" type="number" label="Price per day (₱)" density="compact" variant="outlined" hide-details class="mb-2" />
      <v-text-field v-model.number="newPlan.coverage" type="number" label="Max coverage (₱)" density="compact" variant="outlined" hide-details />
    </HpaModal>
  </DashboardTemplate>
</template>

<script setup lang="ts">
import { ref, reactive, onMounted } from 'vue'
import DashboardTemplate from '@/components/DashboardTemplate.vue'
import HpaModal from '@/components/base/HpaModal.vue'
import { useToastStore } from '@/stores/toast'
import api from '@/lib/api'

const toast = useToastStore()
const planTypes = ['Collision', 'Comprehensive', 'All-risk', 'Liability']
const addPlanDialog = ref(false)
const newPlan = reactive({ name: '', type: 'Collision', price: 0, coverage: 0 })

interface PlanRow { id: string | number; name: string; type: string; price: number; coverage: number; subscribers: number; status: string }

const headers = [
  { title: 'Plan', key: 'name' },
  { title: 'Type', key: 'type', width: '140px' },
  { title: 'Price / day', key: 'price', width: '120px' },
  { title: 'Max coverage', key: 'coverage', width: '140px' },
  { title: 'Subscribers', key: 'subscribers', width: '110px' },
  { title: 'Status', key: 'status', width: '100px' },
  { title: '', key: 'actions', width: '100px', sortable: false },
]

const SEED: PlanRow[] = [
  { id: 1, name: 'Basic Protection', type: 'Collision', price: 150, coverage: 50000, subscribers: 89, status: 'Active' },
  { id: 2, name: 'Standard Coverage', type: 'Comprehensive', price: 350, coverage: 150000, subscribers: 45, status: 'Active' },
  { id: 3, name: 'Premium Shield', type: 'All-risk', price: 650, coverage: 500000, subscribers: 18, status: 'Active' },
  { id: 4, name: 'Third-Party Only', type: 'Liability', price: 80, coverage: 30000, subscribers: 120, status: 'Active' },
  { id: 5, name: 'Legacy Plan A', type: 'Collision', price: 200, coverage: 75000, subscribers: 5, status: 'Inactive' },
]

const plans = ref<PlanRow[]>([])

function mapPlan(row: { id: string; name?: string; description?: string; price?: number; coverage_details?: string; is_active?: boolean }): PlanRow {
  const cov = row.coverage_details ? parseInt(row.coverage_details, 10) : 0
  return {
    id: row.id,
    name: row.name ?? '',
    type: row.description ?? 'Collision',
    price: Number(row.price) || 0,
    coverage: Number.isNaN(cov) ? 0 : cov,
    subscribers: 0,
    status: row.is_active !== false ? 'Active' : 'Inactive',
  }
}

async function loadPlans() {
  try {
    const { data } = await api.get<{ data?: { id: string; name?: string; description?: string; price?: number; coverage_details?: string; is_active?: boolean }[] }>('/insurance/plans')
    const list = Array.isArray(data) ? data : (data as { data?: unknown[] })?.data
    if (Array.isArray(list) && list.length) {
      plans.value = list.map(mapPlan)
      return
    }
  } catch {
    // fallback
  }
  plans.value = [...SEED]
}

onMounted(() => loadPlans())

function openAddPlan() {
  newPlan.name = ''
  newPlan.type = 'Collision'
  newPlan.price = 0
  newPlan.coverage = 0
  addPlanDialog.value = true
}

async function submitAddPlan() {
  if (!newPlan.name?.trim()) {
    toast.error('Enter a plan name.')
    return
  }
  try {
    const { data } = await api.post<{ data?: { id: string; name?: string; description?: string; price?: number; coverage_details?: string; is_active?: boolean } }>('/insurance/plans', {
      name: newPlan.name.trim(),
      description: newPlan.type,
      price: Number(newPlan.price) || 0,
      coverage_details: String(Number(newPlan.coverage) || 0),
    })
    const created = Array.isArray(data) ? null : (data as { data?: unknown })?.data ?? data
    if (created && typeof created === 'object' && 'id' in created) {
      plans.value.push(mapPlan(created as { id: string; name?: string; description?: string; price?: number; coverage_details?: string; is_active?: boolean }))
    } else {
      plans.value.push({
        id: plans.value.length + 1,
        name: newPlan.name.trim(),
        type: newPlan.type,
        price: Number(newPlan.price) || 0,
        coverage: Number(newPlan.coverage) || 0,
        subscribers: 0,
        status: 'Active',
      })
    }
    addPlanDialog.value = false
    toast.success(`Plan "${newPlan.name}" added.`)
  } catch {
    const nextId = Math.max(...plans.value.map(p => typeof p.id === 'number' ? p.id : 0), 0) + 1
    plans.value.push({
      id: nextId,
      name: newPlan.name.trim(),
      type: newPlan.type,
      price: Number(newPlan.price) || 0,
      coverage: Number(newPlan.coverage) || 0,
      subscribers: 0,
      status: 'Active',
    })
    addPlanDialog.value = false
    toast.success(`Plan "${newPlan.name}" added (demo).`)
  }
}

function editPlan(p: PlanRow) {
  toast.info(`Edit: ${p.name}. Use API to update plan.`)
}

async function togglePlan(p: PlanRow) {
  const prev = p.status
  p.status = p.status === 'Active' ? 'Inactive' : 'Active'
  const isActive = p.status === 'Active'
  try {
    await api.put(`/insurance/plans/${p.id}`, { is_active: isActive })
    toast.success(p.status === 'Active' ? 'Plan activated.' : 'Plan deactivated.')
  } catch {
    p.status = prev
    toast.error('Failed to update plan.')
  }
}
</script>
