# BulodPH Website – Audit Findings

**Date:** March 1, 2026  
**Scope:** Frontend (Vue/Vite), Backend (Laravel API), security, UX, accessibility, and operations.

---

## Executive summary

The codebase has **solid foundations** (validation, auth, CORS, rate limiting, structured APIs) but has **several high- and medium-priority issues** across security, incomplete features, code quality, and production readiness. Below is a categorized list with recommended fixes.

---

## 1. Security

### High

| # | Finding | Location | Recommendation |
|---|---------|----------|----------------|
| 1.1 | **Demo credentials in frontend** | `LoginView.vue`: demo accounts with email/password (e.g. `client@bulodph.demo` / `Demo123!`) are hardcoded. If `VITE_DEMO_ACCOUNTS_ENABLED` is true in production, this is a serious risk. | Ensure `VITE_DEMO_ACCOUNTS_ENABLED=false` in production builds. Prefer loading demo accounts from env or a dedicated demo-only config so passwords never ship in client bundle. |
| 1.2 | **Payment flow not implemented** | `PaymentController.php`: `create` and `status` return stubs (empty reference/checkout_url, 404). Payment gateway flag returns 503 when disabled. | Implement Payment model, persist payment records, integrate GCash/Maya (or chosen gateway), and scope status by authenticated user. Remove or complete TODOs. |
| 1.3 | **v-html / document.write usage** | `ClientBookingDetailView.vue` (receipt fallback) builds HTML from booking data and uses `document.write(html)`. `HpaSearchHighlight.vue`, `ClientCheckoutView.vue`, `PlatformAgreementModal.vue`, `CarOwnerAgreementView.vue`, `HpaHelpView.vue` use `v-html`. | Escape all user- or API-sourced data before inserting into HTML (receipt: escape `b.id`, `b.vehicleName`, `b.start`, etc.). For `HpaSearchHighlight`, escape `text` before wrapping matches in `<mark>` to prevent XSS if content is user-generated. Where content is static (e.g. platform agreement), document that and consider sanitizing anyway (e.g. DOMPurify) for consistency. |

### Medium

| # | Finding | Location | Recommendation |
|---|---------|----------|----------------|
| 1.4 | **APP_DEBUG in .env.example** | `bulodph-backend/.env.example`: `APP_DEBUG=true`. | Default to `false` in example; document that production must use `APP_DEBUG=false`. |
| 1.5 | **CORS** | `config/cors.php`: uses `FRONTEND_URL` / `CORS_ALLOWED_ORIGINS`. | Confirm production env sets allowed origins explicitly (no wildcard in production). |
| 1.6 | **Raw SQL** | `AdminCarOwnerController.php`: `selectRaw('user_id, count(*) as cnt')`. | No user input in that expression; keep as-is but avoid adding user input into raw SQL elsewhere. |

---

## 2. Backend (Laravel / API)

### High

| # | Finding | Location | Recommendation |
|---|---------|----------|----------------|
| 2.1 | **Payment TODOs** | `app/Http/Controllers/Api/PaymentController.php` | Implement payment creation and status lookup; see Security 1.2. |
| 2.2 | **Stub controller surface** | `CarRentalStubController` used for dashboard, profile, KPIs, etc. | Plan migration to real implementations (DB, business logic) so production does not rely on stubbed behavior. |

### Medium

| # | Finding | Location | Recommendation |
|---|---------|----------|----------------|
| 2.3 | **User model $fillable** | `User.php`: includes many fields. | Ensure sensitive fields (e.g. `password`) are never mass-assigned from request; use `$guarded` or explicit assignment for sensitive attributes. (Current code uses `'password' => 'hashed'` in casts and explicit Hash::make in controllers; verify no route allows mass-assigning `password`.) |
| 2.4 | **Request validation** | Most API endpoints use Form Requests or inline validation. | Audit all POST/PUT/PATCH endpoints for required validation, type, and length limits; ensure file uploads are validated (type, size). |

---

## 3. Frontend (Vue / Vite)

### High

| # | Finding | Location | Recommendation |
|---|---------|----------|----------------|
| 3.1 | **Vue template errors (fixed)** | `ClientBrowseRentalsView.vue`, `ClientFavoritesView.vue`: `v-else` was not adjacent to `v-if`. | Fixed by wrapping loading branch in `<template v-if>` and using `v-else` on sibling. Re-run build to confirm no other templates have similar issues. |
| 3.2 | **Console usage in production** | `LandingPage.vue`: `console.error('GSAP Setup Failed', e)`. `paymentQr.ts`: `console.debug('[paymentQr] API response:', raw)`. | Replace with a logger that is no-op or stripped in production, or guard with `import.meta.env.DEV`. Remove or guard `console.debug` so it does not leak in production. |

