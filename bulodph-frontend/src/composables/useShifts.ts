import { useQuery, useMutation, useQueryClient } from '@tanstack/vue-query'
import api from '@/lib/api'
import type { Ref } from 'vue'

export interface Shift {
  id: string
  client: {
    id: string
    full_name: string
    address_line_1: string
    suburb: string
    latitude: number
    longitude: number
  }
  primary_worker: {
    id: string
    email: string
  }
  scheduled_start: string
  scheduled_end: string
  actual_start?: string
  actual_end?: string
  status: 'SCHEDULED' | 'IN_PROGRESS' | 'COMPLETED' | 'CANCELLED'
  notes?: string
  parent_shift_id?: string
}

export interface CreateShiftPayload {
  client_id: string
  primary_worker_id: string
  parent_shift_id?: string
  scheduled_start: string
  scheduled_end: string
  plan_line_item_ids: string[]
  notes?: string
}

export interface ClockInPayload {
  latitude: number
  longitude: number
}

export function useShifts(filters?: Ref<{ status?: string; worker_id?: string; client_id?: string }>) {
  return useQuery({
    queryKey: ['shifts', filters],
    queryFn: async () => {
      const { data } = await api.get<{ data: Shift[] }>('/shifts', {
        params: filters?.value,
      })
      return data.data
    },
  })
}

export function useShift(id: Ref<string>) {
  return useQuery({
    queryKey: ['shifts', id],
    queryFn: async () => {
      const { data } = await api.get<Shift>(`/shifts/${id.value}`)
      return data
    },
    enabled: () => !!id.value,
  })
}

export function useCreateShift() {
  const queryClient = useQueryClient()

  return useMutation({
    mutationFn: async (payload: CreateShiftPayload) => {
      const { data } = await api.post<Shift>('/shifts', payload)
      return data
    },
    onSuccess: () => {
      queryClient.invalidateQueries({ queryKey: ['shifts'] })
    },
  })
}

export function useClockIn() {
  const queryClient = useQueryClient()

  return useMutation({
    mutationFn: async ({ shiftId, payload }: { shiftId: string; payload: ClockInPayload }) => {
      const { data } = await api.post<Shift>(`/shifts/${shiftId}/clock-in`, payload)
      return data
    },
    onSuccess: () => {
      queryClient.invalidateQueries({ queryKey: ['shifts'] })
    },
  })
}

export function useClockOut() {
  const queryClient = useQueryClient()

  return useMutation({
    mutationFn: async ({ shiftId, payload }: { shiftId: string; payload: ClockInPayload }) => {
      const { data } = await api.post<Shift>(`/shifts/${shiftId}/clock-out`, payload)
      return data
    },
    onSuccess: () => {
      queryClient.invalidateQueries({ queryKey: ['shifts'] })
    },
  })
}

export function useCancelShift() {
  const queryClient = useQueryClient()

  return useMutation({
    mutationFn: async ({ shiftId, reason }: { shiftId: string; reason: string }) => {
      const { data } = await api.post<Shift>(`/shifts/${shiftId}/cancel`, {
        cancellation_reason: reason,
      })
      return data
    },
    onSuccess: () => {
      queryClient.invalidateQueries({ queryKey: ['shifts'] })
    },
  })
}

