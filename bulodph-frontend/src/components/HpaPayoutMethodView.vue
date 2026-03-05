<template>
  <DashboardTemplate
    title="Payout method"
    subtitle="Receive payouts via GCash, Maya or bank"
    :animate="true"
    :back-to="backTo"
    back-label="Back"
  >
    <h3 class="heading-section mb-3">Current method</h3>
    <div class="payment-method-cards mb-4">
      <div
        v-for="pm in savedMethods"
        :key="pm.id"
        class="payment-method-card"
        :class="[
          `payment-method-card--${pm.method}`,
          { 'payment-method-card--active': pm.isDefault }
        ]"
      >
        <div class="payment-method-card__inner">
          <div class="payment-method-card__top">
            <div class="payment-method-card__chip" aria-hidden="true">
              <div class="payment-method-card__chip-lines">
                <span v-for="i in 6" :key="i" />
              </div>
            </div>
            <div class="payment-method-card__logo-wrap">
              <v-img :src="getMethodLogo(pm.method)" height="28" width="28" contain alt="" />
            </div>
          </div>
          <div class="payment-method-card__divider" />
          <div class="payment-method-card__number">
            <span class="payment-method-card__number-mask">····</span>
            <span class="payment-method-card__number-visible">{{ pm.suffix }}</span>
          </div>
          <div class="payment-method-card__bottom">
            <span class="payment-method-card__label">{{ pm.label }}</span>
            <span v-if="pm.isDefault" class="payment-method-card__active-badge">Default</span>
          </div>
        </div>
      </div>
    </div>

    <div class="payout-maintenance-wrap">
      <v-card elevation="0" rounded="lg" class="modern-card section-card-accent payout-maintenance-card">
        <v-card-text class="pa-4">
          <h3 class="heading-section mb-3">Update payout method</h3>
          <v-radio-group v-model="method" label="Receive payouts via" hide-details class="mb-3">
            <v-radio value="gcash">
              <template #label>
                <span class="d-inline-flex align-center gap-2">
                  <v-img :src="IMAGES.payments.gcash" height="24" width="24" contain class="flex-shrink-0" alt="" />
                  GCash
                </span>
              </template>
            </v-radio>
            <v-radio value="maya">
              <template #label>
                <span class="d-inline-flex align-center gap-2">
                  <v-img :src="IMAGES.payments.maya" height="24" width="24" contain class="flex-shrink-0" alt="" />
                  Maya
                </span>
              </template>
            </v-radio>
            <v-radio value="bank">
              <template #label>
                <span class="d-inline-flex align-center gap-2">
                  <v-img :src="IMAGES.payments.bpi" height="24" width="32" contain class="flex-shrink-0" alt="" />
                  Bank account (e.g. BPI)
                </span>
              </template>
            </v-radio>
          </v-radio-group>
          <v-text-field
            v-if="method !== 'bank'"
            :model-value="mobile"
            @update:model-value="(v) => mobile = formatInput(v, 'phone')"
            :label="method === 'gcash' ? 'GCash mobile number' : 'Maya mobile number'"
            placeholder="09XX XXX XXXX"
            variant="outlined"
            class="mb-3"
          />
          <template v-else>
            <v-text-field :model-value="bankName" @update:model-value="(v) => bankName = formatInput(v, 'letters')" label="Bank name" variant="outlined" class="mb-3" />
            <v-text-field :model-value="accountNumber" @update:model-value="(v) => accountNumber = formatInput(v, 'numbers')" label="Account number" variant="outlined" class="mb-3" />
            <v-text-field :model-value="accountName" @update:model-value="(v) => accountName = formatInput(v, 'letters')" label="Account name" variant="outlined" class="mb-3" />
          </template>
          <v-btn color="primary" rounded="lg" @click="save">Save</v-btn>
        </v-card-text>
        <div class="payout-maintenance-overlay">
          <v-chip color="warning" variant="tonal" size="small" prepend-icon="mdi-wrench" class="payout-maintenance-chip">Under maintenance</v-chip>
          <v-tooltip location="bottom">
            <template #activator="{ props: tooltipProps }">
              <v-btn
                v-bind="tooltipProps"
                icon="mdi-help-circle-outline"
                variant="tonal"
                size="small"
                class="payout-maintenance-help"
                aria-label="Why is this unavailable?"
                @click="showMaintenanceModal = true"
              />
            </template>
            Why is this unavailable?
          </v-tooltip>
        </div>
      </v-card>
    </div>

    <HpaModal
      v-model="showMaintenanceModal"
      title="Why isn't this available?"
      icon="mdi-wrench-clock-outline"
      max-width="440"
      persistent
      :show-actions="true"
      confirm-text="Got it"
      hide-cancel
      @confirm="showMaintenanceModal = false"
    >
      <p class="text-body-2 mb-0">
        Payout methods (GCash, Maya, bank) are currently <strong>under maintenance</strong>. We're working on full integration.
      </p>
      <p class="text-body-2 mt-3 mb-0">
        You can still request payouts from your Earnings page; we'll contact you for payment details. Full integration is coming soon.
      </p>
    </HpaModal>
  </DashboardTemplate>
