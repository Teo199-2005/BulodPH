<template>
  <v-card elevation="0" class="hpa-data-table modern-card" rounded="lg">
    <!-- Toolbar – section card style -->
    <div class="hpa-data-table__toolbar">
      <div class="section-card-header">
        <div v-if="icon" class="section-card-icon">
          <v-icon :icon="icon" size="20" />
        </div>
        <span class="section-card-title">{{ title }}</span>
      </div>
      <div class="hpa-data-table__toolbar-actions">
        <v-text-field
          v-if="searchable"
          v-model="search"
          prepend-inner-icon="mdi-magnify"
          placeholder="Search..."
          single-line
          hide-details
          density="compact"
          variant="outlined"
          class="hpa-data-table__search"
          clearable
        />
        <slot name="actions" />
        <v-btn
          v-if="exportable"
          variant="outlined"
          size="small"
          rounded="lg"
          prepend-icon="mdi-download"
          color="primary"
          aria-label="Export"
          @click="customExport ? customExport() : exportData()"
        >
          Export
        </v-btn>
      </div>
    </div>

    <v-divider class="table-divider" />

    <!-- Table -->
    <v-data-table
      v-model="selected"
      :headers="headers"
      :items="items"
      :loading="loading"
      :search="search"
      :items-per-page="itemsPerPage"
      :show-select="selectable"
      item-value="id"
      class="hpa-data-table__table elevation-0"
      hover
    >
      <template v-for="(_, slot) in $slots" #[slot]="scope">
        <slot :name="slot" v-bind="scope" />
      </template>

      <template #loading>
        <v-skeleton-loader type="table-row@5" />
      </template>

      <template #no-data>
        <div class="pa-8">
          <HpaEmptyState
            :title="emptyTitle"
            :description="emptyDescription"
            :icon="emptyIcon"
            :image-url="emptyStateImage"
          />
        </div>
      </template>
    </v-data-table>

    <!-- Bulk Actions Bar -->
    <v-card-actions
      v-if="selectable && selected.length > 0"
      class="hpa-data-table__bulk-actions"
    >
      <span class="text-body-2 font-weight-medium">
        {{ selected.length }} item{{ selected.length > 1 ? 's' : '' }} selected
      </span>
      <v-spacer />
      <slot name="bulk-actions" :selected="selected" />
    </v-card-actions>
  </v-card>
</template>

<script setup lang="ts">
import { ref } from 'vue'
import HpaEmptyState from './HpaEmptyState.vue'

interface Props {
  title: string
  headers: any[]
  items: any[]
  icon?: string
  loading?: boolean
  searchable?: boolean
  exportable?: boolean
  /** Optional custom export function; if provided, called instead of default CSV export */
  customExport?: () => void
  selectable?: boolean
  itemsPerPage?: number
  emptyTitle?: string
  emptyDescription?: string
  emptyIcon?: string
  emptyStateImage?: string
}

const props = withDefaults(defineProps<Props>(), {
  loading: false,
  searchable: true,
  exportable: false,
  selectable: false,
  itemsPerPage: 10,
  emptyTitle: 'No data found',
  emptyDescription: 'There are no items to display',
  emptyIcon: 'mdi-database-off',
})

const search = ref('')
const selected = ref<any[]>([])

function clearSelection() {
  selected.value = []
}

defineExpose({ clearSelection })

const exportData = () => {
  const headers = props.headers.map(h => h.title).join(',')
  const rows = props.items.map(item =>
    props.headers.map(h => item[h.key] || '').join(',')
  ).join('\n')
  const csv = `${headers}\n${rows}`
  const blob = new Blob([csv], { type: 'text/csv' })
  const url = window.URL.createObjectURL(blob)
  const a = document.createElement('a')
  a.href = url
  a.download = `${props.title.toLowerCase().replace(/\s+/g, '-')}-${new Date().toISOString().split('T')[0]}.csv`
  a.click()
  window.URL.revokeObjectURL(url)
}
</script>

