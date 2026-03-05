# Car Rental Owners Migration Plan

## Context & Rationale

**Why the transition?** Private car owners as suppliers create legal liability (e.g., stolen vehicles, insurance gaps). Car rental companies have:
- Existing terms and conditions
- Proper permits and insurance
- Established business practices

**New positioning:** BulodPH is a marketplace that helps **car rental businesses** reach more customers. The platform makes their rentals more accessible, marketable, and popular.

---

## Phase 1: Terminology Transition

Change all user-facing text from "car owner" to "car rental owner" / "car rental company":

| Location | Before | After |
|----------|--------|-------|
| Admin nav | Car owners | Car rental owners |
| Dashboard KPI | Car Owners | Car rental companies |
| Dashboard promos text | Car owner | Car rental owner |
| Profile section | Car owner | Car rental owner |
| Listings subtitle | Car owner submissions | Car rental company submissions |
| Payouts empty state | car owners and marketing | car rental companies and marketing |
| Admin booking modal | car owner | car rental company |
| Add/Edit dialogs | Add car owner | Add car rental company |
| roleNav, MobileLayout | Car owners | Car rental owners |

**Technical note:** Keep `car_owner` in API routes, roles, and code identifiers for backward compatibility. Only change **display labels**.

---

## Phase 2: Admin Car Rental Owners Table – Logo & Profile

- Extend `CarOwnerSeedItem` with `logo_url`, `business_name` (rental company name)
- Admin table: show **company logo** instead of or alongside avatar in the name column
- Fallback: use business initial/avatar when no logo
- "By location" → "Rentals by location"

---

## Phase 3: Vehicle Branding – Logo Badge & Watermark

### 3a. Rental logo on vehicle cards
- **Position:** Top-right corner of vehicle image (overlay)
- **Size:** ~40×40px or 48×48px, rounded
- **Views:** Admin Vehicles, Client Browse, Client Rental Detail, Admin Listings
- **Data:** Get logo from rental profile (businessName → getRentalProfileSeed)

### 3b. Watermark on vehicle images
- **Style:** Subtle semi-transparent text or logo repeated (e.g., rental company name)
- **Placement:** Diagonal or centered, low opacity (10–15%)
- **Implementation:** CSS overlay or `background-image` with repeat

---

## Phase 4: Additional Features (Planned & Implemented)

### Implemented
- **Rental profile link** – Vehicle card badge links to rental profile (Browse view)
- **Fleet size** – Already on Browse car rentals cards
- **Verification** – "Verified" chip for permitted vehicles (existing hasPermit)
- **Terminology** – All user-facing "car owner" / "host" → "car rental owner" / "rental"

### To implement (recommended order)
1. **Rental company verification badge** – "Verified rental business" for permitted companies
2. **Rental company page link** – From vehicle card to rental profile (Browse car rentals)
3. **Terms & conditions per rental** – Link to each rental’s T&Cs
4. **Fleet size on cards** – Show "X vehicles" from this rental
5. **Rental ratings** – Aggregate reviews per rental company
6. **Business permit display** – Optional "Permit: BP-2024-001" on rental profile
7. **Admin: bulk actions** – Verify, feature, suspend rental companies
8. **Onboarding flow** – Rental-specific signup (business details, permit upload)
9. **Insurance display** – Optional field for rental insurance info
10. **Export/Reports** – Per-rental analytics for admin

---

## Implementation Order

1. ✅ Create plan (this document)
2. Phase 1: Terminology (user-facing text only)
3. Phase 2: Admin table logo
4. Phase 3: Vehicle logo badge + watermark
5. Phase 4: Rental link, fleet size, terminology cleanup, build fix

---

## Files to Modify

| File | Changes |
|------|---------|
| `constants/roleNav.ts` | Car owners → Car rental owners |
| `constants/carOwnersSeed.ts` | Add logo_url, business_name |
| `views/CarOwnersView.vue` | Terminology, logo in table |
| `views/DashboardView.vue` | KPI labels, promo text |
| `views/ProfileView.vue` | Car owner → Car rental owner |
| `views/admin/AdminListingsView.vue` | Subtitle |
| `views/admin/AdminPayoutsView.vue` | Empty state text |
| `views/admin/AdminBookingDetailView.vue` | Modal, toast text |
| `views/admin/AdminVehiclesView.vue` | Logo on cards, terminology |
| `layouts/MobileLayout.vue` | Page titles, subtitles |
| `views/client/ClientBrowseView.vue` | Logo on vehicle cards |
| `views/client/ClientVehicleDetailView.vue` | Logo + watermark |
| `views/client/ClientRentalDetailView.vue` | Vehicle cards with logo |
| `composables/useCarRentalProfiles.ts` | getRentalLogo(businessName) helper |
| New: `components/VehicleRentalBadge.vue` | Reusable logo overlay |
