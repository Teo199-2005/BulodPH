<template>
  <DashboardTemplate :animate="true">
    <template #header>
      <div>
        <h1 class="page-title mb-1">BulodPH Reports</h1>
        <p class="page-subtitle">Platform reports, insights and export data</p>
      </div>
      <v-btn color="primary" size="default" prepend-icon="mdi-file-export" rounded="lg" aria-label="Export all reports as CSV" @click="exportAllReports(); toast.success('All reports exported.')">
        Export All
      </v-btn>
    </template>
    <div class="reports-page">
    <!-- Filters -->
    <div class="reports-filters-wrap mb-2">
      <v-btn
        variant="outlined"
        size="small"
        rounded="lg"
        class="filters-toggle-btn mb-2"
        :prepend-icon="showFilters ? 'mdi-chevron-up' : 'mdi-filter'"
        :color="showFilters ? 'primary' : undefined"
        aria-label="Toggle filters"
        @click="showFilters = !showFilters"
      >
        {{ showFilters ? 'Hide filters' : 'Filters' }}
      </v-btn>
      <v-expand-transition>
        <v-card v-show="showFilters" elevation="0" rounded="lg" class="modern-card mb-2 reports-filters-card">
      <v-card-text class="pa-2">
        <HpaDateRangePresets
          v-model="dateRangePreset"
          class="mb-3"
          @range="onDateRange"
        />
        <v-row align="center" dense>
          <v-col cols="12" md="3">
            <v-select
              v-model="selectedPeriod"
              :items="periods"
              label="Time Period"
              density="compact"
              hide-details
              prepend-inner-icon="mdi-calendar-range"
            />
          </v-col>
          <v-col cols="12" md="3">
            <v-text-field
              v-model="startDate"
              label="Start Date"
              type="date"
              density="compact"
              hide-details
            />
          </v-col>
          <v-col cols="12" md="3">
            <v-text-field
              v-model="endDate"
              label="End Date"
              type="date"
              density="compact"
              hide-details
            />
          </v-col>
        </v-row>
      </v-card-text>
        </v-card>
      </v-expand-transition>
    </div>

    <!-- Financial + Shift Statistics side by side; Client Reports as strip below -->
    <v-row class="reports-cards-row mb-2" dense align="start">
      <!-- Financial Summary -->
      <v-col cols="12" md="6" class="py-1">
        <v-card elevation="0" rounded="lg" class="modern-card reports-card">
          <div class="section-card-header section-card-header--with-actions">
            <div class="section-card-icon reports-icon-success">
              <v-icon icon="mdi-currency-php" size="20" />
            </div>
            <span class="section-card-title">Financial Summary</span>
            <v-spacer />
            <v-btn
              icon="mdi-download"
              variant="text"
              size="small"
              color="primary"
              aria-label="Export Financial Summary as CSV"
              @click="exportReport('financial'); toast.success('Financial report downloaded.')"
            >
              <v-icon>mdi-download</v-icon>
              <v-tooltip activator="parent" location="top">Export CSV</v-tooltip>
            </v-btn>
          </div>
          <v-divider class="dashboard-divider" />
          <v-card-text class="pa-2 pt-1">
            <v-row dense class="financial-row">
              <v-col cols="6" class="financial-col">
                <div class="text-center financial-stat-box rounded-lg bg-success-lighten">
                  <div class="text-overline text-success-darken">Total Revenue</div>
                  <div class="text-h6 font-weight-bold text-success">{{ formatPrice(financial.totalRevenue) }}</div>
                  <div class="text-caption text-success-darken mt-0">
                    <v-icon icon="mdi-trending-up" size="12" />
                    +{{ financial.totalRevenueTrend }}% from last month
                  </div>
                </div>
              </v-col>
              <v-col cols="6" class="financial-col">
                <div class="text-center financial-stat-box rounded-lg bg-primary-lighten">
                  <div class="text-overline text-primary-darken">Paid to owners</div>
                  <div class="text-h6 font-weight-bold text-primary">{{ formatPrice(financial.paidToOwners) }}</div>
                  <div class="text-caption text-primary-darken mt-0">
                    <v-icon icon="mdi-trending-up" size="12" />
                    +{{ financial.paidToOwnersTrend }}% from last month
                  </div>
                </div>
              </v-col>
              <v-col cols="6" class="financial-col">
                <div class="text-center financial-stat-box rounded-lg bg-warning-lighten">
                  <div class="text-overline text-warning-darken">Pending payouts</div>
                  <div class="text-h6 font-weight-bold text-warning">{{ formatPrice(financial.pendingPayouts) }}</div>
                  <div class="text-caption text-warning-darken mt-0">{{ financial.pendingPayoutsCount }} requests</div>
                </div>
              </v-col>
              <v-col cols="6" class="financial-col">
                <div class="text-center financial-stat-box rounded-lg bg-grey-lighten-3">
                  <div class="text-overline text-grey-darken-2">Overdue payouts</div>
                  <div class="text-h6 font-weight-bold text-grey-darken-2">{{ formatPrice(financial.overduePayouts) }}</div>
                  <div class="text-caption text-grey-darken-1 mt-0">{{ financial.overduePayoutsCount }} overdue</div>
                </div>
              </v-col>
            </v-row>
          </v-card-text>
        </v-card>
      </v-col>
      <!-- Booking Statistics -->
      <v-col cols="12" md="6" class="py-1">
        <v-card elevation="0" rounded="lg" class="modern-card reports-card">
          <div class="section-card-header section-card-header--with-actions">
            <div class="section-card-icon">
              <v-icon icon="mdi-calendar-check" size="20" />
            </div>
            <span class="section-card-title">Booking Statistics</span>
            <v-spacer />
            <v-btn
              icon="mdi-download"
              variant="text"
              size="small"
              color="primary"
              aria-label="Export Booking Statistics as CSV"
              @click="exportReport('bookings'); toast.success('Booking statistics downloaded.')"
            >
              <v-icon>mdi-download</v-icon>
              <v-tooltip activator="parent" location="top">Export CSV</v-tooltip>
            </v-btn>
          </div>
          <v-divider class="dashboard-divider" />
          <v-card-text class="pa-2 pt-1">
            <div class="chart-height chart-height--compact">
              <Bar :data="bookingChartData" :options="chartOptions" />
            </div>
            <v-row dense class="shift-stats-row mt-1">
              <v-col cols="6" class="py-0">
                <div class="d-flex align-center">
                  <div class="stat-dot stat-dot--completed mr-2"></div>
                  <div>
                    <div class="text-caption text-medium-emphasis">Completed</div>
                    <div class="text-body-2 font-weight-bold">{{ bookingStats.completed }} trips</div>
                  </div>
                </div>
              </v-col>
              <v-col cols="6" class="py-0">
                <div class="d-flex align-center">
                  <div class="stat-dot stat-dot--scheduled mr-2"></div>
                  <div>
                    <div class="text-caption text-medium-emphasis">Scheduled</div>
                    <div class="text-body-2 font-weight-bold">{{ bookingStats.scheduled }} bookings</div>
                  </div>
                </div>
              </v-col>
              <v-col cols="6" class="py-0">
                <div class="d-flex align-center">
                  <div class="stat-dot stat-dot--pending mr-2"></div>
                  <div>
                    <div class="text-caption text-medium-emphasis">Pending</div>
                    <div class="text-body-2 font-weight-bold">{{ bookingStats.pending }} bookings</div>
                  </div>
                </div>
              </v-col>
              <v-col cols="6" class="py-0">
                <div class="d-flex align-center">
                  <div class="stat-dot stat-dot--cancelled mr-2"></div>
                  <div>
                    <div class="text-caption text-medium-emphasis">Cancelled</div>
                    <div class="text-body-2 font-weight-bold">{{ bookingStats.cancelled }} bookings</div>
                  </div>
                </div>
              </v-col>
            </v-row>
          </v-card-text>
        </v-card>
      </v-col>
    </v-row>

    <!-- Platform reports strip -->
    <v-card elevation="0" rounded="lg" class="modern-card mb-2 client-reports-strip">
      <div class="client-reports-strip__inner">
        <div class="section-card-icon reports-icon-primary client-reports-strip__icon">
          <v-icon icon="mdi-chart-box-outline" size="20" />
        </div>
        <p class="client-reports-strip__text text-body-2 text-medium-emphasis mb-0">
          Platform reports: view users, listings and bookings. Export data for payouts, compliance and analytics.
        </p>
        <v-btn
          variant="outlined"
          color="primary"
          size="small"
          to="/admin"
          class="client-reports-strip__btn"
        >
          View dashboard
        </v-btn>
      </div>
    </v-card>

    <!-- Report Templates -->
    <v-card elevation="0" rounded="lg" class="modern-card mb-2">
      <div class="section-card-header">
        <div class="section-card-icon">
          <v-icon icon="mdi-file-document-multiple" size="20" />
        </div>
        <span class="section-card-title">Report Templates</span>
      </div>
      <v-divider class="dashboard-divider" />
      <v-list lines="two" class="pa-0 report-templates-list">
        <v-list-item
          v-for="template in reportTemplates"
          :key="template.id"
          class="px-3 py-1 report-template-item"
        >
          <template #prepend>
            <v-avatar :color="template.color" size="40">
              <v-icon :icon="template.icon" color="white" size="20" />
            </v-avatar>
          </template>

          <v-list-item-title class="font-weight-medium mb-0 text-body-2">
            {{ template.name }}
          </v-list-item-title>
          <v-list-item-subtitle class="text-caption">
            {{ template.description }}
          </v-list-item-subtitle>

          <template #append>
            <div class="d-flex gap-3 flex-wrap">
              <v-btn
                variant="outlined"
                color="primary"
                size="small"
                prepend-icon="mdi-eye"
                @click="openViewReport(template.id)"
              >
                View
              </v-btn>
              <v-btn
                variant="tonal"
                color="action"
                size="small"
                prepend-icon="mdi-download"
                @click="downloadReport(template.id)"
              >
                Download
              </v-btn>
            </div>
          </template>
        </v-list-item>
      </v-list>
    </v-card>

    <!-- Recent Reports -->
    <HpaDataTable
      title="Recent Reports"
      icon="mdi-history"
      :headers="recentReportsHeaders"
      :items="recentReports"
      :loading="loading"
      searchable
      exportable
    >
      <!-- Custom column: Type -->
      <template #item.type="{ item }">
        <v-chip
          :color="getReportTypeColor(item.type)"
          size="small"
          variant="tonal"
        >
          {{ item.type }}
        </v-chip>
      </template>

      <!-- Custom column: Status -->
      <template #item.status="{ item }">
        <v-chip
          :color="item.status === 'Ready' ? 'success' : 'warning'"
          size="small"
        >
          {{ item.status }}
        </v-chip>
      </template>

      <!-- Custom column: Actions -->
      <template #item.actions="{ item }">
        <div class="d-flex gap-2 flex-wrap">
          <v-btn
            icon="mdi-download"
            variant="text"
            size="small"
            color="primary"
            @click="downloadReport(item.id)"
          >
            <v-icon>mdi-download</v-icon>
            <v-tooltip activator="parent" location="top">Download</v-tooltip>
          </v-btn>
          <v-btn
            icon="mdi-share-variant"
            variant="text"
            size="small"
            color="action"
          >
            <v-icon>mdi-share-variant</v-icon>
            <v-tooltip activator="parent" location="top">Share</v-tooltip>
          </v-btn>
        </div>
      </template>
    </HpaDataTable>

    <HpaModal
      v-model="viewReportDialog"
      :title="viewReportTemplate?.name ?? 'Report'"
      :icon="viewReportTemplate?.icon ?? 'mdi-chart-box-outline'"
      max-width="520"
      persistent
      :show-actions="true"
    >
      <template v-if="viewReportTemplate" #default>
        <p class="text-body-2 text-medium-emphasis mb-2">{{ viewReportTemplate.description }}</p>
        <div class="report-view-summary">
          <template v-if="viewReportTemplate.id === 1">
            <p class="text-caption mb-1"><strong>Total revenue:</strong> {{ formatPrice(financial.totalRevenue) }}</p>
            <p class="text-caption mb-1"><strong>Paid to owners:</strong> {{ formatPrice(financial.paidToOwners) }}</p>
            <p class="text-caption mb-1"><strong>Pending payouts:</strong> {{ formatPrice(financial.pendingPayouts) }}</p>
          </template>
          <template v-else-if="viewReportTemplate.id === 2">
            <p class="text-caption mb-1"><strong>Completed:</strong> {{ bookingStats.completed }}</p>
            <p class="text-caption mb-1"><strong>Scheduled:</strong> {{ bookingStats.scheduled }}</p>
            <p class="text-caption mb-1"><strong>Pending:</strong> {{ bookingStats.pending }}</p>
            <p class="text-caption mb-1"><strong>Cancelled:</strong> {{ bookingStats.cancelled }}</p>
          </template>
          <template v-else>
            <p class="text-caption text-medium-emphasis">Summary data for this report will load when the report API is connected. Use Download to export current data.</p>
          </template>
        </div>
      </template>
      <template #actions>
        <v-spacer />
        <v-btn variant="text" rounded="lg" density="compact" @click="viewReportDialog = false">Close</v-btn>
        <v-btn
          v-if="viewReportTemplate"
          color="primary"
          prepend-icon="mdi-download"
          rounded="lg"
          density="compact"
          @click="downloadReport(viewReportTemplate.id); viewReportDialog = false"
        >
          Download CSV
        </v-btn>
      </template>
    </HpaModal>
    </div>
  </DashboardTemplate>
