<template>
  <DashboardTemplate
    :animate="true"
    :back-to="{ name: 'staff' }"
    back-label="Back to Staff"
  >
    <template #header>
      <div>
        <h1 class="page-title mb-1">Staff member</h1>
        <p class="page-subtitle">{{ staffName }} – contact, role and documents</p>
      </div>
      <v-btn variant="outlined" color="primary" rounded="lg" class="mr-2" @click="goToEdit">
        <v-icon start>mdi-pencil</v-icon>
        Edit
      </v-btn>
    </template>

    <v-row>
      <v-col cols="12" lg="4">
        <v-card elevation="0" rounded="lg" class="modern-card mb-4">
          <v-card-text class="pa-4 text-center">
            <v-avatar size="96" class="mb-3">
              <v-img :src="avatarUrl" />
            </v-avatar>
            <h3 class="text-h6 font-weight-bold mb-1">{{ staffName }}</h3>
            <p class="text-body-2 text-medium-emphasis mb-2">{{ staffRole }}</p>
            <v-chip :color="statusColor" :prepend-icon="getStatusIcon(staffStatus)" size="small" variant="tonal" class="mb-3">{{ staffStatus }}</v-chip>
            <v-divider class="my-3" />
            <div class="text-left text-body-2">
              <div class="d-flex align-center mb-2">
                <v-icon icon="mdi-phone" size="18" class="mr-2 text-medium-emphasis" />
                {{ staffPhone }}
              </div>
              <div class="d-flex align-center mb-2">
                <v-icon icon="mdi-email" size="18" class="mr-2 text-medium-emphasis" />
                <span class="text-truncate">{{ staffEmail }}</span>
              </div>
              <div class="d-flex align-center">
                <v-icon icon="mdi-certificate" size="18" class="mr-2 text-medium-emphasis" />
                {{ staffCertifications }} certifications
              </div>
            </div>
          </v-card-text>
        </v-card>
      </v-col>
      <v-col cols="12" lg="8">
        <v-tabs v-model="employeeTab" color="primary" class="mb-4">
          <v-tab value="id-visa">ID documents</v-tab>
          <v-tab value="contract">Contract</v-tab>
          <v-tab value="certificates">Certificates</v-tab>
          <v-tab value="training">Training</v-tab>
          <v-tab value="performance">Notes</v-tab>
        </v-tabs>

        <v-window v-model="employeeTab">
          <!-- ID documents -->
          <v-window-item value="id-visa">
            <v-card elevation="0" rounded="lg" class="modern-card">
              <div class="section-card-header d-flex align-center justify-space-between flex-wrap gap-2">
                <div class="d-flex align-center">
                  <div class="section-card-icon">
                    <v-icon icon="mdi-card-account-details-outline" size="20" />
                  </div>
                  <span class="section-card-title">ID documents</span>
                </div>
                <v-btn color="primary" size="small" prepend-icon="mdi-plus" rounded="lg" @click="openAddDoc('id-visa')">Add</v-btn>
              </div>
              <v-divider class="detail-divider" />
              <v-card-text class="pa-4">
                <employee-file-list :items="itemsByCategory.idVisa" @remove="removeDoc" />
              </v-card-text>
            </v-card>
          </v-window-item>
          <!-- Contract -->
          <v-window-item value="contract">
            <v-card elevation="0" rounded="lg" class="modern-card">
              <div class="section-card-header d-flex align-center justify-space-between flex-wrap gap-2">
                <div class="d-flex align-center">
                  <div class="section-card-icon">
                    <v-icon icon="mdi-file-document-edit-outline" size="20" />
                  </div>
                  <span class="section-card-title">Contract</span>
                </div>
                <v-btn color="primary" size="small" prepend-icon="mdi-plus" rounded="lg" @click="openAddDoc('contract')">Add</v-btn>
              </div>
              <v-divider class="detail-divider" />
              <v-card-text class="pa-4">
                <employee-file-list :items="itemsByCategory.contract" @remove="removeDoc" />
              </v-card-text>
            </v-card>
          </v-window-item>
          <!-- Certificates -->
          <v-window-item value="certificates">
            <v-card elevation="0" rounded="lg" class="modern-card">
              <div class="section-card-header d-flex align-center justify-space-between flex-wrap gap-2">
                <div class="d-flex align-center">
                  <div class="section-card-icon">
                    <v-icon icon="mdi-certificate-outline" size="20" />
                  </div>
                  <span class="section-card-title">Certificates</span>
                </div>
                <v-btn color="primary" size="small" prepend-icon="mdi-plus" rounded="lg" @click="openAddDoc('certificates')">Add</v-btn>
              </div>
              <v-divider class="detail-divider" />
              <v-card-text class="pa-4">
                <employee-file-list :items="itemsByCategory.certificates" @remove="removeDoc" />
              </v-card-text>
            </v-card>
          </v-window-item>
          <!-- Training -->
          <v-window-item value="training">
            <v-card elevation="0" rounded="lg" class="modern-card">
              <div class="section-card-header d-flex align-center justify-space-between flex-wrap gap-2">
                <div class="d-flex align-center">
                  <div class="section-card-icon">
                    <v-icon icon="mdi-school-outline" size="20" />
                  </div>
                  <span class="section-card-title">Training</span>
                </div>
                <v-btn color="primary" size="small" prepend-icon="mdi-plus" rounded="lg" @click="openAddDoc('training')">Add</v-btn>
              </div>
              <v-divider class="detail-divider" />
              <v-card-text class="pa-4">
                <employee-file-list :items="itemsByCategory.training" @remove="removeDoc" />
              </v-card-text>
            </v-card>
          </v-window-item>
          <!-- Performance Notes -->
          <v-window-item value="performance">
            <v-card elevation="0" rounded="lg" class="modern-card">
              <div class="section-card-header d-flex align-center justify-space-between flex-wrap gap-2">
                <div class="d-flex align-center">
                  <div class="section-card-icon">
                    <v-icon icon="mdi-note-text-outline" size="20" />
                  </div>
                  <span class="section-card-title">Notes</span>
                </div>
                <v-btn color="primary" size="small" prepend-icon="mdi-plus" rounded="lg" @click="showAddNoteDialog = true">Add note</v-btn>
              </div>
              <v-divider class="detail-divider" />
              <v-card-text class="pa-4">
                <v-list v-if="performanceNotes.length" class="pa-0">
                  <v-list-item v-for="note in performanceNotes" :key="note.id" class="doc-list-item" :subtitle="`${note.date} · ${note.author}`">
                    <template #prepend>
                      <v-icon icon="mdi-note-text" color="primary" class="mr-3" />
                    </template>
                    <v-list-item-title>{{ note.title }}</v-list-item-title>
                    <v-list-item-subtitle class="mt-1">{{ note.content }}</v-list-item-subtitle>
                    <template #append>
                      <v-btn icon="mdi-delete-outline" variant="text" size="small" color="error" aria-label="Delete note" @click="removeNote(note.id)" />
                    </template>
                  </v-list-item>
                </v-list>
                <p v-else class="text-body-2 text-medium-emphasis mb-0">No performance notes yet.</p>
              </v-card-text>
            </v-card>
            <HpaModal
              v-model="showAddNoteDialog"
              title="Add Performance Note"
              icon="mdi-note-plus-outline"
              max-width="500"
              :persistent="true"
              confirm-text="Add"
              cancel-text="Cancel"
              @confirm="addPerformanceNote"
            >
              <v-text-field v-model="newNote.title" label="Title" />
              <v-textarea v-model="newNote.content" label="Note" rows="3" />
            </HpaModal>
          </v-window-item>
        </v-window>
      </v-col>
    </v-row>

    <HpaModal
      v-model="showAddDocDialog"
      :title="`Add to ${addDocCategoryLabel}`"
      icon="mdi-file-document-plus"
      max-width="500"
      :persistent="true"
      confirm-text="Add"
      cancel-text="Cancel"
      @confirm="addDoc"
    >
      <v-text-field v-model="newDoc.name" label="Document name" />
      <v-file-input v-model="newDoc.file" label="Upload file" prepend-icon="" prepend-inner-icon="mdi-paperclip" show-size accept=".pdf,.doc,.docx,image/*" />
    </HpaModal>
  </DashboardTemplate>
