# Public Pages Refactor Checklist

Completed refactor to use `PublicLayout`, `BulodSection`, and `BulodMetallicCard` across public-facing views.

## Completed tasks

- [x] **1. LandingPage.vue** – Stripped of hardcoded navbar/footer; wrapped in `PublicLayout`.
- [x] **2. LandingPage.vue** – `PublicLayout`, `BulodSection`, and `BulodMetallicCard` imported and used.
- [x] **3. BulodSection in AboutUs & LandingPage** – `BulodSection` (and `BulodMetallicCard` where needed) registered and used in both.
- [x] **4. AboutUsView.vue** – Hardcoded `section-light` / `container-metallic` replaced with `BulodSection` and `BulodMetallicCard`.
- [x] **5. PublicFleetView.vue** – `BulodSection` registered and used.
- [x] **6. Contact Us & FAQ** – `ContactUsView.vue` and `FaqView.vue` use `PublicLayout`, `BulodSection`, and `BulodMetallicCard`.
- [x] **7–8. FAQ and Blog** – FAQ and Blog views refactored to use shared components.
- [x] **9. Blog page** – Blog index uses `BulodSection`; featured post block uses `BulodMetallicCard` instead of `container-metallic`.
- [x] **10. BlogIndexView & verification** – `BulodSection` and `BulodMetallicCard` applied; final pass done.

## Summary

| View / File           | PublicLayout | BulodSection | BulodMetallicCard |
|-----------------------|-------------|-------------|-------------------|
| LandingPage.vue       | ✓           | ✓           | ✓                 |
| AboutUsView.vue       | ✓           | ✓           | ✓                 |
| PublicFleetView.vue   | ✓           | ✓           | —                 |
| ContactUsView.vue     | ✓           | ✓           | ✓                 |
| FaqView.vue           | ✓           | ✓           | ✓                 |
| BlogIndexView.vue     | ✓           | ✓           | ✓                 |

Landing page sections now using `BulodSection` + `BulodMetallicCard`: About, Receipt of Truth, Explore, Stats bar, Featured Rides.
