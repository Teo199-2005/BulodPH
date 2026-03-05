# HPA Plus Frontend – Dashboard & Pages Audit

**Date:** February 5, 2026  
**Scope:** All dashboards and pages across Client, Car Owner, Marketing, and Admin roles.

This document lists **suggestions**, **missing or incomplete features**, **non-working or placeholder buttons**, and **recommended improvements** so you can prioritize fixes and enhancements.

---

## 1. Dashboard (All Roles) – `DashboardView.vue`

### Issues / Non-working or Incomplete
- **Admin – Weekly Bookings chart:** Data is **hardcoded** (`[2, 1, 0, 1, 0, 0, 0]` etc.). It does **not** change when the user toggles **Week / Month / Year** (`dashboardTimeRange`). Wire the chart to `dashboardTimeRange` and to real booking data (e.g. from `useRentalBookings()` aggregated by week/month/year).
- **Admin – Total Users:** Value is **hardcoded** to `11`. Replace with a real count (e.g. from API or from clients + car owners + marketing staff lists).
- **Client / Car owner / Marketing KPIs:** Most stats show `0` or placeholder values (e.g. “Total trips”, “Upcoming bookings”, “Earnings (month)”, “Link clicks”, “Referral earnings”). Connect these to real data (bookings, earnings, referral stats) when backend is available.

### Suggestions
- Add a **“Recent activity”** or **“Recent bookings”** section for Admin (e.g. last 5 bookings with link to detail).
- Make **Quick links** (non-admin) open in same tab; ensure all links match current routes.
- For Admin, consider **date range picker** for charts instead of or in addition to Week/Month/Year.
- Add **loading states** for stats when data is fetched from API.

---

## 2. Client – Browse Rides – `ClientBrowseView.vue`

### Working
- Search, filters (location, type, car type, seats, transmission, price min/max), Reset.
- Vehicle cards link to vehicle detail; primary CTA goes to vehicle detail (then user can “Book now” or “Add to cart” there).

### Suggestions
- **Sort options:** e.g. “Price: low to high”, “Price: high to low”, “Newest”, “Distance” (if location/distance is supported).
- **Map view:** Optional map of listings for the region.
- **Wishlist / Save:** “Saved vehicles” KPI on dashboard is 0; add ability to save/favorite vehicles and persist (e.g. localStorage or API).
- **Results count:** Show “X vehicles found” near filters.
- Ensure **locations** and **carTypeOptions** stay in sync with vehicle seed/API (already derived from data; verify when backend is connected).

---

## 3. Client – Vehicle Detail – `ClientVehicleDetailView.vue`

### Issues / Non-working
- **“Add to cart”** button: Calls `addToCart()` which shows a toast and navigates to Cart, but **does not write to any shared cart store**. The Cart page (`ClientCartView.vue`) uses **local `ref` state** only. So items “added to cart” from this page **do not appear** in the Cart. **Fix:** Introduce a global cart store (e.g. Pinia) and add the current vehicle (with optional dates) to that store in `addToCart()`. Cart page should read from the same store.

### Suggestions
- **Book now:** Pre-fill “Schedule booking” with current vehicle; consider optional quick date picker on this page.
- **Share vehicle:** Share link (copy URL or share to social).
- **Similar vehicles:** “More like this” (same type or location) at bottom.

---

## 4. Client – Schedule Booking – `ClientScheduleBookingView.vue`

### Working
- Vehicle from query; start/end date; meet-up; days and total; “Continue to checkout” with query params.

### Issues / Incomplete
- **Promo code** field is present in template (`promoCode` ref) but **not applied** to `total`. Total is always `pricePerDay * days`. Either apply promo here (e.g. BULOD30 → 30% off) or remove the promo UI and keep it only on Checkout.

