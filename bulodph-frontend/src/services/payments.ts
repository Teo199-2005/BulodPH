import api from '@/lib/api'
import { unwrapData } from './api-types'

/** Backend expects snake_case for /payments/create. */
export interface CreatePaymentPayload {
  bookingId?: string
  vehicleId?: string
  startDate?: string
  endDate?: string
  amount: number
  method: string
  promoCode?: string
  returnUrl?: string
  cancelUrl?: string
}

export interface CreatePaymentResponse {
  reference?: string
  checkout_url?: string
  redirect_url?: string
  reference_id?: string
  status?: string
}

/** Thrown when the payment gateway is not configured (backend returns 503). */
export class PaymentUnavailableError extends Error {
  constructor(message = 'Payments are not available yet.') {
    super(message)
    this.name = 'PaymentUnavailableError'
  }
}

/**
 * Create a payment session for GCash/Maya (or other gateway).
 * Backend returns 503 with code "payment_unavailable" when gateway is not configured.
 */
export async function createPaymentSession(payload: CreatePaymentPayload): Promise<CreatePaymentResponse | null> {
  const body = {
    booking_id: payload.bookingId,
    amount: payload.amount,
    currency: 'PHP',
    return_url: payload.returnUrl,
    cancel_url: payload.cancelUrl,
  }
  try {
    const { data } = await api.post<{ data?: CreatePaymentResponse } | CreatePaymentResponse>('/payments/create', body)
    return unwrapData(data) as CreatePaymentResponse
  } catch (err: unknown) {
    const status = (err as { response?: { status?: number; data?: { code?: string } } })?.response?.status
    const code = (err as { response?: { data?: { code?: string } } })?.response?.data?.code
    if (status === 503 || code === 'payment_unavailable') {
      throw new PaymentUnavailableError('Payments are not available yet. You can complete your booking and pay later via GCash or Maya.')
    }
    return null
  }
}

/** Check payment status (e.g. after return from gateway). Returns null on error or 404. */
export async function getPaymentStatus(referenceId: string): Promise<{ status: string; bookingId?: string } | null> {
  try {
    const { data } = await api.get<{ data?: { status: string; bookingId?: string } } | { status: string; bookingId?: string }>(`/payments/status/${referenceId}`)
    return unwrapData(data) as { status: string; bookingId?: string }
  } catch {
    return null
  }
}