</template>

<script setup lang="ts">
import { ref, computed } from 'vue'
import { useRoute, useRouter } from 'vue-router'
import DashboardTemplate from '@/components/DashboardTemplate.vue'
import HpaModal from '@/components/base/HpaModal.vue'
import { getAvatarUrl } from '@/constants/images'
import EmployeeFileList from '@/components/EmployeeFileList.vue'

const route = useRoute()
const router = useRouter()
const staffId = computed(() => (route.params as { id: string }).id)

const staffMembers: Record<string, { name: string; role: string; status: string; phone: string; email: string; certifications: number }> = {
  '1': { name: 'John Smith', role: 'Support Worker', status: 'Active', phone: '0412 345 678', email: 'john.smith@hpaplus.com', certifications: 5 },
  '2': { name: 'Sarah Davis', role: 'Registered Nurse', status: 'Active', phone: '0423 456 789', email: 'sarah.davis@hpaplus.com', certifications: 8 },
  '3': { name: 'Michael Brown', role: 'Care Coordinator', status: 'Active', phone: '0434 567 890', email: 'michael.brown@hpaplus.com', certifications: 6 },
  '4': { name: 'Emily Wilson', role: 'Support Worker', status: 'On Leave', phone: '0445 678 901', email: 'emily.wilson@hpaplus.com', certifications: 4 },
  '5': { name: 'David Martinez', role: 'Team Leader', status: 'Active', phone: '0456 789 012', email: 'david.martinez@hpaplus.com', certifications: 10 },
  '6': { name: 'Lisa Anderson', role: 'Support Worker', status: 'Active', phone: '0467 890 123', email: 'lisa.anderson@hpaplus.com', certifications: 3 },
}
const current = staffMembers[staffId.value] || staffMembers['1']
const staffName = ref(current.name)
const staffRole = ref(current.role)
const staffStatus = ref(current.status)
const staffPhone = ref(current.phone)
const staffEmail = ref(current.email)
const staffCertifications = ref(current.certifications)

