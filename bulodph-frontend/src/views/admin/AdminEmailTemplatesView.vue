<template>
  <DashboardTemplate title="Email Templates" subtitle="Manage email templates and content.">
    <!-- Test email (admin settings) -->
    <v-card class="modern-card section-card-accent mb-4" elevation="0" rounded="lg">
      <div class="section-card-header">
        <div class="section-card-icon"><v-icon icon="mdi-email-send" size="20" /></div>
        <span class="section-card-title">Test email</span>
      </div>
      <v-divider class="dashboard-divider" />
      <v-card-text class="pa-4">
        <p class="text-body-2 text-medium-emphasis mb-3">Send a test email to <strong>teofiloharry69@gmail.com</strong>. Gmail: enable 2-Step Verification, then create an <strong>App Password</strong> at <a href="https://myaccount.google.com/apppasswords" target="_blank" rel="noopener">myaccount.google.com/apppasswords</a> and set it as <code>MAIL_PASSWORD</code> in backend <code>.env</code>.</p>
        <v-btn color="primary" rounded="lg" prepend-icon="mdi-email-send-outline" :loading="sendingTest" @click="sendTestEmail">
          Send test email
        </v-btn>
      </v-card-text>
    </v-card>

    <v-card class="modern-card section-card-accent" elevation="0" rounded="lg">
      <div class="section-card-header">
        <div class="section-card-icon"><v-icon icon="mdi-email-edit" size="20" /></div>
        <span class="section-card-title">Templates</span>
        <v-spacer />
        <v-text-field v-model="search" prepend-inner-icon="mdi-magnify" placeholder="Search templates…" density="compact" variant="outlined" hide-details class="min-w-220 max-w-320" rounded="lg" />
      </div>
      <v-divider class="dashboard-divider" />
      <v-data-table v-model:model-value="selectedTemplates" :headers="headers" :items="filteredTemplates" :items-per-page="10" density="comfortable" class="elevation-0" :search="search" show-select item-value="id">
        <template #item.trigger="{ item }">
          <v-chip size="small" variant="tonal" color="primary" prepend-icon="mdi-email-outline">{{ item.trigger }}</v-chip>
        </template>
        <template #item.status="{ item }">
          <v-chip :color="item.status === 'Active' ? 'success' : 'default'" :prepend-icon="item.status === 'Active' ? 'mdi-check-circle' : 'mdi-pause-circle-outline'" size="small" variant="tonal">{{ item.status }}</v-chip>
        </template>
        <template #item.actions="{ item }">
          <v-btn size="x-small" variant="text" icon="mdi-pencil" @click="editTemplate(item)" />
          <v-btn size="x-small" variant="text" icon="mdi-eye" @click="previewTemplate(item)" />
        </template>
      </v-data-table>
    </v-card>

    <HpaModal
      v-model="previewDialog"
      :title="previewTemplateData?.name ?? 'Preview'"
      icon="mdi-email-outline"
      max-width="500"
      persistent
      :show-actions="true"
      confirm-text="Close"
      hide-cancel
      @confirm="previewDialog = false"
    >
      <template v-if="previewTemplateData" #default>
        <p class="text-caption text-medium-emphasis mb-1">Trigger</p>
        <v-chip size="small" variant="tonal" color="primary" prepend-icon="mdi-email-outline" class="mb-2">{{ previewTemplateData.trigger }}</v-chip>
        <p class="text-caption text-medium-emphasis mb-1 mt-3">Subject</p>
        <p class="text-body-2 font-weight-medium">{{ previewTemplateData.subject }}</p>
        <p class="text-caption text-medium-emphasis mb-1 mt-3">Body (preview)</p>
        <p class="text-body-2 text-medium-emphasis" v-text="previewGreeting"></p>
        <p class="text-body-2 text-medium-emphasis">This email is sent when: {{ previewTemplateData.trigger }}. Connect to template API for full HTML body.</p>
      </template>
    </HpaModal>
  </DashboardTemplate>
</template>

<script setup lang="ts">
import { ref, computed } from 'vue'
import DashboardTemplate from '@/components/DashboardTemplate.vue'
import HpaModal from '@/components/base/HpaModal.vue'
import { useToastStore } from '@/stores/toast'
import { sendTestEmail as sendTestEmailApi } from '@/services/adminEmail'

const toast = useToastStore()
const search = ref('')
const sendingTest = ref(false)

async function sendTestEmail() {
  sendingTest.value = true
  try {
    const res = await sendTestEmailApi()
    toast.success(res.message ?? 'Test email sent.')
  } catch (err: unknown) {
    const ax = err as { response?: { status?: number; data?: { message?: string } } }
    const msg = ax.response?.data?.message ?? 'Failed to send test email. Check Brevo config.'
    toast.error(msg)
  } finally {
    sendingTest.value = false
  }
}
/** Body preview line (literal placeholder; must not use {{ in template) */
const previewGreeting = 'Hello {{ name }},'
const previewDialog = ref(false)
const previewTemplateData = ref<EmailTemplate | null>(null)
const selectedTemplates = ref<(string | number)[]>([])

interface EmailTemplate { id: number; name: string; trigger: string; subject: string; lastEdited: string; status: string }

const headers = [
  { title: 'Template', key: 'name' },
  { title: 'Trigger', key: 'trigger', width: '160px' },
  { title: 'Subject', key: 'subject' },
  { title: 'Last edited', key: 'lastEdited', width: '130px' },
  { title: 'Status', key: 'status', width: '100px' },
  { title: '', key: 'actions', width: '100px', sortable: false },
]

const templates = ref<EmailTemplate[]>([
  { id: 1, name: 'Welcome email', trigger: 'Registration', subject: 'Welcome to BulodPH!', lastEdited: '2026-02-20', status: 'Active' },
  { id: 2, name: 'Booking confirmation', trigger: 'Booking created', subject: 'Your booking is confirmed', lastEdited: '2026-02-18', status: 'Active' },
  { id: 3, name: 'Password reset', trigger: 'Forgot password', subject: 'Reset your password', lastEdited: '2026-02-15', status: 'Active' },
  { id: 4, name: 'Booking reminder', trigger: '24h before pickup', subject: 'Reminder: your trip is tomorrow', lastEdited: '2026-02-10', status: 'Active' },
  { id: 5, name: 'Review request', trigger: 'Trip completed', subject: 'How was your trip?', lastEdited: '2026-02-08', status: 'Active' },
  { id: 6, name: 'Payout sent', trigger: 'Payout processed', subject: 'Your payout has been sent', lastEdited: '2026-02-05', status: 'Active' },
  { id: 7, name: 'Account deactivation', trigger: 'Admin action', subject: 'Your account has been deactivated', lastEdited: '2026-01-28', status: 'Inactive' },
])

const filteredTemplates = computed(() => templates.value)

function editTemplate(t: EmailTemplate) {
  toast.info(`Edit template: ${t.name}. Edit form will be available when template API is connected.`)
}
function previewTemplate(t: EmailTemplate) {
  previewTemplateData.value = t
  previewDialog.value = true
}
</script>
