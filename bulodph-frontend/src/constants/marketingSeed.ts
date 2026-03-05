/**
 * Seed data for marketing staff, campaigns, referral stats.
 */

export interface MarketingPartnerSeedItem {
  id: number
  full_name: string
  email: string
  phone: string
  city?: string
  province?: string
  referral_code: string
  status: 'Active' | 'Pending' | 'Inactive'
  referrals_count: number
  notes: string
}

export interface TopReferrerItem {
  id: number
  name: string
  signUps: number
  earnings: number
  rank: string
}

export interface CampaignSeedItem {
  id: number
  name: string
  status: string
  clicks: number
  signUps: number
  conversionPct: number
}

export const MARKETING_PARTNERS_SEED: MarketingPartnerSeedItem[] = [
  { id: 1, full_name: 'Ana Garcia', email: 'ana@email.com', phone: '0917 111 2233', referral_code: 'BULOD-ANA', status: 'Active', referrals_count: 12, notes: '' },
  { id: 2, full_name: 'Carlos Lopez', email: 'carlos@email.com', phone: '0918 222 3344', referral_code: 'BULOD-CARLOS', status: 'Active', referrals_count: 8, notes: '' },
  { id: 3, full_name: 'Elena Torres', email: 'elena@email.com', phone: '0919 333 4455', referral_code: '', status: 'Pending', referrals_count: 0, notes: '' },
]

export const TOP_REFERRERS_SEED: TopReferrerItem[] = [
  { id: 1, name: 'Maria Santos', signUps: 12, earnings: 2400, rank: '#1' },
  { id: 2, name: 'Juan Dela Cruz', signUps: 8, earnings: 1600, rank: '#2' },
  { id: 3, name: 'Ana Reyes', signUps: 5, earnings: 1000, rank: '#3' },
]

export const CAMPAIGNS_SEED: CampaignSeedItem[] = [
  { id: 1, name: 'Isabela Launch', status: 'Active', clicks: 320, signUps: 48, conversionPct: 15 },
  { id: 2, name: 'First Ride Free', status: 'Active', clicks: 185, signUps: 22, conversionPct: 12 },
]

export const REFERRAL_STATS_SEED = {
  referralLink: 'https://bulodph.com/ref/ABC123',
  clicks: 42,
  signUps: 8,
}
