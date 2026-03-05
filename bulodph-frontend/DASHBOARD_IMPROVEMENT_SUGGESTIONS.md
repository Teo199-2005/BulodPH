# Dashboard & Pages – Improvement Suggestions

Suggestions for **functions**, **modals**, **elements**, **stylings**, **widgets**, and **cards** across all dashboard pages. Use this as a prioritised backlog.

---

## Cross-cutting (all pages)

### Loading states
- **Skeleton loaders:** Use `HpaSkeletonLoader` (or a small card skeleton) on list/card views while data loads (e.g. Client Bookings, Car Owner Bookings, Admin Bookings, Clients, Car Owners, Marketing Staff, Reports).
- **Button loading:** Keep `:loading` on all submit/action buttons (Confirm, Pay, Save, Approve, etc.) and set to `true` during API calls.
- **Page-level overlay:** Optional full-page loading overlay for initial dashboard load or heavy fetches.

### Empty states
- **Standardise on HpaEmptyState:** Where you show “No items” (bookings, payouts, notifications, favorites, cart), use `<HpaEmptyState>` with `title`, `description`, optional `actionText` / `actionIcon` and `@action` to navigate or refresh.
- **Illustrations:** Add optional `imageUrl` for key empty states (empty cart, no bookings, no notifications) for a friendlier look.

### Modals & dialogs
- **Confirm before destructive actions:** Use `HpaConfirmModal` for: Remove from cart, Cancel booking, Delete vehicle, Delete client/car owner/partner, Reject payout, Archive booking, Log out. Already done in several places; apply everywhere similar.
- **Inline “quick view” drawers:** On list pages (Bookings, Vehicles, Clients), consider a side drawer or bottom sheet to preview one item without leaving the page, with “Open full detail” linking to the detail route.
- **Form modals:** Keep Add/Edit in modals (Clients, Car Owners, Marketing Staff, Vehicles) and ensure validation messages and “Cancel” are clear.

### Styling
- **Card consistency:** Use `elevation="0" rounded="lg" class="modern-card"` on all content cards; keep `mb-4` or `mb-3` between sections.
- **Section headers:** Use the same pattern everywhere: `section-card-header` + `section-card-icon` + `section-card-title` (and optional actions). See DashboardView and ReportsView.
- **Spacing:** Use a single spacing scale (e.g. `pa-4` for card body, `gap-2` / `gap-3` for flex/grid) so layouts feel consistent.
- **Mobile:** Ensure sticky headers or bottom CTAs don’t overlap content; test “More” bottom nav and floating bars (e.g. Vehicle Detail booking bar) on small viewports.
- **Focus & hover:** Keep visible focus rings and hover states on interactive cards and buttons for accessibility.

