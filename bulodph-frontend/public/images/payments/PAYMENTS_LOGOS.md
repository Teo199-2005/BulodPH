# Payment logos

This folder holds payment and payout method logos used across the app.

## Files

| File            | Used for |
|-----------------|----------|
| `gcash.png`     | GCash – client payments, checkout, payout method, hero |
| `maya.png`      | Maya – client payments, checkout, payout method, hero |
| `visa.png`      | Visa – client payment method (add payment, checkout) |
| `mastercard.png`| Mastercard – client payment method |
| `bpi.png`       | BPI (Bank of the Philippine Islands) – payout method (bank), client payment |
| `gcash.svg`     | GCash in hero trust bar (optional; PNG also used in dashboard) |
| `maya.svg`      | Maya in hero trust bar (optional) |
| `verified-badge.svg` | Verified ID in hero |
| `support-24.svg`| 24/7 Support in hero |

## Where they’re used

- **Client:** `ClientPaymentsView.vue`, `ClientCheckoutView.vue` – saved methods and add payment (GCash, Maya, Visa, Mastercard, BPI).
- **Car owner / Marketing:** `CarOwnerPayoutMethodView.vue`, `MarketingPayoutMethodView.vue` – payout options (GCash, Maya, Bank/BPI).
- **Landing:** Hero trust bar can use `gcash.svg` / `maya.svg` or the PNGs depending on CSS.
- **Constants:** `src/constants/images.ts` – `IMAGES.payments` points to these files.
