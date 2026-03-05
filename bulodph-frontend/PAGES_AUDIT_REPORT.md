# BulodPH Frontend – Pages Audit Report

**Audit focus:** Similar issues to those fixed earlier:
- Static/seed data used where live data should be used (e.g. "Recent" sections not updating)
- Displaying initials instead of full names (e.g. car rental owner)
- UI spacing (image + text too close)
- Dead or inconsistent data sources

**Date:** 2026-02-25

---

## Fixes applied in this audit

### 1. **ClientCheckoutView.vue**
- **Issue:** Unused `VEHICLE_SEED` import; vehicles already come from `useVehicles()`.
- **Fix:** Removed the unused import.

### 2. **ClientsView.vue – Recent activity**
- **Issue:** "Recent activity" used static `CLIENT_ACTIVITY_SEED` and never reflected real bookings.
- **Fix:** Wired to live data via `useRentalBookings()`. Recent activity is now a computed value from non-archived rental records (sorted by start date, latest first, max 5). Falls back to `CLIENT_ACTIVITY_SEED` when there are no bookings. `fetchRentalBookings()` is called on mount.

### 3. **Car rental owners – Recent listings** (fixed earlier)
- **Issue:** "Recent listings" on Car rental owners page used `VEHICLE_SEED.slice(0, 4)` and did not update when new cars were added.
- **Fix:** Uses `useVehicles()` and shows the last 4 vehicles (most recent first).

### 4. **Admin Listings – owner name** (fixed earlier)
- **Issue:** Listing cards showed only initials (e.g. "DO") in the badge instead of the full car rental name.
- **Fix:** Full rental/owner name is shown under the vehicle title; badge has a tooltip with the full name.

### 5. **Admin Dashboard promos – spacing** (fixed earlier)
- **Issue:** Promo thumbnail and text were too close.
- **Fix:** Added `mr-4` to the promo image in `AdminDashboardPromosView.vue`.

---

## Pages checked – no change needed

| Page / area | Data source | Notes |
|-------------|-------------|--------|
| **DashboardView** | `useVehicles()`, `useRentalBookings()`, stores | Client/car owner/admin dashboard vehicles and recent bookings use live data. |
| **AdminListingsView** | `useVehicles()` | Listings and owner names are live; full name + tooltip already added. |
| **AdminVehiclesView** | `useVehicles()` | Shows full `businessName ?? hostName` on cards; no initials-only issue. |
| **ClientBrowseView** | `useVehicles()` / car rental profiles | Rental name in watermark + badge; badge links to rental detail. |
| **ClientVehicleDetailView** | `useVehicles()`, `approvedVehicles` | Similar vehicles and main vehicle data are live. |
| **ClientCheckoutView** | `useVehicles()` | Vehicle for checkout comes from `vehicles` computed (live). Only dead import removed. |
| **CarOwnerVehiclesView** | `useVehicles()` | Single-owner context; watermark shows rental name. |
| **CarOwnerCalendarView** | Bookings + vehicles | Uses live data; `.slice(0, 3)` is for display limit per day, not static list. |

---

## Seed / static data – intentional or fallback

These use seed or static data as **fallback when API returns nothing** or as **placeholder until APIs exist**. Left as-is unless product wants full API wiring.

| Location | What | Reason |
|----------|------|--------|
| **CarOwnersView** | `CAR_OWNERS_SEED` | Fallback when `getCarOwners()` returns empty; merged with car rental profiles. |
| **ClientsView** | `CLIENTS_SEED` | Fallback when `getClients()` returns empty. |
| **MarketingStaffView** | `TOP_REFERRERS_SEED`, `MARKETING_PARTNERS_SEED` | Placeholder/fallback; can be wired when referral/partner API exists. |
| **DashboardView** | `CAR_OWNER_EARNINGS_SEED`, `REFERRAL_STATS_SEED`, `MARKETING_EARNINGS_SEED` | KPI placeholders for car owner / marketing roles. |
| **ReportsView** | `FINANCIAL_SUMMARY_SEED`, `BOOKING_CHART_SEED`, etc. | Report placeholders. |
| **CarOwnerEarningsView** / **MarketingEarningsView** | Earnings seeds | Placeholder until earnings API is used. |
| **AdminPayoutsView** / **MarketingPayoutHistoryView** | Payout seeds | Placeholder until payout API is used. |
| **Client/Marketing/Car owner FAQ / Help** | FAQ seeds | Static content; no live source. |

---

## Recommendations

1. **Referral / marketing:** When referral and partner APIs exist, wire **MarketingStaffView** “Top referrers” (and partners if needed) to live data, similar to ClientsView recent activity.
2. **Earnings / payouts:** When backend endpoints are ready, replace earnings and payout seeds in Dashboard, CarOwnerEarningsView, MarketingEarningsView, and payout views with API data.
3. **Reports:** Replace report seeds in ReportsView with real reporting APIs when available.

---

## Summary

- **Fixed in this audit:** Dead import in ClientCheckoutView; ClientsView “Recent activity” now driven by rental bookings; CarOwnersView “Recent listings” and Admin Listings owner name + promo spacing were fixed earlier.
- **Verified:** Dashboard, Admin Listings/Vehicles, Client browse/detail/checkout, and Car owner views use live vehicle/booking data where intended; no further changes needed for the issues audited.
- **Left as-is:** Seed/fallback usage for clients, car owners, marketing, earnings, payouts, and reports, with recommendations to replace with APIs when available.
