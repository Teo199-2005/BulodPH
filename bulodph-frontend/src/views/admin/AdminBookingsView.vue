<template>
  <DashboardTemplate :animate="true">
    <template #header>
      <div class="total-bookings-header">
        <div>
          <h1 class="page-title">Bookings</h1>
        </div>
        <div class="header-actions">
          <span class="header-date">{{ formattedDate }}</span>
          <v-tooltip location="bottom">
            <template #activator="{ props: tooltipProps }">
              <v-btn v-bind="tooltipProps" icon variant="text" size="small" :to="{ name: 'profile' }" aria-label="Go to profile">
                <v-icon>mdi-account-circle</v-icon>
              </v-btn>
            </template>
            Go to profile
          </v-tooltip>
        </div>
      </div>
    </template>

    <v-tabs v-model="adminBookingsTab" color="primary" class="mb-4">
      <v-tab value="records">
        <v-icon start size="18">mdi-format-list-bulleted</v-icon>
        Rental Records
      </v-tab>
      <v-tab value="overview">
        <v-icon start size="18">mdi-chart-timeline-variant</v-icon>
        Overview
      </v-tab>
    </v-tabs>

    <v-window v-model="adminBookingsTab" class="admin-bookings-window">
      <v-window-item value="records">
        <section class="rental-records-tab mb-6">
          <div class="section-head">
            <div>
              <h2 class="section-title d-flex align-center gap-2">
                <v-icon icon="mdi-format-list-bulleted" size="24" />
                Rental Records
              </h2>
              <p class="section-subtitle">Approve, reject, or archive bookings</p>
            </div>
            <div class="section-actions d-flex align-center gap-2 flex-wrap">
              <v-btn
                variant="outlined"
                size="small"
                rounded="lg"
                :prepend-icon="showFilters ? 'mdi-chevron-up' : 'mdi-filter'"
                :color="showFilters ? 'primary' : undefined"
                class="filters-toggle-btn"
                aria-label="Toggle filters"
                @click="showFilters = !showFilters"
              >
                {{ showFilters ? 'Hide filters' : 'Filters' }}
              </v-btn>
              <v-btn
                variant="outlined"
                size="small"
                rounded="lg"
                prepend-icon="mdi-archive"
                :color="showArchived ? 'primary' : undefined"
                aria-label="Toggle archived"
                @click="showArchived = !showArchived"
              >
                {{ showArchived ? 'Hide archived' : 'Archived' }}
              </v-btn>
              <v-btn
                variant="outlined"
                size="small"
                rounded="lg"
                prepend-icon="mdi-file-pdf-box"
                aria-label="Export PDF"
                @click="exportPdf"
              >
                Export PDF
              </v-btn>
            </div>
          </div>

      <div class="filters-bar-wrap">
        <v-expand-transition>
          <div v-show="showFilters" class="filters-bar">
        <v-btn
          variant="outlined"
          size="small"
          rounded="lg"
          prepend-icon="mdi-filter-off"
          class="reset-filters-btn"
          aria-label="Reset filters"
          @click="resetFilters"
        >
          Reset
        </v-btn>
        <v-text-field
          v-model="filters.search"
          placeholder="Search car, plate or customer..."
          prepend-inner-icon="mdi-magnify"
          variant="outlined"
          density="compact"
          hide-details
          clearable
          rounded="lg"
          class="filter-search"
        />
        <v-select
          v-model="filters.status"
          :items="statusOptions"
          label="Status"
          variant="outlined"
          density="compact"
          hide-details
          rounded="lg"
          class="filter-select"
        />
        <v-select
          v-model="filters.business"
          :items="businessOptions"
          label="Business"
          variant="outlined"
          density="compact"
          hide-details
          rounded="lg"
          class="filter-select"
        />
        <v-text-field
          v-model="filters.dateFrom"
          placeholder="mm/dd/yyyy"
          variant="outlined"
          density="compact"
          hide-details
          rounded="lg"
          class="filter-date"
        />
        <v-text-field
          v-model="filters.dateTo"
          placeholder="mm/dd/yyyy"
          variant="outlined"
          density="compact"
          hide-details
          rounded="lg"
          class="filter-date"
        />
          </div>
        </v-expand-transition>
      </div>

      <v-alert
        v-if="clientIdFilter"
        type="info"
        variant="tonal"
        density="compact"
        rounded="lg"
        class="mb-4"
        closable
      >
        Showing bookings for this renter only.
        <v-btn variant="text" size="small" class="ml-2" @click="router.replace({ name: 'admin-bookings' })">
          Show all
        </v-btn>
      </v-alert>

      <HpaDataTable
        ref="tableRef"
        :title="`Rental Records (${filteredRecords.length})`"
        icon="mdi-format-list-bulleted"
        :headers="bookingHeaders"
        :items="filteredRecords"
        :searchable="false"
        :items-per-page="10"
        :exportable="true"
        :custom-export="exportExcel"
        selectable
      >
        <template #bulk-actions="{ selected: selectedRows }">
          <v-btn
            color="success"
            size="small"
            variant="tonal"
            rounded="lg"
            prepend-icon="mdi-check"
            :loading="bulkLoading"
            :disabled="!selectedRows.some((r: RentalBookingRecord) => r.status === 'Pending')"
            @click="bulkApprove(selectedRows)"
          >
            Approve
          </v-btn>
          <v-btn
            variant="outlined"
            color="error"
            size="small"
            rounded="lg"
            prepend-icon="mdi-close"
            :loading="bulkLoading"
            :disabled="!selectedRows.some((r: RentalBookingRecord) => r.status === 'Pending')"
            @click="bulkReject(selectedRows)"
          >
            Reject
          </v-btn>
          <v-btn
            variant="outlined"
            size="small"
            rounded="lg"
            prepend-icon="mdi-archive"
            :loading="bulkLoading"
            @click="bulkArchive(selectedRows)"
          >
            Archive
          </v-btn>
        </template>
        <template #item.transactionId="{ item }">
          <span class="text-body-2 font-mono">{{ item.transactionId }}</span>
        </template>
        <template #item.vehicle="{ item }">
          <div class="font-weight-medium">{{ item.vehicleName }}</div>
          <div class="text-caption text-medium-emphasis">{{ item.businessName }}</div>
        </template>
        <template #item.client="{ item }">
          <div class="font-weight-medium">{{ item.clientName }}</div>
          <div class="text-caption text-medium-emphasis">{{ item.clientEmail }}</div>
        </template>
        <template #item.rental_period="{ item }">
          <span class="text-body-2">{{ item.startDate }} to {{ item.endDate }}</span>
        </template>
        <template #item.amount="{ item }">
          <span class="font-weight-medium">{{ formatAmount(item.amount) }}</span>
        </template>
        <template #item.status="{ item }">
          <div class="d-flex flex-wrap align-center gap-1">
            <v-chip
              :color="getStatusColor(item.status)"
              :prepend-icon="getStatusIcon(item.status)"
              size="small"
              variant="tonal"
              class="table-status-chip"
            >
              {{ item.status }}
            </v-chip>
            <v-chip v-if="item.paidAt" color="success" size="small" variant="tonal" prepend-icon="mdi-credit-card-check" class="table-status-chip">
              Paid
            </v-chip>
          </div>
        </template>
        <template #item.actions="{ item }">
          <div class="d-flex align-center gap-2 table-action-buttons">
            <template v-if="item.status === 'Approved' && !item.paidAt">
              <v-tooltip location="top" text="Mark as paid">
                <template #activator="{ props: tooltipProps }">
                  <v-btn
                    v-bind="tooltipProps"
                    icon
                    variant="text"
                    size="small"
                    color="success"
                    class="table-action-btn"
                    :loading="actionLoadingId === item.id"
                    @click="markAsPaidOne(item)"
                  >
                    <v-icon size="20">mdi-cash-check</v-icon>
                  </v-btn>
                </template>
              </v-tooltip>
            </template>
            <template v-if="item.status === 'Pending'">
              <v-tooltip location="top" text="Approve">
                <template #activator="{ props: tooltipProps }">
                  <v-btn
                    v-bind="tooltipProps"
                    icon
                    variant="text"
                    size="small"
                    color="success"
                    class="table-action-btn"
                    :loading="actionLoadingId === item.id"
                    @click="approveOne(item)"
                  >
                    <v-icon size="20">mdi-check</v-icon>
                  </v-btn>
                </template>
              </v-tooltip>
              <v-tooltip location="top" text="Reject">
                <template #activator="{ props: tooltipProps }">
                  <v-btn
                    v-bind="tooltipProps"
                    icon
                    variant="text"
                    size="small"
                    color="error"
                    class="table-action-btn"
                    :loading="actionLoadingId === item.id"
                    @click="rejectOne(item)"
                  >
                    <v-icon size="20">mdi-close</v-icon>
                  </v-btn>
                </template>
              </v-tooltip>
            </template>
            <v-tooltip location="top" text="View">
              <template #activator="{ props: tooltipProps }">
                <v-btn
                  v-bind="tooltipProps"
                  icon
                  variant="text"
                  size="small"
                  color="primary"
                  class="table-action-btn"
                  :to="{ name: 'admin-booking-detail', params: { id: item.id } }"
                >
                  <v-icon size="20">mdi-eye</v-icon>
                </v-btn>
              </template>
            </v-tooltip>
            <v-tooltip location="top" text="Archive">
              <template #activator="{ props: tooltipProps }">
                <v-btn
                  v-bind="tooltipProps"
                  icon
                  variant="text"
                  size="small"
                  color="error"
                  class="table-action-btn"
                  @click="archiveRecord(item)"
                >
                  <v-icon size="20">mdi-archive</v-icon>
                </v-btn>
              </template>
            </v-tooltip>
          </div>
        </template>
      </HpaDataTable>
        </section>
      </v-window-item>

      <v-window-item value="overview">
        <section class="rental-analytics mb-6">
          <div class="section-head">
            <div>
              <h2 class="section-title d-flex align-center gap-2">
                <v-icon icon="mdi-chart-timeline-variant" size="24" />
                Rental Analytics
              </h2>
              <p class="section-subtitle">View and analyze car rental records</p>
            </div>
          </div>
          <p class="text-body-2 text-medium-emphasis mb-4">Use the <strong>Rental Records</strong> tab to approve or reject pending booking requests.</p>

          <v-row class="mb-6">
        <v-col cols="6" sm="6" md="3">
          <HpaDashboardWidget
            role="admin"
            :loading="false"
            title="Total"
            :value="stats.total"
            icon="mdi-calendar-multiple"
            trend="neutral"
            trend-value="—"
            trend-label="records"
          />
        </v-col>
        <v-col cols="6" sm="6" md="3">
          <HpaDashboardWidget
            role="admin"
            :loading="false"
            title="Active"
            :value="stats.active"
            icon="mdi-play-circle"
            trend="neutral"
            :trend-value="String(stats.active)"
            trend-label="active"
          />
        </v-col>
        <v-col cols="6" sm="6" md="3">
          <HpaDashboardWidget
            role="admin"
            :loading="false"
            title="Pending"
            :value="stats.pending"
            icon="mdi-clock-outline"
            trend="neutral"
            :trend-value="String(stats.pending)"
            trend-label="pending"
          />
        </v-col>
        <v-col cols="6" sm="6" md="3">
          <HpaDashboardWidget
            role="admin"
            :loading="false"
            title="Approved"
            :value="stats.approved"
            icon="mdi-check-circle-outline"
            trend="neutral"
            :trend-value="String(stats.approved)"
            trend-label="awaiting payment"
          />
        </v-col>
        <v-col cols="6" sm="6" md="3">
          <HpaDashboardWidget
            role="admin"
            :loading="false"
            title="Completed"
            :value="stats.completed"
            icon="mdi-check-circle"
            trend="neutral"
            :trend-value="String(stats.completed)"
            trend-label="completed"
          />
        </v-col>
        <v-col cols="6" sm="6" md="3">
          <HpaDashboardWidget
            role="admin"
            :loading="false"
            title="Cancelled"
            :value="stats.cancelled"
            icon="mdi-close-circle"
            trend="neutral"
            :trend-value="String(stats.cancelled)"
            trend-label="cancelled"
          />
        </v-col>
        <v-col cols="6" sm="6" md="3">
          <HpaDashboardWidget
            role="admin"
            :loading="false"
            title="Rejected"
            :value="stats.rejected"
            icon="mdi-cancel"
            trend="neutral"
            :trend-value="String(stats.rejected)"
            trend-label="rejected"
          />
        </v-col>
        <v-col cols="6" sm="6" md="3">
          <HpaDashboardWidget
            role="admin"
            :loading="false"
            title="Overdue"
            :value="stats.overdue"
            icon="mdi-alert-circle"
            trend="neutral"
            :trend-value="String(stats.overdue)"
            trend-label="overdue"
          />
        </v-col>
      </v-row>
        </section>
      </v-window-item>
    </v-window>
  </DashboardTemplate>