### Suggestions
- **Calendar availability:** If API supports it, show which dates are already booked for this vehicle.
- **Min rental period:** Respect vehicle’s `minRentalPeriodHours` and show warning if selected period is shorter.
- **Promo code:** If kept on this page, apply discount to `total` and pass discount to checkout (e.g. via query or store).

---

## 5. Client – Cart – `ClientCartView.vue`

### Issues / Non-working
- Cart is **local state** only (`ref` in component). It is **not** shared with Vehicle Detail’s “Add to cart”. So the only way to see items is the initial seed (e.g. one Toyota Innova). **Fix:** Use a global cart store; “Add to cart” on Vehicle Detail and “Remove” here should update the same store.
- **“Pick dates in Schedule booking”:** No link or flow to set dates per cart item. Consider linking each item to “Schedule booking” for that vehicle, or a small date picker on the card, and syncing dates to cart store so Checkout can use them.

### Suggestions
- **Edit dates:** From Cart, allow “Change dates” per item → navigate to Schedule booking with `vehicleId` (and optionally pre-filled start/end).
- **Persist cart:** Persist cart in localStorage or API so it survives refresh and is consistent across “Add to cart” and Cart page.

---

## 6. Client – Checkout – `ClientCheckoutView.vue`

### Working
- Summary from route query (vehicleId, start, end, meetUp); payment method selection; promo BULOD30 applies 30%; “Confirm and pay” shows loading then redirects to My bookings with success toast.

### Issues / Incomplete
- **Payment:** “Confirm and pay” does not call any payment gateway (GCash/Maya). It only simulates success. Payment gateway integration is out of scope for this release (manual flow only).
- **Payment methods:** List is local `ref`; “Manage payment methods” links to Client Payments (which also uses local state). For consistency, use a single source (e.g. store or API) for payment methods across Checkout and Payments page.
- **Multi-item checkout:** Checkout is built for a single vehicle (from query). If you support multiple cart items, extend summary and total to support multiple lines and optional split payment.

### Suggestions
- **Validation:** Ensure `start`/`end` are valid dates and vehicle is still available before confirming.
- **Receipt:** After success, redirect to booking detail or a “Receipt” page with booking ID and amount paid.
- **Back to cart:** If user came from Cart with multiple items, “Back” could go to Cart instead of Schedule booking.

---

## 7. Client – My Bookings – `ClientBookingsView.vue`

### Working
- Tabs (Upcoming / Past); list from local data; “Pay” / “View” link to booking detail.

### Issues / Incomplete
- **Data source:** Bookings are hardcoded `ref`. Replace with API or shared store (e.g. from `useRentalBookings()` or a client-specific bookings API) so that new bookings from Checkout appear here.
- **Filters:** No filter by status or date range; consider adding for power users.

### Suggestions
- **Cancel:** From list, allow “Cancel” for confirmed upcoming bookings (with confirmation dialog); wire to API.
- **Repeat booking:** “Book again” for a past booking (pre-fill vehicle and dates).

---

## 8. Client – Booking Detail – `ClientBookingDetailView.vue`

### Issues / Non-working
- **“Pay now”:** Informational only; payment gateway integration is out of scope for this release (manual flow only).
- **“Cancel booking”:** Only shows `toast.warning('Cancel booking – confirm in dialog. Connect API.')`. No confirmation dialog and no API call. **Fix:** Add confirmation modal; on confirm, call cancel API and update booking status; redirect or refresh list.

### Suggestions
- **Contact host:** Show “Message host” or “Call host” (e.g. tel: link) using `hostPhone`.
- **Directions:** Link to map (e.g. Google Maps) for meet-up/location.
- **Receipt / Invoice:** Link to download or view receipt for completed/paid bookings.

---

## 9. Client – Payments – `ClientPaymentsView.vue`

### Working
- List of payment methods; Set default; Remove; Add (GCash, Maya, Visa, Mastercard, BPI) with validation and local state update. All **in-memory** only.

