<template>
  <HpaModal
    :model-value="show"
    :title="unseen.length > 1 ? 'New bookings' : 'New booking'"
    icon="mdi-bell-ring"
    max-width="480"
    persistent
    :show-actions="true"
    @update:model-value="show = $event"
  >
    <p class="text-body-2 text-medium-emphasis mb-4">
      {{ unseen.length > 1
        ? `You have ${unseen.length} new booking${unseen.length > 1 ? 's' : ''} (approved or paid). Review details below.`
        : 'You have a new booking (approved or paid). Review details below.' }}
    </p>
    <div v-for="b in unseen.slice(0, 3)" :key="b.id" class="unseen-preview-card mb-3">
      <div class="unseen-preview-card__row d-flex align-start">
        <v-img
          v-if="b.vehicleImage"
          :src="resolveImageUrl(b.vehicleImage) ?? b.vehicleImage"
          width="72"
          height="48"
          cover
          rounded="md"
          class="flex-shrink-0 unseen-preview-card__thumb"
        />
        <v-sheet v-else width="72" height="48" rounded="md" color="surface-variant" class="flex-shrink-0 d-flex align-center justify-center unseen-preview-card__thumb">
          <v-icon>mdi-car-side</v-icon>
        </v-sheet>
        <div class="flex-grow-1 min-w-0 unseen-preview-card__info">
          <div class="font-weight-medium text-body-2">{{ b.vehicleName }}</div>
          <div class="text-caption text-medium-emphasis">{{ b.renterName }} · {{ b.start }} – {{ b.end }}</div>
          <v-chip :color="b.status === 'Confirmed' ? 'success' : 'primary'" :prepend-icon="b.status === 'Confirmed' ? 'mdi-check-circle' : 'mdi-clock-outline'" size="x-small" variant="tonal" class="mt-1">{{ b.status }}</v-chip>
        </div>
      </div>
    </div>
    <p v-if="unseen.length > 3" class="text-caption text-medium-emphasis mb-3">+ {{ unseen.length - 3 }} more</p>
    <template #actions>
      <v-spacer />
      <v-btn variant="text" rounded="lg" density="compact" @click="dismiss">Close</v-btn>
      <v-btn color="primary" rounded="lg" density="compact" :to="{ name: 'car-owner-bookings' }" @click="goToBookings">
        Go to Bookings
      </v-btn>
    </template>
  </HpaModal>
</template>

<script setup lang="ts">
import { ref, onMounted } from 'vue'
import HpaModal from '@/components/base/HpaModal.vue'
import { getCarOwnerUnseenBookings, markCarOwnerBookingsSeen } from '@/services/bookings'
import type { CarOwnerBookingItem } from '@/services/bookings'
import { resolveImageUrl } from '@/constants/images'

const show = ref(false)
const unseen = ref<CarOwnerBookingItem[]>([])
const loading = ref(false)

async function loadUnseen() {
  if (loading.value) return
  loading.value = true
  try {
    const data = await getCarOwnerUnseenBookings()
    unseen.value = data ?? []
    if (unseen.value.length > 0) show.value = true
  } catch {
    unseen.value = []
  } finally {
    loading.value = false
  }
}

function dismiss() {
  markSeenAndClose()
}

function goToBookings() {
  markSeenAndClose()
}

async function markSeenAndClose() {
  const ids = unseen.value.map(b => b.id)
  if (ids.length > 0) {
    try {
      await markCarOwnerBookingsSeen(ids)
    } catch {
      /* ignore */
    }
  }
  show.value = false
  unseen.value = []
}

onMounted(() => {
  loadUnseen()
})
</script>

<style scoped>
.unseen-preview-card {
  padding: 12px;
  background: rgb(var(--v-theme-surface-variant), 0.3);
  border-radius: 12px;
  border: 1px solid rgba(0, 0, 0, 0.06);
}
.unseen-preview-card__row {
  gap: 1rem;
}
.unseen-preview-card__info {
  margin-left: 12px;
}
</style>