</template>

<script setup lang="ts">
import { ref, computed, onMounted, watch } from 'vue'
import { Bar } from 'vue-chartjs'
import DashboardTemplate from '@/components/DashboardTemplate.vue'
import {
  Chart as ChartJS,
  CategoryScale,
  LinearScale,
  BarElement,
  Title,
  Tooltip,
  Legend
} from 'chart.js'
import { format, subDays } from 'date-fns'
import HpaDataTable from '@/components/base/HpaDataTable.vue'
import HpaDateRangePresets from '@/components/base/HpaDateRangePresets.vue'
import HpaModal from '@/components/base/HpaModal.vue'
import { useToastStore } from '@/stores/toast'
import { formatPrice } from '@/utils/priceFormat'
import {
  FINANCIAL_SUMMARY_SEED,
  RECENT_REPORTS_SEED,
  BOOKING_STATS_SEED,
  BOOKING_CHART_SEED,
} from '@/constants/reportsSeed'
import type { FinancialSummarySeed } from '@/constants/reportsSeed'
import { getFinancialSummary, getBookingStats } from '@/services/reports'
import type { BookingStatsSeed } from '@/services/reports'

const toast = useToastStore()

// Register Chart.js components
ChartJS.register(CategoryScale, LinearScale, BarElement, Title, Tooltip, Legend)

