# BulodPH Styling Suggestions — Design System Refinements

A guide to improve fonts, colors, icons, widgets, shadows, and animations across all pages.

---

## 1. Typography & Fonts

### Current
- **Primary font:** DM Sans (400, 500, 600, 700)
- **Usage:** Mixed; some views use inline font-size/font-weight inconsistently

### Suggestions

| Element | Current | Suggested | Rationale |
|--------|---------|-----------|-----------|
| **Headings** | Mix of `text-h5`, `text-h6`, `text-subtitle-1` | Add utility `.heading-page`, `.heading-section`, `.heading-card` with consistent scale | Clear hierarchy |
| **Numbers/KPIs** | `1.875rem` (30px) in widgets | Use `font-variant-numeric: tabular-nums` for alignment | Aligns digits in tables/widgets |
| **Body text** | 0.875–0.9375rem | Standardize: body=0.9375rem, caption=0.8125rem, label=0.75rem | Consistency |
| **Monospace** | None | Add `font-family: 'JetBrains Mono'` or `ui-monospace` for IDs, codes | Better for transaction IDs, codes |
| **Letter-spacing** | Inconsistent | Uppercase labels: `0.05em`, headings: `-0.02em`, body: `0` | Refined look |

### Implementation

```css
/* Add to style.css :root */
--font-mono: 'JetBrains Mono', 'SF Mono', ui-monospace, monospace;

/* Number alignment for stats/tables */
.font-tabular { font-variant-numeric: tabular-nums; }
```

**Font loading:** Consider adding `font-display: swap` and variable font DM Sans to reduce weight.

---

## 2. Colors

### Current
- Primary: `#0f172a` (navy)
- Action/CTA: `#60a5fa` (sky blue)
- Success: `#10B981`
- Text: `#1F2937`, secondary `#64748B`

### Suggestions

| Area | Suggestion | Example |
|------|------------|---------|
| **Status chips** | Semantic opacity variants | `success`: 0.12 bg + full color text; `warning`: 0.12 bg |
| **Hover states** | Slightly darker/lighter | Buttons: `action-darken-1` on hover; cards: subtle tint |
| **Empty states** | Softer icon color | `rgba(148, 163, 184, 0.4)` instead of grey-lighten-2 |
| **Price/savings** | Keep green `#10B981` | Ensure sufficient contrast (4.5:1) on white |
| **Borders** | Lighter default | `#E2E8F0` → `#F1F5F9` for cards on light bg |
| **Role-specific** | Reinforce role colors | Admin: navy; Client: sky; Car owner: emerald tint; Marketing: violet accent |

### New tokens to add

```css
--hover-overlay: rgba(15, 23, 42, 0.04);
--chip-success-bg: rgba(16, 185, 129, 0.12);
--chip-warning-bg: rgba(245, 158, 11, 0.12);
--chip-error-bg: rgba(239, 68, 68, 0.12);
```

---

## 3. Icons

### Current
- Material Design Icons (MDI)
- Size mix: 14–24px; some 18–22px in widgets

### Suggestions

| Context | Size | Style | Notes |
|---------|------|-------|-------|
| **Nav/sidebar** | 20px | Outline (e.g. `mdi-home-outline`) | Consistent outline style |
| **Section headers** | 22px | Outlined, color `text-secondary` | Match `section-card-icon` |
| **KPI widgets** | 24px | Filled, white on gradient bg | Keep current |
| **List prepend** | 20px | Outline, `text-medium-emphasis` | Softer than filled |
| **Buttons** | 18px | Match button variant | Outlined=outline icon feel |
| **Chips/badges** | 14px | Small, same color as chip | For status chips |
| **Empty states** | 80–96px | Large, very muted | `opacity: 0.5` |

### Icon style rules
- Use `-outline` for nav, list items, secondary actions
- Use filled for primary CTAs, KPIs, alerts
- Keep icon-to-text alignment: `align-items: center` and consistent gap (10–12px)

---

## 4. Widgets & Cards

### KPI / Stats widgets (HpaDashboardWidget)

| Property | Current | Suggestion |
|----------|---------|------------|
| **Shadow** | Soft navy tint | Option: `--shadow-widget: 0 2px 12px rgba(0,0,0,0.06)` |
| **Hover** | `translateY(-3px)` | Add `transition: transform 0.2s ease` if missing |
| **Icon** | 52×52px, gradient bg | Consider 44×44px for denser dashboards |
| **Value font** | 1.875rem, 800 | Add `font-variant-numeric: tabular-nums` |
| **Border** | 1px subtle | Optional: left accent bar `border-left: 4px solid var(--role-primary)` |

### Content cards (modern-card)

| Property | Suggestion |
|----------|------------|
| **Default shadow** | `--shadow-sm` or slightly softer |
| **Hover shadow** | `--shadow-md` with subtle lift |
| **Border** | 1px `var(--border-subtle)` or transparent |
| **Radius** | Keep 12–16px; use 8px for compact lists |
| **Transition** | `transition: box-shadow 0.25s ease, transform 0.25s ease` |

### Section headers

- Use `section-card-icon` + `section-card-title` consistently
- Icon: 40×40px, gradient bg, 18px icon
- Title: `--text-base`, `font-weight: 600`

---

## 5. Shadows

