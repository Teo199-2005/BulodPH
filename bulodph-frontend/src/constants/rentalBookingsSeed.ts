/**
 * Seed data for admin Total Bookings (rental records).
 */

export type RentalBookingStatus = 'Active' | 'Pending' | 'Approved' | 'Completed' | 'Cancelled' | 'Rejected' | 'Overdue' | 'Pending cancellation'

export interface RentalBookingRecord {
  id: string
  transactionId: string
  vehicleName: string
  businessName: string
  /** Client user id (for admin filtering by renter). */
  clientUserId?: string | null
  clientName: string
  clientEmail: string
  startDate: string
  endDate: string
  amount: number
  status: RentalBookingStatus
  archived?: boolean
  /** ISO date when client payment was recorded (admin "Mark as paid"). */
  paidAt?: string | null
}

export const RENTAL_BOOKINGS_SEED: RentalBookingRecord[] = [
  { id: '1', transactionId: 'LfJcsBZBSA0PEzseDdj5', vehicleName: 'toyota civic', businessName: "Calli's Rental", clientName: 'Second Two', clientEmail: 'perdu1107@gmail.com', startDate: '11/23/2025', endDate: '11/29/2025', amount: 23994, status: 'Pending' },
  { id: '2', transactionId: '9LivXIapY3WGkZu3Gdmd', vehicleName: 'toyota civic', businessName: "Calli's Rental", clientName: 'Third Three', clientEmail: 'twitch.val007@gmail.com', startDate: '11/16/2025', endDate: '11/17/2025', amount: 3999, status: 'Completed' },
  { id: '3', transactionId: 'aOaywc7avvjRnxpUp979', vehicleName: 'toyota civic', businessName: "Calli's Rental", clientName: 'Second Two', clientEmail: 'perdu1107@gmail.com', startDate: '11/25/2025', endDate: '11/28/2025', amount: 11997, status: 'Pending' },
  { id: '4', transactionId: 'LvjYWYnwUYzq1eJ6Jb9C', vehicleName: 'toyota civic', businessName: "Calli's Rental", clientName: 'First One', clientEmail: 'tabinjl107@gmail.com', startDate: '11/18/2025', endDate: '11/21/2025', amount: 11997, status: 'Cancelled' },
  { id: '5', transactionId: 'obwBek5s8GVYl1j3HnUH', vehicleName: 'XLE RAV4', businessName: "Collin's Rental", clientName: 'Another Two', clientEmail: 'tabinjl107@gmail.com', startDate: '11/28/2025', endDate: '11/29/2025', amount: 4000, status: 'Cancelled' },
  { id: '6', transactionId: 'iydUoaPZ5k0XTos5y7FH', vehicleName: 'XLE RAV4', businessName: "Collin's Rental", clientName: 'Another Two', clientEmail: 'tabinjl107@gmail.com', startDate: '11/3/2025', endDate: '11/7/2025', amount: 16000, status: 'Cancelled' },
  { id: '7', transactionId: 'vtynZUr4y1oSABfsGAxE', vehicleName: 'XLE RAV4', businessName: "Collin's Rental", clientName: 'Another Two', clientEmail: 'tabinjl107@gmail.com', startDate: '10/31/2025', endDate: '11/1/2025', amount: 474500, status: 'Completed' },
  { id: '8', transactionId: 'weDaH8DUCcec35IQpTIm', vehicleName: 'Civic Toyota', businessName: "CMae's Rental", clientName: 'John Lawrenz Tabin', clientEmail: 'perdu1107@gmail.com', startDate: '10/24/2025', endDate: '10/25/2025', amount: 3000, status: 'Cancelled' },
  { id: '9', transactionId: 'wRS5rFZD14HILOkWRU3E', vehicleName: 'Hiace Toyota Commuter', businessName: "CMae's Rental", clientName: 'Madi Latta', clientEmail: 'perdu1107@gmail.com', startDate: '10/24/2025', endDate: '10/25/2025', amount: 3000, status: 'Cancelled' },
  { id: '10', transactionId: 'zvWVtwSTShKBDRziy9ge', vehicleName: 'toyota civic', businessName: "CMae's Rental", clientName: 'Madi Latta', clientEmail: 'perdu1107@gmail.com', startDate: '10/15/2025', endDate: '10/20/2025', amount: 10000, status: 'Cancelled' },
  { id: '11', transactionId: 'xPpTThje8rAkhGatUMAH', vehicleName: 'Hiace Toyota Commuter', businessName: "CMae's Rental", clientName: 'Madi Latta', clientEmail: 'perdu1107@gmail.com', startDate: '10/29/2025', endDate: '10/31/2025', amount: 6000, status: 'Pending' },
  { id: '12', transactionId: 'wWfDwuYnxRMXdDfC1pcN', vehicleName: 'toyota civic', businessName: "CMae's Rental", clientName: 'Unknown User', clientEmail: 'bangtwuce@gmail.com', startDate: '9/30/2025', endDate: '10/4/2025', amount: 8000, status: 'Pending' },
  { id: '13', transactionId: 'zN9sNYorivf2lg6gDb1a', vehicleName: 'toyota civic', businessName: "CMae's Rental", clientName: 'Unknown User', clientEmail: 'perdu1107@gmail.com', startDate: '9/27/2025', endDate: '9/28/2025', amount: 2000, status: 'Cancelled' },
]

export function formatRentalAmount(amount: number): string {
  return '₱' + amount.toLocaleString('en-PH')
}

export function getUniqueBusinesses(records: RentalBookingRecord[]): string[] {
  const set = new Set(records.map(r => r.businessName))
  return Array.from(set).sort()
}
