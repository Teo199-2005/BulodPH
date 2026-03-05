<template>
  <v-dialog
    v-model="isOpen"
    :max-width="maxWidth"
    :persistent="persistent"
    :scrollable="scrollable"
    transition="modal-transition"
    content-class="hpa-modal__content"
    overlay-opacity="0.4"
    scrim="rgba(15, 23, 42, 0.4)"
    class="hpa-modal-overlay"
    @click:outside="!persistent && close()"
  >
    <v-card
      ref="modalCardRef"
      :loading="loading"
      rounded="xl"
      class="hpa-modal-card"
      :class="[variantClass, { 'hpa-modal--role': role }]"
      :style="modalRoleStyle"
      elevation="0"
    >
      <!-- Header -->
      <div class="hpa-modal__header-wrap">
        <div class="hpa-modal__header d-flex align-center justify-space-between">
          <div class="d-flex align-center hpa-modal__header-title-row">
            <div v-if="icon" class="hpa-modal__header-icon">
              <v-icon :icon="icon" size="20" />
            </div>
            <span class="hpa-modal__title">{{ title }}</span>
          </div>
          <v-tooltip v-if="!persistent" location="bottom">
            <template #activator="{ props: tooltipProps }">
              <v-btn
                v-bind="tooltipProps"
                icon="mdi-close"
                variant="text"
                size="small"
                density="compact"
                class="hpa-modal__close"
                aria-label="Close modal"
                @click="close"
              />
            </template>
            Close
          </v-tooltip>
        </div>
      </div>

      <!-- Content -->
      <v-card-text class="hpa-modal__body">
        <slot />
      </v-card-text>

      <!-- Actions -->
      <div v-if="showActions" class="hpa-modal__actions-wrap">
        <v-card-actions class="hpa-modal__actions">
        <slot name="actions">
          <v-spacer />
          <v-btn
            v-if="!hideCancel"
            variant="text"
            class="hpa-modal__btn-cancel"
            rounded="lg"
            density="compact"
            @click="close"
          >
            {{ cancelText }}
          </v-btn>
          <v-btn
            :color="role ? undefined : variantButtonColor"
            variant="flat"
            class="hpa-modal__btn-confirm"
            :style="role ? { background: roleColors?.gradient, color: '#fff' } : undefined"
            rounded="lg"
            density="compact"
            :loading="loading"
            :disabled="confirmDisabled"
            @click="onConfirmClick"
          >
            {{ confirmText }}
          </v-btn>
        </slot>
      </v-card-actions>
      </div>
    </v-card>
  </v-dialog>
</template>

<script setup lang="ts">
import { computed, ref, watch, nextTick, onBeforeUnmount } from 'vue'
import { getRoleColors } from '@/constants/roleColors'

export type ModalVariant = 'default' | 'danger' | 'success'

const modalCardRef = ref<HTMLElement | null>(null)
let gsapCtx: { revert: () => void } | null = null

interface Props {
  modelValue: boolean
  title: string
  icon?: string
  maxWidth?: string | number
  persistent?: boolean
  scrollable?: boolean
  loading?: boolean
  showActions?: boolean
  confirmText?: string
  cancelText?: string
  confirmDisabled?: boolean
  /** When true, only the confirm button is shown (e.g. for Close / Got it dialogs). */
  hideCancel?: boolean
  variant?: ModalVariant
  /** When set, header accent and confirm button use role colors (client/car_owner/marketing_staff/admin) */
  role?: string
}

const props = withDefaults(defineProps<Props>(), {
  maxWidth: 600,
  persistent: false,
  scrollable: true,
  loading: false,
  showActions: true,
  confirmText: 'Confirm',
  cancelText: 'Cancel',
  hideCancel: false,
  variant: 'default',
})

const emit = defineEmits<{
  'update:modelValue': [value: boolean]
  'confirm': []
  'cancel': []
}>()

const isOpen = computed({
  get: () => props.modelValue,
  set: (value) => emit('update:modelValue', value)
})

const variantClass = computed(() => `hpa-modal--${props.variant}`)

const roleColors = computed(() => (props.role ? getRoleColors(props.role) : null))

const modalRoleStyle = computed(() => {
  const r = roleColors.value
  if (!r) return undefined
  return {
    '--modal-role-primary': r.primary,
    '--modal-role-gradient': r.gradient,
    '--modal-role-bg-tint': r.bgTint,
  } as Record<string, string>
})

