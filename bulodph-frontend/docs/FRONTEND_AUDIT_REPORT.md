# HPA+ Frontend Audit Report — Enterprise UI/UX Systems

**Audit Date:** February 2026  
**Scope:** Complete frontend codebase — dashboards, pages, components, layouts  
**Standard:** Enterprise-grade SaaS (Stripe, Linear, Notion, Vercel quality)

---

## Executive Summary

The HPA+ frontend has a **solid foundation** with design tokens, Vuetify theming, and reusable base components. Key gaps: **no explicit spacing scale**, **inconsistent raw v-dialog usage**, **duplicated view patterns**, and **missing layout/container system**. This audit identifies all issues by severity and documents fixes applied.

---

## 1. Spacing Problems — Audit & Fixes

### 1.1 Detected Issues

| Severity | Issue | Location | Status |
|----------|-------|----------|--------|
| **High** | No spacing scale (4/8px grid) | Global | Fixed — tokens added |
| **Medium** | Button groups use 12px gap (not 8px multiple) | style.css `.action-buttons` | Acceptable — kept for comfort |
| **Medium** | Mixed pa-2, pa-3, pa-4, pa-6, pa-8 across views | 50+ files | Documented — standardization via tokens |
| **Low** | Card padding inconsistent (pa-4 vs pa-6) | Various | Standardized via `--card-padding` |

### 1.2 Spacing Scale (Added)

```css
--space-0: 0;
--space-1: 4px;    --space-2: 8px;    --space-3: 12px;   --space-4: 16px;
--space-5: 20px;   --space-6: 24px;   --space-8: 32px;   --space-10: 40px;
--space-12: 48px;  --space-16: 64px;
--page-padding-x: 24px;  --page-padding-y: 24px;
--section-gap: 24px;     --card-padding: 20px;
```

### 1.3 Fixes Applied

- Added `--space-*` tokens for 4px grid
- Added `--page-padding-x`, `--page-padding-y` for main content
- Standardized section spacing via `--section-gap`

---

## 2. Button System — Audit & Fixes

### 2.1 Detected Issues

| Severity | Issue | Status |
|----------|-------|--------|
| **Medium** | VBtn defaults lack explicit height | Fixed — min-height in Vuetify |
| **Low** | Some buttons use `size="small"` vs `size="default"` inconsistently | Documented |
| **Low** | Ghost/outline variants not always consistent | Vuetify handles |

### 2.2 Button System (Existing + Enhanced)

| Variant | Use Case | Color | Height |
|---------|----------|-------|--------|
| **Primary** | Main CTAs | action/primary | 40–44px |
| **Secondary** | Secondary actions | outlined | 40px |
| **Danger** | Destructive | error | 40px |
| **Ghost** | Tertiary | text | 40px |

Vuetify defaults: `elevation: 0`, `rounded: lg`, `font-weight: 600`, `text-transform: none`.  
Global CSS: hover lift, active scale(0.98), focus ring.

### 2.3 Fixes Applied

- VBtn `min-height: 40px` for default size
- Consistent transition and focus-visible handling

---

## 3. Typography System — Audit & Fixes

### 3.1 Current State

| Token | Size | Status |
|-------|------|--------|
| --text-xs | 12px | ✓ |
| --text-sm | 13px | ✓ |
| --text-body | 15px | ✓ |
| --text-body-sm | 14px | ✓ |
| --text-body-lg | 16px | ✓ |
| --text-base | 17px | ✓ |
| --text-md | 18px | ✓ |
| --text-lg | 20px | ✓ |
| --text-xl | 22px | ✓ |
| --text-2xl | 28px | ✓ |

### 3.2 Utilities Added

- `.heading-page`, `.heading-section`, `.heading-card`
- `.label-uppercase`
- `.font-tabular`, `.font-mono`

### 3.3 Gaps

- Some views still use Vuetify classes (`text-h5`, `text-body-2`) instead of tokens — acceptable for now.

---

## 4. Layout & Container System — Audit & Fixes

### 4.1 Detected Issues

| Severity | Issue | Status |
|----------|-------|--------|
| **High** | No global max-width for main content | Fixed |
| **Medium** | Main content padding varies | Fixed via tokens |
| **Medium** | Tables can overflow on small screens | HpaDataTable has responsive handling |
| **Low** | Section spacing inconsistent | Standardized |

