# Dashboard & App Audit – Suggestions & Plan

## Executive Summary

This document outlines findings from a full audit of all dashboards and pages, with suggested improvements for functionality, styling, UX, and consistency.

---

## 1. Missing KPI Widgets

**Current:** Several list/management pages have no summary stats.

| Page | Suggestion |
|------|------------|
| **Admin Listings** | Add KPI row: Total listings, Pending approval, Featured, Approved |
| **Admin Payouts** | Add KPI row: Pending amount, Pending count, Paid this month |
| **Client Browse** | Optional: "X vehicles in the region" summary above filters |
| **Client Browse Rentals** | Optional: "X rental companies" |

**Effort:** Low. Reuse `HpaDashboardWidget` and existing data.

---

## 2. Empty States

**Current:** Some views show plain text or nothing when lists are empty.

| Page | Current | Suggestion |
|------|---------|------------|
| Admin Listings | "No listings match" + icon | Use `HpaEmptyState` with CTA "Add listing" or "View vehicles" |
| Client Browse | Custom empty | Use `HpaEmptyState` with "Browse car rentals" or "Adjust filters" CTA |
| Client Browse Rentals | Custom empty | Use `HpaEmptyState` with "Browse vehicles" CTA |
| Admin Vehicles | Plain "No vehicles" | Use `HpaEmptyState` with "Add vehicle" CTA |
| Car Owner Bookings (tabs) | HpaEmptyState | Add contextual CTAs: "Add vehicle", "View calendar" |
| Car Owner Earnings history | None | Add empty state when no earnings yet |
| Marketing Earnings history | None | Add empty state |

**Effort:** Low–medium.

---

## 3. Form Validation & UX

**Current:** Several forms lack validation, loading states, or clear error feedback.

| Form | Gaps | Suggestion |
|------|------|------------|
| Car Owner Vehicle Form | No loading on save; minimal validation | Add `v-form` rules (required, min length, URLs), loading spinner on submit |
| Client Checkout | No loading on pay | Disable submit + show loading during payment |
| Car Owner Rental Profile | No cancel button | Add "Cancel" that navigates back |
| Client Schedule Booking | Partial validation | Add rule: end date ≥ start date; validate pickup location |

**Effort:** Medium.

---

## 4. Styling & Spacing Consistency

**Current:** Spacing and proportions vary across pages.

| Issue | Suggestion |
|-------|------------|
| Section padding | Standardize section headers to `pa-4` (16px) or `1.25rem 1.5rem` |
| Card body padding | Use `pa-4` consistently (some use `pa-3`) |
| KPI card height | Ensure `min-height` consistent (e.g. 140–148px) on all dashboards |
| Page bottom padding | Add `pb-6` or `pb-8` for scroll comfort on long pages |
| Mobile card spacing | Ensure `gap` between cards is at least 16px on small screens |
| Filter bar spacing | Use `gap-2` or `gap-3` consistently in filter rows |

**Effort:** Low.

---

## 5. Proportions & Layout

| Area | Suggestion |
|------|------------|
| Vehicle/listing cards | Ensure image aspect ratio consistent (e.g. 16:10 or 4:3) across Browse, Admin, Car Owner |
| KPI grid | Use `cols="6" sm="6" lg="3"` consistently for 4-column KPI rows |
| Sidebar width | Verify 260px works on small tablets; consider 240px below 1024px |
| Modal max-width | Standardize (e.g. 560px for forms, 720px for detail) |

**Effort:** Low.

---

## 6. Missing Actions & Logic

| Page | Missing | Suggestion |
|------|---------|------------|
| Admin Listings | Sort by status, date, price | Add sort dropdown |
| Admin Listings | Filters (status, type, location) | Add filter bar like Admin Bookings |
| Admin Bookings table | Export | Add `exportable` to HpaDataTable or export button |
| Admin Payouts | Bulk approve/reject | Add checkbox + bulk actions if applicable |
| Car Owner Vehicles | Pagination | Add pagination when > 12 vehicles |
| Client Browse | Results count | Show "X vehicles found" (already present in some views – verify consistency) |

**Effort:** Medium.

---

## 7. Navigation & Back Buttons

| Page | Status | Suggestion |
|------|--------|------------|
| Client Browse | No back (expected) | OK |
| Admin Listings | No back | OK (main nav) |
| Vehicle Detail (from admin) | Has back | OK |
| Car Owner Rental Profile | Back only via header | Ensure back goes to dashboard or vehicles |

