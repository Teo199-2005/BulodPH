# BulodPH — Price & Marketing Appeal Plan

A structured plan to make prices more appealing, add discounted-price presentation, and apply consumer-focused marketing styling across the app.

---

## 1. Goals

- **Prices:** Consistent, readable formatting (₱ with thousands separator); prominent but not harsh.
- **Discounts:** Show original + discounted price where applicable; badges and strikethrough for “sale” feel.
- **Marketing:** Trust cues, urgency, clear CTAs, and promo visibility to improve conversion.

---

## 2. Where Prices Appear (Audit)

| Location | File(s) | Current | Action |
|----------|---------|---------|--------|
| **Client – Dashboard** | `DashboardView.vue` | `₱{{ vehicle.pricePerDay }}/day` | Add formatted price; optional discount/original. |
| **Client – Browse** | `ClientBrowseView.vue` | `₱{{ vehicle.pricePerDay }}/day` | Same + discount badge if applicable. |
| **Client – Vehicle detail** | `ClientVehicleDetailView.vue` | `₱{{ vehicle.pricePerDay }}/day` | Prominent price block; original/discounted. |
| **Client – Cart** | `ClientCartView.vue` | `₱{{ item.pricePerDay }}/day`, total | Line items + total; show savings. |
| **Client – Checkout** | `ClientCheckoutView.vue` | Subtotal, discount, total | Keep; improve styling (savings in green, total bold). |
| **Client – Favorites** | `ClientFavoritesView.vue` | `₱{{ v.pricePerDay }}/day` | Same as Browse. |
| **Client – Booking detail** | `ClientBookingDetailView.vue` | `₱{{ booking.total }}` | Formatted; optional “You saved ₱X”. |
| **Client – Payments** | `ClientPaymentsView.vue` | `₱{{ item.total }}` | Formatted. |
| **Car owner – Vehicles** | `CarOwnerVehiclesView.vue` | `₱{{ v.pricePerDay }}/day` | Formatted. |
| **Car owner – Form** | `CarOwnerVehicleFormView.vue` | Inputs only | Optional “Suggested” / “From ₱X”. |
| **Admin – Vehicles** | `AdminVehiclesView.vue` | List + form | Formatted in list; filters stay. |
| **Other** | Earnings, Payouts, Reports, Invoices | Various | Use shared formatter. |

---

## 3. Price Formatting (Foundation)

### 3.1 Shared price utility

- **Add:** `src/utils/priceFormat.ts` (or `composables/usePriceFormat.ts`)
  - `formatPrice(amount: number, options?: { showDecimals?: boolean, suffix?: string })`  
    → e.g. `₱2,500` or `₱2,500/day`
  - `formatPriceRange(min: number, max?: number)`  
    → `₱2,000 – ₱4,000/day`
- Use `toLocaleString('en-PH', { minimumFractionDigits: 0, maximumFractionDigits: 0 })` for consistency.

### 3.2 Optional: global filter or component

- Either a Vue filter/global property `$formatPrice`, or a small `<PriceAmount>` component used everywhere so formatting and styling stay consistent.

---

## 4. Discounted Prices (Data & UI)

### 4.1 Data model (optional but recommended)

- **Vehicle (seed / types):**
  - `pricePerDay` (current selling price).
  - `originalPricePerDay?: number` — if set, show as “was ₱X” and display discounted price as main.
  - Or derive from promo: e.g. “First ride 30% off” applied at checkout only; listing can show “From ₱X after BULOD30”.
- **Promo application:** Checkout already has `discountPercent` and `summary.discount`. Ensure cart and vehicle cards can show “Save up to X%” or “₱X off with BULOD30” where relevant.

### 4.2 UI patterns for “discount”

- **Listing cards (Browse, Dashboard, Favorites):**
  - If `originalPricePerDay > pricePerDay`: show strikethrough `₱4,000` + bold `₱2,800` and a small badge “20% off” or “Save ₱1,200”.
  - If no original but promo applies at checkout: small chip “30% off with BULOD30” (or “Promo”).
- **Vehicle detail page:**
  - Price block: large discounted price; below it, smaller “Was ₱X” with strikethrough; optional “You save ₱X (20%)”.
- **Cart / Checkout:**
  - Already show discount line; style it clearly (green, “You’re saving ₱X”) and make total prominent.

### 4.3 Seed data for demos

- Add a few vehicles in `vehicleSeed.ts` with `originalPricePerDay` (e.g. one SUV at 4000 with original 5000) so discount UI is visible without backend.

---

## 5. Marketing-Appealing Styling

### 5.1 Price-specific styles (CSS / design tokens)

- **Primary price (selling):** Slightly larger, bold, use `--primary` or `--trust-blue`; optional very subtle gradient or shadow for “premium” feel.
- **Original price (strikethrough):** Smaller, `--text-muted`, `text-decoration: line-through`.
- **Savings text / discount line:** Green (`--accent-green` or `success`), e.g. “You save ₱1,200”.
- **Badges:** “20% off”, “Promo”, “First ride deal” — small, pill-shaped, accent color; do not overwhelm the card.

### 5.2 Trust & urgency (light touch)

- **Trust:** “Verified by BulodPH”, “Secure payment”, “Free cancellation until X” (if applicable) near price or CTA.
- **Urgency:** Only if accurate, e.g. “Promo ends Dec 31” on checkout or promo page; avoid fake countdowns.
- **Social proof:** Reviews and “X trips completed” already help; keep them visible near vehicle cards and detail.

