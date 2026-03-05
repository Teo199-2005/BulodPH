# BulodPH – Publish readiness checklist

Use this before going live. **Payment is not integrated yet**; everything below assumes you are publishing with payment as “coming soon” or manual.

---

## ✅ Already in good shape

- **404 page**: Unknown routes show `NotFoundView` (Page not found + Go home / Go back).
- **Auth**: Login, register, forgot/reset password; role-based redirects; car-owner agreement flow.
- **SEO**: Route meta (title, description), index.html meta/OG, robots index follow, canonical, JSON-LD.
- **Legal**: `/privacy`, `/terms`, `/accessibility`; platform disclaimer in footer.
- **API config**: Frontend uses `VITE_API_URL`; backend CORS uses `FRONTEND_URL` / `CORS_ALLOWED_ORIGINS`.
- **Debug telemetry**: Footer/layout debug ingest only runs in dev (`import.meta.env.DEV`); production build does not call it.
- **Payment console**: `console.debug` in payment QR service only in `import.meta.env.DEV`.

---

## 🔧 Before you publish – do these

### Frontend (bulodph-frontend)

| Item | Action |
|------|--------|
| **Demo accounts** | In production `.env`: set `VITE_DEMO_ACCOUNTS_ENABLED=false` so login does not show demo account chips. |
| **API URL** | Set `VITE_API_URL` to your production API (e.g. `https://api.bulodph.com/api` or same-origin `/api` if proxied). |
| **App version** | Optional: set `VITE_APP_VERSION=1.0.0` (or current) for footer. |
| **Google Maps** | If you use registration location / map: set `VITE_GOOGLE_MAPS_API_KEY` and optionally `VITE_GOOGLE_MAPS_EMBED_KEY`. |

### Backend (bulodph-backend)

| Item | Action |
|------|--------|
| **Environment** | `APP_ENV=production`, `APP_DEBUG=false`. |
| **URLs** | `APP_URL` and `FRONTEND_URL` to production domains. |
| **CORS** | Set `CORS_ALLOWED_ORIGINS` to your frontend origin(s), e.g. `https://bulodph.com`. |
| **Sanctum** | `SANCTUM_STATEFUL_DOMAINS` must include production frontend domain. |
| **Database** | Use production DB credentials; run migrations. |
| **Mail** | Set `MAIL_*` and `MAIL_FROM_ADDRESS` to a real domain (not `hello@example.com`) if you use verification/reset. |
| **Payment** | `PAYMENT_GATEWAY_ENABLED=false` until gateway is integrated (already in `.env.example`). |

See also **bulodph-backend/SECURITY_HARDENING.md** for full production checklist (token storage, CSP, etc.).

---

## 📄 Content and assets

- **Favicon**: `index.html` uses `/vite.svg`; replace with your favicon if desired.
- **OG image**: Meta points to `/og-image.png`; ensure this exists in `public/` for social previews.
- **Canonical / OG URL**: `index.html` has `https://bulodph.com/`; change if your domain is different.
- **CSP**: `index.html` CSP is dev-friendly. For production, prefer server-sent CSP (e.g. backend SecurityHeaders) with stricter rules.

---

## 🚫 Payment (excluded from “100% ready”)

- Payment flow (Pay via QR, GCash/Maya) is **not integrated** with a real gateway.
- Ensure users understand payments are manual / “coming soon” (e.g. copy on Payments page or Terms).
- When you integrate: set `PAYMENT_GATEWAY_ENABLED=true`, wire webhooks, and follow SECURITY_HARDENING.md payment section.

---

## Quick verification

1. **Build**: `npm run build` in frontend; no errors.
2. **Env**: Production `.env` has no `localhost` or `127.0.0.1` for API/CORS (except optional local fallbacks).
3. **Demo accounts**: With `VITE_DEMO_ACCOUNTS_ENABLED=false`, login has no demo chips.
4. **404**: Open a non-existent path (e.g. `/foo-bar-404`); 404 page appears.
5. **Roles**: Client, car owner, admin, marketing flows load and redirect correctly after login.

Once the items above are done (and payment clearly marked as not yet integrated), you are in good shape to publish.
