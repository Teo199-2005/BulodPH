import { onMounted, onBeforeUnmount, type Ref } from 'vue'

export function useCleave(inputRef: Ref<HTMLInputElement | null>, options: Record<string, unknown>) {
  let instance: { destroy: () => void } | null = null

  onMounted(async () => {
    if (!inputRef.value) return
    const { default: Cleave } = await import('cleave.js')
    instance = new Cleave(inputRef.value, options)
  })

  onBeforeUnmount(() => {
    instance?.destroy()
    instance = null
  })
}
