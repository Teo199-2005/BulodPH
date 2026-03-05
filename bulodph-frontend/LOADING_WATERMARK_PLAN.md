# Loading Spinner & Watermark Strategy

## Goals
- **Spinner:** Consistent, branded loading indicator on landing (full-page loader) and dashboard (global overlay + in-page bar).
- **Watermarks:** Subtle BulodPH logo/pattern in the background for full-page loader, loading overlay, and dashboard main content.

## Current state
| Location | What exists |
|----------|-------------|
| **Landing / post-login** | `HpaFullPageLoader` – triple-ring spinner + logo center; gradient bg; pattern div present but `display: none` |
| **Dashboard global** | `HpaLoadingOverlay` – `v-progress-circular`, blurred backdrop, no watermark |
| **Dashboard pages** | `DashboardTemplate` – `v-progress-linear` when `requestStatus.isLoading`; `MobileLayout` main area has `app-dots-bg` (gradient + climpek), no logo watermark |
| **Landing sections** | Already use `.has-watermark` / `.section-watermark` and hero split watermarks |
| **Inline** | Buttons use Vuetify `:loading`; BlogIndexView / AnnouncementsView use `v-progress-circular` |

## Decisions

### Spinner
- **Full-page loader:** Keep triple-ring + logo; align ring colors with theme (primary navy, action/sky blue).
- **Loading overlay:** Keep `v-progress-circular` with `color="primary"`; optionally increase size for visibility. No new shared component for this pass.
- **Dashboard bar:** Keep `v-progress-linear`; ensure it uses primary (already). Optional: add rounded class.
- **Vuetify:** Theme already sets primary/action; no plugin change required for progress defaults unless we want explicit `VProgressCircular`/`VProgressLinear` defaults.

### Watermarks
- **Full-page loader:** Use the existing `.hpa-full-page-loader__pattern` as a logo watermark (repeated or single large logo, low opacity) so the first screen feels branded.
- **Loading overlay:** Add a logo watermark on the backdrop (single centered logo, very low opacity) so overlay feels consistent with full-page loader.
- **Dashboard:** Add a single background watermark layer to the main content area (`.main-content-wrap` or a wrapper inside it): logo repeated or one large centered logo, low opacity, behind existing `app-dots-bg` or layered with it. Use a class like `dashboard-watermark` in global CSS so all dashboard pages get it.

## Files to touch
1. `src/components/base/HpaFullPageLoader.vue` – pattern as watermark; spinner colors.
2. `src/components/base/HpaLoadingOverlay.vue` – watermark on backdrop; spinner size/color if desired.
3. `src/layouts/MobileLayout.vue` – add watermark div or class to main content wrap.
4. `src/style.css` – add `.dashboard-watermark` (or `.main-content-wrap` watermark) using logo.png, position absolute, low opacity.
5. Optional: `src/components/DashboardTemplate.vue` – add class to progress bar for rounded ends; or leave as-is.

## Implemented
- **HpaFullPageLoader:** Pattern div used as repeated logo watermark (opacity 0.055); spinner rings use theme `action` / `action-lighten-1` / `primary`.
- **HpaLoadingOverlay:** Backdrop watermark (centered logo, opacity 0.06); spinner size 56px, primary color.
- **Dashboard:** `.dashboard-watermark-wrap` + `.dashboard-watermark` in `MobileLayout`; global `.dashboard-watermark` in `style.css` (centered logo, opacity 0.05).
- **Vuetify:** Defaults for `VProgressCircular` (primary, width 4) and `VProgressLinear` (primary, height 3, rounded).

## Out of scope (this pass)
- Shared `BulodLoadingSpinner.vue` component (can add later if we want same triple-ring in overlay).
- Changing button `:loading` appearance (Vuetify default is fine).
- Extra watermark on individual landing sections (already present).
