import { ref } from 'vue'

/**
 * Pull-to-refresh composable for mobile lists.
 * Attach to a scrollable container and call onRefresh when user pulls down.
 */
export function usePullToRefresh(onRefresh: () => Promise<void> | void) {
  const isPulling = ref(false)
  const pullDistance = ref(0)
  const startY = ref(0)

  const threshold = 80
  const maxPull = 120

  function handleTouchStart(e: TouchEvent) {
    startY.value = e.touches[0].clientY
    isPulling.value = true
    pullDistance.value = 0
  }

  function handleTouchMove(e: TouchEvent) {
    if (!isPulling.value) return
    const el = e.target as HTMLElement
    if (el.scrollTop > 0) {
      isPulling.value = false
      pullDistance.value = 0
      return
    }
    const diff = e.touches[0].clientY - startY.value
    if (diff > 0) {
      pullDistance.value = Math.min(diff * 0.5, maxPull)
    }
  }

  async function handleTouchEnd() {
    if (pullDistance.value >= threshold) {
      pullDistance.value = 0
      isPulling.value = false
      await Promise.resolve(onRefresh())
    } else {
      pullDistance.value = 0
      isPulling.value = false
    }
  }

  function attach(el: HTMLElement) {
    el.addEventListener('touchstart', handleTouchStart, { passive: true })
    el.addEventListener('touchmove', handleTouchMove, { passive: true })
    el.addEventListener('touchend', handleTouchEnd)
    return () => {
      el.removeEventListener('touchstart', handleTouchStart)
      el.removeEventListener('touchmove', handleTouchMove)
      el.removeEventListener('touchend', handleTouchEnd)
    }
  }

  return { isPulling, pullDistance, threshold, attach }
}
