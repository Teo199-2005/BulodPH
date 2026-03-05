import { useToastStore } from '@/stores/toast'

/**
 * Copy text to clipboard and show toast feedback.
 */
export function useCopyToClipboard(successMessage = 'Copied!', errorMessage = 'Failed to copy') {
  const toast = useToastStore()

  async function copy(text: string): Promise<boolean> {
    try {
      await navigator.clipboard.writeText(text)
      toast.success(successMessage, 2000)
      return true
    } catch {
      toast.error(errorMessage)
      return false
    }
  }

  return { copy }
}
