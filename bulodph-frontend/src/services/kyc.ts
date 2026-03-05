import api from '@/lib/api'
import { unwrapData } from './api-types'

function getErrorMessage(error: unknown): string {
  const message = (error as { response?: { data?: { message?: string } } })?.response?.data?.message
  return message ?? 'Request failed. Please try again.'
}

export interface KycStatusRecord {
  id: string
  user_id: string
  status: string
  id_type?: string | null
  id_number?: string | null
  rejection_reason?: string | null
  reviewed_at?: string | null
  created_at?: string
  updated_at?: string
}

export async function getKycStatus(): Promise<KycStatusRecord | null> {
  try {
    const { data } = await api.get<{ data?: KycStatusRecord | null } | KycStatusRecord | null>('/kyc/status')
    const out = unwrapData(data)
    return (out as KycStatusRecord) ?? null
  } catch (error) {
    throw new Error(getErrorMessage(error))
  }
}

export async function submitKyc(form: {
  id_type: string
  id_number?: string
  id_front?: File
  id_back?: File
  license?: File
  selfie?: File
}): Promise<KycStatusRecord> {
  try {
    const body = new FormData()
    body.append('id_type', form.id_type)
    if (form.id_number) body.append('id_number', form.id_number)
    if (form.id_front) body.append('id_front', form.id_front)
    if (form.id_back) body.append('id_back', form.id_back)
    if (form.license) body.append('license', form.license)
    if (form.selfie) body.append('selfie', form.selfie)

    const { data } = await api.post<{ data?: KycStatusRecord } | KycStatusRecord>('/kyc/submit', body, {
      headers: { 'Content-Type': 'multipart/form-data' },
    })
    return unwrapData(data) as KycStatusRecord
  } catch (error) {
    throw new Error(getErrorMessage(error))
  }
}
