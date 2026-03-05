<template>
  <DashboardTemplate :animate="true">
    <template #header>
      <div>
        <h1 class="page-title mb-1">Invoices & Finance</h1>
        <p class="page-subtitle">Manage invoices and finance records</p>
      </div>
      <v-btn color="primary" size="default" prepend-icon="mdi-plus" rounded="lg" @click="showAddInvoiceDialog = true">
        Add Invoice
      </v-btn>
    </template>

    <v-row class="mb-4">
      <v-col cols="6" sm="6" md="3">
        <HpaDashboardWidget
          :loading="false"
          title="Total Invoices"
          :value="invoices.length"
          icon="mdi-file-document-outline"
          color="primary"
          trend="neutral"
          trend-value="—"
          trend-label="this month"
        />
      </v-col>
      <v-col cols="6" sm="6" md="3">
        <HpaDashboardWidget
          :loading="false"
          title="Paid"
          :value="paidCount"
          icon="mdi-check-circle"
          color="success"
          trend="up"
          trend-value="paid"
          trend-label=""
        />
      </v-col>
      <v-col cols="6" sm="6" md="3">
        <HpaDashboardWidget
          :loading="false"
          title="Pending"
          :value="pendingCount"
          icon="mdi-clock-outline"
          color="warning"
          trend="neutral"
          trend-value="pending"
          trend-label=""
        />
      </v-col>
      <v-col cols="6" sm="6" md="3">
        <HpaDashboardWidget
          :loading="false"
          title="Overdue"
          :value="overdueCount"
          icon="mdi-alert-circle"
          color="error"
          trend="neutral"
          trend-value="overdue"
          trend-label=""
        />
      </v-col>
    </v-row>

    <v-card elevation="0" rounded="lg" class="modern-card">
      <div class="section-card-header d-flex align-center justify-space-between flex-wrap gap-2">
        <div class="d-flex align-center">
          <div class="section-card-icon">
            <v-icon icon="mdi-currency-php" size="20" />
          </div>
          <span class="section-card-title">Invoices & Finance</span>
        </div>
      </div>
      <v-divider class="detail-divider" />
      <v-card-text class="pa-4">
        <v-list v-if="invoices.length" class="pa-0">
          <v-list-item
            v-for="inv in invoices"
            :key="inv.id"
            class="doc-list-item"
            :subtitle="`Due: ${inv.dueDate} · ${inv.status}`"
          >
            <template #prepend>
              <v-icon icon="mdi-file-document-outline" color="primary" class="mr-3" />
            </template>
            <v-list-item-title>{{ inv.reference }}</v-list-item-title>
            <v-list-item-subtitle class="mt-1">{{ inv.description }}</v-list-item-subtitle>
            <template #append>
              <span class="text-body-2 font-weight-medium mr-2">{{ inv.amount }}</span>
              <v-chip size="small" :color="getStatusColor(inv.status)" :prepend-icon="getStatusIcon(inv.status)" variant="tonal">{{ inv.status }}</v-chip>
              <v-btn icon="mdi-download" variant="text" size="small" class="ml-1" aria-label="Download invoice" @click="downloadInvoice(inv)" />
              <v-btn icon="mdi-delete-outline" variant="text" size="small" color="error" aria-label="Delete invoice" @click="removeInvoice(inv.id)" />
            </template>
          </v-list-item>
        </v-list>
        <p v-else class="text-body-2 text-medium-emphasis mb-0">No invoices yet. Add invoices and track finance here.</p>
      </v-card-text>
    </v-card>

    <HpaModal
      v-model="showAddInvoiceDialog"
      title="Add Invoice"
      icon="mdi-file-document-plus"
      max-width="500"
      :persistent="true"
      confirm-text="Add"
      cancel-text="Cancel"
      @confirm="addInvoice"
    >
      <v-text-field v-model="newInvoice.reference" label="Reference" placeholder="e.g. INV-2026-001" />
      <v-text-field v-model="newInvoice.description" label="Description" />
      <v-text-field :model-value="newInvoice.amount" @update:model-value="(v) => newInvoice.amount = String(sanitizePrice(v))" label="Amount" type="number" prefix="₱" />
      <v-text-field v-model="newInvoice.dueDate" label="Due date" type="date" />
      <v-select v-model="newInvoice.status" :items="['Draft', 'Sent', 'Paid', 'Overdue']" label="Status" />
    </HpaModal>
  </DashboardTemplate>
