/**
 * Seed data for car rental company profiles.
 * Used when API doesn't provide profile data – gives clients a good browse experience.
 * Logos are stored in public/logos/ and served at /logos/rental-N.png
 */

import type { CarRentalProfile } from '@/types/carRentalProfile'

export const RENTAL_PROFILES_SEED: Partial<CarRentalProfile>[] = [
  {
    businessName: "Collin's Rental",
    logoUrl: '/logos/rental-1.png',
    bio: 'Family-owned car rental in Vigan. We offer reliable SUVs and sedans for trips around Ilocos and beyond. Well-maintained fleet, competitive rates.',
    city: 'Vigan',
    province: 'Ilocos Sur',
    address: 'Vigan City, Ilocos Sur',
    phone: '0917 123 4567',
  },
  {
    businessName: "Juliet's Rental",
    logoUrl: '/logos/rental-2.png',
    bio: 'Your trusted rental partner in Vigan. Quality sedans and economy cars for business and leisure. Book with confidence.',
    city: 'Vigan',
    province: 'Ilocos Sur',
    address: 'Vigan City, Ilocos Sur',
  },
  {
    businessName: "Zkyrie's Car Rental",
    logoUrl: '/logos/rental-3.png',
    bio: 'Affordable and reliable car rental. From economy to family-sized vehicles – we have you covered for your next trip.',
    city: 'Vigan',
    province: 'Ilocos Sur',
  },
  {
    businessName: "Calli's Rental",
    logoUrl: '/logos/rental-4.png',
    bio: 'Premium rental experience. Modern fleet, excellent service, and flexible terms for short and long-term rentals.',
    city: 'Vigan',
    province: 'Ilocos Sur',
  },
  {
    businessName: 'C',
    logoUrl: '/logos/rental-5.png',
    bio: 'Car and SUV rentals. Serving the region and nearby areas with quality vehicles and competitive pricing.',
    city: 'Cauayan',
    province: 'Isabela',
  },
  {
    businessName: 'Juan D.',
    logoUrl: '/logos/rental-6.png',
    bio: 'MPV and SUV specialist. Perfect for family trips, out-of-town getaways, and group travel.',
    city: 'Cauayan',
    province: 'Isabela',
  },
  {
    businessName: 'Maria S.',
    logoUrl: '/logos/rental-7.png',
    bio: 'Car rentals. Fuel-efficient options for city errands and short trips around Ilagan.',
    city: 'Ilagan',
    province: 'Isabela',
  },
  {
    businessName: 'Miguel P.',
    logoUrl: '/logos/rental-8.png',
    bio: 'Full-size SUV rentals. Comfortable and powerful vehicles for long drives and adventure trips.',
    city: 'Ilagan',
    province: 'Isabela',
  },
]

export function getRentalProfileSeed(businessName: string): Partial<CarRentalProfile> | undefined {
  return RENTAL_PROFILES_SEED.find(
    p => p.businessName?.toLowerCase() === businessName.toLowerCase()
  )
}
