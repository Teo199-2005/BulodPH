# Publish BulodPH via GitHub and Hostinger

Use GitHub for version control and Hostinger for hosting. Repo: **https://github.com/Teo199-2005/BulodPH**

---

## Switch to GitHub publishing (stop using old uploaded files)

If the site is still running from files you uploaded earlier and you want the live site to use the code from GitHub:

1. **Update the repo on the server**  
   In Hostinger **GIT** → **Manage Repositories** → click **Deploy** for the BulodPH repo (so `bulodph_repo` has the latest from GitHub).

2. **Replace public_html with repo code**  
   In **File Manager**:
   - Copy **bulodph_repo/deploy/public_index.php** → **public_html/index.php** (overwrite).
   - Copy **bulodph_repo/bulodph-backend/public/.htaccess.production** → **public_html/.htaccess** (overwrite).
   - Replace **public_html/bulodph-backend** with **bulodph_repo/bulodph-backend**: either delete the old `bulodph-backend` and copy the folder from `bulodph_repo`, or copy everything from `bulodph_repo/bulodph-backend` over. **Keep** your existing **public_html/bulodph-backend/.env** (and **vendor** if you have it) so the site keeps using your database and config; only replace code files.

3. **Rebuild and upload the frontend**  
   On your PC: `cd bulodph-frontend`, run `npm run build`, then upload the contents of **dist/** (e.g. **index.html** and **assets/**) into **public_html** (overwrite). So the Vue app is the one built from the repo.

4. **From now on (publishing from GitHub)**  
   - Push changes to GitHub.  
   - In Hostinger GIT click **Deploy**.  
   - Copy from **bulodph_repo** to **public_html** as in step 2 (index.php, .htaccess, bulodph-backend code; keep .env and vendor).  
   - If the frontend changed: run `npm run build` and upload **dist/** to **public_html**.

---

## 1. Push your code to GitHub

From the **BulodPH** folder (the one that contains `bulodph-backend` and `bulodph-frontend`):

```powershell
cd c:\Users\Cocotantan\Downloads\BulodPH

# First time: add all files, commit, push
git add .
git status   # optional: check what will be committed
git commit -m "Initial commit: BulodPH frontend + backend"
git push -u origin main
```

- If GitHub asks for login, use your GitHub account (or a [Personal Access Token](https://github.com/settings/tokens) if you use 2FA).
- The repo is **empty** on GitHub, so this first push will upload everything (except files in `.gitignore`: `.env`, `node_modules`, `vendor`, `dist`, etc.).

Later, after changes:

```powershell
git add .
git commit -m "Your message"
git push
```

---

## 2. Deploy to Hostinger (GIT form)

In **Hostinger hPanel** go to **Websites** → **bulodph.com** → **Advanced** → **GIT**.

Under **“Create a New Repository”** (deploy from public Git), fill in:

| Field | Value |
|-------|--------|
| **Repository** | `https://github.com/Teo199-2005/BulodPH.git` |
| **Branch** | `main` |
| **Directory (optional)** | Leave **blank** to deploy into `public_html`. |

Important: **The target directory must be empty.**  
- If `public_html` already has your live site: **back it up** (download or rename), then clear `public_html` before creating the repository, **or** create an empty folder (e.g. `repo`) and set **Directory** to `repo` (you’ll then move/copy files as needed).  
- If `public_html` is empty (new site): leave **Directory** blank and click **Create**.

After the first deploy, Hostinger will clone the repo. Then do the following.

### Right after the first Git deploy

1. **Production entry point and .htaccess**
   - In **File Manager** go to `public_html`.
   - Copy `deploy/public_index.php` to `public_html/index.php` (overwrite if it exists).
   - Copy `bulodph-backend/public/.htaccess.production` to `public_html/.htaccess`.

2. **Backend (Laravel)**
   - In `public_html/bulodph-backend/`: copy `.env.example` to `.env`, set your database and `APP_KEY`, then run `composer install --no-dev` and `php artisan migrate` (via SSH or Hostinger’s PHP / run script if available).
   - If you can’t run Composer on the server: run `composer install --no-dev` locally in `bulodph-backend`, then upload the whole `bulodph-backend` folder (including `vendor`) to `public_html/bulodph-backend/`.

3. **Frontend (Vue build)**
   - The repo does not contain the built frontend. On your PC: `cd bulodph-frontend`, then `npm run build`. Upload the contents of `bulodph-frontend/dist/` (e.g. `index.html` and `assets/`) into `public_html` so the site and assets are at the root.

4. **Later updates**
   - In Hostinger GIT, use **Pull** (or the repo’s update button) to get latest from GitHub. Then repeat step 3 (build Vue and upload `dist/`) and update backend (e.g. `composer install`, `php artisan migrate`) if needed.

### Demo login: "Invalid email or password"

The demo user **admin@bulodph.demo** / **Demo123!** must exist in the database with the correct password hash.

**Running locally (your PC):**
1. **Use a local database** — The repo’s `.env` may contain **Hostinger** DB credentials (`u476461747_*`). Those only work on Hostinger; from your PC you get "Access denied" and login returns "Login failed". For local dev, point the backend at a **local MySQL**:
   - Create a database (e.g. `bulodph`) and a user in MySQL on your machine (XAMPP, WAMP, or standalone MySQL).
   - In **bulodph-backend/.env** set: `DB_HOST=127.0.0.1`, `DB_DATABASE=bulodph`, `DB_USERNAME=root` (or your local user), `DB_PASSWORD=` (or your local password).
   - Import **bulodph.sql** into that database (e.g. with phpMyAdmin or `mysql -u root -p bulodph < bulodph.sql`).
2. Start the backend: `cd bulodph-backend` then `php artisan serve`.
3. Set demo passwords: `php artisan demo:reset-passwords` (or create users with `php artisan db:seed --class=DemoAccountsSeeder`).
4. Run the frontend: in **bulodph-frontend** ensure `.env` has `VITE_API_URL=http://localhost:8000/api`, then `npm run dev`.

**On Hostinger (production):**
- **If you can run Artisan on the server** (SSH or Hostinger’s PHP/run):  
  `php artisan db:seed --class=DemoAccountsSeeder` (creates demo users), or if users already exist: `php artisan demo:reset-passwords` (sets password to Demo123!).
- **If you cannot run Artisan**:  
  1. Pull the latest repo (so `deploy/fix_demo_login_once.php` is in `bulodph_repo`).  
  2. Copy `bulodph_repo/deploy/fix_demo_login_once.php` to `public_html/`.  
  3. Open **https://bulodph.com/fix_demo_login_once.php** in the browser once.  
  4. Delete `public_html/fix_demo_login_once.php` after use.

If the script says “Not found” for the demo user, import **bulodph.sql** or run `php artisan migrate` and `php artisan db:seed --class=DemoAccountsSeeder`, then run the fix again.

---

**Still "Invalid email or password" after updating passwords in phpMyAdmin?**

1. **Check which API the site calls** — On https://bulodph.com open DevTools (F12) → Network tab → try Login. If the request goes to **http://localhost:8000/api/login**, the frontend was built for dev; rebuild with production env and re-upload (step 3 below). If it goes to **https://bulodph.com/api/login**, the backend is being hit; then check step 2.
2. **Check backend database** — In **public_html/bulodph-backend/.env** on Hostinger, ensure `DB_DATABASE=u476461747_bulodph` (the same DB where you ran the password UPDATE). If it points to another database, fix it or run the same UPDATE there.
3. **Rebuild and re-upload the frontend** — On your PC: `cd bulodph-frontend`, ensure `.env.production` has `VITE_API_URL=/api`, run `npm run build`, then upload the new **dist/** contents to **public_html**.

---

**500 Internal Server Error on POST /api/login**

The backend is reached but Laravel is throwing an exception. Do the following:

1. **See the actual error**  
   - In Hostinger **File Manager** open **public_html/bulodph-backend/storage/logs/laravel.log** and check the last entries (scroll to the bottom). The exception message and file/line will be there.  
   - Or upload **deploy/debug_login_500.php** to **public_html**, open **https://bulodph.com/debug_login_500.php** in the browser, then delete the file. The page will show the error if it happens during login (user lookup, password check, token creation).

2. **Common causes and fixes**  
   - **Missing table `personal_access_tokens`** — Run migrations on the server (or import a DB that includes them): `php artisan migrate` or re-import **bulodph.sql**.  
   - **Storage not writable** — In **public_html/bulodph-backend**, ensure **storage** and **bootstrap/cache** are writable by the web server (e.g. chmod 775 or use Hostinger’s “Fix File Ownership”).  
   - **Missing or wrong .env** — In **public_html/bulodph-backend/.env** set `APP_KEY=...` (run `php artisan key:generate` locally and copy, or generate a 32-char key), and correct `DB_*` for the Hostinger database.  
   - **Spatie permission tables missing** — Run migrations or ensure **bulodph.sql** (which includes roles/permissions tables) is imported.

3. **Temporarily show errors in the browser**  
   In **public_html/bulodph-backend/.env** set `APP_DEBUG=true` and reload **https://bulodph.com/api/login** (e.g. via a form submit). The response may show the exception. Set `APP_DEBUG=false` again after debugging.

---

**Vehicle images or link previews show localhost:8000**

- In **public_html/bulodph-backend/.env** set **APP_URL=https://bulodph.com** (not `http://localhost:8000`). This affects any URLs the backend generates (e.g. rental logo uploads).
- Vehicle main/side images are stored as relative paths (`/storage/vehicle-images/...`) so they work on any domain. Ensure **storage** is writable and, if needed, run **php artisan storage:link** (from `public_html/bulodph-backend`) so `/storage/*` is served from `storage/app/public`.

---

## 3. Option: Build locally and upload (no Git on server)

If you prefer not to use Hostinger GIT:

1. **Push** your latest code to GitHub (as in step 1).
2. **Build** the frontend on your PC: `cd bulodph-frontend`, `npm install`, `npm run build`.
3. **Upload** to Hostinger `public_html` as in [DEPLOY_HOSTINGER.md](../DEPLOY_HOSTINGER.md): upload `dist/index.html` and `dist/assets/`, keep `index.php` and `bulodph-backend/`, use `bulodph-backend/public/.htaccess.production` as `public_html/.htaccess`.

---

## 4. Summary

| Step | Where | What to do |
|------|--------|------------|
| 1 | Your PC | `git add .` → `git commit -m "..."` → `git push` |
| 2 | GitHub | Code is stored at https://github.com/Teo199-2005/BulodPH |
| 3 | Your PC | `cd bulodph-frontend` → `npm run build` |
| 4 | Hostinger | If using GIT: Create repo with form above, then add `index.php`, `.htaccess`, backend `.env`/composer, and Vue `dist/`. Else: upload `dist/` and use DEPLOY_HOSTINGER.md. |

For full deployment details (Laravel + Vue, .htaccess, env), see [DEPLOY_HOSTINGER.md](../DEPLOY_HOSTINGER.md).
