<template>
  <DashboardTemplate title="Messages" subtitle="Chat with your rental partner for each booking.">
    <v-row>
      <v-col cols="12" md="4">
        <v-card class="modern-card h-100" elevation="0" rounded="lg">
          <div class="section-card-header">
            <span class="section-card-title">Conversations</span>
          </div>
          <v-divider class="dashboard-divider" />
          <v-card-text class="pa-4">
            <p v-if="loadingThreads" class="text-body-2 text-medium-emphasis mb-0">Loading…</p>
            <template v-else-if="threads.length">
              <v-list class="pa-0">
                <v-list-item
                  v-for="t in threads"
                  :key="t.id"
                  :to="threadTo(t.id)"
                  :active="selectedThreadId === t.id"
                  class="px-0"
                  rounded="lg"
                >
                  <template #prepend>
                    <v-icon>mdi-message-text-outline</v-icon>
                  </template>
                  <v-list-item-title class="text-body-2">
                    {{ t.booking_reference ? `Booking ${t.booking_reference}` : 'Conversation' }}
                  </v-list-item-title>
                  <v-list-item-subtitle class="text-body-2">{{ t.status }}</v-list-item-subtitle>
                </v-list-item>
              </v-list>
            </template>
            <p v-else class="text-body-2 text-medium-emphasis mb-0">No conversations yet. Start one from a booking (Message rental).</p>
          </v-card-text>
        </v-card>
      </v-col>
      <v-col cols="12" md="8">
        <v-card class="modern-card h-100" elevation="0" rounded="lg">
          <div class="section-card-header">
            <span class="section-card-title">Chat</span>
          </div>
          <v-divider class="dashboard-divider" />
          <v-card-text class="pa-4">
            <template v-if="selectedThread">
              <p v-if="loadingMessages" class="text-body-2 text-medium-emphasis mb-3">Loading messages…</p>
              <div v-else-if="selectedThread.messages?.length" class="messages-list mb-4">
                <div
                  v-for="m in selectedThread.messages"
                  :key="m.id"
                  class="message-bubble mb-2 pa-3 rounded-lg"
                  :class="m.sender_id === currentUserId ? 'message-bubble--own' : 'message-bubble--other'"
                >
                  <p class="text-body-2 mb-0">{{ m.body || '(attachment)' }}</p>
                  <p class="text-caption text-medium-emphasis mb-0 mt-1">{{ formatDate(m.created_at) }}</p>
                </div>
              </div>
              <p v-else class="text-body-2 text-medium-emphasis mb-4">No messages yet. Send one below.</p>
              <v-form @submit.prevent="handleSubmit">
                <v-textarea
                  v-model="message"
                  label="Type a message"
                  rows="3"
                  variant="outlined"
                  class="mt-2"
                  :error-messages="errors.message"
                  placeholder="Type your message…"
                />
                <v-file-input
                  v-model="attachment"
                  label="Attach image (optional)"
                  variant="outlined"
                  density="compact"
                  class="mt-2"
                  accept="image/*"
                  :error-messages="errors.attachment"
                  hide-details
                />
                <v-btn
                  color="primary"
                  variant="flat"
                  class="mt-3"
                  rounded="lg"
                  type="submit"
                  :disabled="isSubmitting || !canSubmit"
                  :loading="isSubmitting"
                >
                  Send
                </v-btn>
              </v-form>
            </template>
            <p v-else class="text-body-2 text-medium-emphasis mb-0">Select a conversation to view and send messages.</p>
          </v-card-text>
        </v-card>
      </v-col>
    </v-row>
  </DashboardTemplate>
</template>

<script setup lang="ts">
import { computed, ref, onMounted, watch } from 'vue'
import { useRoute, useRouter } from 'vue-router'
import DashboardTemplate from '@/components/DashboardTemplate.vue'
import { useToastStore } from '@/stores/toast'
import { useUserSessionStore } from '@/stores/userSession'
import * as messagesApi from '@/services/messages'
import type { MessageThreadRecord } from '@/services/messages'
import { hasInjectionRisk, isSafeText, sanitizeBasicText, validateFiles } from '@/utils/inputValidation'

const route = useRoute()
const router = useRouter()
const toast = useToastStore()
const userSession = useUserSessionStore()
const threads = ref<MessageThreadRecord[]>([])
const selectedThread = ref<MessageThreadRecord | null>(null)
const loadingThreads = ref(true)
const loadingMessages = ref(false)
const message = ref('')
const attachment = ref<File[] | File | null>(null)
const isSubmitting = ref(false)
const errors = ref<{ message?: string; attachment?: string }>({})

const currentUserId = computed(() => userSession.user?.id ?? '')
const selectedThreadId = computed(() => route.query.threadId as string | undefined)

function threadTo(threadId: string) {
  return { name: route.path.startsWith('/car-owner') ? 'car-owner-messages' : 'client-messages', query: { threadId } }
}

function formatDate(s: string | undefined): string {
  if (!s) return ''
  try {
    const d = new Date(s)
    return d.toLocaleString(undefined, { dateStyle: 'short', timeStyle: 'short' })
  } catch {
    return s
  }
}

const canSubmit = computed(() => message.value.trim().length > 0)

async function loadThreads() {
  loadingThreads.value = true
  try {
    threads.value = await messagesApi.getThreads()
  } catch {
    threads.value = []
  } finally {
    loadingThreads.value = false
  }
}

async function loadThread(threadId: string) {
  if (!threadId) {
    selectedThread.value = null
    return
  }
  loadingMessages.value = true
  try {
    selectedThread.value = await messagesApi.getThreadById(threadId)
  } catch {
    selectedThread.value = null
  } finally {
    loadingMessages.value = false
  }
}

onMounted(async () => {
  await loadThreads()
  const tid = route.query.threadId as string | undefined
  if (tid) await loadThread(tid)
})
watch(selectedThreadId, (tid) => {
  if (tid) loadThread(tid)
  else selectedThread.value = null
})

async function handleSubmit() {
  errors.value = {}
  message.value = sanitizeBasicText(message.value)

  if (!message.value.trim()) {
    errors.value.message = 'Message is required'
  } else if (!isSafeText(message.value) || hasInjectionRisk(message.value)) {
    errors.value.message = 'Message contains unsafe characters'
  }

  const file = Array.isArray(attachment.value) ? attachment.value[0] : attachment.value
  const fileError = validateFiles(file, {
    required: false,
    maxSizeMb: 5,
    allowedTypes: ['image/png', 'image/jpeg', 'image/webp'],
    label: 'Attachment',
  })
  if (fileError) errors.value.attachment = fileError

  if (Object.keys(errors.value).length) return
  if (!selectedThread.value) return

  isSubmitting.value = true
  try {
    await messagesApi.sendMessage(
      selectedThread.value.id,
      message.value,
      file as File | undefined
    )
    toast.success('Message sent.')
    message.value = ''
    attachment.value = null
    await loadThread(selectedThread.value.id)
  } catch (e) {
    toast.error(e instanceof Error ? e.message : 'Could not send message.')
  } finally {
    isSubmitting.value = false
  }
}
</script>

<style scoped>
.messages-list {
  max-height: 320px;
  overflow-y: auto;
}
.message-bubble--own {
  background: rgba(var(--v-theme-primary), 0.12);
  margin-left: 2rem;
}
.message-bubble--other {
  background: var(--v-theme-surface-variant);
  margin-right: 2rem;
}
</style>
