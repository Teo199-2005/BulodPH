# BulodPH Security Overview

This document outlines security measures implemented for the BulodPH platform, which handles payments and sensitive user data.

## Authentication & Authorization

### Frontend
- **Bearer token auth**: API requests include `Authorization: Bearer <token>` header
- **Token storage**: Stored in `sessionStorage` (user-scoped). For production hardening, migrate to httpOnly cookies:
  1. Backend: Create `/api/auth/login` that sets `Set-Cookie: token=...; HttpOnly; Secure; SameSite=Strict`
  2. Frontend: Use `credentials: 'include'` on API requests; remove token from client JS
  3. CSRF: Add CSRF token for cookie-based auth (Sanctum SPA mode supports this)
- **401 handling**: Unauthenticated responses clear session and redirect to login
- **Demo accounts**: Disabled in production via `VITE_DEMO_ACCOUNTS_ENABLED=false` (set in `.env.production`)

### Backend (Laravel + Sanctum)
- **Sanctum token auth**: Stateless API tokens for SPA
- **Token expiration**: Configurable via `SANCTUM_TOKEN_EXPIRATION` (default: 7 days)
- **Role-based access**: `EnsureRole` middleware restricts admin, car-owner, and client routes
- **Rate limiting**: Login (5/min), register/forgot-password (10/min), reset-password (5/min)

## CSRF & Request Security

- **Bearer tokens**: Not susceptible to classic CSRF (token in header, not cookie)
- **X-Requested-With**: Header sent on all API requests for request identification
- **CORS**: Restrict `CORS_ALLOWED_ORIGINS` in production to your frontend domain(s)

## Production Checklist

### Environment Variables

**Frontend (`.env.production`):**
```
VITE_API_URL=https://api.yourdomain.com
VITE_DEMO_ACCOUNTS_ENABLED=false
```

**Backend (`.env`):**
```
SANCTUM_TOKEN_EXPIRATION=10080
CORS_ALLOWED_ORIGINS=https://yourdomain.com,https://www.yourdomain.com
APP_ENV=production
APP_DEBUG=false
```

### Backend
- [ ] Set `APP_DEBUG=false`
- [ ] Use HTTPS only
- [ ] Restrict CORS to your frontend origin(s)
- [ ] Ensure demo accounts are not seeded in production (or disable demo login)
- [ ] Configure proper `SESSION_SECURE_COOKIE` if using sessions
- [ ] Set strong `APP_KEY`

### Frontend
- [ ] Build with `VITE_DEMO_ACCOUNTS_ENABLED=false` for production
- [ ] Ensure no secrets in frontend bundle (use env vars)
- [ ] Serve over HTTPS
- [ ] Configure CSP headers (via server/CDN)

### Payments (GCash, Maya)
- **Current**: Manual QR flow; admin confirms receipt. Stub endpoints at `/api/payments/create` and `/api/payments/status/{ref}`.
- **Integration**: See `bulodph-backend/SECURITY_HARDENING.md` for production checklist.
- [ ] Use official SDKs with server-side verification
- [ ] Never store full card/wallet numbers
- [ ] Validate webhooks with signature verification
- [ ] Log payment events for audit trail

## Reporting Security Issues

Report vulnerabilities privately to your security team. Do not disclose in public repos or issue trackers.