</template>

<script setup lang="ts">
import { ref, computed, onMounted, watch } from 'vue'
import { useRoute, useRouter } from 'vue-router'
import DashboardTemplate from '@/components/DashboardTemplate.vue'
import HpaDashboardWidget from '@/components/base/HpaDashboardWidget.vue'
import HpaDataTable from '@/components/base/HpaDataTable.vue'
import {
  getUniqueBusinesses,
  formatRentalAmount,
  type RentalBookingRecord,
  type RentalBookingStatus,
} from '@/constants/rentalBookingsSeed'
import { useRentalBookings } from '@/composables/useRentalBookings'
import { useToastStore } from '@/stores/toast'

const route = useRoute()
const router = useRouter()
const toast = useToastStore()
const { records, setArchived, setStatus, markAsPaid, fetchFromApi } = useRentalBookings()
const adminBookingsTab = ref<'overview' | 'records'>('records')
const showArchived = ref(false)

const clientIdFilter = computed(() => (route.query.clientId as string) || '')
const tableRef = ref<InstanceType<typeof HpaDataTable> | null>(null)
const bulkLoading = ref(false)
const actionLoadingId = ref<string | null>(null)

onMounted(() => {
  fetchFromApi()
  if (clientIdFilter.value) adminBookingsTab.value = 'records'
})
watch(clientIdFilter, (id) => {
  if (id) adminBookingsTab.value = 'records'
})

