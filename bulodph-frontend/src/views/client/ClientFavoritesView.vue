<template>
  <DashboardTemplate title="Favorites" subtitle="Vehicles you saved—one click to view or book your next trip." :animate="true">
    <div v-if="favoriteVehicles.length" class="mb-4 d-flex gap-3 flex-wrap">
      <v-tooltip location="bottom">
        <template #activator="{ props: tooltipProps }">
          <v-btn
            v-bind="tooltipProps"
            variant="outlined"
            color="error"
            size="small"
            rounded="lg"
            icon="mdi-heart-remove"
            aria-label="Remove all favorites"
            @click="openRemoveAllConfirm"
          />
        </template>
        Remove all favorites
      </v-tooltip>
      <v-tooltip location="bottom">
        <template #activator="{ props: tooltipProps }">
          <v-btn
            v-bind="tooltipProps"
            variant="tonal"
            color="primary"
            size="small"
            rounded="lg"
            icon="mdi-cart-plus"
            aria-label="Add all to cart"
            @click="openAddAllToCartConfirm"
          />
        </template>
        Add all to cart
      </v-tooltip>
    </div>
    <template v-if="favoriteVehicles.length">
      <div ref="favListRef" class="favorites-list-stagger">
        <v-row>
          <v-col
            v-for="v in favoriteVehicles"
            :key="v.id"
            cols="12"
            sm="6"
            md="4"
            lg="3"
          >
            <v-card elevation="0" rounded="lg" class="modern-card vehicle-card" hover>
              <div class="vehicle-card__image">
                <v-img :src="v.image" :alt="v.name" cover height="160" gradient="to bottom, rgba(0,0,0,0) 60%, rgba(0,0,0,0.4) 100%" />
                <span class="vehicle-card__type">{{ v.type }}</span>
                <span class="vehicle-card__location">
                  <v-icon size="14">mdi-map-marker</v-icon>
                  {{ v.location }}
                </span>
                <v-tooltip location="top">
                  <template #activator="{ props: tooltipProps }">
                    <v-btn
                      v-bind="tooltipProps"
                      icon="mdi-heart"
                      size="small"
                      class="vehicle-card__fav"
                      color="error"
                      variant="flat"
                      aria-label="Remove from favorites"
                      @click="removeFavorite(v.id)"
                    />
                  </template>
                  Remove from favorites
                </v-tooltip>
              </div>
              <v-card-text class="pa-4">
                <div class="d-flex flex-wrap gap-2 mb-2">
                  <v-chip v-if="v.rentalMode" size="x-small" variant="tonal" color="secondary" prepend-icon="mdi-car-key">{{ rentalModeLabel(v.rentalMode) }}</v-chip>
                  <v-chip v-if="minRentalChipText(v.minRentalPeriodHours)" size="x-small" variant="tonal" color="secondary">{{ minRentalChipText(v.minRentalPeriodHours) }}</v-chip>
                </div>
                <h3 class="text-h6 font-weight-bold mb-2">{{ v.name }}</h3>
                <div class="d-flex align-center justify-space-between">
                  <PriceDisplay :price-per-day="v.pricePerDay" :original-price-per-day="v.originalPricePerDay" variant="card" />
                  <div class="d-flex gap-2">
                    <v-btn variant="outlined" size="small" rounded="lg" prepend-icon="mdi-eye" :to="{ name: 'client-vehicle-detail', params: { id: v.id } }">View</v-btn>
                    <v-btn color="primary" variant="flat" size="small" rounded="lg" prepend-icon="mdi-calendar-check" :to="{ name: 'client-vehicle-detail', params: { id: v.id } }">Book</v-btn>
                  </div>
                </div>
              </v-card-text>
            </v-card>
          </v-col>
        </v-row>
      </div>
    </template>
    <v-card v-else elevation="0" rounded="lg" class="modern-card">
      <v-card-text class="pa-4">
        <HpaEmptyState
          title="No favorites yet"
          description="Tap the heart on any vehicle while browsing to save it here—then book when you're ready."
          icon="mdi-heart-outline"
          action-text="Find your ride"
          action-icon="mdi-car-search"
          @action="goToBrowse"
        />
      </v-card-text>
    </v-card>

    <HpaConfirmModal
      v-model="showRemoveAllConfirm"
      title="Remove all favorites?"
      message="All saved vehicles will be removed from your favorites. You can add them again from Browse."
      confirm-text="Remove all"
      cancel-text="Cancel"
      variant="danger"
      @confirm="confirmRemoveAll"
    />
    <HpaConfirmModal
      v-model="showAddAllToCartConfirm"
      title="Add all to cart?"
      message="All favorite vehicles will be added to your cart. You can adjust dates in the cart before checkout."
      confirm-text="Add all"
      cancel-text="Cancel"
      variant="default"
      @confirm="confirmAddAllToCart"
    />
  </DashboardTemplate>