### 4.2 Container System (Added)

- `.app-container` — max-width 1280px, centered, responsive padding
- `--page-max-width: 1280px`
- Main content uses `--page-padding-x`, `--page-padding-y`

### 4.3 Responsive Breakpoints

| Breakpoint | Width | Notes |
|------------|-------|-------|
| xs | 0–599px | Mobile |
| sm | 600–959px | Tablet |
| md | 960–1279px | Desktop |
| lg | 1280px+ | Large desktop |

---

## 5. Tables & Forms — Audit & Fixes

### 5.1 Tables (HpaDataTable)

| Item | Status |
|------|--------|
| Row hover | ✓ `--hover-overlay` |
| Header styling | ✓ uppercase, letter-spacing |
| Empty state | ✓ HpaEmptyState |
| Loading | ✓ skeleton |

### 5.2 Forms

| Item | Status |
|------|--------|
| VTextField/VSelect defaults | ✓ outlined, comfortable, action color |
| Focus ring | ✓ 2px primary-cyan |
| Error state | Vuetify handles |
| Label styling | Use `--text-sm`, `font-weight: 500` |

---

## 6. Modal & Dialog System — Audit & Fixes

### 6.1 Components

| Component | Usage | Status |
|-----------|-------|--------|
| **HpaModal** | 7 views | ✓ Unified header, body, footer |
| **HpaConfirmModal** | 14+ views | ✓ Built on HpaModal |
| **Raw v-dialog** | 15+ (ClientDetailsView, DocumentsView, etc.) | **Gap** — should migrate to HpaModal |

### 6.2 HpaModal Specs

- Header: icon + title, close button
- Body: scrollable, consistent padding
- Footer: cancel + confirm
- Shadow: `--shadow-modal`
- Backdrop: blur, scroll lock

---

## 7. Dashboard Consistency — Audit

### 7.1 Implemented

- All dashboards use `DashboardTemplate` + `page-template`
- Card style: `modern-card` with glassmorphism
- Section headers: `section-card-header`, `section-card-icon`, `section-card-title`
- KPI widgets: `HpaDashboardWidget` with role colors

### 7.2 Elevation System

| Level | Token | Use |
|-------|-------|-----|
| 0 | — | Flat |
| 1 | --shadow-sm | Cards at rest |
| 2 | --shadow-md | Hover, dropdowns |
| 3 | --shadow-lg | Skip link, raised |
| 4 | --shadow-modal | Dialogs |

---

## 8. Responsive Audit

### 8.1 Breakpoints Tested

- **320px**: Min-width on body; sidebar collapses to drawer
- **375px**: Mobile layout active
- **768px**: Tablet; some 2-col layouts
- **1024px**: Desktop; sidebar permanent
- **1280px+**: Max container width

### 8.2 Fixes

- `min-width: 320px` on body
- Main content overflow-x handled
- Tables: v-data-table has built-in horizontal scroll

---

## 9. Accessibility — Audit & Fixes

### 9.1 Implemented

- Skip link to `#main-content`
- `aria-current="page"` on active nav
- Focus-visible rings (2px primary-cyan)
- `role="main"`, `tabindex="-1"` on v-main
- HpaEmptyState: 44px min tap target
- ToastContainer: aria-live, role="alert"

### 9.2 Gaps

- Some form fields may lack explicit `<label>` — audit forms
- Modal focus trap delegated to Vuetify

---

## 10. Design System Summary

### Tokens Added

- **Spacing**: `--space-0` to `--space-16`, `--page-padding-x/y`, `--section-gap`, `--card-padding`
- **Transitions**: `--transition-fast`, `--transition-base`, `--transition-slow`
- **Layout**: `--page-max-width`

### Component Refactors

- None required — existing HpaModal, HpaDataTable, HpaDashboardWidget, HpaEmptyState are solid
- Recommendation: Migrate raw v-dialogs to HpaModal for consistency

### Performance

- No significant performance issues identified
- Vuetify tree-shaking in place

---

## 11. Before vs After

