/**
 * Seed reviews per vehicle for BulodPH vehicle detail (read-only).
 */
export interface ReviewSeedItem {
  id: string
  vehicleId: string
  authorName: string
  rating: number
  comment: string
  date: string
}

export const REVIEWS_SEED: ReviewSeedItem[] = [
  { id: 'r1', vehicleId: '1', authorName: 'Maria S.', rating: 5, comment: 'Smooth ride, very clean. Host was on time for hand-off. Will book again.', date: 'Jan 15, 2026' },
  { id: 'r2', vehicleId: '1', authorName: 'Robert W.', rating: 4, comment: 'Good condition. Minor scratch on rear bumper as noted—no surprise.', date: 'Jan 8, 2026' },
  { id: 'r3', vehicleId: '2', authorName: 'Patricia M.', rating: 5, comment: 'Perfect for city errands. Fuel-efficient and easy to park.', date: 'Jan 20, 2026' },
  { id: 'r4', vehicleId: '2', authorName: 'James L.', rating: 4, comment: 'Great car. Pickup was at Ilagan as agreed.', date: 'Jan 12, 2026' },
  { id: 'r5', vehicleId: '3', authorName: 'Ana G.', rating: 5, comment: 'Comfortable sedan. AC works well. Host very responsive.', date: 'Jan 22, 2026' },
  { id: 'r6', vehicleId: '3', authorName: 'Carlos R.', rating: 4, comment: 'Reliable car for a weekend trip. Would recommend.', date: 'Jan 5, 2026' },
  { id: 'r7', vehicleId: '4', authorName: 'Liza T.', rating: 5, comment: 'Car was spotless. Hand-off and return were hassle-free.', date: 'Jan 6, 2026' },
]

export function getReviewsForVehicle(vehicleId: string): ReviewSeedItem[] {
  return REVIEWS_SEED.filter(r => r.vehicleId === vehicleId).sort(
    (a, b) => new Date(b.date).getTime() - new Date(a.date).getTime()
  )
}
