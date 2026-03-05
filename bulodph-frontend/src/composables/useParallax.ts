import { onMounted, onBeforeUnmount, type Ref } from 'vue'

export function useParallax(rootRef: Ref<HTMLElement | null>) {
  let instance: { disable: () => void; destroy: () => void } | null = null

  onMounted(async () => {
    if (!rootRef.value) return
    if (window.matchMedia('(prefers-reduced-motion: reduce)').matches) return

    const { default: Parallax } = await import('parallax-js')
    instance = new Parallax(rootRef.value, {
      relativeInput: true,
      hoverOnly: true,
    })
  })

  onBeforeUnmount(() => {
    if (instance) {
      instance.disable()
      instance.destroy()
      instance = null
    }
  })
}