const bookingHeaders = [
  { title: 'Transaction', key: 'transactionId', sortable: true },
  { title: 'Vehicle', key: 'vehicle', sortable: false },
  { title: 'Client', key: 'client', sortable: false },
  { title: 'Rental Period', key: 'rental_period', sortable: false },
  { title: 'Amount', key: 'amount', sortable: true },
  { title: 'Status', key: 'status', sortable: true },
  { title: 'Actions', key: 'actions', sortable: false, width: '100px' },
]

const statusOptions = ['All Status', 'Pending', 'Approved', 'Active', 'Completed', 'Cancelled', 'Rejected', 'Overdue']
const businessOptions = computed(() => ['All Businesses', ...getUniqueBusinesses(records.value)])

const showFilters = ref(false)
const filters = ref({
  search: '',
  status: 'All Status',
  business: 'All Businesses',
  dateFrom: '',
  dateTo: '',
})

const formattedDate = computed(() => {
  const d = new Date()
  return d.toLocaleDateString('en-PH', { weekday: 'long', year: 'numeric', month: 'long', day: 'numeric' })
})

const visibleRecords = computed(() => {
  return showArchived.value
    ? records.value.filter(r => r.archived)
    : records.value.filter(r => !r.archived)
})

const stats = computed(() => {
  const list = visibleRecords.value
  return {
    total: list.length,
    active: list.filter(r => r.status === 'Active').length,
    pending: list.filter(r => r.status === 'Pending').length,
    approved: list.filter(r => r.status === 'Approved').length,
    completed: list.filter(r => r.status === 'Completed').length,
    cancelled: list.filter(r => r.status === 'Cancelled').length,
    rejected: list.filter(r => r.status === 'Rejected').length,
    overdue: list.filter(r => r.status === 'Overdue').length,
  }
})

