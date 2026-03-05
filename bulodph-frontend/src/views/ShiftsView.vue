<template>
  <DashboardTemplate :animate="true">
    <template #header>
      <div>
        <h1 class="page-title mb-1">Rosters & Timesheets</h1>
        <p class="page-subtitle">Rosters and timesheets for your team</p>
      </div>
      <v-btn color="primary" size="default" prepend-icon="mdi-plus" rounded="lg" @click="showCreateShiftDialog = true">
        Create Shift
      </v-btn>
    </template>

    <!-- Toolbar -->
    <v-card elevation="0" rounded="lg" class="modern-card mb-3 shifts-toolbar-card">
      <v-card-text class="pa-3">
        <v-row align="center" dense>
          <v-col cols="12" md="2">
            <v-btn-toggle
              v-model="viewMode"
              mandatory
              variant="outlined"
              divided
              density="compact"
              rounded="lg"
              class="dashboard-mode-toggle shifts-view-toggle"
            >
              <v-btn value="calendar" prepend-icon="mdi-calendar" size="small">
                Calendar
              </v-btn>
              <v-btn value="list" prepend-icon="mdi-view-list" size="small">
                List
              </v-btn>
            </v-btn-toggle>
          </v-col>
          <v-col cols="12" md="2">
            <v-select
              v-model="statusFilter"
              :items="statusOptions"
              label="Filter by Status"
              density="compact"
              clearable
              hide-details
              variant="outlined"
            />
          </v-col>
          <v-col cols="12" md="4">
            <v-text-field
              v-model="searchQuery"
              label="Search shifts..."
              prepend-inner-icon="mdi-magnify"
              density="compact"
              clearable
              hide-details
              variant="outlined"
            />
          </v-col>
          <v-col cols="12" md="4" class="d-flex justify-end gap-2">
            <v-btn
              icon="mdi-filter-variant"
              variant="text"
              color="primary"
              size="small"
            >
              <v-icon>mdi-filter-variant</v-icon>
              <v-tooltip activator="parent" location="bottom">Advanced Filters</v-tooltip>
            </v-btn>
            <v-btn
              icon="mdi-download"
              variant="text"
              color="primary"
              size="small"
            >
              <v-icon>mdi-download</v-icon>
              <v-tooltip activator="parent" location="bottom">Export</v-tooltip>
            </v-btn>
          </v-col>
        </v-row>
      </v-card-text>
    </v-card>

    <!-- Calendar View -->
    <v-card v-if="viewMode === 'calendar'" elevation="0" rounded="lg" class="modern-card calendar-card">
      <div class="section-card-header calendar-toolbar">
        <div class="section-card-icon shifts-calendar-icon">
          <v-icon icon="mdi-calendar-week" size="20" />
        </div>
        <div class="calendar-nav">
          <v-btn
            icon="mdi-chevron-left"
            variant="text"
            size="small"
            class="calendar-nav-btn"
            @click="previousWeek"
          />
          <v-btn
            icon="mdi-chevron-right"
            variant="text"
            size="small"
            class="calendar-nav-btn"
            @click="nextWeek"
          />
          <span class="calendar-week-label">{{ currentWeekLabel }}</span>
        </div>
        <v-spacer />
        <v-btn
          variant="outlined"
          size="small"
          density="compact"
          class="calendar-today-btn"
          rounded="lg"
          @click="goToToday"
        >
          Today
        </v-btn>
      </div>
      <v-divider class="dashboard-divider" />

      <!-- Calendar Grid -->
      <div class="calendar-container">
        <!-- Time Column -->
        <div class="gcal-time-column">
          <div class="gcal-time-header"></div>
          <div
            v-for="(label, index) in timeSlotLabels"
            :key="index"
            class="gcal-time-slot"
          >
            {{ label }}
          </div>
        </div>

        <!-- Days Columns -->
        <div class="gcal-days-container">
          <div
            v-for="day in weekDays"
            :key="day.date"
            class="gcal-day-column"
            :class="{ 'gcal-weekend': day.isWeekend }"
          >
            <!-- Day Header (Google style: day name + date, today = blue circle) -->
            <div class="gcal-day-header" :class="{ 'gcal-today': day.isToday }">
              <span class="gcal-day-name">{{ day.dayName }}</span>
              <div class="gcal-day-date-wrap">
                <span class="gcal-day-date">{{ day.dayDate }}</span>
              </div>
            </div>

            <!-- Time Grid -->
            <div class="gcal-time-grid">
              <div
                v-for="(_, hourIndex) in timeSlots"
                :key="hourIndex"
                class="gcal-grid-slot"
              />
              <!-- Shift Blocks (Google Calendar event style) -->
              <div
                v-for="shift in getShiftsForDay(day.date)"
                :key="shift.id"
                class="gcal-event"
                :class="`gcal-event-${shift.status.toLowerCase()}`"
                :style="getShiftStyle(shift)"
                @click="handleViewDetails(shift.id)"
              >
                <div class="gcal-event-content">
                  <span class="gcal-event-time">{{ formatShiftTimeShort(shift) }}</span>
                  <span class="gcal-event-title">{{ shift.client.full_name }}</span>
                  <span class="gcal-event-subtitle">{{ shift.staff_name || 'Unassigned' }}</span>
                </div>
              </div>
            </div>
          </div>
        </div>
      </div>
    </v-card>

    <!-- List View -->
    <v-card v-else elevation="0" rounded="lg" class="modern-card shifts-list-card">
      <div class="section-card-header">
        <div class="section-card-icon shifts-list-icon">
          <v-icon icon="mdi-view-list" size="20" />
        </div>
        <span class="section-card-title">Shifts</span>
      </div>
      <v-divider class="dashboard-divider" />
      <v-list lines="three" class="pa-0 shifts-list">
        <v-list-item
          v-for="shift in filteredShifts"
          :key="shift.id"
          class="px-4 py-2 shifts-list-item"
          @click="handleViewDetails(shift.id)"
        >
          <template #prepend>
            <v-avatar :color="getStatusColor(shift.status)" size="40" class="shifts-list-avatar">
              <v-icon icon="mdi-calendar-clock" color="white" size="20" />
            </v-avatar>
          </template>

          <v-list-item-title class="font-weight-medium mb-0 text-body-2">
            {{ shift.client.full_name }}
          </v-list-item-title>
          <v-list-item-subtitle class="text-caption">
            <div class="d-flex align-center flex-wrap ga-3 mt-0">
              <span>
                <v-icon icon="mdi-clock-outline" size="14" class="mr-1" />
                {{ formatShiftTime(shift) }}
              </span>
              <span>
                <v-icon icon="mdi-account" size="14" class="mr-1" />
                {{ shift.staff_name || 'Unassigned' }}
              </span>
              <span>
                <v-icon icon="mdi-map-marker" size="14" class="mr-1" />
                {{ shift.client.suburb }}
              </span>
            </div>
          </v-list-item-subtitle>

          <template #append>
            <div class="d-flex align-center gap-2">
              <v-chip
                :color="getStatusColor(shift.status)"
                size="small"
                variant="tonal"
              >
                {{ shift.status }}
              </v-chip>
              <v-btn
                icon="mdi-chevron-right"
                variant="text"
                size="small"
                color="primary"
              />
            </div>
          </template>
        </v-list-item>
      </v-list>

      <v-divider class="dashboard-divider" />

      <div v-if="filteredShifts.length === 0" class="pa-6">
        <HpaEmptyState
          title="No shifts found"
          description="Try adjusting your filters or create a new shift"
          icon="mdi-calendar-blank"
          action-text="Create Shift"
          @action="showCreateShiftDialog = true"
        />
      </div>
    </v-card>

    <!-- Create Shift Dialog -->
    <HpaModal
      v-model="showCreateShiftDialog"
      title="Create New Shift"
      icon="mdi-calendar-plus"
      max-width="640"
      @confirm="handleCreateShift"
    >
      <v-form ref="shiftForm" class="modal-form">
        <v-row dense>
          <v-col cols="12" md="6">
            <v-select
              v-model="newShift.client_id"
              label="Client"
              :items="mockClients"
              item-title="name"
              item-value="id"
              density="compact"
              hide-details
              variant="outlined"
            />
          </v-col>
          <v-col cols="12" md="6">
            <v-select
              v-model="newShift.staff_id"
              label="Staff Member"
              :items="mockStaff"
              item-title="name"
              item-value="id"
              density="compact"
              hide-details
              variant="outlined"
            />
          </v-col>
          <v-col cols="12" md="6">
            <v-text-field
              v-model="newShift.start_date"
              label="Start Date"
              type="date"
              density="compact"
              hide-details
              variant="outlined"
            />
          </v-col>
          <v-col cols="12" md="6">
            <v-text-field
              v-model="newShift.start_time"
              label="Start Time"
              type="time"
              density="compact"
              hide-details
              variant="outlined"
            />
          </v-col>
          <v-col cols="12" md="6">
            <v-text-field
              v-model="newShift.end_date"
              label="End Date"
              type="date"
              density="compact"
              hide-details
              variant="outlined"
            />
          </v-col>
          <v-col cols="12" md="6">
            <v-text-field
              v-model="newShift.end_time"
              label="End Time"
              type="time"
              density="compact"
              hide-details
              variant="outlined"
            />
          </v-col>
          <v-col cols="12">
            <v-textarea
              v-model="newShift.notes"
              label="Notes"
              rows="2"
              density="compact"
              hide-details
              variant="outlined"
            />
          </v-col>
        </v-row>
      </v-form>
    </HpaModal>
  </DashboardTemplate>
