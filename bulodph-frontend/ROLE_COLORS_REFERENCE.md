# BulodPH Role Color Reference

Single source of truth for role-based colors. **Registration page** uses **navy blue** (renter), **green** (car owner), and **purple** (marketing partner). **Admin** uses **red** (not on registration; for dashboard/layout only).

Use these values in:
- Dashboard layout (sidebar, app bar, role pill)
- Stats cards (`HpaDashboardWidget` / role accent)
- Modals and confirmation modals (header accent, primary button)
- Toast notifications (optional role tint)
- Footer accent (optional)
- Any role-specific UI (badges, section titles, borders)

---

## 1. Client (Renter) — Navy blue

| Use            | Value |
|----------------|--------|
| **Primary**    | `#1e3a5f` |
| **Primary hover / dark** | `#2d3a52` |
| **Accent gradient** | `linear-gradient(90deg, #2d3a52, #1e3a5f)` |
| **Background tint** | `rgba(30, 58, 95, 0.12)` |
| **Border**     | `rgba(30, 58, 95, 0.25)` to `0.35` |
| **Text on tint** | `#1e3a5f` |

*Matches registration: "Sign up to rent" card, role indicator, form card accent.*

---

## 2. Car owner — Green

| Use            | Value |
|----------------|--------|
| **Primary**    | `#047857` |
| **Primary hover / dark** | `#059669` |
| **Accent gradient** | `linear-gradient(90deg, #059669, #047857)` |
| **Background tint** | `rgba(4, 120, 87, 0.12)` |
| **Border**     | `rgba(4, 120, 87, 0.25)` to `0.35` |
| **Text on tint** | `#047857` |

*Matches registration: "Sign up as car owner" card, role indicator, form card accent.*

---

## 3. Marketing partner — Purple

| Use            | Value |
|----------------|--------|
| **Primary**    | `#5b21b6` |
| **Primary hover / dark** | `#6d28d9` |
| **Accent gradient** | `linear-gradient(90deg, #6d28d9, #5b21b6)` |
| **Background tint** | `rgba(91, 33, 182, 0.12)` |
| **Border**     | `rgba(91, 33, 182, 0.25)` to `0.35` |
| **Text on tint** | `#5b21b6` |

*Matches registration: "Sign up as partner" card, role indicator, form card accent.*

---

## 4. Admin — Red

| Use            | Value |
|----------------|--------|
| **Primary**    | `#dc2626` |
| **Primary hover / dark** | `#b91c1c` |
| **Accent gradient** | `linear-gradient(90deg, #dc2626, #b91c1c)` |
| **Background tint** | `rgba(220, 38, 38, 0.12)` |
| **Border**     | `rgba(220, 38, 38, 0.25)` to `0.35` |
| **Text on tint** | `#dc2626` |

*Not on registration; use for admin dashboard, sidebar, and role pill only.*

---

## 5. Role → CSS variable / constant (for DRY)

**Implemented:** `src/constants/roleColors.ts` exports `getRoleColors(role)`, `toRoleColorKey(role)`, `applyRoleCssVars(el, role)`, and `ROLE_CSS_VARS`. Layout uses `useRoleTheme(appShellRef)` to set CSS vars on the app shell.

Suggested mapping for code:

| Role             | Token / key   | Primary hex  |
|------------------|---------------|--------------|
| `client`         | `roleClient`  | `#1e3a5f`    |
| `car_owner`      | `roleCarOwner`| `#047857`    |
| `marketing_staff`| `roleMarketing` | `#5b21b6` |
| `admin`          | `roleAdmin`   | `#dc2626`    |

Use these tokens everywhere (sidebar active state, stats card icon bg, modal top bar, confirm button, footer border, etc.) so changing a role color is done in one place.

---

## 6. Registration page reference (line refs in `RegisterView.vue`)

- **Renter card border:** `.register-role-card--renter` — `#1e3a5f` / `#2d3a52`
- **Car owner card border:** `.register-role-card--car-owner` — `#047857` / `#059669`
- **Marketing partner card border:** `.register-role-card--marketing-partner` — `#5b21b6` / `#6d28d9`
- **CTA button gradients:** `.register-role-card--renter .register-role-card-cta` (navy), `--car-owner` (green), `--marketing-partner` (purple)
- **Role indicator pills:** `.auth-role-indicator--renter`, `--car-owner`, `--marketing-partner`
- **Form card accent bar:** `.auth-form-card--renter::before`, `--car-owner::before`, `--marketing-partner::before`

Keep dashboard and layout role colors aligned with this reference.
