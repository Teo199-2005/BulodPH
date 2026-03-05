# Legacy and optional modules (BulodPH)

This document explains code that exists for historical or optional use.

---

## Shifts, NDIS plans, and “clients” (HPA origin)

The codebase includes:

- **API routes:** `/api/shifts`, `/api/clients`, `/api/ndis-plans` (and related actions like clock-in/clock-out, budget summary).
- **Backend:** `ShiftController`, `ClientController`, `NDISPlanController`, models (Shift, Client, NDISPlan, etc.), migrations.

These come from an earlier product (HPA Plus / NDIS healthcare). BulodPH is a **car rental marketplace**; the primary flows are:

- **Clients** = renters (car rental clients).
- **Car owners**, **bookings**, **vehicles**, **payouts**, **reviews**, **disputes**, etc.

The shift/NDIS/client (NDIS participant) modules are **not required** for BulodPH. Options:

1. **Leave as-is** – Routes remain available for potential future use or a separate product; no impact on car rental flows if unused.
2. **Remove later** – If you are sure they will never be used, you can remove the routes, controllers, and migrations in a separate cleanup (ensure no references in frontend or other services).

No action is required for normal BulodPH development; this note is for maintainers and auditors.

---

## Organization and ABN

Registration uses a default organization (e.g. `Organization::firstOrCreate(['abn' => '11111111111'], ...)`). This is intentional for a single-tenant or single-brand setup. For multi-tenant with real ABNs per org, replace with proper organization creation and pass the correct ABN from registration or admin.
