import { onMounted, onBeforeUnmount, type Ref } from 'vue'

export function useChoices(selectRef: Ref<HTMLSelectElement | null>, options: Record<string, unknown> = {}) {
  let instance: { destroy: () => void } | null = null

  onMounted(async () => {
    if (!selectRef.value) return
    const { default: Choices } = await import('choices.js')
    instance = new Choices(selectRef.value, {
      searchEnabled: true,
      itemSelectText: '',
      shouldSort: false,
      ...options,
    })
  })

  onBeforeUnmount(() => {
    instance?.destroy()
    instance = null
  })
}
