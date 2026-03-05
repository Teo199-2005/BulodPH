# Pagination strategy – BulodPH frontend

## Goal
Identify all list-based pages and which need pagination (or already have it) so lists stay performant and usable as data grows.

---

## 1. Pages that already have pagination

| Page | Component | How |
|------|-----------|-----|
| **Car owner – My vehicles** | CarOwnerVehiclesView | Custom `v-pagination` + `paginatedVehicles` (12 per page) |
| **Admin – Affiliate applications** | AdminAffiliateApplicationsView | `v-data-table` with `items-per-page="10"` |
| **Admin – Review moderation** | AdminReviewModerationView | `v-data-table` with `items-per-page="10"` |
| **Admin – Fraud risk** | AdminFraudRiskView | `v-data-table` with `items-per-page="10"` |
| **Admin – Insurance plans** | AdminInsurancePlansView | `v-data-table` with `items-per-page="10"` |
| **Admin – System logs** | AdminSystemLogsView | `v-data-table` with `items-per-page="15"` |
| **Admin – Tax reports** | AdminTaxReportsView | `v-data-table` with `items-per-page="12"` |
| **Admin – Email templates** | AdminEmailTemplatesView | `v-data-table` with `items-per-page="10"` |
| **Admin – Disputes** | AdminDisputesView | `v-data-table` with `items-per-page="10"` |
| **Admin – Webhook logs** | AdminWebhookLogsView | `v-data-table` with `items-per-page="15"` |
| **Admin – Bookings** | AdminBookingsView | `v-data-table` with `items-per-page="10"` |
| **Tax & invoicing** | TaxInvoicingView | `v-data-table` with `items-per-page="10"` |
| **Activity logs** | ActivityLogsView | `v-data-table` with `items-per-page="10"` |
| **Admin – Clients** | ClientsView | `HpaDataTable` (uses `itemsPerPage`, default 10) |
| **Admin – Car owners** | CarOwnersView | `HpaDataTable` (uses `itemsPerPage`, default 10) |

---

## 2. Pages that need pagination (priority order)

### High priority (lists can grow quickly)

| Page | Component | Current behavior | Recommendation |
|------|-----------|------------------|----------------|
| **Client – Browse rides** | ClientBrowseView | Renders all `sortedVehicles` in a grid | Add pagination (e.g. 12 or 24 per page) + “Load more” or page numbers |
| **Client – Browse rentals** | ClientBrowseRentalsView | Renders all `filteredRentals` | Add pagination (e.g. 12 per page) |
| **Admin – Vehicle listings** | AdminVehiclesView | Renders all `filteredVehicles` in cards | Add pagination (e.g. 12 or 24 per page) |
| **Admin – Listings** | AdminListingsView | `paginatedListings` = `filteredListings` (no slice) | Add real pagination (slice + `v-pagination`) |

### Medium priority (lists grow over time)

| Page | Component | Current behavior | Recommendation |
|------|-----------|------------------|----------------|
| **Car owner – Bookings** | CarOwnerBookingsView | Three tabs: requested / upcoming / completed; each shows all cards | Add pagination per tab (e.g. 10 per page) when count > 10 |
| **Client – My bookings** | ClientBookingsView | Upcoming + past; all cards shown | Add pagination per section (e.g. 10 per page) |
| **Admin – Staff** | StaffView | All `staffMembers` in cards or list | Add pagination (e.g. 12 cards per page) |
| **Admin – Payouts** | AdminPayoutsView | Pending list + history list; all cards | Add pagination for “Payout history” (e.g. 10 per page) |
| **Public – Fleet** | PublicFleetView | All `filteredRides` in grid | Add pagination or “Load more” (e.g. 12 per page) |

### Lower priority (usually smaller lists)

