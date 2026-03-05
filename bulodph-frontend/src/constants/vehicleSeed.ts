/**
 * Shared vehicle seed for BulodPH – browse, car owner listings, admin listings.
 * Uses Unsplash images matched to vehicle type (minivan, sedan, SUV, etc.).
 */

export type CarType = 'Sedan' | 'SUV' | 'MPV' | 'Hatchback' | 'Van'
export type TransmissionType = 'Automatic' | 'Manual'
export type FuelType = 'Gasoline' | 'Diesel' | 'Electric'
export type FuelReturnPolicy = 'Return with Same Level' | 'Full Tank' | 'Empty'
export type RentalMode = 'driver_only' | 'self_drive_only' | 'both'

/** Vehicle photographed from 4 sides for listing and detail view */
export interface VehicleImagesFourSides {
  front: string
  rear: string
  left: string
  right: string
}

export interface VehicleSeedItem {
  id: string
  /** Owner user id when from API (used for car owner dashboard "My vehicles") */
  userId?: string
  name: string
  type: 'Car'
  location: string
  pricePerDay: number
  /** If set and > pricePerDay, show as "was ₱X" with discounted price */
  originalPricePerDay?: number
  description: string
  /** Short tags shown as chips on cards (e.g. 7-seater, MPV, AC, Verified by BulodPH) */
  tags?: string[]
  image: string
  /** Vehicle photographed from 4 sides (front, rear, left, right) for detail view */
  imagesFourSides?: VehicleImagesFourSides
  /** Optional additional image URLs (max 5 for UI) */
  additionalImages?: string[]
  /** Known issues or notes (e.g. minor scratches, AC condition) – shown on detail view */
  knownIssues?: string
  hostName?: string
  status?: 'Available' | 'Unavailable'
  approved?: boolean
  /** When true, vehicle is hidden from public browse (e.g. maintenance, direct booking). */
  hiddenFromListing?: boolean
  featured?: boolean
  verified?: boolean
  hasPermit?: boolean
  /** Rental-specific fields */
  brand?: string
  model?: string
  carNumber?: string
  businessPermitNumber?: string
  businessName?: string
  carType?: CarType
  capacity?: number
  overdueChargeRate?: number
  securityDeposit?: number
  transmission?: TransmissionType
  fuelType?: FuelType
  fuelReturnPolicy?: FuelReturnPolicy
  /** Rental mode: driver only, self-drive only, or both */
  rentalMode?: RentalMode
  minRentalPeriodHours?: number
  reviewCount?: number
  /** Record info (admin): display only, e.g. "10/29/2025" */
  createdAt?: string
  updatedAt?: string
}

// Unsplash images: minivan, sedan, hatchback, SUV, car
const U = (id: string) => `https://images.unsplash.com/photo-${id}?w=800&q=80&fit=crop`

/** 4-side image sets: car (front, rear, left, right) */
const FOUR_SIDES_CAR: VehicleImagesFourSides = {
  front: U('1544636331-e26879cd4d9b'),
  rear: U('1533473359331-0135ef1b58bf'),
  left: U('1619767886558-efdc259cde1a'),
  right: U('1552519507-da3b142c6e3d'),
}
const FOUR_SIDES_SUV: VehicleImagesFourSides = {
  front: U('1519641471654-76ce0107ad1b'),
  rear: U('1533473359331-0135ef1b58bf'),
  left: U('1549317661-bd32c8ce0db2'),
  right: U('1544636331-e26879cd4d9b'),
}
/** Registered business owners for dropdown (e.g. in Add Vehicle form) */
export const BUSINESS_OWNERS = [
  "Collin's Rental",
  "Juliet's Rental",
  "Zkyrie's Car Rental",
  "Calli's Rental",
  "C",
  "Vigan Car Rental",
  "Demo Car rental owner",
] as const