// State
const loading = ref(false)
const financial = ref<FinancialSummarySeed>({ ...FINANCIAL_SUMMARY_SEED })
const bookingStats = ref<BookingStatsSeed>({ ...BOOKING_STATS_SEED })
const showFilters = ref(false)
const selectedPeriod = ref('This Month')
const startDate = ref(format(subDays(new Date(), 30), 'yyyy-MM-dd'))
const endDate = ref(format(new Date(), 'yyyy-MM-dd'))
const dateRangePreset = ref('last30')

function onDateRange(range: { start: Date; end: Date }) {
  startDate.value = format(range.start, 'yyyy-MM-dd')
  endDate.value = format(range.end, 'yyyy-MM-dd')
}

async function loadReports() {
  loading.value = true
  const [financialData, bookingData] = await Promise.all([
    getFinancialSummary({ startDate: startDate.value, endDate: endDate.value }),
    getBookingStats({ startDate: startDate.value, endDate: endDate.value }),
  ])
  if (financialData) financial.value = financialData
  else financial.value = { ...FINANCIAL_SUMMARY_SEED }
  if (bookingData) bookingStats.value = bookingData
  else bookingStats.value = { ...BOOKING_STATS_SEED }
  loading.value = false
}

onMounted(() => loadReports())
watch([startDate, endDate], () => loadReports())

