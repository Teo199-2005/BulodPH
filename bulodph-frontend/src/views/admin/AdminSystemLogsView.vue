<template>
  <DashboardTemplate title="System Logs" subtitle="Payment, API, and booking error logs.">
    <v-card class="modern-card section-card-accent" elevation="0" rounded="lg">
      <div class="section-card-header">
        <div class="section-card-icon"><v-icon icon="mdi-console" size="20" /></div>
        <span class="section-card-title">Latest logs</span>
        <v-spacer />
        <v-select v-model="levelFilter" :items="['All', 'Error', 'Warning', 'Info']" density="compact" variant="outlined" hide-details class="max-w-140 mr-2" rounded="lg" />
        <v-text-field v-model="search" prepend-inner-icon="mdi-magnify" placeholder="Search…" density="compact" variant="outlined" hide-details class="min-w-200 max-w-260" rounded="lg" />
      </div>
      <v-divider class="dashboard-divider" />
      <v-data-table v-model:model-value="selectedLogs" :headers="headers" :items="filtered" :items-per-page="15" density="comfortable" class="elevation-0" show-select item-value="id">
        <template #item.level="{ item }">
          <v-chip :color="levelColor(item.level)" size="small" variant="flat">
            <v-icon :icon="levelIcon(item.level)" size="14" start />
            {{ item.level }}
          </v-chip>
        </template>
        <template #item.timestamp="{ item }">
          <span class="text-caption text-medium-emphasis font-weight-medium">{{ item.timestamp }}</span>
        </template>
      </v-data-table>
    </v-card>
  </DashboardTemplate>
</template>

<script setup lang="ts">
import { ref, computed } from 'vue'
import DashboardTemplate from '@/components/DashboardTemplate.vue'

const levelFilter = ref('All')
const search = ref('')
const selectedLogs = ref<unknown[]>([])

const headers = [
  { title: 'Level', key: 'level', width: '110px' },
  { title: 'Source', key: 'source', width: '140px' },
  { title: 'Message', key: 'message' },
  { title: 'Timestamp', key: 'timestamp', width: '170px' },
]

const logs = ref([
  { id: 1, level: 'Error', source: 'Payment API', message: 'GCash webhook timeout after 12s — booking BK-1234', timestamp: '2026-02-23 10:45:12' },
  { id: 2, level: 'Warning', source: 'Auth', message: 'Rate limit reached for IP 203.0.113.50 — 15 login attempts', timestamp: '2026-02-23 10:30:05' },
  { id: 3, level: 'Error', source: 'Booking', message: 'Double-booking conflict on vehicle VH-089', timestamp: '2026-02-23 09:22:38' },
  { id: 4, level: 'Info', source: 'Payout', message: 'Payout PO-456 processed — ₱3,200 to Maya account', timestamp: '2026-02-23 09:00:00' },
  { id: 5, level: 'Warning', source: 'Storage', message: 'Avatar upload size exceeded 5MB — rejected', timestamp: '2026-02-22 16:45:20' },
  { id: 6, level: 'Error', source: 'Payment API', message: 'Maya checkout session creation failed — 500 response', timestamp: '2026-02-22 14:12:33' },
  { id: 7, level: 'Info', source: 'Auth', message: 'User maria@example.com password reset completed', timestamp: '2026-02-22 11:30:00' },
  { id: 8, level: 'Info', source: 'Booking', message: 'Booking BK-1235 auto-cancelled — no payment after 1h', timestamp: '2026-02-22 10:00:00' },
  { id: 9, level: 'Warning', source: 'Vehicle', message: 'Vehicle VH-102 listing has no photos — hidden from search', timestamp: '2026-02-21 15:20:00' },
  { id: 10, level: 'Error', source: 'Email', message: 'SMTP connection failed — booking confirmation not sent for BK-1236', timestamp: '2026-02-21 13:05:44' },
])

const filtered = computed(() => {
  let result = logs.value
  if (levelFilter.value !== 'All') result = result.filter(l => l.level === levelFilter.value)
  if (search.value) {
    const s = search.value.toLowerCase()
    result = result.filter(l => l.message.toLowerCase().includes(s) || l.source.toLowerCase().includes(s))
  }
  return result
})

function levelColor(l: string) { return l === 'Error' ? 'error' : l === 'Warning' ? 'warning' : 'info' }
function levelIcon(l: string) { return l === 'Error' ? 'mdi-alert-circle' : l === 'Warning' ? 'mdi-alert' : 'mdi-information' }
</script>
