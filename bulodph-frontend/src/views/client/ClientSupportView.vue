<template>
  <DashboardTemplate title="Contact support" subtitle="Get in touch with BulodPH." :animate="true">
    <!-- Contact us -->
    <v-card elevation="0" rounded="lg" class="support-section modern-card mb-4">
      <div class="support-section__accent" />
      <div class="support-section__header">
        <div class="support-section__icon">
          <v-icon icon="mdi-headset" size="22" />
        </div>
        <span class="support-section__title">Contact us</span>
      </div>
      <v-divider class="mx-4" />
      <v-card-text class="pa-4">
        <p class="text-body-2 text-medium-emphasis mb-4">For booking issues, payments, or general questions, reach out using one of the options below.</p>
        <div class="support-contact-list">
          <a href="mailto:support@bulodph.com" target="_blank" rel="noopener" class="support-contact-item">
            <v-icon color="primary" size="22">mdi-email-outline</v-icon>
            <div>
              <span class="support-contact-item__title">Email</span>
              <span class="support-contact-item__sub">support@bulodph.com</span>
            </div>
          </a>
          <a href="tel:+639171234567" class="support-contact-item">
            <v-icon color="primary" size="22">mdi-phone-outline</v-icon>
            <div>
              <span class="support-contact-item__title">Phone</span>
              <span class="support-contact-item__sub">+63 917 123 4567</span>
            </div>
          </a>
          <div class="support-contact-item support-contact-item--static">
            <v-icon color="primary" size="22">mdi-clock-outline</v-icon>
            <div>
              <span class="support-contact-item__title">Hours</span>
              <span class="support-contact-item__sub">Mon–Fri 9:00 AM – 6:00 PM (PHT)</span>
            </div>
          </div>
        </div>
      </v-card-text>
    </v-card>

    <div class="support-content">
      <!-- Send a message -->
      <v-card elevation="0" rounded="lg" class="support-section modern-card">
        <div class="support-section__accent support-section__accent--form" />
        <div class="support-section__header">
          <div class="support-section__icon support-section__icon--form">
            <v-icon icon="mdi-message-text-outline" size="22" />
          </div>
          <span class="support-section__title">Send a message</span>
        </div>
        <v-divider class="mx-4" />
        <v-card-text class="pa-4">
          <v-form @submit.prevent="sendMessage">
            <v-text-field
              v-model="form.subject"
              label="Subject (optional)"
              placeholder="e.g. Booking #1234 question"
              variant="outlined"
              density="comfortable"
              hide-details
              class="mb-3"
              rounded="lg"
            />
            <v-textarea
              v-model="form.message"
              label="Message *"
              placeholder="Describe your issue or question..."
              variant="outlined"
              rows="4"
              hide-details
              class="mb-3"
              rounded="lg"
              :error-messages="errors.message"
            />
            <v-btn type="submit" color="primary" rounded="lg" :loading="sending">Send message</v-btn>
          </v-form>
        </v-card-text>
      </v-card>

      <!-- Your tickets -->
      <v-card elevation="0" rounded="lg" class="support-section modern-card">
        <div class="support-section__accent support-section__accent--tickets" />
        <div class="support-section__header">
          <div class="support-section__icon support-section__icon--tickets">
            <v-icon icon="mdi-ticket-confirmation-outline" size="22" />
          </div>
          <span class="support-section__title">Your tickets</span>
        </div>
        <v-divider class="mx-4" />
        <v-card-text class="pa-4">
          <template v-if="loadingTickets">
            <div class="support-loading">
              <v-progress-circular indeterminate color="primary" size="28" class="me-2" />
              <span class="text-body-2 text-medium-emphasis">Loading…</span>
            </div>
          </template>
          <template v-else-if="tickets.length">
            <div class="support-ticket-list">
              <div v-for="t in tickets" :key="t.id" class="support-ticket-item">
                <div class="support-ticket-item__main">
                  <span class="support-ticket-item__subject">{{ t.subject || 'No subject' }}</span>
                  <span class="support-ticket-item__preview">{{ (t.message || '').slice(0, 60) }}{{ (t.message?.length ?? 0) > 60 ? '…' : '' }}</span>
                </div>
                <v-chip :color="t.status === 'closed' ? 'default' : 'primary'" :prepend-icon="t.status === 'closed' ? 'mdi-check-circle' : 'mdi-ticket-confirmation-outline'" size="small" variant="tonal" density="compact">{{ t.status }}</v-chip>
              </div>
            </div>
          </template>
          <HpaEmptyState
            v-else
            title="No tickets yet"
            description="Send a message above and we'll get back to you within 1–2 business days."
            icon="mdi-ticket-outline"
          />
        </v-card-text>
      </v-card>
    </div>
  </DashboardTemplate>
</template>