// Options
const periods = ['Today', 'This Week', 'This Month', 'Last Month', 'This Quarter', 'This Year', 'Custom']

// Report Templates – BulodPH
const reportTemplates = [
  {
    id: 1,
    name: 'Monthly Revenue Report',
    description: 'Platform revenue, payouts to owners, and booking fees (GCash & Maya)',
    icon: 'mdi-currency-php',
    color: 'success',
  },
  {
    id: 2,
    name: 'Bookings Report',
    description: 'Booking volume by period, vehicle type, and location (the region & beyond)',
    icon: 'mdi-calendar-check',
    color: 'primary',
  },
  {
    id: 3,
    name: 'Listings Report',
    description: 'Active vehicles, new listings, and availability by car',
    icon: 'mdi-car-multiple',
    color: 'accent',
  },
  {
    id: 4,
    name: 'Payout Report',
    description: 'Payout requests, paid amounts, and overdue payouts to Kadua (owners)',
    icon: 'mdi-bank-transfer-out',
    color: 'warning',
  },
  {
    id: 5,
    name: 'User Growth Report',
    description: 'New sign-ups by role (renters, owners, partners), retention and referrals',
    icon: 'mdi-account-group',
    color: 'action',
  },
]

// Recent Reports Table
const recentReportsHeaders = [
  { title: 'Report Name', key: 'name', sortable: true },
  { title: 'Type', key: 'type', sortable: true },
  { title: 'Generated', key: 'generated', sortable: true },
  { title: 'Status', key: 'status', sortable: true },
  { title: 'Actions', key: 'actions', sortable: false },
]

