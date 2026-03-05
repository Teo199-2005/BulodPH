# BulodPH Frontend – Testing

This project uses **Vitest** and **Vue Test Utils** for unit and integration-style tests.

## Commands

| Command | Description |
|--------|-------------|
| `npm run test` | Run tests in watch mode |
| `npm run test:run` | Run all tests once (CI-friendly) |
| `npm run test:coverage` | Run tests with coverage report |

## What’s covered

### Stores (Pinia)
- **userSession** – Auth (setAuth, clearAuth, updateUser), roles, **avatar persistence** (localStorage restore on login, no clear on logout)
- **agreementAcceptance** – Per-user car owner / client agreement acceptance and persistence
- **locale** – Default locale, read/write from localStorage
- **dashboardPromos** – Seed load, getByRole, add, update, remove

### Utils
- **inputFormatters** – `letters`, `lettersStrict`, `numbers`, `alphanumericSpaces`, `phone`, `idNumber`, `cardExpiry`
- **inputValidation** – `sanitizeBasicText`, `hasInjectionRisk`, `isSafeText`, `toFileArray`, `validateFiles`
- **userScopedStorage** – get/set/remove keyed by user id; guest key when not logged in; isolation between users

### Composables
- **useAuth** – `getPrimaryRole`, `getDashboardRouteForRole` (no API)
- **usePasswordValidation** – strength, rules (length, uppercase, digit, special), empty handling

### Constants
- **siteUrls** – ROUTES (login, register, etc.), SITE_URLS, CONTACT

## Setup

Tests use `src/test/setup.ts` (e.g. `$t` mock). Each store test that uses `localStorage` or `sessionStorage` should call `localStorage.clear()` and `sessionStorage.clear()` in `beforeEach`, and use `setActivePinia(createPinia())` so state is isolated.

## Adding tests

1. Place spec files next to the module: `foo.ts` → `foo.spec.ts` (or `__tests__/foo.spec.ts`).
2. For stores that depend on `useUserSessionStore`, set auth in the test with `userSession.setAuth(...)` so user-scoped keys use the correct id.
3. Mock the API in `@/lib/api` when testing composables that call it (e.g. `vi.mock('@/lib/api')`).

## Coverage

Run `npm run test:coverage`. Ensure `vitest` is configured with a `coverage` provider (e.g. `v8` or `istanbul`) in `vitest.config.ts` if you need coverage output.
