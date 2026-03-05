<template>
  <DashboardTemplate title="Announcements" subtitle="Show on dashboards and send by email" :animate="true">
    <v-tabs v-model="activeTab" color="primary" grow class="announcements-tabs mb-4">
      <v-tab value="compose">
        <v-icon start size="20">mdi-email-edit-outline</v-icon>
        Compose
      </v-tab>
      <v-tab value="sent">
        <v-icon start size="20">mdi-email-send-outline</v-icon>
        Sent
      </v-tab>
    </v-tabs>

    <v-window v-model="activeTab">
      <!-- Compose tab -->
      <v-window-item value="compose">
        <v-card elevation="0" rounded="xl" class="announcements-compose-card modern-card">
          <div class="section-card-header section-card-header--with-actions">
            <div class="section-card-icon announcements-header-icon">
              <v-icon icon="mdi-bullhorn-outline" size="22" />
            </div>
            <span class="section-card-title">New announcement</span>
          </div>
          <v-divider class="dashboard-divider" />
          <v-card-text class="pa-5">
            <v-form ref="formRef" @submit.prevent="sendAnnouncement">
              <!-- Channels: Dashboards + Email -->
              <div class="announcements-channels mb-5">
                <p class="text-overline text-medium-emphasis mb-2">Where to send</p>
                <div class="channels-row">
                  <v-card
                    elevation="0"
                    rounded="lg"
                    class="channel-card"
                    :class="{ 'channel-card--active': sendToDashboard }"
                    variant="outlined"
                    @click="sendToDashboard = !sendToDashboard"
                  >
                    <v-card-text class="pa-4 d-flex align-center channel-card__inner">
                      <v-checkbox
                        :model-value="sendToDashboard"
                        hide-details
                        color="primary"
                        density="compact"
                        class="channel-card__checkbox mt-0 flex-shrink-0"
                        @click.stop
                        @update:model-value="sendToDashboard = $event"
                      />
                      <div class="channel-card__content">
                        <v-icon icon="mdi-view-dashboard-outline" size="28" class="channel-card__icon" />
                        <div class="text-subtitle-2 font-weight-bold">Dashboards</div>
                        <div class="text-caption text-medium-emphasis">Show this announcement on user dashboards</div>
                      </div>
                    </v-card-text>
                  </v-card>
                  <v-card
                    elevation="0"
                    rounded="lg"
                    class="channel-card"
                    :class="{ 'channel-card--active': sendToEmail }"
                    variant="outlined"
                    @click="sendToEmail = !sendToEmail"
                  >
                    <v-card-text class="pa-4 d-flex align-center channel-card__inner">
                      <v-checkbox
                        :model-value="sendToEmail"
                        hide-details
                        color="primary"
                        density="compact"
                        class="channel-card__checkbox mt-0 flex-shrink-0"
                        @click.stop
                        @update:model-value="sendToEmail = $event"
                      />
                      <div class="channel-card__content">
                        <v-icon icon="mdi-email-outline" size="28" class="channel-card__icon" />
                        <div class="text-subtitle-2 font-weight-bold">Email</div>
                        <div class="text-caption text-medium-emphasis">Send a copy by email</div>
                      </div>
                    </v-card-text>
                  </v-card>
                </div>
              </div>

              <v-divider class="dashboard-divider mb-5" />

              <v-text-field
                v-model="subject"
                label="Subject"
                placeholder="e.g. New promo – March, Platform update"
                variant="outlined"
                density="comfortable"
                hide-details="auto"
                class="mb-4"
                rounded="lg"
                :rules="[v => !!v?.trim() || 'Subject is required']"
              />

              <!-- Recipients: summary + modal trigger -->
              <div class="announcements-recipients mb-4">
                <p class="text-overline text-medium-emphasis mb-2">Recipients</p>
                <div class="recipients-summary" @click="openRecipientModal">
                  <div class="recipients-summary__inner">
                    <v-icon icon="mdi-account-group-outline" size="20" class="recipients-summary__icon" />
                    <span class="recipients-summary__text">{{ recipientSummary }}</span>
                    <v-icon icon="mdi-chevron-down" size="20" class="recipients-summary__chevron" />
                  </div>
                </div>
                <p class="text-caption text-medium-emphasis mt-1 mb-0">Click to choose who receives this announcement</p>
              </div>

              <v-textarea
                v-model="message"
                label="Message"
                placeholder="Write your announcement..."
                variant="outlined"
                density="comfortable"
                rows="6"
                hide-details="auto"
                class="mb-4"
                rounded="lg"
                :rules="[v => !!v?.trim() || 'Message is required']"
              />

              <div class="announcements-form-actions">
                <v-btn variant="outlined" rounded="lg" @click="resetForm">Reset</v-btn>
                <v-btn
                  color="primary"
                  type="submit"
                  rounded="lg"
                  :loading="sending"
                  prepend-icon="mdi-send"
                  class="announcements-send-btn"
                  :disabled="!sendToDashboard && !sendToEmail"
                >
                  Send announcement
                </v-btn>
              </div>
            </v-form>
          </v-card-text>
        </v-card>
      </v-window-item>

      <!-- Sent tab -->
      <v-window-item value="sent">
        <v-card elevation="0" rounded="xl" class="modern-card">
          <div class="section-card-header section-card-header--with-actions">
            <div class="section-card-icon">
              <v-icon icon="mdi-email-send-outline" size="20" />
            </div>
            <span class="section-card-title">Sent announcements</span>
          </div>
          <v-divider class="dashboard-divider" />
          <v-card-text class="pa-5">
            <div v-if="sentLoading" class="d-flex justify-center py-10">
              <v-progress-circular indeterminate color="primary" size="48" />
            </div>
            <div v-else-if="!sentList.length" class="sent-empty">
              <v-icon icon="mdi-email-open-outline" size="64" class="sent-empty__icon" />
              <p class="text-body-1 font-weight-medium mb-1">No announcements sent yet</p>
              <p class="text-body-2 text-medium-emphasis mb-0">Use the Compose tab to send your first announcement to dashboards or email.</p>
            </div>
            <div v-else class="sent-list">
              <v-card
                v-for="item in sentList"
                :key="item.id"
                elevation="0"
                rounded="lg"
                class="sent-item"
                variant="outlined"
              >
                <v-card-text class="pa-4">
                  <div class="sent-item__row">
                    <div class="sent-item__main">
                      <h3 class="sent-item__subject">{{ item.subject }}</h3>
                      <p class="sent-item__snippet">{{ item.snippet }}</p>
                      <span class="sent-item__meta">{{ formatSentDate(item.sent_at) }}</span>
                    </div>
                    <v-chip :color="tagColor(item.recipient_tag)" size="small" variant="tonal" prepend-icon="mdi-tag" class="sent-item__tag">
                      {{ item.recipient_tag }}
                    </v-chip>
                  </div>
                </v-card-text>
              </v-card>
            </div>
          </v-card-text>
        </v-card>
      </v-window-item>
    </v-window>

    <!-- Recipient selection modal -->
    <HpaModal
      v-model="recipientModalOpen"
      title="Select recipients"
      icon="mdi-account-multiple"
      max-width="560"
      persistent
      scrollable
      :show-actions="true"
      confirm-text="Done"
      hide-cancel
      @confirm="recipientModalOpen = false"
    >
      <v-radio-group v-model="recipientType" class="recipient-type-group" hide-details>
        <v-radio value="all" class="recipient-radio">
          <template #label>
            <span class="d-flex align-center gap-2">
              <v-icon size="20">mdi-account-multiple</v-icon>
              Everyone (all renters, car owners & partners)
            </span>
          </template>
        </v-radio>
        <v-radio value="clients_only" class="recipient-radio">
          <template #label>
            <span class="d-flex align-center gap-2">
              <v-icon size="20">mdi-account-outline</v-icon>
              Renters (clients) only
            </span>
          </template>
        </v-radio>
        <v-radio value="staff_only" class="recipient-radio">
          <template #label>
            <span class="d-flex align-center gap-2">
              <v-icon size="20">mdi-car-side</v-icon>
              Car rental owners only
            </span>
          </template>
        </v-radio>
        <v-radio value="specific" class="recipient-radio">
          <template #label>
            <span class="d-flex align-center gap-2">
              <v-icon size="20">mdi-account-search</v-icon>
              Specific people (search & select)
            </span>
          </template>
        </v-radio>
      </v-radio-group>

      <template v-if="recipientType === 'specific'">
        <v-text-field
          v-model="recipientSearch"
          placeholder="Search by name or email..."
          variant="outlined"
          density="compact"
          hide-details
          rounded="lg"
          prepend-inner-icon="mdi-magnify"
          class="mt-4 mb-3"
          clearable
        />
        <div class="recipient-list">
          <div v-if="specificLoading" class="d-flex justify-center py-6">
            <v-progress-circular indeterminate color="primary" size="32" />
          </div>
          <div v-else-if="!filteredSpecificPeople.length" class="text-body-2 text-medium-emphasis py-4 text-center">
            No users found. Try a different search.
          </div>
          <div v-else class="recipient-list__scroll">
            <div
              v-for="person in filteredSpecificPeople"
              :key="person.id"
              class="recipient-list-item"
              :class="{ 'recipient-list-item--selected': isPersonSelected(person) }"
              @click="togglePerson(person)"
            >
              <v-checkbox
                :model-value="isPersonSelected(person)"
                hide-details
                color="primary"
                density="compact"
                class="mt-0 flex-shrink-0"
                @click.stop
              />
              <div class="recipient-list-item__content">
                <span class="recipient-list-item__name">{{ person.name }}</span>
                <span class="recipient-list-item__meta">{{ person.email }} · {{ person.roleLabel }}</span>
              </div>
              <v-chip size="x-small" variant="tonal" class="recipient-list-item__role">{{ person.roleLabel }}</v-chip>
            </div>
          </div>
        </div>
      </template>
    </HpaModal>
  </DashboardTemplate>
