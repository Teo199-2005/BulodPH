/**
 * Active promos for BulodPH – show expiry and terms on Promos page.
 */
export interface PromoSeedItem {
  id: string
  code: string
  title: string
  description: string
  /** e.g. "10% on 1-day booking" */
  discountLabel: string
  expiry: string
  terms: string
  active: boolean
}

export const PROMOS_SEED: PromoSeedItem[] = [
  {
    id: 'p1',
    code: 'BULOD10',
    title: '10% off on 1-day booking',
    description: 'Use at checkout for 10% off when you book for 1 day only.',
    discountLabel: '10% on 1-day booking',
    expiry: 'Dec 31, 2026',
    terms: 'Valid for 1-day bookings only. Use code BULOD10 at checkout. Cannot be combined with other promos.',
    active: true,
  },
  {
    id: 'p2',
    code: 'WEEKEND20',
    title: '20% off weekend rentals',
    description: 'Book Friday–Sunday and save 20%.',
    discountLabel: '20% off',
    expiry: 'Mar 31, 2026',
    terms: 'Valid for bookings that include Friday, Saturday or Sunday. Minimum 2 days. Excludes holidays.',
    active: true,
  },
  {
    id: 'p3',
    code: 'LONG3',
    title: '3+ days discount',
    description: 'Rent 3 days or more and get ₱500 off.',
    discountLabel: '₱500 off',
    expiry: 'Jun 30, 2026',
    terms: 'Single use. Minimum 3 consecutive days. Applicable to base rental only (excludes add-ons).',
    active: true,
  },
]

export function getActivePromos(): PromoSeedItem[] {
  return PROMOS_SEED.filter(p => p.active)
}