const recentReports = ref([...RECENT_REPORTS_SEED])

// Chart Data – from seed (Completed=dark green, Scheduled=orange, Pending=yellow, Cancelled=red)
const bookingChartData = computed(() => ({
  labels: ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'],
  datasets: [
    { label: 'Completed', data: BOOKING_CHART_SEED.completed, backgroundColor: '#166534' },
    { label: 'Scheduled', data: BOOKING_CHART_SEED.scheduled, backgroundColor: '#ea580c' },
    { label: 'Pending', data: BOOKING_CHART_SEED.pending, backgroundColor: '#ca8a04' },
    { label: 'Cancelled', data: BOOKING_CHART_SEED.cancelled, backgroundColor: '#dc2626' },
  ],
}))

const chartOptions = {
  responsive: true,
  maintainAspectRatio: false,
  plugins: {
    legend: {
      display: true,
      position: 'top' as const,
    },
    tooltip: {
      mode: 'index' as const,
      intersect: false,
    },
  },
  scales: {
    y: {
      beginAtZero: true,
      grid: {
        color: 'rgba(0, 0, 0, 0.05)',
      },
      ticks: {
        stepSize: 10,
      },
    },
    x: {
      grid: {
        display: false,
      },
    },
  },
}

// Methods
const getReportTypeColor = (type: string) => {
  const colors: Record<string, string> = {
    Revenue: 'success',
    Bookings: 'primary',
    Listings: 'accent',
    Payouts: 'warning',
    'User Growth': 'action',
  }
  return colors[type] || 'grey'
}

