<template>
  <DashboardTemplate title="Tax & Invoicing" subtitle="Download invoices and receipts." :animate="true">
    <!-- Stats row -->
    <div class="tax-stats mb-5">
      <v-card elevation="0" rounded="lg" class="tax-stat-card modern-card">
        <v-card-text class="pa-4">
          <div class="tax-stat-card__icon tax-stat-card__icon--invoices">
            <v-icon icon="mdi-receipt-text" size="26" />
          </div>
          <p class="tax-stat-card__value mb-0">{{ tableRows.length }}</p>
          <p class="tax-stat-card__label">Total invoices</p>
        </v-card-text>
      </v-card>
      <v-card elevation="0" rounded="lg" class="tax-stat-card modern-card">
        <v-card-text class="pa-4">
          <div class="tax-stat-card__icon tax-stat-card__icon--billed">
            <v-icon icon="mdi-currency-php" size="26" />
          </div>
          <p class="tax-stat-card__value mb-0">₱{{ totalAmount.toLocaleString() }}</p>
          <p class="tax-stat-card__label">Total billed</p>
        </v-card-text>
      </v-card>
      <v-card elevation="0" rounded="lg" class="tax-stat-card modern-card">
        <v-card-text class="pa-4">
          <div class="tax-stat-card__icon tax-stat-card__icon--vat">
            <v-icon icon="mdi-percent" size="26" />
          </div>
          <p class="tax-stat-card__value mb-0">₱{{ totalTax.toLocaleString() }}</p>
          <p class="tax-stat-card__label">VAT collected</p>
        </v-card-text>
      </v-card>
    </div>

    <div class="tax-content">
      <!-- Invoices table -->
      <v-card elevation="0" rounded="lg" class="tax-section modern-card">
        <div class="tax-section__accent" />
        <div class="tax-section__header">
          <div class="tax-section__icon">
            <v-icon icon="mdi-file-document-multiple" size="22" />
          </div>
          <span class="tax-section__title">Invoices</span>
        </div>
        <v-divider class="mx-4" />

        <template v-if="loading">
          <div class="tax-loading pa-4">
            <v-progress-circular indeterminate color="primary" size="32" class="me-3" />
            <span class="text-body-2 text-medium-emphasis">Loading invoices…</span>
          </div>
        </template>
        <template v-else-if="!tableRows.length">
          <div class="tax-empty pa-4">
            <HpaEmptyState
              title="No invoices yet"
              description="Invoices will appear here after you complete and pay for bookings."
              icon="mdi-receipt-text-outline"
              action-text="Browse vehicles"
              action-icon="mdi-car-search"
              @action="goToBrowse"
            />
          </div>
        </template>
        <template v-else>
          <v-data-table
            :headers="headers"
            :items="paginatedRows"
            :items-per-page="10"
            density="comfortable"
            class="tax-table elevation-0"
            hide-default-footer
          >
            <template #item.status="{ item }">
              <v-chip
                :color="item.status === 'paid' ? 'success' : 'warning'"
                :prepend-icon="item.status === 'paid' ? 'mdi-check-circle' : 'mdi-clock-outline'"
                size="small"
                variant="tonal"
                density="compact"
              >
                {{ item.status }}
              </v-chip>
            </template>
            <template #item.amount="{ item }">
              <span class="font-weight-medium">₱{{ item.amount.toLocaleString() }}</span>
            </template>
            <template #item.actions="{ item }">
              <v-btn
                size="small"
                variant="tonal"
                icon="mdi-download"
                aria-label="Download invoice"
                @click="downloadInvoice(item)"
              />
            </template>
          </v-data-table>
          <div v-if="tableRows.length > 10" class="pa-3 d-flex justify-center">
            <v-pagination
              v-model="tablePage"
              :length="tableTotalPages"
              :total-visible="5"
              density="comfortable"
              rounded="lg"
            />
          </div>
        </template>
      </v-card>

      <!-- Tax summary -->
      <v-card elevation="0" rounded="lg" class="tax-section tax-section--summary modern-card">
        <div class="tax-section__accent tax-section__accent--summary" />
        <div class="tax-section__header">
          <div class="tax-section__icon tax-section__icon--summary">
            <v-icon icon="mdi-chart-pie" size="22" />
          </div>
          <span class="tax-section__title">Tax summary</span>
        </div>
        <v-divider class="mx-4" />
        <v-card-text class="pa-4">
          <div class="tax-summary-row">
            <span class="text-body-2 text-medium-emphasis">Subtotal</span>
            <span class="text-body-2 font-weight-medium">₱{{ subtotal.toLocaleString() }}</span>
          </div>
          <div class="tax-summary-row">
            <span class="text-body-2 text-medium-emphasis">VAT (12%)</span>
            <span class="text-body-2 font-weight-medium">₱{{ totalTax.toLocaleString() }}</span>
          </div>
          <v-divider class="tax-summary-divider" />
          <div class="tax-summary-row tax-summary-row--total">
            <span class="text-body-1 font-weight-bold">Total</span>
            <span class="text-body-1 font-weight-bold">₱{{ totalAmount.toLocaleString() }}</span>
          </div>
          <v-btn
            color="primary"
            variant="outlined"
            rounded="lg"
            block
            class="mt-4"
            prepend-icon="mdi-download"
            disabled
          >
            Export tax report (coming soon)
          </v-btn>
        </v-card-text>
      </v-card>
    </div>
  </DashboardTemplate>
