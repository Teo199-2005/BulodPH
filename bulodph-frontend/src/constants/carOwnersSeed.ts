/**
 * Seed data for car rental owners (admin Car Rental Owners list).
 * Logos are in public/logos/
 */

export interface CarOwnerSeedItem {
  id: number
  full_name: string
  business_name?: string
  logo_url?: string
  email: string
  phone: string
  city: string
  province: string
  address: string
  status: 'Active' | 'Pending' | 'Suspended' | 'Inactive'
  account_status: 'Approved' | 'Pending'
  verified: boolean
  has_permit: boolean
  listings_count: number
  notes: string
}

export const CAR_OWNERS_SEED: CarOwnerSeedItem[] = [
  { id: 1, full_name: 'Juan Dela Cruz', business_name: "Collin's Rental", logo_url: '/logos/rental-1.png', email: 'juan@email.com', phone: '0917 123 4567', city: 'Cauayan', province: 'Isabela', address: '', status: 'Active', account_status: 'Approved', verified: true, has_permit: true, listings_count: 2, notes: '' },
  { id: 2, full_name: 'Maria Santos', business_name: "Juliet's Rental", logo_url: '/logos/rental-2.png', email: 'maria@email.com', phone: '0918 234 5678', city: 'Santiago', province: 'Isabela', address: '', status: 'Active', account_status: 'Approved', verified: true, has_permit: true, listings_count: 1, notes: '' },
  { id: 3, full_name: 'Pedro Reyes', business_name: 'Reyes Rentals', logo_url: '/logos/rental-3.png', email: 'pedro@email.com', phone: '0919 345 6789', city: 'Ilagan', province: 'Isabela', address: '', status: 'Pending', account_status: 'Pending', verified: false, has_permit: false, listings_count: 0, notes: '' },
]