### Medium

| # | Finding | Location | Recommendation |
|---|---------|----------|----------------|
| 3.3 | **Type safety** | Use of `any` in several places: `MarketingStaffView.vue` (`mapApiPartner(item: any)`), `CarOwnersView.vue` (`mapApiOwner(item: any)`), `ShiftsView.vue` (shift: any), `CarOwnerCalendarView.vue` (null as any), `CarOwnerVehicleFormView.vue` (payload as any), `receiptPdf.ts`, `inputFormat.ts`. | Introduce proper types (e.g. API response DTOs, shift/calendar types) and remove `any` where possible. |
| 3.4 | **Error handling** | Many services/composables use try/catch and return null or reject; some views may not show user-friendly messages for all failure cases. | Audit critical flows (login, register, checkout, booking, payments) and ensure every failure path shows a clear message and, where appropriate, retry or recovery. |
| 3.5 | **401 handling** | `lib/api.ts`: on 401, clears auth and redirects to `/login`. | Ensure redirect preserves intended destination (e.g. returnUrl) so users can land back after login. |

---

## 4. Accessibility (a11y)

| # | Finding | Location | Recommendation |
|---|---------|----------|----------------|
| 4.1 | **aria-label usage** | Many interactive elements have `aria-label`; some buttons or links may still lack them. | Run axe or Lighthouse a11y on key flows (login, browse, booking, checkout) and fix missing labels and roles. |
| 4.2 | **Images** | Most vehicle/rental images use `v-img` with `:alt`. | Ensure every meaningful image has a non-empty alt (or aria-label where decorative). |
| 4.3 | **Focus and keyboard** | Modals and dialogs. | Verify focus trap and restore, and that all actions are keyboard-accessible. |

---

## 5. Operations & configuration

| # | Finding | Location | Recommendation |
|---|---------|----------|----------------|
| 5.1 | **Environment** | `.env.example` for frontend and backend. | Ensure production checklist: `APP_DEBUG=false`, `APP_ENV=production`, strong `APP_KEY`, no default DB credentials, `VITE_DEMO_ACCOUNTS_ENABLED=false`, correct `VITE_API_URL` and CORS origins. |
| 5.2 | **Secrets** | Backend uses `env()` for DB, Redis, AWS, Brevo, etc. | No hardcoded secrets found; keep all secrets in env and never commit `.env`. |
| 5.3 | **Logging** | Backend uses Laravel Log. | Ensure production log level and channels (e.g. no stack traces to end users, secure log storage). |

---

## 6. Code quality & maintainability

| # | Finding | Location | Recommendation |
|---|---------|----------|----------------|
| 6.1 | **TODO / FIXME** | `PaymentController.php`: TODOs for payment create/status. | Resolve or track in issue tracker; avoid long-lived TODOs in critical paths. |
| 6.2 | **Duplicate logic** | Rental name/logo resolution duplicated between `ClientBrowseView.vue` and `ClientVehicleDetailView.vue` (latter was fixed to align with browse). | Consider a shared composable (e.g. `useRentalDisplay(vehicle)`) to avoid future drift. |
| 6.3 | **Scripts** | `scripts/get-image-dimensions.js` uses `console.log` for output. | Acceptable for a dev script; ensure it is not part of production bundle. |

---

## 7. Testing & validation

| # | Finding | Location | Recommendation |
|---|---------|----------|----------------|
| 7.1 | **Backend tests** | `tests/Feature/Api/AuthTest.php` and others. | Run full test suite (e.g. `php artisan test`) in CI; add tests for payment and booking flows when implemented. |
| 7.2 | **Frontend tests** | Vitest and `inputValidation.spec.ts` present. | Add tests for critical composables and services (auth, cart, checkout, bookings); run in CI. |
| 7.3 | **E2E** | No E2E mentioned. | Consider Playwright/Cypress for login, browse, and checkout once payment is implemented. |

---

## 8. Summary of priorities

1. **Immediate (before production):**  
   - Ensure demo accounts disabled in production (1.1).  
   - Fix or remove all `v-html` / receipt HTML escaping (1.3).  
   - Set `APP_DEBUG=false` and secure env (1.4, 5.1).

2. **Short term:**  
   - Implement payment create/status (1.2, 2.1).  
   - Replace or guard `console.*` in production (3.2).  
   - Improve type safety and error handling (3.3, 3.4).

3. **Ongoing:**  
   - Accessibility audit and fixes (4.x).  
   - Replace stub controller with real logic (2.2).  
   - Add tests and E2E (7.x).

---

*This audit was generated from static analysis and code review. Run tests and manual QA before release.*
