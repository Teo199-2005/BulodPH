# BulodPH Pre-Release Full Audit Report

**Date:** February 2026  
**Last updated (v2):** February 2026 — post–release hardening  
**Scope:** Widgets, modals, tables, pages, and dashboards across frontend and backend touchpoints.  
**Rating:** Each area scored 1–100 using the rubric in the Appendix.

---

## 1. Summary

### Overall score: **76 / 100** (v2; was 68)

Weighted average of area scores, with higher weight for Landing, Client Browse/Checkout/Bookings, Car owner Vehicles, and Admin Vehicles/Listings.

### Release blockers — status after hardening

All previously listed blockers have been addressed:

1. ~~**Cart/Checkout → Bookings consistency**~~ **Done.** Backend `/client/bookings` returns rental bookings for the logged-in client; Checkout sets `client_user_id` and adds to store; ClientBookingsView fetches from API on mount.
2. ~~**Profile & Settings persistence**~~ **Done.** Profile and Settings persist via `/profile`, `/profile/avatar`, `/profile/change-password` (CarRentalStubController); notification prefs use userScopedStorage.
3. ~~**Car owner booking actions**~~ **Done.** Car owner bookings API returns vehicles owned by current user; Accept/Decline/Hand over/Return call PATCH `/car-owner/bookings/:id/status` and persist.
4. ~~**Admin/Car owner payouts**~~ **Done.** Payouts table, Payout model, PayoutController; GET `/payouts/pending` and `/payouts/history` (admin sees all, car_owner/marketing see own); POST approve/reject for admin. Car owner and Marketing payout history views load from API.
5. ~~**Client payment methods (UI consistency)**~~ **Done.** Payment methods in usePaymentMethodsStore with userScopedStorage; shared by Checkout and ClientPaymentsView (payment gateway out of scope).

### Remaining gaps (non-blocking for launch)

- **Dashboard KPIs:** Admin KPIs now from API (totalBookings, totalCars, carOwners, totalUsers, revenue, pendingPayouts); Client/Car owner/Marketing still use stores/seeds; chart data (weekly-bookings, car-types) still stub.
- **Admin lists:** Car owners list from API; POST/PUT/DELETE car-owners and some reports/exports still placeholder.
- **Optional polish:** Reports export (CSV/PDF), Announcements send.

### Top recommended fixes (high impact, non-blocker)

1. **Dashboard KPIs:** Replace hardcoded Admin "Total Users" (11) and Weekly Bookings chart data with API or aggregated data; connect Client/Car owner/Marketing KPIs to real bookings/earnings.
2. **Schedule booking promo:** Promo code field on Schedule Booking is not applied to total; apply BULOD30 (or API-driven promo) and pass discount to Checkout.
3. **Admin Car owners / Clients / Marketing Staff:** Load lists from API (currently many return `[]` or local seed); implement or wire GET/POST/PUT/DELETE so add/edit/delete persist.
4. **Reports View:** Export All and per-card Export currently log to console; implement CSV/PDF download. Refresh should load report data from API.
5. **Announcements:** Confirm sendAnnouncement calls backend and emails are sent or queued; if toast-only, wire to announcements API.
6. **Client Details (Admin):** Edit button has no handler; tabs (Reports, Medical, etc.) are placeholder. Simplify or wire to client API and bookings.
7. **Settings View:** Bind Save changes and notification toggles to store/API; wire Change password and 2FA or remove.
8. **Marketing Referral:** Facebook/WhatsApp/Twitter share buttons have no @click; add share URLs. Wire referral stats to API when available.
9. **Admin Bookings header:** Account icon in header has no :to or @click; link to profile or user menu.
10. **Car owner Bookings list:** "Decline" button (Requested tab) has no handler in CarOwnerBookingsView; add decline flow and sync with API.

---

## 2. Public & auth

### Landing (`LandingPage.vue`)

- **Working:** Hero, CTAs (Browse Cars → /login, Become a Partner → /register), contact links, sections, PublicLayout, skip-friendly structure.
- **Issues:** None critical.
- **Gaps:** Content is static; no dynamic promos or fleet count from API.
- **Suggestions:** Optional "How many vehicles" from API in hero or footer.
- **Score:** 88 (F:90, D:80, U:90, A:90, P:90)

### Login / Register / Forgot / Reset (`LoginView.vue`, `RegisterView.vue`, etc.)

