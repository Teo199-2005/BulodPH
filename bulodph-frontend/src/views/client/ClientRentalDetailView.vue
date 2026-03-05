<template>
  <DashboardTemplate
    :animate="true"
    :breadcrumb-items="[{ label: 'Dashboard', to: '/client' }, { label: 'Browse car rentals', to: '/client/browse-rentals' }, { label: rental?.businessName ?? 'Car rental' }]"
  >
    <template v-if="rental">
      <LiabilityDisclaimerBanner dismiss-key="client-rental-detail-liability-dismissed" />
      <!-- Rental profile header -->
      <v-card elevation="0" rounded="lg" class="modern-card rental-profile-card mb-4">
        <div class="rental-profile-header">
          <v-avatar :size="100" rounded="lg" class="rental-profile-logo" :class="{ 'rental-profile-logo--initials': showDetailInitials(rental) }">
            <v-img
              v-if="effectiveLogo(rental) && !detailLogoFailed"
              :src="resolveImageUrl(effectiveLogo(rental)!) ?? effectiveLogo(rental)!"
              cover
              @error="detailLogoFailed = true"
            />
            <span v-else-if="effectiveName(rental)" class="rental-profile-initials">{{ rentalDetailInitials(effectiveName(rental)!) }}</span>
            <v-icon v-else size="48" color="grey">mdi-storefront-outline</v-icon>
          </v-avatar>
          <div class="rental-profile-info">
            <h1 class="rental-profile-name">{{ effectiveName(rental) }}</h1>
            <div v-if="rental.city || rental.province" class="rental-profile-location">
              <v-icon size="18">mdi-map-marker</v-icon>
              {{ [rental.city, rental.province].filter(Boolean).join(', ') }}
            </div>
            <div v-if="rental.phone || rental.email" class="rental-profile-contact mt-2">
              <a v-if="rental.phone" :href="`tel:${rental.phone.replace(/\s/g, '')}`" class="contact-link">
                <v-icon size="16">mdi-phone</v-icon> {{ rental.phone }}
              </a>
              <a v-if="rental.email" :href="`mailto:${rental.email}`" class="contact-link ml-3">
                <v-icon size="16">mdi-email</v-icon> {{ rental.email }}
              </a>
            </div>
            <v-btn
              v-if="rental.ownerId"
              variant="tonal"
              color="primary"
              size="small"
              rounded="lg"
              class="mt-2"
              prepend-icon="mdi-message-text-outline"
              @click="goToMessages(rental.ownerId)"
            >
              Message this rental
            </v-btn>
          </div>
        </div>
        <v-card-text v-if="rental.bio" class="pt-0">
          <p class="rental-profile-bio text-body-1">{{ rental.bio }}</p>
        </v-card-text>
        <v-card-text v-if="rental.address" class="pt-0">
          <p class="text-body-2 text-medium-emphasis mb-0">
            <v-icon size="16">mdi-map-marker-outline</v-icon> {{ rental.address }}
          </p>
        </v-card-text>
      </v-card>

      <!-- Their vehicles -->
      <h2 class="section-title mb-3">Their fleet</h2>
      <v-row>
        <v-col
          v-for="vehicle in vehicles"
          :key="vehicle.id"
          cols="12"
          sm="6"
          md="4"
          lg="3"
        >
          <v-card elevation="0" rounded="lg" class="modern-card vehicle-card" hover>
            <div class="vehicle-card__image">
              <v-img
                :src="vehicle.image"
                :alt="vehicle.name"
                cover
                gradient="to bottom, rgba(0,0,0,0) 60%, rgba(0,0,0,0.4) 100%"
              />
              <div v-if="rental?.businessName" class="vehicle-card__watermark">{{ rental.businessName }}</div>
              <div v-if="rental?.businessName" class="vehicle-card__rental-badge">
                <VehicleRentalBadge :rental-name="rental.businessName" :size="36" />
              </div>
              <span class="vehicle-card__type">{{ vehicle.type }}</span>
            </div>
            <v-card-text class="pa-3">
              <div class="d-flex flex-wrap gap-2 mb-2 vehicle-card__badges">
                <v-chip v-if="vehicle.verified" size="x-small" color="success" variant="tonal" prepend-icon="mdi-shield-check">Verified</v-chip>
                <v-chip v-if="vehicle.hasPermit" size="x-small" color="info" variant="tonal" prepend-icon="mdi-file-document-check">Has Permit</v-chip>
                <v-chip v-if="vehicle.featured" size="x-small" color="primary" variant="tonal" prepend-icon="mdi-star">Featured</v-chip>
                <v-chip v-if="vehicle.rentalMode" size="x-small" variant="tonal" color="secondary" prepend-icon="mdi-car-key">{{ rentalModeLabel(vehicle.rentalMode) }}</v-chip>
                <v-chip v-if="minRentalChipText(vehicle.minRentalPeriodHours)" size="x-small" variant="tonal" color="secondary">{{ minRentalChipText(vehicle.minRentalPeriodHours) }}</v-chip>
              </div>
              <h3 class="text-subtitle-1 font-weight-bold mb-1">{{ vehicle.name }}</h3>
              <div class="d-flex flex-wrap gap-3 mb-2">
                <v-chip
                  v-for="tag in (vehicle.tags ?? []).slice(0, 2)"
                  :key="tag"
                  size="x-small"
                  variant="tonal"
                  color="primary"
                >
                  {{ tag }}
                </v-chip>
              </div>
              <div class="d-flex align-center justify-space-between flex-wrap gap-3">
                <PriceDisplay
                  :price-per-day="vehicle.pricePerDay"
                  :original-price-per-day="vehicle.originalPricePerDay"
                  variant="inline"
                />
                <v-btn
                  color="primary"
                  variant="flat"
                  size="small"
                  rounded="lg"
                  :to="{ name: 'client-vehicle-detail', params: { id: vehicle.id } }"
                >
                  View
                </v-btn>
              </div>
            </v-card-text>
          </v-card>
        </v-col>
      </v-row>

      <div v-if="!vehicles.length" class="text-center py-8">
        <p class="text-medium-emphasis mb-0">No vehicles listed yet.</p>
      </div>
    </template>

    <div v-else class="text-center py-10">
      <v-icon icon="mdi-storefront-outline" size="56" color="grey" class="mb-2" />
      <p class="text-medium-emphasis mb-3">Rental company not found.</p>
      <v-btn
        variant="outlined"
        rounded="lg"
        :to="{ name: 'client-browse-rentals' }"
      >
        Browse car rentals
      </v-btn>
    </div>
  </DashboardTemplate>
