import { onMounted, onBeforeUnmount, type Ref } from 'vue'

export function useVanillaTilt(rootRef: Ref<HTMLElement | null>, selector = '[data-tilt]') {
  let tiltInstances: Array<{ destroy: () => void }> = []

  onMounted(async () => {
    if (!rootRef.value) return
    if (window.matchMedia('(prefers-reduced-motion: reduce)').matches) return

    const { default: VanillaTilt } = await import('vanilla-tilt')
    const elements = Array.from(rootRef.value.querySelectorAll(selector)) as HTMLElement[]
    if (!elements.length) return
    VanillaTilt.init(elements, {
      max: 6,
      speed: 500,
      glare: true,
      'max-glare': 0.15,
      scale: 1.02,
    })
    tiltInstances = elements as unknown as Array<{ destroy: () => void }>
  })

  onBeforeUnmount(() => {
    tiltInstances.forEach((el) => (el as { vanillaTilt?: { destroy: () => void } }).vanillaTilt?.destroy())
    tiltInstances = []
  })
}
