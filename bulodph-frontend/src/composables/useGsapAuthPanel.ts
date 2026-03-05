import { onMounted, onBeforeUnmount, type Ref } from 'vue'

export interface UseGsapAuthPanelOptions {
  y?: number
  duration?: number
  delay?: number
  ease?: string
}

/**
 * Animate auth panel (login/register form card) on mount: fade + slide up.
 * Respects prefers-reduced-motion.
 */
export function useGsapAuthPanel(panelRef: Ref<HTMLElement | null>, options: UseGsapAuthPanelOptions = {}) {
  const { y = 16, duration = 0.5, delay = 0.1, ease = 'power2.out' } = options
  let ctx: gsap.Context | null = null

  onMounted(() => {
    if (!panelRef.value) return
    void run()
  })

  onBeforeUnmount(() => {
    ctx?.revert()
    ctx = null
  })

  async function run() {
    if (!panelRef.value) return
    const [{ default: gsap }] = await Promise.all([import('gsap')])

    if (window.matchMedia('(prefers-reduced-motion: reduce)').matches) {
      gsap.set(panelRef.value, { opacity: 1, y: 0 })
      return
    }

    try {
      ctx = gsap.context(() => {
        gsap.fromTo(
          panelRef.value,
          { opacity: 0, y },
          { opacity: 1, y: 0, duration, delay, ease, overwrite: true }
        )
      }, panelRef.value)
    } catch {
      gsap.set(panelRef.value, { opacity: 1, y: 0 })
    }
  }
}