- **Working:** Forms, validation, demo accounts (when enabled), auth API calls, redirect by role after login.
- **Issues:** None blocking.
- **Gaps:** Forgot/Reset may hit stubs; ensure backend sends or simulates email.
- **Suggestions:** Rate limiting feedback; clearer error messages for wrong password.
- **Score:** 82 (F:85, D:80, U:85, A:80, P:82)

### Privacy, Terms, Trust & Safety, Affiliate apply, Blog, City, FAQ, Contact

- **Working:** Routes and views exist; static or API-backed where implemented (e.g. trust-safety, blog-posts, city-pages).
- **Issues:** Minor copy/placeholder in some pages.
- **Gaps:** Some public endpoints return empty until content is added.
- **Score (combined):** 78 (F:80, D:75, U:80, A:78, P:78)

### Public & auth overall score: **82**

---

## 3. Client

### Dashboard (`DashboardView.vue`, role: client)

- **Working:** Role-based KPIs, Quick actions, Promos & offers (PromosOffersBox), layout.
- **Issues:** KPI values (Total trips, Upcoming bookings, Saved vehicles, etc.) are 0 or placeholder unless wired to stores/API.
- **Gaps:** Connect to clientBookings and favorites for real counts; optional earnings if applicable.
- **Score:** 72 (F:70, D:65, U:80, A:78, P:75)

### Browse rides (`ClientBrowseView.vue`)

- **Working:** Vehicle list from `approvedVehicles` (useVehicles + API merge), fetchFromApi on mount, search, filters (location, type, car type, seats, transmission, price), sort (Newest, price asc/desc), "X vehicles found", cards link to vehicle detail, rental name/logo from useCarRentalProfiles.
- **Issues:** None blocking.
- **Gaps:** Map view and distance sort not implemented.
- **Score:** 85 (F:88, D:85, U:85, A:82, P:85)

### Vehicle detail (`ClientVehicleDetailView.vue`)

- **Working:** Vehicle from useVehicles/getById, Book now → schedule booking, Add to cart → cartStore.addItem, Favorites toggle (favoritesStore), Share (copy URL), lightbox, rental badge, similar vehicles.
- **Issues:** None; cart and favorites are wired.
- **Score:** 88 (F:90, D:88, U:88, A:85, P:88)

### Schedule booking (`ClientScheduleBookingView.vue`)

- **Working:** Vehicle from query, start/end date, days and total; promo code (e.g. BULOD30) applied to total; Continue to checkout passes promo in query so Checkout shows same discount.
- **Issues:** None.
- **Gaps:** Calendar availability and min rental period warning not implemented.
- **Score:** 82 (F:84, D:80, U:84, A:80, P:82)

### Cart (`ClientCartView.vue`)

- **Working:** cartStore.cart, remove item, Change dates → schedule booking, Continue to book → checkout, empty state, totals.
- **Issues:** None; cart is shared with Vehicle detail and Schedule booking.
- **Score:** 86 (F:88, D:85, U:86, A:85, P:86)

### Checkout (`ClientCheckoutView.vue`)

- **Working:** Summary from query (vehicleId, start, end, meetUp), payment method list from usePaymentMethodsStore (shared with Payments page), BULOD30 30% off, Confirm and pay creates booking via API and adds to clientBookings then redirects with success toast.
- **Issues:** Payment gateway integration is out of scope for this release (manual/QR flow).
- **Gaps:** Multi-item checkout; receipt/booking detail redirect after confirm.
- **Score:** 78 (F:80, D:75, U:78, A:78, P:78)

### My bookings (`ClientBookingsView.vue`)

- **Working:** Tabs (Upcoming/Past), list from useClientBookingsStore, fetchFromApi on mount (backend returns client’s rental_bookings), Pay → payments with payBookingId, View details, Cancel with confirm, Book again.
- **Issues:** None blocking.
- **Gaps:** Filter by status/date.
- **Score:** 82 (F:85, D:80, U:82, A:82, P:82)

### Booking detail (`ClientBookingDetailView.vue`)

- **Working:** Booking from clientBookings.getById, vehicle and host info, Pay now / Cancel booking buttons.
- **Issues:** Pay now is informational only (payment gateway out of scope); Cancel only toast in some code paths—Confirm Cancel updates clientBookings.setStatus and persist.
- **Gaps:** Receipt/invoice link when available.
- **Score:** 68 (F:68, D:62, U:72, A:72, P:70)

### Payments (`ClientPaymentsView.vue`)

- **Working:** List of methods from usePaymentMethodsStore (userScopedStorage), Set default, Remove, Add (GCash, Maya, etc.) with validation; same source used in Checkout.
- **Issues:** None; payment gateway out of scope.
- **Score:** 78 (F:80, D:75, U:78, A:78, P:78)

