import api from '@/lib/api'

/**
 * Send a test email via Brevo. Default recipient is teofiloharry69@gmail.com.
 * Admin only.
 */
export async function sendTestEmail(to?: string): Promise<{ message: string }> {
  const { data } = await api.post<{ message: string }>('/admin/settings/test-email', to ? { to } : {})
  return data
}