<style scoped>
.hpa-data-table {
  overflow: hidden;
  border: 1px solid var(--border-subtle, #e2e8f0);
  box-shadow: 0 1px 3px rgba(0, 0, 0, 0.05), 0 1px 2px rgba(255, 255, 255, 0.4) inset;
  transition: box-shadow 0.3s ease, border-color 0.25s ease;
  animation: fadeInUp 0.35s ease-out;
}
.hpa-data-table:hover {
  border-color: var(--metallic-mid, #cbd5e1);
  box-shadow: 0 4px 12px rgba(0, 0, 0, 0.06), 0 2px 4px rgba(255, 255, 255, 0.5) inset;
}

.hpa-data-table__toolbar {
  display: flex;
  flex-wrap: wrap;
  align-items: center;
  justify-content: space-between;
  gap: 1rem;
  padding: 1rem 1.25rem;
  background: linear-gradient(180deg, var(--surface-0, #fff) 0%, var(--surface-1, #f8fafc) 100%);
}

.hpa-data-table__toolbar .section-card-header {
  padding: 0;
}

.hpa-data-table__toolbar-actions {
  display: flex;
  align-items: center;
  gap: 0.75rem;
  flex-wrap: wrap;
}

.hpa-data-table__search {
  min-width: 220px;
  max-width: 320px;
  flex-shrink: 0;
}

.table-divider {
  border-color: var(--border-subtle, #e2e8f0) !important;
  opacity: 1;
}

.hpa-data-table__table {
  overflow-x: auto;
  -webkit-overflow-scrolling: touch;
}
.hpa-data-table__table :deep(.v-table) {
  border-radius: 0 0 8px 8px;
  min-width: 480px;
}

.hpa-data-table__table :deep(.v-data-table__th) {
  font-weight: 600 !important;
  font-size: 0.8125rem !important;
  text-transform: uppercase;
  letter-spacing: 0.04em;
  color: var(--text-secondary, #64748b) !important;
  background-color: var(--surface-1, #f1f5f9) !important;
  padding: var(--space-3, 12px) var(--space-4, 16px) !important;
  border-bottom: 1px solid var(--border-subtle, #e2e8f0) !important;
  border-right: 1px solid var(--border-subtle, #e2e8f0) !important;
  position: sticky;
  top: 0;
  z-index: 2;
  box-shadow: 0 1px 0 var(--border-subtle, #e2e8f0);
}
.hpa-data-table__table :deep(.v-data-table__th:last-child) {
  border-right: none !important;
}

.hpa-data-table__table :deep(.v-data-table__td) {
  padding: var(--space-3, 12px) var(--space-4, 16px) !important;
  font-size: 0.875rem;
  border-right: 1px solid var(--border-subtle, #e2e8f0) !important;
}
.hpa-data-table__table :deep(.v-data-table__td:last-child) {
  border-right: none !important;
}

.hpa-data-table__table :deep(.v-data-table__tbody .v-data-table__tr:nth-child(even)) {
  background-color: rgba(248, 250, 252, 0.5);
}

.hpa-data-table__table :deep(.v-data-table__tr) {
  transition: background-color 0.15s ease;
}

.hpa-data-table__table :deep(.v-data-table__tr:hover) {
  background-color: var(--hover-overlay, rgba(15, 23, 42, 0.04)) !important;
}

.hpa-data-table__table :deep(.v-data-table__tbody .v-data-table__tr) {
  border-bottom: 1px solid var(--border-subtle, #e2e8f0);
}

.hpa-data-table__table :deep(.v-data-table__tbody .v-data-table__tr:last-child) {
  border-bottom: none;
}

.hpa-data-table__bulk-actions {
  background: var(--surface-1, #f8fafc) !important;
  border-top: 1px solid var(--border-subtle, #e2e8f0);
  gap: 0.75rem;
}
</style>
