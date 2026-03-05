<template>
  <DashboardTemplate title="VAT & Withholding Reports" subtitle="Export compliance reports for finance.">
    <v-row class="mb-4">
      <v-col cols="12" sm="4">
        <v-card class="modern-card section-card-accent" elevation="0" rounded="lg">
          <v-card-text class="pa-4 text-center">
            <v-icon icon="mdi-cash-multiple" size="28" color="primary" class="mb-1" />
            <p class="text-h5 font-weight-bold mb-0">₱{{ totalRevenue.toLocaleString() }}</p>
            <p class="text-caption text-medium-emphasis">Total revenue (YTD)</p>
          </v-card-text>
        </v-card>
      </v-col>
      <v-col cols="12" sm="4">
        <v-card class="modern-card section-card-accent" elevation="0" rounded="lg">
          <v-card-text class="pa-4 text-center">
            <v-icon icon="mdi-percent" size="28" color="warning" class="mb-1" />
            <p class="text-h5 font-weight-bold mb-0">₱{{ totalVat.toLocaleString() }}</p>
            <p class="text-caption text-medium-emphasis">VAT collected (12%)</p>
          </v-card-text>
        </v-card>
      </v-col>
      <v-col cols="12" sm="4">
        <v-card class="modern-card section-card-accent" elevation="0" rounded="lg">
          <v-card-text class="pa-4 text-center">
            <v-icon icon="mdi-bank-transfer" size="28" color="info" class="mb-1" />
            <p class="text-h5 font-weight-bold mb-0">₱{{ totalWithholding.toLocaleString() }}</p>
            <p class="text-caption text-medium-emphasis">Withholding tax</p>
          </v-card-text>
        </v-card>
      </v-col>
    </v-row>

    <v-card class="modern-card section-card-accent" elevation="0" rounded="lg">
      <div class="section-card-header">
        <div class="section-card-icon"><v-icon icon="mdi-file-chart" size="20" /></div>
        <span class="section-card-title">Monthly reports</span>
        <v-spacer />
        <v-btn size="small" color="primary" variant="outlined" rounded="lg" prepend-icon="mdi-download" @click="exportAll">Export all (CSV)</v-btn>
      </div>
      <v-divider class="dashboard-divider" />
      <v-data-table :headers="headers" :items="reports" :items-per-page="12" density="comfortable" class="elevation-0">
        <template #item.revenue="{ item }">₱{{ item.revenue.toLocaleString() }}</template>
        <template #item.vat="{ item }">₱{{ item.vat.toLocaleString() }}</template>
        <template #item.withholding="{ item }">₱{{ item.withholding.toLocaleString() }}</template>
        <template #item.status="{ item }">
          <v-chip :color="item.status === 'Filed' ? 'success' : 'warning'" :prepend-icon="item.status === 'Filed' ? 'mdi-check-circle' : 'mdi-clock-outline'" size="small" variant="tonal">{{ item.status }}</v-chip>
        </template>
        <template #item.actions="{ item }">
          <v-btn size="x-small" variant="text" icon="mdi-download" @click="download(item)" />
        </template>
      </v-data-table>
    </v-card>
  </DashboardTemplate>
</template>

<script setup lang="ts">
import { computed } from 'vue'
import DashboardTemplate from '@/components/DashboardTemplate.vue'
import { useToastStore } from '@/stores/toast'

const toast = useToastStore()

const headers = [
  { title: 'Period', key: 'period', width: '130px' },
  { title: 'Revenue', key: 'revenue', width: '130px' },
  { title: 'VAT (12%)', key: 'vat', width: '120px' },
  { title: 'Withholding', key: 'withholding', width: '120px' },
  { title: 'Bookings', key: 'bookings', width: '100px' },
  { title: 'Status', key: 'status', width: '100px' },
  { title: '', key: 'actions', width: '50px', sortable: false },
]

const reports = [
  { period: 'Feb 2026', revenue: 285000, vat: 34200, withholding: 5700, bookings: 78, status: 'Pending' },
  { period: 'Jan 2026', revenue: 312000, vat: 37440, withholding: 6240, bookings: 92, status: 'Filed' },
  { period: 'Dec 2025', revenue: 350000, vat: 42000, withholding: 7000, bookings: 105, status: 'Filed' },
  { period: 'Nov 2025', revenue: 270000, vat: 32400, withholding: 5400, bookings: 71, status: 'Filed' },
  { period: 'Oct 2025', revenue: 245000, vat: 29400, withholding: 4900, bookings: 65, status: 'Filed' },
]

const totalRevenue = computed(() => reports.reduce((s, r) => s + r.revenue, 0))
const totalVat = computed(() => reports.reduce((s, r) => s + r.vat, 0))
const totalWithholding = computed(() => reports.reduce((s, r) => s + r.withholding, 0))

function download(r: typeof reports[0]) { toast.info(`Downloading ${r.period} report…`) }
function exportAll() { toast.info('Exporting all reports…') }
</script>
