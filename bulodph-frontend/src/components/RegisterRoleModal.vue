<template>
  <v-dialog
    :model-value="modelValue"
    persistent
    max-width="1400"
    content-class="register-triple-dialog"
    transition="dialog-transition"
    aria-labelledby="register-role-title"
    aria-describedby="register-role-desc"
    role="dialog"
    @update:model-value="$emit('update:modelValue', $event)"
  >
    <div ref="modalContentRef" class="register-triple-modal" role="presentation">
      <div class="register-role-modal-brand register-role-modal-brand--triple">
        <img src="/logo.png" alt="BulodPH" class="register-role-modal-logo" />
        <p id="register-role-desc" class="register-role-modal-tagline">
          Car rental marketplace throughout the region and across the Philippines.
        </p>
        <h2 id="register-role-title" class="register-role-modal-title">How do you want to use BulodPH?</h2>
      </div>
      <div class="register-triple-row">
        <div class="register-modal-container register-modal-container--triple">
          <button
            type="button"
            class="register-role-card register-role-card--renter"
            aria-label="Sign up to rent a car"
            @click="$emit('select', 'renter')"
          >
            <div class="register-role-card-image-wrap">
              <span class="register-role-card-logo-wrap" aria-hidden="true">
                <img src="/logo.png" alt="" class="register-role-card-logo" />
              </span>
              <img
                src="/images/rent-a-car-hero.png"
                alt="Rent a car — find a ride with BulodPH"
                class="register-role-card-image"
              />
              <span class="register-role-card-badge">Rent a car</span>
            </div>
            <p class="register-role-card-desc">Find a ride. Book cars from partners throughout the region and the Philippines.</p>
            <span class="register-role-card-cta">Sign up to rent</span>
          </button>
        </div>
        <div class="register-modal-container register-modal-container--triple">
          <button
            type="button"
            class="register-role-card register-role-card--car-owner"
            aria-label="Sign up as car rental owner"
            @click="$emit('select', 'car_owner')"
          >
            <div class="register-role-card-image-wrap">
              <span class="register-role-card-logo-wrap" aria-hidden="true">
                <img src="/logo.png" alt="" class="register-role-card-logo" />
              </span>
              <img
                src="/images/car-owner-hero.png"
                alt="List your vehicle — share with neighbors and earn with BulodPH"
                class="register-role-card-image"
              />
              <span class="register-role-card-badge">Car Rental Owner</span>
            </div>
            <p class="register-role-card-desc">List your vehicle and earn when it's idle. Share your car with neighbors and travelers.</p>
            <span class="register-role-card-cta">Sign up as car rental owner</span>
          </button>
        </div>
      </div>
    </div>
  </v-dialog>
</template>

<script setup lang="ts">
import { ref, watch, nextTick, onBeforeUnmount } from 'vue'

const props = defineProps<{
  modelValue: boolean
}>()

defineEmits<{
  'update:modelValue': [value: boolean]
  'select': [role: 'renter' | 'car_owner']
}>()

const modalContentRef = ref<HTMLElement | null>(null)
let ctx: gsap.Context | null = null

watch(
  () => props.modelValue,
  async (open) => {
    if (!open || !modalContentRef.value) return
    await nextTick()
    const el = modalContentRef.value
    if (!el) return
    if (window.matchMedia('(prefers-reduced-motion: reduce)').matches) return
    const { default: gsap } = await import('gsap')
    ctx?.revert()
    ctx = gsap.context(() => {
      gsap.fromTo(el, { opacity: 0, y: 16 }, { opacity: 1, y: 0, duration: 0.45, ease: 'power2.out', overwrite: true })
    }, el)
  },
  { immediate: false }
)

onBeforeUnmount(() => {
  ctx?.revert()
  ctx = null
})
</script>