</template>

<script setup lang="ts">
import { ref, computed, onMounted, watch } from 'vue'
import { useRoute, useRouter } from 'vue-router'
import DashboardTemplate from '@/components/DashboardTemplate.vue'
import LiabilityDisclaimerBanner from '@/components/LiabilityDisclaimerBanner.vue'
import PriceDisplay from '@/components/PriceDisplay.vue'
import VehicleRentalBadge from '@/components/VehicleRentalBadge.vue'
import { useCarRentalProfiles } from '@/composables/useCarRentalProfiles'
import * as carRentalApi from '@/services/carRentalProfile'
import * as messagesApi from '@/services/messages'
import { rentalModeLabel, minRentalChipText } from '@/constants/vehicleSeed'
import { useUserSessionStore } from '@/stores/userSession'
import type { CarRentalProfile } from '@/types/carRentalProfile'
import { resolveImageUrl } from '@/constants/images'

const route = useRoute()
const router = useRouter()
const userSession = useUserSessionStore()
const { getRentalById, getVehiclesByRental, fetchFromApi, fetchRentals } = useCarRentalProfiles()

/** Profile loaded from API (so client view always shows full profile including logo). */
const rentalFromApi = ref<CarRentalProfile | null>(null)
/** When logo image fails to load, show initials instead. */
const detailLogoFailed = ref(false)

const rental = computed(() => {
  const id = route.params.id as string
  if (!id) return null
  return rentalFromApi.value ?? getRentalById(id) ?? null
})

const vehicles = computed(() => {
  const id = route.params.id as string
  return id ? getVehiclesByRental(id) : []
})

async function loadRentalProfile() {
  const id = route.params.id as string
  if (!id) return
  const fromApi = await carRentalApi.getCarRentalById(id)
  if (fromApi) rentalFromApi.value = fromApi
}

onMounted(() => {
  fetchFromApi()
  fetchRentals()
  loadRentalProfile()
})

watch(() => route.params.id, () => {
  rentalFromApi.value = null
  detailLogoFailed.value = false
  loadRentalProfile()
})