### Favorites, Help, Promos, Browse rentals, Rental detail

- **Working:** Favorites store (persist), Help/FAQ content, Promos static (BULOD30), Browse rentals and Rental detail use useCarRentalProfiles and vehicles.
- **Score (combined):** 78 (F:80, D:72, U:80, A:78, P:80)

### Client overall score: **80** (v2; was 76)

---

## 4. Car owner

### Dashboard (`DashboardView.vue`, role: car_owner)

- **Working:** KPIs, Quick actions, Promos (PromosOffersBox), layout.
- **Issues:** Earnings and trip counts are placeholder unless wired.
- **Score:** 72 (F:72, D:65, U:80, A:78, P:75)

### My vehicles (`CarOwnerVehiclesView.vue`)

- **Working:** List from useVehicles merged with getStoredVehiclesForCurrentUser (owner filter + API), fetchFromApi on mount, Add vehicle → form, Edit, Bookings, Calendar, availability toggle (update + updateStoredVehicle), rental badge with logo from myRentalProfile.
- **Issues:** None blocking; vehicles created via form hit API and appear in Admin/Client after fetch.
- **Score:** 85 (F:88, D:85, U:85, A:82, P:85)

### Add/Edit vehicle (`CarOwnerVehicleFormView.vue`)

- **Working:** Form validation, useVehicles add/update (API), businessName/hostName from userSession, persistVehicle to localStorage after success, image uploads (data URLs).
- **Issues:** None; approved: true set in useVehicles.add.
- **Score:** 86 (F:88, D:88, U:84, A:82, P:86)

### Bookings (`CarOwnerBookingsView.vue`)

- **Working:** Tabs (Requested/Upcoming/Completed), list from carOwnerBookings store (getCarOwnerBookings API), Accept/Decline and detail actions wired to PATCH `/car-owner/bookings/:id/status`.
- **Issues:** None blocking.
- **Score:** 82 (F:85, D:80, U:82, A:82, P:82)

### Booking detail (`CarOwnerBookingDetailView.vue`)

- **Working:** Accept, Decline, Mark handed over, Mark returned; status updates persist via API.
- **Issues:** None.
- **Score:** 80 (F:82, D:78, U:82, A:80, P:80)

### Earnings / Payout method / Payout history (`CarOwnerEarningsView.vue`, etc.)

- **Working:** Request payout toast, balance and history UI; payout history loads from GET `/payouts/history` (car_owner scope).
- **Issues:** Balance/earnings aggregation still placeholder until tied to completed bookings.
- **Score:** 72 (F:74, D:68, U:75, A:72, P:72)

### Calendar, Help, Disputes, Reviews, Messages, Insurance, Tax, Activity, Rewards

- **Working:** Calendar uses vehicles and bookings; Help/FAQ static; shared Disputes/Reviews/Insurance etc. exist.
- **Score (combined):** 70 (F:72, D:62, U:75, A:72, P:72)

### Car owner overall score: **78** (v2; was 72)

---

## 5. Marketing

### Dashboard, Referral, Analytics, Campaigns, Earnings, Payout history, Resources, Payout method

- **Working:** Referral link copy, layout, tabs, local/stub data for stats and earnings.
- **Issues:** Facebook/WhatsApp/Twitter share buttons no handlers; stats and earnings not from API; payout stub.
- **Gaps:** Wire referral tracking and payout API when available.
- **Score (Marketing overall):** 66 (F:68, D:55, U:75, A:72, P:68)

---

## 6. Admin

### Dashboard (`DashboardView.vue`, role: admin)

- **Working:** KPIs (Total bookings, Total cars, Car rental companies, Total users) from GET /dashboard/kpis (real DB counts scoped by organization); Weekly Bookings chart, Most Rented Car Types, Status distribution.
- **Issues:** Chart data and time range toggle still stub; admin KPI cards use API when available.
- **Score:** 74 (F:76, D:70, U:76, A:76, P:74)

### Vehicles (`AdminVehiclesView.vue`)

- **Working:** useVehicles with fetchFromApi on mount, search, filters, Add/Edit/Delete (API), View → vehicle detail, HpaModal form, HpaConfirmModal delete, rental name and rentalLogoUrl from useCarRentalProfiles.
- **Issues:** Header account icon no :to (cosmetic).
- **Score:** 86 (F:88, D:88, U:84, A:82, P:86)

### Listings (`AdminListingsView.vue`)

