# Complete Makeover + DRY Templates Prompt

Use this prompt to drive a **full UI makeover** and a **template-based (DRY) system** for modals, toasts, confirmations, footer, and shared UI. The goal: **one place to change styling so all usages update everywhere**—no hunting through files. Apply DRY to anything that repeats.

---

## 1. Scope of the Makeover

Do a **complete visual makeover** of:

- **Modals** – All dialogs (add/edit forms, confirmations, detail popups) must use a single templated modal component. Same look, same animations, same behavior everywhere.
- **Pages** – All dashboard and app pages: consistent layout, spacing, and card treatment via the existing `DashboardTemplate` (or equivalent). No page-specific header/card styles; everything comes from shared templates and global styles.
- **Widgets** – KPI/stat cards, chart cards, list cards. One stat-card template (e.g. `HpaDashboardWidget`), one card-container style. All widgets use these; no inline or per-page widget styling.
- **Stat cards** – Single template component for “stat block” (label, value, icon, optional trend). Used on Dashboard, Clients, Staff, Reports, etc. Styling lives only in that component (and optional global overrides in one file).
- **Top bar** – One layout component owns the app bar (e.g. in `MobileLayout`). All styling for the bar (colors, spacing, user card, actions) lives there. No red; use the app’s blue/sky palette. Solid background, no dots.

**Design direction:** Modern, clean, consistent. Use the app’s existing color tokens (e.g. sky blue primary). Only the **footer** is explicitly **minimalist** (see below).

---

## 2. Minimalist Footer (Watermark + Version)

Add a **single, app-wide footer** that is the **only** deliberately minimalist element:

- **Placement:** Fixed or sticky at the bottom of the main content area (or at the bottom of the viewport below the main scroll). It must appear on **all** authenticated dashboard/app pages—so it belongs in the main layout (e.g. `MobileLayout.vue`), not in individual views.
- **Content:**
  - **Watermark:** e.g. “HPA Plus” or product name, subtle (light gray, small font).
  - **Version:** e.g. “v1.0.0” or from `package.json` / env. Keep it minimal.
- **Style:** Minimalist only here—very low visual weight: small text, muted color, no icons or heavy borders. One line or two is enough. Do not use this minimalist style for the rest of the app (modals, toasts, top bar stay fully styled).
- **Implementation:** One footer component (e.g. `AppFooter.vue`) used once in the layout. Version can be injected from env or a small constant in one place.

---

## 3. Templated Modals, Confirmations, and Toasts (DRY + Animations)

All modals, confirmation dialogs, and toast notifications must be **templated** and **animated** so that:

- Changing the template **once** updates **every** modal, confirmation, and toast across the app.
- No page or view should implement its own modal/toast markup or animations; they all use the shared components.

### 3.1 Modal Template

- **Single modal component** (e.g. refactor/use `HpaModal.vue`):
  - Props: `modelValue`, `title`, `icon?`, `maxWidth?`, `persistent?`, `loading?`, `confirmText?`, `cancelText?`, `showActions?`, and optionally `variant` (e.g. default / danger / success) for button/header color.
  - Slots: default (body), optional `actions` for custom buttons.
  - **Animations:** Use Vue transitions or CSS (e.g. scale + fade, or slide-up). Same transition name used everywhere so one change in the component updates all modals.
- **Usage:** Every dialog in the app (Clients add/edit, Shifts create, confirmations, etc.) must use **only** this component. No raw `v-dialog` or custom modal markup in views. Pass content via slots; styling comes from the template and one shared SCSS/CSS block (or design tokens).

### 3.2 Confirmation Modal Template

- **Single confirmation component** (can be a thin wrapper around the modal template or a dedicated `HpaConfirmModal.vue`):
  - Props: `modelValue`, `title`, `message`, `confirmText`, `cancelText`, `variant?` (e.g. danger for delete), `loading?`.
  - Emits: `confirm`, `cancel` / `update:modelValue`.
  - **Same animations** as the main modal template. Same card style, same button style.
