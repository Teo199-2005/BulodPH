<template>
  <DashboardTemplate :animate="true">
    <template #header>
      <div>
        <h1 class="page-title mb-1">Documents</h1>
        <p class="page-subtitle">Vehicle and driver docs, rental agreements, insurance and expiry tracking</p>
      </div>
    </template>

    <p class="text-body-2 text-medium-emphasis mb-4">Store and manage documents for your vehicles, rentals and compliance. Upload LTO, insurance, and hand-over checklists here.</p>

    <v-tabs v-model="docActiveTab" color="primary" class="mb-4">
      <v-tab value="policies">Rental & Policies</v-tab>
      <v-tab value="compliance">LTO & Insurance</v-tab>
      <v-tab value="forms">Forms & Checklists</v-tab>
      <v-tab value="expiry">Expiry Notifications</v-tab>
    </v-tabs>

    <v-window v-model="docActiveTab">
      <!-- Policies & Procedures -->
      <v-window-item value="policies">
        <v-card elevation="0" rounded="lg" class="modern-card mb-4">
          <div class="section-card-header d-flex align-center justify-space-between flex-wrap gap-2">
            <div class="d-flex align-center">
              <div class="section-card-icon">
                <v-icon icon="mdi-file-document-multiple-outline" size="20" />
              </div>
              <span class="section-card-title">Rental & Policies</span>
            </div>
            <v-btn color="primary" size="small" prepend-icon="mdi-plus" rounded="lg" @click="showAddPolicyDialog = true">Add</v-btn>
          </div>
          <v-divider class="detail-divider" />
          <v-card-text class="pa-4">
            <v-list v-if="policiesAndProcedures.length" class="pa-0">
              <v-list-item v-for="p in policiesAndProcedures" :key="p.id" class="doc-list-item" :subtitle="p.updatedAt">
                <template #prepend>
                  <v-icon icon="mdi-file-document-outline" color="primary" class="mr-3" />
                </template>
                <v-list-item-title>{{ p.name }}</v-list-item-title>
                <template #append>
                  <v-btn icon="mdi-download" variant="text" size="small" aria-label="Download policy" @click="downloadPolicy(p)" />
                  <v-btn icon="mdi-delete-outline" variant="text" size="small" color="error" aria-label="Delete policy" @click="removePolicy(p.id)" />
                </template>
              </v-list-item>
            </v-list>
            <p v-else class="text-body-2 text-medium-emphasis mb-0">No rental policies on file. Add rental terms and vehicle policies here.</p>
          </v-card-text>
        </v-card>
        <HpaModal
          v-model="showAddPolicyDialog"
          title="Add Policy or Document"
          icon="mdi-file-document-plus-outline"
          max-width="500"
          :persistent="true"
          confirm-text="Add"
          cancel-text="Cancel"
          @confirm="addPolicy"
        >
          <v-text-field v-model="newPolicy.name" label="Name" placeholder="e.g. Rental policy, Hand-over checklist" />
          <v-file-input v-model="newPolicy.file" label="Upload document" prepend-icon="" prepend-inner-icon="mdi-paperclip" show-size accept=".pdf,.doc,.docx" />
        </HpaModal>
      </v-window-item>

      <!-- Compliance & Certificates -->
      <v-window-item value="compliance">
        <v-card elevation="0" rounded="lg" class="modern-card mb-4">
          <div class="section-card-header d-flex align-center justify-space-between flex-wrap gap-2">
            <div class="d-flex align-center">
              <div class="section-card-icon">
                <v-icon icon="mdi-shield-check-outline" size="20" />
              </div>
              <span class="section-card-title">LTO & Insurance</span>
            </div>
            <v-btn color="primary" size="small" prepend-icon="mdi-plus" rounded="lg" @click="showAddComplianceDialog = true">Add</v-btn>
          </div>
          <v-divider class="detail-divider" />
          <v-card-text class="pa-4">
            <v-list v-if="complianceAndCertificates.length" class="pa-0">
              <v-list-item v-for="c in complianceAndCertificates" :key="c.id" class="doc-list-item" :subtitle="c.updatedAt">
                <template #prepend>
                  <v-icon icon="mdi-certificate-outline" color="primary" class="mr-3" />
                </template>
                <v-list-item-title>{{ c.name }}</v-list-item-title>
                <template #append>
                  <v-btn icon="mdi-download" variant="text" size="small" aria-label="Download compliance" @click="downloadCompliance(c)" />
                  <v-btn icon="mdi-delete-outline" variant="text" size="small" color="error" aria-label="Delete compliance" @click="removeCompliance(c.id)" />
                </template>
              </v-list-item>
            </v-list>
            <p v-else class="text-body-2 text-medium-emphasis mb-0">No LTO or insurance documents on file. Add vehicle registration and insurance certificates here.</p>
          </v-card-text>
        </v-card>
        <HpaModal
          v-model="showAddComplianceDialog"
          title="Add LTO or Insurance Document"
          icon="mdi-shield-plus-outline"
          max-width="500"
          :persistent="true"
          confirm-text="Add"
          cancel-text="Cancel"
          @confirm="addCompliance"
        >
          <v-text-field v-model="newCompliance.name" label="Name" placeholder="e.g. LTO registration, Insurance certificate" />
          <v-file-input v-model="newCompliance.file" label="Upload document" prepend-icon="" prepend-inner-icon="mdi-paperclip" show-size accept=".pdf,.doc,.docx,image/*" />
        </HpaModal>
      </v-window-item>

      <!-- Custom Form Creation -->
      <v-window-item value="forms">
        <v-row>
          <v-col cols="12" md="8">
            <v-card elevation="0" rounded="lg" class="modern-card mb-4">
              <div class="section-card-header d-flex align-center justify-space-between flex-wrap gap-2">
                <div class="d-flex align-center">
                  <div class="section-card-icon">
                    <v-icon icon="mdi-form-select" size="20" />
                  </div>
                  <span class="section-card-title">Forms & Checklists</span>
                </div>
                <v-btn color="primary" size="small" prepend-icon="mdi-plus" rounded="lg" @click="openFormBuilder">
                  Create Form
                </v-btn>
              </div>
              <v-divider class="detail-divider" />
              <v-card-text class="pa-4">
                <v-list v-if="customForms.length" class="pa-0">
                  <v-list-item
                    v-for="form in customForms"
                    :key="form.id"
                    class="doc-list-item"
                    :subtitle="`${form.fields.length} field(s)`"
                  >
                    <template #prepend>
                      <v-icon icon="mdi-file-document-edit-outline" color="primary" class="mr-3" />
                    </template>
                    <v-list-item-title>{{ form.name }}</v-list-item-title>
                    <template #append>
                      <v-btn icon="mdi-pencil" variant="text" size="small" aria-label="Edit form" @click="editForm(form)" />
                      <v-btn icon="mdi-delete-outline" variant="text" size="small" color="error" aria-label="Delete form" @click="removeForm(form.id)" />
                    </template>
                  </v-list-item>
                </v-list>
                <p v-else class="text-body-2 text-medium-emphasis mb-0">No custom forms yet. Create forms to collect consistent data from staff or clients.</p>
              </v-card-text>
            </v-card>
          </v-col>
          <v-col cols="12" md="4">
            <v-card elevation="0" rounded="lg" class="modern-card">
              <div class="section-card-header">
                <div class="section-card-icon">
                  <v-icon icon="mdi-information-outline" size="20" />
                </div>
                <span class="section-card-title">About Forms & Checklists</span>
              </div>
              <v-divider class="detail-divider" />
              <v-card-text class="pa-4 text-body-2 text-medium-emphasis">
                Create forms and checklists for hand-over, damage reports, or rental agreements. Add custom fields (text, number, date, checkbox, dropdown) and use them for each trip or vehicle.
              </v-card-text>
            </v-card>
          </v-col>
        </v-row>

        <!-- Form builder dialog -->
        <HpaModal
          v-model="showFormBuilderDialog"
          :title="editingFormId ? 'Edit Form' : 'Create Form'"
          icon="mdi-form-select"
          max-width="640"
          :persistent="true"
          confirm-text="Save form"
          cancel-text="Cancel"
          @confirm="saveForm"
          @cancel="closeFormBuilder"
        >
          <v-text-field v-model="formBuilder.name" label="Form name" placeholder="e.g. Hand-over checklist, Damage report" class="mb-4" />
          <div class="text-subtitle-2 mb-2">Fields</div>
          <v-list class="pa-0 mb-3">
            <v-list-item v-for="(field, idx) in formBuilder.fields" :key="field.id" class="px-0">
              <template #prepend>
                <v-icon icon="mdi-drag" size="20" class="mr-2 text-medium-emphasis" aria-hidden="true" />
              </template>
              <v-list-item-title>
                <v-row dense align="center">
                  <v-col cols="5">
                    <v-text-field v-model="field.label" density="compact" hide-details placeholder="Label" />
                  </v-col>
                  <v-col cols="4">
                    <v-select v-model="field.type" :items="fieldTypes" density="compact" hide-details />
                  </v-col>
                  <v-col cols="2">
                    <v-checkbox v-if="field.type === 'text' || field.type === 'number'" v-model="field.required" label="Required" density="compact" hide-details />
                  </v-col>
                  <v-col cols="1">
                    <v-btn icon="mdi-delete-outline" variant="text" size="small" color="error" aria-label="Remove field" @click="removeFormField(idx)" />
                  </v-col>
                </v-row>
              </v-list-item-title>
            </v-list-item>
          </v-list>
          <v-btn variant="outlined" prepend-icon="mdi-plus" size="small" @click="addFormField">Add field</v-btn>
        </HpaModal>
      </v-window-item>

      <!-- Expiry date notifications -->
      <v-window-item value="expiry">
        <v-row>
          <v-col cols="12" lg="8">
            <v-card elevation="0" rounded="lg" class="modern-card mb-4">
              <div class="section-card-header d-flex align-center justify-space-between flex-wrap gap-2">
                <div class="d-flex align-center">
                  <div class="section-card-icon">
                    <v-icon icon="mdi-bell-alert-outline" size="20" />
                  </div>
                  <span class="section-card-title">Expiry notifications</span>
                </div>
                <v-btn color="primary" size="small" prepend-icon="mdi-plus" rounded="lg" @click="showAddDocumentDialog = true">
                  Add document with expiry
                </v-btn>
              </div>
              <v-divider class="detail-divider" />
              <v-card-text class="pa-4">
                <div class="d-flex align-center justify-space-between mb-4">
                  <span class="text-body-2">Notify me before documents expire</span>
                  <v-switch v-model="expiryNotificationsEnabled" color="primary" hide-details />
                </div>
                <v-text-field
                  v-model="expiryNotifyDays"
                  type="number"
                  min="1"
                  max="90"
                  label="Days before expiry to notify"
                  density="compact"
                  class="mb-4"
                  style="max-width: 200px;"
                  :disabled="!expiryNotificationsEnabled"
                />
                <div v-if="expiryNotificationsEnabled" class="text-caption text-medium-emphasis mb-3">
                  You will be notified {{ expiryNotifyDays }} day(s) before each document expires.
                </div>

                <div class="text-subtitle-2 mb-2">Documents with expiry dates</div>
                <v-list v-if="documentsWithExpiry.length" class="pa-0">
                  <v-list-item
                    v-for="doc in documentsWithExpiryDisplay"
                    :key="doc.id"
                    class="doc-list-item"
                    :subtitle="`Expires: ${doc.expiryDateFormatted}`"
                  >
                    <template #prepend>
                      <v-icon :icon="doc.expiringSoon ? 'mdi-alert' : 'mdi-file-document-outline'" :color="doc.expiringSoon ? 'warning' : 'primary'" class="mr-3" />
                    </template>
                    <v-list-item-title>{{ doc.name }}</v-list-item-title>
                    <template #append>
                      <v-chip v-if="doc.expiringSoon" size="small" color="warning" variant="tonal" prepend-icon="mdi-clock-alert-outline" class="mr-2">Expiring soon</v-chip>
                      <v-btn icon="mdi-bell-off" v-if="doc.notify" variant="text" size="small" aria-label="Disable expiry notification" @click="toggleDocNotify(doc)" />
                      <v-btn icon="mdi-bell" v-else variant="text" size="small" aria-label="Enable expiry notification" @click="toggleDocNotify(doc)" />
                      <v-btn icon="mdi-delete-outline" variant="text" size="small" color="error" aria-label="Delete document" @click="removeDocumentWithExpiry(doc.id)" />
                    </template>
                  </v-list-item>
                </v-list>
                <p v-else class="text-body-2 text-medium-emphasis mb-0">No documents with expiry dates. Add documents to get reminded before they expire.</p>
              </v-card-text>
            </v-card>
          </v-col>
          <v-col cols="12" lg="4">
            <v-card elevation="0" rounded="lg" class="modern-card">
              <div class="section-card-header">
                <div class="section-card-icon">
                  <v-icon icon="mdi-calendar-clock" size="20" />
                </div>
                <span class="section-card-title">Expiring soon</span>
              </div>
              <v-divider class="detail-divider" />
              <v-card-text class="pa-4">
                <v-list v-if="expiringSoonList.length" class="pa-0">
                  <v-list-item v-for="doc in expiringSoonList" :key="doc.id" class="px-0" :subtitle="doc.expiryDate">
                    <v-list-item-title class="text-body-2">{{ doc.name }}</v-list-item-title>
                  </v-list-item>
                </v-list>
                <p v-else class="text-body-2 text-medium-emphasis mb-0">No documents expiring in the next {{ expiryNotifyDays }} days.</p>
              </v-card-text>
            </v-card>
          </v-col>
        </v-row>

        <HpaModal
          v-model="showAddDocumentDialog"
          title="Add document with expiry"
          icon="mdi-file-document-plus"
          max-width="500"
          :persistent="true"
          confirm-text="Add"
          cancel-text="Cancel"
          @confirm="addDocumentWithExpiry"
        >
          <v-text-field v-model="newExpiryDoc.name" label="Document name" placeholder="e.g. LTO registration, Insurance" />
          <v-text-field v-model="newExpiryDoc.expiryDate" label="Expiry date" type="date" />
          <v-checkbox v-model="newExpiryDoc.notify" label="Notify me before expiry" hide-details />
        </HpaModal>
      </v-window-item>
    </v-window>
  </DashboardTemplate>