</template>

<script setup lang="ts">
import { computed, ref, onMounted } from 'vue'
import { useRouter } from 'vue-router'
import DashboardTemplate from '@/components/DashboardTemplate.vue'
import HpaEmptyState from '@/components/base/HpaEmptyState.vue'
import { useToastStore } from '@/stores/toast'
import * as invoicesApi from '@/services/invoices'
import type { InvoiceRecord } from '@/services/invoices'

const router = useRouter()
const toast = useToastStore()
const loading = ref(true)
const invoices = ref<InvoiceRecord[]>([])
const tablePage = ref(1)

interface TableRow {
  id: string
  date: string
  description: string
  amount: number
  tax: number
  status: string
  pdf_path?: string | null
}

const headers = [
  { title: 'Invoice #', key: 'id', width: '120px' },
  { title: 'Date', key: 'date', width: '120px' },
  { title: 'Description', key: 'description' },
  { title: 'Amount', key: 'amount', width: '120px' },
  { title: 'Status', key: 'status', width: '100px' },
  { title: '', key: 'actions', width: '56px', sortable: false },
]

const tableRows = computed<TableRow[]>(() =>
  invoices.value.map((r) => ({
    id: String(r.id).slice(0, 8),
    date: r.paid_at ? String(r.paid_at).slice(0, 10) : String(r.created_at ?? '').slice(0, 10),
    description: r.booking_reference ? `Booking ${r.booking_reference}` : 'Invoice',
    amount: Number(r.total) || 0,
    tax: Number(r.taxes) || 0,
    status: String(r.status ?? 'issued').toLowerCase(),
    pdf_path: r.pdf_path ?? null,
  }))
)

const totalAmount = computed(() => tableRows.value.reduce((s, i) => s + i.amount, 0))
const totalTax = computed(() => tableRows.value.reduce((s, i) => s + i.tax, 0))
const subtotal = computed(() => Math.max(0, totalAmount.value - totalTax.value))

const ITEMS_PER_PAGE = 10
const tableTotalPages = computed(() => Math.max(1, Math.ceil(tableRows.value.length / ITEMS_PER_PAGE)))
const paginatedRows = computed(() => {
  const start = (tablePage.value - 1) * ITEMS_PER_PAGE
  return tableRows.value.slice(start, start + ITEMS_PER_PAGE)
})

async function loadInvoices() {
  loading.value = true
  try {
    const result = await invoicesApi.getInvoices()
    invoices.value = Array.isArray(result) ? result : []
  } catch (e) {
    toast.error(e instanceof Error ? e.message : 'Failed to load invoices.')
    invoices.value = []
  } finally {
    loading.value = false
  }
}

