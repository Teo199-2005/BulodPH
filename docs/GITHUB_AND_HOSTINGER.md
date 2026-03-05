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