</template>

<script setup lang="ts">
import { ref, computed } from 'vue'
import DashboardTemplate from '@/components/DashboardTemplate.vue'
import HpaModal from '@/components/base/HpaModal.vue'
import { downloadDocAsText } from '@/utils/downloadDoc'

const docActiveTab = ref('policies')

// Policies & Procedures
const policiesAndProcedures = ref<{ id: number; name: string; updatedAt: string }[]>([
  { id: 1, name: 'Rental terms and conditions', updatedAt: '15 Jan 2026' },
  { id: 2, name: 'Vehicle hand-over checklist', updatedAt: '10 Jan 2026' },
])
const showAddPolicyDialog = ref(false)
const newPolicy = ref<{ name: string; file: File[] | null }>({ name: '', file: null })
function addPolicy() {
  if (!newPolicy.value.name.trim()) return
  policiesAndProcedures.value.push({
    id: Date.now(),
    name: newPolicy.value.name,
    updatedAt: new Date().toLocaleDateString('en-AU', { day: 'numeric', month: 'short', year: 'numeric' }),
  })
  newPolicy.value = { name: '', file: null }
  showAddPolicyDialog.value = false
}
function removePolicy(id: number) {
  policiesAndProcedures.value = policiesAndProcedures.value.filter(p => p.id !== id)
}
function downloadPolicy(p: { id: number; name: string; updatedAt: string }) {
  downloadDocAsText(
    `policy-${p.id}-${p.name.replace(/\W+/g, '-')}.txt`,
    `Rental & Policy\n${'='.repeat(40)}\n\nName: ${p.name}\nUpdated: ${p.updatedAt}\n\nGenerated ${new Date().toLocaleString()}`
  )
}

