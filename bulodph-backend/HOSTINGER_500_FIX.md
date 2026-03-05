# Fixing HTTP 500 on Hostinger (e.g. /api/ping, /api/login)

If **every** API request returns **500** with an **empty body**, the failure happens before your route (bootstrap or middleware). Follow these steps on the **server** (Hostinger).

## 1. See the real error (JSON in response)

- In `public_html/bulodph-backend/.env` set **temporarily**:
  - `APP_DEBUG=true`
- Redeploy or upload the updated `bootstrap/app.php` (it now returns JSON for API 500s when debug is on).
- Open: **https://bulodph.com/api/ping**
- Check the **response body** in DevTools → Network → click the request → Response. You should see JSON like:
  - `{"error":"...","file":"...","line":...}`  
  That tells you the exact exception.

## 2. Avoid cache/session file issues

On Hostinger, `storage` or `bootstrap/cache` might not be writable, which can cause 500s. Use in-memory drivers so Laravel does not write to disk for cache/session:

In `public_html/bulodph-backend/.env` set:

```env
CACHE_STORE=array
SESSION_DRIVER=array
```

Then try **https://bulodph.com/api/ping** again.

## 3. Permissions

Ensure Laravel can write logs and cache:

- `public_html/bulodph-backend/storage` and everything inside it: writable (e.g. 775 or 755, or via File Manager “Permissions”).
- `public_html/bulodph-backend/bootstrap/cache`: writable.

## 4. Logs

- **Laravel:** `public_html/bulodph-backend/storage/logs/login-error.txt` (and `laravel.log`) — exceptions are appended there.
- **Server:** In Hostinger hPanel → Advanced → Error Logs (or similar). Check the log at the time you hit `/api/ping` for PHP/LiteSpeed errors.

## 5. After fixing

Set back in `.env`:

- `APP_DEBUG=false`
- Optionally restore `CACHE_STORE` and `SESSION_DRIVER` if you fix permissions and prefer file/database drivers.