<style scoped>
/* Role selection modal – 1×1×1 three equal columns */
.register-triple-modal {
  display: flex;
  flex-direction: column;
  min-height: 320px;
  width: 100%;
  overflow: visible;
  background: linear-gradient(165deg, #ffffff 0%, #f8fcff 50%, #f0f9ff 100%);
  border-radius: 28px;
  border: 1px solid rgba(14, 165, 233, 0.25);
  box-shadow: 0 4px 0 0 rgba(14, 165, 233, 0.12), 0 24px 48px rgba(15, 23, 42, 0.15);
}
.register-role-modal-brand--triple {
  flex-shrink: 0;
}
.register-triple-row {
  display: flex;
  flex: 0 1 auto;
  min-width: 0;
  padding: 0 1rem 1.5rem;
}
.register-modal-container {
  flex: 1 1 0;
  min-width: 280px;
  display: flex;
  flex-direction: column;
  padding: 1.5rem 1.25rem;
  border-right: 1px solid rgba(14, 165, 233, 0.15);
}
.register-modal-container:last-child {
  border-right: none;
}
.register-modal-container--triple {
  flex: 1 1 0;
  min-width: 0;
  max-width: none;
}
.register-modal-container--triple .register-role-card {
  display: flex;
  flex-direction: column;
  flex: 0 1 auto;
  min-height: 0;
}
@media (max-width: 900px) {
  .register-triple-row {
    flex-direction: column;
  }
  .register-modal-container {
    min-width: 100%;
    border-right: none;
    border-bottom: 1px solid rgba(14, 165, 233, 0.15);
  }
  .register-modal-container:last-child {
    border-bottom: none;
  }
  .register-modal-container--triple {
    flex: 1 1 auto;
  }
}

@media (max-width: 600px) {
  .register-triple-modal {
    border-radius: 18px;
    background: linear-gradient(180deg, #ffffff 0%, #f7fbff 100%);
    max-height: 88vh;
    overflow: hidden;
  }
  .register-role-modal-brand {
    padding: 1.25rem 1.25rem 0.85rem;
  }
  .register-role-modal-logo {
    height: 44px;
    margin-bottom: 0.75rem;
  }
  .register-role-modal-tagline {
    font-size: 0.9rem;
    margin-bottom: 0.75rem;
  }
  .register-role-modal-title {
    font-size: 1.2rem;
  }
  .register-triple-row {
    display: flex;
    flex-direction: column;
    gap: 0.9rem;
    padding: 0 1rem 1.25rem;
    overflow-y: auto;
    -webkit-overflow-scrolling: touch;
    max-height: 60vh;
  }
  .register-modal-container {
    padding: 0;
    border: none;
  }
  .register-role-card {
    border-radius: 18px;
    box-shadow: 0 10px 24px rgba(15, 23, 42, 0.1);
    border: 1px solid rgba(226, 232, 240, 0.9);
  }
  .register-role-card-image-wrap {
    aspect-ratio: 16 / 9;
    min-height: 160px;
    border-bottom: 1px solid rgba(226, 232, 240, 0.8);
  }
  .register-role-card-image {
    object-fit: cover;
  }
  .register-role-card-badge {
    font-size: 0.9rem;
    padding: 0.45rem 0.8rem;
    border-radius: 12px;
    left: 1rem;
    right: auto;
  }
  .register-role-card-desc {
    font-size: 0.9rem;
    margin: 0.75rem 1rem 0.4rem;
    min-height: auto;
  }
  .register-role-card-cta {
    display: block;
    width: calc(100% - 2rem);
    margin: 0 1rem 1rem;
    font-size: 0.88rem;
    padding: 0.65rem 0.9rem;
    border-radius: 12px;
    text-transform: none;
    letter-spacing: 0.02em;
  }
}
.register-role-modal-brand {
  padding: 2.25rem 2rem 1.5rem;
  text-align: center;
}
.register-role-modal-logo {
  height: 56px;
  width: auto;
  max-width: 200px;
  object-fit: contain;
  display: block;
  margin: 0 auto 1rem;
}
.register-role-modal-tagline {
  font-size: 1rem;
  color: var(--text-secondary);
  margin: 0 0 1.25rem;
  line-height: 1.45;
}
.register-role-modal-title {
  font-size: 1.5rem;
  font-weight: 700;
  color: var(--trust-blue);
  margin: 0;
  letter-spacing: -0.02em;
  line-height: 1.3;
}
.register-role-card {
  display: flex;
  flex-direction: column;
  align-items: stretch;
  text-align: left;
  background: #fff;
  border: 1px solid rgba(14, 165, 233, 0.2);
  border-radius: 20px;
  overflow: hidden;
  cursor: pointer;
  transition: border-color 0.2s, box-shadow 0.2s;
  padding: 0;
  box-shadow: 0 2px 12px rgba(14, 165, 233, 0.08);
}
.register-triple-modal .register-role-card {
  overflow: hidden;
}
.register-role-card:hover {
  border-color: rgba(14, 165, 233, 0.5);
  box-shadow: 0 6px 24px rgba(14, 165, 233, 0.14);
}
.register-role-card--renter {
  border-top: 2px solid rgba(45, 58, 82, 0.25);
}
.register-role-card--renter:hover {
  border-top-color: rgba(45, 58, 82, 0.4);
}
.register-role-card--car-owner {
  border-top: 2px solid rgba(4, 120, 87, 0.25);
}
.register-role-card--car-owner:hover {
  border-top-color: rgba(4, 120, 87, 0.4);
}
.register-role-card-image-wrap {
  position: relative;
  width: 100%;
  aspect-ratio: 16 / 10;
  min-height: 200px;
  flex-shrink: 0;
  overflow: hidden;
  background: #e2e8f0;
}
.register-role-card-logo-wrap {
  position: absolute;
  top: 0.5rem;
  left: 0.5rem;
  z-index: 1;
  padding: 0.35rem 0.5rem;
  background: #fff;
  border-radius: 8px;
  box-shadow: 0 1px 3px rgba(0, 0, 0, 0.12);
  pointer-events: none;
}
.register-role-card-logo {
  display: block;
  height: 32px;
  width: auto;
  max-width: 88px;
  object-fit: contain;
}
.register-role-card-image {
  width: 100%;
  height: 100%;
  object-fit: contain;
  object-position: center center;
  display: block;
}
.register-role-card-badge {
  position: absolute;
  bottom: 0.75rem;
  left: 0.75rem;
  right: 0.75rem;
  padding: 0.5rem 0.75rem;
  background: rgba(15, 23, 42, 0.88);
  color: #fff;
  font-size: 1rem;
  font-weight: 700;
  letter-spacing: 0.02em;
  border-radius: 10px;
  text-align: center;
}
.register-role-card-desc {
  font-size: 0.9375rem;
  color: #475569;
  line-height: 1.5;
  margin: 1rem 1rem 0.5rem;
  padding: 0;
  min-height: 3.75rem;
  flex: 1 0 auto;
}
.register-role-card-cta {
  font-size: 0.9375rem;
  font-weight: 600;
  margin: 0 1rem 1rem;
  padding: 0.5rem 1rem;
  flex-shrink: 0;
  display: inline-block;
  text-align: center;
  border-radius: 9999px;
  color: #fff;
  border: 1px solid rgba(255, 255, 255, 0.12);
  box-shadow:
    0 1px 0 0 rgba(255, 255, 255, 0.08) inset,
    0 -1px 0 0 rgba(0, 0, 0, 0.35) inset,
    0 2px 4px rgba(0, 0, 0, 0.3);
  text-shadow: 0 1px 1px rgba(0, 0, 0, 0.3);
  transition: filter 0.2s, box-shadow 0.2s;
}
.register-role-card--renter .register-role-card-cta {
  background: linear-gradient(145deg, #2d3a52 0%, #1e3a5f 25%, #0f172a 50%, #1e3a5f 75%, #2d3a52 100%);
}
.register-role-card--car-owner .register-role-card-cta {
  background: linear-gradient(145deg, #2d5a4a 0%, #1e4d3c 25%, #0f3329 50%, #1e4d3c 75%, #2d5a4a 100%);
}
.register-role-card:hover .register-role-card-cta {
  filter: brightness(1.08);
  box-shadow:
    0 1px 0 0 rgba(255, 255, 255, 0.1) inset,
    0 -1px 0 0 rgba(0, 0, 0, 0.3) inset,
    0 3px 8px rgba(0, 0, 0, 0.35);
}
</style>

<style>
/* Overlay/content sizing – applied by parent or global */
.register-triple-dialog :deep(.v-overlay__content) {
  max-width: 1400px;
  width: 96vw;
  max-height: 95vh;
  overflow-y: auto;
  overflow-x: hidden;
  display: flex;
  align-items: flex-start;
  justify-content: center;
  padding: 1rem;
  box-sizing: border-box;
}
.register-triple-dialog :deep(.v-overlay__content) > * {
  max-width: 100%;
  min-width: 0;
  flex-shrink: 0;
}

@media (max-width: 600px) {
  .register-triple-dialog :deep(.v-overlay__content) {
    width: 100vw;
    max-width: 100vw;
    max-height: 100vh;
    padding: 0.5rem;
  }
}
</style>
