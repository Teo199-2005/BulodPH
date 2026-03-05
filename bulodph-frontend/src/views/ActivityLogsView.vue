<template>
  <DashboardTemplate title="Account Activity" subtitle="Login history, device sessions, and account changes.">
    <!-- Stats row -->
    <v-row class="mb-4">
      <v-col cols="12" sm="4">
        <v-card class="modern-card section-card-accent" elevation="0" rounded="lg">
          <v-card-text class="pa-4 text-center">
            <v-icon icon="mdi-login" size="28" color="primary" class="mb-1" />
            <p class="text-h5 font-weight-bold mb-0">{{ totalLogins }}</p>
            <p class="text-caption text-medium-emphasis mb-0">Total logins</p>
          </v-card-text>
        </v-card>
      </v-col>
      <v-col cols="12" sm="4">
        <v-card class="modern-card section-card-accent" elevation="0" rounded="lg">
          <v-card-text class="pa-4 text-center">
            <v-icon icon="mdi-devices" size="28" color="primary" class="mb-1" />
            <p class="text-h5 font-weight-bold mb-0">{{ uniqueDevices }}</p>
            <p class="text-caption text-medium-emphasis mb-0">Devices used</p>
          </v-card-text>
        </v-card>
      </v-col>
      <v-col cols="12" sm="4">
        <v-card class="modern-card section-card-accent" elevation="0" rounded="lg">
          <v-card-text class="pa-4 text-center">
            <v-icon icon="mdi-shield-check" size="28" color="success" class="mb-1" />
            <p class="text-h5 font-weight-bold mb-0">{{ securityEvents }}</p>
            <p class="text-caption text-medium-emphasis mb-0">Security events</p>
          </v-card-text>
        </v-card>
      </v-col>
    </v-row>

    <!-- Activity log table -->
    <v-card class="modern-card section-card-accent" elevation="0" rounded="lg">
      <div class="section-card-header">
        <div class="section-card-icon"><v-icon icon="mdi-history" size="20" /></div>
        <span class="section-card-title">Recent activity</span>
        <v-spacer />
        <v-select
          v-model="filterType"
          :items="filterOptions"
          density="compact"
          variant="outlined"
          hide-details
          style="max-width: 180px"
          rounded="lg"
        />
      </div>
      <v-divider class="dashboard-divider" />
      <v-data-table
        :headers="headers"
        :items="filteredLogs"
        :items-per-page="10"
        density="comfortable"
        class="elevation-0"
      >
        <template #item.type="{ item }">
          <v-chip :color="typeColor(item.type)" size="small" variant="tonal">
            <v-icon :icon="typeIcon(item.type)" size="14" start />
            {{ item.type }}
          </v-chip>
        </template>
        <template #item.ip="{ item }">
          <span class="text-caption font-weight-medium">{{ item.ip }}</span>
        </template>
        <template #item.device="{ item }">
          <span class="text-body-2">{{ item.device }}</span>
        </template>
        <template #item.timestamp="{ item }">
          <span class="text-body-2 text-medium-emphasis">{{ item.timestamp }}</span>
        </template>
      </v-data-table>
    </v-card>
  </DashboardTemplate>
</template>

<script setup lang="ts">
import { ref, computed } from 'vue'
import DashboardTemplate from '@/components/DashboardTemplate.vue'

interface ActivityLog {
  id: number
  type: string
  description: string
  ip: string
  device: string
  timestamp: string
}

const filterType = ref('All')
const filterOptions = ['All', 'Login', 'Password', 'Profile', 'Security']

const headers = [
  { title: 'Type', key: 'type', width: '130px' },
  { title: 'Description', key: 'description' },
  { title: 'IP Address', key: 'ip', width: '140px' },
  { title: 'Device', key: 'device', width: '180px' },
  { title: 'Time', key: 'timestamp', width: '170px' },
]

const logs = ref<ActivityLog[]>([
  { id: 1, type: 'Login', description: 'Signed in successfully', ip: '192.168.1.42', device: 'Chrome · Windows', timestamp: '2026-02-23 10:30 AM' },
  { id: 2, type: 'Login', description: 'Signed in successfully', ip: '10.0.0.15', device: 'Safari · iPhone', timestamp: '2026-02-22 08:15 AM' },
  { id: 3, type: 'Password', description: 'Password changed', ip: '192.168.1.42', device: 'Chrome · Windows', timestamp: '2026-02-20 04:45 PM' },
  { id: 4, type: 'Profile', description: 'Profile photo updated', ip: '192.168.1.42', device: 'Chrome · Windows', timestamp: '2026-02-19 02:10 PM' },
  { id: 5, type: 'Profile', description: 'Email address updated', ip: '10.0.0.15', device: 'Safari · iPhone', timestamp: '2026-02-18 11:00 AM' },
  { id: 6, type: 'Security', description: 'New device detected', ip: '172.16.0.5', device: 'Firefox · Linux', timestamp: '2026-02-17 09:20 AM' },
  { id: 7, type: 'Login', description: 'Login attempt failed', ip: '203.0.113.50', device: 'Unknown', timestamp: '2026-02-16 03:55 PM' },
  { id: 8, type: 'Security', description: 'Account locked — too many failed logins', ip: '203.0.113.50', device: 'Unknown', timestamp: '2026-02-16 03:58 PM' },
  { id: 9, type: 'Login', description: 'Signed in successfully', ip: '192.168.1.42', device: 'Chrome · Windows', timestamp: '2026-02-15 10:00 AM' },
  { id: 10, type: 'Profile', description: 'Display name changed', ip: '192.168.1.42', device: 'Chrome · Windows', timestamp: '2026-02-14 01:30 PM' },
])

const filteredLogs = computed(() =>
  filterType.value === 'All' ? logs.value : logs.value.filter((l) => l.type === filterType.value)
)

const totalLogins = computed(() => logs.value.filter((l) => l.type === 'Login' && l.description.includes('successfully')).length)
const uniqueDevices = computed(() => new Set(logs.value.map((l) => l.device)).size)
const securityEvents = computed(() => logs.value.filter((l) => l.type === 'Security').length)

function typeColor(type: string) {
  const map: Record<string, string> = { Login: 'primary', Password: 'warning', Profile: 'info', Security: 'error' }
  return map[type] ?? 'default'
}
function typeIcon(type: string) {
  const map: Record<string, string> = { Login: 'mdi-login', Password: 'mdi-key', Profile: 'mdi-account-edit', Security: 'mdi-shield-alert' }
  return map[type] ?? 'mdi-information'
}
</script>
