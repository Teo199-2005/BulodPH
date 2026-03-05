/**
 * Seed data for Notifications page.
 */

export type NotificationType = 'bookings' | 'payments' | 'promos' | 'other'

export interface NotificationSeedItem {
  id: string
  title: string
  message: string
  time: string
  icon: string
  read: boolean
  type?: NotificationType
  actionTo?: { name: string; params?: { id: string } }
}

export const NOTIFICATIONS_SEED: NotificationSeedItem[] = [
  { id: '1', title: 'Booking accepted', message: 'Juan D. accepted your booking for Toyota Innova 2022 (Feb 10–12).', time: '2 hours ago', icon: 'mdi-calendar-check', read: false, type: 'bookings', actionTo: { name: 'client-booking-detail', params: { id: '1' } } },
  { id: '2', title: 'Payment received', message: 'Your payment of ₱5,000 for booking #1234 was received.', time: '1 day ago', icon: 'mdi-currency-php', read: false, type: 'payments', actionTo: { name: 'client-bookings' } },
  { id: '3', title: 'Payout sent', message: 'Your payout of ₱7,500 was sent to your GCash account.', time: '3 days ago', icon: 'mdi-bank-transfer-out', read: true, type: 'payments', actionTo: { name: 'car-owner-earnings' } },
  { id: '4', title: 'New promo', message: 'Use BULOD10 for 10% off on 1-day booking.', time: '5 days ago', icon: 'mdi-tag-percent', read: true, type: 'promos', actionTo: { name: 'client-promo' } },
]
