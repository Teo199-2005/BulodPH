import api from '@/lib/api'

/** Request a password reset link. Always shows success to avoid revealing if email exists. */
export async function requestPasswordReset(email: string): Promise<{ ok: boolean; message?: string }> {
  try {
    await api.post('/forgot-password', { email })
    return { ok: true }
  } catch (err: unknown) {
    const status = (err as { response?: { status?: number } })?.response?.status
    // 404/422/500 - backend might not have the endpoint yet; still show success for security
    if (status === 404 || status === 422 || status === 500) {
      return { ok: true }
    }
    return { ok: false, message: 'Something went wrong. Please try again.' }
  }
}

/** Reset password with token from email link. */
export async function resetPassword(email: string, token: string, password: string): Promise<void> {
  await api.post('/reset-password', {
    email,
    token,
    password,
    password_confirmation: password,
  })
}
