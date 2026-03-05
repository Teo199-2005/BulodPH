# BulodPH Frontend – Button & Action Audit Report

**Audit focus:** Buttons and links that don’t work, only show a toast, or don’t persist (client-only state).

**Date:** 2026-02-25

---

## Summary

| Category | Count | Status |
|----------|--------|--------|
| Buttons that only show toast (no real action) | 4 | Fixed or documented |
| Actions that only update local state (no API) | 5 | Toasts added; API wiring recommended |
| View/Preview/Edit with no UI | 3 | Fixed where possible |
| Links/routes | — | Verified; no broken routes found |

---

## 1. Buttons that only showed a toast (fixed)

### AdminEmailTemplatesView
- **Edit** – Previously: `toast.info('Edit template: …')`. **Fix:** Preview dialog added; Edit still shows toast with “Edit form coming soon” until backend/API exists.
- **Preview** – Previously: `toast.info('Preview: …')`. **Fix:** Opens a preview dialog showing template name, trigger, subject, and placeholder body.

### AdminInsurancePlansView
- **Add plan** – Previously: `toast.info('Open add plan dialog')` with no dialog. **Fix:** “Add plan” dialog added (name, type, price, coverage); new plan is appended to the list.
- **Edit plan** – Still shows toast; full edit form can be added later (same as Add plan dialog in edit mode).

### ReportsView
- **View** (Report Templates) – Previously: `toast.info('View: … Connect to report API for full view.')`. **Fix:** “View” opens a dialog that shows the report summary (same data as export) with a “Download CSV” button so the action is useful.

---

## 2. Actions that only update local state (no API)

These buttons **do** change the UI (e.g. status chip) but do **not** call an API, so changes are lost on refresh. User feedback toasts were added so it’s clear the action ran.

| View | Buttons | Behavior | Recommendation |
|------|--------|----------|----------------|
| **AdminReviewModerationView** | Approve, Reject | Set `item.status` locally | Wire to reviews API when available; toast added. |
| **AdminAffiliateApplicationsView** | Approve, Reject | Set `item.status` locally | Wire to affiliate API; toast added. |
| **AdminFraudRiskView** | Clear, Block | Set `item.risk` locally | Wire to risk API; toast added. |
| **AdminDisputesView** | Investigate, Resolve | Set `item.status` locally | Wire to disputes API; toast added. |
| **AdminWebhookLogsView** | Retry | Toast + set status to Pending | Wire to webhook retry API when available. |

---

## 3. Other buttons verified

- **AdminListingsView** – View (→ client-vehicle-detail), Approve, Toggle featured, Reset filters: handlers exist; View uses correct route.
- **AdminBookingsView** – Export PDF, filters, archive, View (→ admin-booking-detail): working.
- **AdminPayoutsView** – Approve & pay, Reject: handlers call API/actions as implemented.
- **AdminVehiclesView** – Add, View, Edit, Delete, View on browse: dialogs and navigation work.
- **DashboardView** – Promo cards use `promo.linkUrl` (external `http` or internal `router-link`); correct.
- **Client / Car owner / Marketing** – Navigation and `:to` routes match `router/index.ts` (client-browse, client-vehicle-detail, car-owner-bookings, etc.).
- **ReportsView** – “View dashboard” links to `/admin`; Export All and per-card Export call `exportReport` / `exportAllReports`; Download on templates and recent reports calls `downloadReport`. Share button on recent reports has no handler (tooltip only); can be wired later.

---

## 4. Recommendations

1. **Backend APIs:** When review, affiliate, fraud, dispute, and webhook-retry APIs exist, replace local-only state updates with API calls and refetch or optimistic updates.
2. **Email templates:** Add a real “Edit template” form or route (e.g. same dialog as preview with editable fields and save API).
3. **Insurance plans:** Wire Add/Edit plan to backend; optionally add delete and toggle API.
4. **Reports:** “Share” on recent reports is not implemented; add share action (e.g. copy link, email) when needed.

---

## 5. Files changed in this audit

- `src/views/admin/AdminEmailTemplatesView.vue` – Preview dialog; Edit toast clarified.
- `src/views/admin/AdminInsurancePlansView.vue` – Add plan dialog.
- `src/views/admin/AdminReviewModerationView.vue` – Toasts on Approve/Reject.
- `src/views/admin/AdminAffiliateApplicationsView.vue` – Toasts on Approve/Reject.
- `src/views/admin/AdminFraudRiskView.vue` – Toasts on Clear/Block.
- `src/views/admin/AdminDisputesView.vue` – Toasts on Investigate/Resolve.
- `src/views/ReportsView.vue` – View report dialog with summary + Download CSV.