</template>

<script setup lang="ts">
import type { RouteLocationRaw } from 'vue-router'
import { ref, onMounted } from 'vue'
import DashboardTemplate from '@/components/DashboardTemplate.vue'
import HpaModal from '@/components/base/HpaModal.vue'
import { useToastStore } from '@/stores/toast'
import { IMAGES } from '@/constants/images'
import { getUserScopedItem, setUserScopedItem } from '@/utils/userScopedStorage'
import { formatInput } from '@/utils/inputFormatters'

const props = withDefaults(
  defineProps<{
    /** Route for back link */
    backTo: RouteLocationRaw
    /** If set, persist methods to storage (disabled for security) */
    storageKey?: string
  }>(),
  { storageKey: undefined }
)

const STORAGE_KEY = 'bulodph_payout_methods'
const toast = useToastStore()
const showMaintenanceModal = ref(false)
const method = ref<'gcash' | 'maya' | 'bank'>('gcash')
const mobile = ref('0917 123 4567')
const bankName = ref('')
const accountNumber = ref('')
const accountName = ref('')

type MethodKey = 'gcash' | 'maya' | 'bank'
interface SavedMethod {
  id: string
  method: MethodKey
  suffix: string
  label: string
  isDefault: boolean
}

const DEFAULT_METHODS: SavedMethod[] = [
  { id: '1', method: 'gcash', suffix: '4567', label: 'GCash', isDefault: true },
  { id: '2', method: 'maya', suffix: '8901', label: 'Maya', isDefault: false },
]

function loadSavedMethods(): SavedMethod[] {
  const stored = getUserScopedItem<SavedMethod[]>(STORAGE_KEY)
  return Array.isArray(stored) && stored.length ? stored : [...DEFAULT_METHODS]
}

const savedMethods = ref<SavedMethod[]>(loadSavedMethods())

onMounted(() => {
  savedMethods.value = loadSavedMethods()
})

function getMethodLogo(m: MethodKey): string {
  if (m === 'gcash') return IMAGES.payments.gcash
  if (m === 'maya') return IMAGES.payments.maya
  return IMAGES.payments.bpi
}

function save() {
  const suffix = method.value !== 'bank' ? mobile.value.slice(-4) : accountNumber.value.slice(-4)
  const label = method.value === 'gcash' ? 'GCash' : method.value === 'maya' ? 'Maya' : bankName.value || 'Bank'
  const newEntry: SavedMethod = {
    id: String(Date.now()),
    method: method.value,
    suffix,
    label,
    isDefault: savedMethods.value.length === 0,
  }
  savedMethods.value = [...savedMethods.value.filter((m) => !m.isDefault), newEntry]
  if (savedMethods.value.length === 1) savedMethods.value[0].isDefault = true
  setUserScopedItem(STORAGE_KEY, savedMethods.value)
  toast.success('Payout method updated.')
}
</script>

