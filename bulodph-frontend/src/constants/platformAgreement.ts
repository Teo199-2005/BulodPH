/**
 * Platform agreement copy for BulodPH.
 * Purpose: Make clear we are a peer-to-peer platform only; no liability for theft, damage, or disputes between users.
 */

export const PLATFORM_DISCLAIMER_SHORT =
  'BulodPH is a platform connecting vehicle owners and renters. We do not own, operate, or insure vehicles. We are not liable for theft, damage, loss, or disputes—see Terms.'

/** Short disclaimer for banners on browse, vehicle detail, etc. */
export const LIABILITY_DISCLAIMER_BANNER =
  'BulodPH is a platform only. We are not liable for vehicle theft, damage, loss of property, or accidents. Your use and any rental are at your own risk.'

/** Car owner (host) agreement: shown before accessing car-owner dashboard. */
export const CAR_OWNER_AGREEMENT = {
  title: 'Car Owner Platform Agreement',
  version: '1',
  paragraphs: [
    'By using BulodPH as a vehicle owner (“Host”), you agree to the following:',
    '**BulodPH is a platform only.** We provide technology to connect you with renters. We are not a rental company, we do not own your vehicle, and we do not take possession or control of your vehicle at any time.',
    '**Your responsibility.** You are solely responsible for your vehicle, including its condition, insurance, and compliance with local laws. You enter into a direct agreement with each renter. BulodPH is not a party to that agreement.',
    '**No liability for loss or damage.** BulodPH is not liable for theft, damage, loss, or any claim arising from the use of your vehicle by a renter or any third party. Disputes regarding the vehicle (including theft or damage) are between you and the renter. You may pursue your own insurance or legal remedies.',
    '**Listing and handover.** You represent that you have the right to list the vehicle and that the information you provide is accurate. Handover and return are your responsibility; BulodPH does not supervise or guarantee any handover.',
    'By clicking “I have read and accept”, you confirm that you have read this agreement and accept these terms before using the Car rental owner dashboard.',
  ],
}

/** Client (renter) agreement: shown before checkout / confirm payment. */
export const CLIENT_RENTAL_AGREEMENT = {
  title: 'Rental Terms & Platform Disclaimer',
  version: '1',
  paragraphs: [
    'By completing this booking, you agree to the following:',
    '**BulodPH is a platform only.** We connect you with independent car rental companies. We do not own, operate, or insure the vehicles. Your rental contract is between you and the car rental company.',
    '**Your responsibility.** You are responsible for using the vehicle in accordance with the host’s rules and the law. You must return the vehicle on time and in the condition received. You may be liable for damage, loss, or penalties under the host’s terms.',
    '**No liability for theft or loss.** BulodPH is not liable for theft of the vehicle, damage, loss of property, accidents, or any dispute between you and the rental. Any such claims are between you and the rental (and their insurance, if any).',
    '**Payment and cancellation.** Payment is processed in accordance with our payment terms. Cancellation and refund rules are as stated at the time of booking. Disputes about the rental (including condition, handover, or return) are between you and the rental.',
    'By checking the box and proceeding to pay, you confirm that you have read and accept these terms for this booking.',
  ],
}

/** Short insurance disclaimer for checkout/booking bar. */
export const INSURANCE_DISCLAIMER_SHORT =
  'BulodPH does not insure vehicles. Insurance is the responsibility of the car rental owner. For claims related to theft or damage, contact the rental directly.'

/** Cancellation policy summary for checkout. */
export const CANCELLATION_POLICY_SHORT =
  'Free cancellation up to 24 hours before pickup. Late cancellations may be subject to fees—see Terms for full policy.'
