# Landing Page Enhancement Prompt — HPA Plus

**Purpose:** Use this as the single source of truth to enhance the HPA Plus landing page so it becomes a stronger first impression than [hpaplus.com.au](https://hpaplus.com.au/). Implement each section in order. Keep the existing design system from `RESTYLE_PROMPT_HPA_PLUS.md` (navy, CTA blue, white/off-white, NDIS tone).

---

## Mission

Build a **better** landing experience than the current [hpaplus.com.au](https://hpaplus.com.au/): clearer hierarchy, stronger trust, modern feel, and a “this site is good” impression—without flashy or outdated effects.

---

## 1. Logo — HPA-Plus-Logo.png

- **Asset:** Use the official logo `HPA-Plus-Logo.png` (project root or `hpa-plus-backend/public/`). Copy it to `hpa-plus-frontend/public/HPA-Plus-Logo.png` so the frontend can reference `/HPA-Plus-Logo.png`.
- **Placement:**
  - **Navbar:** Replace the current avatar + “HPA Plus” text block with the logo image. Show the logo in the top-left of the app bar. Size: height ~40–48px, width auto (preserve aspect ratio). Use a white or light version if the file includes one; otherwise ensure the logo works on the navy background (e.g. white/light logo or add a light background pill only if needed).
  - **Mobile drawer:** Use the same logo at the top of the drawer (same sizing rules).
- **Fallback:** If the image fails to load, keep a minimal text “HPA Plus” so the navbar never looks broken.
- **Link:** Clicking the logo should go to `#home` or `/` (landing home).

**Check:** The first thing users see in the header is the real HPA Plus logo, not a generic icon.

---

## 2. Hero Section Buttons — Fix & Clarify

- **Primary CTA (“Start Free Trial”):**
  - One clear primary button: solid CTA blue (`#2F80ED`–`#3A86FF`), white text, sufficient size (e.g. `size="x-large"`), rounded (e.g. `rounded="xl"`).
  - No competing visuals: no duplicate glow or gradient that makes it look “cheap.” Optional: very subtle gradient and one soft shadow only.
  - Hover: slight lift (e.g. `translateY(-2px)` to `-4px`) and slightly stronger shadow. **No** bobbing or looping animation.
  - Icon: single arrow (e.g. `mdi-arrow-right`) on the end; keep it minimal.
  - Ensure contrast: white text on CTA blue meets WCAG AA (ideally AAA).

- **Secondary CTA (“Watch Demo” or “Book a free demo”):**
  - Clearly secondary: outlined style (white border on navy hero), transparent or very subtle fill. Text and icon white (or near-white).
  - Do **not** use black text on the hero (poor contrast and inconsistent with “white on navy”).
  - Hover: light background tint (e.g. `rgba(255,255,255,0.1)`) and optional slight lift.
  - If “Watch Demo” has no URL yet, either link to a placeholder (e.g. `#demo`) or use “Book a free demo” and link to contact/login.

- **Spacing & hierarchy:** Primary and secondary sit side by side on desktop with a small gap; on mobile they can stack, primary on top. No third button competing with these two.

**Check:** One obvious primary action and one clear secondary; both readable and clickable; no bobbing or outdated motion.

---

## 3. Loading Screen

- **When:** Show a full-page loading screen on first load of the landing (or app shell) until the main content is ready. Hide it when the landing (or first route) has mounted and optionally after a minimum display time (e.g. 800–1200 ms) to avoid flash.
- **Content:**
  - Centered HPA Plus logo (`/HPA-Plus-Logo.png`) at a comfortable size.
  - Optional short line: “Loading…” or “HPA Plus” underneath in muted text.
  - **No** spinner that bounces up and down. Prefer: subtle fade-in of the logo, then a minimal progress indicator (e.g. thin bar at bottom or a low-key indeterminate loader) or a simple opacity pulse on the logo—smooth and calm.
- **Style:**
  - Background: same as hero (e.g. `linear-gradient(180deg, #0E2038 0%, #132A46 100%)`) or solid navy so the transition to the hero feels seamless.
  - No heavy animation: no bobbing, no spinning logos.
- **Implementation:** Use a global loading state (e.g. in `App.vue` or a layout) that wraps the router-view; when the landing route is ready and (optionally) min time has passed, set `loading = false` and transition out (e.g. fade) over ~300 ms.

**Check:** First paint shows brand (logo + calm loader), then a smooth handoff to the landing content.

---

## 4. White / Off-White Background Patterns

- **Reference:** The current hero uses a dark navy background with subtle **organic, scattered dot/speck** patterns (light on dark). Reuse that **style** for sections that use white or off-white (`#FFFFFF`, `#F7F9FC`).
- **Implementation:**
  - On **white** (`#FFFFFF`) sections: use very subtle dots/specks in a **dark** tone (e.g. `rgba(14, 32, 56, 0.04)` to `0.08`) so the pattern is visible but not noisy. Same idea: irregular, organic placement; not a rigid grid.
  - On **off-white** (`#F7F9FC`) sections: same approach—slightly darker or same opacity so the pattern reads as texture, not decoration.
- **Technique:** CSS-only is fine: e.g. a pseudo-element or a div with `background-image: radial-gradient(circle, ...)` repeated, or a small SVG pattern. Keep it performant (no huge images). The goal is **depth and polish**, not distraction.
- **Where:** Apply to at least: Features section, Testimonials section, Pricing section (or alternate white/off-white sections as per `RESTYLE_PROMPT_HPA_PLUS.md`).

**Check:** Light sections feel as considered as the hero: subtle texture, no flat “blank” white.

---

## 5. Icons — Professional, Modern Style

- **Problem:** Too many icons and mixed styles can feel busy or inconsistent.
- **Rules:**
  - **Single set:** Use one icon set across the landing (e.g. Material Design Icons already in use). Do not mix multiple icon libraries.
  - **Consistent weight:** Prefer one style per context—e.g. **outline** for nav and list items, **filled** only for primary emphasis (e.g. star rating, primary CTA icon). Or the reverse, but be consistent.
  - **Size and spacing:** Use a small set of sizes (e.g. 20, 24, 32) and consistent spacing (e.g. `start`/`end` with 8–12px). Avoid one-off huge icons unless it’s a hero trust badge.
  - **Color:** On navy: white or near-white. On white/off-white: primary text (`#1F2937`) or accent blue (`#2F80ED`) for emphasis. Do not introduce new accent colors.
  - **Reduce where possible:** In lists (e.g. feature bullets, footer links), consider removing redundant icons if the list is clear without them, or use a single subtle icon style (e.g. small chevron or check).
- **Trust badges (hero):** Keep NDIS Compliant, Bank-level Security, 4.9/5 Rating but style them with the same icon set and one clear style (e.g. outline in a circle, or simple filled symbol on a soft background). No cartoonish or playful icons.

**Check:** Icons feel like one system: professional, modern, and not overwhelming.

---

## 6. Animations — Modern, No “Up and Down”

- **Avoid:** Bobbing, floating up-and-down loops, spinning logos, or anything that feels like early-2000s web.
- **Prefer:**
  - **Scroll-triggered:** Fade-in and short upward motion (e.g. `translateY(20–30px)` → `0`) when sections enter the viewport. Use one easing (e.g. `cubic-bezier(0.4, 0, 0.2, 1)`) and modest duration (e.g. 0.5–0.8s). Stagger children (e.g. cards) by a small delay (0.05–0.15s).
  - **Hero:** Fade-in and slight upward motion for headline, subtitle, and buttons with staggered delays. No continuous bobbing.
  - **Hover:** Subtle lift (`translateY(-2px)` to `-4px`), shadow increase, and optionally a soft scale (e.g. 1.02) on cards and primary button. Transition ~0.3s.
  - **Scroll indicator (chevron):** If kept, a gentle opacity pulse or a single “breathe” (scale or opacity) is fine; remove any looping bounce.
- **Performance:** Prefer CSS `transform` and `opacity`; avoid animating layout-heavy properties. If using Intersection Observer for scroll animations, disconnect or throttle when not needed.

**Check:** Motion supports clarity and polish; nothing feels gimmicky or dated.

---

## 7. Overall “Feel” — The Site Feels Good

- **Trust:** First screen (hero) should communicate: professional, compliant, and “for NDIS & Aged Care.” Use the real logo, clear headline (“Grow your NDIS business on the go”), one primary CTA, and trust badges (NDIS Compliant, Security, Rating) without clutter.
- **Clarity:** Clear sections (Features, Testimonials, Pricing, CTA, Footer), consistent headings and spacing, and enough white space so the page breathes.
- **Consistency:** Same navy/CTA blue/white system from navbar through footer; same button treatment for “Start Free Trial” and “Book a demo” across the page.
- **Quality cues:** Subtle patterns on light sections, consistent icons, calm loading screen, and modern (non-bobbing) animations all signal care and quality.
- **Reference:** Compare to [hpaplus.com.au](https://hpaplus.com.au/) and ensure this implementation feels **more** coherent, **more** modern, and **more** trustworthy—not just different.

**Check:** A stakeholder would say “this feels like a better, more professional version of HPA Plus.”

---

## 8. Implementation Checklist

- [ ] **Logo:** Copy `HPA-Plus-Logo.png` to `hpa-plus-frontend/public/`; use it in navbar and mobile drawer; link to home.
- [ ] **Hero buttons:** Primary = one solid CTA blue button (no black text on hero); secondary = outlined white; hover = lift + shadow, no bobbing.
- [ ] **Loading screen:** Full-page loader with logo and calm indicator; navy background; hide when landing is ready (with optional min time); smooth fade-out.
- [ ] **White patterns:** Subtle organic dot/speck pattern on white and off-white sections (CSS or small pattern asset).
- [ ] **Icons:** One set, consistent weight (outline vs filled), limited sizes and colors; reduce redundancy where it doesn’t hurt clarity.
- [ ] **Animations:** Scroll-based fade-in + slight upward motion; hover lift/shadow; no bobbing or spinning.
- [ ] **Feel:** One pass for trust, clarity, consistency, and quality cues so the landing clearly beats the current site in first impression.

Use this prompt together with `RESTYLE_PROMPT_HPA_PLUS.md` for colors, typography, and section structure. If something isn’t specified here, default to: **navy for authority, CTA blue for action, white/off-white for clarity, and a professional NDIS/Aged Care tone.**