- **Working:** List from vehiclesList, Approve/Feature/Unfeature via update(), View → client-vehicle-detail, search and filters, fetchFromApi on mount, rental name and listingLogoUrl for badge.
- **Score:** 85 (F:88, D:85, U:84, A:82, P:85)

### Total Bookings (`AdminBookingsView.vue`)

- **Working:** useRentalBookings, fetchFromApi, filters, archive, Export Excel/PDF, View → booking detail.
- **Issues:** Header account icon no action.
- **Score:** 82 (F:85, D:82, U:82, A:80, P:82)

### Booking detail (`AdminBookingDetailView.vue`)

- **Working:** Archive calls setArchived (API). Cancel booking toast only; does not update status via API/store.
- **Score:** 74 (F:75, D:70, U:78, A:75, P:75)

### Payouts (`AdminPayoutsView.vue`)

- **Working:** Pending and history from GET `/payouts/pending` and `/payouts/history`; Approve & pay / Reject call API and refresh list. Car owner and Marketing "Request payout" call POST `/payouts` (min ₱100); PayoutSeeder provides demo data.
- **Issues:** None.
- **Score:** 82 (F:84, D:80, U:84, A:82, P:82)

### Car owners (`CarOwnersView.vue`)

- **Working:** List from GET /admin/car-owners (AdminCarOwnerController; users with car_owner role, listings_count from vehicles); View → car-owner-details; Add/Edit/Delete still local/placeholder.
- **Issues:** Send email and Export bulk are placeholder; POST/PUT/DELETE car-owners not implemented.
- **Score:** 78 (F:80, D:75, U:80, A:78, P:78)

### Clients (`ClientsView.vue`)

- **Working:** Add/Edit/Delete, View → client-details, New booking with clientId, recent activity from useRentalBookings.
- **Issues:** Send Email/Export bulk console.log only; clients from seed/API (AdminClientController exists).
- **Score:** 74 (F:76, D:70, U:78, A:75, P:75)

### Marketing staff, Staff, Shifts, Reports, Disputes, Review moderation, Fraud & risk, System logs, Roles, Email templates, Dashboard promos, Insurance, Webhook logs, Tax, Affiliate applications

- **Working:** Views exist; many use HpaDataTable, HpaModal, HpaEmptyState. Approve/Reject/Resolve etc. update local state and show toasts; some endpoints are stubs.
- **Issues:** Reports Export All/per-card not downloading; Announcements send may be toast-only; Client Details Edit and tabs placeholder; Profile/Settings not persisting.
- **Score (combined Admin other):** 68 (F:70, D:62, U:72, A:72, P:70)

### Admin overall score: **76** (v2; was 74)

---

## 7. Shared

### Modals (`HpaModal.vue`, `HpaConfirmModal.vue`)

- **Working:** v-model, title, icon, slots, actions, persistent/scrollable, close button, loading state. Used consistently across Admin and Car owner forms.
- **Score:** 88 (F:90, D:88, U:88, A:85, P:88)

### Tables (`HpaDataTable.vue`)

- **Working:** Headers, rows, sort, select, pagination, loading, empty state. Used in Admin Bookings, Clients, Car owners, Marketing staff, etc.
- **Score:** 85 (F:88, D:85, U:85, A:82, P:85)

### Widgets & empty states (`HpaDashboardWidget.vue`, `HpaEmptyState.vue`)

- **Working:** Role-themed widgets (value, icon, trend), empty state with action. Used on dashboards and list pages.
- **Score:** 86 (F:88, D:85, U:86, A:82, P:86)

### Loaders, command palette, toasts, footer

- **Working:** HpaFullPageLoader, HpaLoadingOverlay, command palette (Ctrl+K), ToastContainer, AppFooter/PublicFooter.
- **Score:** 85 (F:88, D:85, U:85, A:82, P:85)

### Layout & nav (`MobileLayout.vue`)

- **Working:** Sidebar with role-based menu (mainMenuItems), skip link, top bar, breadcrumbs, drawer on mobile, role-based redirect after login.
- **Score:** 86 (F:88, D:85, U:86, A:85, P:86)

### Shared overall score: **86**

---

## 8. Backend touchpoints