<style scoped>
.payment-method-cards {
  display: flex;
  flex-wrap: wrap;
  gap: var(--space-4, 16px);
}
.payment-method-card {
  width: 100%;
  max-width: 280px;
  border-radius: 14px;
  overflow: hidden;
  min-height: 150px;
  position: relative;
  box-shadow: 0 6px 20px rgba(0, 0, 0, 0.1), 0 2px 6px rgba(0, 0, 0, 0.06);
  transition: box-shadow 0.2s ease, transform 0.2s ease;
}
.payment-method-card--active {
  box-shadow: 0 0 0 2px rgba(255, 255, 255, 0.9), 0 8px 24px rgba(0, 0, 0, 0.14);
  transform: scale(1.02);
}
.payment-method-card__inner {
  padding: var(--space-4, 16px) 18px;
  min-height: 150px;
  display: flex;
  flex-direction: column;
  justify-content: space-between;
}
.payment-method-card--gcash {
  background: linear-gradient(135deg, #002f6c 0%, #0047ab 45%, #0066cc 100%);
  color: rgba(255, 255, 255, 0.95);
}
.payment-method-card--gcash .payment-method-card__divider {
  background: linear-gradient(90deg, transparent 0%, rgba(255,255,255,0.35) 20%, rgba(255,255,255,0.35) 80%, transparent 100%);
}
.payment-method-card--maya {
  background: linear-gradient(135deg, #006b5a 0%, #00a896 50%, #00c9b7 100%);
  color: rgba(255, 255, 255, 0.95);
}
.payment-method-card--maya .payment-method-card__divider {
  background: linear-gradient(90deg, transparent 0%, rgba(255,255,255,0.35) 20%, rgba(255,255,255,0.35) 80%, transparent 100%);
}
.payment-method-card--bank {
  background: linear-gradient(135deg, #8b0000 0%, #b22222 50%, #c41e3a 100%);
  color: rgba(255, 255, 255, 0.95);
}
.payment-method-card--bank .payment-method-card__divider {
  background: linear-gradient(90deg, transparent 0%, rgba(255,255,255,0.35) 20%, rgba(255,255,255,0.35) 80%, transparent 100%);
}
.payment-method-card__top {
  display: flex;
  align-items: flex-start;
  justify-content: space-between;
}
.payment-method-card__chip {
  width: 36px;
  height: 28px;
  border-radius: 5px;
  background: linear-gradient(145deg, rgba(255,255,255,0.4) 0%, rgba(255,255,255,0.15) 100%);
  border: 1px solid rgba(255,255,255,0.25);
  overflow: hidden;
  position: relative;
}
.payment-method-card__chip-lines {
  position: absolute;
  inset: 0;
  display: flex;
  flex-direction: column;
  justify-content: space-evenly;
  padding: 0 3px;
}
.payment-method-card__chip-lines span {
  display: block;
  height: 1.5px;
  background: rgba(255,255,255,0.5);
  border-radius: 1px;
}
.payment-method-card__logo-wrap {
  background: rgba(255, 255, 255, 0.95);
  border-radius: 8px;
  padding: 6px;
  display: flex;
  align-items: center;
  justify-content: center;
}
.payment-method-card__divider {
  height: 1px;
  margin: 10px 0 12px;
  border-radius: 1px;
}
.payment-method-card__number {
  font-family: var(--font-mono), 'SF Mono', Monaco, Consolas, monospace;
  font-size: 0.95rem;
  letter-spacing: 0.15em;
  font-weight: 500;
}
.payment-method-card__number-mask {
  opacity: 0.85;
  margin-right: 0.1em;
}
.payment-method-card__number-visible {
  letter-spacing: 0.12em;
  margin-left: 0.1em;
}
.payment-method-card__bottom {
  display: flex;
  align-items: center;
  justify-content: space-between;
  font-size: 0.75rem;
  text-transform: uppercase;
  letter-spacing: 0.04em;
}
.payment-method-card__label {
  opacity: 0.9;
}
.payment-method-card__active-badge {
  background: rgba(255, 255, 255, 0.35);
  padding: 3px 8px;
  border-radius: 6px;
  font-weight: 700;
  font-size: 0.7rem;
}

/* Payout methods under maintenance */
.payout-maintenance-wrap {
  position: relative;
}
.payout-maintenance-card {
  position: relative;
  filter: grayscale(0.7);
  opacity: 0.88;
  pointer-events: none;
}
.payout-maintenance-card .payout-maintenance-overlay {
  pointer-events: auto;
}
.payout-maintenance-overlay {
  position: absolute;
  inset: 0;
  background: rgba(255, 255, 255, 0.7);
  border-radius: inherit;
  display: flex;
  align-items: center;
  justify-content: center;
  gap: 0.75rem;
  padding: 0.5rem;
}
.payout-maintenance-chip {
  flex-shrink: 0;
}
.payout-maintenance-help {
  flex-shrink: 0;
}
</style>