- **Usage:** All “Are you sure?” flows (delete client, cancel shift, etc.) use this component. No ad-hoc confirmation dialogs. Styling is entirely in this template (and shared modal styles).

### 3.3 Toast / Snackbar Template

- **Single toast component** (e.g. refactor `ToastContainer.vue`):
  - Renders a list of toasts from a **single store** (e.g. `useToastStore`). No duplicate toast logic elsewhere.
  - **Animations:** Enter/leave (e.g. slide-in from top-right, fade out). All toasts use the same transition; one place to change.
  - **Styling:** One set of styles for container and variants (success, error, warning, info). Colors and layout come from the template and one CSS/SCSS file (or tokens). No per-call or per-page toast styling.
- **Usage:** All `toast.success()`, `toast.error()`, etc. go through the store; the single container renders them with the shared template. No inline snackbars in views.

### 3.4 Rules for Modals / Confirmations / Toasts

- **One component per concept:** One modal, one confirmation, one toast container.
- **One place for styling and animation:** Component + one shared style file (or design tokens). No duplicated modal/toast styles in views or other components.
- **Animations:** Define transition names and keyframes in the template component (or a single `transitions.css` imported once). Use these everywhere so “change animation” = “edit one file.”

---

## 4. DRY Principles Everywhere

Apply the same “template once, use everywhere” idea to anything that repeats:

- **Page layout:** One `DashboardTemplate` (or equivalent) for title, subtitle, actions slot, and content. All dashboard pages use it; no custom page wrappers or duplicate header/card styles.
- **Stat / KPI cards:** One component (e.g. `HpaDashboardWidget`). All stats on Dashboard, Clients, Staff, Reports use it. Styling only in that component (+ optional global tokens).
- **Cards (charts, lists, sections):** One “section card” style (e.g. `.modern-card` in global CSS or a small wrapper component). All chart cards, list cards, and content blocks use it. No per-view card styling.
- **Empty states:** One `HpaEmptyState` (or similar) with props for icon, title, description, action. Used everywhere a list or table is empty. Style only in that component.
- **Data tables:** One table component (e.g. `HpaDataTable`) with consistent header, row, and action styling. All tables use it; styling in one place.
- **Form blocks:** If forms repeat (e.g. “field + label + error”), consider a small `FormField` or form-group template so layout and validation styling live in one place.

**Rule for you (or the AI):** Before adding a new UI pattern (e.g. a second way to show a confirmation), ask: “Can this be the same template as the existing one?” If yes, extend the template (e.g. with a prop or slot) instead of creating a new pattern. This keeps the codebase easy to navigate and update: change one template, everything using it updates.

---

## 5. File and Architecture Conventions

- **Templates live in one place:** e.g. `src/components/base/` for `HpaModal.vue`, `HpaConfirmModal.vue`, and shared building blocks; `src/components/` for `AppFooter.vue`, `ToastContainer.vue`. Layout in `src/layouts/`.
- **Global styles:** One main style file (e.g. `src/style.css`) for tokens, reset, and shared class names (e.g. `.modern-card`, `.page-title`). Modal/toast/footer components can import a single `_modals.css` or `_toasts.css` if you want to keep their styles in separate files but still “one file per concept.”
- **No duplicated styles:** Views and pages should not define their own modal, toast, or card styles. They use the shared components and global classes. If a view needs a one-off tweak, use a single override class and document it; avoid scattering magic numbers or colors.

---

## 6. Implementation Guide: Step-by-Step + Dos and Don'ts

Implement in this order so dependencies are in place. Act like a senior frontend/fullstack developer: one change per concept, test as you go, no shortcuts that duplicate logic or styles.

### Step 1: Footer (no dependencies)

1. Create `src/components/AppFooter.vue`. One root element, one scoped style block. Props: `productName` (default `"HPA Plus"`), `version` (default from env or `"1.0.0"`).
2. Content: one line or two—e.g. `{{ productName }} · v{{ version }}`. No icons, no borders, no background beyond transparent or a very subtle tint.
3. Style: `font-size: 0.6875rem` (11px), `color: #94a3b8` (or similar muted gray), `text-align: center`, minimal padding. **Do not** use this minimalist style elsewhere.
4. Add `<AppFooter />` once in `MobileLayout.vue`—e.g. after `v-main`, inside the app shell, so it appears on all authenticated pages. **Do not** put the footer inside individual views.
5. **Do:** Keep footer in the layout so it’s truly app-wide. **Don’t:** Add links, icons, or multiple sections; the spec says “minimalist” and “watermark + version” only.