</template>

<script setup lang="ts">
import { ref, computed, watch } from 'vue'
import { format } from 'date-fns'
import DashboardTemplate from '@/components/DashboardTemplate.vue'
import HpaModal from '@/components/base/HpaModal.vue'
import { useClients } from '@/composables/useClients'
import { useToastStore } from '@/stores/toast'
import api from '@/lib/api'

const activeTab = ref<'compose' | 'sent'>('compose')
const formRef = ref<{ validate: () => Promise<{ valid: boolean }> } | null>(null)
const subject = ref('')
const message = ref('')
const sendToDashboard = ref(true)
const sendToEmail = ref(true)
const recipientType = ref<'all' | 'clients_only' | 'staff_only' | 'specific'>('all')
const recipientModalOpen = ref(false)
const recipientSearch = ref('')
const selectedPeople = ref<{ id: string; role: 'client' | 'staff' | 'marketing' }[]>([])
const sending = ref(false)
const sentLoading = ref(false)
const staffLoading = ref(false)
const marketingLoading = ref(false)

interface PersonOption {
  id: string
  name: string
  email: string
  role: 'client' | 'staff' | 'marketing'
  roleLabel: string
}

const staffList = ref<{ id: string; name: string; email: string }[]>([])
const marketingList = ref<{ id: string; name: string; email: string }[]>([])

