import { onMounted, onBeforeUnmount, type Ref } from 'vue'

export interface RevealOptions {
  selector?: string
  y?: number
  duration?: number
  stagger?: number
  start?: string
  /** If true, animate on mount without ScrollTrigger (for above-the-fold content) */
  immediate?: boolean
}

export function useGsapReveal(rootRef: Ref<HTMLElement | null>, options: RevealOptions = {}) {
  const {
    selector = '[data-reveal], .modern-card',
    y = 20,
    duration = 0.6,
    stagger = 0.08,
    start = 'top 85%',
    immediate = false,
  } = options

  let ctx: gsap.Context | null = null
  let revealTimeout: number | undefined

  onMounted(() => {
    if (!rootRef.value) return
    void initGsap()
  })

  onBeforeUnmount(() => {
    if (revealTimeout) window.clearTimeout(revealTimeout)
    ctx?.revert()
    ctx = null
  })

  async function initGsap() {
    if (!rootRef.value) return
    const [{ default: gsap }, { ScrollTrigger }] = await Promise.all([
      import('gsap'),
      import('gsap/ScrollTrigger'),
    ])
    gsap.registerPlugin(ScrollTrigger)
    const targets = gsap.utils.toArray<HTMLElement>(selector, rootRef.value)
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
        gsap.set(targets, { autoAlpha: 0, y })
        if (immediate) {
          gsap.to(targets, {
            autoAlpha: 1,
            y: 0,
            duration,
            stagger,
            ease: 'power2.out',
            overwrite: true,
          })
        } else {
          ScrollTrigger.batch(targets, {
            start,
            onEnter: (batch) => {
              gsap.to(batch, {
                autoAlpha: 1,
                y: 0,
                duration,
                stagger,
                ease: 'power2.out',
                overwrite: true,
              })
            },
          })
        }
      }, rootRef.value)

      if (!immediate) {
        ScrollTrigger.refresh()
        revealTimeout = window.setTimeout(() => {
          const hidden = targets.filter((el) => Number.parseFloat(getComputedStyle(el).opacity) < 0.1)
          if (hidden.length) showAll()
        }, 1800)
      }
    } catch {
      showAll()
    }
  }
}