// Compliance & Certificates
const complianceAndCertificates = ref<{ id: number; name: string; updatedAt: string }[]>([
  { id: 1, name: 'NDIS registration certificate', updatedAt: '01 Jan 2026' },
  { id: 2, name: 'Insurance certificate', updatedAt: '05 Jan 2026' },
])
const showAddComplianceDialog = ref(false)
const newCompliance = ref<{ name: string; file: File[] | null }>({ name: '', file: null })
function addCompliance() {
  if (!newCompliance.value.name.trim()) return
  complianceAndCertificates.value.push({
    id: Date.now(),
    name: newCompliance.value.name,
    updatedAt: new Date().toLocaleDateString('en-AU', { day: 'numeric', month: 'short', year: 'numeric' }),
  })
  newCompliance.value = { name: '', file: null }
  showAddComplianceDialog.value = false
}
function removeCompliance(id: number) {
  complianceAndCertificates.value = complianceAndCertificates.value.filter(c => c.id !== id)
}
function downloadCompliance(c: { id: number; name: string; updatedAt: string }) {
  downloadDocAsText(
    `compliance-${c.id}-${c.name.replace(/\W+/g, '-')}.txt`,
    `LTO & Insurance\n${'='.repeat(40)}\n\nName: ${c.name}\nUpdated: ${c.updatedAt}\n\nGenerated ${new Date().toLocaleString()}`
  )
}

