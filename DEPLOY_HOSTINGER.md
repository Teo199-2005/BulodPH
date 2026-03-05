# Deploy BulodPH to Hostinger (Vue frontend + Laravel API)

Your app has two parts:
- **Frontend (Vue)** – the website users see at https://bulodph.com
- **Backend (Laravel API)** – runs at https://bulodph.com/api (same server)

Locally you run `php artisan serve` (backend) and `npm run dev` (frontend). On Hostinger you serve the **built** frontend and the API from the same domain.

---

## 1. Build the Vue frontend for production

On your PC, in the **bulodph-frontend** folder:

```bash
cd bulodph-frontend
npm install
npm run build
```

This creates a **`dist/`** folder with `index.html` and an **`assets/`** folder (JS, CSS). The build uses **`.env.production`**, which sets `VITE_API_URL=/api` so the app calls your API at `https://bulodph.com/api`.

---

## 2. Upload to Hostinger

In **File Manager** go to **`public_html`**. You should already have:

- `index.php` (Laravel entry)
- `bulodph-backend/` (Laravel app)
- Maybe other files

Do this:

1. **Upload the Vue build**
   - From your PC open **`bulodph-frontend/dist/`**.
   - Upload **`index.html`** into **`public_html`** (same level as `index.php`).
   - Upload the **`assets`** folder into **`public_html`** (so you have `public_html/assets/` with JS and CSS inside).

2. **Use the production .htaccess**
   - In the project you have **`bulodph-backend/public/.htaccess.production`**.
   - Copy its contents and put them in **`public_html/.htaccess`** (overwrite the existing one), **or** upload that file as **`public_html/.htaccess`**.

   That `.htaccess` does:
   - **/api** and **/api/** → Laravel (`index.php`)
   - **Existing files** (e.g. `/assets/xxx.js`) → served as-is
   - **Everything else** (e.g. `/`, `/login`) → Vue app (`index.html`)

3. **Keep Laravel as-is**
   - Leave **`public_html/index.php`** and **`public_html/bulodph-backend/`** as they are. The API is already under `/api`.

---

## 3. Check the result

- **https://bulodph.com** → Vue app (login, pages, etc.).
- **https://bulodph.com/api** → Laravel API (e.g. JSON or your API docs).

If you see the API JSON on the main URL, the new `.htaccess` is not in place or not applied. Make sure **`public_html/.htaccess`** contains the rules that send **/api** to **index.php** and everything else to **index.html**.

---

## 4. Optional: fix 500 on the main site

If the site still returns 500:

- Set **`SESSION_DRIVER=file`** and **`CACHE_STORE=file`** in **`public_html/bulodph-backend/.env`** (temporary), and/or
- Check **`public_html/bulodph-backend/storage/logs/laravel.log`** and the server **Error log** in hPanel for the real error.

---

## Summary

| Local | Production (Hostinger) |
|-------|-------------------------|
| `php artisan serve` (port 8000) | Laravel handles **/api** only |
| `npm run dev` (port 5173) | Built Vue (**index.html** + **assets**) served at **/** |
| Frontend calls `http://localhost:8000/api` | Frontend calls **/api** (same domain) |

Build → upload **dist/index.html** and **dist/assets/** to **public_html** → use **.htaccess.production** as **public_html/.htaccess** → visit **https://bulodph.com**.