| Flow | Frontend | Backend | Status |
|------|----------|---------|--------|
| Auth (login, register, me, logout) | AuthController, userSession | POST /login, /register, GET /me, POST /logout | Working |
| Vehicles (list, get, create, update, delete) | useVehicles, vehiclesApi | GET/POST /vehicles, GET/PUT/DELETE /vehicles/:id | Working |
| Rental bookings (admin) | useRentalBookings, bookingsApi | GET /bookings, PATCH status, PATCH archive | Working |
| Client bookings | useClientBookingsStore, getClientBookings | GET /client/bookings, POST /bookings (client_user_id) | Working; client list from API; Checkout creates and syncs |
| Car owner bookings | carOwnerBookings store | GET /car-owner/bookings, PATCH /car-owner/bookings/:id/status | Working; owner-scoped list and status updates |
| Car rental profiles | useCarRentalProfiles, carRentalProfile API | GET /car-rentals, GET/PUT /car-owner/rental-profile, logo upload | Partial; public index/show; profile CRUD for car owner |
| Payouts (car owner / admin / marketing) | AdminPayoutsView, CarOwnerEarningsView, MarketingEarningsView, payout history views | POST /payouts (request), GET pending/history, POST approve/reject | Working; PayoutSeeder for demo; Request payout wired |
| Profile | ProfileView, CarRentalStubController | GET/PUT /profile, change-password, avatar | Stub endpoints persist; settings use userScopedStorage |
| Dashboard KPIs | DashboardView | GET /dashboard/kpis?role=, weekly-bookings, car-types | Admin KPIs from DB (counts by org); charts stub |
| Disputes, Reviews, KYC, Cancellations | Controllers exist | Routes and controllers | Implemented; frontend may use local state in some admin actions |
| Admin clients | AdminClientController | GET/POST/PUT/DELETE /admin/clients | Implemented |
| Admin car-owners | CarOwnersView, getCarOwners | GET /admin/car-owners, GET /admin/car-owners/:id | Working; AdminCarOwnerController returns users with role car_owner + listings_count |
| Admin marketing staff | AdminMarketingStaffController | GET etc. /admin/marketing-staff | Implemented |
| Payments (create, status) | Checkout | POST /payments/create, GET /payments/status/:ref | Out of scope for this release (manual flow only) |

**Summary:** Vehicles and auth are production-ready. Client bookings (list + create) and car-owner bookings (list + status) use real APIs. Payouts (pending, history, approve, reject) are persistent and role-scoped. Profile/settings persist via stub endpoints and userScopedStorage. Dashboard KPIs and several admin list endpoints (car-owners, etc.) remain stubbed. Payment gateway integration is not in scope for this release.

---

## 9. Appendix

### Rating rubric (reminder)

- **Functionality (F) 30%:** All actions work; data from API or defined seed; no broken links.
- **Data & API (D) 25%:** Correct endpoints; list/detail/create/update/delete consistent; errors handled.
- **UX & clarity (U) 20%:** Clear CTAs, labels, feedback; filters/search; pagination/sort where needed.
- **Accessibility & responsiveness (A) 15%:** Keyboard/screen reader; works on small viewports.
- **Polish & consistency (P) 10%:** Design system; no stray TODO; loading/empty states.

**Formula:** `Score = round(0.30×F + 0.25×D + 0.20×U + 0.15×A + 0.10×P)` per area.

### Files and views audited (sample)

- **Views:** LandingPage, LoginView, RegisterView, DashboardView, ClientBrowseView, ClientVehicleDetailView, ClientScheduleBookingView, ClientCartView, ClientCheckoutView, ClientBookingsView, ClientBookingDetailView, ClientPaymentsView, CarOwnerVehiclesView, CarOwnerVehicleFormView, CarOwnerBookingsView, CarOwnerBookingDetailView, CarOwnerEarningsView, AdminVehiclesView, AdminListingsView, AdminBookingsView, AdminBookingDetailView, AdminPayoutsView, CarOwnersView, ClientsView, MarketingStaffView, ReportsView, ProfileView, SettingsView, MobileLayout, DashboardTemplate, HpaModal, HpaConfirmModal, HpaDataTable, HpaDashboardWidget, HpaEmptyState, and others under views/ and components/base/.
- **Composables:** useVehicles, useRentalBookings, useCarRentalProfiles, useClientBookingsStore, useCartStore.
- **Backend:** routes/api.php, VehicleController, AuthController, RentalBookingController, CarRentalProfileController, AdminClientController, AdminMarketingStaffController.

### References

- [DASHBOARD_AUDIT.md](bulodph-frontend/DASHBOARD_AUDIT.md) – Dashboard and per-page issues/suggestions.
- [PAGES_AUDIT_REPORT.md](bulodph-frontend/PAGES_AUDIT_REPORT.md) – Data source fixes and pages checked.
- [BUTTONS_AUDIT_REPORT.md](bulodph-frontend/BUTTONS_AUDIT_REPORT.md) – Buttons and actions audit; toasts and dialogs added where applicable.