export const VEHICLE_SEED: VehicleSeedItem[] = [
  {
    id: '1',
    name: 'XLE RAV4',
    type: 'Car',
    location: 'Vigan',
    pricePerDay: 3200,
    originalPricePerDay: 4000,
    description: 'Spacious SUV, ideal for family trips.',
    tags: ['SUV', '12 Seats'],
    image: U('1519641471654-76ce0107ad1b'),
    imagesFourSides: FOUR_SIDES_SUV,
    hostName: "Collin's Rental",
    businessName: "Collin's Rental",
    brand: 'Toyota',
    model: 'XLE RAV4',
    carNumber: 'sj3sj91',
    carType: 'SUV',
    capacity: 12,
    transmission: 'Automatic',
    fuelType: 'Diesel',
    fuelReturnPolicy: 'Return with Same Level',
    overdueChargeRate: 500,
    securityDeposit: 5000,
    rentalMode: 'both',
    minRentalPeriodHours: 24,
    status: 'Available',
    approved: true,
    featured: false,
    verified: true,
    hasPermit: false,
    reviewCount: 0,
    createdAt: '10/29/2025',
    updatedAt: '10/29/2025',
  },
  {
    id: '2',
    name: 'Carolla Toyota',
    type: 'Car',
    location: 'Vigan',
    pricePerDay: 3600,
    originalPricePerDay: 4500,
    description: 'Reliable sedan for daily use.',
    tags: ['Sedan', '4 Seats'],
    image: U('1619767886558-efdc259cde1a'),
    imagesFourSides: FOUR_SIDES_CAR,
    knownIssues: 'Minor scratch on rear bumper (cosmetic only).',
    hostName: "Juliet's Rental",
    businessName: "Juliet's Rental",
    brand: 'Toyota',
    model: 'Corolla',
    carNumber: 'gwi201w',
    carType: 'Sedan',
    capacity: 4,
    transmission: 'Automatic',
    fuelType: 'Diesel',
    fuelReturnPolicy: 'Return with Same Level',
    overdueChargeRate: 500,
    securityDeposit: 3000,
    rentalMode: 'self_drive_only',
    minRentalPeriodHours: 24,
    status: 'Available',
    approved: true,
    featured: false,
    verified: true,
    hasPermit: false,
    reviewCount: 0,
    createdAt: '10/28/2025',
    updatedAt: '10/29/2025',
  },
  {
    id: '3',
    name: 'toyota Toyota Commuter',
    type: 'Car',
    location: 'Vigan',
    pricePerDay: 2000,
    description: 'Economy sedan.',
    tags: ['Sedan', '4 Seats'],
    image: U('1549317661-bd32c8ce0db2'),
    imagesFourSides: FOUR_SIDES_CAR,
    hostName: "Zkyrie's Car Rental",
    businessName: "Zkyrie's Car Rental",
    brand: 'Toyota',
    model: 'Commuter',
    carNumber: 'wqe241',
    carType: 'Sedan',
    capacity: 4,
    transmission: 'Automatic',
    fuelType: 'Gasoline',
    fuelReturnPolicy: 'Return with Same Level',
    overdueChargeRate: 500,
    rentalMode: 'driver_only',
    minRentalPeriodHours: 12,
    status: 'Available',
    approved: true,
    featured: false,
    verified: true,
    hasPermit: false,
    reviewCount: 0,
    createdAt: '10/27/2025',
    updatedAt: '10/28/2025',
  },
  {
    id: '4',
    name: 'toyota civic',
    type: 'Car',
    location: 'Vigan',
    pricePerDay: 3999,
    description: 'Popular sedan.',
    tags: ['Sedan', '4 Seats'],
    image: U('1552519507-da3b142c6e3d'),
    imagesFourSides: FOUR_SIDES_CAR,
    hostName: "Calli's Rental",
    businessName: "Calli's Rental",
    brand: 'Honda',
    model: 'Civic',
    carNumber: 'fw213a',
    carType: 'Sedan',
    capacity: 4,
    transmission: 'Automatic',
    fuelType: 'Diesel',
    fuelReturnPolicy: 'Return with Same Level',
    overdueChargeRate: 200,
    rentalMode: 'both',
    minRentalPeriodHours: 36,
    status: 'Available',
    approved: true,
    featured: false,
    verified: true,
    hasPermit: false,
    reviewCount: 0,
    createdAt: '10/26/2025',
    updatedAt: '10/27/2025',
  },
  {
    id: '5',
    name: 'Toyota Hilux',
    type: 'Car',
    location: 'Vigan',
    pricePerDay: 100,
    description: 'Pickup truck.',
    tags: ['Sedan', '4 Seats'],
    image: U('1533473359331-0135ef1b58bf'),
    imagesFourSides: FOUR_SIDES_SUV,
    knownIssues: 'AC may need refill in peak summer; otherwise runs cold.',
    hostName: 'C',
    businessName: 'C',
    brand: 'Toyota',
    model: 'Hilux',
    carNumber: 'ADC123',
    businessPermitNumber: 'BP-2023-092',
    carType: 'Sedan',
    capacity: 4,
    transmission: 'Automatic',
    fuelType: 'Gasoline',
    fuelReturnPolicy: 'Return with Same Level',
    overdueChargeRate: 1000,
    rentalMode: 'both',
    minRentalPeriodHours: 24,
    status: 'Available',
    approved: true,
    featured: false,
    verified: true,
    hasPermit: true,
    reviewCount: 0,
    createdAt: '10/25/2025',
    updatedAt: '10/26/2025',
  },
  {
    id: '6',
    name: 'toyota RAV4 XLE AWD 2024',
    type: 'Car',
    location: 'Vigan',
    pricePerDay: 2000,
    description: 'SUV AWD 2024.',
    tags: ['SUV', '4 Seats'],
    image: U('1544636331-e26879cd4d9b'),
    imagesFourSides: FOUR_SIDES_SUV,
    hostName: 'C',
    businessName: 'C',
    brand: 'Toyota',
    model: 'RAV4 XLE AWD 2024',
    carNumber: 'wqe241',
    businessPermitNumber: 'dwwd',
    carType: 'SUV',
    capacity: 4,
    transmission: 'Automatic',
    fuelType: 'Gasoline',
    fuelReturnPolicy: 'Return with Same Level',
    overdueChargeRate: 500,
    rentalMode: 'self_drive_only',
    minRentalPeriodHours: 24,
    status: 'Available',
    approved: true,
    featured: false,
    verified: true,
    hasPermit: true,
    reviewCount: 0,
    createdAt: '10/24/2025',
    updatedAt: '10/25/2025',
  },
  {
    id: '7',
    name: 'Toyota Innova 2022',
    type: 'Car',
    location: 'Cauayan',
    pricePerDay: 2500,
    description: '7-seater MPV, AC, ideal for family trips and out-of-town. Verified by BulodPH.',
    tags: ['7-seater', 'MPV', 'AC', 'Family trips', 'Verified by BulodPH'],
    image: U('1544636331-e26879cd4d9b'),
    imagesFourSides: FOUR_SIDES_SUV,
    hostName: 'Juan D.',
    status: 'Available',
    approved: true,
    featured: true,
    verified: true,
    hasPermit: true,
    securityDeposit: 4000,
    rentalMode: 'both',
    minRentalPeriodHours: 24,
    createdAt: '10/23/2025',
    updatedAt: '10/24/2025',
  },
  {
    id: '9',
    name: 'Toyota Fortuner 2022',
    type: 'Car',
    location: 'Ilagan',
    pricePerDay: 3800,
    description: 'Full-size SUV, powerful and comfortable for long drives.',
    tags: ['Full-size SUV', 'Powerful', 'Comfortable', 'Long drives'],
    image: U('1533473359331-0135ef1b58bf'),
    imagesFourSides: FOUR_SIDES_SUV,
    hostName: 'Miguel P.',
    status: 'Available',
    approved: true,
    featured: true,
    verified: true,
    hasPermit: true,
    rentalMode: 'driver_only',
    minRentalPeriodHours: 48,
    createdAt: '10/21/2025',
    updatedAt: '10/22/2025',
  },
  {
    id: 'demo-1',
    name: 'Toyota Innova 2022',
    type: 'Car',
    location: 'Cauayan',
    pricePerDay: 2500,
    description: '7-seater MPV, AC, ideal for family trips. Demo vehicle.',
    tags: ['7-seater', 'MPV', 'AC', 'Verified by BulodPH'],
    image: U('1544636331-e26879cd4d9b'),
    imagesFourSides: FOUR_SIDES_SUV,
    hostName: 'Demo Car rental owner',
    businessName: 'Demo Car rental owner',
    brand: 'Toyota',
    model: 'Innova',
    carType: 'MPV',
    capacity: 7,
    status: 'Available',
    approved: true,
    featured: false,
    verified: true,
    hasPermit: true,
    rentalMode: 'both',
    minRentalPeriodHours: 24,
    createdAt: '10/20/2025',
    updatedAt: '10/20/2025',
  },
]

export function getVehicleById(id: string): VehicleSeedItem | undefined {
  return VEHICLE_SEED.find(v => v.id === id)
}

export function getVehiclesByIds(ids: string[]): VehicleSeedItem[] {
  return ids.map(id => getVehicleById(id)).filter(Boolean) as VehicleSeedItem[]
}

/** Display label for rental mode (for chips and filters). */
export function rentalModeLabel(mode: RentalMode | undefined): string {
  if (!mode) return 'Both'
  if (mode === 'driver_only') return 'Driver only'
  if (mode === 'self_drive_only') return 'Self-drive'
  return 'Both'
}

/** Short chip text for min rental period (e.g. "12h min", "1 day min"). */
export function minRentalChipText(hours: number | undefined | null): string | null {
  if (hours == null || hours < 1) return null
  if (hours === 24) return '1 day min'
  if (hours < 24) return `${hours}h min`
  if (hours % 24 === 0) return `${hours / 24} days min`
  return `${hours}h min`
}
