# BulodPH – Section-by-Section Restyle Guide

Top-to-bottom audit with concrete suggestions so **no section feels like "text + image"**. Each section gets a different layout, container, and typography approach.

---

## 1. Hero

| Current | Suggestion |
|--------|------------|
| 2-col: image left, content right; v-container | **Keep** as main hero, but differentiate with **layout**: use a **wider container** (e.g. `max-width: 1280px`) and **asymmetric split** (e.g. 45% image / 55% content) so it doesn’t match later sections. |
| **Font:** Same as rest of page | **Typography:** Give hero a distinct scale: **one display font** for the headline only (e.g. `font-family: 'Plus Jakarta Sans'` or `'Outfit'` for the H1 only), rest stay DM Sans. Slightly **tighter letter-spacing** on the headline (e.g. `-0.04em`). |
| Trust bar at bottom | Keep; already breaks the “one big image” feel. |

**Avoid:** Making the next sections use the same 50/50 image+text pattern.

---

## 2. Stats bar

| Current | Suggestion |
|--------|------------|
| Centered row, dividers | **Container:** Full-bleed (no max-width) or **narrow band** (e.g. max-width 800px) so it reads as a “strip,” not a content block. |
| Same font as body | **Font:** Slightly **different weight/size** for numbers: e.g. tabular numbers (`font-variant-numeric: tabular-nums`), and **lighter label** (e.g. 0.7rem, uppercase, letter-spacing 0.15em) so it feels like a “data bar,” not body copy. |

**Feel:** Keep it as a **utility strip** (stats only, no paragraphs).

---

## 3. Logo wall (Ride in the region)

| Current | Suggestion |
|--------|------------|
| Centered cities as text | **Layout:** Either (a) **horizontal scroll** with `overflow-x: auto` and subtle fade edges, or (b) **two rows** with different font sizes (bigger cities / smaller “& more”). |
| Plain text list | **Typography:** Use **medium weight** for city names and a **muted “Available in”** label (small caps, gray). Optional: small **location pin icon** before the list. |
| Same container as others | **Container:** Full width; inner content **max-width 900px** centered so the strip doesn’t feel like a content column. |

**Feel:** “Trust bar / presence” strip, not a content section.

---

## 4. Adventure Awaits

| Current | Suggestion |
|--------|------------|
| Centered title + one image card + CTA under image | **Layout:** Make it **not** “text + image side by side”: keep **one focal block** (image + CTA) but add a **small overline** (e.g. “Road trips”) and **short headline only** above the card; move sub copy **inside** the card or **below** the CTA as a one-liner. So the section is “headline → one visual card,” not two columns. |
| Same container | **Container:** Slightly **narrower** content (e.g. max-width 720px for the card) so it feels like a “feature spotlight,” not a full-width grid. |
| Same title font | **Font:** Slightly **larger title** (e.g. clamp 2rem–2.75rem), **lighter sub** (400 weight, 1rem). |

**Feel:** One **hero-style card** (image + CTA), not a text column + image column.

---

## 5. Ribbon

| Current | Suggestion |
|--------|------------|
| Skewed band, one line + CTA | **Layout:** Keep. Optional: **two ribbons** on the site (one promo, one “Trusted in the region”) with **different colors** (e.g. one navy, one accent) so they’re clearly different. |
| — | **Font:** Slightly **bolder** code (e.g. 800) and **same or smaller** rest; keep one line. |

**Feel:** Stays a **banner**, not content.

---

## 6. Explore the Philippines

| Current | Suggestion |
|--------|------------|
| **Card with text left + image right** → classic “text + image” | **Layout change:** Turn into **full-bleed background image** with **overlay**. One big photo (explore-philippines), dark overlay (e.g. `rgba(0,0,0,0.4)`), **centered** title + one paragraph + tags + CTA. **No side-by-side** text and image. |
| Card with max-width 1100px | **Container:** Section **full width**; content **narrow column** (e.g. 560px) centered over the image so it’s clearly “billboard” not “card with two columns.” |
| Same title style | **Font:** **White/light** title and sub (e.g. 2rem title, 1.1rem body); tags as **pill chips** (outline style) on the overlay. |

**Feel:** **One big visual** with overlaid copy (like Airbnb/travel heroes), **not** text block + image block.

