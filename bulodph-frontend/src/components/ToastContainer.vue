<template>
  <Teleport to="body">
    <div class="hpa-toast-container hpa-toast-stack" aria-live="polite">
      <template v-for="toast in toasts" :key="toast.id">
        <Transition name="toast-transition">
          <div
            v-if="toastStates[toast.id] !== false"
            class="hpa-toast"
            :class="[`hpa-toast--${toast.type}`, { 'hpa-toast--role': toast.role }]"
            :style="toast.role ? { '--toast-role-primary': getRoleColors(toast.role).primary } : undefined"
            role="alert"
          >
            <div class="hpa-toast__inner">
              <div class="hpa-toast__icon-wrap">
                <v-icon :icon="getToastIcon(toast.type)" class="hpa-toast__icon" size="22" />
              </div>
              <span class="hpa-toast__message">{{ toast.message }}</span>
              <div class="hpa-toast__actions">
                <v-btn
                  v-if="toast.action"
                  variant="text"
                  size="small"
                  class="hpa-toast__action"
                  @click="handleAction(toast)"
                >
                  {{ toast.action.text }}
                </v-btn>
                <v-btn
                  icon="mdi-close"
                  variant="text"
                  size="x-small"
                  class="hpa-toast__close"
                  @click="dismissToast(toast.id)"
                />
              </div>
            </div>
          </div>
        </Transition>
      </template>
    </div>
  </Teleport>
</template>

<script setup lang="ts">
import { ref, watch, computed } from 'vue'
import { useToastStore } from '@/stores/toast'
import { getRoleColors } from '@/constants/roleColors'
import type { Toast } from '@/stores/toast'

const toastStore = useToastStore()
const toasts = computed(() => toastStore.toasts)
const toastStates = ref<Record<number, boolean>>({})

watch(
  toasts,
  (newToasts) => {
    newToasts.forEach(toast => {
      if (!(toast.id in toastStates.value)) {
        toastStates.value[toast.id] = true
      }
    })
  },
  { deep: true, immediate: true }
)

const getToastIcon = (type: Toast['type']) => {
  const icons: Record<Toast['type'], string> = {
    success: 'mdi-check-circle',
    error: 'mdi-alert-circle',
    warning: 'mdi-alert',
    info: 'mdi-information',
  }
  return icons[type]
}

const dismissToast = (id: number) => {
  toastStates.value[id] = false
  setTimeout(() => {
    toastStore.dismiss(id)
    delete toastStates.value[id]
  }, 320)
}

const handleAction = (toast: Toast) => {
  if (toast.action) {
    toast.action.onClick()
    dismissToast(toast.id)
  }
}
</script>

<style scoped>
.hpa-toast-container {
  position: fixed;
  top: 20px;
  right: 20px;
  z-index: 9999;
  display: flex;
  flex-direction: column;
  gap: 10px;
  max-width: 420px;
  pointer-events: none;
}

.hpa-toast {
  pointer-events: auto;
  min-width: 320px;
  max-width: 420px;
  border-radius: var(--radius-lg, 16px);
  background: rgba(255, 255, 255, 0.9);
  backdrop-filter: blur(16px);
  -webkit-backdrop-filter: blur(16px);
  border: 1px solid rgba(255, 255, 255, 0.6);
  box-shadow: var(--shadow-lg, 0 8px 24px rgba(0,0,0,0.12)), 0 1px 3px rgba(255, 255, 255, 0.5) inset;
  overflow: hidden;
}

.hpa-toast__inner {
  display: flex;
  align-items: center;
  gap: 12px;
  padding: 14px 16px;
}

.hpa-toast__icon-wrap {
  width: 40px;
  height: 40px;
  border-radius: var(--radius-md, 12px);
  display: flex;
  align-items: center;
  justify-content: center;
  flex-shrink: 0;
}

.hpa-toast--success .hpa-toast__icon-wrap {
  background: rgba(16, 185, 129, 0.12);
  color: #059669;
}

.hpa-toast--error .hpa-toast__icon-wrap {
  background: rgba(239, 68, 68, 0.12);
  color: #dc2626;
}

.hpa-toast--warning .hpa-toast__icon-wrap {
  background: rgba(245, 158, 11, 0.12);
  color: #d97706;
}

.hpa-toast--info .hpa-toast__icon-wrap {
  background: rgba(30, 58, 95, 0.12);
  color: var(--role-primary);
}

.hpa-toast__message {
  flex: 1;
  font-size: 0.9375rem;
  font-weight: 500;
  line-height: 1.4;
  color: var(--text-primary, #0f172a);
  min-width: 0;
}

.hpa-toast__actions {
  display: flex;
  align-items: center;
  gap: 4px;
  flex-shrink: 0;
}

.hpa-toast__action {
  text-transform: none;
  font-weight: 600;
  color: var(--role-primary) !important;
}

.hpa-toast__close {
  color: var(--text-muted, #94a3b8) !important;
}

.hpa-toast--role {
  border-left: 4px solid var(--toast-role-primary, #1e3a5f);
}
</style>

<style>
.toast-transition-enter-active,
.toast-transition-leave-active {
  transition: opacity 0.3s ease, transform 0.3s ease;
}

.toast-transition-enter-from {
  opacity: 0;
  transform: translateX(120%);
}

.toast-transition-leave-to {
  opacity: 0;
  transform: translateX(120%);
}

.toast-transition-enter-to,
.toast-transition-leave-from {
  opacity: 1;
  transform: translateX(0);
}
</style>