/** Show initials when no logo URL or logo image failed to load. */
function showDetailInitials(r: { logoUrl?: string | null; logo_url?: string; businessName?: string; business_name?: string } | null): boolean {
  if (!r) return true
  if (detailLogoFailed.value) return true
  const url = r.logoUrl ?? (r as { logo_url?: string }).logo_url
  if (typeof url === 'string' && url.trim()) return false
  return true
}

/** Effective logo URL (non-empty string) so avatar never clears. */
function effectiveLogo(rental: { logoUrl?: string | null; logo_url?: string }): string | undefined {
  const url = rental.logoUrl ?? (rental as { logo_url?: string }).logo_url
  return typeof url === 'string' && url.trim() ? url.trim() : undefined
}
/** Display name so avatar/heading never empty (handles API snake_case or null). */
function effectiveName(rental: { businessName?: string; business_name?: string }): string {
  const name = rental.businessName ?? (rental as { business_name?: string }).business_name
  return typeof name === 'string' && name.trim() ? name.trim() : 'Rental'
}
/** Initials from company name when no logo (company logo = profile photo). */
function rentalDetailInitials(name: string): string {
  const parts = String(name || '').trim().split(/\s+/).filter(Boolean)
  if (parts.length >= 2) return (parts[0][0] + parts[parts.length - 1][0]).toUpperCase()
  return (name || '?').slice(0, 2).toUpperCase()
}

async function goToMessages(ownerId: string) {
  const userId = userSession.user?.id
  if (!userId) {
    router.push({ name: 'client-messages' })
    return
  }
  try {
    const thread = await messagesApi.createThread({
      client_id: userId,
      owner_id: ownerId,
    })
    router.push({ name: 'client-messages', query: { threadId: thread.id } })
  } catch {
    router.push({ name: 'client-messages' })
  }
}
</script>

<style scoped>
.rental-profile-header {
  display: flex;
  gap: 1.5rem;
  flex-wrap: wrap;
}
.rental-profile-logo {
  flex-shrink: 0;
  background: rgba(var(--v-theme-surface-variant), 0.3);
}
.rental-profile-logo--initials {
  background: linear-gradient(135deg, rgb(var(--v-theme-primary)) 0%, rgba(var(--v-theme-primary), 0.85) 100%);
  color: rgb(var(--v-theme-on-primary));
  font-weight: 700;
  font-size: 2rem;
}
.rental-profile-initials {
  letter-spacing: 0.02em;
}
.rental-profile-info {
  flex: 1;
  min-width: 0;
}
.rental-profile-name {
  font-size: 1.5rem;
  font-weight: 700;
  margin: 0 0 8px;
  line-height: 1.2;
}
.rental-profile-location {
  display: flex;
  align-items: center;
  gap: 6px;
  color: rgba(0, 0, 0, 0.7);
  font-size: 0.9375rem;
}
.rental-profile-contact .contact-link {
  color: var(--v-theme-primary);
  text-decoration: none;
  font-size: 0.875rem;
  display: inline-flex;
  align-items: center;
  gap: 4px;
}
.rental-profile-contact .contact-link:hover {
  text-decoration: underline;
}
.rental-profile-bio {
  margin: 0;
  line-height: 1.6;
  color: rgba(0, 0, 0, 0.8);
}
.section-title {
  font-size: 1.25rem;
  font-weight: 700;
  margin: 0;
}
.vehicle-card__image {
  position: relative;
  overflow: hidden;
  border-radius: 12px 12px 0 0;
  aspect-ratio: 4/3;
  min-height: 120px;
}
.vehicle-card__image :deep(.v-img) {
  position: absolute;
  inset: 0;
  width: 100%;
  height: 100%;
  object-fit: cover;
}
.vehicle-card__type {
  position: absolute;
  top: 8px;
  left: 8px;
  background: rgba(0, 0, 0, 0.6);
  color: #fff;
  font-size: 0.625rem;
  font-weight: 700;
  text-transform: uppercase;
  padding: 3px 6px;
  border-radius: 4px;
}
.vehicle-card__watermark {
  position: absolute;
  bottom: 8px;
  left: 8px;
  right: 8px;
  font-size: 0.7rem;
  color: rgba(255, 255, 255, 0.85);
  text-shadow: 0 1px 2px rgba(0, 0, 0, 0.6);
  pointer-events: none;
  z-index: 1;
}
.vehicle-card__rental-badge {
  position: absolute;
  top: 8px;
  right: 8px;
  z-index: 2;
}
.vehicle-card__badges {
  min-height: 24px;
}
</style>
