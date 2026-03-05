<template>
  <DashboardTemplate :animate="true">
    <template #header>
      <div>
        <h1 class="page-title mb-1">Staff</h1>
        <p class="page-subtitle">Platform support and operations team</p>
      </div>
      <v-btn color="primary" size="default" prepend-icon="mdi-plus" rounded="lg" @click="openAddStaff">
        Add staff
      </v-btn>
    </template>

    <!-- Stats Cards (same style as dashboard) -->
    <v-row class="mb-4">
      <v-col cols="6" sm="6" lg="3">
        <HpaDashboardWidget
          role="admin"
          :loading="false"
          title="Total staff"
          :value="staffMembers.length"
          icon="mdi-account-hard-hat"
          trend="neutral"
          trend-value="—"
          trend-label="team"
        />
      </v-col>
      <v-col cols="6" sm="6" lg="3">
        <HpaDashboardWidget
          role="admin"
          :loading="false"
          title="Active today"
          :value="activeTodayCount"
          icon="mdi-account-check"
          trend="up"
          :trend-value="String(activeTodayCount)"
          trend-label="active"
        />
      </v-col>
      <v-col cols="6" sm="6" lg="3">
        <HpaDashboardWidget
          role="admin"
          :loading="false"
          title="Available"
          :value="availableCount"
          icon="mdi-account-clock"
          trend="neutral"
          :trend-value="String(availableCount)"
          trend-label="available"
        />
      </v-col>
      <v-col cols="6" sm="6" lg="3">
        <HpaDashboardWidget
          role="admin"
          :loading="false"
          title="On leave"
          :value="onLeaveCount"
          icon="mdi-beach"
          trend="neutral"
          :trend-value="String(onLeaveCount)"
          trend-label="leave"
        />
      </v-col>
    </v-row>

    <!-- View Toggle -->
    <v-card elevation="0" rounded="lg" class="modern-card mb-4">
      <v-card-text class="pa-4">
        <v-btn-toggle
          v-model="viewMode"
          mandatory
          variant="outlined"
          divided
          density="compact"
          rounded="lg"
        >
          <v-btn value="cards" prepend-icon="mdi-view-grid">
            Cards
          </v-btn>
          <v-btn value="table" prepend-icon="mdi-view-list">
            Table
          </v-btn>
        </v-btn-toggle>
      </v-card-text>
    </v-card>

    <!-- Cards View -->
    <v-row v-if="viewMode === 'cards'">
      <v-col
        v-for="staff in staffMembers"
        :key="staff.id"
        cols="12"
        sm="6"
        md="4"
        lg="3"
      >
        <v-card elevation="0" rounded="lg" class="modern-card staff-card h-100" hover>
          <v-card-text class="pa-6 text-center">
            <!-- Avatar -->
            <v-avatar size="80" class="mb-4">
              <v-img :src="getAvatarUrl(staff.name)" />
            </v-avatar>

            <!-- Name & Role -->
            <h3 class="text-h6 font-weight-bold mb-1">{{ staff.name }}</h3>
            <p class="text-body-2 text-medium-emphasis mb-3">{{ staff.role }}</p>

            <!-- Status Badge -->
            <v-chip
              :color="getStatusColor(staff.status)"
              :prepend-icon="getStatusIcon(staff.status)"
              size="small"
              variant="tonal"
              class="mb-4"
            >
              {{ staff.status }}
            </v-chip>

            <!-- Info -->
            <v-divider class="my-4" />

            <div class="text-left">
              <div class="d-flex align-center mb-2">
                <v-icon icon="mdi-phone" size="16" class="mr-2 text-medium-emphasis" />
                <span class="text-body-2">{{ staff.phone }}</span>
              </div>
              <div class="d-flex align-center mb-2">
                <v-icon icon="mdi-email" size="16" class="mr-2 text-medium-emphasis" />
                <span class="text-body-2 text-truncate">{{ staff.email }}</span>
              </div>
              <div class="d-flex align-center">
                <v-icon icon="mdi-certificate" size="16" class="mr-2 text-medium-emphasis" />
                <span class="text-body-2">{{ staff.certifications }} docs</span>
              </div>
            </div>
          </v-card-text>

          <v-card-actions class="pa-4 pt-0">
            <v-btn
              variant="outlined"
              color="primary"
              block
              @click="viewStaff(staff.id)"
            >
              View Profile
            </v-btn>
          </v-card-actions>
        </v-card>
      </v-col>
    </v-row>

    <!-- Table View -->
    <HpaDataTable
      v-else
      title="Staff directory"
      icon="mdi-account-hard-hat"
      :headers="headers"
      :items="staffMembers"
      :loading="loading"
      searchable
      exportable
      selectable
    >
      <!-- Custom column: Avatar -->
      <template #item.name="{ item }">
        <div class="d-flex align-center py-2">
          <v-avatar size="40" class="mr-3">
            <v-img :src="getAvatarUrl(item.name)" />
          </v-avatar>
          <div>
            <div class="font-weight-medium">{{ item.name }}</div>
            <div class="text-caption text-medium-emphasis">{{ item.role }}</div>
          </div>
        </div>
      </template>

      <!-- Custom column: Status -->
      <template #item.status="{ item }">
        <v-chip
          :color="getStatusColor(item.status)"
          :prepend-icon="getStatusIcon(item.status)"
          size="small"
          variant="tonal"
        >
          {{ item.status }}
        </v-chip>
      </template>

      <!-- Custom column: Documents -->
      <template #item.certifications="{ item }">
        <v-chip size="small" variant="tonal" color="accent" prepend-icon="mdi-file-document-multiple">
          {{ item.certifications }} docs
        </v-chip>
      </template>

      <!-- Custom column: Actions -->
      <template #item.actions="{ item }">
        <div class="d-flex gap-2 flex-wrap">
          <v-btn
            icon="mdi-eye"
            variant="text"
            size="small"
            color="primary"
            @click="viewStaff(item.id)"
          >
            <v-icon>mdi-eye</v-icon>
            <v-tooltip activator="parent" location="top">View Profile</v-tooltip>
          </v-btn>
          <v-btn
            icon="mdi-pencil"
            variant="text"
            size="small"
            color="action"
            @click="editStaff(item.id)"
          >
            <v-icon>mdi-pencil</v-icon>
            <v-tooltip activator="parent" location="top">Edit</v-tooltip>
          </v-btn>
          <v-btn
            icon="mdi-calendar"
            variant="text"
            size="small"
            color="accent"
            @click="viewSchedule(item.id)"
          >
            <v-icon>mdi-calendar</v-icon>
            <v-tooltip activator="parent" location="top">View schedule</v-tooltip>
          </v-btn>
        </div>
      </template>
    </HpaDataTable>

    <!-- Add Staff Dialog -->
    <HpaModal
      v-model="showAddStaffDialog"
      :title="editingStaffId ? 'Edit staff member' : 'Add staff member'"
      :icon="editingStaffId ? 'mdi-account-edit' : 'mdi-account-plus'"
      max-width="900"
      @confirm="handleAddStaff"
    >
      <v-form ref="staffForm">
        <v-row>
          <v-col cols="12" md="6">
            <v-text-field
              v-model="newStaff.first_name"
              label="First Name"
              prepend-icon="mdi-account"
              required
            />
          </v-col>
          <v-col cols="12" md="6">
            <v-text-field
              v-model="newStaff.last_name"
              label="Last Name"
              prepend-icon="mdi-account"
              required
            />
          </v-col>
          <v-col cols="12" md="6">
            <v-text-field
              v-model="newStaff.email"
              label="Email"
              type="email"
              prepend-icon="mdi-email"
            />
          </v-col>
          <v-col cols="12" md="6">
            <v-text-field
              v-model="newStaff.phone"
              label="Phone"
              prepend-icon="mdi-phone"
            />
          </v-col>
          <v-col cols="12" md="6">
            <v-select
              v-model="newStaff.role"
              :items="roles"
              label="Role"
              prepend-icon="mdi-briefcase"
            />
          </v-col>
          <v-col cols="12" md="6">
            <v-select
              v-model="newStaff.status"
              :items="statuses"
              label="Status"
              prepend-icon="mdi-information"
            />
          </v-col>
          <v-col cols="12">
            <v-textarea
              v-model="newStaff.notes"
              label="Notes"
              rows="3"
              prepend-icon="mdi-note-text"
            />
          </v-col>
        </v-row>
      </v-form>
    </HpaModal>
  </DashboardTemplate>
