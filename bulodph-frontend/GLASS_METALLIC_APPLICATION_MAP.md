# BulodPH — Glassmorphism & Metallic Application Map

Reference for where glass and metallic styling is applied across the app. Use this to maintain consistency when adding new pages or components.

---

## CSS Tokens (style.css)

```css
/* Glassmorphism */
--glass-bg: rgba(255, 255, 255, 0.65);
--glass-bg-strong: rgba(255, 255, 255, 0.85);
--glass-border: 1px solid rgba(255, 255, 255, 0.5);
--glass-border-dark: 1px solid rgba(15, 23, 42, 0.08);
--glass-blur: 16px;
--glass-blur-strong: 24px;

/* Metallic (existing) */
--metallic-gradient, --metallic-shadow-sm, --metallic-shadow-hover, --metallic-transition, etc.
```

---

## Layout & Shell

| Element | File | Treatment |
|--------|------|-----------|
| **Topbar** | MobileLayout.vue | Glass: `rgba(255,255,255,0.7)` + `backdrop-filter: blur(20px)` + metallic border |
| **Bottom nav** | MobileLayout.vue | Same as topbar |
| **Sidebar welcome** | MobileLayout.vue | Glass panel: `rgba(255,255,255,0.06)` + blur + metallic border |
| **Sidebar dividers** | MobileLayout.vue | Metallic gradient line |
| **Main content bg** | style.css (.app-dots-bg) | Gradient + dot pattern for depth |
| **AppFooter** | AppFooter.vue | Glass bar + metallic top border |

---

## Shared Components

| Component | Treatment |
|-----------|-----------|
| **modern-card** | Glass bg + blur + metallic border & shadow (all dashboard cards) |
| **section-card-icon** | Metallic gradient + shine animation |
| **HpaDashboardWidget** | Extends modern-card; metallic icon container |
| **HpaModal** | Glass panel + metallic header/actions |
| **ToastContainer** | Glass toasts with blur |
| **HpaEmptyState** | Glass container with blur |
| **ShiftCard** | modern-card + metallic; shadow-shift uses tinted glass |

---

## Pages & Views

| Page | Elements styled |
|------|-----------------|
| **DashboardView** | dashboard-hero: glass card + role accent bar |
| **ProfileView** | Cards: section-card-accent (role-colored left border) |
| **SettingsView** | Cards: section-card-accent |
| **ClientPaymentsView** | Cards: section-card-accent |
| **PlaceholderView** | placeholder-view--glass container |
| **LoginView** | auth-demo-float: glass; auth-form-card: glass |
| **RegisterView** | auth-form-card: glass (role accent via ::before) |

---

## Form Elements

| Element | Treatment |
|---------|-----------|
| **v-text-field (outlined)** | Glass bg inside modern-card; metallic focus ring |
| **v-select, v-radio** | Same as above when inside .modern-card |
| **section-card-accent** | Utility class: 4px left border in `var(--role-primary)` |

---

## Utility Classes

| Class | Purpose |
|-------|---------|
| `.modern-card` | Glass + metallic card (use on v-card) |
| `.section-card-accent` | Role-colored left accent bar |
| `.section-card-header` | Header with metallic icon |
| `.section-card-icon` | Metallic gradient icon box |

---

## Implementation Notes

1. **Role colors** — Set on app shell via `useRoleTheme`; `--role-primary` etc. available globally.
2. **Backdrop blur** — Use `-webkit-backdrop-filter` for Safari.
3. **Fallback** — On older browsers, glass degrades to semi-opaque solid; still readable.
4. **Contrast** — Glass works best on `.app-dots-bg` or gradient backgrounds.
5. **New cards** — Add `modern-card` and optionally `section-card-accent` to v-cards.

---

*Last updated: February 2026*
