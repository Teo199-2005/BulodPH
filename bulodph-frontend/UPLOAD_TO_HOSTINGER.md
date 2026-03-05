# Upload frontend to Hostinger – exact paths on your PC

Use **Replace** when Hostinger asks about overwriting files.

---

## 1. Open this folder on your PC

```
c:\Users\Cocotantan\Downloads\BulodPH\bulodph-frontend\dist
```

That folder should contain:
- **index.html**
- **assets** (folder with .js and .css)
- **images** (folder with climpek.svg, payments/, etc.)
- **vite.svg**

---

## 2. Upload to Hostinger `public_html`

In **File Manager** go to **public_html**, then upload so it matches this:

| On your PC (dist folder) | Upload to Hostinger (public_html) |
|--------------------------|------------------------------------|
| `dist\index.html` | **public_html\index.html** (Replace) |
| `dist\assets` (entire folder) | **public_html\assets** (Replace / merge so all files inside are there) |
| `dist\images` (entire folder) | **public_html\images** (Replace / merge) |
| `dist\vite.svg` | **public_html\vite.svg** (Replace) |

---

## 3. Logo (not in dist)

Your project has **no logo.png** in `public`. The app expects **/logo.png**.

- If you already have **logo.png** on Hostinger in **public_html**, leave it there.
- If not: add **logo.png** to  
  `c:\Users\Cocotantan\Downloads\BulodPH\bulodph-frontend\public\logo.png`  
  run **npm run build** again, then upload the new **dist** (or upload that **logo.png** to **public_html\logo.png** on the server).

---

## 4. Result on the server

After uploading, **public_html** should contain:

- index.html  
- index.php (Laravel – do not remove)  
- .htaccess (production one – do not overwrite with old)  
- assets\ (with many .js, .css)  
- images\ (with climpek.svg, payments\gcash.svg, maya.svg, etc.)  
- vite.svg  
- logo.png (if you added/uploaded it)  
- bulodph-backend\ (Laravel – do not remove)

---

## Quick copy-paste paths (PC)

- **Main folder to upload from:**  
  `c:\Users\Cocotantan\Downloads\BulodPH\bulodph-frontend\dist`

- **Single file:**  
  `c:\Users\Cocotantan\Downloads\BulodPH\bulodph-frontend\dist\index.html`  
  `c:\Users\Cocotantan\Downloads\BulodPH\bulodph-frontend\dist\vite.svg`

- **Folders:**  
  `c:\Users\Cocotantan\Downloads\BulodPH\bulodph-frontend\dist\assets`  
  `c:\Users\Cocotantan\Downloads\BulodPH\bulodph-frontend\dist\images`

When asked to replace, choose **Replace** so the latest build is live.