### Current tokens
```
--shadow-sm: 0 1px 3px rgba(0,0,0,0.06)
--shadow-md: 0 4px 12px rgba(0,0,0,0.05), 0 1px 2px rgba(15,23,42,0.04)
--shadow-lg: 0 8px 24px rgba(0,0,0,0.06), 0 2px 6px rgba(15,23,42,0.04)
--shadow-card-hover: 0 12px 32px rgba(15,23,42,0.08)
```

### Suggestions

| Use case | Suggested shadow | Notes |
|----------|------------------|-------|
| **Cards at rest** | `0 1px 4px rgba(0,0,0,0.04)` | Very soft |
| **Cards hover** | `0 8px 24px rgba(0,0,0,0.08), 0 2px 8px rgba(0,0,0,0.04)` | Clear elevation |
| **Modals/dialogs** | `0 24px 48px rgba(0,0,0,0.12)` | Strong for overlays |
| **Dropdowns** | `0 4px 16px rgba(0,0,0,0.08)` | Visible but light |
| **Topbar** | `0 2px 8px rgba(0,0,0,0.06)` | Subtle separation |
| **Widget icon** | Keep metallic look | Optional: softer `inset` highlight |

### Layering
- Base: 1–2px blur
- Elevated: 8–12px blur, 4–8px Y offset
- Overlay: 24px+ blur, 12px+ Y offset

---

## 6. Animations & Effects

### Current
- `fadeInUp`, `fadeInScale`, `pageFadeIn`, `metallicShine`, `shimmer`, `pulseSubtle`
- Card hover: `translateY(-2px)` or `-3px`
- Transitions: ~0.25–0.35s ease

### Suggestions

| Effect | Use case | Implementation |
|--------|----------|----------------|
| **Page enter** | Route change | `opacity 0→1`, 200ms ease |
| **Card enter** | List/grid items | `fadeInUp` with 50ms stagger per child |
| **Button press** | Primary buttons | `scale(0.98)` on `:active` |
| **Skeleton** | Loading | `shimmer` on gradient, 1.5s infinite |
| **Toast** | Notifications | Slide in from top-right, 300ms ease-out |
| **Modal** | Dialogs | Backdrop fade + content scale 0.98→1 |
| **Tab switch** | Tabs | Slight fade + optional slide |
| **Number count** | KPI values | AnimatedNumber (already used) ✓ |

### Performance
- Prefer `transform` and `opacity` for animations
- Use `will-change: transform` sparingly and only during animation
- Keep duration 200–400ms for micro-interactions

### New keyframes to add

```css
@keyframes slideInRight {
  from { opacity: 0; transform: translateX(12px); }
  to { opacity: 1; transform: translateX(0); }
}
@keyframes scaleIn {
  from { opacity: 0; transform: scale(0.96); }
  to { opacity: 1; transform: scale(1); }
}
```

---

## 7. Component-Specific Suggestions

### Forms
- Focus ring: 2px `var(--primary-cyan)` with 2px offset
- Error: red border + `aria-describedby` for screen readers
- Label: `--text-sm`, `font-weight: 500`, `color: text-secondary`

### Tables (HpaDataTable)
- Header: `font-size: 0.8125rem`, `font-weight: 600`, `text-transform: uppercase`, `letter-spacing: 0.04em`
- Row hover: `background: var(--hover-overlay)`
- Striped rows: optional `nth-child(even)` with very subtle bg

### Empty states (HpaEmptyState)
- Icon: 80–96px, `opacity: 0.5`, `color: grey-lighten-2`
- Title: `--text-lg`, `font-weight: 600`
- Description: `--text-body`, `color: text-secondary`
- Button: Primary CTA, 44px min height

### Notifications
- Icon size: 24px
- Gap icon–text: 16px (already improved)
- Unread: bold title + primary icon color
- Read: medium emphasis, muted icon

### Bottom nav (mobile)
- Active: `action` color with subtle background
- Inactive: `text-secondary`
- Height: 64–72px; tap target min 44px

---

## 8. Consistency Checklist

- [ ] All section titles use `section-card-header` or equivalent
- [ ] All primary buttons use `color="primary"` or `action`
- [ ] All cards use `modern-card` and `rounded="lg"`
- [ ] Spacing: `pa-4` for card bodies; `gap-3` or `gap-4` for button groups
- [ ] Icons: consistent size per context (nav=20, section=22, widget=24)
- [ ] Shadows: use CSS variables, avoid inline `box-shadow`
- [ ] Transitions: 0.2–0.35s ease for hover/active states

---

## 9. Quick Wins (Low Effort)

1. Add `font-variant-numeric: tabular-nums` to KPI values and price displays
2. Add `:active { transform: scale(0.98) }` to primary buttons
3. Add `--hover-overlay` and use for table row hover
4. Standardize chip backgrounds with opacity tokens
5. Add `transition` to all interactive cards if missing

---

## 10. File Reference

| File | Purpose |
|------|---------|
| `src/style.css` | Global tokens, animations, utilities |
| `src/plugins/vuetify.ts` | Theme colors, component defaults |
| `src/components/base/HpaDashboardWidget.vue` | KPI widget styles |
| `src/layouts/MobileLayout.vue` | Sidebar, topbar, bottom nav |
| `index.html` | Font preconnect and Google Fonts load |

---

*Use this document as a reference when refining styles. Implement gradually to avoid large, disruptive changes.*