const filteredRecords = computed(() => {
  let list = visibleRecords.value
  if (clientIdFilter.value) {
    list = list.filter(r => (r.clientUserId ?? '') === clientIdFilter.value)
  }
  const q = filters.value.search?.toLowerCase().trim()
  if (q) {
    list = list.filter(
      r =>
        r.vehicleName.toLowerCase().includes(q) ||
        r.businessName.toLowerCase().includes(q) ||
        r.clientName.toLowerCase().includes(q) ||
        r.clientEmail.toLowerCase().includes(q) ||
        r.transactionId.toLowerCase().includes(q)
    )
  }
  if (filters.value.status && filters.value.status !== 'All Status') {
    list = list.filter(r => r.status === filters.value.status)
  }
  if (filters.value.business && filters.value.business !== 'All Businesses') {
    list = list.filter(r => r.businessName === filters.value.business)
  }
  if (filters.value.dateFrom) {
    list = list.filter(r => r.startDate >= filters.value.dateFrom)
  }
  if (filters.value.dateTo) {
    list = list.filter(r => r.endDate <= filters.value.dateTo)
  }
  return list
})

function formatAmount(amount: number) {
  return formatRentalAmount(amount)
}

function getStatusColor(status: RentalBookingStatus): string {
  const map: Record<RentalBookingStatus, string> = {
    Active: 'success',
    Pending: 'warning',
    Approved: 'info',
    Completed: 'grey',
    Cancelled: 'error',
    Rejected: 'error',
    Overdue: 'error',
  }
  return map[status] ?? 'grey'
}

