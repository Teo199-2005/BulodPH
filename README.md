# BulodPH – Car Rental Marketplace

Car rental marketplace for the Philippines. Browse and book from local rental partners; secure payments via GCash and Maya (gateway integration ready).

---

## Project overview

**Product:** BulodPH – Car rental marketplace (Philippines)  
**Stack:**
- **Backend:** Laravel 11, PHP 8.2, MySQL 8
- **Frontend:** Vue 3, TypeScript, Vite 7, Vuetify 3
- **Auth:** Laravel Sanctum (API tokens)
- **State:** Pinia + TanStack Vue Query
- **Tests:** Pest (backend), Vitest (frontend)

**Roles:** Client (renter), Car owner, Marketing partner, Admin.

---

## Repository layout

```
BulodPH/
├── bulodph-backend/     # Laravel API
├── bulodph-frontend/    # Vue 3 SPA
├── .github/workflows/   # CI (backend + frontend tests, deploy placeholder)
└── docs/                # Deployment and legacy notes (see DEPLOYMENT.md, LEGACY.md)
```

Use the folder names above for all commands and CI.

---

## Getting started

### Prerequisites

- PHP 8.2+, Composer
- Node.js 20+, npm
- MySQL 8+

### Backend

```bash
cd bulodph-backend
composer install
cp .env.example .env
# Set DB_DATABASE, DB_USERNAME, DB_PASSWORD in .env
php artisan key:generate
php artisan migrate
php artisan serve
```

API: **http://localhost:8000**

### Frontend

```bash
cd bulodph-frontend
npm install
npm run dev
```

App: **http://localhost:5173** (Vite proxies `/api` to backend).

### Health

- Backend: `GET http://localhost:8000/up`
- API info: `GET http://localhost:8000/` (JSON)

---

## Testing

```bash
# Backend
cd bulodph-backend
./vendor/bin/pest

# Frontend
cd bulodph-frontend
npm run test:run
npm run type-check
npm run build
```

CI runs these in `.github/workflows/ci.yml` (paths: `bulodph-backend`, `bulodph-frontend`).

---

## Security and production

- **Auth:** Sanctum token; rate-limited login/register/forgot-password. Production: consider httpOnly cookie SPA auth (see backend `SECURITY_HARDENING.md`).
- **Env:** Set `APP_ENV=production`, `APP_DEBUG=false`. Never enable debug in production.
- **CORS:** Set `CORS_ALLOWED_ORIGINS` to your frontend origin(s).
- **Payments:** Payment endpoints return 503 until a gateway (e.g. GCash/Maya) is wired; see `PAYMENT_GATEWAY_ENABLED` in `.env.example` and `App\Http\Controllers\Api\PaymentController`.

See `bulodph-backend/SECURITY_HARDENING.md` and `bulodph-frontend/SECURITY.md` for details.

---

## Payments (GCash / Maya)

Payment API is implemented with validation and logging. Until a provider is integrated, the app returns **503 Payment Unavailable**. Configure `PAYMENT_GATEWAY_ENABLED=true` only when the gateway is wired in `PaymentController`.

---

## Documentation

- **Deployment:** [docs/DEPLOYMENT.md](docs/DEPLOYMENT.md) – checklist and options.
- **GitHub + Hostinger:** [docs/GITHUB_AND_HOSTINGER.md](docs/GITHUB_AND_HOSTINGER.md) – push to [GitHub](https://github.com/Teo199-2005/BulodPH) and deploy to Hostinger.
- **Legacy / NDIS:** [docs/LEGACY.md](docs/LEGACY.md) – shifts, NDIS plans, and HPA-origin code.

---

## License

Proprietary – BulodPH.
