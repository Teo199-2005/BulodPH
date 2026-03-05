# Animation & GSAP – further suggestions

Already done: Login, Register, Forgot Password, Reset Password (auth panel), Dashboard stat stagger, Public scroll-reveal, route transition, card/button hovers.

Below are **optional next steps** you can add over time. Keep motion subtle and respect `prefers-reduced-motion`.

---

## 1. **List / grid stagger on load** (useGsapStagger)

Use when a page shows a list or grid that appears in one go (no scroll needed to see it).

| View | What to stagger | Notes |
|------|-----------------|--------|
| **ClientBookingsView** | Booking cards | Wrap the list in a ref, `selector: '.v-card'` or the card wrapper class. |
| **ClientCartView** | Cart item cards | Same pattern; already uses DashboardTemplate so cards reveal on scroll—optional stagger on the list container. |
| **ClientFavoritesView** | Favorite vehicle cards | Stagger the grid columns/cards. |
| **ClientBrowseRentalsView** | Rental company cards | Stagger each rental card. |
| **CarOwnerBookingsView** | Booking rows/cards | Stagger list items. |
| **CarOwnerVehiclesView** | Vehicle cards | Stagger the grid. |
| **AdminBookingsView** | Table or card list | Stagger rows or first N cards. |
| **AdminListingsView** | Listing cards | Stagger cards. |
| **AdminVehiclesView** | Vehicle rows/cards | Stagger table rows or cards. |
| **ClientsView** | Client list items | Stagger rows. |
| **CarOwnersView** | Car owner cards | Stagger. |
| **MarketingStaffView** | Staff/referral list | Stagger. |
| **AnnouncementsView** | Announcement cards | Stagger. |
| **ReportsView** | Report blocks or chart cards | Stagger sections. |

**Pattern:** Add `ref="listRef"` on the container, then:

```ts
useGsapStagger(listRef, { selector: '.your-card-class', y: 12, duration: 0.4, stagger: 0.05 })
```

---

## 2. **Scroll reveal** (data-gsap-reveal or existing selectors)

DashboardTemplate already reveals `.modern-card`, `[data-gsap-reveal]`, etc. Add **`data-gsap-reveal`** on any block that should animate when it scrolls into view but isn’t matched by the current selectors.

| View | Element to tag |
|------|----------------|
| **ClientBookingDetailView** | Main content sections (dates, vehicle, payment). |
| **ClientVehicleDetailView** | Detail blocks (description, specs, CTA). |
| **AdminBookingDetailView** | Header and action cards. |
| **ProfileView** | Profile sections (avatar, details, verification). |
| **SettingsView** | Settings sections. |
| **KycVerificationView** | Upload / instructions block. |
| **DisputeDetailView** | Evidence and messages. |
| **MessagingView** | Conversation thread container. |

---

## 3. **“Panel” entrance** (useGsapAuthPanel-style)

Use a short fade + slide-up when a **modal or side panel** opens (not just auth).

| Component / View | Idea |
|------------------|------|
| **RegisterRoleModal** | On open, animate the modal content (opacity + y) instead of only scale. |
| **HpaModal** | Optional: run a short `gsap.fromTo` on the inner content when `modelValue` becomes true. |
| **ProfileView** (edit mode) | If you have an edit “panel” or sheet, animate it in. |
| **Admin detail drawers** | If any detail view opens in a drawer, animate the drawer content. |

You can reuse `useGsapAuthPanel` with a ref to the inner content and call it in `onMounted` or when the panel becomes visible (e.g. `watch(modelValue, …)`).

---

## 4. **Success / feedback states**

| Where | Idea |
|-------|------|
| **Checkout** | After “Booking submitted”, animate the success message (e.g. `gsap.fromTo(el, { scale: 0.98, opacity: 0 }, { scale: 1, opacity: 1, duration: 0.3 })`). |
| **Promo applied** | When “10% off applied” appears, quick fade-in (or already covered by v-if + layout). |
| **Form success** | Forgot/Reset success message: light fade-in when `success === true`. |
| **Toast / snackbar** | If you use a custom toast, slide-in from top/bottom + fade. |

---

## 5. **Tables and data**

| View | Idea |
|------|------|
| **HpaDataTable** | Optional: stagger table rows on first load (e.g. `selector: '.v-data-table__tr'` in a ref to the table body). |
| **Admin Payouts / Reports** | Stagger summary cards or first table rows. |
| **CarOwnerEarningsView / MarketingEarningsView** | Stagger stat cards or list items. |

---

## 6. **Public / marketing**

| Page | Idea |
|------|------|
| **BlogIndexView** | Already has scroll-reveal; optional stagger per post card on scroll. |
| **BlogPostView** | Fade-in article body; optional stagger for images or pull-quotes. |
| **TrustSafetyView** | Add `scroll-reveal` class to sections and rely on PublicLayout GSAP. |
| **TermsOfServiceView / PrivacyPolicyView** | Optional: fade-in main content. |
| **AffiliateApplyView** | Scroll-reveal for form and benefits (add `.scroll-reveal` if not already). |
| **CityPageView** | Same as Fleet: scroll-reveal + optional card stagger. |

---

## 7. **Empty states**

When switching from loading to empty list, animate the empty-state block (e.g. **HpaEmptyState**): `useGsapAuthPanel(emptyStateRef, { y: 10, duration: 0.35 })` so it doesn’t feel abrupt.

---

## 8. **Micro-interactions**

| Element | Idea |
|--------|------|
| **v-expansion-panel** | When a panel opens, optional fade-in for the panel content (CSS or GSAP). |
| **Filters (e.g. Browse)** | When filters expand, optional stagger for the filter fields. |
| **Bottom nav / sidebar** | Active item: already transition; optional very light scale on tap (e.g. 0.98) for feedback. |

---

## Implementation order (suggested)

1. **High traffic:** Client Bookings, Cart, Favorites, Vehicle detail – stagger or `data-gsap-reveal` where it’s quick to add.
2. **Admin/Car owner/Marketing:** Stagger on list views (bookings, vehicles, clients, staff).
3. **Modals:** RegisterRoleModal, HpaModal – panel-style entrance when opened.
4. **Success states:** Checkout success, promo applied, form success messages.
5. **Public:** Trust & safety, Terms/Privacy, Affiliate apply – ensure `.scroll-reveal` or equivalent.
6. **Empty states and tables:** Stagger or short entrance for empty state and table rows where it doesn’t hurt performance.

All of the above should respect `prefers-reduced-motion: reduce` (skip or shorten animations).