const avatarUrl = computed(() => getAvatarUrl(staffName.value))
const statusColor = computed(() => {
  const map: Record<string, string> = { Active: 'success', 'On Leave': 'warning', Inactive: 'grey' }
  return map[staffStatus.value] || 'grey'
})

function getStatusIcon(s: string): string {
  const map: Record<string, string> = { Active: 'mdi-check-circle', 'On Leave': 'mdi-calendar-clock', Inactive: 'mdi-account-off-outline' }
  return map[s] ?? 'mdi-circle-outline'
}

type EmployeeFileCategory = 'id-visa' | 'contract' | 'certificates' | 'training'
interface StaffDocItem { id: number; name: string; category: EmployeeFileCategory; uploadedAt: string }
const staffDocuments = ref<StaffDocItem[]>([
  { id: 1, name: 'Passport copy', category: 'id-visa', uploadedAt: '10 Jan 2026' },
  { id: 2, name: 'Visa grant notice', category: 'id-visa', uploadedAt: '08 Jan 2026' },
  { id: 3, name: 'Employment contract 2026', category: 'contract', uploadedAt: '05 Jan 2026' },
  { id: 4, name: 'First Aid certificate', category: 'certificates', uploadedAt: '05 Jan 2026' },
  { id: 5, name: 'WWCC clearance', category: 'certificates', uploadedAt: '10 Jan 2026' },
  { id: 6, name: 'Manual handling training', category: 'training', uploadedAt: '12 Jan 2026' },
])

const employeeTab = ref('id-visa')
const itemsByCategory = computed(() => ({
  idVisa: staffDocuments.value.filter(d => d.category === 'id-visa'),
  contract: staffDocuments.value.filter(d => d.category === 'contract'),
  certificates: staffDocuments.value.filter(d => d.category === 'certificates'),
  training: staffDocuments.value.filter(d => d.category === 'training'),
}))

const categoryLabels: Record<EmployeeFileCategory, string> = {
  'id-visa': 'ID & Visa',
  contract: 'Contract',
  certificates: 'Certificates',
  training: 'Training',
}
const addDocCategory = ref<EmployeeFileCategory>('id-visa')
const showAddDocDialog = ref(false)
const newDoc = ref<{ name: string; file: File[] | null }>({ name: '', file: null })
const addDocCategoryLabel = computed(() => categoryLabels[addDocCategory.value])
function openAddDoc(cat: EmployeeFileCategory) {
  addDocCategory.value = cat
  newDoc.value = { name: '', file: null }
  showAddDocDialog.value = true
}
function addDoc() {
  if (!newDoc.value.name.trim()) return
  staffDocuments.value.push({
    id: Date.now(),
    name: newDoc.value.name,
    category: addDocCategory.value,
    uploadedAt: new Date().toLocaleDateString('en-AU', { day: 'numeric', month: 'short', year: 'numeric' }),
  })
  newDoc.value = { name: '', file: null }
  showAddDocDialog.value = false
}
function removeDoc(id: number) {
  staffDocuments.value = staffDocuments.value.filter(d => d.id !== id)
}

interface PerfNote { id: number; title: string; date: string; author: string; content: string }
const performanceNotes = ref<PerfNote[]>([
  { id: 1, title: 'Q1 review', date: '20 Jan 2026', author: 'Manager', content: 'Strong performance. Client feedback positive.' },
])
const showAddNoteDialog = ref(false)
const newNote = ref({ title: '', content: '', author: 'Current User' })
function addPerformanceNote() {
  if (!newNote.value.title.trim() || !newNote.value.content.trim()) return
  performanceNotes.value.push({
    id: Date.now(),
    title: newNote.value.title,
    date: new Date().toLocaleDateString('en-AU', { day: 'numeric', month: 'short', year: 'numeric' }),
    author: newNote.value.author,
    content: newNote.value.content,
  })
  newNote.value = { title: '', content: '', author: 'Current User' }
  showAddNoteDialog.value = false
}
function removeNote(id: number) {
  performanceNotes.value = performanceNotes.value.filter(n => n.id !== id)
}

function goToEdit() {
  router.push({ name: 'staff', query: { edit: staffId.value } })
}
</script>

<style scoped>
.section-card-header { padding: 1rem 1.25rem; }
.section-card-icon { margin-right: 0.75rem; display: flex; align-items: center; }
.detail-divider { border-color: rgba(30, 58, 95, 0.08); }
.doc-list-item { border-bottom: 1px solid rgba(30, 58, 95, 0.08); }
.doc-list-item:last-child { border-bottom: none; }
</style>
