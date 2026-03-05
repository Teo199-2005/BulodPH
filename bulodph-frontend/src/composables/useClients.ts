import { useQuery, useMutation, useQueryClient } from '@tanstack/vue-query'
import api from '@/lib/api'
import type { Ref } from 'vue'

export interface Client {
  id: string
  organization_id: string
  ndis_number: string
  first_name: string
  last_name: string
  full_name: string
  date_of_birth: string
  address_line_1: string
  address_line_2?: string
  suburb: string
  state: string
  postcode: string
  latitude: number
  longitude: number
  emergency_contact_name: string
  emergency_contact_phone: string
}

export interface CreateClientPayload {
  ndis_number: string
  first_name: string
  last_name: string
  date_of_birth: string
  address_line_1: string
  address_line_2?: string
  suburb: string
  state: string
  postcode: string
  latitude: number
  longitude: number
  emergency_contact_name: string
  emergency_contact_phone: string
}

export function useClients(search?: Ref<string>) {
  return useQuery({
    queryKey: ['clients', search],
    queryFn: async () => {
      const { data } = await api.get<{ data: Client[] }>('/clients', {
        params: { search: search?.value },
      })
      return data.data
    },
  })
}

export function useClient(id: Ref<string>) {
  return useQuery({
    queryKey: ['clients', id],
    queryFn: async () => {
      const { data } = await api.get<Client>(`/clients/${id.value}`)
      return data
    },
    enabled: () => !!id.value,
  })
}

export function useCreateClient() {
  const queryClient = useQueryClient()

  return useMutation({
    mutationFn: async (payload: CreateClientPayload) => {
      const { data } = await api.post<Client>('/clients', payload)
      return data
    },
    onSuccess: () => {
      queryClient.invalidateQueries({ queryKey: ['clients'] })
    },
  })
}

export function useUpdateClient() {
  const queryClient = useQueryClient()

  return useMutation({
    mutationFn: async ({ id, payload }: { id: string; payload: Partial<CreateClientPayload> }) => {
      const { data } = await api.put<Client>(`/clients/${id}`, payload)
      return data
    },
    onSuccess: () => {
      queryClient.invalidateQueries({ queryKey: ['clients'] })
    },
  })
}

