# BulodPH – Deployment Checklist

Use this when deploying backend and frontend to production.

---

## Before deploy

- [ ] **Environment**
  - `APP_ENV=production`
  - `APP_DEBUG=false` (never enable in production)
  - `APP_URL` = your backend URL (e.g. `https://api.bulodph.com`)
  - `FRONTEND_URL` = your frontend URL (e.g. `https://bulodph.com`)
  - Strong `APP_KEY` (from `php artisan key:generate`)

- [ ] **Database**
  - `DB_DATABASE`, `DB_USERNAME`, `DB_PASSWORD` for production MySQL
  - Run migrations: `php artisan migrate --force`

- [ ] **CORS**
  - Set `CORS_ALLOWED_ORIGINS` to your frontend origin(s), e.g. `https://bulodph.com`

- [ ] **Auth / sessions**
  - `SESSION_SECURE_COOKIE=true` if using HTTPS
  - `SANCTUM_STATEFUL_DOMAINS` to include your frontend domain if using cookie-based SPA auth

- [ ] **Payments**
  - Leave `PAYMENT_GATEWAY_ENABLED=false` until GCash/Maya (or other gateway) is wired in `PaymentController`

---

## Backend (Laravel)

- **Options:** Laravel Forge, Envoyer, AWS (EC2 + RDS), DigitalOcean App Platform, VPS + Nginx/PHP-FPM.
- **Requirements:** PHP 8.2+, MySQL 8+, Composer.
- **Steps (typical):**
  1. Clone repo, `cd bulodph-backend`, `composer install --no-dev --optimize-autoloader`
  2. Copy `.env.example` to `.env`, fill production values
  3. `php artisan key:generate`
  4. `php artisan migrate --force`
  5. `php artisan config:cache` and `php artisan route:cache`
  6. Point document root to `bulodph-backend/public` (or use `php artisan serve` only for dev)
- **Health:** Expose `GET /up` for load balancer / monitoring.

---

## Frontend (Vue / Vite)

- **Options:** Vercel, Netlify, Cloudflare Pages, or same server as backend (static build).
- **Build:** From repo root, `cd bulodph-frontend`, set `VITE_API_URL` to your API base (e.g. `https://api.bulodph.com/api`), then `npm ci && npm run build`.
- **Output:** `bulodph-frontend/dist`. Serve as static files; ensure SPA fallback (all routes → `index.html`) for client-side routing.

---

## CI/CD (GitHub Actions)

- Workflow in `.github/workflows/ci.yml` runs backend and frontend tests on push/PR.
- Paths use `bulodph-backend` and `bulodph-frontend`.
- The deploy job is a placeholder: add your own steps (e.g. deploy to Forge, Vercel) after tests pass.

---

## Security reminders

- Never set `APP_DEBUG=true` in production.
- Debug route has been removed from the API; no DB info leak.
- Use HTTPS; set HSTS and secure cookies in production.
- See `bulodph-backend/SECURITY_HARDENING.md` and `bulodph-frontend/SECURITY.md` for details.
