<template>
  <DashboardTemplate title="Cart" subtitle="Your selected rides—almost there! Pick dates and proceed to book." :animate="true">
    <div ref="cartListRef" class="cart-list-stagger">
    <v-card v-for="(item, i) in cartStore.cart" :key="item.id" elevation="0" rounded="lg" class="modern-card mb-3">
      <v-card-text class="pa-4">
        <div class="d-flex align-center justify-space-between flex-wrap gap-3">
          <div class="d-flex align-center cart-item-row">
            <v-img :src="item.vehicleImage" width="80" height="56" cover rounded="lg" class="cart-item__img" />
            <div class="cart-item__info">
              <div class="font-weight-bold">{{ item.vehicleName }}</div>
              <div class="text-caption text-medium-emphasis">{{ item.location }} · {{ formatPrice(item.pricePerDay, { suffix: '/day' }) }}</div>
            </div>
          </div>
          <div class="d-flex align-center gap-3">
            <span class="font-weight-bold">{{ formatPrice(item.pricePerDay * (item.days || 1)) }}</span>
            <v-tooltip location="top">
              <template #activator="{ props: tooltipProps }">
                <v-btn
                  v-bind="tooltipProps"
                  variant="outlined"
                  size="small"
                  icon="mdi-eye"
                  aria-label="View vehicle"
                  :to="{ name: 'client-vehicle-detail', params: { id: item.vehicleId } }"
                />
              </template>
              View vehicle
            </v-tooltip>
            <v-tooltip location="top">
              <template #activator="{ props: tooltipProps }">
                <v-btn
                  v-bind="tooltipProps"
                  variant="outlined"
                  size="small"
                  icon="mdi-calendar-edit"
                  aria-label="Change dates"
                  :to="scheduleBookingTo(item)"
                />
              </template>
              Change dates
            </v-tooltip>
            <v-tooltip location="top">
              <template #activator="{ props: tooltipProps }">
                <v-btn
                  v-bind="tooltipProps"
                  icon="mdi-delete-outline"
                  variant="text"
                  size="small"
                  color="error"
                  aria-label="Remove from cart"
                  @click="openRemoveConfirm(i)"
                />
              </template>
              Remove from cart
            </v-tooltip>
          </div>
        </div>
        <p v-if="!item.start || !item.end" class="text-caption text-warning mt-2 mb-0">Pick dates in Schedule booking.</p>
      </v-card-text>
    </v-card>
    </div>

    <v-card v-if="cartStore.cartCount" elevation="0" rounded="lg" class="modern-card mt-4">
      <v-card-text class="pa-4">
        <div class="d-flex justify-space-between align-center flex-wrap gap-3">
          <span class="text-h6 font-weight-bold">Total ({{ cartStore.cartCount }} item{{ cartStore.cartCount > 1 ? 's' : '' }})</span>
          <span class="text-h6 font-weight-bold text-primary">{{ formatPrice(cartStore.cartTotal) }}</span>
        </div>
        <p class="text-caption text-medium-emphasis mt-2 mb-0">By proceeding, you agree that BulodPH is a platform connecting you with vehicle owners; rental terms apply at checkout.</p>
        <v-btn
          color="primary"
          block
          size="large"
          rounded="lg"
          class="mt-4"
          prepend-icon="mdi-arrow-right"
          :to="checkoutTo"
        >
          Continue to book
        </v-btn>
      </v-card-text>
    </v-card>

    <v-card v-else elevation="0" rounded="lg" class="modern-card">
      <v-card-text class="pa-4">
        <HpaEmptyState
          title="Your cart is empty"
          description="Save a ride from Browse, then come back here to pick your dates and book."
          icon="mdi-cart-outline"
          action-text="Find your ride"
          action-icon="mdi-car-search"
          @action="goToBrowse"
        />
      </v-card-text>
    </v-card>

    <HpaConfirmModal
      v-model="showRemoveConfirm"
      title="Remove from cart?"
      :message="removeConfirmMessage"
      confirm-text="Remove"
      cancel-text="Keep"
      variant="danger"
      @confirm="confirmRemove"
    />
  </DashboardTemplate>
</template>

<script setup lang="ts">
import { ref, computed, onMounted } from 'vue'
import { useRouter } from 'vue-router'
import DashboardTemplate from '@/components/DashboardTemplate.vue'
import HpaEmptyState from '@/components/base/HpaEmptyState.vue'
import HpaConfirmModal from '@/components/base/HpaConfirmModal.vue'
import { formatPrice } from '@/utils/priceFormat'
import { useCartStore } from '@/stores/cart'
import type { CartItem } from '@/stores/cart'
import { useGsapStagger } from '@/composables/useGsapStagger'

const router = useRouter()
const cartStore = useCartStore()
const cartListRef = ref<HTMLElement | null>(null)
useGsapStagger(cartListRef, { selector: '.modern-card', y: 12, duration: 0.4, stagger: 0.05 })
onMounted(() => cartStore.reload())
const showRemoveConfirm = ref(false)
const removeIndex = ref<number | null>(null)

const removeConfirmMessage = computed(() => {
  const i = removeIndex.value
  if (i == null || !cartStore.cart[i]) return 'This item will be removed from your cart.'
  return `Remove "${cartStore.cart[i].vehicleName}" from your cart?`
})

function openRemoveConfirm(index: number) {
  removeIndex.value = index
  showRemoveConfirm.value = true
}

function confirmRemove() {
  if (removeIndex.value != null) {
    cartStore.removeAt(removeIndex.value)
    removeIndex.value = null
  }
  showRemoveConfirm.value = false
}

function goToBrowse() {
  router.push({ name: 'client-browse' })
}

const checkoutTo = computed(() => {
  const first = cartStore.cart[0]
  if (!first) return { name: 'client-browse' }
  return {
    name: 'client-checkout',
    query: { vehicleId: first.vehicleId, start: first.start, end: first.end },
  }
})

function scheduleBookingTo(item: CartItem) {
  return {
    name: 'client-booking-new',
    query: { vehicleId: item.vehicleId, start: item.start, end: item.end },
  }
}
</script>

<style scoped>
.cart-item-row {
  display: flex;
  align-items: center;
  gap: 20px;
}
.cart-item__img {
  flex-shrink: 0;
}
</style>