</template>

<script setup lang="ts">
import { computed, ref, onMounted } from 'vue'
import { useRouter } from 'vue-router'
import DashboardTemplate from '@/components/DashboardTemplate.vue'
import PriceDisplay from '@/components/PriceDisplay.vue'
import HpaEmptyState from '@/components/base/HpaEmptyState.vue'
import HpaConfirmModal from '@/components/base/HpaConfirmModal.vue'
import { rentalModeLabel, minRentalChipText } from '@/constants/vehicleSeed'
import { useFavoritesStore } from '@/stores/favorites'
import { useVehicles } from '@/composables/useVehicles'
import { useCartStore } from '@/stores/cart'
import { useToastStore } from '@/stores/toast'
import { useGsapStagger } from '@/composables/useGsapStagger'

const router = useRouter()
const favListRef = ref<HTMLElement | null>(null)
useGsapStagger(favListRef, { selector: '.v-col', y: 14, duration: 0.42, stagger: 0.06 })
const favoritesStore = useFavoritesStore()
onMounted(() => favoritesStore.reload())
const cartStore = useCartStore()
const toast = useToastStore()
const { getById } = useVehicles()
const showRemoveAllConfirm = ref(false)
const showAddAllToCartConfirm = ref(false)

const favoriteVehicles = computed(() => {
  return favoritesStore.vehicleIds
    .map((id) => getById(id))
    .filter(Boolean)
    .map((v) => ({
      id: v!.id,
      name: v!.name,
      type: v!.type,
      location: v!.location,
      pricePerDay: v!.pricePerDay,
      originalPricePerDay: v!.originalPricePerDay,
      image: v!.image,
      rentalMode: v!.rentalMode,
      minRentalPeriodHours: v!.minRentalPeriodHours,
    }))
})

function removeFavorite(id: string) {
  favoritesStore.remove(id)
}

function goToBrowse() {
  router.push({ name: 'client-browse' })
}

function openRemoveAllConfirm() {
  showRemoveAllConfirm.value = true
}

function confirmRemoveAll() {
  favoritesStore.vehicleIds.forEach(id => favoritesStore.remove(id))
  showRemoveAllConfirm.value = false
  toast.warning('All favorites removed.')
}

function openAddAllToCartConfirm() {
  showAddAllToCartConfirm.value = true
}

function confirmAddAllToCart() {
  favoriteVehicles.value.forEach(v => {
    cartStore.addItem({
      vehicleId: v.id,
      vehicleName: v.name,
      vehicleImage: v.image,
      location: v.location,
      pricePerDay: v.pricePerDay,
    })
  })
  showAddAllToCartConfirm.value = false
  toast.success(`${favoriteVehicles.value.length} vehicle(s) added to cart.`)
  router.push({ name: 'client-cart' })
}
</script>

<style scoped>
.vehicle-card__image {
  position: relative;
  overflow: hidden;
  border-radius: 12px 12px 0 0;
}
.vehicle-card__type {
  position: absolute;
  top: 12px;
  left: 12px;
  background: rgba(0,0,0,0.6);
  color: #fff;
  font-size: 0.6875rem;
  font-weight: 700;
  text-transform: uppercase;
  padding: 4px 8px;
  border-radius: 6px;
}
.vehicle-card__location {
  position: absolute;
  bottom: 12px;
  left: 12px;
  color: #fff;
  font-size: 0.8125rem;
  display: flex;
  align-items: center;
  gap: 4px;
}
.vehicle-card__fav {
  position: absolute;
  top: 8px;
  right: 8px;
}
</style>