const variantButtonColor = computed(() => {
  if (props.role) return undefined
  switch (props.variant) {
    case 'danger': return 'error'
    case 'success': return 'success'
    default: return 'primary'
  }
})

watch(
  () => props.modelValue,
  async (open) => {
    if (!open || !modalCardRef.value) return
    await nextTick()
    const el = modalCardRef.value
    if (!el) return
    if (window.matchMedia('(prefers-reduced-motion: reduce)').matches) return
    const { default: gsap } = await import('gsap')
    gsapCtx?.revert()
    gsapCtx = gsap.context(() => {
      gsap.fromTo(el, { opacity: 0, y: 12 }, { opacity: 1, y: 0, duration: 0.35, ease: 'power2.out', overwrite: true })
    }, el)
  },
  { immediate: false }
)

onBeforeUnmount(() => {
  gsapCtx?.revert()
  gsapCtx = null
})

const close = () => {
  emit('cancel')
  isOpen.value = false
}

const confirm = () => {
  emit('confirm')
}

/** When hideCancel is true, confirm button often acts as "Close" and should close the modal. */
const onConfirmClick = () => {
  emit('confirm')
  if (props.hideCancel) isOpen.value = false
}
</script>

<style scoped>
.hpa-modal-card {
  overflow: hidden;
  background: var(--surface-1, #f8fafc);
  border: none;
  box-shadow: var(--shadow-modal, 0 24px 48px rgba(15, 23, 42, 0.12)),
    0 0 0 1px rgba(15, 23, 42, 0.06);
  border-radius: var(--radius-xl, 20px);
  animation: modalEnter 0.4s cubic-bezier(0.34, 1.56, 0.64, 1);
}
@keyframes modalEnter {
  from {
    opacity: 0;
    transform: scale(0.95) translateY(-20px);
  }
  to {
    opacity: 1;
    transform: scale(1) translateY(0);
  }
}

/* Header: clean, no colored bars */
.hpa-modal__header-wrap {
  position: relative;
  background: rgba(255, 255, 255, 0.7) !important;
  padding: 0;
  border-radius: var(--radius-xl, 20px) var(--radius-xl, 20px) 0 0;
  border-bottom: 1px solid rgba(15, 23, 42, 0.06);
}
.hpa-modal__header-wrap::before {
  display: none;
}

.hpa-modal__header {
  padding: 1.25rem 1.5rem !important;
  min-height: auto;
  position: relative;
  z-index: 1;
}

.hpa-modal__header-icon {
  width: 42px;
  height: 42px;
  border-radius: var(--radius-md, 12px);
  display: flex;
  align-items: center;
  justify-content: center;
  flex-shrink: 0;
  background: linear-gradient(145deg, rgba(255, 255, 255, 0.95) 0%, rgba(248, 250, 252, 0.98) 100%);
  box-shadow: 0 2px 8px rgba(15, 23, 42, 0.1), 0 1px 0 rgba(255, 255, 255, 0.8) inset;
  border: 1px solid rgba(15, 23, 42, 0.08);
  transition: transform 0.2s ease, box-shadow 0.25s ease;
}
.hpa-modal__header-icon:hover {
  transform: scale(1.06);
  box-shadow: 0 4px 12px rgba(15, 23, 42, 0.12), 0 1px 0 rgba(255, 255, 255, 0.9) inset;
}

.hpa-modal__header-title-row {
  gap: 1rem;
}

.hpa-modal--default .hpa-modal__header-icon {
  color: var(--navy-light, #1e40af);
  background: linear-gradient(145deg, #eff6ff 0%, #dbeafe 100%);
  border-color: rgba(30, 64, 175, 0.15);
  box-shadow: 0 2px 8px rgba(30, 64, 175, 0.12), 0 1px 0 rgba(255, 255, 255, 0.8) inset;
}

.hpa-modal--danger .hpa-modal__header-icon {
  background: linear-gradient(145deg, #fef2f2 0%, #fee2e2 100%);
  color: #dc2626;
  border-color: rgba(220, 38, 38, 0.15);
}

.hpa-modal--success .hpa-modal__header-icon {
  background: linear-gradient(145deg, #ecfdf5 0%, #d1fae5 100%);
  color: #059669;
  border-color: rgba(5, 150, 105, 0.15);
}

.hpa-modal--role .hpa-modal__header-icon {
  background: var(--modal-role-bg-tint);
  color: var(--modal-role-primary);
  border-color: rgba(0, 0, 0, 0.06);
}

.hpa-modal__title {
  font-size: 1.125rem;
  font-weight: 700;
  color: var(--text-primary, #0f172a);
  letter-spacing: -0.025em;
  text-shadow: 0 0 0 transparent;
}

.hpa-modal__close {
  color: var(--text-muted, #94a3b8) !important;
  border-radius: var(--radius-sm, 8px);
  transition: background 0.2s, color 0.2s;
}

.hpa-modal__close:hover {
  background: rgba(15, 23, 42, 0.06) !important;
  color: var(--text-primary, #0f172a) !important;
}

/* Body: comfortable padding, no accent bar */
.hpa-modal__body {
  position: relative;
  padding: 1.75rem 1.5rem 1.25rem 1.5rem !important;
  color: var(--text-primary, #0f172a);
  font-size: var(--text-body-lg, 0.9375rem);
  line-height: 1.6;
  background: transparent;
}
.hpa-modal__body::before {
  display: none;
}

.hpa-modal__body :deep(p) {
  margin: 0 0 0.875rem;
  color: var(--text-secondary, #64748b);
  font-size: var(--text-body-lg, 0.9375rem);
  line-height: 1.65;
}

.hpa-modal__body :deep(p:last-child) {
  margin-bottom: 0;
}

.hpa-modal__body :deep(.v-field) {
  border-radius: var(--radius-md, 12px);
  --v-field-border-opacity: 0.6;
}

.hpa-modal__body :deep(.v-field--focused) {
  --v-field-border-opacity: 1;
  box-shadow: 0 0 0 2px rgba(30, 58, 95, 0.2);
}

.hpa-modal__body :deep(.v-field__outline) {
  --v-border-opacity: 0.5;
}

/* Actions: subtle separation */
.hpa-modal__actions-wrap {
  padding: 0;
  background: rgba(255, 255, 255, 0.6);
  border-top: 1px solid rgba(15, 23, 42, 0.06);
}

.hpa-modal__actions {
  padding: 1rem 1.5rem 1.25rem !important;
  min-height: auto;
  gap: 0.75rem;
}

.hpa-modal__btn-cancel {
  color: var(--text-secondary, #64748b) !important;
  text-transform: none;
  font-weight: 600;
  border-radius: var(--radius-md, 12px);
  padding-inline: 1.25rem;
  transition: transform 0.2s ease, box-shadow 0.2s ease, background 0.2s, color 0.2s;
}

.hpa-modal__btn-cancel:hover {
  background: rgba(15, 23, 42, 0.06) !important;
  color: var(--text-primary, #0f172a) !important;
  transform: translateY(-1px);
  box-shadow: 0 2px 8px rgba(15, 23, 42, 0.08);
}

.hpa-modal__btn-confirm {
  text-transform: none;
  font-weight: 600;
  border-radius: var(--radius-md, 12px);
  padding-inline: 1.5rem;
  box-shadow: 0 2px 10px rgba(30, 58, 95, 0.25), 0 1px 0 rgba(255, 255, 255, 0.3) inset;
  transition: transform 0.2s ease, box-shadow 0.25s ease;
}

.hpa-modal__btn-confirm:hover {
  box-shadow: 0 4px 16px rgba(30, 58, 95, 0.35), 0 2px 0 rgba(255, 255, 255, 0.25) inset;
  transform: translateY(-2px);
}
</style>

<style>
/* Backdrop: stronger blur and tint for focus */
.hpa-modal-overlay .v-overlay__scrim {
  backdrop-filter: blur(14px);
  -webkit-backdrop-filter: blur(14px);
  background: rgba(15, 23, 42, 0.45) !important;
}

.hpa-modal__content {
  align-items: center;
  justify-content: center;
  padding: 1.5rem;
}

.modal-transition-enter-active,
.modal-transition-leave-active {
  transition: opacity 0.35s cubic-bezier(0.34, 1.56, 0.64, 1), transform 0.35s cubic-bezier(0.34, 1.56, 0.64, 1);
}

.modal-transition-enter-from,
.modal-transition-leave-to {
  opacity: 0;
  transform: scale(0.96) translateY(-24px);
}

.modal-transition-enter-to,
.modal-transition-leave-from {
  opacity: 1;
  transform: scale(1) translateY(0);
}
</style>
