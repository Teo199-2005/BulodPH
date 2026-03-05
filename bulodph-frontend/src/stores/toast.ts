import { defineStore } from 'pinia'
import { ref } from 'vue'

export interface Toast {
  id: number
  message: string
  type: 'success' | 'error' | 'warning' | 'info'
  duration?: number
  /** Optional role for accent (client/car_owner/marketing_staff/admin) */
  role?: string
  action?: {
    text: string
    onClick: () => void
  }
}

export interface UndoToastOptions {
  message: string
  onUndo: () => void
  duration?: number
}

export const useToastStore = defineStore('toast', () => {
  const toasts = ref<Toast[]>([])
  let nextId = 1

  const show = (
    message: string,
    type: Toast['type'] = 'info',
    duration = 5000,
    action?: Toast['action'],
    role?: string
  ) => {
    const id = nextId++
    const toast: Toast = {
      id,
      message,
      type,
      duration,
      role,
      action,
    }

    toasts.value.push(toast)

    if (duration > 0) {
      setTimeout(() => {
        dismiss(id)
      }, duration)
    }

    return id
  }

  const success = (message: string, duration?: number, action?: Toast['action'], role?: string) => {
    return show(message, 'success', duration, action, role)
  }

  const error = (message: string, duration?: number, action?: Toast['action'], role?: string) => {
    return show(message, 'error', duration, action, role)
  }

  const warning = (message: string, duration?: number, action?: Toast['action'], role?: string) => {
    return show(message, 'warning', duration, action, role)
  }

  const info = (message: string, duration?: number, action?: Toast['action'], role?: string) => {
    return show(message, 'info', duration, action, role)
  }

  const dismiss = (id: number) => {
    const index = toasts.value.findIndex(t => t.id === id)
    if (index !== -1) {
      toasts.value.splice(index, 1)
    }
  }

  const dismissAll = () => {
    toasts.value = []
  }

  /** Show a toast with Undo action for destructive operations (e.g. delete, remove). */
  const undo = (options: UndoToastOptions) => {
    const { message, onUndo, duration = 6000 } = options
    return show(message, 'info', duration, {
      text: 'Undo',
      onClick: onUndo,
    })
  }

  return {
    toasts,
    show,
    success,
    error,
    warning,
    info,
    undo,
    dismiss,
    dismissAll,
  }
})

