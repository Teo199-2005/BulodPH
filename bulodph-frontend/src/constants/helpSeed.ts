/**
 * FAQ and help content for Client and Car Rental Owner help pages.
 */

export interface FaqItem {
  id: string
  question: string
  answer: string
}

export const CLIENT_FAQ_SEED: FaqItem[] = [
  {
    id: '1',
    question: 'How do I book a vehicle?',
    answer: 'Browse rides, pick a vehicle, and click Book now. Choose your dates and proceed to checkout. Pay with GCash or Maya to confirm. You’ll get a confirmation and the host’s contact for pickup.',
  },
  {
    id: '2',
    question: 'What is the cancellation policy?',
    answer: 'Free cancellation up to 24 hours before pickup. After that, cancellations may be subject to a fee. Cancel from My bookings by opening the booking and choosing Cancel.',
  },
  {
    id: '3',
    question: 'What payment methods are accepted?',
    answer: 'We accept GCash and Maya. Add or set a default payment method under Payments. You pay via GCash or Maya after the rental approves your booking.',
  },
  {
    id: '4',
    question: 'What if I damage the vehicle?',
    answer: 'Report any damage to the rental and to BulodPH as soon as possible. A security deposit may apply; see the vehicle’s rental terms. For disputes, contact support.',
  },
  {
    id: '5',
    question: 'Can I modify my booking dates?',
    answer: 'You can request a change from the booking detail page if the new dates are available. Contact the rental or support if you need help.',
  },
]

export const CAR_OWNER_FAQ_SEED: FaqItem[] = [
  {
    id: '1',
    question: 'How do I list my vehicle?',
    answer: 'Go to My vehicles and click Add vehicle. Fill in brand, model, photos (main + 4 sides), price, and availability. Submit for approval. Once approved, renters can book.',
  },
  {
    id: '2',
    question: 'What is the hand-off checklist?',
    answer: 'At hand-off: verify renter ID, check fuel level, note any existing damage (photos), hand over keys and documents. At return: check fuel, inspect for damage, collect keys.',
  },
  {
    id: '3',
    question: 'What if the renter is late?',
    answer: 'Contact the renter via the details in the booking. If they don’t show within a reasonable time, you can mark the booking and contact BulodPH support for guidance.',
  },
  {
    id: '4',
    question: 'How and when do I get paid?',
    answer: 'Earnings from completed trips go to your balance. Set your payout method (GCash, Maya, or bank) under Payout method. Payouts run on schedule (e.g. weekly); see Earnings for details.',
  },
]
