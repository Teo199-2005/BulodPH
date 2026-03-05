# BulodPH Frontend – API Endpoints Reference

This document lists API endpoints the frontend calls. Implement these on your backend so the app works with real data and payment gateways.

**Base URL:** `VITE_API_URL` (e.g. `http://localhost:8000/api`)  
**Auth:** `Authorization: Bearer <token>` for protected routes.

---

## Dashboard

| Method | Endpoint | Description |
|--------|----------|-------------|
| GET | `/dashboard/kpis` | Query: `role`. Returns KPIs (totalBookings, totalUsers, totalRevenue, etc.) |
| GET | `/dashboard/weekly-bookings` | Query: `range` (week \| month \| year). Returns labels + completed/pending/cancelled arrays |
| GET | `/dashboard/car-types` | Most rented car types with count and percent |

---

## Bookings

| Method | Endpoint | Description |
|--------|----------|-------------|
| GET | `/bookings` | Admin rental bookings. Query: `archived` (boolean) |
| GET | `/bookings/:id` | Single rental booking |
| POST | `/bookings` | Create booking (vehicleId, clientId?, startDate, endDate, amount, meetUp?, specialRequests?) |
| PATCH | `/bookings/:id/status` | Body: `{ status }` |
| PATCH | `/bookings/:id/archive` | Body: `{ archived: boolean }` |
| GET | `/client/bookings` | Current user's client bookings |
| GET | `/car-owner/bookings` | Current user's car-owner bookings |
| PATCH | `/car-owner/bookings/:id/status` | Body: `{ status }` (Requested → Confirmed/Declined, etc.) |

---

## Vehicles

| Method | Endpoint | Description |
|--------|----------|-------------|
| GET | `/vehicles` | Query: `approved`, `ownerId`. List vehicles (shape like VehicleSeedItem) |
| GET | `/vehicles/:id` | Single vehicle |
| POST | `/vehicles` | Create vehicle |
| PUT | `/vehicles/:id` | Update vehicle |
| DELETE | `/vehicles/:id` | Delete vehicle |

---

## Payouts (Admin)

| Method | Endpoint | Description |
|--------|----------|-------------|
| GET | `/payouts/pending` | Pending payout requests |
| GET | `/payouts/history` | Query: `limit`. Paid/rejected history |
| POST | `/payouts/:id/approve` | Approve and process payout |
| POST | `/payouts/:id/reject` | Body: `{ reason? }` |

---

## Admin – Clients

| Method | Endpoint | Description |
|--------|----------|-------------|
| GET | `/admin/clients` | Query: `search`. List clients (ClientSeedItem shape) |
| GET | `/admin/clients/:id` | Single client |
| POST | `/admin/clients` | Create client |
| PUT | `/admin/clients/:id` | Update client |
| DELETE | `/admin/clients/:id` | Delete client |

---

## Admin – Car Owners

| Method | Endpoint | Description |
|--------|----------|-------------|
| GET | `/admin/car-owners` | Query: `search` |
| GET | `/admin/car-owners/:id` | Single car owner |
| POST | `/admin/car-owners` | Create |
| PUT | `/admin/car-owners/:id` | Update |
| DELETE | `/admin/car-owners/:id` | Delete |

---

## Admin – Marketing Staff

| Method | Endpoint | Description |
|--------|----------|-------------|
| GET | `/admin/marketing-staff` | Query: `search` |
| GET | `/admin/marketing-staff/:id` | Single partner |
| POST | `/admin/marketing-staff` | Create |
| PUT | `/admin/marketing-staff/:id` | Update |
| DELETE | `/admin/marketing-staff/:id` | Delete |

---

## Reports

| Method | Endpoint | Description |
|--------|----------|-------------|
| GET | `/reports/financial` | Query: `period`, `startDate`, `endDate`. Financial summary (totalRevenue, paidToOwners, etc.) |
| GET | `/reports/bookings` | Query: `period`, `startDate`, `endDate`. Booking stats (completed, scheduled, pending, cancelled) |

---

## Profile

| Method | Endpoint | Description |
|--------|----------|-------------|
| GET | `/profile` | Current user profile (User shape) |
| PUT | `/profile` | Body: `{ name?, email?, mobile?, address? }` |
| POST | `/profile/avatar` | FormData: `avatar` (file). Returns `{ avatar_url }` or `{ data: { avatar_url } }` |
| POST | `/profile/change-password` | Body: `{ current_password, new_password }` |

---

## Car Rental Profile (Car Owner)

| Method | Endpoint | Description |
|--------|----------|-------------|
| GET | `/car-owner/rental-profile` | Current car owner's rental company profile |
| PUT | `/car-owner/rental-profile` | Body: `{ businessName?, logoUrl?, bio?, city?, province?, address?, phone?, email?, businessPermitNumber?, businessAddress? }` |
| POST | `/car-owner/rental-profile/logo` | FormData: `logo` (file). Returns `{ logo_url }` |

---

## Car Rentals (Client Browse)

| Method | Endpoint | Description |
|--------|----------|-------------|
| GET | `/car-rentals` | List car rental companies. Query: `search`, `location` |
| GET | `/car-rentals/:idOrSlug` | Single car rental profile |
| GET | `/car-rentals/:idOrSlug/vehicles` | Vehicles belonging to this rental company |

---

## Payments (GCash / Maya)

| Method | Endpoint | Description |
|--------|----------|-------------|
| POST | `/payments/create` | Body: `bookingId?`, `vehicleId?`, `startDate?`, `endDate?`, `amount`, `method` (gcash \| maya \| card), `promoCode?`, `returnUrl`, `cancelUrl?`. Returns `{ redirect_url, reference_id, status }` |
| GET | `/payments/status/:referenceId` | Check payment status. Returns `{ status, bookingId? }` |

When `redirect_url` is present, the frontend redirects the user to the payment gateway (e.g. GCash/Maya checkout). After payment, the gateway redirects back to `returnUrl`; the frontend can call `GET /payments/status/:referenceId` to confirm and update booking status.
