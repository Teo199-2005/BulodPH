# BulodPH Security Hardening

## Implemented

- **No debug route**: The API does not expose `/api/debug/db` or any debug endpoint; no DB info leak in production.
- **Rate limiting**: Login 5/min, register 10/min, reset 5/min
- **Security headers** (production): CSP, HSTS, X-Frame-Options, Referrer-Policy, X-Content-Type-Options, Permissions-Policy
- **Sanctum**: Bearer token auth, 7-day expiration
- **Input validation**: Laravel validation on all controller inputs
- **Authorization**: Role middleware (admin, car_owner, client, marketing_staff); organization scoping on admin endpoints
- **Password**: Bcrypt via `password` cast; `Hash::check()` on login
- **SQL injection**: Eloquent ORM; `whereJsonContains` uses bound parameters; no raw user input in queries
- **CORS**: Configurable via `CORS_ALLOWED_ORIGINS`

## Production Checklist

### Environment
- [ ] `APP_DEBUG=false`
- [ ] `APP_ENV=production`
- [ ] Strong `APP_KEY`
- [ ] `CORS_ALLOWED_ORIGINS` restricted to frontend domain(s)

### Auth
- [ ] `SANCTUM_STATEFUL_DOMAINS` set to production frontend
- [ ] Consider shorter token expiration (e.g. 1 day) for sensitive roles

### Token Storage (httpOnly)
For XSS resistance, migrate from sessionStorage to httpOnly cookies:
1. Backend: Set `Set-Cookie: token=...; HttpOnly; Secure; SameSite=Strict`
2. Frontend: Use `credentials: 'include'` on API requests
3. Ensure CSRF token for cookie-based auth (Sanctum SPA mode)

### Payment Gateway
- [ ] Integrate real GCash/Maya APIs
- [ ] Webhook signature verification
- [ ] Never log full card/wallet numbers
- [ ] Audit logging for payment events

### CSP
- [ ] Remove `'unsafe-inline'` / `'unsafe-eval'` in production; use nonces or hashes
- [ ] Vite can inject nonces in production build; configure accordingly
