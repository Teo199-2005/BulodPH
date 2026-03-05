<template>
  <v-card class="shift-card modern-card" :class="{ 'shadow-shift': shift.parent_shift_id }">
    <v-card-text>
      <div class="d-flex justify-space-between align-center mb-2">
        <div>
          <div class="text-h6">{{ shift.client.full_name }}</div>
          <div class="text-caption text-medium-emphasis">
            {{ formatTime(shift.scheduled_start) }} - {{ formatTime(shift.scheduled_end) }}
          </div>
        </div>
        <v-chip
          :color="getStatusColor(shift.status)"
          size="small"
          variant="flat"
        >
          {{ shift.status }}
        </v-chip>
      </div>

      <v-divider class="my-2" />

      <div class="text-body-2 mb-2">
        <v-icon size="small" class="mr-1">mdi-map-marker</v-icon>
        {{ shift.client.address_line_1 }}, {{ shift.client.suburb }}
      </div>

      <div v-if="shift.notes" class="text-body-2 text-medium-emphasis">
        <v-icon size="small" class="mr-1">mdi-note-text</v-icon>
        {{ shift.notes }}
      </div>
    </v-card-text>

    <v-card-actions>
      <v-btn
        v-if="shift.status === 'SCHEDULED' && canClockIn"
        color="primary"
        variant="flat"
        block
        :loading="isClockingIn"
        @click="handleClockIn"
      >
        <v-icon start>mdi-clock-check</v-icon>
        Clock In
      </v-btn>

      <v-btn
        v-else-if="shift.status === 'IN_PROGRESS'"
        color="success"
        variant="flat"
        block
        @click="handleClockOut"
      >
        <v-icon start>mdi-clock-end</v-icon>
        Clock Out
      </v-btn>

      <v-btn
        v-else
        variant="outlined"
        block
        @click="$emit('view-details', shift.id)"
      >
        View Details
      </v-btn>
    </v-card-actions>

    <v-alert
      v-if="distanceError"
      type="warning"
      density="compact"
      class="ma-2"
    >
      {{ distanceError }}
    </v-alert>
  </v-card>
</template>

<script setup lang="ts">
import { ref, computed } from 'vue'
import { format } from 'date-fns'

interface Shift {
  id: string
  client: {
    full_name: string
    address_line_1: string
    suburb: string
    latitude: number
    longitude: number
  }
  scheduled_start: string
  scheduled_end: string
  status: 'SCHEDULED' | 'IN_PROGRESS' | 'COMPLETED' | 'CANCELLED'
  notes?: string
  parent_shift_id?: string
}

interface Props {
  shift: Shift
}

const props = defineProps<Props>()
const emit = defineEmits<{
  'clock-in': [shiftId: string, latitude: number, longitude: number]
  'clock-out': [shiftId: string, latitude: number, longitude: number]
  'view-details': [shiftId: string]
}>()

const isClockingIn = ref(false)
const distanceError = ref<string | null>(null)
const canClockIn = ref(true)

const formatTime = (dateString: string) => {
  return format(new Date(dateString), 'h:mm a')
}

const getStatusColor = (status: string) => {
  const colors: Record<string, string> = {
    SCHEDULED: 'info',
    IN_PROGRESS: 'warning',
    COMPLETED: 'success',
    CANCELLED: 'error',
  }
  return colors[status] || 'grey'
}

const calculateDistance = (lat1: number, lon1: number, lat2: number, lon2: number): number => {
  const R = 6371e3 // Earth radius in meters
  const φ1 = (lat1 * Math.PI) / 180
  const φ2 = (lat2 * Math.PI) / 180
  const Δφ = ((lat2 - lat1) * Math.PI) / 180
  const Δλ = ((lon2 - lon1) * Math.PI) / 180

  const a =
    Math.sin(Δφ / 2) * Math.sin(Δφ / 2) +
    Math.cos(φ1) * Math.cos(φ2) * Math.sin(Δλ / 2) * Math.sin(Δλ / 2)
  const c = 2 * Math.atan2(Math.sqrt(a), Math.sqrt(1 - a))

  return R * c // Distance in meters
}

const handleClockIn = async () => {
  isClockingIn.value = true
  distanceError.value = null

  try {
    const position = await new Promise<GeolocationPosition>((resolve, reject) => {
      navigator.geolocation.getCurrentPosition(resolve, reject, {
        enableHighAccuracy: true,
        timeout: 10000,
      })
    })

    const { latitude, longitude } = position.coords
    const distance = calculateDistance(
      latitude,
      longitude,
      props.shift.client.latitude,
      props.shift.client.longitude
    )

    // Geofence: Must be within 100 meters
    if (distance > 100) {
      distanceError.value = `You are ${Math.round(distance)}m away from the shift location. Please move closer.`
      canClockIn.value = false
      return
    }

    emit('clock-in', props.shift.id, latitude, longitude)
  } catch (error) {
    distanceError.value = 'Unable to get your location. Please enable location services.'
  } finally {
    isClockingIn.value = false
  }
}

const handleClockOut = async () => {
  const position = await new Promise<GeolocationPosition>((resolve, reject) => {
    navigator.geolocation.getCurrentPosition(resolve, reject)
  })

  const { latitude, longitude } = position.coords
  emit('clock-out', props.shift.id, latitude, longitude)
}
</script>

<style scoped>
.shift-card {
  border-left: 4px solid #00796B;
  margin-bottom: 12px;
}

.shadow-shift {
  border-left-color: #F57C00;
  background: rgba(255, 243, 224, 0.85) !important;
  backdrop-filter: blur(8px);
}
</style>

