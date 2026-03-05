# Images for production (Hostinger)

The app loads images from these paths. They must exist **either** in `public/` before `npm run build` (so they’re in `dist/`) **or** be uploaded to the same paths in `public_html` on the server.

## Root

| Path on site | File to have |
|--------------|----------------|
| `/logo.png` | `public/logo.png` → then build, or upload `logo.png` to `public_html/logo.png` on server |
| `/vite.svg` | Already in `public/` → in `dist/` after build |
| `/og-image.png` | Optional; add to `public/` if you use OG image |
| `/favicon.ico` | Optional; add to `public/` if you use it |

## Under `/images/`

| Path | Notes |
|------|--------|
| `/images/climpek.svg` | In `public/images/` → in `dist/images/` after build |
| `/images/login-hero.png` | Auth pages – add to `public/images/` or upload to `public_html/images/` |
| `/images/auth-hero.png` | Auth pages |
| `/images/register-hero.png` | Auth pages |
| `/images/hero-bulod-ph.png` | Landing hero |
| `/images/hero-dot-fade.png` | Landing |
| `/images/hero-grid.png` | Landing |
| `/images/about-safe-byahe.png` | Landing |
| `/images/late-no-problem.png` | Landing |
| `/images/adventure-van.png` | Landing |
| `/images/bulod-rent-without-drama.png` | Landing |
| `/images/tap-book-drive.png` | Landing |
| `/images/bulod-dashboard-showcase.png` | Footer |
| `/images/rent-a-car-hero.png` | Register role modal |
| `/images/car-owner-hero.png` | Register role modal |
| `/images/fleet-owner-cta.png` | Public fleet view |
| `/images/partners/*.png` | Partner logos (see IMAGE_SIZES.md) |
| `/images/payments/gcash.svg` | In `public/images/payments/` |
| `/images/payments/maya.svg` | In `public/images/payments/` |
| `/images/payments/gcash.png` | If used |
| `/images/payments/maya.png` | If used |

## What to do

1. **On your PC**  
   - Put every image the app uses into `bulodph-frontend/public/` at the path above (e.g. `public/logo.png`, `public/images/login-hero.png`, …).  
   - Run `npm run build`.  
   - Upload **the whole `dist/`** to Hostinger (so `public_html/` has `index.html`, `assets/`, `images/`, `logo.png`, `vite.svg`, etc.).

2. **Or on Hostinger only**  
   - Upload each file to the same path under `public_html/` (e.g. `public_html/logo.png`, `public_html/images/login-hero.png`, `public_html/images/partners/aims-healthcare.png`, …).

After that, the site will use your images.