</template>

<script setup lang="ts">
import { ref, computed } from 'vue'
import DashboardTemplate from '@/components/DashboardTemplate.vue'
import { downloadDocAsText } from '@/utils/downloadDoc'
import HpaModal from '@/components/base/HpaModal.vue'
import HpaDashboardWidget from '@/components/base/HpaDashboardWidget.vue'
import { formatPrice } from '@/utils/priceFormat'
import { sanitizePrice } from '@/utils/numericValidation'

interface Invoice { id: number; reference: string; description: string; amount: string; dueDate: string; status: string }
const invoices = ref<Invoice[]>([
  { id: 1, reference: 'INV-2026-001', description: 'January services', amount: '₱2,450.00', dueDate: '31 Jan 2026', status: 'Sent' },
  { id: 2, reference: 'INV-2026-002', description: 'NDIS claim', amount: '₱1,200.00', dueDate: '15 Feb 2026', status: 'Draft' },
  { id: 3, reference: 'INV-2025-012', description: 'December services', amount: '₱2,100.00', dueDate: '15 Jan 2026', status: 'Paid' },
])
const showAddInvoiceDialog = ref(false)
const newInvoice = ref<{ reference: string; description: string; amount: string; dueDate: string; status: string }>({
  reference: '',
  description: '',
  amount: '',
  dueDate: new Date().toISOString().slice(0, 10),
  status: 'Draft',
})
const paidCount = computed(() => invoices.value.filter(i => i.status === 'Paid').length)
const pendingCount = computed(() => invoices.value.filter(i => i.status === 'Sent' || i.status === 'Draft').length)
const overdueCount = computed(() => invoices.value.filter(i => i.status === 'Overdue').length)
function getStatusColor(s: string) {
  const map: Record<string, string> = { Paid: 'success', Sent: 'primary', Draft: 'grey', Overdue: 'error' }
  return map[s] || 'grey'
}
function getStatusIcon(s: string): string {
  const map: Record<string, string> = { Paid: 'mdi-check-circle', Sent: 'mdi-send-outline', Draft: 'mdi-file-document-outline', Overdue: 'mdi-alert-circle' }
  return map[s] || 'mdi-circle-outline'
}
function addInvoice() {
  if (!newInvoice.value.reference.trim()) return
  invoices.value.push({
    id: Date.now(),
    reference: newInvoice.value.reference,
    description: newInvoice.value.description,
    amount: formatPrice(sanitizePrice(newInvoice.value.amount), { showDecimals: true }),
    dueDate: newInvoice.value.dueDate,
    status: newInvoice.value.status,
  })
  newInvoice.value = { reference: '', description: '', amount: '', dueDate: new Date().toISOString().slice(0, 10), status: 'Draft' }
  showAddInvoiceDialog.value = false
}
function removeInvoice(id: number) {
  invoices.value = invoices.value.filter(i => i.id !== id)
}
function downloadInvoice(inv: Invoice) {
  downloadDocAsText(
    `invoice-${inv.reference.replace(/\W+/g, '-')}.txt`,
    `Invoice\n${'='.repeat(40)}\n\nReference: ${inv.reference}\nDescription: ${inv.description}\nAmount: ${inv.amount}\nDue date: ${inv.dueDate}\nStatus: ${inv.status}\n\nGenerated ${new Date().toLocaleString()}`
  )
}
</script>

<style scoped>
.section-card-header { padding: 1rem 1.25rem; }
.section-card-icon { margin-right: 0.75rem; display: flex; align-items: center; }
.detail-divider { border-color: rgba(30, 58, 95, 0.08); }
.doc-list-item { border-bottom: 1px solid rgba(30, 58, 95, 0.08); }
.doc-list-item:last-child { border-bottom: none; }
</style>
