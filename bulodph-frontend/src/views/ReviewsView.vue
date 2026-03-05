<template>
  <DashboardTemplate title="Reviews & Ratings" subtitle="Leave feedback and see your review history.">
    <v-row>
      <v-col cols="12" md="6">
        <v-card class="modern-card" elevation="0" rounded="lg">
          <div class="section-card-header">
            <span class="section-card-title">Leave a review</span>
          </div>
          <v-divider class="dashboard-divider" />
          <v-card-text class="pa-4">
            <v-form @submit.prevent="handleSubmit">
              <v-text-field
                v-model="bookingRef"
                label="Booking reference (optional)"
                placeholder="e.g. booking ID"
                variant="outlined"
                density="compact"
                :error-messages="errors.bookingRef"
              />
              <v-text-field
                v-model="vehicleRef"
                label="Vehicle reference (optional)"
                placeholder="e.g. vehicle ID"
                variant="outlined"
                density="compact"
                class="mt-3"
                :error-messages="errors.vehicleRef"
              />
              <v-select
                v-model="rating"
                :items="[1, 2, 3, 4, 5]"
                label="Rating (1–5) *"
                variant="outlined"
                density="compact"
                class="mt-3"
                :error-messages="errors.rating"
              />
              <v-textarea
                v-model="comment"
                label="Comment"
                variant="outlined"
                rows="4"
                class="mt-3"
                placeholder="How was your trip?"
                :error-messages="errors.comment"
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
                Submit review
              </v-btn>
            </v-form>
          </v-card-text>
        </v-card>
      </v-col>
      <v-col cols="12" md="6">
        <v-card class="modern-card" elevation="0" rounded="lg">
          <div class="section-card-header">
            <span class="section-card-title">Your reviews</span>
          </div>
          <v-divider class="dashboard-divider" />
          <v-card-text class="pa-4">
            <p v-if="loading" class="text-body-2 text-medium-emphasis mb-0">Loading…</p>
            <template v-else-if="myReviews.length">
              <v-list class="pa-0">
                <v-list-item
                  v-for="r in myReviews"
                  :key="r.id"
                  class="px-0"
                  rounded="lg"
                >
                  <template #prepend>
                    <v-rating :model-value="r.rating" density="compact" size="small" readonly />
                  </template>
                  <v-list-item-title class="text-body-2">{{ r.comment || 'No comment' }}</v-list-item-title>
                  <v-list-item-subtitle class="text-body-2">
                    {{ r.booking_reference ? `Booking ${r.booking_reference}` : '' }} {{ r.vehicle_reference ? `· Vehicle ${r.vehicle_reference}` : '' }} · {{ r.status }}
                  </v-list-item-subtitle>
                </v-list-item>
              </v-list>
            </template>
            <p v-else class="text-body-2 text-medium-emphasis mb-0">No reviews yet. Leave one after a completed trip.</p>
          </v-card-text>
        </v-card>
      </v-col>
    </v-row>
  </DashboardTemplate>
</template>

<script setup lang="ts">
import { computed, ref, onMounted, watch } from 'vue'
import { useRoute } from 'vue-router'
import DashboardTemplate from '@/components/DashboardTemplate.vue'
import { useToastStore } from '@/stores/toast'
import { useUserSessionStore } from '@/stores/userSession'
import * as reviewsApi from '@/services/reviews'
import type { ReviewRecord } from '@/services/reviews'
import {
  BOOKING_REF_REGEX,
  hasInjectionRisk,
  isSafeText,
  sanitizeBasicText,
} from '@/utils/inputValidation'

const route = useRoute()
const toast = useToastStore()
const userSession = useUserSessionStore()
const bookingRef = ref('')
const vehicleRef = ref('')
const rating = ref<number | null>(null)
const comment = ref('')
const isSubmitting = ref(false)
const loading = ref(true)
const reviews = ref<ReviewRecord[]>([])
const errors = ref<{ bookingRef?: string; vehicleRef?: string; rating?: string; comment?: string }>({})

const canSubmit = computed(() => (rating.value != null && rating.value >= 1 && rating.value <= 5))

/** Only show reviews written by the current user (backend may return all). */
const myReviews = computed(() => {
  const uid = userSession.user?.id
  if (!uid) return reviews.value
  return reviews.value.filter((r) => r.reviewer_id === uid)
})

async function loadReviews() {
  loading.value = true
  try {
    reviews.value = await reviewsApi.getReviews()
  } catch {
    reviews.value = []
  } finally {
    loading.value = false
  }
}

onMounted(() => {
  loadReviews()
  const bid = route.query.bookingId as string | undefined
  const vid = route.query.vehicleId as string | undefined
  if (bid) bookingRef.value = bid
  if (vid) vehicleRef.value = vid
})
watch(() => route.query.bookingId, (bid) => { if (bid) bookingRef.value = String(bid) })
watch(() => route.query.vehicleId, (vid) => { if (vid) vehicleRef.value = String(vid) })

async function handleSubmit() {
  errors.value = {}
  bookingRef.value = sanitizeBasicText(bookingRef.value)
  vehicleRef.value = sanitizeBasicText(vehicleRef.value)
  comment.value = sanitizeBasicText(comment.value)

  if (bookingRef.value && (!BOOKING_REF_REGEX.test(bookingRef.value) || hasInjectionRisk(bookingRef.value))) {
    errors.value.bookingRef = 'Use letters, numbers, dashes, or underscores only'
  }
  if (vehicleRef.value && (!isSafeText(vehicleRef.value) || hasInjectionRisk(vehicleRef.value))) {
    errors.value.vehicleRef = 'Vehicle reference contains unsafe characters'
  }

  const numRating = rating.value == null ? 0 : Number(rating.value)
  if (numRating < 1 || numRating > 5) {
    errors.value.rating = 'Rating must be between 1 and 5'
  }

  if (comment.value && (!isSafeText(comment.value) || hasInjectionRisk(comment.value))) {
    errors.value.comment = 'Comment contains unsafe characters'
  }

  if (Object.keys(errors.value).length) return

  isSubmitting.value = true
  try {
    await reviewsApi.createReview({
      booking_reference: bookingRef.value || undefined,
      vehicle_reference: vehicleRef.value || undefined,
      rating: numRating,
      comment: comment.value || undefined,
    })
    toast.success('Thanks for your review!')
    comment.value = ''
    await loadReviews()
  } catch (e) {
    toast.error(e instanceof Error ? e.message : 'Could not submit review.')
  } finally {
    isSubmitting.value = false
  }
}
</script>
