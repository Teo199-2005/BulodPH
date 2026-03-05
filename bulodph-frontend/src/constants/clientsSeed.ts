/**
 * Seed data for clients (admin Clients list, Client Details).
 */

export interface ClientSeedItem {
  id: number | string
  full_name: string
  email: string
  phone: string
  city: string
  province: string
  address: string
  status: 'Active' | 'Pending' | 'Inactive'
  bookings_count: number
  notes: string
  avatar_url?: string | null
}

export interface ClientActivityItem {
  id: number
  icon: string
  color: string
  title: string
  detail: string
  time: string
}

export const CLIENTS_SEED: ClientSeedItem[] = [
  { id: 1, full_name: 'Mary Johnson', email: 'mary.johnson@email.com', phone: '0917 123 4567', city: 'Cauayan', province: 'Isabela', address: '', status: 'Active', bookings_count: 5, notes: '' },
  { id: 2, full_name: 'Robert Williams', email: 'robert.williams@email.com', phone: '0918 234 5678', city: 'Santiago', province: 'Isabela', address: '', status: 'Active', bookings_count: 3, notes: '' },
  { id: 3, full_name: 'Patricia Miller', email: 'patricia.miller@email.com', phone: '0919 345 6789', city: 'Ilagan', province: 'Isabela', address: '', status: 'Pending', bookings_count: 0, notes: '' },
  { id: 4, full_name: 'James Anderson', email: 'james.anderson@email.com', phone: '0920 456 7890', city: 'Tuguegarao', province: 'Cagayan', address: '', status: 'Active', bookings_count: 2, notes: '' },
  { id: 5, full_name: 'Jennifer Taylor', email: 'jennifer.taylor@email.com', phone: '0921 567 8901', city: 'Cauayan', province: 'Isabela', address: '', status: 'Inactive', bookings_count: 1, notes: '' },
]

export const CLIENT_ACTIVITY_SEED: ClientActivityItem[] = [
  { id: 1, icon: 'mdi-account-plus', color: 'primary', title: 'New sign-up', detail: 'Rosa Lim from Cauayan registered as Pasahero', time: '2 hours ago' },
  { id: 2, icon: 'mdi-calendar-check', color: 'success', title: 'Booking completed', detail: 'Carlos Cruz returned Honda City to Ana D. in Santiago', time: '5 hours ago' },
  { id: 3, icon: 'mdi-credit-card', color: 'action', title: 'Payment received', detail: 'Maria Santos paid ₱5,000 for Toyota Innova booking', time: '1 day ago' },
  { id: 4, icon: 'mdi-car-search', color: 'info', title: 'Browse activity', detail: '12 clients viewed vehicle listings in Ilagan today', time: '1 day ago' },
]

export interface ClientDetailSeed {
  id: number
  full_name: string
  email: string
  phone: string
  address: string
  ndisNumber: string
  generalNotes: string
}

/** Client details by id for ClientDetailsView (overview tab). */
export const CLIENT_DETAILS_SEED: Record<number, ClientDetailSeed> = {
  1: { id: 1, full_name: 'Mary Johnson', email: 'mary.johnson@email.com', phone: '0917 123 4567', address: 'Cauayan City, Isabela', ndisNumber: 'NDIS-123456789', generalNotes: 'General care notes will load from API.' },
  2: { id: 2, full_name: 'Robert Williams', email: 'robert.williams@email.com', phone: '0918 234 5678', address: 'Santiago City, Isabela', ndisNumber: 'NDIS-234567890', generalNotes: '' },
  3: { id: 3, full_name: 'Patricia Miller', email: 'patricia.miller@email.com', phone: '0919 345 6789', address: 'Ilagan City, Isabela', ndisNumber: '', generalNotes: '' },
  4: { id: 4, full_name: 'James Anderson', email: 'james.anderson@email.com', phone: '0920 456 7890', address: 'Tuguegarao City, Cagayan', ndisNumber: '', generalNotes: '' },
  5: { id: 5, full_name: 'Jennifer Taylor', email: 'jennifer.taylor@email.com', phone: '0921 567 8901', address: 'Cauayan City, Isabela', ndisNumber: '', generalNotes: '' },
}

export function getClientById(id: number): ClientDetailSeed | undefined {
  return CLIENT_DETAILS_SEED[id]
}