### Issues / Incomplete
- **Persistence:** Add/remove/set default only update local `ref`. They are **not** persisted to backend or localStorage. After refresh, changes are lost. **Fix:** Persist to localStorage (or API when available), and load on mount. Checkout should use the same source. Payment gateway integration is out of scope for this release.
- **Security:** Card/bank details are not actually sent anywhere; when you add API later, never send full card numbers; use tokenization or backend payment method APIs.

### Suggestions
- **Default badge:** Ensure “Default” is clearly shown and only one method is default.
- **Validation:** For GCash/Maya, validate Philippine mobile format (e.g. 09XXXXXXXX).

---

## 10. Client – Promos – `ClientPromoView.vue`

### Working
- Static promo card (BULOD30, 30% off); “How to use” steps; active promos list. Purely informational.

### Suggestions
- **Dynamic promos:** Load active promos from API (code, discount, validity, description).
- **Apply from here:** Optional “Copy code” for BULOD30 so user can paste at checkout.
- **Expiry:** Show “Valid until …” from API; hide expired promos.

---

## 11. Car Owner – Bookings – `CarOwnerBookingsView.vue`

### Issues / Non-working
- **“Decline” button** (Requested tab): No `@click` handler. Button does nothing. **Fix:** Add `@click="decline(b)"` (or similar) and implement `decline(id)` to update booking status (e.g. set to Declined/Cancelled) and optionally notify client; sync with CarOwnerBookingDetailView if both use same data source.
- **Data:** All bookings are local `ref`; not synced with backend or with client-side bookings. When client confirms a booking, car owner should see it here. Connect to API or shared store.

### Suggestions
- **Accept:** “Accept” links to detail page where Accept is implemented; consider also “Accept” inline from list with confirmation.
- **Filters:** Filter by vehicle or date range.
- **Earnings column:** Show earnings in Requested/Upcoming where applicable (e.g. after acceptance).

---

## 12. Car Owner – Booking Detail – `CarOwnerBookingDetailView.vue`

### Working
- Accept, Decline, “Mark handed over”, “Mark returned” all show toasts. Status and list are local only.

### Issues / Incomplete
- **State updates:** Accept/Decline/Mark handed over/Mark returned only toast; they do **not** update the booking status in the list or in a store, so the UI does not reflect the new state. **Fix:** Update a shared bookings store or call API, then update local state so that “Requested” becomes “Confirmed” after Accept, etc.
- **Data source:** Same as Car Owner Bookings – move to API or shared store so client and car owner see consistent state.

### Suggestions
- **Contact renter:** Show renter phone as clickable `tel:` link.
- **Directions:** Link to meet-up location on map.
- **Checklist:** Optional digital hand-off checklist (keys, condition, fuel) for “Mark handed over” / “Mark returned”.

---

## 13. Car Owner – My Vehicles – `CarOwnerVehiclesView.vue`

### Working
- List from `VEHICLE_SEED.slice(0, 5)`; Add vehicle → form; Edit → edit form; Bookings → bookings list.

### Issues / Incomplete
- **Data source:** Uses **VEHICLE_SEED** (constant), not the same as Admin’s `useVehicles()`. So admin and car owner see **different** vehicle lists. **Fix:** Car owner should use `useVehicles()` filtered by current user (or a dedicated “my vehicles” API). Add/edit/delete should update the same source so admin Vehicle Listings and car owner My Vehicles stay in sync for that owner’s vehicles.
- **Delete:** No delete vehicle action on this page; admin has Delete. If car owners can delete their own listing, add Delete with confirmation and wire to same vehicle store/API.

### Suggestions
- **Availability toggle:** Quick “Available” / “Unavailable” toggle per card to pause listings without deleting.
- **Stats per vehicle:** Show number of upcoming bookings or earnings per vehicle on the card.

---

## 14. Car Owner – Earnings – `CarOwnerEarningsView.vue`

### Working
- “Request payout” shows success toast; balance and history are local refs.

