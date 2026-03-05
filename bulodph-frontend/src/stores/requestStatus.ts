import { defineStore } from 'pinia'
import { computed, ref } from 'vue'

export const useRequestStatusStore = defineStore('requestStatus', () => {
  const activeRequests = ref(0)

  function start() {
    activeRequests.value += 1
  }

  function end() {
    activeRequests.value = Math.max(0, activeRequests.value - 1)
  }

  const isLoading = computed(() => activeRequests.value > 0)

  return { activeRequests, isLoading, start, end }
})
