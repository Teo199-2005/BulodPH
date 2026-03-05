# BulodPH – What It Is, User Roles & Dashboard Content Guide

This guide is based on your **landing page** and **registration flow**. Use it to implement or refine the four role-specific dashboards.

---

## 1. What is BulodPH (from landing page)

- **Tagline:** “Your neighbor’s garage, now within reach.”
- **Definition:** Car rental marketplace **throughout the region and across the Philippines**. Browse, book, drive.
- **Core actions:** **Find a ride** (rent) or **List your vehicle** (earn).
- **Locations:** Throughout the region & beyond.
- **Payments:** GCash & Maya; secure, no cash hand-offs.
- **Trust:** 2-step verification (ID, LTO license, NBI/passport); “Verified by BulodPH” badge; digital hand-off with checklist and photos.
- **Terms:** **Kadua** = Host (vehicle owner), **Pasahero** = Traveler (renter).
- **Values:** Fully local, “Walang sayang” (owners earn from idle cars, renters save), marketplace, secure hand-off, community-first.

---

## 2. The 4 user types and their functions

| Role | Who they are | Main functions (from landing + register) |
|------|----------------|------------------------------------------|
| **Client** | Renter / Pasahero | Find a ride; book cars from neighbors; pay with GCash/Maya; use for city trips, road trips (e.g. Magat Dam), or quick errands. |
| **Car owner** | Host / Kadua | List your car; earn when it’s idle; hand off to renters; use digital checklist and photos; “walang sayang” – car works for you even when at home. |
| **Marketing partner** | Promoter / referrer | Partner with BulodPH; grow reach; promote the marketplace; earn through **referrals and campaigns**. |
| **Admin** | Platform operator | Manage platform: users, listings, bookings, payouts, support, reports, and policies. |

---

## 3. Suggested dashboard contents by role

### 3.1 Client dashboard (Renter / Pasahero)

**Goal:** Help renters find a ride, manage bookings, and see trip history.

| Section | Suggested content |
|--------|--------------------|
| **Hero / welcome** | Short greeting + “Find a ride throughout the region” + CTA **Browse rides**. |
| **Quick stats** | Total trips, upcoming bookings, saved vehicles (if you add favorites). |
| **Browse / search** | Search or filter by location (Cauayan, Ilagan, etc.), vehicle type (car), dates. Reuse “Featured Rides” style cards (Sedan, Hatchback, SUV) with **Book now**. |
| **My bookings** | List of bookings: **Upcoming** (date, vehicle, host, status), **Past** (trip summary, receipt link). Actions: View details, Cancel (if allowed), Pay (if pending). |
| **Promo** | Banner: “30% off your first ride • Use code **BULOD30**” (from landing). |
| **How it works** | 3 steps: Mag-Register → Mag-Pili → Bulod Na! (Verify → Browse → Book & meet Kadua). |
| **Support** | Link to Help / FAQ, contact (e.g. hello@bulodph.com, +63 912 345 6789). |

**Optional:** Saved/list of favorite vehicles; reviews you’ve written; payment methods (GCash/Maya).

---

### 3.2 Car owner dashboard (Host / Kadua)

**Goal:** Help owners list vehicles, manage availability, see earnings and bookings.

| Section | Suggested content |
|--------|--------------------|
| **Hero / welcome** | “Earn from your idle car” + CTA **Add a vehicle** or **Manage listings**. |
| **Quick stats** | Total earnings (this month / all time), active listings, upcoming hand-offs, completed trips. |
| **My vehicles** | Cards per listing: photo, name/type (e.g. Toyota Innova), location, price/day, status (Available / On trip / Unavailable). Actions: Edit, Pause, View bookings. |
| **Bookings** | **Upcoming hand-offs** (date, renter, vehicle, meet-up); **Past trips** (earnings per trip). Optional: Approve/decline request, mark “handed over” / “returned”. |
| **Earnings** | Simple summary: This month, Last month, Total; payout method (GCash/Maya); “Request payout” or “Next payout date”. |
| **How it works** | Short flow: List vehicle → Set price & availability → Accept booking → Hand off (checklist + photos) → Get paid. |
| **Trust** | “Verified by BulodPH” badge when eligible; link to verification status (ID, license). |
| **Support** | Help, FAQ, contact. |

