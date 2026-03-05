import { onMounted, onBeforeUnmount, type Ref } from 'vue'

export interface UseGsapStaggerOptions {
  /** Selector for direct children or elements to stagger (default: direct children) */
  selector?: string
  /** Parent selector; if not set, uses rootRef children */
  parentSelector?: string
  /** Y offset from (default: 16) */
  y?: number
  /** Duration per element (default: 0.4) */
  duration?: number
  /** Delay between elements in seconds (default: 0.05) */
  stagger?: number
  /** Ease (default: 'power2.out') */
  ease?: string
  /** Initial opacity (default: 0) */
  fromOpacity?: number
}

/**
 * Stagger animate elements on mount (no scroll). Respects prefers-reduced-motion.
 */
export function useGsapStagger(rootRef: Ref<HTMLElement | null>, options: UseGsapStaggerOptions = {}) {
  const {
    selector,
    parentSelector,
    y = 16,
    duration = 0.4,
    stagger = 0.05,
    ease = 'power2.out',
    fromOpacity = 0,
  } = options

  let ctx: gsap.Context | null = null

  onMounted(() => {
    if (!rootRef.value) return
    void run()
  })

  onBeforeUnmount(() => {
    ctx?.revert()
    ctx = null
  })

  async function run() {
    if (!rootRef.value) return
    const [{ default: gsap }] = await Promise.all([import('gsap')])

    const parent = parentSelector
      ? rootRef.value.querySelector<HTMLElement>(parentSelector)
      : rootRef.value
    if (!parent) return

    const targets = selector
      ? gsap.utils.toArray<HTMLElement>(selector, parent)
      : (Array.from(parent.children) as HTMLElement[]).filter((el) => el.nodeType === 1)
    if (!targets.length) return

    const showAll = () => {
      gsap.set(targets, { autoAlpha: 1, y: 0 })
    }

    if (window.matchMedia('(prefers-reduced-motion: reduce)').matches) {
      showAll()
      return
    }

    try {
      ctx = gsap.context(() => {
        gsap.set(targets, { autoAlpha: fromOpacity, y })
        gsap.to(targets, {
          autoAlpha: 1,
          y: 0,
          duration,
          stagger,
          ease,
          overwrite: true,
        })
      }, rootRef.value)
    } catch {
      showAll()
    }
  }
}