const clientsQuery = useClients()
const clients = computed(() => clientsQuery.data.value ?? [])

const specificLoading = computed(() => clientsQuery.isLoading.value || staffLoading.value || marketingLoading.value)

const specificPeople = computed(() => {
    const list: PersonOption[] = []
  const clientsData = Array.isArray(clients.value) ? clients.value : []
  clientsData.forEach((c: { id: string; full_name?: string; first_name?: string; last_name?: string; email?: string }) => {
    list.push({
      id: String(c.id),
      name: ((c as { full_name?: string }).full_name ?? `${(c as { first_name?: string }).first_name ?? ''} ${(c as { last_name?: string }).last_name ?? ''}`.trim()) || 'Unknown',
      email: (c as { email?: string }).email ?? '',
      role: 'client',
      roleLabel: 'Renter',
    })
  })
  staffList.value.forEach(s => {
    list.push({
      id: `staff-${s.id}`,
      name: s.name,
      email: s.email,
      role: 'staff',
      roleLabel: 'Car owner',
    })
  })
  marketingList.value.forEach(m => {
    list.push({
      id: `marketing-${m.id}`,
      name: m.name,
      email: m.email ?? '',
      role: 'marketing',
      roleLabel: 'Partner',
    })
  })
  return list
})

const filteredSpecificPeople = computed(() => {
  const q = recipientSearch.value.trim().toLowerCase()
  if (!q) return specificPeople.value
  return specificPeople.value.filter(
    p => p.name.toLowerCase().includes(q) || p.email.toLowerCase().includes(q) || p.roleLabel.toLowerCase().includes(q)
  )
})