</template>

<script setup lang="ts">
import { ref, computed } from 'vue'
import { useRoute, useRouter } from 'vue-router'
import { format, addDays, startOfWeek, endOfWeek, isSameDay, isToday, parseISO } from 'date-fns'
import HpaModal from '@/components/base/HpaModal.vue'
import HpaEmptyState from '@/components/base/HpaEmptyState.vue'
import DashboardTemplate from '@/components/DashboardTemplate.vue'
import { getAvatarUrl } from '@/constants/images'
import { MOCK_SHIFT_CLIENTS, MOCK_SHIFT_STAFF, MOCK_SHIFTS } from '@/constants/mockShiftsSeed'
import { useToastStore } from '@/stores/toast'

const route = useRoute()
const router = useRouter()
const toast = useToastStore()

// View state
const viewMode = ref('calendar')
const statusFilter = ref(null)
const searchQuery = ref('')
const showCreateShiftDialog = ref(false)
const currentWeekStart = ref(startOfWeek(new Date(), { weekStartsOn: 1 }))

// Form data
const newShift = ref({
  client_id: null,
  staff_id: null,
  start_date: format(new Date(), 'yyyy-MM-dd'),
  start_time: '09:00',
  end_date: format(new Date(), 'yyyy-MM-dd'),
  end_time: '17:00',
  notes: '',
})

