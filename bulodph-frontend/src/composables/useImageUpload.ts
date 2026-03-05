/**
 * Convert a File to a data URL (base64) for use as image src / store value without a backend.
 */
export function fileToDataUrl(file: File): Promise<string> {
  return new Promise((resolve, reject) => {
    const reader = new FileReader()
    reader.onload = () => resolve(reader.result as string)
    reader.onerror = () => reject(reader.error)
    reader.readAsDataURL(file)
  })
}

/**
 * Resize and compress image to a small base64 string
 * Safe for localStorage injection without hitting 5MB quotas.
 */
export function optimizeImage(file: File, maxWidth = 400, maxHeight = 400): Promise<string> {
  return new Promise((resolve, reject) => {
    const reader = new FileReader()
    reader.onload = (e) => {
      const img = new Image()
      img.onload = () => {
        const canvas = document.createElement('canvas')
        let { width, height } = img
        if (width > height) {
          if (width > maxWidth) {
            height *= maxWidth / width
            width = maxWidth
          }
        } else {
          if (height > maxHeight) {
            width *= maxHeight / height
            height = maxHeight
          }
        }
        canvas.width = Math.round(width)
        canvas.height = Math.round(height)
        const ctx = canvas.getContext('2d')
        ctx?.drawImage(img, 0, 0, canvas.width, canvas.height)
        resolve(canvas.toDataURL('image/jpeg', 0.85))
      }
      img.onerror = () => reject(new Error('Failed to load image for optimization'))
      img.src = e.target?.result as string
    }
    reader.onerror = () => reject(reader.error)
    reader.readAsDataURL(file)
  })
}

/** Normalize to File[] (v-file-input may pass single File or File[]). */
function toFileArray(files: File[] | File | null | undefined): File[] | null {
  if (files == null) return null
  if (Array.isArray(files)) return files.length ? files : null
  return [files]
}

/**
 * When user selects file(s), read the first (or all) as data URL(s).
 * For single: returns Promise<string>.
 * For multiple: pass multiple: true, returns Promise<string[]>.
 * Accepts File | File[] (Vuetify v-file-input may pass either).
 */
export async function filesToDataUrls(files: File[] | File | null | undefined, multiple = false): Promise<string | string[] | null> {
  const list = toFileArray(files)
  if (!list?.length) return null
  if (multiple) {
    const urls = await Promise.all(list.map((f) => fileToDataUrl(f)))
    return urls
  }
  return fileToDataUrl(list[0])
}

/**
 * Get natural width and height of an image from its URL (data URL or http).
 */
export function getImageDimensions(src: string): Promise<{ width: number; height: number }> {
  return new Promise((resolve, reject) => {
    const img = new Image()
    img.onload = () => resolve({ width: img.naturalWidth, height: img.naturalHeight })
    img.onerror = () => reject(new Error('Failed to load image'))
    img.src = src
  })
}
