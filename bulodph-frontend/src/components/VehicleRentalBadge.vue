<template>
  <div v-if="rentalName" class="vehicle-rental-badge-wrap">
    <v-avatar v-if="logoUrl" :size="size" rounded="lg" class="vehicle-rental-badge vehicle-rental-badge--logo">
      <v-img :src="logoUrl" :cover="false" class="vehicle-rental-badge__img" />
    </v-avatar>
    <div v-else class="vehicle-rental-badge vehicle-rental-badge--text" :style="{ width: size + 'px', height: size + 'px' }">
      <span class="vehicle-rental-badge__initials">{{ initials }}</span>
    </div>
  </div>
</template>

<script setup lang="ts">
import { computed } from 'vue'
import { getRentalProfileSeed } from '@/constants/rentalProfilesSeed'
import { resolveImageUrl } from '@/constants/images'

const props = withDefaults(
  defineProps<{
    /** Rental company / business name (from vehicle.businessName or hostName) */
    rentalName?: string
    /** Logo URL override (company logo = owner profile photo) */
    logoUrl?: string
    /** Badge size in pixels */
    size?: number
  }>(),
  { size: 40 }
)

const logoUrl = computed(() => {
  const raw = props.logoUrl ?? (props.rentalName ? getRentalProfileSeed(props.rentalName)?.logoUrl : '') ?? ''
  return raw ? (resolveImageUrl(raw) ?? raw) : ''
})

const initials = computed(() => {
  const name = (props.rentalName ?? '').trim()
  if (!name) return '?'
  const parts = name.split(/\s+/).filter(Boolean)
  if (parts.length >= 2) return (parts[0][0] + parts[parts.length - 1][0]).toUpperCase()
  return name.slice(0, 2).toUpperCase()
})
</script>

<style scoped>
.vehicle-rental-badge-wrap {
  position: relative;
}

.vehicle-rental-badge {
  flex-shrink: 0;
  box-shadow: 0 2px 8px rgba(0, 0, 0, 0.2);
  border: 2px solid rgba(255, 255, 255, 0.9);
  overflow: hidden;
  background: #fff;
}
.vehicle-rental-badge--logo {
  padding: 4px;
}
.vehicle-rental-badge__img {
  object-fit: contain !important;
  transform: scale(1.15);
}

.vehicle-rental-badge--text {
  display: flex;
  align-items: center;
  justify-content: center;
  background: linear-gradient(135deg, var(--role-primary) 0%, var(--role-primary-dark) 100%);
  color: #fff;
  font-size: 0.65rem;
  font-weight: 700;
  border-radius: 10px;
  box-shadow: 0 2px 8px rgba(0, 0, 0, 0.2);
  border: 2px solid rgba(255, 255, 255, 0.9);
}

.vehicle-rental-badge__initials {
  letter-spacing: 0.02em;
}
</style>