// Options
const statusOptions = [
  { title: 'Invoiced', value: 'INVOICED' },
  { title: 'Booked', value: 'BOOKED' },
  { title: 'Pending', value: 'PENDING' },
  { title: 'Leave', value: 'LEAVE' },
]

// Mock data
const mockClients = MOCK_SHIFT_CLIENTS
const mockStaff = MOCK_SHIFT_STAFF
const mockShifts = ref(MOCK_SHIFTS)

// Time slots for calendar (6 AM to 10 PM)
const timeSlots = Array.from({ length: 17 }, (_, i) => {
  const hour = i + 6
  return `${hour.toString().padStart(2, '0')}:00`
})

// Week navigation
const currentWeekLabel = computed(() => {
  const start = currentWeekStart.value
  const end = endOfWeek(start, { weekStartsOn: 1 })
  return `${format(start, 'MMM d')} - ${format(end, 'MMM d, yyyy')}`
})

const weekDays = computed(() => {
  return Array.from({ length: 7 }, (_, i) => {
    const date = addDays(currentWeekStart.value, i)
    const dayOfWeek = date.getDay()
    return {
      date: format(date, 'yyyy-MM-dd'),
      dayName: format(date, 'EEE'),
      dayDate: format(date, 'd'),
      isToday: isToday(date),
      isWeekend: dayOfWeek === 0 || dayOfWeek === 6,
    }
  })
})