function downloadCsv(filename: string, headers: string[], rows: (string | number)[][]) {
  const escape = (v: string | number) => `"${String(v).replace(/"/g, '""')}"`
  const csv = [headers.join(','), ...rows.map(r => r.map(escape).join(','))].join('\n')
  const blob = new Blob(['\ufeff' + csv], { type: 'text/csv;charset=utf-8;' })
  const url = URL.createObjectURL(blob)
  const a = document.createElement('a')
  a.href = url
  a.download = `${filename}-${startDate.value}-${endDate.value}.csv`
  a.click()
  URL.revokeObjectURL(url)
}

const exportAllReports = () => {
  const f = financial.value
  const b = bookingStats.value
  downloadCsv('bulodph-all-reports', ['Report', 'Metric', 'Value', 'Period'], [
    ['Financial', 'Total Revenue', formatPrice(f.totalRevenue), selectedPeriod.value],
    ['Financial', 'Paid to owners', formatPrice(f.paidToOwners), selectedPeriod.value],
    ['Financial', 'Pending payouts', formatPrice(f.pendingPayouts), selectedPeriod.value],
    ['Bookings', 'Completed trips', String(b.completed), selectedPeriod.value],
    ['Bookings', 'Scheduled', String(b.scheduled), selectedPeriod.value],
    ['Bookings', 'Pending', String(b.pending), selectedPeriod.value],
    ['Listings', 'Active vehicles', '42', selectedPeriod.value],
    ['Payouts', 'Pending requests', String(f.pendingPayoutsCount), selectedPeriod.value],
  ])
}

const exportReport = (type: string) => {
  const ts = new Date().toISOString().slice(0, 10)
  const f = financial.value
  const b = bookingStats.value
  if (type === 'financial') {
    downloadCsv('financial-summary', ['Metric', 'Value', 'Note'], [
      ['Total Revenue', formatPrice(f.totalRevenue), `+${f.totalRevenueTrend}% from last month`],
      ['Paid to owners', formatPrice(f.paidToOwners), `+${f.paidToOwnersTrend}% from last month`],
      ['Pending payouts', formatPrice(f.pendingPayouts), `${f.pendingPayoutsCount} requests`],
      ['Overdue payouts', formatPrice(f.overduePayouts), `${f.overduePayoutsCount} overdue`],
    ])
  } else if (type === 'bookings') {
    downloadCsv('booking-statistics', ['Status', 'Count'], [
      ['Completed', String(b.completed)],
      ['Scheduled', String(b.scheduled)],
      ['Pending', String(b.pending)],
      ['Cancelled', String(b.cancelled)],
    ])
  } else {
    downloadCsv(`report-${type}`, ['Metric', 'Value'], [['Report', type], ['Generated', ts]])
  }
}

const viewReportDialog = ref(false)
const viewReportTemplate = ref<typeof reportTemplates[0] | null>(null)
function openViewReport(id: number) {
  const t = reportTemplates.find(tpl => tpl.id === id)
  if (t) {
    viewReportTemplate.value = t
    viewReportDialog.value = true
  }
}