### 5.3 CTAs and hierarchy

- Primary CTA (e.g. “Book now”, “Reserve”) — use existing primary button; ensure contrast and size.
- Secondary (e.g. “Save for later”, “Compare”) — outlined or text; less prominent than primary.
- On listing cards: one clear primary action; price and discount should be scannable in &lt; 2 seconds.

### 5.4 Promo visibility

- **Dashboard:** Promos & offers already visible; ensure CTA on promo card is obvious.
- **Browse:** Optional thin banner “Use BULOD30 for 30% off your first ride” (dismissible or minimal).
- **Checkout:** Promo code field prominent; after applying, show “You’re saving ₱X” in green.
- **Promos page:** Keep; consider short “How to use” and expiry/terms clearly visible.

---

## 6. Implementation Phases

### Phase 1 — Foundation (low risk)

1. Add `src/utils/priceFormat.ts` with `formatPrice` and `formatPriceRange`.
2. Use it in 2–3 key places (e.g. ClientBrowseView, ClientVehicleDetailView, ClientCheckoutView) and replace raw `₱{{ x }}`.
3. Add CSS variables or utility classes for “price main”, “price original”, “price savings” in `style.css` or a small `price.css`.

### Phase 2 — Discount display (vehicle cards & detail)

1. Extend vehicle type/seed with optional `originalPricePerDay`.
2. Add 1–2 seed vehicles with `originalPricePerDay` for demo.
3. Create a small `PriceDisplay` component (or inline logic): accepts `pricePerDay`, `originalPricePerDay?`, optional `promoLabel`; renders main price, optional strikethrough original, optional “Save ₱X” / “X% off”.
4. Use it on Dashboard (client), Browse, Favorites, Vehicle detail.

### Phase 3 — Cart & Checkout polish

1. Cart: format all amounts with `formatPrice`; if cart has a promo applied, show “Savings: ₱X” near total.
2. Checkout: style discount line (green, clear “You’re saving”); make total and “Confirm and pay ₱X” prominent.
3. Optional: “You save ₱X with BULOD30” summary line when promo is applied.

### Phase 4 — Marketing styling pass

1. Apply “price main” / “price original” / “savings” styles everywhere prices appear.
2. Add small “Promo” / “X% off” badges on cards where applicable (from vehicle data or global first-ride promo).
3. Optional: minimal trust line under price or above CTA on vehicle detail (“Secure payment · Verified host”).
4. Review CTA hierarchy on Browse, Vehicle detail, Cart, Checkout; ensure one clear primary action per screen.

### Phase 5 — Consistency & admin/car-owner

1. Replace remaining raw `₱{{ ... }}` with `formatPrice` (or `<PriceAmount>`) in Admin vehicles, Car owner views, Earnings, Payouts, Reports, etc.
2. Ensure filters (min/max price) and inputs still use numbers; only display uses formatter.

---

## 7. Files to Touch (Summary)

| Purpose | Files |
|--------|--------|
| **Price formatter** | New: `src/utils/priceFormat.ts` or `src/composables/usePriceFormat.ts` |
| **Price component** | New: `src/components/PriceDisplay.vue` or `PriceAmount.vue` (optional) |
| **Styles** | `src/style.css` (tokens/classes for price, discount, badge) |
| **Vehicle type/seed** | `src/constants/vehicleSeed.ts`, types in `vehicleSeed.ts` or `types/` |
| **Client** | `DashboardView.vue`, `ClientBrowseView.vue`, `ClientVehicleDetailView.vue`, `ClientCartView.vue`, `ClientCheckoutView.vue`, `ClientFavoritesView.vue`, `ClientBookingDetailView.vue`, `ClientPaymentsView.vue` |
| **Car owner** | `CarOwnerVehiclesView.vue`, `CarOwnerEarningsView.vue`, `CarOwnerPayoutHistoryView.vue`, `CarOwnerBookingDetailView.vue`, `CarOwnerCalendarView.vue` |
| **Admin** | `AdminVehiclesView.vue`, `AdminPayoutsView.vue` |
| **Marketing** | `MarketingEarningsView.vue`, `MarketingPayoutHistoryView.vue`, `MarketingHowYouEarnView.vue`, `MarketingAnalyticsView.vue` |
| **Other** | `ReportsView.vue`, `InvoicesView.vue`, `ClientPromoView.vue` (styling only if needed) |

---

## 8. Do Not Do (to stay honest and maintainable)

- No fake “was ₱X” when there was no real original price.
- No fake countdown timers or “only 1 left” unless backed by data.
- No dark patterns (hidden fees; discount that doesn’t apply).
- Keep discount logic in one place (e.g. checkout + optional vehicle-level original price); avoid scattered magic numbers.

---

## 9. Success Criteria

- All displayed prices use the same formatting (₱X,XXX).
- Where a discount exists, users see original (strikethrough) + discounted price and/or “You save ₱X”.
- Checkout clearly shows discount and total; primary CTA is obvious.
- Marketing styling (badges, savings in green, trust line) is consistent and light-handed.
- Plan is implementable in phases without breaking existing flows.

You can implement Phase 1 first, then Phase 2 (discount display), then Phase 3–5 as needed. If you tell me which phase you want to start with, I can generate the concrete code changes next.