</template>

<script setup lang="ts">
import { ref, computed, watch } from 'vue'
import { useRoute, useRouter } from 'vue-router'
import HpaDataTable from '@/components/base/HpaDataTable.vue'
import HpaDashboardWidget from '@/components/base/HpaDashboardWidget.vue'
import HpaModal from '@/components/base/HpaModal.vue'
import DashboardTemplate from '@/components/DashboardTemplate.vue'
import { getAvatarUrl } from '@/constants/images'

const route = useRoute()
const router = useRouter()

// State
const loading = ref(false)
const viewMode = ref('cards')
const showAddStaffDialog = ref(false)
const editingStaffId = ref<number | null>(null)

// Form data
const newStaff = ref({
  first_name: '',
  last_name: '',
  email: '',
  phone: '',
  role: 'Support',
  status: 'Active',
  notes: '',
})

const roles = ['Support', 'Operations', 'Coordinator', 'Team Leader', 'Admin']
const statuses = ['Active', 'On Leave', 'Inactive']

// Table configuration
const headers = [
  { title: 'Name', key: 'name', sortable: true },
  { title: 'Phone', key: 'phone', sortable: true },
  { title: 'Email', key: 'email', sortable: true },
  { title: 'Status', key: 'status', sortable: true },
  { title: 'Documents', key: 'certifications', sortable: true },
  { title: 'Actions', key: 'actions', sortable: false },
]