### Step 2: Shared modal styles and animations

1. Define **one** transition name for all modals (e.g. `modal-transition`). In `HpaModal.vue`, use `<transition name="modal-transition">` on the overlay/content (or use Vuetify’s transition prop with a custom name).
2. Define **one** set of CSS for the modal card: header (e.g. primary or variant-based), body padding, action bar. Put these in `HpaModal.vue`’s scoped styles (or a single `_modals.css` imported only by modal components). **Do not** duplicate these styles in views or in `HpaConfirmModal`.
3. **Do:** Use the same transition name and class names for the confirmation modal so one CSS change updates both. **Don’t:** Create a second transition name or a second set of modal card styles.

### Step 3: Refactor HpaModal (template + variant)

1. Add prop `variant?: 'default' | 'danger' | 'success'`. Map to header/button color (e.g. danger = error color, success = success color). Use existing design tokens or a small map in the component.
2. Keep slots: default (body), optional `actions` for custom buttons. If `actions` is used, hide the default Confirm/Cancel buttons.
3. Use the shared modal transition and card styles from Step 2. **Do:** Keep all modal markup and styles inside this one component. **Don’t:** Use inline styles for colors; use classes so they can be overridden in one place.

### Step 4: HpaConfirmModal (wrapper around shared template)

1. Create `src/components/base/HpaConfirmModal.vue`. It can wrap `HpaModal` with a default slot that shows `message` and default action buttons that emit `confirm` / `cancel`, or it can be a second template that reuses the same transition and card classes as `HpaModal`.
2. Props: `modelValue`, `title`, `message`, `confirmText`, `cancelText`, `variant?`, `loading?`. Emits: `confirm`, `update:modelValue` (on cancel).
3. **Do:** Reuse the same transition name and card style as `HpaModal` so one style change updates both. **Don’t:** Copy-paste modal markup; either use `<HpaModal>` with preset slots/props or share the same CSS classes.

### Step 5: Toast template (animations + single style set)

1. In `ToastContainer.vue`, wrap each toast item in a `<transition>` (e.g. `name="toast-transition"`). Define enter/leave in scoped styles (e.g. slide from right + fade in, fade out on leave).
2. One set of styles for the toast container and for types (success, error, warning, info): background, border-radius, padding, icon color. Use CSS variables or a small map so changing one color updates all toasts.
3. **Do:** Keep all toast markup and animation in this component; toasts are shown only via the store. **Don’t:** Add a second toast container or duplicate toast markup in any view.

### Step 6: Use templates everywhere (DRY audit)

1. **Modals:** Search for `<v-dialog` or raw dialog markup. Replace with `<HpaModal>` or `<HpaConfirmModal>`. Pass content via slots; remove any local modal styles from views.
2. **Confirmations:** Search for “confirm” or “Are you sure” or `v-dialog` used for yes/no. Replace with `<HpaConfirmModal>` and a single handler. Remove duplicate confirmation markup/styles.
3. **Toasts:** Ensure all notifications use `useToastStore()` and `toast.success()`, `toast.error()`, etc. Remove any inline `v-snackbar` or custom toast markup in views.
4. **Pages:** Ensure every dashboard page uses `<DashboardTemplate>` (or the single page template). Remove page-specific header/card styles; use shared `.page-title`, `.page-subtitle`, `.modern-card` from global CSS.
5. **Stat cards:** Ensure Dashboard, Clients, Staff, Reports use `HpaDashboardWidget` (or the single stat component). Remove any local stat-card markup or styles from views.
6. **Do:** One pass per concept (modals, then toasts, then pages, then stats). **Don’t:** Mix refactors (e.g. changing modal and toast in the same file in one commit) until you’re comfortable; it’s easier to review and roll back.

