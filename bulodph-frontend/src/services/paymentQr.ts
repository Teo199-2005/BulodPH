import api from '@/lib/api'
import { unwrapData } from './api-types'

export interface PaymentQrData {
  gcashQrUrl: string | null
  mayaQrUrl: string | null
}

/** Normalize API response (backend may return camelCase or snake_case). */
function normalizePaymentQrData(raw: unknown): PaymentQrData {
  if (raw != null && typeof raw === 'object') {
    const o = raw as Record<string, unknown>
    return {
      gcashQrUrl: (o.gcashQrUrl ?? o.gcash_qr_url ?? null) as string | null,
      mayaQrUrl: (o.mayaQrUrl ?? o.maya_qr_url ?? null) as string | null,
    }
  }
  return { gcashQrUrl: null, mayaQrUrl: null }
}

/** Get QR URLs for manual payment (client payment page). Uses public endpoint so QR always loads. */
export async function getPaymentQr(): Promise<PaymentQrData> {
  const { data } = await api.get<{ data?: unknown } | unknown>('/public/payment-qr')
  const raw = unwrapData(data)
  if (import.meta.env.DEV && raw != null && typeof raw === 'object') {
    console.debug('[paymentQr] API response:', raw)
  }
  return normalizePaymentQrData(raw)
}

/** Admin: get QR settings (same shape as client). */
export async function getAdminPaymentQr(): Promise<PaymentQrData> {
  const { data } = await api.get<{ data?: unknown } | unknown>('/admin/settings/payment-qr')
  const raw = unwrapData(data)
  return normalizePaymentQrData(raw)
}

/** Admin: update GCash and Maya QR image URLs. */
export async function updatePaymentQr(payload: Partial<PaymentQrData>): Promise<PaymentQrData> {
  const { data } = await api.put<{ data?: PaymentQrData } | PaymentQrData>('/admin/settings/payment-qr', payload)
  return unwrapData(data) as PaymentQrData
}
