<template>
  <DashboardTemplate title="Webhook Logs" subtitle="Track payment webhook status and failures.">
    <v-card class="modern-card section-card-accent" elevation="0" rounded="lg">
      <div class="section-card-header">
        <div class="section-card-icon"><v-icon icon="mdi-webhook" size="20" /></div>
        <span class="section-card-title">Payment webhooks</span>
        <v-spacer />
        <v-select v-model="statusFilter" :items="['All', 'Success', 'Failed', 'Pending']" density="compact" variant="outlined" hide-details style="max-width: 140px" rounded="lg" />
      </div>
      <v-divider class="dashboard-divider" />
      <v-data-table v-model:model-value="selectedLogs" :headers="headers" :items="filtered" :items-per-page="15" density="comfortable" class="elevation-0" show-select item-value="id">
        <template #item.status="{ item }">
          <v-chip :color="item.status === 'Success' ? 'success' : item.status === 'Failed' ? 'error' : 'warning'" :prepend-icon="item.status === 'Success' ? 'mdi-check-circle' : item.status === 'Failed' ? 'mdi-close-circle' : 'mdi-alert-circle-outline'" size="small" variant="tonal">{{ item.status }}</v-chip>
        </template>
        <template #item.provider="{ item }">
          <v-chip size="x-small" variant="outlined">{{ item.provider }}</v-chip>
        </template>
        <template #item.actions="{ item }">
          <v-btn v-if="item.status === 'Failed'" size="x-small" variant="tonal" color="primary" rounded="lg" @click="retry(item)">Retry</v-btn>
        </template>
      </v-data-table>
    </v-card>
  </DashboardTemplate>
</template>

<script setup lang="ts">
import { ref, computed } from 'vue'
import DashboardTemplate from '@/components/DashboardTemplate.vue'
import { useToastStore } from '@/stores/toast'

const toast = useToastStore()
const statusFilter = ref('All')
const selectedLogs = ref<string[]>([])

const headers = [
  { title: 'Event ID', key: 'id', width: '120px' },
  { title: 'Provider', key: 'provider', width: '100px' },
  { title: 'Event', key: 'event' },
  { title: 'Booking', key: 'booking', width: '100px' },
  { title: 'Amount', key: 'amount', width: '110px' },
  { title: 'Status', key: 'status', width: '100px' },
  { title: 'Time', key: 'timestamp', width: '160px' },
  { title: '', key: 'actions', width: '80px', sortable: false },
]

const webhooks = ref([
  { id: 'WH-001', provider: 'GCash', event: 'payment.success', booking: 'BK-1234', amount: '₱3,500', status: 'Success', timestamp: '2026-02-23 10:45' },
  { id: 'WH-002', provider: 'Maya', event: 'payment.success', booking: 'BK-1235', amount: '₱1,800', status: 'Success', timestamp: '2026-02-23 09:30' },
  { id: 'WH-003', provider: 'GCash', event: 'payment.failed', booking: 'BK-1236', amount: '₱4,200', status: 'Failed', timestamp: '2026-02-22 15:20' },
  { id: 'WH-004', provider: 'Maya', event: 'refund.processed', booking: 'BK-1230', amount: '₱2,000', status: 'Success', timestamp: '2026-02-22 12:00' },
  { id: 'WH-005', provider: 'GCash', event: 'payment.pending', booking: 'BK-1237', amount: '₱5,000', status: 'Pending', timestamp: '2026-02-22 10:15' },
  { id: 'WH-006', provider: 'GCash', event: 'payment.failed', booking: 'BK-1238', amount: '₱1,500', status: 'Failed', timestamp: '2026-02-21 14:30' },
])

const filtered = computed(() => statusFilter.value === 'All' ? webhooks.value : webhooks.value.filter(w => w.status === statusFilter.value))

function retry(w: typeof webhooks.value[0]) {
  toast.info(`Retrying webhook ${w.id}…`)
  w.status = 'Pending'
}
</script>