// 12-hour labels for time column (Google Calendar style)
const timeSlotLabels = computed(() => {
  return Array.from({ length: 17 }, (_, i) => {
    const hour = i + 6
    if (hour === 0) return '12 AM'
    if (hour === 12) return '12 PM'
    if (hour < 12) return `${hour} AM`
    return `${hour - 12} PM`
  })
})

const previousWeek = () => {
  currentWeekStart.value = addDays(currentWeekStart.value, -7)
}

const nextWeek = () => {
  currentWeekStart.value = addDays(currentWeekStart.value, 7)
}

const goToToday = () => {
  currentWeekStart.value = startOfWeek(new Date(), { weekStartsOn: 1 })
}

// Shift helpers
const getShiftsForDay = (dateStr: string) => {
  return mockShifts.value.filter(shift => {
    const shiftDate = format(parseISO(shift.scheduled_start), 'yyyy-MM-dd')
    return shiftDate === dateStr
  })
}

const getShiftStyle = (shift: any) => {
  const start = parseISO(shift.scheduled_start)
  const end = parseISO(shift.scheduled_end)

  const startHour = start.getHours() + start.getMinutes() / 60
  const endHour = end.getHours() + end.getMinutes() / 60
  const duration = endHour - startHour

  // Position from 6 AM (first time slot)
  const top = ((startHour - 6) / 16) * 100
  const height = (duration / 16) * 100

  return {
    top: `${top}%`,
    height: `${height}%`,
  }
}

const formatShiftTime = (shift: any) => {
  const start = parseISO(shift.scheduled_start)
  const end = parseISO(shift.scheduled_end)
  return `${format(start, 'h:mm a')} - ${format(end, 'h:mm a')}`
}

const formatShiftTimeShort = (shift: any) => {
  const start = parseISO(shift.scheduled_start)
  const end = parseISO(shift.scheduled_end)
  return `${format(start, 'h:mm a')} – ${format(end, 'h:mm a')}`
}

const getStatusColor = (status: string) => {
  const colors: Record<string, string> = {
    INVOICED: 'success',
    BOOKED: 'primary',
    PENDING: 'warning',
    LEAVE: 'error',
  }
  return colors[status] || 'grey'
}

const filteredShifts = computed(() => {
  let shifts = mockShifts.value

  if (statusFilter.value) {
    shifts = shifts.filter(s => s.status === statusFilter.value)
  }

  if (searchQuery.value) {
    const query = searchQuery.value.toLowerCase()
    shifts = shifts.filter(s =>
      s.client.full_name.toLowerCase().includes(query) ||
      s.staff_name?.toLowerCase().includes(query) ||
      s.client.suburb.toLowerCase().includes(query)
    )
  }

  const staffIdRaw = route.query.staffId
  const staffId = typeof staffIdRaw === 'string' ? parseInt(staffIdRaw, 10) : Number(staffIdRaw)
  if (!isNaN(staffId)) {
    const staffName = mockStaff.find(s => s.id === staffId)?.name
    if (staffName) {
      shifts = shifts.filter(s => s.staff_name === staffName)
    }
  }

  return shifts
})

