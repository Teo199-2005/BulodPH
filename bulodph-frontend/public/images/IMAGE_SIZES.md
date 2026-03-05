# Landing Page – Image Dimensions

All dimensions are **width × height** in pixels. Aspect ratios match the image files so containers can use `aspect-ratio: width / height` to avoid cropping.

**Note:** Some files have a `.png` extension but are actually JPEG or WebP; the table shows the real format.

---

## Local images (used on landing page)

| Path | Width | Height | Aspect ratio | Format | Container in LandingPage.vue |
|------|-------|--------|--------------|--------|-----------------------------|
| `/logo.png` | 526 | 192 | 2.74 | PNG | Navbar, footer (height constrained) |
| `/images/hero-banner.png` | 1024 | 489 | 2.094 | JPEG | `.hero-image-container` → `1024 / 489` |
| `/images/hero-adventure.png` | 1024 | 367 | 2.79 | JPEG | Adventure billboard (full-bleed). **For sharp quality:** use a 1920px-wide or `@2x` version and add `srcset` so it isn’t upscaled on wide screens. |
| `/images/explore-philippines.png` | 1024 | 1024 | 1 (square) | JPEG | `.explore-image-wrap` → `1 / 1` |
| `/images/beat-the-traffic.png` | 1024 | 1024 | 1 (square) | JPEG | `.traffic-image-wrap` → `1 / 1` |

---

## Other local images (public/images)

| Path | Width | Height | Aspect ratio | Format |
|------|-------|--------|--------------|--------|
| `/images/hero-grid.png` | 1024 | 535 | 1.91 | JPEG |
| `/images/hero-bg.png` | 1920 | 1080 | 16 / 9 | JPEG |
| `/images/partners/aims-healthcare.png` | 805 | 180 | 4.47 | PNG |
| `/images/partners/amg-victoria.png` | 805 | 180 | 4.47 | PNG |
| `/images/partners/awesome-healthcare.png` | 805 | 180 | 4.47 | PNG |
| `/images/partners/denat-support-services.png` | 805 | 180 | 4.47 | PNG |
| `/images/partners/filled-with-hope.png` | 805 | 180 | 4.47 | PNG |
| `/images/partners/inclusive-abilities-care.png` | 805 | 180 | 4.47 | PNG |
| `/images/people/caregiver-elderly.png` | — | — | — | WebP |
| `/images/people/client-hearing-aid.png` | — | — | — | WebP |
| `/images/people/engagement-phone.png` | — | — | — | WebP |

People images are WebP; dimensions not read by the current script.

---

## Auth pages – right-side panel (Login / Register)

The right panel (hero side) uses **`/images/hero-banner.png`** with `background-size: cover` and `background-position: center`. The panel size is **50% of viewport width × 100% viewport height** (e.g. 960×1080 on a 1920×1080 screen), so it’s always **taller than wide** (portrait-like).

| Use | Ideal dimensions (W×H) | Aspect ratio | Notes |
|-----|------------------------|--------------|--------|
| Auth hero background | **1200×1350** (min) or **1920×2160** (@2x) | ~1 : 1.12 (portrait) | Matches panel shape; minimal cropping with `cover` + `center`. |

- **Why this ratio:** The visible area is roughly 9:10 (e.g. 960×1080). An image at ~1:1.12 fills the panel with little crop; landscape images will crop heavily on the sides.
- **Current file:** `hero-banner.png` is 1024×489 (landscape). It still works with `cover` but the center strip is what shows; for a better fit use a portrait image at the dimensions above.

---

## External images (Unsplash, etc.)

Used via `IMAGES` in `src/constants/images.ts`. URLs include a `w=` parameter (requested width); actual delivered size may vary.

| Constant / use | Requested width | Typical aspect |
|----------------|-----------------|----------------|
| Hero fallback `IMAGES.hero.carScenic` | 1200 | crop |
| Featured rides (cars.sedan, hatchback, suv, roadScenic) | 800 | crop |
| Testimonial avatars | 200 | crop |
| App screenshot (footer) `IMAGES.appScreenshots.loginStaff` | 400 | crop |

Use the **local** image dimensions above to set container `aspect-ratio` so the image fills without unwanted cropping.
