# BulodPH Performance Guide

## Backend Optimizations (Implemented)

### Pagination
- **Bookings** (`/api/bookings`): `per_page` (default 20, max 100)
- **Vehicles** (`/api/vehicles`): `per_page` (default 20, max 100)
- **Payouts** (`/api/payouts/pending`, `/api/payouts/history`): `per_page` (default 20, max 100)
- Response includes `meta`: `current_page`, `last_page`, `per_page`, `total`

### Limits
- **Client bookings** (`/api/client/bookings`): `per_page` (default 50, max 100)
- **Car owner bookings** (`/api/car-owner/bookings`): `per_page` (default 50, max 100)
- **Announcements**: admin 100, user 50
- **Car rentals** (public): limit 200
- **Weekly bookings**: DB-level date filter + limit 5000
- **Fraud risk flags**: limit 100

### Caching
- **Public car rentals** (`/api/car-rentals`, `/api/car-rentals/{id}`): `Cache-Control: public, max-age=300, s-maxage=300` (5 min)

### Query Optimization
- **Weekly bookings**: Filters by date range at DB level instead of loading all and filtering in PHP
- **Eager loading**: `with('vehicle')`, `with('creator:id,name,email')` where needed

## Frontend Optimizations (Implemented)

### Build
- **Manual chunks**: vue-vendor, vuetify, vue-query, lib
- **chunkSizeWarningLimit**: 600 KB
- **Route lazy loading**: `() => import('@/views/...')`

### API
- **Retries**: GET requests retry up to 2× on 5xx or timeout
- **Timeout**: 12 seconds
- **Preconnect**: Google Fonts

## Recommendations

1. **CDN**: Serve static assets (JS, CSS, images) via CDN
2. **Image optimization**: WebP/AVIF, lazy loading (`loading="lazy"` on v-img where appropriate)
3. **Redis**: Use Redis for cache/store in production
4. **Database indexes**: Ensure indexes on `rental_bookings.start_date`, `vehicles.user_id`, etc.
5. **APM**: Add Laravel Telescope or similar for profiling in staging
