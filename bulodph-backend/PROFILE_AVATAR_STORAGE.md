# Profile / avatar upload – where it’s stored and why admin may not see it

## Where the profile photo is stored

When a user (e.g. Demo Client) uploads a photo from **Profile** in the app:

### 1. Backend API

- **Endpoint:** `POST /api/profile/avatar`  
- **Controller:** `App\Http\Controllers\Api\CarRentalStubController::profileAvatar`  
- **Route:** defined in `routes/api.php` (inside `auth:sanctum` group).

### 2. File on disk

- **Disk:** `public` (see `config/filesystems.php`).
- **Path:** `storage/app/public/avatars/{user_id}/{random_filename}`  
  e.g. `storage/app/public/avatars/a12535dd-84fe-436e-b02e-a83a458891f1/abc123.jpg`
- **Public URL:** Generated with `Storage::url($path)` and `url()`, so the value saved in the DB is:
  - **`APP_URL` + `/storage` + relative path**  
  e.g. `http://localhost:8000/storage/avatars/a12535dd-.../abc123.jpg`
- **No extra env** for the path; it’s fixed in code. The only env that affects the **saved URL** is **`APP_URL`** (see `config/filesystems.php` → `public` disk → `'url' => env('APP_URL').'/storage'`).

So:

- **`.env`:** Set `APP_URL` to the URL where the backend is served (e.g. `http://localhost:8000` when using `php artisan serve`). If `APP_URL` is wrong, avatar links in the DB will be wrong and images won’t load for anyone (including admin).
- **Symlink:** Run once:  
  `php artisan storage:link`  
  so that `public/storage` → `storage/app/public` and `/storage/avatars/...` is served correctly.

### 3. Database

- **`users.avatar_url`** – always updated when a user uploads an avatar.
- **`client_profiles.avatar_url`** – also updated when the user has the **client** role (same URL as above).

So the “profile that is uploading from here” is stored in:

1. **Files:** `storage/app/public/avatars/{user_id}/...` (no env for path; `APP_URL` affects the URL only).  
2. **DB:** `users.avatar_url` and, for clients, `client_profiles.avatar_url`.

---

## Why the admin might not see new profile pics

The admin Clients list and client detail use **GET /api/admin/clients** and **GET /api/admin/clients/{id}**. They return `avatar_url` from the database (preferring `client_profiles.avatar_url`, then `users.avatar_url`). If the admin doesn’t see new avatars, it’s usually one of these:

1. **Wrong database**  
   Backend must use the **same** MySQL database you’re looking at in phpMyAdmin.  
   - In **`.env`** set:  
     `DB_DATABASE=hpa_plus`  
     (or whatever your real DB name is; `.env.example` uses `bulodph`).  
   - If the app uses `bulodph` but you check `hpa_plus` in phpMyAdmin, you won’t see updates there, and the admin app is reading from `bulodph`, so keep DB name consistent everywhere.

2. **Wrong `APP_URL`**  
   If `APP_URL` is wrong (e.g. missing port or wrong host), the URL stored in `users.avatar_url` / `client_profiles.avatar_url` will be wrong and the image won’t load for the admin (or for the client when they reload). Set `APP_URL` to the exact URL of your backend (e.g. `http://localhost:8000`).

3. **Storage link missing**  
   If `php artisan storage:link` was never run, requests to `/storage/avatars/...` will 404. Run it once so `public/storage` points to `storage/app/public`.

4. **Client role / permissions**  
   For **clients**, the controller also updates `client_profiles.avatar_url`. If the user doesn’t have the “client” role in the same organization (Spatie permissions team), only `users.avatar_url` is updated; the admin API still returns that, so this alone usually doesn’t explain “admin sees nothing” if `users.avatar_url` is set.

5. **Cache**  
   Admin UI may cache the list; use a full refresh (e.g. Ctrl+F5) or the Refresh button on the Clients page so it refetches and gets the latest `avatar_url` from the API.

---

## Quick checklist

- [ ] **`.env`:** `DB_DATABASE` = the database you use (e.g. `hpa_plus`).  
- [ ] **`.env`:** `APP_URL` = backend URL (e.g. `http://localhost:8000`).  
- [ ] Run **`php artisan storage:link`** once.  
- [ ] After a client uploads, check in phpMyAdmin that **`users.avatar_url`** (and for clients **`client_profiles.avatar_url`**) are updated in **that same DB**.  
- [ ] Admin: hard refresh or click Refresh on the Clients page so the new `avatar_url` is loaded.