### Issues / Incomplete
- **Request payout:** No API call; no minimum or validation beyond disabled when balance &lt; 100. **Fix:** Call payout API; show pending payout status; on success, move amount to “pending” and update balance.
- **Balance / history:** Values are hardcoded. Replace with API or store so that completed trips and payouts update balance and history.

### Suggestions
- **Payout schedule:** Show “Next payout date” or “Payouts processed weekly on …”.
- **Export:** Export earnings history as CSV.

---

## 15. Car Owner – Payout Method – `CarOwnerPayoutMethodView.vue`

### Working
- Display saved methods; form to choose GCash/Maya/Bank and enter details; “Save” updates local state.

### Issues / Incomplete
- **Persistence:** Same as Client Payments – saved methods are in-memory only. **Fix:** Persist to API (or localStorage) and load on mount; use same source for Admin Payouts and car owner payout requests.
- **Validation:** Validate mobile number format and bank account format before save.

### Suggestions
- **Set default:** Allow marking one method as default for payouts.
- **Remove method:** Option to remove a saved payout method.

---

## 16. Marketing – Referral Link – `MarketingReferralView.vue`

### Working
- Copy link button works (clipboard + toast). Stats (clicks, sign-ups) are local refs.

### Issues / Non-working
- **Facebook / WhatsApp / Twitter buttons:** No `@click` handlers. They do not open share dialogs or share the referral link. **Fix:** Add handlers to open share URLs (e.g. `https://www.facebook.com/sharer/sharer.php?u=...`, WhatsApp `https://wa.me/?text=...`, Twitter intent URL) with `referralLink` as the URL.
- **Stats:** Clicks and sign-ups are hardcoded. Replace with API when referral tracking is available.

### Suggestions
- **QR code:** Generate and display QR code for referral link (e.g. for offline sharing).
- **Short link:** Optional short link (e.g. bulodph.com/ref/ABC123) and vanity codes.

---

## 17. Marketing – Campaigns, Earnings, Resources, Payout Method

- **Campaigns / Earnings / Resources / Payout method:** Use local or static data. When backend is ready, connect to campaigns API, referral earnings API, and payout method API. Same persistence and “Set default” suggestions as for Client Payments and Car Owner Payout Method where applicable.

---

## 18. Admin – Dashboard – (see Section 1)

Already covered in **DashboardView** (charts, KPIs, time range).

---

## 19. Admin – Total Bookings – `AdminBookingsView.vue`

### Working
- Rental analytics; filters; table from `useRentalBookings()`; Archive; Export Excel (CSV download); Export PDF (window.print); View → booking detail.

### Issues / Non-working
- **Header “account” icon:** The button with `mdi-account-circle` in the header has **no `@click`** or `:to`. It does nothing. **Fix:** Remove it or wire to Profile/Settings (e.g. `:to="{ name: 'profile' }"` or open user menu).
- **Export PDF:** Uses `window.print()`; user has to “Save as PDF” in print dialog. Acceptable for now; document in UI that it’s “Print / Save as PDF”.

### Suggestions
- **Date range filter:** Apply date range to the table and to Excel export so export matches visible data.
- **Booking status change:** From table or detail, allow changing status (e.g. Pending → Confirmed, Cancel) and sync with rental store/API.

---

## 20. Admin – Booking Detail – `AdminBookingDetailView.vue`

### Working
- Archive button updates `useRentalBookings()` and shows toast.

### Issues / Non-working
- **“Cancel booking”:** Only `toast.warning('Booking cancelled.')`; does **not** update the booking status in `useRentalBookings()` or call API. **Fix:** Update status to Cancelled in store/API and show success; optionally notify client/car owner.
- **Reopen / Unarchive:** No way to unarchive. If needed, add “Restore” for archived records.

### Suggestions
- **Edit dates/amount:** Allow admin to edit rental period or amount and save.
- **Refund:** If booking is cancelled after payment, link to or trigger refund flow.

---