function downloadInvoice(item: TableRow) {
  if (item.pdf_path && (item.pdf_path.startsWith('http://') || item.pdf_path.startsWith('https://'))) {
    window.open(item.pdf_path, '_blank')
    return
  }
  toast.info(`Invoice ${item.id}. PDF download coming soon.`)
}

function goToBrowse() {
  router.push({ name: 'client-browse' })
}

onMounted(() => loadInvoices())
</script>

<style scoped>
.tax-stats {
  display: grid;
  grid-template-columns: repeat(auto-fit, minmax(160px, 1fr));
  gap: 1rem;
}

.tax-stat-card {
  border: 1px solid rgba(var(--v-border-color), var(--v-border-opacity));
  transition: box-shadow 0.2s ease;
}

.tax-stat-card:hover {
  box-shadow: 0 4px 16px rgba(0, 0, 0, 0.06);
}

.tax-stat-card__icon {
  width: 48px;
  height: 48px;
  border-radius: 12px;
  display: inline-flex;
  align-items: center;
  justify-content: center;
  margin-bottom: 0.75rem;
}

.tax-stat-card__icon--invoices {
  background: rgba(var(--v-theme-primary), 0.12);
  color: rgb(var(--v-theme-primary));
}

.tax-stat-card__icon--billed {
  background: rgba(76, 175, 80, 0.15);
  color: rgb(76, 175, 80);
}

.tax-stat-card__icon--vat {
  background: rgba(255, 152, 0, 0.15);
  color: rgb(255, 152, 0);
}

.tax-stat-card__value {
  font-size: 1.5rem;
  font-weight: 700;
  color: rgb(var(--v-theme-on-surface));
  line-height: 1.2;
}

.tax-stat-card__label {
  font-size: 0.8125rem;
  color: rgba(var(--v-theme-on-surface), 0.7);
  margin: 0;
}

.tax-content {
  display: grid;
  grid-template-columns: 1fr;
  gap: 1.25rem;
}

@media (min-width: 960px) {
  .tax-content {
    grid-template-columns: 1fr 340px;
  }
}

.tax-section {
  position: relative;
  overflow: hidden;
  border: 1px solid rgba(var(--v-border-color), var(--v-border-opacity));
}

.tax-section__accent {
  position: absolute;
  top: 0;
  left: 0;
  width: 4px;
  height: 100%;
  background: rgb(var(--v-theme-primary));
  border-radius: 4px 0 0 4px;
}

.tax-section__accent--summary {
  background: linear-gradient(to bottom, rgb(76, 175, 80), rgba(76, 175, 80, 0.5));
}

.tax-section__header {
  display: flex;
  align-items: center;
  gap: 0.75rem;
  padding: 1rem 1rem 0.5rem;
}

.tax-section__icon {
  width: 40px;
  height: 40px;
  border-radius: 10px;
  background: rgba(var(--v-theme-primary), 0.1);
  color: rgb(var(--v-theme-primary));
  display: flex;
  align-items: center;
  justify-content: center;
}

.tax-section__icon--summary {
  background: rgba(76, 175, 80, 0.12);
  color: rgb(76, 175, 80);
}

.tax-section__title {
  font-size: 1rem;
  font-weight: 700;
  color: rgb(var(--v-theme-on-surface));
}

.tax-loading {
  display: flex;
  align-items: center;
  min-height: 120px;
}

.tax-empty {
  min-height: 200px;
}

.tax-table :deep(.v-data-table__thead) {
  background: rgba(0, 0, 0, 0.03);
}

.tax-table :deep(.v-data-table__td) {
  padding-block: 0.5rem;
}

.tax-summary-row {
  display: flex;
  justify-content: space-between;
  align-items: center;
  padding: 0.35rem 0;
}

.tax-summary-divider {
  margin: 0.5rem 0;
}

.tax-summary-row--total {
  padding-top: 0.5rem;
}
</style>
