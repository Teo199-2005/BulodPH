# Landing Page Section Texture Prompt

Use this prompt to transform the landing page so that **section-light** and **section-dark** (with their background textures) are applied only to the **content sections between the hero and the footer**. The hero and footer must **not** use these texture classes.

---

## Instructions

1. **Keep these CSS definitions exactly as-is** (used only by the middle sections):

   ```css
   .section-light {
     background-color: #ffffff;
     background-image: url("https://www.transparenttextures.com/patterns/batthern.png");
     background-repeat: repeat;
     background-position: 0 0;
     background-size: 100px 100px;
     background-origin: padding-box;
     min-height: 1px;
   }

   .section-dark {
     background-color: #dbeafe;
     background-image: url("https://www.transparenttextures.com/patterns/dotnoise-light-grey.png");
     background-repeat: repeat;
     background-position: 0 0;
     background-size: 100px 100px;
     background-origin: padding-box;
     min-height: 1px;
   }
   ```

2. **Hero section**
   - **Remove** the class `section-light` from the hero `<section>`.
   - Leave only `hero-section` (and any other non-texture classes like `id="home"`).
   - The hero keeps its own background (e.g. solid colour or gradient). Do **not** apply `.section-light` or `.section-dark` or their texture images to the hero.

3. **Footer**
   - **Remove** the class `section-light` from the footer `<footer>`.
   - Leave only `footer-section` (and any other non-texture classes like `id="contact"`).
   - The footer keeps its own background. Do **not** apply `.section-light` or `.section-dark` or their texture images to the footer.

4. **Middle sections (between hero and footer)**
   - **Keep** alternating `section-light` and `section-dark` on these sections only:
     - Trust: `section-dark`
     - Features: `section-light`
     - Testimonials: `section-dark`
     - Pricing: `section-light`
     - CTA: `section-dark`
   - These are the only areas that use the batthern (white) and dotnoise (light blue) textures.

5. **CSS specificity**
   - If any existing rules target `.hero-section.section-light` or `.footer-section.section-light`, update them so they target `.hero-section` and `.footer-section` only (no `.section-light`), and define the hero/footer backgrounds there so hero and footer never use the texture URLs.

**Result:** From top to bottom: Hero (no texture) → alternating textured sections (Trust, Features, Testimonials, Pricing, CTA) → Footer (no texture). The batthern and dotnoise patterns are used only in the middle content blocks, not on the hero or footer.