### Dos and Don'ts (summary)

| Do | Don’t |
|----|--------|
| One component per concept (one modal, one confirm, one toast container). | Add a second modal or toast component “just for this page.” |
| Put all modal/toast/footer styles in the template component (or one shared file). | Duplicate modal/toast/card styles in views or layout. |
| Use the same transition name and card classes for modal and confirm. | Invent a new transition or new card style for confirm. |
| Show toasts only via the store; render in one container. | Put `<v-snackbar>` or toast markup in views. |
| Add footer once in the layout; pass version via prop or env. | Put footer in each view or duplicate footer content. |
| Use `DashboardTemplate` and shared `.page-title`, `.modern-card` on every page. | Define `.page-title` or `.modern-card` in a view’s scoped styles. |
| Extend the existing template with a prop or slot when you need a variant. | Create a new component that does almost the same thing. |
| Run a quick search for `v-dialog`, `v-snackbar`, `.page-title`, stat-card markup before finishing. | Assume “everything already uses the template” without checking. |

---

## 7. Checklist for Implementation

- [x] **Top bar:** Styled in layout only; blue palette; no dots; single source of styling.
- [x] **Footer:** New `AppFooter.vue` with watermark + version; minimalist; used once in main layout on all app pages.
- [x] **Modal:** One `HpaModal` with variant (default/danger/success), shared transition `modal-transition`; all dialogs use it; no raw `v-dialog` in views.
- [x] **Confirmation:** `HpaConfirmModal.vue` wraps `HpaModal` with message + same styles/animations; use for “Are you sure?” flows.
- [x] **Toasts:** One `ToastContainer` + store; `toast-transition` enter/leave; used only via store.
- [x] **Pages:** All use `DashboardTemplate`; shared `.page-title`, `.modern-card` in global CSS.
- [x] **Stat cards:** One `HpaDashboardWidget`; used on Dashboard, Clients, Staff, Reports.
- [x] **Cards / widgets:** One `.modern-card` in global CSS; used for chart/list/section cards.
- [ ] **DRY audit:** When adding new flows, use `HpaConfirmModal` for confirmations; keep modal/toast styles only in template components.

---

## 8. Usage (HpaConfirmModal + Toast)

**HpaConfirmModal** – Use for any “Are you sure?” flow (delete, cancel, overwrite). One place for styling and animation.

```vue
<HpaConfirmModal
  v-model="showDeleteConfirm"
  title="Delete client?"
  :message="deleteConfirmMessage"
  confirm-text="Delete"
  cancel-text="Cancel"
  variant="danger"
  @confirm="handleDeleteConfirm"
/>
```

- `variant`: `'default' | 'danger' | 'success'` (danger = red header/button, success = green).
- On confirm, close the modal in the handler (e.g. set `showDeleteConfirm = false`) or let `HpaConfirmModal` close it (it emits `update:modelValue(false)` on confirm/cancel).

**Toasts** – Use only via the store; do not add `<v-snackbar>` in views.

```ts
import { useToastStore } from '@/stores/toast'

const toast = useToastStore()
toast.success('Saved')
toast.error('Something went wrong')
toast.warning('Please review')
toast.info('Tip: …')
```

- Optional: `toast.success('Done', 5000, { text: 'Undo', onClick: () => { … } })`.

**Version / footer** – Set `VITE_APP_VERSION=1.0.0` in `.env` (see `.env.example`). Version and app name come from `src/constants/app.ts` so one place updates footer and any other version display.

---

## 9. One-Line Summary for AI

**“Do a full makeover of modals, pages, widgets, stat cards, and top bar; add a minimalist footer (watermark + version) in the layout; make modals, confirmations, and toasts use a single templated component each with shared animations and styling so one change updates everywhere; and apply DRY to stat cards, page layout, cards, empty states, and tables so styling and structure live in one place per concept.”**

Use this prompt so the AI (or developer) does not have to navigate every file to update styling: change the template or the single style file, and all usages update across all pages and dashboards.