| Area | Before | After |
|------|--------|-------|
| Spacing | Ad hoc pa-* values | 4px grid tokens |
| Buttons | Implicit heights | 40px min-height |
| Containers | No max-width | 1280px centered |
| Typography | Mixed | Scale + utilities |
| Modals | Mixed raw + HpaModal | HpaModal preferred |
| Tables | Basic | Hover overlay, header style |
| Focus | Good | Unchanged (already good) |

---

## 12. Recommendations

1. **Migrate raw v-dialogs** to HpaModal (ClientDetailsView, DocumentsView, etc.)
2. **Extract shared PayoutMethodView** from CarOwner + Marketing
3. **Extract shared HelpView** structure
4. **Add `aria-label`** to icon-only buttons where missing
5. **Consider** Tailwind or utility-first for consistency (optional, large effort)

---

## 13. Complete Fix List Applied

### Design Tokens (style.css)
- [x] Added `--space-0` through `--space-16` (4px grid)
- [x] Added `--page-padding-x`, `--page-padding-y`, `--section-gap`, `--card-padding`
- [x] Added `--page-max-width: 1280px`
- [x] Added `--transition-fast`, `--transition-base`, `--transition-slow`

### Layout (MobileLayout.vue)
- [x] Wrapped router-view in `.app-container` for max-width + centering
- [x] Main content padding uses design tokens

### Button System (vuetify.ts)
- [x] VBtn default `min-height: 40px`

### Tables (HpaDataTable.vue)
- [x] Table wrapper `overflow-x: auto` for mobile scroll
- [x] `min-width: 480px` on v-table for horizontal scroll

### Modals (style.css)
- [x] Raw v-dialog cards receive `--shadow-modal` for consistency

### Accessibility
- [x] `overflow-x: hidden` on html/body
- [x] `@media (prefers-reduced-motion: reduce)` support

### Documentation
- [x] Created `docs/FRONTEND_AUDIT_REPORT.md`
- [x] Created `docs/DESIGN_SYSTEM.md`

---

## 14. Continuation Fixes (Phase 2)

### Shared PayoutMethodView
- [x] Created `HpaPayoutMethodView.vue` — shared component for Car Owner + Marketing payout method
- [x] Refactored `CarOwnerPayoutMethodView` and `MarketingPayoutMethodView` to use shared component
- [x] Props: `backTo`, `storageKey` (optional, for localStorage persistence)

### Raw v-dialog → HpaModal Migration (ClientDetailsView)
- [x] Add Client Report dialog
- [x] Add Medical Document dialog
- [x] Add Service Agreement dialog
- [x] Add Progress Note dialog
- [x] View Progress Note dialog
- [x] Add Incident Report dialog
- [x] View Incident Report dialog

### Accessibility
- [x] `aria-label` on HpaModal close button
- [x] `aria-label` on icon-only buttons: ClientDetailsView, InvoicesView, DocumentsView, EmployeeFileList, StaffDetailsView

---

## 15. Continuation Phase 3 (v-dialog → HpaModal)

### DocumentsView
- [x] Add Policy, Add Compliance, Form Builder, Add Document with expiry dialogs
- [x] aria-label on edit/delete form, bell toggle, remove field

### StaffDetailsView
- [x] Add Performance Note, Add Document dialogs

### InvoicesView
- [x] Add Invoice dialog

### AdminDashboardPromosView
- [x] Add/Edit promo dialog (with confirmDisabled)

### HpaModal
- [x] Added `confirmDisabled` prop

---

## 16. Continuation Phase 4

### AdminVehiclesView
- [x] Vehicle detail dialog migrated to HpaModal (custom actions slot)
- [x] aria-label on image gallery thumbnails

### Remaining raw v-dialogs (kept)
- **RegisterView** — Role selection with custom 3-column layout
- **PlatformAgreementModal** — Dedicated component

---

## 17. Continuation Phase 5

### Shared HpaHelpView
- [x] Created `HpaHelpView.vue` — shared Help/FAQ layout
- [x] Refactored ClientHelpView and CarOwnerHelpView to use it

### Additional aria-labels
- [x] ClientBrowseView, ClientFavoritesView — favorites
- [x] ClientPaymentsView, ClientCartView — remove actions
- [x] CarOwnerCalendarView — nav, clear
- [x] AdminVehiclesView, AdminBookingsView — profile
- [x] MarketingStaffView — Edit, Delete

---

*Report generated as part of enterprise frontend audit. All fixes applied are documented in git history.*
