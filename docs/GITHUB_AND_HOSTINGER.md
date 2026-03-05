# Publish BulodPH via GitHub and Hostinger

Use GitHub for version control and Hostinger for hosting. Repo: **https://github.com/Teo199-2005/BulodPH**

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

## 2. Deploy to Hostinger

You have two options.

### Option A: Deploy from GitHub (if Hostinger supports Git)

1. In **Hostinger hPanel** go to **Advanced** → **Git** (or **Deploy from Git**).
2. Connect the repository: `https://github.com/Teo199-2005/BulodPH.git`, branch **main**.
3. Set the deploy path (e.g. a folder under `domains/yourdomain/public_html` or the repo root).
4. After clone/pull, you still need to:
   - Build the frontend on the server (if Node is available) or build locally and upload `bulodph-frontend/dist/` (see Option B).
   - Configure the backend: copy `bulodph-backend/.env.example` to `.env`, set DB and `APP_KEY`, run `php artisan migrate` if needed.
   - Use the production `.htaccess` so `/api` goes to Laravel and the rest to the Vue app (see [DEPLOY_HOSTINGER.md](../DEPLOY_HOSTINGER.md)).

### Option B: Build locally and upload (recommended for shared hosting)

1. **Push** your latest code to GitHub (as in step 1).
2. **Build** the frontend on your PC:
   ```powershell
   cd bulodph-frontend
   npm install
   npm run build
   ```
3. **Upload** to Hostinger `public_html` as in [DEPLOY_HOSTINGER.md](../DEPLOY_HOSTINGER.md):
   - Upload `bulodph-frontend/dist/index.html` and `dist/assets/` to `public_html`.
   - Keep `public_html/index.php` and `public_html/bulodph-backend/` for the API.
   - Use `bulodph-backend/public/.htaccess.production` as `public_html/.htaccess`.

So: **GitHub = source of truth and backup**; **Hostinger = build + upload** as you did before.

---

## 3. Summary

| Step | Where | What to do |
|------|--------|------------|
| 1 | Your PC | `git add .` → `git commit -m "..."` → `git push` |
| 2 | GitHub | Code is stored at https://github.com/Teo199-2005/BulodPH |
| 3 | Your PC | `cd bulodph-frontend` → `npm run build` |
| 4 | Hostinger | Upload `dist/` to `public_html`; keep API and `.htaccess` as in DEPLOY_HOSTINGER.md |

For full deployment details (Laravel + Vue, .htaccess, env), see [DEPLOY_HOSTINGER.md](../DEPLOY_HOSTINGER.md).