## 21. Admin – Vehicle Listings – `AdminVehiclesView.vue`

### Working
- Search and filters; Add / Edit / Delete vehicle via `useVehicles()`; View goes to vehicle detail. Modal form and delete confirmation are wired.

### Issues / Non-working
- **Header account icon:** Same as Admin Bookings – icon button in header has no action. **Fix:** Same as Section 19 (link to profile or user menu).

### Suggestions
- **Bulk actions:** Bulk approve, bulk feature, or bulk delete (with confirmation).
- **Import:** Bulk import vehicles from CSV.
- **Permit expiry:** If permits have expiry dates, show warning or column for “Permit expiring soon”.

---

## 22. Admin – Listings – `AdminListingsView.vue`

### Working
- Approve and Feature/Unfeature call `useVehicles()` `update()` and toast. View links to vehicle detail. Search filters the list.

### Suggestions
- **Reject listing:** If you support “Rejected”, add Reject button and set `approved: false` (or status Rejected) with optional reason.
- **Bulk approve:** Select multiple pending listings and Approve all.

---

## 23. Admin – Payouts – `AdminPayoutsView.vue`

### Working
- Approve & pay / Reject remove the item from local list and show toast. Pending and history are local refs.

### Issues / Incomplete
- **Persistence:** Pending and history are not from API. **Fix:** Load pending payouts and history from API; on Approve, call payout API and move to history; on Reject, call API and remove from pending.
- **Actual payout:** “Approve & pay” does not trigger real payout to GCash/Maya/bank. Integrate with payout provider when ready.

### Suggestions
- **Filters:** Filter by type (Car owner vs Marketing), date range, status.
- **Export:** Export payout history as CSV.
- **Minimum payout:** Show platform minimum (e.g. ₱100) and warn if below.

---

## 24. Admin – Car Owners – `CarOwnersView.vue`

### Working
- Add / Edit / Delete car owner (local refs); table with search; bulk “Send email” and “Export” show toast/info (placeholder). Data is local `owners` ref.

### Issues / Incomplete
- **Send email (bulk):** Only `toast.info('Send email – connect to API')`. **Fix:** Open mailto or integrate with email API for selected owners.
- **Export (bulk):** Only `toast.info('Export – connect to API')`. **Fix:** Export selected rows to CSV (reuse pattern from HpaDataTable or Admin Bookings export).
- **Persistence:** Car owners list is in-memory. **Fix:** Load/save from API so new car owners appear and edits/deletes persist.
- **Listings count:** Should come from actual vehicle count per owner (e.g. from `useVehicles()`) when data is shared.

### Suggestions
- **View listings:** Link from owner row to Admin Vehicles filtered by that owner (e.g. query param `?owner=...`).
- **Suspend / Activate:** If status includes Suspended, wire actions to update status and optionally hide their listings.

---

## 25. Admin – Clients – `ClientsView.vue`

### Working
- Add / Edit / Delete client; View → Client details; New booking → admin bookings with `clientId` query. Form and delete confirmation are wired.

### Issues / Non-working
- **Send Email (bulk):** Only `console.log('Send email to:', selected)`. No toast or user feedback; no mailto or API. **Fix:** Same as Car Owners – mailto or email API and user feedback.
- **Export (bulk):** Only `console.log('Export:', selected)`. **Fix:** Export selected clients to CSV and download.
- **Data:** Clients are local ref; load from API and persist add/edit/delete when backend exists.

### Suggestions
- **New booking:** Currently goes to admin-bookings with clientId; ensure Admin Bookings page uses `clientId` to pre-filter or pre-fill client when creating a booking.
- **Client status:** If you have “Pending review”, wire status changes and document meaning.

---

## 26. Admin – Marketing Staff – `MarketingStaffView.vue`

### Working
- Add / Edit / Delete partner; table; bulk Send email / Export (likely same pattern as Car Owners – toast or placeholder). Data is local.