**Recommendation:** Add a reusable breadcrumb for deep flows (e.g. Browse → Vehicle → Booking).

**Effort:** Low–medium.

---

## 8. Accessibility

| Gap | Suggestion |
|-----|------------|
| Form errors | Add `aria-describedby` linking fields to error messages |
| Skip link | Add "Skip to main content" for keyboard users |
| Bottom nav | Add `aria-current="page"` on active item |
| Focus styles | Ensure all buttons/links have visible focus ring |
| Contrast | Verify `text-secondary` (#64748B) passes WCAG AA on white |

**Effort:** Medium.

---

## 9. Data & API Consistency

| Issue | Suggestion |
|------|------------|
| Clients: `useClients` vs `ClientsView` logic | Unify: use one source (API or composable) for client list |
| Earnings: seed-only | Add API integration for car owner and marketing earnings when backend ready |
| `PlaceholderView` | Remove if unused, or wire to a route |
| `dashboard.ts` helpers | Remove or integrate if unused |

**Effort:** Medium–high (depends on backend).

---

## 10. Domain Mismatch (HPA vs Car Rental)

**Current:** Some views use NDIS/HPA/staffing terms (Shifts, Staff, ClientDetails with "NDIS", "support worker").

| View | Note |
|------|------|
| ClientDetailsView | Uses NDIS/support-worker terminology – consider rebranding to car-rental context |
| StaffView, ShiftsView | Appear HPA-specific – decide if they belong in this app |
| InvoicesView, DocumentsView | Same as above |

**Suggestion:** Either remove these routes or adapt copy to car-rental domain.

**Effort:** Depends on product decision.

---

## Prioritized Implementation Plan

### Phase 1 – Quick Wins (1–2 days)

1. Add KPI widgets to Admin Listings and Admin Payouts
2. Replace custom empty states with `HpaEmptyState` + CTAs (Admin Listings, Admin Vehicles, Browse views)
3. Standardize section padding (`pa-4`) and card spacing
4. Add loading state to Client Checkout submit
5. Add Export to Admin Bookings table

### Phase 2 – Forms & Validation (2–3 days)

1. Add `v-form` rules to Car Owner Vehicle Form (required, URL validation)
2. Add loading state to Car Owner Vehicle Form save
3. Add Cancel button to Car Owner Rental Profile
4. Improve Client Schedule Booking validation (date range, location)

### Phase 3 – Actions & Logic (2–3 days)

1. Add sort to Admin Listings
2. Add filters (status, type, location) to Admin Listings
3. Add pagination to Car Owner Vehicles when list is long
4. Add empty states to earnings history sections

### Phase 4 – UX & Accessibility (2–3 days)

1. Add skip link
2. Add `aria-current` and improve ARIA on forms
3. Review and fix focus styles
4. Add breadcrumbs for deep flows (optional)

### Phase 5 – Data & Cleanup (ongoing)

1. Unify client data source
2. Plan API integration for earnings
3. Resolve domain mismatch (HPA vs car rental)
4. Remove or repurpose unused views

---

## Files to Modify (Phase 1)

| File | Changes |
|------|---------|
| `src/views/admin/AdminListingsView.vue` | Add KPI row; use HpaEmptyState |
| `src/views/admin/AdminPayoutsView.vue` | Add KPI row |
| `src/views/admin/AdminVehiclesView.vue` | Use HpaEmptyState for empty list |
| `src/views/client/ClientBrowseView.vue` | Use HpaEmptyState for no results |
| `src/views/client/ClientBrowseRentalsView.vue` | Use HpaEmptyState |
| `src/views/client/ClientCheckoutView.vue` | Add loading on submit |
| `src/views/admin/AdminBookingsView.vue` | Add export to table |
| `src/style.css` or shared SCSS | Standardize section padding |

---

## Summary

The app has a solid base with shared components and role-based dashboards. The main gaps are:

- **Missing KPIs** on a few admin pages  
- **Inconsistent empty states** and missing CTAs  
- **Form validation and loading** on key flows  
- **Styling and spacing** consistency  
- **Data/API** duplication and domain mismatch in some views  

Tackling Phase 1 and 2 will give the biggest UX and consistency gains with relatively low effort.
