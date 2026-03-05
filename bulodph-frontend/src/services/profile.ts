import api from '@/lib/api'
import { unwrapData } from './api-types'
import type { User } from '@/stores/userSession'

export interface ProfileUpdatePayload {
  name?: string
  email?: string
  mobile?: string
  address?: string
  city?: string
  province?: string
  id_number?: string
  emergency_contact_name?: string
  emergency_contact_phone?: string
}

export async function getProfile(): Promise<User | null> {
  try {
    const { data } = await api.get<{ data?: User } | User>('/profile')
    return unwrapData(data) as User
  } catch {
    return null
  }
}

export async function updateProfile(payload: ProfileUpdatePayload): Promise<User | null> {
  try {
    const { data } = await api.put<{ data?: User } | User>('/profile', payload)
    return unwrapData(data) as User
  } catch {
    return null
  }
}

function fileToDataUrl(file: File): Promise<string> {
  return new Promise((resolve, reject) => {
    const reader = new FileReader()
    reader.onload = () => resolve(reader.result as string)
    reader.onerror = () => reject(new Error('Could not read file.'))
    reader.readAsDataURL(file)
  })
}

export async function uploadProfileImage(file: File): Promise<{ avatar_url: string } | null> {
  const dataUrl = await fileToDataUrl(file)
  if (!dataUrl.startsWith('data:image/')) {
    throw new Error('The photo must be a JPEG, PNG, GIF, or WebP image.')
  }
  if (dataUrl.length > 7.5 * 1024 * 1024) {
    throw new Error('The photo must not be larger than 5 MB.')
  }
  try {
    const { data } = await api.post<{ data?: { avatar_url: string }; avatar_url?: string }>('/profile/avatar', {
      avatar_base64: dataUrl,
    })
    const result = unwrapData(data) as { avatar_url?: string }
    const url = result?.avatar_url ?? (data as { avatar_url?: string })?.avatar_url
    return url ? { avatar_url: url } : null
  } catch (err: unknown) {
    const res = (err as { response?: { data?: { message?: string; errors?: Record<string, string[] | string> }; status?: number } })?.response
    if (res?.status === 422 && res?.data) {
      const errs = res.data.errors ?? {}
      const avatarErr = errs.avatar ?? errs.avatar_base64
      const first = Array.isArray(avatarErr) ? avatarErr[0] : typeof avatarErr === 'string' ? avatarErr : Object.values(errs).flat()[0]
      throw new Error(first || res.data.message || 'Invalid photo.')
    }
    if (res?.status === 419) {
      throw new Error('Session or security token expired. Please refresh the page and try again.')
    }
    throw new Error((err as Error)?.message || 'Failed to save photo.')
  }
}

export async function changePassword(currentPassword: string, newPassword: string): Promise<boolean> {
  try {
    await api.post('/profile/change-password', { current_password: currentPassword, new_password: newPassword })
    return true
  } catch {
    return false
  }
}