### Issues / Incomplete
- Same as Car Owners: **Send email** and **Export** should do real bulk email and CSV export. **Persistence** should be API when available.
- **Top referrers / Campaign snapshot:** Static or local data; connect to referral and campaign API when ready.

### Suggestions
- **View referral stats:** Link to a report or modal showing that partner’s referral clicks, sign-ups, earnings.
- **Deactivate:** Option to deactivate partner without deleting.

---

## 27. Admin – Reports – `ReportsView.vue`

### Issues / Non-working
- **Export All:** `exportAllReports()` only `console.log('Exporting all reports...')`. No file download. **Fix:** Implement export of all report sections (e.g. one CSV/Excel or multiple files) and trigger download.
- **Refresh:** `refreshReports()` sets loading and logs; data (e.g. Total Revenue ₱125,450) is **hardcoded**. **Fix:** Load report data from API based on `selectedPeriod` and date range; then Refresh fetches and updates.
- **Export (per card):** `exportReport(type)` only `console.log('Exporting report:', type)`. **Fix:** Generate CSV/PDF for that report type (financial, bookings, etc.) and download.

### Suggestions
- **Charts:** Replace or supplement static numbers with charts (e.g. revenue over time, bookings by status).
- **Schedule reports:** Optional “Email me this report weekly” (backend + cron).
- **Client reports:** If “Client Reports” section is used, ensure data comes from API and export includes it.

---

## 28. Admin – Announcements – `AnnouncementsView.vue`

### Working
- Compose form (subject, recipient type, message); Send uses validation and likely toast/API placeholder; Sent tab with list. Uses `useClients()` for client list and staff list for “specific_staff”.

### Issues / Incomplete
- **sendAnnouncement:** Implementation exists; confirm it actually sends email via API (or queued job). If it only shows success toast and does not call backend, **connect to announcements API** so emails are sent or queued.
- **Recipient lists:** “All clients” / “All car owners” etc. must be resolved server-side or from API; ensure recipient counts and delivery are correct.

### Suggestions
- **Templates:** Save draft or template for recurring announcements.
- **Preview:** “Preview” with sample recipient before sending.
- **Schedule:** Optional “Send at” date/time.

---

## 29. Client Details – `ClientDetailsView.vue`

### Context
- This view is under Admin (Clients → View). It shows a “Client Portal” with Overview, Client Reports, Medical Documentation, Service Agreements, Progress Notes, Incident Reports. Some labels (e.g. NDIS Number) suggest a healthcare/NDIS context; if this product is car rental only, consider simplifying tabs to “Overview”, “Bookings”, “Documents”, “Notes”.

### Issues / Non-working
- **“Edit” button** in header: No `@click` or `:to`. It does nothing. **Fix:** Open edit client modal (same as Clients list edit) or navigate to an edit page; load client by `$route.params.id` and persist changes.
- **Tabs content:** Reports, Medical, Agreements, Progress, Incidents are placeholder or static. **Fix:** Load per-client data from API and allow upload/view/download of documents where applicable.
- **Client data:** Name, email, phone, address, NDIS appear to be from local/computed; ensure they load from the same client API as Clients list (by id).

### Suggestions
- **Bookings for this client:** Add a tab or section listing bookings for this client with links to booking detail.
- **Notes:** Editable general notes saved to API.
- **Documents:** Upload ID, contracts, etc., with role-based access.

---

## 30. Profile – `ProfileView.vue`

### Working
- Personal info fields; profile image upload (preview via object URL); Save changes and Update password show toasts. Role-specific sections (Client, Car owner, Marketing, Admin) with documents and fields. Language and role label.