| Page | Component | Current behavior | Recommendation |
|------|-----------|------------------|----------------|
| **Car owner – Payout history** | CarOwnerPayoutHistoryView | All `payouts` in a list | Add pagination if list can exceed ~20 (e.g. 10 per page) |
| **Car owner – Earnings history** | CarOwnerEarningsView | All `history` in list | Same: paginate if > 15–20 |
| **Marketing – Payout history** | MarketingPayoutHistoryView | All `payouts` | Same as car owner payout history |
| **Marketing – Earnings** | MarketingEarningsView | All `history` | Same as car owner earnings |
| **Marketing – Campaigns** | MarketingCampaignsView | All `campaigns` in cards | Paginate if campaigns can grow (e.g. 6–9 per page) |
| **Client – Favorites** | ClientFavoritesView | All `favoriteVehicles` | Paginate if many favorites (e.g. 12 per page) |
| **Client – Payments** | ClientPaymentsView | `unpaidBookings` + `billingHistory` | Paginate billing history if long (e.g. 10 per page) |
| **Blog index** | BlogIndexView | All `posts` in grid; has “Load More” but no real pagination | Either implement “Load more” (append next N) or page-based (e.g. 9 per page) |
| **Notifications** | NotificationsView | All `groupedNotifications` | Paginate per group or globally if many (e.g. 20 per page) |
| **Shifts** | ShiftsView | `filteredShifts` in list | Paginate if many shifts (e.g. 15 per page) |
| **Announcements** | AnnouncementsView | `sentList` | Paginate if list grows (e.g. 10 per page) |

---

## 3. Pages that don’t need pagination

- **Detail views** (booking, vehicle, client, staff, dispute, etc.): single record.
- **Forms / settings** (profile, payout method, rental profile, etc.): no list.
- **Dashboard** (DashboardView): widgets and small “recent” lists; keep as-is or cap at 5–10 items.
- **Calendar** (CarOwnerCalendarView): month grid; not a list.
- **Public static** (About, FAQ, Contact, Terms, Privacy): no dynamic lists.
- **Auth** (Login, Register, Forgot/Reset password): no lists.
- **Small fixed lists** (e.g. handoff checklist, return checklist, agreement paragraphs): static length.

---

## 4. Implementation approach

1. **Reuse patterns**
   - **Card grids** (vehicles, rentals, staff, listings): follow **CarOwnerVehiclesView** (computed `paginatedListings` = slice by `currentPage` and `ITEMS_PER_PAGE`, plus `v-pagination`).
   - **Tables**: Prefer `v-data-table` or `HpaDataTable` with `items-per-page` so pagination is built-in.
   - **Lists** (bookings, payouts, earnings history): add a `currentPage` ref and slice the array; add `v-pagination` below the list.

2. **Default page sizes**
   - Cards/grids: **12** per page (or 24 on wide screens if desired).
   - Tables: **10** (already standard in app).
   - Lists (bookings, payouts, history): **10** per page.

3. **Reset page on filter change**
   - When the user changes search, filters, or tab, set `currentPage = 1` (already done on CarOwnerVehiclesView for search/sort).

4. **Optional “Load more”**
   - For browse/fleet/blog, “Load more” (append next N) can be used instead of page numbers; document which pattern is chosen per page.

---

## 5. Summary table

| Area | Page | Has pagination? | Action |
|------|------|-----------------|--------|
| Car owner | My vehicles | Yes | — |
| Car owner | Bookings | No | Add (high/medium) |
| Car owner | Payout history | No | Add if list grows |
| Car owner | Earnings history | No | Add if list grows |
| Client | Browse rides | No | Add (high) |
| Client | Browse rentals | No | Add (high) |
| Client | My bookings | No | Add (medium) |
| Client | Favorites | No | Add (low) |
| Client | Payments (billing history) | No | Add (low) |
| Admin | Listings | No (fake) | Add real pagination (high) |
| Admin | Vehicle listings | No | Add (high) |
| Admin | Bookings | Yes (table) | — |
| Admin | Staff | No | Add (medium) |
| Admin | Payouts (history) | No | Add (medium) |
| Admin | Clients / Car owners | Yes (HpaDataTable) | — |
| Admin | Other tables | Yes (v-data-table) | — |
| Marketing | Payout / Earnings history | No | Add (low) |
| Marketing | Campaigns | No | Add (low) |
| Public | Fleet | No | Add (medium) |
| Public | Blog | Partial (“Load more”) | Clarify and implement |

---

## 6. Suggested implementation order

1. **Admin Listings** – Add slice + `v-pagination` to `paginatedListings`.
2. **Admin Vehicles** – Add `currentPage`, slice `filteredVehicles`, add `v-pagination`.
3. **Client Browse (rides)** – Add pagination to vehicle grid (e.g. 12 per page).
4. **Client Browse rentals** – Add pagination to rentals grid.
5. **Car owner Bookings** – Add pagination per tab (requested / upcoming / completed).
6. **Client Bookings** – Add pagination for upcoming and past.
7. **Admin Staff** – Add pagination to card/list view.
8. **Admin Payouts** – Add pagination to history section.
9. Remaining medium/low priority as needed.

This document can be updated as pagination is added to each page.
