import api from '@/lib/api'
import { unwrapData } from './api-types'

function getErrorMessage(error: unknown): string {
  const message = (error as { response?: { data?: { message?: string } } })?.response?.data?.message
  return message ?? 'Request failed. Please try again.'
}

export interface ReviewRecord {
  id: string
  booking_reference?: string | null
  reviewee_id?: string | null
  vehicle_reference?: string | null
  reviewer_id: string
  rating: number
  comment?: string | null
  status: string
  created_at?: string
  updated_at?: string
}

export interface CreateReviewPayload {
  booking_reference?: string
  reviewee_id?: string
  vehicle_reference?: string
  rating: number
  comment?: string
}

export async function getReviews(params?: { vehicle_reference?: string; reviewee_id?: string }): Promise<ReviewRecord[]> {
  try {
    const { data } = await api.get<{ data?: ReviewRecord[] } | ReviewRecord[]>('/reviews', { params })
    return (unwrapData(data) as ReviewRecord[]) ?? []
  } catch (error) {
    throw new Error(getErrorMessage(error))
  }
}

export async function createReview(payload: CreateReviewPayload): Promise<ReviewRecord> {
  try {
    const body = {
      booking_reference: payload.booking_reference || undefined,
      reviewee_id: payload.reviewee_id || undefined,
      vehicle_reference: payload.vehicle_reference || undefined,
      rating: payload.rating,
      comment: payload.comment || undefined,
    }
    const { data } = await api.post<{ data?: ReviewRecord } | ReviewRecord>('/reviews', body)
    return unwrapData(data) as ReviewRecord
  } catch (error) {
    throw new Error(getErrorMessage(error))
  }
}