function getStatusIcon(status: RentalBookingStatus): string {
  const map: Record<RentalBookingStatus, string> = {
    Active: 'mdi-play-circle',
    Pending: 'mdi-clock-outline',
    Approved: 'mdi-check-circle-outline',
    Completed: 'mdi-check-circle',
    Cancelled: 'mdi-close-circle',
    Rejected: 'mdi-cancel',
    Overdue: 'mdi-alert-circle',
  }
  return map[status] ?? 'mdi-circle-outline'
}

async function bulkApprove(rows: RentalBookingRecord[]) {
  const pending = rows.filter((r: RentalBookingRecord) => r.status === 'Pending')
  if (!pending.length) return
  bulkLoading.value = true
  try {
    for (const r of pending) {
      await setStatus(r.id, 'Approved')
    }
    toast.success(`${pending.length} booking(s) approved.`)
    tableRef.value?.clearSelection()
    fetchFromApi()
  } catch {
    toast.error('Some approvals failed. Please try again.')
  } finally {
    bulkLoading.value = false
  }
}

async function bulkReject(rows: RentalBookingRecord[]) {
  const pending = rows.filter((r: RentalBookingRecord) => r.status === 'Pending')
  if (!pending.length) return
  bulkLoading.value = true
  try {
    for (const r of pending) {
      await setStatus(r.id, 'Rejected')
    }
    toast.success(`${pending.length} booking(s) rejected.`)
    tableRef.value?.clearSelection()
    fetchFromApi()
  } catch {
    toast.error('Some rejections failed. Please try again.')
  } finally {
    bulkLoading.value = false
  }
}

async function approveOne(item: RentalBookingRecord) {
  if (item.status !== 'Pending') return
  actionLoadingId.value = item.id
  try {
    await setStatus(item.id, 'Approved')
    toast.success('Booking approved.')
    fetchFromApi()
  } catch {
    toast.error('Approval failed. Please try again.')
  } finally {
    actionLoadingId.value = null
  }
}

async function rejectOne(item: RentalBookingRecord) {
  if (item.status !== 'Pending') return
  actionLoadingId.value = item.id
  try {
    await setStatus(item.id, 'Rejected')
    toast.success('Booking rejected.')
    fetchFromApi()
  } catch {
    toast.error('Rejection failed. Please try again.')
  } finally {
    actionLoadingId.value = null
  }
}

