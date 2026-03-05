import axios, { type AxiosRequestConfig } from 'axios'
import { useUserSessionStore } from '@/stores/userSession'
import { useRequestStatusStore } from '@/stores/requestStatus'

const apiBaseUrl = import.meta.env.VITE_API_URL || 'http://localhost:8000/api'

const api = axios.create({
  baseURL: apiBaseUrl,
  headers: {
    'Accept': 'application/json',
    'X-Requested-With': 'XMLHttpRequest',
  },
  withCredentials: false,
  timeout: 12000,
})

// Request interceptor - attach auth token and set Content-Type only for JSON (not FormData)
api.interceptors.request.use(
  (config) => {
    const userSession = useUserSessionStore()
    const requestStatus = useRequestStatusStore()
    if (userSession.token) {
      config.headers.Authorization = `Bearer ${userSession.token}`
    }
    // Only set JSON content type when body is not FormData (so avatar upload sends multipart/form-data)
    if (!(config.data instanceof FormData)) {
      config.headers['Content-Type'] = 'application/json'
    }
    const method = (config.method ?? 'get').toLowerCase()
    if (method === 'get') {
      requestStatus.start()
      ;(config as AxiosRequestConfig & { __trackRequest?: boolean }).__trackRequest = true
    }
    return config
  },
  (error) => {
    return Promise.reject(error)
  }
)

// Response interceptor - handle retries for transient GET failures
api.interceptors.response.use(
  (response) => {
    const requestStatus = useRequestStatusStore()
    const tracked = (response.config as AxiosRequestConfig & { __trackRequest?: boolean }).__trackRequest
    if (tracked) requestStatus.end()
    return response
  },
  async (error) => {
    const requestStatus = useRequestStatusStore()
    const config = error.config as (AxiosRequestConfig & { __retryCount?: number }) | undefined
    const status = error.response?.status
    const isGet = (config?.method ?? 'get').toLowerCase() === 'get'
    if (config && (config as AxiosRequestConfig & { __trackRequest?: boolean }).__trackRequest) {
      requestStatus.end()
    }
    const shouldRetry =
      isGet &&
      config &&
      ((status && status >= 500) || error.code === 'ECONNABORTED' || !error.response)

    if (shouldRetry) {
      config.__retryCount = (config.__retryCount ?? 0) + 1
      if (config.__retryCount <= 2) {
        const delay = 400 * config.__retryCount
        await new Promise((resolve) => setTimeout(resolve, delay))
        return api.request(config)
      }
    }

    if (error.response?.status === 401) {
      const userSession = useUserSessionStore()
      userSession.clearAuth()
      window.location.href = '/login'
      return Promise.reject(error)
    }
    // Improve error message for API errors (prefer validation errors for 422)
    const data = error.response?.data as { message?: string; errors?: Record<string, string[]> } | undefined
    let msg = data?.message ?? error.message ?? 'An unexpected error occurred. Please try again.'
    if (error.response?.status === 422 && data?.errors) {
      const first = Object.values(data.errors).flat()[0]
      if (first) msg = first
    }
    error.message = msg
    return Promise.reject(error)
  }
)

export default api