---

## 7. Beat the Traffic

| Current | Suggestion |
|--------|------------|
| **Image left + text right** → again “text + image” | **Layout change:** Make it **opposite** of Explore: **text-first section** with **no big image** in the main flow. Use a **small decorative visual** (icon, illustration, or small photo in a circle/rounded square) **above** or **beside** the headline, and **list + CTA** below. Or: **image as a small “floating” card** (e.g. 280px wide) overlapping the content block so the section is “content + accent visual,” not 50/50. |
| Same grid as Explore (reversed) | **Container:** **Narrow content column** (e.g. 520px) with **optional right margin** where a small image sits; or full-width with **floating image card** (absolute position) so layout is asymmetric. |
| Same fonts | **Font:** **Overline** (e.g. “City mobility”) in small caps; **headline** a bit bolder; **benefits** as short bullets with icons (already there). |

**Feel:** **Content-first** (copy + list + CTA) with a **supporting visual**, not “half image, half text.”

---

## 8. Single-column (Why peer-to-peer?)

| Current | Suggestion |
|--------|------------|
| Narrow centered text + CTA | **Layout:** Keep single column; add **one visual cue**: e.g. **large quotation mark** or **simple line illustration** above the title (not a photo) so it’s “editorial + one graphic,” not “text only.” |
| 640px inner | **Container:** Keep **640px**; consider **slightly larger body** (1.125rem) and **more line-height** (1.75) for an “article” feel. |
| Same font | **Font:** Optional **serif for body** (e.g. Lora, 1.125rem) and **sans for title** to make it feel like a “story” block. |

**Feel:** **Editorial / story** section, not a CTA card.

---

## 9. How It Works

| Current | Suggestion |
|--------|------------|
| Header + 3 cards in a row | **Layout:** Keep 3 steps but **change the container**: (a) **timeline** (vertical line + steps stacked on mobile; horizontal on desktop), or (b) **numbered list** with large numbers (e.g. 01, 02, 03) and **no card boxes** — just icon + title + text + list with generous spacing. So it’s “steps” not “three same cards.” |
| Cards with left border | **Container:** **Wider** (e.g. 1000px) so the three items don’t look cramped; or **narrower** (720px) with **vertical timeline** and steps stacked. |
| Same badge + title | **Font:** **Larger step numbers** (e.g. 3rem, light weight) and **short titles**; body can stay 0.9375rem. |

**Feel:** **Process / timeline**, not “three image-less cards.”

---

## 10. Featured Rides

| Current | Suggestion |
|--------|------------|
| Header + 3 product cards (image + body) | **Layout:** Keep cards but **vary the grid**: (a) **one featured large card** (2 cols) + **two smaller** (1 col each), or (b) **horizontal scroll** (e.g. 3 cards, scroll on mobile) with **visible next/prev** so it’s “carousel / showcase” not “static row.” |
| 3 equal cards | **Container:** **Wider** (1200px) with **more gap** between cards, or **narrower** (960px) with **one card emphasized** (bigger image + different background). |
| Same card style | **Font:** **Vehicle type** more prominent (e.g. 1.25rem); **price** as the main accent (already bold); **description** slightly smaller (0.875rem). |

**Feel:** **Product showcase** (or “hero + list”), not “three identical blocks.”

---

## 11. Why BulodPH (bento)

| Current | Suggestion |
|--------|------------|
| Bento grid (one tall, three small) | **Layout:** Keep bento; optionally **different shapes**: e.g. one **wide** card (span 2 cols) at top, two **square** below, so the grid isn’t “one tall + column.” Or **icon-only** top row + **text** below. |
| Same card style | **Container:** Keep max-width 900px; **font:** **Title** bolder (700), **description** slightly smaller (0.875rem) so cards feel “headline + support,” not paragraph blocks. |

**Feel:** **Feature grid** (already not “text + image”); refine for hierarchy.

---

## 12. Testimonials

