# BulodPH – Full troubleshooting report

**Date:** March 1, 2026  
**Scope:** Frontend (Vue/Vite), Backend (Laravel 11), config, security, assets, and flows.

---

## Summary

| Area | Status | Notes |
|------|--------|--------|
| **Frontend build** | ✅ Pass | `npm run build` and `tsc --noEmit` succeed |
| **Frontend tests** | ✅ Pass | 59 tests, 10 files |
| **Backend routes** | ✅ OK | 167 routes; Laravel 11.48 |
| **Linting** | ✅ Clean | No linter errors in `src/` or `app/` |
| **API config** | ✅ OK | `VITE_API_URL` used; CORS uses `FRONTEND_URL` |
| **Missing asset** | ⚠️ Fix | `og-image.png` not in `public/` (see below) |
| **Legacy backend** | 📌 Note | NDIS/Shifts/Staff API routes present (optional cleanup) |

---

## 1. Build & tests

- **Frontend**
  - `npm run type-check` (tsc --noEmit): **pass**
  - `npm run build` (tsc && vite build): **pass** (~53s)
  - `npm run test:run`: **59 tests pass** (10 spec files)
- **Backend**
  - `php artisan --version`: Laravel 11.48.0
  - `php -l` on `AdminClientController.php`: no syntax errors
  - `php artisan route:list`: 167 routes registered

---

## 2. Configuration

- **Frontend `.env` / `.env.example`**
  - `VITE_API_URL` (default `http://localhost:8000/api`) – used in `src/lib/api.ts`
  - `VITE_DEMO_ACCOUNTS_ENABLED`, `VITE_APP_VERSION`, `VITE_GOOGLE_MAPS_*` – documented
- **Backend `.env.example`**
  - `APP_URL`, `FRONTEND_URL`, `SANCTUM_STATEFUL_DOMAINS` – set for local/production
  - `CORS_ALLOWED_ORIGINS` falls back to `FRONTEND_URL`; `CORS_SUPPORTS_CREDENTIALS` defaults to `true`
- **API client** (`src/lib/api.ts`)
  - `baseURL` from `VITE_API_URL`
  - `withCredentials: false` – correct when using **Bearer token only** (no cookie auth). Backend CORS `supports_credentials: true` is fine for other clients or future cookie use.

---

## 3. Routes & links

- **Vue Router**
  - Public: `/`, `/about`, `/fleet`, `/contact`, `/faq`, `/login`, `/register`, `/privacy`, `/terms`, `/accessibility`, `/trust-safety`, `/blog`, `/partners` (affiliate-apply), etc.
  - Dashboard (auth): client, car-owner, marketing, admin – all under `MobileLayout` with role meta.
- **ROUTES** (`src/constants/siteUrls.ts`)
  - Contains: home, about, fleet, blog, contact, faq, login, register, privacy, terms, accessibility.
  - Public footer uses only these; all linked routes exist.
- **Backend API**
  - Auth: login, register, forgot-password, reset-password
  - Public: trust-safety, blog-posts, city-pages, affiliate/apply, car-rentals, public/payment-qr
  - Protected: bookings, vehicles, profile, cart, messages, admin/*, etc.

---

## 4. Assets

- **Present**
  - `public/logo.png` – used in footer/navbar
  - `public/vite.svg` – favicon in `index.html`
  - `public/images/bulod-dashboard-showcase.png` – footer showcase
- **Missing**
  - **`public/og-image.png`** – referenced in `index.html` as `<meta property="og:image" content="/og-image.png" />`. Social shares will get a 404 or no image. **Action:** Add a 1200×630 (or similar) OG image at `bulodph-frontend/public/og-image.png`.

---

## 5. Security & production

- **CSP** (index.html): Dev-friendly (`unsafe-inline`, `unsafe-eval`). PUBLISH_CHECKLIST says production should use server-sent CSP (e.g. backend SecurityHeaders) – correct.
- **Auth**: 401 from API clears session and redirects to `/login` (api interceptor).
- **Rate limiting**: Login 5/min, register 10/min, reset-password 5/min on API.
- **Sensitive data**: No secrets in repo; `.env` not committed. Demo accounts gated by `VITE_DEMO_ACCOUNTS_ENABLED`.

---

## 6. Backend legacy / optional cleanup

- **API routes** for **NDIS plans** (`api/ndis-plans`), **Shifts** (`api/shifts`), **Staff** (`api/staff`) are registered. These look like leftovers from another product (e.g. care/NDIS). If BulodPH is car-rental only, consider:
  - Removing or hiding these routes and controllers, or
  - Leaving them disabled behind feature flags if you might use them later.

---

## 7. Recommended actions

1. **Add `public/og-image.png`**  
   Create or copy an OG image (e.g. 1200×630) to `bulodph-frontend/public/og-image.png` so social previews work.

2. **Before production**
   - Set `VITE_API_URL` to production API (e.g. `https://api.bulodph.com/api`).
   - Set `APP_ENV=production`, `APP_DEBUG=false`, `CORS_ALLOWED_ORIGINS`, `SANCTUM_STATEFUL_DOMAINS`.
   - Set `VITE_DEMO_ACCOUNTS_ENABLED=false`.
   - Follow **PUBLISH_CHECKLIST.md** and **bulodph-backend/SECURITY_HARDENING.md**.

3. **Optional**
   - Add `trustSafety` and `partners` (e.g. `/trust-safety`, `/partners`) to `ROUTES` in `siteUrls.ts` if you want footer or other links to use the constant.
   - Plan removal or feature-flag of NDIS/Shifts/Staff APIs if not used.

---

## 8. Quick verification commands

```bash
# Frontend
cd bulodph-frontend
npm run type-check
npm run build
npm run test:run

# Backend
cd bulodph-backend
php artisan route:list
php artisan config:clear
```

---

*Report generated from codebase inspection and run of build, type-check, tests, and route list.*