async function markAsPaidOne(item: RentalBookingRecord) {
  if (item.status !== 'Approved' || item.paidAt) return
  actionLoadingId.value = item.id
  try {
    await markAsPaid(item.id)
    toast.success('Booking marked as paid. The client will see it as confirmed.')
    fetchFromApi()
  } catch {
    toast.error('Could not mark as paid. Please try again.')
  } finally {
    actionLoadingId.value = null
  }
}

async function bulkArchive(rows: RentalBookingRecord[]) {
  if (!rows.length) return
  bulkLoading.value = true
  try {
    for (const r of rows) {
      await setArchived(r.id, true)
    }
    toast.success(`${rows.length} record(s) archived.`)
    tableRef.value?.clearSelection()
    fetchFromApi()
  } catch {
    toast.error('Some archives failed. Please try again.')
  } finally {
    bulkLoading.value = false
  }
}

function resetFilters() {
  filters.value = {
    search: '',
    status: 'All Status',
    business: 'All Businesses',
    dateFrom: '',
    dateTo: '',
  }
  toast.success('Filters reset.')
}

function archiveRecord(r: RentalBookingRecord) {
  setArchived(r.id, true)
  toast.success(`Record ${r.transactionId} archived.`)
}

function exportExcel() {
  const headers = ['Transaction', 'Vehicle', 'Business', 'Client', 'Email', 'Start', 'End', 'Amount', 'Status']
  const rows = filteredRecords.value.map(r =>
    [r.transactionId, r.vehicleName, r.businessName, r.clientName, r.clientEmail, r.startDate, r.endDate, r.amount, r.status]
  )
  const csv = [headers.join(','), ...rows.map(row => row.map(c => `"${String(c).replace(/"/g, '""')}"`).join(','))].join('\n')
  const blob = new Blob(['\ufeff' + csv], { type: 'text/csv;charset=utf-8;' })
  const link = document.createElement('a')
  link.href = URL.createObjectURL(blob)
  link.download = `rental-records-${new Date().toISOString().slice(0, 10)}.csv`
  link.click()
  URL.revokeObjectURL(link.href)
  toast.success('Export downloaded as CSV.')
}

function exportPdf() {
  window.print()
  toast.success('Use browser print to save as PDF.')
}

</script>

<style scoped>
.total-bookings-header {
  display: flex;
  align-items: flex-start;
  justify-content: space-between;
  flex-wrap: wrap;
  gap: 1rem;
}
.page-title {
  margin: 0 0 4px 0;
  font-size: 1.5rem;
  font-weight: 700;
}
.header-actions {
  display: flex;
  align-items: center;
  gap: 0.5rem;
}
.header-date {
  font-size: 0.875rem;
  color: var(--text-secondary, #64748b);
}
.rental-analytics {
  width: 100%;
}
.section-head {
  display: flex;
  flex-wrap: wrap;
  align-items: center;
  justify-content: space-between;
  gap: 1rem;
  margin-bottom: 1rem;
}
.section-title {
  margin: 0 0 4px 0;
  font-size: 1.125rem;
  font-weight: 600;
}
.section-subtitle {
  margin: 0;
  font-size: 0.875rem;
  color: var(--text-secondary, #64748b);
}
.section-actions {
  display: flex;
  flex-wrap: wrap;
  gap: 0.5rem;
}
.filters-bar-wrap {
  margin-bottom: 0.25rem;
}
.filters-bar {
  display: flex;
  flex-wrap: wrap;
  align-items: center;
  gap: 0.75rem;
  margin-top: 0.75rem;
  margin-bottom: 1rem;
  padding: 0.75rem 0;
}
.filter-search {
  max-width: 280px;
}
.filter-select {
  min-width: 140px;
}
.filter-date {
  max-width: 120px;
}

.table-status-chip {
  font-weight: 500;
}
.table-action-buttons .table-action-btn {
  min-width: 32px;
  width: 32px;
  height: 32px;
}
</style>