function downloadReport(id: number) {
  const t = reportTemplates.find(tpl => tpl.id === id)
  if (!t) return
  const ts = new Date().toISOString().slice(0, 10)
  const f = financial.value
  const b = bookingStats.value
  if (id === 1) {
    downloadCsv(`monthly-revenue-${ts}`, ['Metric', 'Value', 'Note'], [
      ['Total Revenue', formatPrice(f.totalRevenue), `+${f.totalRevenueTrend}% from last month`],
      ['Paid to owners', formatPrice(f.paidToOwners), `+${f.paidToOwnersTrend}% from last month`],
      ['Pending payouts', formatPrice(f.pendingPayouts), `${f.pendingPayoutsCount} requests`],
      ['Overdue payouts', formatPrice(f.overduePayouts), `${f.overduePayoutsCount} overdue`],
    ])
  } else if (id === 2) {
    downloadCsv(`bookings-report-${ts}`, ['Status', 'Count'], [
      ['Completed', String(b.completed)],
      ['Scheduled', String(b.scheduled)],
      ['Pending', String(b.pending)],
      ['Cancelled', String(b.cancelled)],
    ])
  } else if (id === 3) {
    downloadCsv(`listings-report-${ts}`, ['Metric', 'Value'], [['Active vehicles', '42'], ['Period', selectedPeriod.value]])
  } else if (id === 4) {
    downloadCsv(`payout-report-${ts}`, ['Metric', 'Value'], [
      ['Pending payouts', formatPrice(f.pendingPayouts)],
      ['Pending requests', String(f.pendingPayoutsCount)],
      ['Overdue', formatPrice(f.overduePayouts)],
    ])
  } else if (id === 5) {
    downloadCsv(`user-growth-${ts}`, ['Metric', 'Value'], [['Report', 'User Growth'], ['Period', selectedPeriod.value]])
  } else {
    downloadCsv(`report-${id}-${ts}`, ['Report', 'Generated'], [t.name, ts])
  }
  toast.success(`"${t.name}" downloaded.`)
}
</script>

<style scoped>
.reports-page :deep(.section-card-header),
.reports-page :deep(.section-card-header--with-actions) {
  padding: 0.5rem 0.75rem;
}

.reports-page :deep(.section-card-icon) {
  width: 32px;
  height: 32px;
}

.reports-page :deep(.section-card-icon .v-icon) {
  font-size: var(--text-lg);
}

.reports-cards-row :deep(.v-col) {
  padding-top: 4px;
  padding-bottom: 4px;
}

.section-card-header--with-actions {
  display: flex;
  align-items: center;
  gap: 0.75rem;
}

.chart-height--compact {
  min-height: 180px;
  height: 180px;
}

.financial-stat-box {
  min-height: 0;
  padding: 6px 8px;
}

.reports-page :deep(.financial-row .v-col) {
  padding-top: 4px;
  padding-bottom: 4px;
  padding-left: 4px;
  padding-right: 4px;
}

.shift-stats-row :deep(.v-col) {
  padding-top: 2px;
  padding-bottom: 2px;
}

.client-reports-strip {
  padding: 0;
}

.client-reports-strip__inner {
  display: flex;
  align-items: center;
  gap: 0.75rem;
  padding: 0.5rem 0.75rem;
  flex-wrap: wrap;
}

.client-reports-strip__icon {
  flex-shrink: 0;
}

.client-reports-strip__text {
  flex: 1;
  min-width: 200px;
}

.client-reports-strip__btn {
  flex-shrink: 0;
}

.reports-icon-primary {
  background: rgba(30, 58, 95, 0.12) !important;
  color: var(--role-primary) !important;
}

.reports-icon-success {
  background: rgba(16, 185, 129, 0.12) !important;
  color: #059669 !important;
}

.stat-dot {
  width: 12px;
  height: 12px;
  border-radius: 50%;
}
.stat-dot--completed { background-color: #166534 !important; }
.stat-dot--scheduled { background-color: #ea580c !important; }
.stat-dot--pending { background-color: #ca8a04 !important; }
.stat-dot--cancelled { background-color: #dc2626 !important; }

.bg-success-lighten {
  background-color: rgba(16, 185, 129, 0.1);
}

.bg-primary-lighten {
  background-color: rgba(30, 58, 95, 0.1);
}

.bg-warning-lighten {
  background-color: rgba(245, 158, 11, 0.1);
}

.text-success-darken {
  color: #047857;
}

.text-primary-darken {
  color: var(--role-primary);
}

.text-warning-darken {
  color: #b45309;
}
</style>
