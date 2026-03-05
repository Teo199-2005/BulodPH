# BulodPH – Must-have features & new pages by role

Suggestions for **Clients**, **Marketing partners**, and **Car owners** so each role has a complete, production-ready experience.

---

## 1. Clients (Pasahero / renters)

**Current:** Dashboard, Browse rides, Vehicle detail, My bookings, Cart, Checkout, Promos, Payments, Notifications, Profile, Settings.

### New pages (must-have)

| Page / feature | Why |
|----------------|-----|
| **Favorites / Saved vehicles** | Let users save vehicles (heart icon on cards) and view them in one place. Increases return bookings. |
| **Help / FAQ** | Central place for “How do I book?”, “Cancellation policy”, “Payment methods”, “What if I damage the vehicle?”. Reduces support load. |
| **Rental history & receipts** | From “Past” bookings: **Download receipt** (PDF or simple page). Needed for expense claims and disputes. |
| **Support / Contact** | Page or modal: “Contact BulodPH” (email, chat, or form). Link in footer and in booking detail. |

### Functions to add on existing pages

| Where | Suggestion |
|-------|-------------|
| **My bookings** | **Cancel booking** (with policy: free until X hours before). **Modify dates** (if allowed by policy). **Contact host** (message or call). **Get directions** to pickup (link to Maps). |
| **Browse / Vehicle detail** | **Reviews & ratings** for the vehicle or host (read-only for now; later allow “Leave a review” after completed trip). |
| **Promos** | List **all active promos** from API; show **expiry** and **terms**. Optional: “Promo applied” badge on checkout when code is valid. |
| **Dashboard** | **Recent activity** (e.g. “Your booking for Toyota Innova was confirmed”). **Quick rebook** from last trip. |
| **Payments** | **Default payment method** toggle. **Billing history** (list of charges with date, booking, amount). |

---

## 2. Marketing partners

**Current:** Dashboard, Referral link (copy + share to FB/WhatsApp/Twitter), Campaigns (list + stats), Earnings, Resources, Payout method, Notifications.

### New pages (must-have)

| Page / feature | Why |
|----------------|-----|
| **Referral performance / Analytics** | Dedicated page: **link clicks**, **sign-ups**, **first booking**, **earnings** over time (chart). Per-referral or per-campaign breakdown. So partners see ROI. |
| **How you earn** | Simple page: “You earn ₱X when someone signs up, ₱Y when they complete first booking.” Commission rules, payout schedule, minimum payout. Builds trust. |
| **Payout history** | List of past payouts (date, amount, method, status). Link from Earnings. Same idea as car-owner payout history. |

### Functions to add on existing pages

| Where | Suggestion |
|-------|-------------|
| **Referral link** | **QR code** (download or show) for in-person sharing. **Short link** (e.g. bulodph.com/r/ABC123). **Email share** (mailto with body). Optional: **track which channel** (FB vs WhatsApp vs copy). |
| **Campaigns** | **Get materials** → download pack (images, copy, hashtags). **Campaign-specific link** so clicks are attributed to that campaign. |
| **Earnings** | **Breakdown**: sign-up bonus vs first-booking bonus. **Pending vs available balance**. **Next payout date** (e.g. “Payouts run every Friday”). |
| **Dashboard** | **Real stats** from API: link clicks, sign-ups, conversions, earnings (replace placeholders). **Leaderboard** (optional): top referrers this month. |

---

## 3. Car owners (Kadua)

**Current:** Dashboard, My vehicles, Add/Edit vehicle, Bookings (Requested / Upcoming / Completed), Booking detail (Accept, Decline, Mark handed over, Mark returned), Earnings, Payout method, Notifications.

### New pages (must-have)

| Page / feature | Why |
|----------------|-----|
| **Calendar / Availability** | Per vehicle: block dates (unavailable), see when it’s booked. Stops double-booking and sets expectations. |
| **Vehicle performance** | Per vehicle: **views**, **bookings count**, **earnings**, **average rating** (if reviews exist). Helps owners decide pricing and which car to add next. |
| **Help / Getting started** | “How to list”, “Hand-off checklist”, “What to do if renter is late”, “Damage and insurance”. Reduces confusion. |
| **Payout / tax info** | **Payout history** (date, amount, method). Optional: **Documents for tax** (annual summary, invoice template). |

### Functions to add on existing pages

| Where | Suggestion |
|-------|-------------|
| **My vehicles** | **Availability toggle** (Available / Unavailable) without full edit. **Quick stats** on card: “3 bookings this month · ₱X earned”. |
| **Bookings** | **Filter by vehicle**. **Reminder**: “Hand-off in 24h” for upcoming. **Renter contact** (masked phone or in-app message). |
| **Booking detail** | **Hand-off checklist** (keys, fuel level, damage check) with checkboxes. **Return checklist**. **Upload photos** (before/after) for dispute protection. |
| **Earnings** | **By vehicle** breakdown. **By period** (this month, last month). **Pending** (from active bookings) vs **Available** (ready to withdraw). |
| **Dashboard** | **Real KPIs**: earnings this month, active listings, upcoming hand-offs, completed trips (from store/API). **Alerts**: “2 booking requests need your response”. |

---

## 4. Cross-role (shared)

| Item | Who | Suggestion |
|------|-----|------------|
| **Notifications** | All | **Mark all read**. **Group by type** (bookings, payments, promos). **Deep link** to the right page (already partly there). |
| **Profile** | All | **Phone number** (for contact). **Avatar** upload. **Email preferences** (promos, reminders). |
| **Settings** | All | **Language** (if you add i18n). **Notification preferences**. **Security** (change password, 2FA later). |

---

## 5. Priority order (suggested)

**High (must-have for launch):**
1. **Clients:** Favorites, Help/FAQ, Receipts from past bookings, Contact/Support.
2. **Car owners:** Calendar/availability, Payout history, Hand-off/return checklist.
3. **Marketing:** How you earn, Payout history, Referral analytics (or expand Referral page).

**Medium (soon after):**
- Clients: Reviews on vehicles, Cancel/Modify booking.
- Marketing: QR code + short link, Campaign materials download.
- Car owners: Vehicle performance page, Getting started guide.

**Nice-to-have:**
- Leaderboard (marketing), Billing history (client), Tax docs (car owner).

---

## 6. Where to wire it in the app

- **New routes:** Add in `router/index.ts` under the right role (e.g. `client/favorites`, `client/help`, `marketing/analytics`, `car-owner/calendar`).
- **New nav:** Add entries in `constants/roleNav.ts` (main or other) for each role.
- **New views:** Create under `views/client/`, `views/marketing/`, or `views/car-owner/` and reuse `DashboardTemplate` and existing stores/composables where possible.

If you tell me which role (and which 1–2 items) you want to build first, I can outline the exact components, routes, and data shape next.
