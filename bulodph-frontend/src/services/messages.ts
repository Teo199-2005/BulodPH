import api from '@/lib/api'
import { unwrapData } from './api-types'

function getErrorMessage(error: unknown): string {
  const message = (error as { response?: { data?: { message?: string } } })?.response?.data?.message
  return message ?? 'Request failed. Please try again.'
}

export interface MessageRecord {
  id: string
  thread_id: string
  sender_id: string
  body?: string | null
  attachment_path?: string | null
  attachment_mime?: string | null
  attachment_size?: number | null
  created_at?: string
}

export interface MessageThreadRecord {
  id: string
  booking_reference?: string | null
  client_id: string
  owner_id: string
  status: string
  created_at?: string
  updated_at?: string
  messages?: MessageRecord[]
}

export interface CreateThreadPayload {
  booking_reference?: string
  client_id: string
  owner_id: string
}

export async function getThreads(): Promise<MessageThreadRecord[]> {
  try {
    const { data } = await api.get<{ data?: MessageThreadRecord[] } | MessageThreadRecord[]>('/messages/threads')
    return (unwrapData(data) as MessageThreadRecord[]) ?? []
  } catch (error) {
    throw new Error(getErrorMessage(error))
  }
}

export async function getThreadById(id: string): Promise<MessageThreadRecord> {
  try {
    const { data } = await api.get<{ data?: MessageThreadRecord } | MessageThreadRecord>(`/messages/threads/${id}`)
    return unwrapData(data) as MessageThreadRecord
  } catch (error) {
    throw new Error(getErrorMessage(error))
  }
}

export async function createThread(payload: CreateThreadPayload): Promise<MessageThreadRecord> {
  try {
    const { data } = await api.post<{ data?: MessageThreadRecord } | MessageThreadRecord>('/messages/threads', payload)
    return unwrapData(data) as MessageThreadRecord
  } catch (error) {
    throw new Error(getErrorMessage(error))
  }
}

export async function sendMessage(threadId: string, body: string, attachment?: File): Promise<MessageRecord> {
  try {
    if (attachment) {
      const form = new FormData()
      form.append('body', body)
      form.append('attachment', attachment)
      const { data } = await api.post<{ data?: MessageRecord } | MessageRecord>(`/messages/threads/${threadId}`, form, {
        headers: { 'Content-Type': 'multipart/form-data' },
      })
      return unwrapData(data) as MessageRecord
    }
    const { data } = await api.post<{ data?: MessageRecord } | MessageRecord>(`/messages/threads/${threadId}`, { body })
    return unwrapData(data) as MessageRecord
  } catch (error) {
    throw new Error(getErrorMessage(error))
  }
}