### Elements
- **Breadcrumbs:** On detail pages (Booking detail, Vehicle detail, Client details), add optional breadcrumbs (e.g. Bookings → Booking #123) for clarity.
- **Back button:** Ensure `DashboardTemplate` `back-to` is set on every detail view so “Back” goes to the correct list.
- **Page title & subtitle:** Set `meta.title` and `meta.subtitle` in the router for every route so the layout shows the right heading.

---

## Main dashboard (DashboardView.vue)

### Functions
- **Refresh KPIs:** Add a “Refresh” or last-updated time that refetches dashboard KPIs from API when clicked or on interval.
- **Time range for charts:** Keep Week/Month/Year for admin charts; optionally add a date range picker for “Custom” and pass to reports API.

### Widgets & cards
- **Recent activity (admin):** Add a “Recent bookings” or “Recent activity” card (e.g. last 5 bookings with link to detail).
- **Quick stats from API:** Replace hardcoded “Total users”, “Total trips”, “Earnings”, “Link clicks” with API-driven values and show skeleton while loading.
- **Client dashboard:** Optional “Recommended for you” or “Recently viewed” vehicles strip.

### Styling
- **Loading on KPIs:** Pass a `loading` prop to `HpaDashboardWidget` when stats are being fetched.
- **Responsive KPI grid:** Ensure 2x2 on mobile and 4 columns on desktop without overflow.

---

## Client

### Browse (ClientBrowseView.vue)
- **Elements:** Keep “X vehicles found” and sort (Newest, Price low–high, Price high–low). Optionally add “Distance” sort when location/distance is available.
- **Widgets:** Optional filter summary chips (e.g. “Cauayan · Car · ₱1k–₱3k”) with clear-all.
- **Styling:** Same card style as Favorites (vehicle card with image, type, location, price, View/Book).

### Vehicle detail (ClientVehicleDetailView.vue)
- **Functions:** “Share” button: copy URL or open native share; “Similar vehicles” section at bottom (same type or location).
- **Modals:** None required beyond existing flow.
- **Styling:** Keep floating booking bar; ensure 4-side thumbnails and reviews section don’t feel cramped on mobile.

### My bookings (ClientBookingsView.vue)
- **Functions:** Optional “Cancel” on upcoming items with confirm modal; “Book again” on past items (pre-fill vehicle + dates).
- **Elements:** Optional filter by status or date range; show booking ID on each card.
- **Empty state:** Use `HpaEmptyState` for “No upcoming bookings” / “No past bookings” with CTA to Browse.

### Schedule booking (ClientScheduleBookingView.vue)
- **Elements:** If API supports it, show a small “Available”/“Booked” indicator per date or a mini calendar.
- **Functions:** Validate `minRentalPeriodHours` and show warning if selection is shorter.
- **Styling:** Keep promo card and price summary visually distinct (e.g. voucher-style border/background).

### Checkout (ClientCheckoutView.vue)
- **Modals:** Optional “Order summary” expandable or modal before final submit.
- **Elements:** Show selected payment method icon/label clearly; optional “Back to cart” when coming from cart with multiple items.
- **Styling:** Keep agreement checkbox and CTA button prominent; consider sticky “Submit” on mobile.

### Cart (ClientCartView.vue)
- **Elements:** “Change dates” per item already links to Schedule booking; optional “Remove” confirm modal.
- **Empty state:** Use `HpaEmptyState` with illustration and “Find your ride” CTA.
- **Styling:** Match card style to other list pages (image, name, price, actions).

### Payments (ClientPaymentsView.vue)
- **Modals:** Confirm before “Remove” payment method; optional “Set as default” confirmation.
- **Elements:** Validate GCash/Maya phone format (e.g. 09XXXXXXXX); show “Default” badge on one method.
- **Styling:** List of payment methods as cards with icon, masked number, and actions.

### Promos (ClientPromoView.vue)
- **Elements:** “Copy code” per promo is done; optional “Valid until” countdown or expiry badge.
- **Styling:** Keep promo cards with icon, title, description, code chip, terms accordion.

### Favorites (ClientFavoritesView.vue)
- **Functions:** Optional “Remove all” with confirm modal; “Add all to cart” (add each to cart store).
- **Empty state:** Already good; ensure it uses same tone as Cart empty state.
- **Styling:** Reuse same vehicle card as Browse (image, type, location, price, View/Book, heart to remove).

### Help (ClientHelpView.vue)
- **Elements:** Optional search within FAQ; “Was this helpful?” on each FAQ with thumbs up/down (could send to API later).
- **Styling:** Keep expansion panels; ensure “Contact support” link is prominent.

### Support (ClientSupportView.vue)
- **Functions:** “Send message” could call a support API or open mailto with pre-filled subject/body; show success message or “We’ll reply within 24h”.
- **Elements:** Optional dropdown “Topic” (Booking, Payment, Other); optional file upload for screenshots.
- **Styling:** Contact list + form in two cards is clear; keep spacing and primary CTAs.

---

## Car owner

### Agreement (CarOwnerAgreementView.vue)
- **Modals:** Keep acceptance flow; optional “Download PDF” of terms.
- **Styling:** Long text in a scrollable card with sticky “I accept” button.

### My vehicles (CarOwnerVehiclesView.vue)
- **Functions:** Optional “Availability” toggle per vehicle (available/unavailable without deleting); optional “Duplicate” to clone a listing.
- **Widgets:** Optional “Upcoming bookings” or “Earnings this month” per vehicle on the card.
- **Modals:** Confirm before “Delete” vehicle if you add it.
- **Empty state:** Use `HpaEmptyState`: “No vehicles yet”, “Add your first vehicle”, CTA to Add vehicle.

### Vehicle form (CarOwnerVehicleFormView.vue)
- **Elements:** Validation messages under each field; optional “Preview” of how the listing will look.
- **Styling:** Group fields into sections (Basics, Pricing, Specs, Photos) with the same section header style.

### Bookings (CarOwnerBookingsView.vue)
- **Functions:** “Decline” with optional reason (modal with text field); optional “Accept” inline with confirm.
- **Elements:** Filter by vehicle already exists; optional date range filter.
- **Empty states:** Use `HpaEmptyState` per tab when Requested/Upcoming/Completed are empty.

### Booking detail (CarOwnerBookingDetailView.vue)
- **Elements:** Clickable `tel:` for renter; “Directions” link to meet-up; optional checklist progress (e.g. 2/4 items done).
- **Modals:** Confirm for “Decline”; optional “Upload photos” modal for hand-off/return.
- **Styling:** Keep status chip, list of details, and action buttons grouped.

### Earnings (CarOwnerEarningsView.vue)
- **Widgets:** Optional “Next payout date” or “Payouts processed weekly on …”; optional small chart (balance over time).
- **Functions:** “Request payout” already; add validation for minimum amount and show pending status after request.
- **Elements:** Optional “Export” for earnings history (CSV).
- **Empty state:** When balance is 0 and no history, use `HpaEmptyState` with short explanation.

### Payout method (CarOwnerPayoutMethodView.vue)
- **Modals:** Confirm before “Remove” method; optional “Set default” if multiple methods.
- **Elements:** Validate mobile (GCash/Maya) and bank account format.
- **Styling:** List methods as cards; form for add in same style as Client Payments.

### Calendar (CarOwnerCalendarView.vue)
- **Functions:** Optional “Add availability” or “Block dates” for selected vehicle; sync booked dates from API.
- **Elements:** Keep vehicle selector and legend; optional “List view” of bookings for the month.
- **Styling:** Keep calendar grid and selected-date details panel readable on mobile (horizontal scroll or smaller cells).

### Help (CarOwnerHelpView.vue)
- **Elements:** Same ideas as Client Help (search FAQ, “Was this helpful?”).
- **Styling:** Consistent with Client Help (expansion panels, link to support).

### Payout history (CarOwnerPayoutHistoryView.vue)
- **Elements:** Optional date filter or “Last 3 months” / “All”; optional “Download” CSV.
- **Empty state:** Use `HpaEmptyState` when no history.
- **Styling:** Table or cards with date, amount, status, method.

---

## Marketing

### Referral (MarketingReferralView.vue)
- **Elements:** Share buttons (Facebook, WhatsApp, Twitter) already use URLs; optional “Email” share. QR code is present; optional “Download QR” image.
- **Styling:** Keep QR + link + share buttons and stats card layout.

### Analytics (MarketingAnalyticsView.vue)
- **Widgets:** Replace static table with a line/bar chart for “Performance over time” (e.g. clicks, sign-ups, earnings by week/month) using the same chart library as Reports/Dashboard.
- **Elements:** Optional period selector (This month, Last 3 months, Custom).
- **Styling:** Keep KPI row and table/chart card; ensure chart is responsive.

### How you earn (MarketingHowYouEarnView.vue)
- **Elements:** Optional “Example calculator”: enter number of sign-ups and first bookings, show estimated earnings.
- **Styling:** Keep steps and commission rules in clear sections.

### Campaigns (MarketingCampaignsView.vue)
- **Elements:** Optional “Copy campaign link” or “Download assets” per campaign; optional status badge (Active, Ended).
- **Empty state:** Use `HpaEmptyState` when no campaigns.
- **Styling:** Campaign cards with image, title, dates, CTA.

### Earnings (MarketingEarningsView.vue)
- **Widgets:** Optional small chart (earnings over time); “Pending” vs “Paid” breakdown.
- **Elements:** Optional “Request payout” CTA when balance &gt; minimum; “Export” CSV.
- **Styling:** Align with Car Owner Earnings (balance, history, request payout).

### Payout history & Payout method (MarketingPayoutHistoryView, MarketingPayoutMethodView)
- **Apply same suggestions as Car owner:** filters, export, empty state, confirm modals, validation, card styling.

### Resources (MarketingResourcesView.vue)
- **Elements:** “Download” for each resource (logo, key messages); optional “Copy” for text snippets.
- **Styling:** Grid or list of resource cards with icon, name, description, download button.

---

## Admin

### Listings (AdminListingsView.vue)
- **Functions:** Optional “Reject” with reason modal; “Bulk approve” (select multiple, then Approve).
- **Elements:** Search and filters already; optional “Permit expiring soon” badge or column.
- **Styling:** Keep card/table and action buttons consistent with Admin Bookings.

### Bookings (AdminBookingsView.vue)
- **Widgets:** Keep rental analytics widgets; optional “Recent 5” list with link to detail.
- **Elements:** Date range filter that applies to table and export; optional status filter.
- **Styling:** Header with account icon, filters, and table; ensure Export Excel/PDF are clear.

### Booking detail (AdminBookingDetailView.vue)
- **Modals:** Confirm for “Cancel” and “Reject” (already); optional “Refund” or “Reschedule” modal when supported by backend.
- **Elements:** Optional “Edit dates/amount” inline or modal; “Notify client” / “Notify owner” actions.
- **Styling:** Same as other booking details (chip, list, actions).

### Payouts (AdminPayoutsView.vue)
- **Modals:** Confirm “Approve & pay” (e.g. “Send ₱X to …?”); “Reject” with optional reason modal.
- **Elements:** Filter by type (Car owner / Marketing), date range; “Export history” CSV.
- **Widgets:** Optional summary card (Total pending, Approved this week).
- **Empty states:** Use `HpaEmptyState` for Pending and History when empty.

### Dashboard promos (AdminDashboardPromosView.vue)
- **Functions:** Reorder promos (drag-and-drop or up/down); optional “Preview” as client/car owner/marketing.
- **Elements:** Optional “Active from / until” date per promo for scheduling.
- **Styling:** Grid of promo cards with image, title, target role, actions.

### Car owners (CarOwnersView.vue)
- **Elements:** “View listings” link from owner row to Admin Vehicles filtered by that owner; optional “Suspend” / “Activate” status.
- **Modals:** Confirm before Delete; optional “Send email” modal (template or custom).
- **Styling:** Keep stats row and table; bulk actions bar when selectable.

### Vehicles (AdminVehiclesView.vue)
- **Functions:** Optional “Bulk approve”, “Bulk feature”, “Bulk delete” with confirm; optional “Import” CSV.
- **Elements:** Permit expiry warning or column; optional “Owner” column with link to Car owners.
- **Styling:** Filters + table + add/edit modal; ensure form and delete confirm are consistent.

### Clients (ClientsView.vue)
- **Elements:** “New booking” already links to admin bookings with clientId; ensure Client details “Edit” opens same modal. Optional status filter (Active, Pending, Inactive).
- **Modals:** Confirm before Delete; optional “Send email” modal.
- **Styling:** Stats + recent activity + by location + table; keep bulk actions.

### Client details (ClientDetailsView.vue)
- **Functions:** “Edit” should open edit client modal (or navigate) and load by id; tabs (Reports, Medical, Agreements, Progress, Incidents) should load from API or show “No data” empty state.
- **Elements:** Optional “Bookings for this client” tab with list and link to booking detail; “Notes” editable and saved via API.
- **Styling:** Overview card + tabs + content; keep section headers consistent.

### Marketing staff (MarketingStaffView.vue)
- **Elements:** Optional “View referral stats” per partner; “Deactivate” without deleting.
- **Modals:** Same as Car owners (confirm delete, optional send email).
- **Styling:** Align with Car owners and Clients (stats, table, bulk actions).

### Reports (ReportsView.vue)
- **Elements:** “Refresh” and “Export” already improved; optional “Schedule report” (e.g. email weekly) when backend supports it.
- **Widgets:** Keep financial and booking stats cards; optional extra chart (e.g. revenue over time).
- **Styling:** Filters + cards + table; ensure chart heights and legend are consistent.

### Announcements (AnnouncementsView.vue)
- **Modals:** Optional “Preview” (sample recipient + subject + body); “Schedule send” (date/time) when backend supports it.
- **Elements:** Optional “Templates” (save draft or reuse); recipient count before send.
- **Styling:** Compose form + Sent list in clear sections.

---

## Shared

### Profile (ProfileView.vue)
- **Elements:** Validation (email format, phone format, required fields) before save; optional “Delete account” in a “Danger zone” section with confirm modal.
- **Styling:** Keep two-column grid on desktop (Personal info + Change password; role-specific + summary); ensure avatar upload area is clear.

### Notifications (NotificationsView.vue)
- **Functions:** “Mark all read” already; optional “Clear old” or “Delete” with confirm; filter by type (Bookings, Payments, Promos, Other) or “Unread only”.
- **Elements:** Each notification should link to the relevant page (booking detail, payments, etc.) via `actionTo`; optional “Snooze” or “Remind later” if you add it later.
- **Styling:** Grouped by type with clear “Mark read” and optional icons; empty state when no notifications.

### Settings (SettingsView.vue)
- **Elements:** “Change password” already links to Profile #change-password; optional “Theme” (light/dark) toggle and “Timezone” when you need it; “Danger zone” (Log out, Delete account, Export data) in one card.
- **Styling:** Keep sections (Profile, Notifications, Language, Security, About) in cards with dividers.

---

## Summary table (high impact)

| Area              | Suggestion type | Priority | Example |
|-------------------|-----------------|----------|---------|
| All list/detail   | Empty state     | High     | Use HpaEmptyState everywhere |
| All submit        | Loading         | High     | :loading on buttons during API calls |
| Destructive       | Modal           | High     | Confirm before Delete / Cancel / Reject |
| Admin Payouts     | Modal + filter  | Medium   | Confirm Approve/Reject; filter by type |
| Car owner Calendar| Function        | Medium   | Block dates, sync from API |
| Marketing Analytics| Widget          | Medium   | Chart for performance over time |
| Client Support    | Function        | Low      | Send message → API or mailto |
| Reports           | Element         | Low      | Schedule report email |
| Profile           | Element         | Medium   | Validation; Danger zone |
| Notifications     | Element         | Medium   | Filter by type; link to target page |

Use this doc as a checklist: tackle high-priority and cross-cutting items first, then role-specific improvements.