### Issues / Incomplete
- **saveProfile:** Only `toast.success('Profile updated.')`; does **not** persist to API or user store. **Fix:** Call profile API (or update `userSession` store and sync to API); reload session if needed.
- **changePassword:** Only clears form and toasts success; no API call. **Fix:** Call change-password API with current/new password; on success, clear form and optionally log out or require re-login.
- **Profile image:** `onProfileImageChange` sets local object URL only; not uploaded to server. **Fix:** Upload image to API and set profile image URL in user profile; use that URL in layout/header.
- **Role-specific documents:** Upload buttons and fields are likely not persisted. Wire to document API and show uploaded files.

### Suggestions
- **Validation:** Email format, phone format, required fields before save.
- **Verification badge:** If “Verified” is shown, tie it to backend verification status.
- **Delete account:** Optional “Delete my account” with confirmation and API call.

---

## 31. Settings – `SettingsView.vue`

### Issues / Non-working
- **Profile card – “Save changes”:** No `@click`. Display name and email fields have **no `v-model`** bound to a store or ref, so nothing is saved. **Fix:** Bind fields to user store or ref; on Save, call profile API and show toast.
- **Notification switches:** No `v-model`; toggles do not persist. **Fix:** Bind to a preferences store or API (e.g. `emailNotifications`, `pushNotifications`) and save on change or via Save.
- **“Change password” button:** No `@click` or navigation. **Fix:** Link to Profile (#change-password section) or open change-password modal/dialog.
- **“Two-factor authentication”:** No handler. **Fix:** Remove or implement 2FA flow (enable/disable) with backend.

### Working
- **Language:** Uses `useLocaleStore()` and persists locale; dropdown works.

### Suggestions
- **Theme:** If you add dark/light theme, add a toggle here and persist.
- **Timezone:** Optional timezone for dates and notifications.
- **Danger zone:** Log out, delete account, or export data in one place.

---

## 32. Notifications – `NotificationsView.vue`

### Working
- List of notifications; “Mark read” updates local `read` flag. Data is local ref.

### Issues / Incomplete
- **Persistence:** Notifications are hardcoded. **Fix:** Load from notifications API; “Mark read” should call API so state is synced across devices.
- **Links:** Notifications don’t link to booking/detail (e.g. “Booking accepted” could link to that booking). Add `to` or `actionUrl` per notification and use `router.push` or `<router-link>`.
- **Real-time:** Consider WebSocket or polling for new notifications and badge count in header.

### Suggestions
- **Mark all read:** Button to mark all as read.
- **Filter:** By type (booking, payment, payout, system) or unread only.
- **Delete:** Optional “Clear” or “Delete” for old notifications.

---

## 33. Shared / Layout

### Mobile layout
- **Bottom nav “More”:** Goes to Settings. Ensure Settings and Profile are both accessible from “More” or that Profile is linked from Settings/header so users can edit profile without confusion.
- **Page titles:** `currentPageTitle` and `pageSubtitleMap` are maintained; ensure any new routes get a title and optional subtitle for mobile.

### DashboardTemplate
- **Back button:** Used where `back-to` is set; works. Ensure all detail pages have a sensible `back-to` (e.g. booking detail → bookings list).
- **Role-based theming:** Already used; ensure new pages use the same template for consistency.

### HpaDataTable
- **Export:** `exportData()` builds CSV from `headers` and `items` and downloads. Works for simple columns. **Note:** Complex slots (e.g. `item.full_name` with avatar) export as raw value; if you need readable export, add a `formatter` or export-specific fields in the table.
- **Bulk actions:** “Send email” and “Export” are provided by parent (Car Owners, Clients, Marketing Staff). Those parents currently show toast or console.log; implement as in Sections 24–26.

---

## 34. Authentication & Landing

- **Login / Register:** Not audited in detail here. Ensure password reset flow exists if you have “Forgot password”; and that after login, redirect to correct dashboard by role (already in router guard).
- **Landing page:** Ensure CTA (e.g. “Get started”, “Browse”) leads to register or client browse as intended.

---

## Summary Table – Buttons / Actions to Fix

| Page / Component           | Element / Button           | Issue | Fix |
|----------------------------|----------------------------|--------|-----|
| ClientBookingDetailView    | Pay now                    | Toast only | Out of scope for this release (manual flow only) |
| ClientBookingDetailView    | Cancel booking             | Toast only | Add confirm dialog + API/store update |
| ClientVehicleDetailView   | Add to cart               | Not in cart store | Use global cart store |
| ClientCartView             | Cart contents              | Local state only | Same cart store; persist |
| ClientPaymentsView         | Add / Remove / Set default | In-memory only | Persist (API or localStorage) |
| CarOwnerBookingsView       | Decline (requested)        | No @click | Add handler + status update |
| CarOwnerBookingDetailView  | Accept/Decline/Hand over/Return | Only toast | Update store/API and UI state |
| CarOwnerEarningsView       | Request payout             | Toast only | Call payout API |
| CarOwnerPayoutMethodView   | Save                       | In-memory | Persist to API |
| CarOwnerVehiclesView       | Data source                | VEHICLE_SEED only | useVehicles() filtered by user |
| MarketingReferralView      | Facebook/WhatsApp/Twitter  | No @click | Open share URLs with referral link |
| AdminBookingsView          | Header account icon        | No action | Link to profile or user menu |
| AdminVehiclesView          | Header account icon        | No action | Same |
| AdminBookingDetailView     | Cancel booking             | Toast only | Update status in store/API |
| Admin Payouts              | Approve/Reject            | Local only | API + real payout for Approve |
| CarOwnersView              | Send email / Export (bulk) | Toast/log | Implement email + CSV export |
| ClientsView                | Send email / Export (bulk) | console.log | Same |
| MarketingStaffView         | Send email / Export (bulk) | Placeholder | Same |
| ReportsView                | Export All / Export (card) / Refresh | console.log / static data | Real export + API data |
| ClientDetailsView          | Edit button                | No handler | Open edit client + load by id |
| ProfileView                | Save / Update password / Photo | Toast only / local URL | Persist profile and password API; upload photo |
| SettingsView               | Save changes / Switches / Change password / 2FA | No bindings/handlers | Bind + persist; link or implement |

---

## Priority Recommendations

1. **High – Cart and checkout**
   - Global cart store so “Add to cart” and Cart page share state; persist cart (e.g. localStorage) so it survives refresh.
   - Checkout: ensure booking is created and client list stays in sync; payment gateway is out of scope for this release.

2. **High – Booking flows**
   - Client: “Pay now” and “Cancel booking” with confirmation and status update; "Pay now" is out of scope (manual flow only).
   - Car owner: “Decline” on list; Accept/Decline/Hand over/Return on detail should update shared booking state/API.
   - Admin: “Cancel booking” on detail should update status.

3. **High – Data consistency**
   - Car owner “My vehicles” should use same source as admin (e.g. `useVehicles()` filtered by owner).
   - Bookings: one source of truth (API or shared store) for client, car owner, and admin.

4. **Medium – Persistence**
   - Profile (name, email, photo, password) and Settings (profile fields, notification prefs) persist to API.
   - Payment methods persist to localStorage and are used in Checkout and Payments page; payout methods persist to API or localStorage. Payment gateway integration is out of scope.

5. **Medium – Admin actions**
   - Reports: Export All and per-card export actually generate and download files; Refresh loads from API.
   - Announcements: sendAnnouncement sends via API.
   - Client Details: Edit button opens edit and loads client by id.
   - Bulk “Send email” and “Export” on Car Owners, Clients, Marketing Staff: implement CSV export and email (or mailto).

6. **Lower – UX and polish**
   - Dashboard charts and KPIs from real data; time range affects charts.
   - Marketing share buttons (Facebook, WhatsApp, Twitter) open share URLs.
   - Notifications from API; mark read and link to relevant page.
   - Remove or implement header account icons and Settings “Change password” / “2FA”.

Use this document as a checklist to fix non-working buttons first, then add persistence and API integration, then enhance with the suggested features.