// Custom forms
interface FormField { id: number; label: string; type: string; required?: boolean }
interface CustomForm { id: number; name: string; fields: FormField[] }
const customForms = ref<CustomForm[]>([
  { id: 1, name: 'Client intake checklist', fields: [{ id: 1, label: 'Full name', type: 'text', required: true }, { id: 2, label: 'NDIS number', type: 'text' }, { id: 3, label: 'Date of birth', type: 'date' }] },
])
const fieldTypes = ['text', 'number', 'date', 'checkbox', 'dropdown', 'textarea']
const showFormBuilderDialog = ref(false)
const editingFormId = ref<number | null>(null)
const formBuilder = ref<{ name: string; fields: (FormField & { id: number })[] }>({ name: '', fields: [] })
let nextFieldId = 100
function addFormField() {
  formBuilder.value.fields.push({ id: nextFieldId++, label: '', type: 'text', required: false })
}
function removeFormField(idx: number) {
  formBuilder.value.fields.splice(idx, 1)
}
function openFormBuilder() {
  editingFormId.value = null
  formBuilder.value = { name: '', fields: [] }
  addFormField()
  showFormBuilderDialog.value = true
}
function editForm(form: CustomForm) {
  editingFormId.value = form.id
  formBuilder.value = { name: form.name, fields: form.fields.map(f => ({ ...f, id: f.id })) }
  if (!formBuilder.value.fields.length) addFormField()
  showFormBuilderDialog.value = true
}
function closeFormBuilder() {
  showFormBuilderDialog.value = false
  editingFormId.value = null
}
function saveForm() {
  if (!formBuilder.value.name.trim()) return
  const fields = formBuilder.value.fields.filter(f => f.label.trim()).map(({ id, label, type, required }) => ({ id, label, type, required: !!required }))
  if (!fields.length) return
  if (editingFormId.value) {
    const idx = customForms.value.findIndex(f => f.id === editingFormId.value)
    if (idx !== -1) customForms.value[idx] = { id: customForms.value[idx].id, name: formBuilder.value.name, fields }
  } else {
    customForms.value.push({ id: Date.now(), name: formBuilder.value.name, fields })
  }
  closeFormBuilder()
}
function removeForm(id: number) {
  customForms.value = customForms.value.filter(f => f.id !== id)
}

