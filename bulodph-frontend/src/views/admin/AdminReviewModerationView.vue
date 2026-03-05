<template>
  <DashboardTemplate title="Review Moderation" subtitle="Approve or reject reviews before they appear publicly.">
    <v-card class="modern-card section-card-accent" elevation="0" rounded="lg">
      <div class="section-card-header">
        <div class="section-card-icon"><v-icon icon="mdi-star-check" size="20" /></div>
        <span class="section-card-title">Pending reviews</span>
        <v-spacer />
        <v-chip color="warning" variant="tonal" size="small" prepend-icon="mdi-clock-outline">{{ pendingCount }} pending</v-chip>
      </div>
      <v-divider class="dashboard-divider" />
      <v-data-table
        v-model:model-value="selectedReviews"
        :headers="headers"
        :items="reviews"
        :items-per-page="10"
        density="comfortable"
        class="elevation-0"
        show-select
        item-value="id"
      >
        <template #top>
          <v-toolbar v-if="selectedReviews.length" density="compact" class="px-3 py-2">
            <span class="text-body-2">{{ selectedReviews.length }} selected</span>
            <v-spacer />
            <v-btn size="small" color="success" variant="tonal" rounded="lg" @click="bulkApprove">Approve</v-btn>
            <v-btn size="small" color="error" variant="tonal" rounded="lg" class="ms-2" @click="bulkReject">Reject</v-btn>
          </v-toolbar>
        </template>
        <template #item.rating="{ item }">
          <div class="d-flex align-center gap-1">
            <v-icon v-for="n in 5" :key="n" :icon="n <= item.rating ? 'mdi-star' : 'mdi-star-outline'" :color="n <= item.rating ? 'amber-darken-2' : 'grey-lighten-2'" size="16" />
          </div>
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
interface ReviewRow { id: string | number; reviewer: string; target: string; rating: number; comment: string; date: string; status: string }

const headers = [
  { title: 'Reviewer', key: 'reviewer' },
  { title: 'Vehicle / Owner', key: 'target' },
  { title: 'Rating', key: 'rating', width: '130px' },
  { title: 'Comment', key: 'comment' },
  { title: 'Date', key: 'date', width: '110px' },
  { title: 'Status', key: 'status', width: '110px' },
  { title: '', key: 'actions', width: '180px', sortable: false },
]

const SEED: ReviewRow[] = [
  { id: 1, reviewer: 'Maria Santos', target: 'Toyota Vios · JRC Rentals', rating: 5, comment: 'Great car and friendly owner!', date: '2026-02-22', status: 'Pending' },
  { id: 2, reviewer: 'Juan Cruz', target: 'Honda City · Isabela Cars', rating: 3, comment: 'Car was clean but late pickup.', date: '2026-02-20', status: 'Pending' },
  { id: 3, reviewer: 'Ana Reyes', target: 'Mitsubishi Montero · Prime Auto', rating: 4, comment: 'Smooth ride, would book again.', date: '2026-02-18', status: 'Approved' },
  { id: 4, reviewer: 'Pedro Garcia', target: 'Toyota Innova · JRC Rentals', rating: 1, comment: 'Terrible experience, car broke down.', date: '2026-02-15', status: 'Pending' },
  { id: 5, reviewer: 'Lisa Tan', target: 'Suzuki Ertiga · Cagayan Wheels', rating: 5, comment: 'Perfect!', date: '2026-02-12', status: 'Approved' },
]

const reviews = ref<ReviewRow[]>([])
const selectedReviews = ref<(string | number)[]>([])

function mapReview(row: { id: string; reviewer_id?: string; vehicle_reference?: string; rating?: number; comment?: string; created_at?: string; status?: string }): ReviewRow {
  const status = row.status === 'pending' ? 'Pending' : row.status === 'approved' ? 'Approved' : row.status === 'rejected' ? 'Rejected' : String(row.status ?? 'Pending')
  return {
    id: row.id,
    reviewer: row.reviewer_id ?? '—',
    target: row.vehicle_reference ?? '—',
    rating: Number(row.rating) || 0,
    comment: row.comment ?? '',
    date: row.created_at ? new Date(row.created_at).toISOString().slice(0, 10) : '',
    status,
  }
}

async function loadReviews() {
  try {
    const { data } = await api.get<{ data?: { id: string; reviewer_id?: string; vehicle_reference?: string; rating?: number; comment?: string; created_at?: string; status?: string }[] }>('/reviews')
    const list = Array.isArray(data) ? data : (data as { data?: unknown[] })?.data
    if (Array.isArray(list) && list.length) {
      reviews.value = list.map(mapReview)
      return
    }
  } catch {
    // fallback
  }
  reviews.value = [...SEED]
}

onMounted(() => loadReviews())

const pendingCount = computed(() => reviews.value.filter(r => r.status === 'Pending').length)

async function approve(item: ReviewRow) {
  const prev = item.status
  item.status = 'Approved'
  try {
    await api.patch(`/reviews/${item.id}/status`, { status: 'approved' })
    toast.success('Review approved.')
  } catch {
    item.status = prev
    toast.error('Failed to update review.')
  }
}

async function reject(item: ReviewRow) {
  const prev = item.status
  item.status = 'Rejected'
  try {
    await api.patch(`/reviews/${item.id}/status`, { status: 'rejected' })
    toast.success('Review rejected.')
  } catch {
    item.status = prev
    toast.error('Failed to update review.')
  }
}

function bulkApprove() {
  const ids = selectedReviews.value
  const pending = reviews.value.filter((r) => ids.includes(r.id) && r.status === 'Pending')
  pending.forEach((r) => approve(r))
  toast.success(pending.length ? `${pending.length} approved` : 'Select Pending reviews to approve.')
  selectedReviews.value = []
}

function bulkReject() {
  const ids = selectedReviews.value
  const pending = reviews.value.filter((r) => ids.includes(r.id) && r.status === 'Pending')
  pending.forEach((r) => reject(r))
  toast.success(pending.length ? `${pending.length} rejected` : 'Select Pending reviews to reject.')
  selectedReviews.value = []
}
</script>
