import { onMounted, onBeforeUnmount, type Ref } from 'vue'

export function useSwiper(
  containerRef: Ref<HTMLElement | null>,
  options: Record<string, unknown>
) {
  let instance: { destroy: () => void } | null = null

  onMounted(async () => {
    if (!containerRef.value) return
    if (window.matchMedia('(prefers-reduced-motion: reduce)').matches) return

    const { default: Swiper } = await import('swiper')
    const { Autoplay, Pagination, Navigation } = await import('swiper/modules')

    instance = new Swiper(containerRef.value, {
      modules: [Autoplay, Pagination, Navigation],
      ...options,
    })
  })

  onBeforeUnmount(() => {
    instance?.destroy()
    instance = null
  })
}