// Actions
const handleViewDetails = (shiftId: string) => {
  router.push({ name: 'shift-details', params: { id: shiftId } })
}

const handleCreateShift = () => {
  const client = mockClients.find(c => c.id === newShift.value.client_id)
  if (!client) {
    toast.warning('Select a client before saving the shift.')
    return
  }

  const startIso = new Date(`${newShift.value.start_date}T${newShift.value.start_time}`).toISOString()
  const endIso = new Date(`${newShift.value.end_date}T${newShift.value.end_time}`).toISOString()
  if (Number.isNaN(Date.parse(startIso)) || Number.isNaN(Date.parse(endIso))) {
    toast.error('Please enter valid start and end date/time.')
    return
  }
  if (new Date(endIso) <= new Date(startIso)) {
    toast.error('End time must be after start time.')
    return
  }

  const staffName = mockStaff.find(s => s.id === newShift.value.staff_id)?.name ?? null
  mockShifts.value.unshift({
    id: String(Date.now()),
    client: {
      full_name: client.name,
      suburb: 'Isabela',
      address_line_1: '—',
      latitude: 0,
      longitude: 0,
    },
    staff_name: staffName,
    scheduled_start: startIso,
    scheduled_end: endIso,
    status: 'PENDING',
    notes: newShift.value.notes,
  })

  toast.success('Shift created.')
  showCreateShiftDialog.value = false
  // Reset form
  newShift.value = {
    client_id: null,
    staff_id: null,
    start_date: format(new Date(), 'yyyy-MM-dd'),
    start_time: '09:00',
    end_date: format(new Date(), 'yyyy-MM-dd'),
    end_time: '17:00',
    notes: '',
  }
}
</script>

<style scoped>
/* Toolbar */
.shifts-toolbar-card :deep(.v-field) {
  --v-field-border-opacity: 0.5;
}

.shifts-view-toggle {
  border-color: var(--border-subtle) !important;
  background: var(--surface-1) !important;
}

/* Calendar – section header + design system */
.calendar-card {
  overflow: hidden;
}

.calendar-toolbar {
  padding: 0.75rem 1rem;
  flex-wrap: wrap;
  gap: 0.75rem;
}

.shifts-calendar-icon {
  background: rgba(14, 165, 233, 0.1) !important;
  color: var(--sky-700) !important;
}

.calendar-nav {
  display: flex;
  align-items: center;
  gap: 4px;
}

.calendar-nav-btn {
  color: var(--text-secondary) !important;
  min-width: 36px;
}

.calendar-nav-btn:hover {
  background: var(--surface-2) !important;
  color: var(--text-primary) !important;
}

.calendar-week-label {
  font-size: var(--text-base);
  font-weight: 600;
  color: var(--text-primary);
  margin-left: 6px;
  min-width: 160px;
}

.calendar-today-btn {
  color: var(--sky-600) !important;
  border-color: var(--border-subtle) !important;
  text-transform: none;
  font-weight: 600;
}

.calendar-today-btn:hover {
  background: rgba(14, 165, 233, 0.08) !important;
  border-color: var(--sky-500) !important;
}

.calendar-container {
  display: flex;
  overflow-x: auto;
  min-height: 560px;
  background: var(--surface-0);
}

.gcal-time-column {
  flex-shrink: 0;
  width: 52px;
  border-right: 1px solid var(--border-subtle);
}

.gcal-time-header {
  height: 44px;
  border-bottom: 1px solid var(--border-subtle);
}

.gcal-time-slot {
  height: 56px;
  padding: 0 6px;
  font-size: var(--text-xs);
  color: var(--text-muted);
  line-height: 56px;
  text-align: right;
  border-bottom: 1px solid var(--surface-2);
}

.gcal-days-container {
  display: flex;
  flex: 1;
  min-width: 0;
}

.gcal-day-column {
  flex: 1;
  min-width: 0;
  border-right: 1px solid var(--border-subtle);
  position: relative;
  background: var(--surface-0);
}