<script setup lang="ts">
import { ref, onMounted } from 'vue'
import DashboardTemplate from '@/components/DashboardTemplate.vue'
import HpaEmptyState from '@/components/base/HpaEmptyState.vue'
import { useToastStore } from '@/stores/toast'
import * as supportApi from '@/services/support'
import type { SupportTicketRecord } from '@/services/support'

const toast = useToastStore()
const sending = ref(false)
const loadingTickets = ref(true)
const tickets = ref<SupportTicketRecord[]>([])
const form = ref({ subject: '', message: '' })
const errors = ref<{ message?: string }>({})

async function loadTickets() {
  loadingTickets.value = true
  try {
    tickets.value = await supportApi.getSupportTickets()
  } catch {
    tickets.value = []
  } finally {
    loadingTickets.value = false
  }
}

function sendMessage() {
  errors.value = {}
  if (!form.value.message.trim()) {
    errors.value.message = 'Message is required.'
    toast.warning('Please enter a message.')
    return
  }
  sending.value = true
  supportApi
    .createSupportTicket({
      subject: form.value.subject.trim() || undefined,
      message: form.value.message.trim(),
    })
    .then(() => {
      toast.success("Message sent. We'll get back to you within 1–2 business days.")
      form.value = { subject: '', message: '' }
      return loadTickets()
    })
    .catch((e) => {
      toast.error(e instanceof Error ? e.message : 'Failed to send message.')
    })
    .finally(() => {
      sending.value = false
    })
}

onMounted(() => loadTickets())
</script>

<style scoped>
.support-section {
  position: relative;
  overflow: hidden;
  border: 1px solid rgba(var(--v-border-color), var(--v-border-opacity));
}

.support-section__accent {
  position: absolute;
  top: 0;
  left: 0;
  width: 4px;
  height: 100%;
  background: rgb(var(--v-theme-primary));
  border-radius: 4px 0 0 4px;
}

.support-section__accent--form {
  background: linear-gradient(to bottom, rgb(var(--v-theme-primary)), rgba(var(--v-theme-primary), 0.5));
}

.support-section__accent--tickets {
  background: linear-gradient(to bottom, rgb(76, 175, 80), rgba(76, 175, 80, 0.5));
}

.support-section__header {
  display: flex;
  align-items: center;
  gap: 0.75rem;
  padding: 1rem 1rem 0.5rem;
}

.support-section__icon {
  width: 40px;
  height: 40px;
  border-radius: 10px;
  background: rgba(var(--v-theme-primary), 0.1);
  color: rgb(var(--v-theme-primary));
  display: flex;
  align-items: center;
  justify-content: center;
}

.support-section__icon--form {
  background: rgba(var(--v-theme-primary), 0.12);
}

.support-section__icon--tickets {
  background: rgba(76, 175, 80, 0.12);
  color: rgb(76, 175, 80);
}

.support-section__title {
  font-size: 1rem;
  font-weight: 700;
  color: rgb(var(--v-theme-on-surface));
}

.support-contact-list {
  display: flex;
  flex-direction: column;
  gap: 0.25rem;
}

.support-contact-item {
  display: flex;
  align-items: center;
  gap: 0.75rem;
  padding: 0.75rem;
  border-radius: 10px;
  text-decoration: none;
  color: inherit;
  transition: background 0.2s ease;
}

a.support-contact-item:hover {
  background: rgba(var(--v-theme-primary), 0.06);
}

.support-contact-item--static {
  cursor: default;
}

.support-contact-item__title {
  display: block;
  font-size: 0.9375rem;
  font-weight: 600;
  color: rgb(var(--v-theme-on-surface));
}

.support-contact-item__sub {
  display: block;
  font-size: 0.8125rem;
  color: rgba(var(--v-theme-on-surface), 0.7);
}

.support-content {
  display: grid;
  grid-template-columns: 1fr;
  gap: 1.25rem;
}

@media (min-width: 960px) {
  .support-content {
    grid-template-columns: 1fr 1fr;
  }
}

.support-loading {
  display: flex;
  align-items: center;
  min-height: 80px;
}

.support-ticket-list {
  display: flex;
  flex-direction: column;
  gap: 0.5rem;
}

.support-ticket-item {
  display: flex;
  align-items: center;
  gap: 0.75rem;
  padding: 0.625rem 0.75rem;
  border-radius: 10px;
  border: 1px solid rgba(var(--v-border-color), var(--v-border-opacity));
  background: rgba(0, 0, 0, 0.02);
}

.support-ticket-item__main {
  flex: 1;
  min-width: 0;
}

.support-ticket-item__subject {
  display: block;
  font-size: 0.875rem;
  font-weight: 600;
  color: rgb(var(--v-theme-on-surface));
}

.support-ticket-item__preview {
  display: block;
  font-size: 0.8125rem;
  color: rgba(var(--v-theme-on-surface), 0.7);
  margin-top: 2px;
}
</style>
