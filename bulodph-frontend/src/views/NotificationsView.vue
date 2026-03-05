<template>
  <DashboardTemplate title="Notifications" subtitle="Booking and account updates." :animate="true">
    <v-card elevation="0" rounded="lg" class="notifications-section modern-card">
      <div class="notifications-section__accent" />
      <div class="notifications-section__header">
        <div class="notifications-section__icon">
          <v-icon icon="mdi-bell-outline" size="22" />
        </div>
        <span class="notifications-section__title">Updates</span>
        <v-spacer />
        <v-btn v-if="hasUnread" variant="tonal" size="small" color="primary" @click="notificationsStore.markAllRead">Mark all read</v-btn>
      </div>
      <v-divider class="mx-4" />
      <v-card-text class="pa-4">
        <template v-if="groupedNotifications.length">
          <div v-for="group in groupedNotifications" :key="group.type" class="notifications-group mb-4" v-auto-animate>
            <div class="notifications-group__header">
              <v-icon size="18" class="notifications-group__icon">mdi-folder-outline</v-icon>
              <span class="notifications-group__label">{{ group.typeLabel }}</span>
            </div>
            <div class="notifications-group__list">
              <div
                v-for="n in group.items"
                :key="n.id"
                class="notification-card"
                :class="{ 'notification-card--clickable': n.actionTo }"
                @click="n.actionTo && $router.push(n.actionTo)"
              >
                <v-icon :icon="n.icon" :color="n.read ? undefined : 'primary'" size="22" class="notification-card__icon" />
                <div class="notification-card__body">
                  <div class="notification-card__title" :class="{ 'text-medium-emphasis': n.read }">{{ n.title }}</div>
                  <div class="notification-card__message">{{ n.message }}</div>
                  <div class="notification-card__time">{{ n.time }}</div>
                </div>
                <v-btn v-if="!n.read" variant="text" size="small" density="compact" @click.stop="notificationsStore.markRead(n.id)">Mark read</v-btn>
              </div>
            </div>
          </div>
        </template>
        <HpaEmptyState v-else title="No notifications yet" description="Booking and account updates will appear here." icon="mdi-bell-outline" />
      </v-card-text>
    </v-card>
  </DashboardTemplate>
</template>

<script setup lang="ts">
import { computed } from 'vue'
import { storeToRefs } from 'pinia'
import DashboardTemplate from '@/components/DashboardTemplate.vue'
import HpaEmptyState from '@/components/base/HpaEmptyState.vue'
import { useNotificationsStore } from '@/stores/notifications'
import { type NotificationType } from '@/constants/notificationsSeed'

const notificationsStore = useNotificationsStore()
const { items: notifications } = storeToRefs(notificationsStore)

const TYPE_LABELS: Record<NotificationType, string> = {
  bookings: 'Bookings',
  payments: 'Payments',
  promos: 'Promos',
  other: 'Other',
}

const hasUnread = computed(() => notifications.value.some(n => !n.read))

const groupedNotifications = computed(() => {
  const typeOrder: NotificationType[] = ['bookings', 'payments', 'promos', 'other']
  const byType: Record<NotificationType, NotificationSeedItem[]> = {
    bookings: [],
    payments: [],
    promos: [],
    other: [],
  }
  notifications.value.forEach(n => {
    const t = n.type ?? 'other'
    if (!byType[t]) byType[t] = []
    byType[t].push(n)
  })
  return typeOrder
    .filter(t => byType[t].length > 0)
    .map(type => ({
      type,
      typeLabel: TYPE_LABELS[type],
      items: byType[type],
    }))
})

function markRead(id: string) {
  notificationsStore.markRead(id)
}

function markAllRead() {
  notificationsStore.markAllRead()
}
</script>

<style scoped>
.notifications-section {
  position: relative;
  overflow: hidden;
  border: 1px solid rgba(var(--v-border-color), var(--v-border-opacity));
}

.notifications-section__accent {
  position: absolute;
  top: 0;
  left: 0;
  width: 4px;
  height: 100%;
  background: rgb(var(--v-theme-primary));
  border-radius: 4px 0 0 4px;
}

.notifications-section__header {
  display: flex;
  align-items: center;
  gap: 0.75rem;
  padding: 1rem 1rem 0.5rem;
}

.notifications-section__icon {
  width: 40px;
  height: 40px;
  border-radius: 10px;
  background: rgba(var(--v-theme-primary), 0.1);
  color: rgb(var(--v-theme-primary));
  display: flex;
  align-items: center;
  justify-content: center;
}

.notifications-section__title {
  font-size: 1rem;
  font-weight: 700;
  color: rgb(var(--v-theme-on-surface));
}

.notifications-group__header {
  display: flex;
  align-items: center;
  gap: 0.5rem;
  margin-bottom: 0.5rem;
}

.notifications-group__icon {
  color: rgba(var(--v-theme-on-surface), 0.6);
}

.notifications-group__label {
  font-size: 0.875rem;
  font-weight: 700;
  color: rgba(var(--v-theme-on-surface), 0.8);
}

.notifications-group__list {
  display: flex;
  flex-direction: column;
  gap: 0.5rem;
}

.notification-card {
  display: flex;
  align-items: flex-start;
  gap: 0.75rem;
  padding: 0.75rem;
  border-radius: 10px;
  border: 1px solid rgba(var(--v-border-color), var(--v-border-opacity));
  background: rgba(0, 0, 0, 0.02);
}

.notification-card--clickable {
  cursor: pointer;
  transition: background 0.2s ease;
}

.notification-card--clickable:hover {
  background: rgba(var(--v-theme-primary), 0.06);
}

.notification-card__icon {
  flex-shrink: 0;
}

.notification-card__body {
  flex: 1;
  min-width: 0;
}

.notification-card__title {
  font-size: 0.9375rem;
  font-weight: 600;
  color: rgb(var(--v-theme-on-surface));
}

.notification-card__message {
  font-size: 0.8125rem;
  color: rgba(var(--v-theme-on-surface), 0.7);
  margin-top: 2px;
}

.notification-card__time {
  font-size: 0.75rem;
  color: rgba(var(--v-theme-on-surface), 0.55);
  margin-top: 4px;
}
</style>