.gcal-day-column:last-child {
  border-right: none;
}

.gcal-day-column.gcal-weekend {
  background: var(--surface-1);
}

.gcal-day-header {
  height: 44px;
  display: flex;
  flex-direction: column;
  align-items: center;
  justify-content: center;
  border-bottom: 1px solid var(--border-subtle);
  background: var(--surface-0);
  position: sticky;
  top: 0;
  z-index: 10;
}

.gcal-day-name {
  font-size: var(--text-xs);
  font-weight: 500;
  color: var(--text-muted);
  text-transform: uppercase;
  letter-spacing: 0.06em;
}

.gcal-day-date-wrap {
  margin-top: 2px;
}

.gcal-day-header.gcal-today .gcal-day-date-wrap {
  width: 26px;
  height: 26px;
  border-radius: 50%;
  background: var(--sky-500);
  display: flex;
  align-items: center;
  justify-content: center;
}

.gcal-day-date {
  font-size: var(--text-base);
  font-weight: 600;
  color: var(--text-primary);
}

.gcal-day-header.gcal-today .gcal-day-date {
  color: #fff;
  font-size: var(--text-body);
}

.gcal-time-grid {
  position: relative;
  height: 952px;
  background: var(--surface-0);
}

.gcal-grid-slot {
  height: 56px;
  border-bottom: 1px solid var(--surface-2);
}

/* Event blocks – design system (pastel + left border) */
.gcal-event {
  position: absolute;
  left: 3px;
  right: 3px;
  border-radius: var(--radius-sm);
  padding: 4px 8px;
  cursor: pointer;
  overflow: hidden;
  border-left: 3px solid;
  z-index: 5;
  transition: box-shadow 0.2s ease, transform 0.15s ease;
}

.gcal-event:hover {
  box-shadow: var(--shadow-md);
  z-index: 10;
}

.gcal-event-content {
  display: flex;
  flex-direction: column;
  gap: 0;
  font-size: var(--text-xs);
  line-height: 1.35;
}

.gcal-event-time {
  font-weight: 700;
  color: inherit;
  opacity: 0.95;
}

.gcal-event-title {
  font-weight: 600;
  white-space: nowrap;
  overflow: hidden;
  text-overflow: ellipsis;
}

.gcal-event-subtitle {
  opacity: 0.85;
  white-space: nowrap;
  overflow: hidden;
  text-overflow: ellipsis;
}

.gcal-event-booked {
  background: var(--sky-100);
  border-left-color: var(--sky-500);
  color: var(--sky-700);
}

.gcal-event-invoiced {
  background: rgba(16, 185, 129, 0.1);
  border-left-color: #10b981;
  color: #047857;
}

.gcal-event-pending {
  background: rgba(245, 158, 11, 0.1);
  border-left-color: #f59e0b;
  color: #b45309;
}

.gcal-event-leave {
  background: rgba(239, 68, 68, 0.08);
  border-left-color: #ef4444;
  color: #b91c1c;
}

/* List view */
.shifts-list-card .section-card-header {
  padding: 0.75rem 1rem;
}

.shifts-list-icon {
  background: rgba(14, 165, 233, 0.1) !important;
  color: var(--sky-700) !important;
}

.shifts-list-item {
  min-height: 56px;
}

.shifts-list-item:hover {
  background: var(--surface-1);
}

.shifts-list-avatar {
  flex-shrink: 0;
}

/* Responsive */
@media (max-width: 960px) {
  .calendar-container {
    overflow-x: scroll;
    min-height: 480px;
  }

  .gcal-day-column {
    min-width: 90px;
  }

  .gcal-time-column {
    width: 44px;
  }

  .gcal-time-slot {
    font-size: var(--text-xs);
    height: 48px;
  }

  .gcal-time-grid {
    height: 816px;
  }

  .gcal-grid-slot {
    height: 48px;
  }
}
</style>
