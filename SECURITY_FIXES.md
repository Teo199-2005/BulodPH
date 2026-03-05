# Security vulnerability fixes (March 2026)

This document summarizes vulnerabilities that were identified and fixed in the BulodPH codebase to reduce risk of hacking and abuse.

---

## SQL injection audit (summary)

- **Laravel query builder / Eloquent:** All `where('column', $value)` usages use bound parameters; user and route input is never concatenated into SQL. **Safe.**
- **LIKE clauses:** Previously used request `search` in `LIKE '%...%'` without escaping. **Fixed** with `sanitizeSearchLike()` (length limit + escape of `\`, `%`, `_`) in AdminClientController, AdminCarOwnerController, AdminMarketingStaffController, ClientController.
- **Raw SQL:** Only `selectRaw('user_id, count(*) as cnt')` (fixed string, no user input) and migrations (fixed strings). **Safe.**
- **Route/request IDs:** All `where('id', $id)` etc. bind `$id`; no concatenation. **Safe.** Defense-in-depth: reject route `id` (and similar) longer than 64 characters in AdminClientController, VehicleController, CarRentalProfileController (showPublic, streamLogo), CartController, RentalBookingController so obviously malformed IDs are rejected early.

---

## Fixes applied

### 1. **Search / LIKE wildcard injection (backend)**

**Risk:** Admin and client list endpoints used user-controlled `search` in SQL `LIKE` clauses without sanitization. An attacker could pass `%` or `_` to match many rows (performance/DoS) or use long strings.

**Fix:**
- **AdminClientController**, **AdminCarOwnerController**, **AdminMarketingStaffController**, **ClientController**: Added `sanitizeSearchLike()` that:
  - Trims and limits search to 100 characters.
  - Escapes SQL LIKE wildcards `\`, `%`, `_` so they are treated as literals.
- Search is now safe for use in `LIKE '%...%'` without wildcard abuse.

**Files:**  
`bulodph-backend/app/Http/Controllers/Api/AdminClientController.php`,  
`AdminCarOwnerController.php`, `AdminMarketingStaffController.php`, `ClientController.php`

---

### 2. **Privilege escalation: vehicle approved/featured (backend)**

**Risk:** Any authenticated user (including car_owner) could send `approved: true` or `featured: true` in vehicle create/update and get their listing approved or featured without admin action.

**Fix:**
- **VehicleController** `requestToAttributes()`: `approved` and `featured` are now set from request **only when the current user has the `admin` role**. For non-admins they are forced to `false`.

**File:** `bulodph-backend/app/Http/Controllers/Api/VehicleController.php`

---

### 3. **XSS in search highlight (frontend)**

**Risk:** `HpaSearchHighlight` uses `v-html` with the result of `highlightSearch(text, search)`. The source `text` was not escaped, so if it contained HTML/script (e.g. from API or user content), it could execute in the page.

**Fix:**
- **searchHighlight.ts**: Added `escapeHtml()` and use it on the source text before applying the highlight. The highlighted result is safe for `v-html`.

**File:** `bulodph-frontend/src/utils/searchHighlight.ts`

---

### 4. **XSS in receipt HTML (frontend)**

**Risk:** In **ClientBookingDetailView**, the fallback receipt builds an HTML string from booking data (`b.id`, `b.vehicleName`, etc.) and passes it to `document.write()`. If the API ever returned malicious content in those fields, it could run as script.

**Fix:**
- Added `escapeReceiptHtml()` and used it for every dynamic value inserted into the receipt HTML string (booking id, vehicle name, dates, location, host, total, status, timestamp).

**File:** `bulodph-frontend/src/views/client/ClientBookingDetailView.vue`

---

## Already in good shape (verified)

- **SQL injection:** No raw SQL with user input; Laravel query builder uses bindings. The LIKE clauses now also have wildcards escaped.
- **Auth:** Admin/client/car-owner routes protected by `auth:sanctum` and role middleware. Controllers scope by `organization_id` or `user_id` where expected.
- **Password reset:** Token is hashed in DB, compared with `Hash::check`, 60-minute expiry.
- **Vehicle access:** `VehicleController` uses `canModifyVehicle()` so only owner or admin can update/delete; `show` hides hidden vehicles from non-owners.
- **Security headers:** Backend `SecurityHeaders` middleware sets CSP, X-Frame-Options, HSTS, etc. in production.

---

## Recommendations (optional)

1. **NDIS / Shifts / ClientController (legacy):**  
   `NDISPlanController::index` and `ShiftController::index` filter by `client_id` / `worker_id` from the request. If these routes are reachable by non-admin users, consider scoping to the current user’s organization or role so one tenant cannot list another’s data.

2. **Token storage:**  
   For production, consider moving from `sessionStorage` to httpOnly cookies and Sanctum SPA authentication to reduce XSS impact on token theft (see frontend `SECURITY.md`).

3. **Rate limiting:**  
   Sensitive admin or listing endpoints could use stricter throttle values if you see abuse.

4. **Content Security Policy:**  
   Frontend `index.html` has a dev-friendly CSP; production should rely on server-sent headers (backend or CDN) as in `SECURITY_HARDENING.md`.

---

*If you discover new issues, fix them and document here or in SECURITY_HARDENING.md / SECURITY.md.*
