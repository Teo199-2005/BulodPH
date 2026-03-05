/**
 * Shared API response types and helpers.
 * Backend can return { data: T } or T; we normalize to T.
 */

export function unwrapData<T>(response: { data?: T } | T): T {
  if (response != null && typeof response === 'object' && 'data' in response && response.data !== undefined) {
    return response.data as T
  }
  return response as T
}

export interface PaginatedMeta {
  total: number
  per_page: number
  current_page: number
  last_page: number
  from: number | null
  to: number | null
}

export interface PaginatedResponse<T> {
  data: T[]
  meta?: PaginatedMeta
  links?: {
    first: string | null
    last: string | null
    prev: string | null
    next: string | null
  }
}

export interface ApiError {
  message?: string
  errors?: Record<string, string[]>
  status?: number
}

/**
 * Standardizes API error handling across all services.
 * Extracts message and field validation errors from an Axios error.
 */
export function handleApiError(error: unknown): ApiError {
  const err = error as any
  const status = err?.response?.status
  const data = err?.response?.data

  if (data && typeof data === 'object') {
    return {
      message: data.message || err.message || 'An unexpected error occurred.',
      errors: data.errors,
      status,
    }
  }

  return {
    message: err?.message || 'An unexpected error occurred.',
    status,
  }
}

// Common Domain Types
export interface Timestamped {
  created_at: string
  updated_at: string
}

export interface DateRange {
  start_date: string
  end_date: string
}