// Documents with expiry
const expiryNotificationsEnabled = ref(true)
const expiryNotifyDays = ref(7)
interface DocWithExpiry { id: number; name: string; expiryDate: string; notify: boolean; expiringSoon?: boolean }
const documentsWithExpiry = ref<DocWithExpiry[]>([
  { id: 1, name: 'Organisation WWCC', expiryDate: '2026-02-15', notify: true },
  { id: 2, name: 'Insurance certificate', expiryDate: '2026-06-01', notify: true },
])
const showAddDocumentDialog = ref(false)
const newExpiryDoc = ref({ name: '', expiryDate: '', notify: true })
function addDocumentWithExpiry() {
  if (!newExpiryDoc.value.name.trim() || !newExpiryDoc.value.expiryDate) return
  const rawDate = newExpiryDoc.value.expiryDate
  const expiringSoon = isExpiringSoon(rawDate, expiryNotifyDays.value)
  documentsWithExpiry.value.push({
    id: Date.now(),
    name: newExpiryDoc.value.name,
    expiryDate: rawDate,
    notify: newExpiryDoc.value.notify,
    expiringSoon,
  })
  newExpiryDoc.value = { name: '', expiryDate: '', notify: true }
  showAddDocumentDialog.value = false
}
function isExpiringSoon(dateStr: string, days: number): boolean {
  const d = new Date(dateStr)
  const now = new Date()
  const diff = (d.getTime() - now.getTime()) / (1000 * 60 * 60 * 24)
  return diff >= 0 && diff <= days
}
function formatDate(s: string): string {
  return new Date(s).toLocaleDateString('en-AU', { day: 'numeric', month: 'short', year: 'numeric' })
}
const documentsWithExpiryDisplay = computed(() =>
  documentsWithExpiry.value.map(d => ({
    ...d,
    expiringSoon: isExpiringSoon(d.expiryDate, expiryNotifyDays.value),
    expiryDateFormatted: formatDate(d.expiryDate),
  }))
)
const expiringSoonList = computed(() => {
  return documentsWithExpiry.value
    .filter(d => isExpiringSoon(d.expiryDate, expiryNotifyDays.value))
    .map(d => ({ name: d.name, id: d.id, expiryDate: formatDate(d.expiryDate) }))
    .slice(0, 5)
})
function toggleDocNotify(doc: DocWithExpiry) {
  doc.notify = !doc.notify
}
function removeDocumentWithExpiry(id: number) {
  documentsWithExpiry.value = documentsWithExpiry.value.filter(d => d.id !== id)
}
</script>

<style scoped>
.section-card-header { padding: 1rem 1.25rem; }
.section-card-icon { margin-right: 0.75rem; display: flex; align-items: center; }
.detail-divider { border-color: rgba(30, 58, 95, 0.08); }
.doc-list-item { border-bottom: 1px solid rgba(30, 58, 95, 0.08); }
.doc-list-item:last-child { border-bottom: none; }
</style>
