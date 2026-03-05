import api from '@/lib/api'

/**
 * Send a test email (admin). Recipient defaults to teofiloharry69@gmail.com.
 */
export async function sendTestEmail(to?: string): Promise<{ message: string }> {
  const { data } = await api.post<{ message: string }>('/admin/settings/test-email', to ? { to } : {})
  return data as { message: string }
}