**Optional:** Calendar view of availability; renter reviews; damage reports.

---

### 3.3 Marketing partner dashboard

**Goal:** Help partners see referral performance, campaigns, and earnings.

| Section | Suggested content |
|--------|--------------------|
| **Hero / welcome** | “Grow your reach with BulodPH” + “Promote the marketplace and earn through referrals and campaigns.” |
| **Quick stats** | Referral link clicks, sign-ups from your link, conversions (e.g. first booking), **referral earnings** (this month / total). |
| **Referral link** | Your unique link + “Share” (copy, social buttons). Short note: “You earn when someone signs up or books via your link.” |
| **Campaigns** | List of active campaigns: name, type (e.g. referral, promo), period, your performance (clicks, sign-ups, earnings). CTA: “Share campaign” or “Get materials”. |
| **Earnings** | Referral earnings breakdown (by month or by campaign); payout method; “Request payout” or next payout date. |
| **Resources** | BulodPH logos, key messages (“Car rental marketplace throughout the region”), sample posts or flyers. |
| **Support** | Contact for partner questions. |

**Optional:** Leaderboard (if you run one); campaign creatives download.

---

### 3.4 Admin dashboard

**Goal:** Oversee platform health, users, listings, bookings, and support.

| Section | Suggested content |
|--------|--------------------|
| **Hero / welcome** | “BulodPH admin” or “Platform overview.” |
| **Key metrics** | Total users (by role: clients, car owners, marketing partners), active listings, bookings (today / week / month), revenue or GMV, support tickets open. |
| **Users** | Table or list: email, name, role, status (active/suspended), joined date. Actions: View, Edit, Suspend, Impersonate (if needed). Filters: by role, status. |
| **Listings** | All vehicles: owner, type, location, price, status (active/paused/removed). Actions: View, Approve, Feature, Hide, Contact owner. |
| **Bookings** | All bookings: renter, host, vehicle, dates, status (pending/confirmed/completed/cancelled), amount. Actions: View, Cancel, Refund, Mark completed. |
| **Payouts** | List of payout requests or scheduled payouts (car owners + marketing partners); status; approve/reject or mark paid. |
| **Support / reports** | Open tickets, NBI/verification flags, dispute list; link to full support tool if separate. |
| **Settings / content** | Promo codes (e.g. BULOD30), landing announcements, FAQ edits, “Coming soon April 2026” toggle. |

**Optional:** Audit log, email/SMS logs, analytics (sign-ups, bookings over time).

---

## 4. Cross-cutting elements (all dashboards)

- **Header:** BulodPH logo, main nav (role-relevant), user menu (profile, logout).
- **Footer (optional):** Short links – Help, FAQ, Contact, Privacy, Terms; “Verified by BulodPH” where relevant.
- **Trust:** Where applicable, show verification status and “2-step verification” / “GCash & Maya” so it matches the landing page.

---

## 5. Implementation order (suggested)

1. **Client:** Browse rides (mock or API), My bookings (list + detail), promo banner.
2. **Car owner:** My vehicles (list + add/edit), Bookings, Earnings summary.
3. **Marketing partner:** Referral link, Referral stats, Earnings.
4. **Admin:** Users list, Listings list, Bookings list, then payouts and support.

Use the same **role-based routes** you already have (`/client`, `/admin`, `/car-owner`, `/marketing`) and render the right dashboard content per route (or one `DashboardView` that branches on `user.roles`). Keep copy aligned with the landing page (the region, Kadua/Pasahero, GCash & Maya, BULOD30, etc.) so the product feels consistent.
