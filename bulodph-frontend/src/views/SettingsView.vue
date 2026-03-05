<template>
  <DashboardTemplate
    title="Settings"
    subtitle="Configure your account and preferences"
    :animate="true"
  >
    <v-row>
      <v-col cols="12" md="8">
        <!-- Profile -->
        <v-card elevation="0" rounded="lg" class="modern-card section-card-accent mb-4">
          <div class="section-card-header">
            <div class="section-card-icon">
              <v-icon icon="mdi-account" size="20" />
            </div>
            <span class="section-card-title">Profile</span>
          </div>
          <v-divider class="settings-divider" />
          <v-card-text class="pa-4">
            <v-row>
              <v-col cols="12" md="6">
                <v-text-field :model-value="displayName" @update:model-value="(v) => displayName = formatInput(v, 'letters')" label="Display name" variant="outlined" density="comfortable" hide-details />
              </v-col>
              <v-col cols="12" md="6">
                <v-text-field v-model="email" label="Email" type="email" variant="outlined" density="comfortable" hide-details />
              </v-col>
              <v-col cols="12">
                <v-btn color="primary" size="default" rounded="lg" prepend-icon="mdi-content-save" @click="saveProfile">Save changes</v-btn>
              </v-col>
            </v-row>
          </v-card-text>
        </v-card>

        <!-- Notifications -->
        <v-card elevation="0" rounded="lg" class="modern-card section-card-accent mb-4">
          <div class="section-card-header">
            <div class="section-card-icon">
              <v-icon icon="mdi-bell-outline" size="20" />
            </div>
            <span class="section-card-title">Notifications</span>
          </div>
          <v-divider class="settings-divider" />
          <v-card-text class="pa-4">
            <div class="d-flex align-center justify-space-between py-3">
              <div>
                <div class="text-body-2 font-weight-medium">Email notifications</div>
                <div class="text-caption text-medium-emphasis">Receive updates about shifts and clients</div>
              </div>
              <v-switch v-model="emailNotifications" color="primary" hide-details @update:model-value="saveNotificationPrefs" />
            </div>
            <v-divider />
            <div class="d-flex align-center justify-space-between py-3">
              <div>
                <div class="text-body-2 font-weight-medium">Push notifications</div>
                <div class="text-caption text-medium-emphasis">Browser alerts for urgent updates</div>
              </div>
              <v-switch v-model="pushNotifications" color="primary" hide-details @update:model-value="saveNotificationPrefs" />
            </div>
          </v-card-text>
        </v-card>
      </v-col>

      <v-col cols="12" md="4">
        <!-- Language -->
        <v-card elevation="0" rounded="lg" class="modern-card section-card-accent mb-4">
          <div class="section-card-header">
            <div class="section-card-icon">
              <v-icon icon="mdi-translate" size="20" />
            </div>
            <span class="section-card-title">Language</span>
          </div>
          <v-divider class="settings-divider" />
          <v-card-text class="pa-4">
            <v-select
              :model-value="localeStore.locale"
              @update:model-value="localeStore.setLocale"
              :items="languageOptions"
              item-title="title"
              item-value="value"
              label="Display language"
              variant="outlined"
              density="comfortable"
              hide-details
              rounded="lg"
            />
          </v-card-text>
        </v-card>

        <!-- Security -->
        <v-card elevation="0" rounded="lg" class="modern-card section-card-accent mb-4">
          <div class="section-card-header">
            <div class="section-card-icon">
              <v-icon icon="mdi-shield-check" size="20" />
            </div>
            <span class="section-card-title">Security</span>
          </div>
          <v-divider class="settings-divider" />
          <v-card-text class="pa-4">
            <v-btn variant="outlined" color="primary" block rounded="lg" class="mb-3" :to="{ name: 'profile', hash: '#change-password' }">
              <v-icon start>mdi-key</v-icon>
              Change password
            </v-btn>
            <v-btn variant="outlined" color="primary" block rounded="lg" @click="on2FAClick">
              <v-icon start>mdi-two-factor-authentication</v-icon>
              Two-factor authentication
            </v-btn>
          </v-card-text>
        </v-card>

        <!-- About -->
        <v-card elevation="0" rounded="lg" class="modern-card section-card-accent">
          <div class="section-card-header">
            <div class="section-card-icon">
              <v-icon icon="mdi-information-outline" size="20" />
            </div>
            <span class="section-card-title">About</span>
          </div>
          <v-divider class="settings-divider" />
          <v-card-text class="pa-4">
            <p class="text-body-2 text-medium-emphasis mb-2">BulodPH</p>
            <p class="text-caption text-medium-emphasis mb-0">Car rental marketplace. Version 1.0.0</p>
          </v-card-text>
        </v-card>
      </v-col>
    </v-row>
  </DashboardTemplate>
</template>

<script setup lang="ts">
import { ref, onMounted } from 'vue'
import DashboardTemplate from '@/components/DashboardTemplate.vue'
import { useLocaleStore } from '@/stores/locale'
import { useUserSessionStore } from '@/stores/userSession'
import { useToastStore } from '@/stores/toast'
import { updateProfile } from '@/services/profile'
import { formatInput } from '@/utils/inputFormatters'
import { getUserScopedItem, setUserScopedItem } from '@/utils/userScopedStorage'

const NOTIF_PREFS_KEY = 'bulodph_notification_prefs'

const localeStore = useLocaleStore()
const userSession = useUserSessionStore()
const toast = useToastStore()

const displayName = ref('')
const email = ref('')
const emailNotifications = ref(true)
const pushNotifications = ref(false)

function loadNotificationPrefs() {
  const stored = getUserScopedItem<{ email?: boolean; push?: boolean }>(NOTIF_PREFS_KEY)
  if (stored) {
    if (typeof stored.email === 'boolean') emailNotifications.value = stored.email
    if (typeof stored.push === 'boolean') pushNotifications.value = stored.push
  }
}

onMounted(() => {
  displayName.value = userSession.user?.name ?? ''
  email.value = userSession.user?.email ?? ''
  loadNotificationPrefs()
})

async function saveProfile() {
  if (!userSession.user) return
  const updated = await updateProfile({ name: displayName.value, email: email.value })
  if (updated) {
    userSession.updateUser(updated)
    toast.success('Profile saved.')
  } else {
    toast.error('Could not save profile. Please try again.')
  }
}

function saveNotificationPrefs() {
  setUserScopedItem(NOTIF_PREFS_KEY, {
    email: emailNotifications.value,
    push: pushNotifications.value,
  })
  toast.success('Notification preferences saved.')
}

function on2FAClick() {
  toast.info('Two-factor authentication – connect to backend when ready.')
}

const languageOptions = [
  { title: 'English', value: 'en' as const },
  { title: 'العربية', value: 'ar' as const },
]
</script>

<style scoped>
.settings-divider {
  border-color: rgba(30, 58, 95, 0.08);
}
</style>
