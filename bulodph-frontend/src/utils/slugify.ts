/**
 * Convert string to URL-safe slug.
 * Matches logic in useCarRentalProfiles for rental routes.
 */
export function slugify(str: string): string {
  return str
    .toLowerCase()
    .replace(/[^a-z0-9]+/g, '-')
    .replace(/^-|-$/g, '')
}
