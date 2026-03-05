# HPA+ Design System

Enterprise-grade design tokens and guidelines for the BulodPH frontend.

---

## 1. Spacing Scale (4px grid)

| Token | Value | Use |
|-------|-------|-----|
| `--space-0` | 0 | Reset |
| `--space-1` | 4px | Tight gaps |
| `--space-2` | 8px | Icon-text gap |
| `--space-3` | 12px | Button groups |
| `--space-4` | 16px | Card internal |
| `--space-5` | 20px | Card padding |
| `--space-6` | 24px | Section gap |
| `--space-8` | 32px | Large gaps |
| `--space-10` | 40px | |
| `--space-12` | 48px | |
| `--space-16` | 64px | |
| `--page-padding-x` | 12px | Main content horizontal |
| `--page-padding-y` | 20px | Main content vertical |
| `--section-gap` | 24px | Between sections |
| `--card-padding` | 20px | Card body |
| `--page-max-width` | 1520px | Container max |

**Mobile (≤599px):** `--page-padding-x: 8px`, `--page-padding-y: 16px`

**Utilities:** `.gap-section`, `.gap-card`, `.pa-card`, `.mb-section`

---

## 2. Typography

| Token | Size | Use |
|-------|------|-----|
| `--text-xs` | 12px | Labels, captions |
| `--text-sm` | 13px | Secondary labels |
| `--text-body` | 15px | Body |
| `--text-body-sm` | 14px | Meta |
| `--text-body-lg` | 16px | Emphasised |
| `--text-base` | 17px | Section titles |
| `--text-md` | 18px | Modal title |
| `--text-lg` | 20px | Card headings |
| `--text-xl` | 22px | Subheadings |
| `--text-2xl` | 28px | Page title |
| `--text-3xl` | 32px | Hero/dashboard titles |

**Line heights:** `--leading-tight` (1.25), `--leading-snug` (1.375), `--leading-normal` (1.5), `--leading-relaxed` (1.6)

**Letter spacing:** `--tracking-tighter` (-0.03em), `--tracking-tight` (-0.02em), `--tracking-normal` (0.01em)

**Utilities:** `.heading-page`, `.heading-section`, `.heading-card`, `.label-uppercase`, `.font-tabular`, `.font-mono`, `.text-size-3xl`

---

## 3. Colors

| Token | Value | Use |
|-------|-------|-----|
| `--text-primary` | #1F2937 | Body text |
| `--text-secondary` | #64748B | Secondary text |
| `--text-muted` | #94A3B8 | Muted/captions |
| `--primary-cyan` | #60a5fa | Accent, CTAs |
| `--trust-blue` | #0f172a | Navy, nav |
| `--accent-green` | #10B981 | Success, verified |
| `--role-primary` | #1e3a5f | Role accent, icons, CTAs |
| `--role-primary-dark` | #334155 | Role accent darker |
| `--navy-icon` | #1e3a5f | Section/card icons |
| `--sidebar-text` | rgba(248,250,252,0.9) | Sidebar nav text |
| `--sidebar-text-muted` | rgba(248,250,252,0.65) | Sidebar datetime |
| `--sidebar-label` | rgba(248,250,252,0.55) | Sidebar section labels |
| `--feedback-success-bg/border` | rgba tokens | Form success |
| `--feedback-error-bg/border` | rgba tokens | Form error |

---

## 4. Radius

| Token | Value |
|-------|-------|
| `--radius-sm` | 8px |
| `--radius-md` | 12px |
| `--radius-lg` | 16px |
| `--radius-xl` | 20px |

---

## 5. Shadows & Elevation

| Token | Use |
|-------|-----|
| `--shadow-sm` | Cards at rest |
| `--shadow-md` | Hover |
| `--shadow-lg` | Raised |
| `--shadow-modal` | Dialogs |
| `--shadow-dropdown` | Dropdowns |
| `--shadow-topbar` | Topbar |
| `--shadow-widget` | KPI widgets |

---

## 6. Transitions & Animations

| Token | Use |
|-------|-----|
| `--transition-fast` | 0.15s – micro |
| `--transition-base` | 0.2s – default |
| `--transition-slow` | 0.3s – modals, pages |
| `--metallic-transition` | Cards, buttons |

**Animation classes:** `.animate-slide-in-right`, `.animate-scale-in`, `.animate-stagger` (list stagger)

**Keyframes:** `fadeInUp`, `fadeInScale`, `pulseSubtle`, `shimmer`, `pageFadeIn`, `slideInRight`, `scaleIn`, `metallicShine`

---

## 7. Button Variants

| Variant | Use |
|---------|-----|
| `flat` / `elevated` | Primary CTAs |
| `tonal` | Secondary emphasis |
| `outlined` | Secondary actions |
| `text` | Tertiary/ghost |
| `error` | Destructive |

**Default:** min-height 40px, rounded lg, font-weight 600. Icon buttons: 44px min on mobile.

---

## 8. Cards & Surfaces

- **Card:** `modern-card` – glass bg, `1px solid var(--border-subtle)`, hover translateY(-1px)
- **Image cards:** `aspect-ratio: 4/3` for vehicle/listing images
- **Section header:** `section-card-header`, `section-card-icon`, `section-card-title`

---

## 9. Forms

- **Inputs:** `variant="outlined"`, `density="comfortable"`
- **Focus:** 2px ring with `--primary-cyan`
- **Error:** `--feedback-error-border` on focus
- **Required:** `.form-label-required::after { content: ' *' }`

---

## 10. Data Tables (HpaDataTable)

- **Header:** Sticky, `--space-3` / `--space-4` padding
- **Rows:** Hover `--hover-overlay`, alternating rows `rgba(248,250,252,0.5)`
- **Empty:** HpaEmptyState

---

## 11. Layout

- **Container:** `.app-container` — max 1520px, centered
- **Page template:** `DashboardTemplate` + `page-template`
- **Modals:** Backdrop blur 8px

---

## 12. Breakpoints

| Name | Width |
|------|-------|
| xs | 0–599px |
| sm | 600–959px |
| md | 960–1279px |
| lg | 1280px+ |

---

## 13. Accessibility

- **Focus:** `:focus-visible` 2px outline on all interactive elements
- **Disabled:** opacity 0.6
- **Skip link:** `.skip-link` for keyboard users
- **Reduced motion:** `@media (prefers-reduced-motion: reduce)` disables animations

---

*See `FRONTEND_AUDIT_REPORT.md` for full audit and fixes.*
