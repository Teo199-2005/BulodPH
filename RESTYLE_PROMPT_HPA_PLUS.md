# HPA Plus Restyle & Improvement Prompt

**Purpose:** Use this document as the single source of truth to restyle and improve the HPA Plus frontend (landing page, navbar, footer, dashboards and all dashboard pages). Follow it step by step. Align visuals and copy with [hpaplus.com.au](https://hpaplus.com.au/) where relevant.

---

## 1. Design System — Color Scheme (Functional Roles)

### 1.1 Core Palette

Apply these **exactly** across the app. Do not introduce new primary/accent colors.

| Role | Hex | Usage | CSS Variable |
|------|-----|--------|--------------|
| **Primary Brand (Deep Navy)** | `#0E2038` – `#132A46` | Header, hero bg, primary CTAs, footer | `--brand-primary-900`, `--brand-primary-800` |
| **Primary Accent (CTA Blue)** | `#2F80ED` – `#3A86FF` | "Book a demo", "Start free trial", hover, links | `--brand-accent-500`, `--brand-accent-600` |
| **Background Base** | `#FFFFFF`, `#F7F9FC` | Section alternation, cards, scannability | `--surface-0`, `--surface-1` |
| **Text Primary** | `#1F2937` | Body, headings (no pure black) | `--text-primary` |
| **Text Secondary** | `#6B7280` | Muted copy, captions | `--text-secondary` |
| **Border Subtle** | `#E5E7EB` | Dividers, card borders | `--border-subtle` |

### 1.2 Formal CSS Variables (Design Token Layer)

Add or ensure these exist in global CSS (e.g. `style.css` or a dedicated `tokens.css` imported in `main.ts`):

```css
:root {
  /* Brand Primary - Deep Navy / Midnight Blue */
  --brand-primary-900: #0E2038;
  --brand-primary-800: #132A46;
  --brand-primary-700: #1E3A5F;

  /* Brand Accent - CTA Blue */
  --brand-accent-500: #2F80ED;
  --brand-accent-600: #1C6ED5;

  /* Surfaces */
  --surface-0: #FFFFFF;
  --surface-1: #F7F9FC;

  /* Text */
  --text-primary: #1F2937;
  --text-secondary: #6B7280;

  /* Borders */
  --border-subtle: #E5E7EB;
}
```

Map Vuetify theme in `plugins/vuetify.ts` to these values (primary = `--brand-primary-900` / `#0E2038`, action = `--brand-accent-500` / `#2F80ED`, etc.) so components use the design system by default.

### 1.3 Gradient Usage (Controlled, No Abuse)

- **Hero / Header / Footer:** Use **one** approved gradient:
  ```css
  linear-gradient(180deg, #0E2038 0%, #132A46 100%)
  ```
- **Do not:** Use purple/pink/rainbow gradients, heavy multi-stop gradients, or “crypto-style” glows.
- **Rationale:** Keeps healthcare/NDIS credibility and avoids banding on large screens.

### 1.4 Contrast & Accessibility

- White on navy = AAA contrast.
- Blue CTAs (`#2F80ED`) on white = AA+.
- Use gray (`#6B7280`) only for secondary content.
- **Do not** use low-contrast pastels for primary text or CTAs.

### 1.5 Visual Hierarchy (Programmatic)

| Layer | Color Strategy |
|-------|----------------|
| Hero | Dark background → white text |
| CTAs | Bright accent blue → immediate affordance |
| Sections | White / off-white alternation (`#FFFFFF` / `#F7F9FC`) |
| Text | Dark primary → readable, scannable |
| Borders | Very light gray → invisible structure |

---

## 2. Persona (Who We’re Designing For)

Design and copy should speak to:

- **Primary:** NDIS & Aged Care **provider owners and operations managers** (Australia). They care about compliance, saving time, reducing admin, and looking professional to participants and auditors.
- **Secondary:** **Care coordinators and frontline staff** who use the app daily (rosters, progress notes, clock in/out). They need clarity and speed, not decoration.
- **Tone:** Professional, trustworthy, healthcare-grade. Enterprise-ready, not “startup playful.” Safe for long-term branding (no trend-heavy visuals).

When in doubt, ask: “Would an NDIS auditor or a busy care manager find this clear and credible?”

---

## 3. Dos and Don’ts

### Do

- Use **deep navy** for header, hero background, and footer.
- Use **bright blue** (`#2F80ED`–`#3A86FF`) for primary CTAs and link affordance.
- Alternate section backgrounds: **white** and **off-white** (`#F7F9FC`) for rhythm.
- Use **primary text** `#1F2937` and **secondary text** `#6B7280`; avoid pure black.
- Keep gradients **subtle and single**: e.g. `180deg, #0E2038 → #132A46`.
- Ensure **white on navy** and **blue on white** meet WCAG AA (ideally AAA where possible).
- Make the page read like a **well-designed dashboard**, not a one-off landing experiment.
- Align messaging with hpaplus.com.au: “Australia’s fastest growing NDIS & Aged Care business management system,” “Grow your NDIS business on the go,” “Book a free demo,” “Start a free trial.”

### Don’t

- **Don’t** abuse gradients (no multi-color rainbow or heavy glow).
- **Don’t** use low-contrast or pastel colors for primary text or main CTAs.
- **Don’t** use pure black (`#000000`) for body text.
- **Don’t** add decorative elements that undermine healthcare seriousness (e.g. playful illustrations that clash with NDIS tone).
- **Don’t** introduce new primary or accent colors outside the defined palette.
- **Don’t** make the navbar or footer feel “crypto” or “SaaS generic”; keep them aligned with the navy + CTA blue system.

---

## 4. Step-by-Step Implementation

### Step 1 — Global Design Tokens & Vuetify

1. **Add or update global CSS variables** (Section 1.2) in `src/style.css` or a new `src/styles/tokens.css` and import in `main.ts`.
2. **Sync `plugins/vuetify.ts`** so that:
   - `primary` = `#0E2038` (and lighten/darken variants from the palette).
   - `action` (or equivalent) = `#2F80ED` / `#3A86FF` for CTAs and links.
   - `background` = `#F7F9FC`, `surface` = `#FFFFFF`.
   - `on-background` / `on-surface` = `#1F2937`, and a variant for secondary = `#6B7280`.
3. **Override any default Vuetify theme** that conflicts with the above (e.g. ensure app bar and buttons use the new tokens).

**Check:** A single CTA button and one card use the correct navy and blue without hard-coded hex in the template where avoidable.

---

### Step 2 — Landing Page

1. **Hero**
   - Background: `linear-gradient(180deg, #0E2038 0%, #132A46 100%)` (with or without a subtle overlay on an image, as long as the gradient dominates).
   - All hero text: white (or near-white). No gray text on navy in the hero.
   - Headline: Reflect hpaplus.com.au messaging, e.g. “Australia’s fastest growing NDIS & Aged Care business management system” or “Grow your NDIS business on the go.”
   - Primary CTA: “Start a free trial” or “Book a free demo” — style with `#2F80ED`–`#3A86FF` (solid or subtle gradient), white text.
   - Secondary CTA: Outlined white or low-emphasis; do not compete with the primary blue.

2. **Sections (Features, Testimonials, Pricing, etc.)**
   - Alternate background: `#FFFFFF` then `#F7F9FC` (or vice versa) so sections are visually separated.
   - Headings: `#1F2937`; body/captions: `#1F2937` and `#6B7280`.
   - Cards: White or off-white, border `#E5E7EB`; hover can add a subtle blue tint or shadow (e.g. `rgba(47, 128, 237, 0.1)`), no heavy gradients.

3. **Trust / social proof**
   - Use the same text and palette; badges or logos should not introduce new dominant colors.

4. **CTA strip (e.g. “Ready to transform your NDIS business?”)**
   - Background: Same navy gradient or navy-to-accent gradient (e.g. `#0E2038` → `#132A46` with a hint of `#2F80ED` at one edge). Buttons: primary = accent blue, secondary = outlined white.

5. **Animations / motion**
   - Keep subtle (e.g. fade-in, light parallax). No flashy or carnival-like motion.

**Check:** Landing reads as one consistent, professional flow; hero and footer feel like the same brand (navy + CTA blue).

---

### Step 3 — Navbar (Landing & App)

**Landing navbar**

1. Background: Same as hero/header — `linear-gradient(180deg, #0E2038 0%, #132A46 100%)`.
2. Logo and nav links: White (or near-white). Hover: slight opacity increase or subtle underline in accent blue.
3. Primary CTA in nav: “Start free trial” or “Book a demo” — accent blue (`#2F80ED`), white text.
4. Secondary action (e.g. “Login”): Outlined white.
5. On scroll: Navbar can stay the same or slightly darker navy; do not switch to a light navbar with dark text unless the whole page transitions (prefer consistency with hero/footer).

**Dashboard / app navbar (e.g. in MobileLayout)**

1. If the app bar is **light** (white/off-white): Use `#1F2937` for title and icons; primary actions = accent blue.
2. If you prefer a **dark app bar** to match landing: Use the same navy gradient and white text/icons; CTAs in the bar = accent blue.
3. Ensure contrast and focus states use `#2F80ED` or `#E5E7EB` where appropriate.

**Check:** Navbar on landing and (if applicable) in-app feel part of the same system; no unrelated colors.

---

### Step 4 — Footer

1. Background: Same deep navy as header — `linear-gradient(180deg, #0E2038 0%, #132A46 100%)` or `linear-gradient(135deg, #0E2038 0%, #0A1828 50%, #0E2038 100%)`.
2. Text: White for headings and key links; muted white (e.g. `rgba(255,255,255,0.8)`) for secondary text and captions.
3. Links: White or light gray; hover: accent blue (`#2F80ED` or `#3A86FF`) or underline.
4. Optional: Thin top border or line in accent blue to tie to the rest of the brand.
5. Social/icons: Outlined white; hover can use accent blue.
6. Bottom bar (copyright, legal): Slightly darker or same navy; text muted white.

**Check:** Footer looks like a continuation of the header/hero (navy + white + accent blue only).

---

### Step 5 — Dashboards and Dashboard Pages

1. **Layout**
   - Main content background: `#F7F9FC` (or `#FFFFFF` with cards on off-white).
   - Cards: White (`#FFFFFF`), border `#E5E7EB`, subtle shadow. No heavy gradients on cards.

2. **Welcome / header strip**
   - If it’s a full-width “welcome” card with image/gradient: Use the same navy gradient and white text; primary button = accent blue.

3. **KPI widgets / stat cards**
   - Background white or off-white; primary number in `#1F2937` or accent blue for emphasis; secondary label in `#6B7280`. Icons can use accent blue or semantic colors (green success, etc.) that already exist in the design system.

4. **Charts and tables**
   - Axes and labels: `#1F2937` and `#6B7280`. Primary series: accent blue; other series use existing semantic colors (green, amber, etc.) without introducing new primaries.
   - Table headers: Navy or dark gray (`#1F2937`); row borders `#E5E7EB`.

5. **Sidebar (if present)**
   - Background: Navy (`#0E2038` or `#132A46`) or dark gray that matches; active item: accent blue or white with accent left border; text white/muted white.

6. **Buttons and actions**
   - Primary: Accent blue; secondary: outlined with `#1F2937` or `#E5E7EB`. Danger: keep existing error color.

**Check:** Every dashboard page (Dashboard, Shifts, Clients, Reports, Settings, etc.) uses only the defined palette and feels like one product.

---

### Step 6 — Consistency Pass

1. **Search the codebase** for hard-coded hex that contradict the design system (e.g. old blues, purples, or black text) and replace with tokens or Vuetify theme variables.
2. **Ensure** “Start free trial,” “Book a demo,” and “Login” (and equivalent) use the same CTA styling everywhere.
3. **Verify** all section backgrounds alternate white / off-white where intended; header and footer stay navy.
4. **Test** contrast (e.g. with browser DevTools or a contrast checker) for white-on-navy and blue-on-white.

---

## 5. Alignment With hpaplus.com.au (Reference Checklist)

Use the live site as a **reference** for tone and structure, not for pixel-perfect copy. Prefer your own implementation for performance and maintainability.

- **Messaging:** “Australia’s fastest growing NDIS & Aged Care business management system,” “Grow your NDIS business on the go,” “Book a free demo,” “Start a free trial,” “Your all in one solution,” “Why choose HPA Plus?”
- **Sections to mirror in spirit:** Hero with two CTAs, “Why choose HPA Plus?” (features), NDIS provider registration/renewal if relevant, “Spend less time on admin, and more time caring,” client reviews/testimonials, pricing (e.g. 1–5 users, 6–40 users), footer with contact and links.
- **Visual tone:** Navy header/footer, clear CTAs, professional imagery. No need to copy exact layout or images; keep your stack (e.g. Vue/Vuetify) and ensure color and hierarchy match.

**Check:** A stakeholder familiar with hpaplus.com.au can say “this feels like the same brand” without needing identical assets.

---

## 6. Optional Suggestions (Non-Binding)

- **Images:** Prefer healthcare/NDIS-friendly imagery (e.g. care, teamwork, tablets/dashboards). If using stock photos, ensure they don’t clash with the navy/blue palette (e.g. avoid strong reds or purples as dominant).
- **Icons:** Use a single icon set (e.g. Material Design Icons already in use); keep style consistent (outline vs filled) per section.
- **Mobile:** Ensure navbar collapses cleanly; CTAs remain thumb-friendly; footer stacks and stays readable; dashboard cards stack in a logical order.
- **Performance:** Lazy-load below-the-fold images and avoid heavy animations on low-end devices.
- **SEO:** Keep one clear H1 per page (e.g. hero headline on landing); use semantic headings (H2, H3) for sections so the page outline matches the visual hierarchy above.

---

## 7. Summary Checklist

Before considering the restyle complete:

- [ ] Global design tokens (CSS variables) and Vuetify theme use the core palette (Section 1).
- [ ] Landing: Hero navy, white text, accent blue CTAs; sections alternate white/off-white; footer navy.
- [ ] Navbar (landing + app): Navy or light with correct text/CTA colors; no unrelated colors.
- [ ] Footer: Navy, white/muted text, accent blue for link hover.
- [ ] Dashboards: Backgrounds, cards, KPIs, charts, tables, and buttons use only the defined palette and hierarchy.
- [ ] No gradient abuse; no low-contrast or pastel primary text/CTAs; no pure black body text.
- [ ] Messaging and structure align with hpaplus.com.au in spirit; visuals are consistent and professional for NDIS/Aged Care.

Use this prompt as the **full brief** for any designer or developer implementing the restyle. If a decision isn’t covered here, default to: **navy for authority, accent blue for action, white/off-white for clarity, and enterprise healthcare tone throughout.**
