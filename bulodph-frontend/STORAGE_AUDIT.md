# Storage & Database Audit

This document describes what data is stored where (database vs localStorage) and what persists across logout/login.

## Database (Backend API)

| Data | Endpoint | Status |
|------|----------|--------|
| **Users** (auth, profile) | `/login`, `/register`, `/me` | ✅ Persisted |
| **Profile** (name, email, mobile) | `PUT /profile` | ✅ Persisted to `users` table |
| **Profile avatar** | `POST /profile/avatar` | ✅ Persisted to `users.avatar_url` + file in `storage/app/public/avatars/` |
| **Password change** | `POST /profile/change-password` | ✅ Persisted |

**Backend setup for avatar:** Run `php artisan storage:link` to create the public storage symlink so avatar images are served at `/storage/avatars/...`.

---

## localStorage (User-scoped, survives logout/login)

Data keyed by user ID so each user has their own data. Falls back when API returns empty or is not implemented.

| Data | Storage Key | Used When |
|------|-------------|-----------|
| **Payment methods** (client) | `bulodph_payment_methods_{userId}` | API returns empty |
| **Payout methods** (car owner/marketing) | `bulodph_payout_methods_{userId}` | Always (no API) |
| **Favorites** (saved vehicles) | `bulodph_favorites_{userId}` | Always |
| **Cart** | `bulodph_cart_{userId}` | Always |
| **Notifications** (read state) | `bulodph_notifications_{userId}` | Always |
| **Client bookings** | `bulodph_client_bookings_{userId}` | API returns empty |
| **Car owner bookings** | `bulodph_car_owner_bookings_{userId}` | API returns empty |
| **Car rental profile** (logo, bio) | `bulodph_car_rental_profile_{userId}` | API returns null |
| **Profile avatar** (fallback) | `bulodph_avatar_{userId}` | API returns null (data URL) |
| **Notification prefs** | `bulodph_notification_prefs_{userId}` | Always |
| **Admin car owners** | `bulodph_admin_car_owners_{userId}` | API returns empty |
| **Admin clients** | `bulodph_admin_clients_{userId}` | API returns empty |
| **Admin marketing staff** | `bulodph_admin_marketing_staff_{userId}` | API returns empty |

---

## sessionStorage (Session only, cleared on logout)

| Data | Storage Key | Purpose |
|------|-------------|---------|
| **Auth token** | `auth_token` | Bearer token for API |
| **User** | `hpa_user` | Current user object (id, email, roles, etc.) |

---

## Other localStorage (Not user-scoped)

| Data | Storage Key | Purpose |
|------|-------------|---------|
| **Locale** | `hpa_locale` | UI language (en/ar) |
| **Dashboard promos** | `bulodph_dashboard_promos` | Admin promo banners |
| **Agreement acceptance** | `*_accepted` | Terms/Privacy acceptance |

---

## API Stubs (Return empty; frontend uses localStorage/seed)

These backend routes return empty arrays or null. Frontend loads from localStorage or seed when empty:

- `GET /client/bookings` → `[]`
- `GET /car-owner/bookings` → `[]`
- `GET /vehicles` → `[]`
- `GET /admin/car-owners` → `[]`
- `GET /admin/clients` → `[]`
- `GET /admin/marketing-staff` → `[]`
- `GET /car-owner/rental-profile` → `null`
- `GET /car-rentals` → `[]`

---

## Future: Full Database Persistence

To move car rental data to the database, the backend would need:

1. Migrations for: `vehicles`, `bookings`, `car_owners`, `payment_methods`, etc.
2. Models and controllers to replace stub responses
3. Frontend already calls these APIs; switching to real data would work once backend persists