| Current | Suggestion |
|--------|------------|
| 3 quote cards in a row | **Layout:** (a) **Carousel** (one visible, swipe/arrows) so it’s “voices” not “three blocks,” or (b) **one large featured quote** + two smaller, or (c) **single full-width quote** with big type and **avatar + name below** (no card box). |
| Card with top accent | **Container:** **Narrow** (e.g. 680px) if single-quote; **wide** (1100px) if keeping 3 with more gap. |
| Same font | **Font:** **Quote** larger (1.25rem) and **italic** or **serif**; **name/role** small caps or smaller size so it reads “testimonial” not “card text.” |

**Feel:** **Social proof / quotes**, not “three same cards.”

---

## 13. CTA (Ready to borrow or share?)

| Current | Suggestion |
|--------|------------|
| Card with content + app image + steps | **Layout:** **Split:** (a) **Full-width band** (gradient or solid) with **only** headline + two CTAs + one line of trust (no app image in the main CTA), or (b) keep app image but as **background** (blurred or right-aligned) so the section is “one CTA strip” not “card with two columns.” |
| Same container | **Container:** **Full width** for the band; inner content **max-width 600px** centered so it’s “one message,” not a wide card. |
| Same font | **Font:** **Headline** larger (e.g. 2rem); **sub** one short line; **steps** optional (or move to footer). |

**Feel:** **Final CTA band** (like “Get started”), not another content card.

---

## 14. Footer

| Current | Suggestion |
|--------|------------|
| Multi-column + map + newsletter | **Layout:** Keep structure; **typography:** **Headings** more distinct (e.g. 0.7rem uppercase, letter-spacing 0.12em); **links** 0.875rem; **tagline** slightly smaller. **Container:** Keep; ensure **max-width** is consistent with the rest of the site. |

**Feel:** Stays **footer**; refine hierarchy.

---

## Quick reference: “Feel” per section

| # | Section            | Current feel           | Target feel                    |
|---|--------------------|------------------------|--------------------------------|
| 1 | Hero               | 2-col intro            | Asymmetric hero, display font  |
| 2 | Stats bar          | Data strip             | Keep strip; refine numbers     |
| 3 | Logo wall          | City list              | Strip / scroll; not content    |
| 4 | Adventure Awaits   | One card               | One spotlight card, not 2-col  |
| 5 | Ribbon             | Banner                 | Keep banner                    |
| 6 | Explore            | **Text + image card**  | **Full-bleed image + overlay** |
| 7 | Beat the Traffic   | **Image + text**       | **Content + small/floating visual** |
| 8 | Why P2P            | Editorial              | Story block + one graphic      |
| 9 | How It Works       | 3 cards                | Timeline or big numbers        |
|10 | Featured Rides     | 3 cards                | Showcase / 1 big + 2 small     |
|11 | Why BulodPH        | Bento                  | Keep; refine type             |
|12 | Testimonials       | 3 cards                | Carousel or 1 big quote        |
|13 | CTA                | Card + image           | One CTA band                  |
|14 | Footer             | Links + map            | Refine hierarchy              |

---

## Typography summary

- **Hero H1:** One display font (e.g. Plus Jakarta Sans, Outfit), rest DM Sans.
- **Section titles:** Keep one system (e.g. DM Sans 800); vary **size** and **overline** per section.
- **Body:** 1rem–1.125rem; **editorial** (Why P2P) can use 1.125rem + serif.
- **Labels/badges:** 0.6875rem–0.75rem, uppercase, letter-spacing 0.1–0.12em.
- **Numbers/stats:** Tabular figures; bold for numbers, light for labels.

---

## Container width summary

| Section     | Suggested max-width (content) |
|------------|---------------------------------|
| Hero       | 1280px (wider)                  |
| Stats      | Full width (inner ~800px)       |
| Logo wall  | Full width (inner ~900px)       |
| Adventure  | 720px (narrower card)            |
| Explore    | Full-bleed; text column 560px   |
| Traffic    | 520px content + floating visual |
| Why P2P    | 640px (keep)                     |
| How It Works | 1000px or 720px timeline      |
| Featured   | 960px or 1200px                 |
| Why BulodPH| 900px (keep)                     |
| Testimonials | 680px (single) or 1100px      |
| CTA        | 600px centered                   |

Use this as a checklist: implement **Explore as full-bleed** and **Beat the Traffic as content-first + small visual** first, then **How It Works as timeline**, **Featured as 1+2**, and **Testimonials as carousel or single quote** so no section feels like the same “text + image” block.
