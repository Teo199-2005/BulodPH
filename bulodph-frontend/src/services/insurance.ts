import api from '@/lib/api'
import { unwrapData } from './api-types'

function getErrorMessage(error: unknown): string {
  const message = (error as { response?: { data?: { message?: string } } })?.response?.data?.message
  return message ?? 'Request failed. Please try again.'
}

export interface InsurancePlanRecord {
  id: string
  name: string
  description?: string | null
  price: number
  currency?: string
  coverage_details?: string | null
  is_active?: boolean
  created_at?: string
  updated_at?: string
}

export interface InsuranceSelectionRecord {
  id: string
  user_id: string
  insurance_plan_id: string
  booking_reference?: string | null
  status: string
  created_at?: string
  updated_at?: string
}

export interface InsuranceClaimRecord {
  id: string
  user_id: string
  insurance_selection_id: string
  description?: string | null
  claim_amount?: number
  status: string
  evidence_path?: string | null
  created_at?: string
  updated_at?: string
}

export async function getInsurancePlans(): Promise<InsurancePlanRecord[]> {
  try {
    const { data } = await api.get<{ data?: InsurancePlanRecord[] } | InsurancePlanRecord[]>('/insurance/plans')
    return (unwrapData(data) as InsurancePlanRecord[]) ?? []
  } catch (error) {
    throw new Error(getErrorMessage(error))
  }
}

export async function getInsuranceSelections(): Promise<InsuranceSelectionRecord[]> {
  try {
    const { data } = await api.get<{ data?: InsuranceSelectionRecord[] } | InsuranceSelectionRecord[]>('/insurance/selections')
    return (unwrapData(data) as InsuranceSelectionRecord[]) ?? []
  } catch (error) {
    throw new Error(getErrorMessage(error))
  }
}

export async function createInsuranceSelection(payload: { booking_reference?: string; insurance_plan_id: string }): Promise<InsuranceSelectionRecord> {
  try {
    const { data } = await api.post<{ data?: InsuranceSelectionRecord } | InsuranceSelectionRecord>('/insurance/selections', payload)
    return unwrapData(data) as InsuranceSelectionRecord
  } catch (error) {
    throw new Error(getErrorMessage(error))
  }
}

export async function getInsuranceClaims(): Promise<InsuranceClaimRecord[]> {
  try {
    const { data } = await api.get<{ data?: InsuranceClaimRecord[] } | InsuranceClaimRecord[]>('/insurance/claims')
    return (unwrapData(data) as InsuranceClaimRecord[]) ?? []
  } catch (error) {
    throw new Error(getErrorMessage(error))
  }
}

export async function createInsuranceClaim(form: {
  insurance_selection_id: string
  description?: string
  claim_amount?: number
  evidence?: File
}): Promise<InsuranceClaimRecord> {
  try {
    const body = new FormData()
    body.append('insurance_selection_id', form.insurance_selection_id)
    if (form.description) body.append('description', form.description)
    if (form.claim_amount != null) body.append('claim_amount', String(form.claim_amount))
    if (form.evidence) body.append('evidence', form.evidence)

    const { data } = await api.post<{ data?: InsuranceClaimRecord } | InsuranceClaimRecord>('/insurance/claims', body, {
      headers: { 'Content-Type': 'multipart/form-data' },
    })
    return unwrapData(data) as InsuranceClaimRecord
  } catch (error) {
    throw new Error(getErrorMessage(error))
  }
}
