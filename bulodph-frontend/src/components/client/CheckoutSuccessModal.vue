<template>
  <v-dialog
    :model-value="modelValue"
    max-width="420"
    persistent
    content-class="checkout-success-dialog"
    scrim="rgba(15, 23, 42, 0.5)"
    @update:model-value="$emit('update:modelValue', $event)"
  >
    <v-card
      rounded="xl"
      elevation="0"
      class="checkout-success-card"
    >
      <div class="checkout-success-card__inner">
        <!-- Animated success icon -->
        <div class="checkout-success__icon-wrap">
          <div class="checkout-success__circle">
            <svg
              class="checkout-success__check"
              viewBox="0 0 52 52"
              aria-hidden="true"
            >
              <circle
                class="checkout-success__circle-bg"
                cx="26"
                cy="26"
                r="24"
                fill="none"
                stroke="currentColor"
                stroke-width="2"
              />
              <path
                class="checkout-success__check-path"
                fill="none"
                stroke="currentColor"
                stroke-width="3"
                stroke-linecap="round"
                stroke-linejoin="round"
                d="M14 27 l6 6 14 -16"
              />
            </svg>
          </div>
        </div>

        <h2 class="checkout-success__title">
          Booking request sent
        </h2>
        <p class="checkout-success__subtitle">
          Your request has been successfully submitted. We’ll confirm shortly—then you can pay and you’re all set.
        </p>
        <p class="checkout-success__enjoy">
          Enjoy your trip.
        </p>

        <div class="checkout-success__actions">
          <v-btn
            v-if="redirectUrl"
            color="primary"
            size="large"
            block
            rounded="lg"
            class="checkout-success__btn"
            prepend-icon="mdi-credit-card-outline"
            @click="onContinue"
          >
            Continue to payment
          </v-btn>
          <v-btn
            v-else
            color="primary"
            size="large"
            block
            rounded="lg"
            class="checkout-success__btn"
            prepend-icon="mdi-format-list-checks"
            @click="onContinue"
          >
            View my bookings
          </v-btn>
        </div>
      </div>
    </v-card>
  </v-dialog>
</template>

<script setup lang="ts">
defineProps<{
  modelValue: boolean
  redirectUrl?: string | null
}>()

const emit = defineEmits<{
  'update:modelValue': [value: boolean]
  continue: []
}>()

function onContinue() {
  emit('continue')
  emit('update:modelValue', false)
}
</script>

<style scoped>
.checkout-success-dialog :deep(.v-overlay__content) {
  align-items: center;
  justify-content: center;
}

.checkout-success-card {
  overflow: hidden;
  background: var(--surface-0);
  box-shadow: var(--shadow-modal);
}

.checkout-success-card__inner {
  padding: var(--space-8) var(--space-6);
  text-align: center;
}

/* Icon container with entrance animation */
.checkout-success__icon-wrap {
  margin-bottom: var(--space-5);
}

.checkout-success__circle {
  display: inline-flex;
  align-items: center;
  justify-content: center;
  width: 80px;
  height: 80px;
  color: var(--accent-green);
  animation: success-icon-pop 0.5s cubic-bezier(0.34, 1.56, 0.64, 1) forwards;
}

.checkout-success__circle .checkout-success__circle-bg {
  stroke-dasharray: 151;
  stroke-dashoffset: 151;
  animation: success-circle-draw 0.6s ease-out 0.2s forwards;
}

.checkout-success__circle .checkout-success__check-path {
  stroke-dasharray: 30;
  stroke-dashoffset: 30;
  animation: success-check-draw 0.4s ease-out 0.5s forwards;
}

@keyframes success-icon-pop {
  0% {
    opacity: 0;
    transform: scale(0.4);
  }
  100% {
    opacity: 1;
    transform: scale(1);
  }
}

@keyframes success-circle-draw {
  to {
    stroke-dashoffset: 0;
  }
}

@keyframes success-check-draw {
  to {
    stroke-dashoffset: 0;
  }
}

.checkout-success__title {
  font-size: 1.375rem;
  font-weight: 700;
  color: var(--text-primary);
  margin: 0 0 var(--space-3);
  line-height: 1.3;
}

.checkout-success__subtitle {
  font-size: var(--text-base);
  color: var(--text-secondary);
  margin: 0 0 var(--space-2);
  line-height: 1.5;
  max-width: 32ch;
  margin-left: auto;
  margin-right: auto;
}

.checkout-success__enjoy {
  font-size: 1.125rem;
  font-weight: 600;
  color: var(--role-primary, var(--navy-dark));
  margin: 0 0 var(--space-6);
  line-height: 1.4;
}

.checkout-success__actions {
  margin-top: var(--space-4);
}

.checkout-success__btn {
  text-transform: none;
  font-weight: 600;
  letter-spacing: 0.01em;
}
</style>