// Mock data
const staffMembers = ref([
  { id: 1, name: 'John Smith', role: 'Support', phone: '0917 123 4567', email: 'john.smith@bulodph.com', status: 'Active', certifications: 5 },
  { id: 2, name: 'Sarah Davis', role: 'Operations', phone: '0918 234 5678', email: 'sarah.davis@bulodph.com', status: 'Active', certifications: 8 },
  { id: 3, name: 'Michael Brown', role: 'Coordinator', phone: '0919 345 6789', email: 'michael.brown@bulodph.com', status: 'Active', certifications: 6 },
  { id: 4, name: 'Emily Wilson', role: 'Support', phone: '0920 456 7890', email: 'emily.wilson@bulodph.com', status: 'On Leave', certifications: 4 },
  { id: 5, name: 'David Martinez', role: 'Team Leader', phone: '0921 567 8901', email: 'david.martinez@bulodph.com', status: 'Active', certifications: 10 },
  { id: 6, name: 'Lisa Anderson', role: 'Support', phone: '0922 678 9012', email: 'lisa.anderson@bulodph.com', status: 'Active', certifications: 3 },
])

const activeTodayCount = 4
const availableCount = computed(() => staffMembers.value.filter(s => s.status === 'Active').length)
const onLeaveCount = computed(() => staffMembers.value.filter(s => s.status === 'On Leave').length)

// Methods
const getStatusColor = (status: string) => {
  const colors: Record<string, string> = {
    Active: 'success',
    'On Leave': 'warning',
    Inactive: 'grey',
  }
  return colors[status] || 'grey'
}

const getStatusIcon = (status: string) => {
  const icons: Record<string, string> = {
    Active: 'mdi-check-circle',
    'On Leave': 'mdi-calendar-clock',
    Inactive: 'mdi-account-off-outline',
  }
  return icons[status] || 'mdi-circle-outline'
}

const viewStaff = (id: number) => {
  router.push({ name: 'staff-details', params: { id: String(id) } })
}

const setFormFromStaff = (staff: (typeof staffMembers.value)[0]) => {
  const [first = '', ...rest] = staff.name.split(' ')
  newStaff.value = {
    first_name: first,
    last_name: rest.join(' ') || '',
    email: staff.email,
    phone: staff.phone,
    role: staff.role,
    status: staff.status,
    notes: '',
  }
}

const openAddStaff = () => {
  editingStaffId.value = null
  newStaff.value = { first_name: '', last_name: '', email: '', phone: '', role: 'Support', status: 'Active', notes: '' }
  showAddStaffDialog.value = true
}

const editStaff = (id: number) => {
  const staff = staffMembers.value.find(s => s.id === id)
  if (!staff) return
  editingStaffId.value = id
  setFormFromStaff(staff)
  showAddStaffDialog.value = true
}

const viewSchedule = (id: number) => {
  router.push({ name: 'shifts', query: { staffId: String(id) } })
}

const handleAddStaff = () => {
  const fullName = [newStaff.value.first_name, newStaff.value.last_name].filter(Boolean).join(' ') || 'Unnamed'
  if (editingStaffId.value) {
    const staff = staffMembers.value.find(s => s.id === editingStaffId.value)
    if (staff) {
      staff.name = fullName
      staff.email = newStaff.value.email
      staff.phone = newStaff.value.phone
      staff.role = newStaff.value.role
      staff.status = newStaff.value.status
    }
  } else {
    const id = Math.max(0, ...staffMembers.value.map(s => s.id)) + 1
    staffMembers.value.push({
      id,
      name: fullName,
      role: newStaff.value.role,
      phone: newStaff.value.phone,
      email: newStaff.value.email,
      status: newStaff.value.status,
      certifications: 0,
    })
  }
  showAddStaffDialog.value = false
  editingStaffId.value = null
  // Reset form
  newStaff.value = {
    first_name: '',
    last_name: '',
    email: '',
    phone: '',
    role: 'Support',
    status: 'Active',
    notes: '',
  }
}

watch(
  () => route.query.edit,
  (editId) => {
    if (editId != null && editId !== '') {
      const id = typeof editId === 'string' ? parseInt(editId, 10) : Number(editId)
      if (!isNaN(id)) editStaff(id)
    }
  },
  { immediate: true }
)
</script>

<style scoped>
.staff-card :deep(.v-divider) {
  border-color: rgba(30, 58, 95, 0.08);
}
</style>