function isPersonSelected(person: PersonOption): boolean {
  return selectedPeople.value.some(
    s => s.role === person.role && (person.role === 'client' ? s.id === person.id : `${person.role}-${s.id}` === person.id)
  )
}

function togglePerson(person: PersonOption) {
  const existing = selectedPeople.value.findIndex(
    s => s.role === person.role && (person.role === 'client' ? s.id === person.id : `${person.role}-${s.id}` === person.id)
  )
  if (existing >= 0) {
    selectedPeople.value = selectedPeople.value.filter((_, i) => i !== existing)
  } else {
    const id = person.role === 'client' ? person.id : person.id.replace(`${person.role}-`, '')
    selectedPeople.value = [...selectedPeople.value, { id, role: person.role }]
  }
}

const recipientSummary = computed(() => {
  if (recipientType.value === 'all') return 'Everyone (all renters, car owners & partners)'
  if (recipientType.value === 'clients_only') return 'Renters (clients) only'
  if (recipientType.value === 'staff_only') return 'Car rental owners only'
  if (recipientType.value === 'specific') {
    const n = selectedPeople.value.length
    if (n === 0) return 'Select specific people'
    return `${n} person${n !== 1 ? 's' : ''} selected`
  }
  return 'Select recipients'
})

async function loadStaff() {
  staffLoading.value = true
  try {
    const { data } = await api.get<{ data?: { id: string; name: string; email: string }[] }>('/staff')
    const list = Array.isArray((data as { data?: unknown[] })?.data) ? (data as { data: { id: number; name: string; email: string }[] }).data : []
    staffList.value = list
  } catch {
    staffList.value = []
  } finally {
    staffLoading.value = false
  }
}

async function loadMarketing() {
  marketingLoading.value = true
  try {
    const { data } = await api.get<{ data?: { id: string; name: string; email: string }[] }>('/admin/marketing-staff')
    const list = Array.isArray((data as { data?: unknown[] })?.data) ? (data as { data: { id: string; name: string; email: string }[] }).data : []
    marketingList.value = list.map(m => ({ ...m, id: String(m.id) }))
  } catch {
    marketingList.value = []
  } finally {
    marketingLoading.value = false
  }
}

function openRecipientModal() {
  recipientModalOpen.value = true
  if (recipientType.value === 'specific') {
    loadStaff()
    loadMarketing()
  }
}

watch(recipientType, (t) => {
  if (t === 'specific' && recipientModalOpen.value) {
    loadStaff()
    loadMarketing()
  }
  if (t !== 'specific') selectedPeople.value = []
})

// Sent list
export interface SentAnnouncement {
  id: string
  subject: string
  snippet: string
  sent_at: string
  recipient_tag: string
}
const sentList = ref<SentAnnouncement[]>([])

async function loadSent() {
  sentLoading.value = true
  try {
    const { data } = await api.get<{ data?: SentAnnouncement[] }>('/announcements')
    const list = Array.isArray((data as { data?: unknown[] })?.data) ? (data as { data: SentAnnouncement[] }).data : []
    sentList.value = list
  } catch {
    sentList.value = []
  } finally {
    sentLoading.value = false
  }
}
watch(activeTab, (tab) => { if (tab === 'sent') loadSent() }, { immediate: true })

function formatSentDate(iso: string) {
  try {
    const d = new Date(iso)
    return format(d, 'MMM d, yyyy · h:mm a')
  } catch {
    return iso
  }
}

function tagColor(tag: string): string {
  if (/clients only|renter/i.test(tag)) return 'primary'
  if (/staff|car owner/i.test(tag)) return 'info'
  if (/specific|person|selected/i.test(tag)) return 'secondary'
  return 'default'
}

function resetForm() {
  subject.value = ''
  message.value = ''
  sendToDashboard.value = true
  sendToEmail.value = true
  recipientType.value = 'all'
  selectedPeople.value = []
  formRef.value?.validate?.()
}

function buildRecipientTag(): string {
  if (recipientType.value === 'all') return 'Everyone'
  if (recipientType.value === 'clients_only') return 'Renters only'
  if (recipientType.value === 'staff_only') return 'Car rental owners only'
  if (recipientType.value === 'specific') {
    const n = selectedPeople.value.length
    return n ? `${n} person(s)` : 'Specific people'
  }
  return 'Everyone'
}

function buildPayload() {
  const payload: Record<string, unknown> = {
    subject: subject.value.trim(),
    message: message.value.trim(),
    send_to_dashboard: sendToDashboard.value,
    send_to_email: sendToEmail.value,
    recipient_type: recipientType.value === 'specific' && selectedPeople.value.length
      ? 'specific'
      : recipientType.value,
  }
  if (recipientType.value === 'specific' && selectedPeople.value.length) {
    payload.client_ids = selectedPeople.value.filter(p => p.role === 'client').map(p => p.id)
    payload.staff_ids = selectedPeople.value.filter(p => p.role === 'staff').map(p => p.id)
    payload.marketing_ids = selectedPeople.value.filter(p => p.role === 'marketing').map(p => p.id)
  }
  return payload
}

async function sendAnnouncement() {
  const valid = await formRef.value?.validate?.().then(r => r.valid) ?? true
  if (!valid) return
  if (!subject.value?.trim() || !message.value?.trim()) {
    useToastStore().warning('Please fill in subject and message.')
    return
  }
  if (!sendToDashboard.value && !sendToEmail.value) {
    useToastStore().warning('Choose at least one: Show on dashboards or Send by email.')
    return
  }
  if (recipientType.value === 'specific' && !selectedPeople.value.length) {
    useToastStore().warning('Please select at least one recipient, or choose another audience.')
    return
  }

  sending.value = true
  try {
    await api.post('/announcements/send', buildPayload())
    useToastStore().success('Announcement sent successfully.')
    resetForm()
    loadSent()
    activeTab.value = 'sent'
    recipientModalOpen.value = false
  } catch (err: unknown) {
    const res = err as { response?: { status?: number; data?: { message?: string } } }
    if (res?.response?.status === 404) {
      useToastStore().info('Send endpoint can be wired when backend is ready. Announcement saved locally for demo.')
      const tag = buildRecipientTag()
      sentList.value = [
        {
          id: String(Date.now()),
          subject: subject.value.trim(),
          snippet: message.value.trim().slice(0, 80) + (message.value.trim().length > 80 ? '…' : ''),
          sent_at: new Date().toISOString(),
          recipient_tag: tag,
        },
        ...sentList.value,
      ]
      resetForm()
      activeTab.value = 'sent'
      recipientModalOpen.value = false
    } else {
      useToastStore().error(res?.response?.data?.message || 'Failed to send. Please try again.')
    }
  } finally {
    sending.value = false
  }
}
</script>

<style scoped>
.announcements-tabs :deep(.v-tab) {
  text-transform: none;
  font-weight: 600;
  letter-spacing: 0.02em;
}

.announcements-compose-card {
  border: 1px solid rgba(30, 58, 95, 0.1);
}

.announcements-header-icon {
  background: linear-gradient(135deg, rgba(30, 58, 95, 0.12) 0%, rgba(30, 58, 95, 0.06) 100%);
}

.announcements-channels .channels-row {
  display: grid;
  grid-template-columns: repeat(auto-fill, minmax(220px, 1fr));
  gap: 1rem;
}

.channel-card {
  cursor: pointer;
  transition: border-color 0.2s ease, background 0.2s ease;
}

.channel-card:hover {
  border-color: rgba(var(--v-theme-primary), 0.5);
  background: rgba(var(--v-theme-primary), 0.04);
}

.channel-card--active {
  border-color: rgb(var(--v-theme-primary));
  background: rgba(var(--v-theme-primary), 0.08);
}

.channel-card__inner {
  gap: 1.25rem;
}

.channel-card__content {
  flex: 1;
  min-width: 0;
  display: flex;
  flex-direction: column;
  gap: 0.25rem;
}

.channel-card__icon {
  opacity: 0.85;
  align-self: flex-start;
}

.announcements-form-actions {
  display: flex;
  justify-content: flex-end;
  flex-wrap: wrap;
  gap: 1rem;
}

.announcements-send-btn :deep(.v-btn__prepend) {
  margin-inline-end: 0.5rem;
}

.announcements-recipients .recipients-summary {
  cursor: pointer;
  border: 1px solid rgba(30, 58, 95, 0.2);
  border-radius: 12px;
  padding: 0.75rem 1rem;
  background: var(--surface-1, #fff);
  transition: border-color 0.2s ease, background 0.2s ease;
}

.recipients-summary:hover {
  border-color: rgb(var(--v-theme-primary));
  background: rgba(var(--v-theme-primary), 0.04);
}

.recipients-summary__inner {
  display: flex;
  align-items: center;
  gap: 0.5rem;
}

.recipients-summary__icon {
  color: var(--text-secondary);
  flex-shrink: 0;
}

.recipients-summary__text {
  flex: 1;
  font-weight: 500;
  color: var(--text-primary);
}

.recipients-summary__chevron {
  color: var(--text-muted);
  flex-shrink: 0;
}

.recipient-type-group {
  gap: 0.25rem;
}

.recipient-radio :deep(.v-label) {
  opacity: 1;
}

.recipient-list {
  min-height: 120px;
}

.recipient-list__scroll {
  max-height: 280px;
  overflow-y: auto;
  border: 1px solid rgba(30, 58, 95, 0.1);
  border-radius: 12px;
  padding: 4px;
}

.recipient-list-item {
  display: flex;
  align-items: center;
  gap: 0.75rem;
  padding: 0.5rem 0.75rem;
  border-radius: 8px;
  cursor: pointer;
  transition: background 0.15s ease;
}

.recipient-list-item:hover {
  background: rgba(30, 58, 95, 0.06);
}

.recipient-list-item--selected {
  background: rgba(var(--v-theme-primary), 0.1);
}

.recipient-list-item__content {
  flex: 1;
  min-width: 0;
  display: flex;
  flex-direction: column;
  gap: 2px;
}

.recipient-list-item__name {
  font-weight: 600;
  font-size: 0.875rem;
  color: var(--text-primary);
}

.recipient-list-item__meta {
  font-size: 0.75rem;
  color: var(--text-secondary);
  white-space: nowrap;
  overflow: hidden;
  text-overflow: ellipsis;
}

.recipient-list-item__role {
  flex-shrink: 0;
}

/* Sent list */
.sent-empty {
  text-align: center;
  padding: 3rem 1rem;
}

.sent-empty__icon {
  color: var(--text-muted);
  opacity: 0.6;
  margin-bottom: 1rem;
}

.sent-list {
  display: flex;
  flex-direction: column;
  gap: 0.75rem;
}

.sent-item {
  border: 1px solid rgba(30, 58, 95, 0.1);
  transition: border-color 0.2s ease;
}

.sent-item:hover {
  border-color: rgba(30, 58, 95, 0.2);
}

.sent-item__row {
  display: flex;
  align-items: flex-start;
  justify-content: space-between;
  gap: 1rem;
}

.sent-item__main {
  flex: 1;
  min-width: 0;
}

.sent-item__subject {
  font-size: 1rem;
  font-weight: 600;
  color: var(--text-primary);
  margin: 0 0 4px 0;
}

.sent-item__snippet {
  font-size: 0.875rem;
  color: var(--text-secondary);
  line-height: 1.45;
  margin: 0 0 4px 0;
}

.sent-item__meta {
  font-size: 0.75rem;
  color: var(--text-muted);
}

.sent-item__tag {
  flex-shrink: 0;
  font-weight: 600;
  font-size: 0.6875rem;
  letter-spacing: 0.03em;
}
</style>
