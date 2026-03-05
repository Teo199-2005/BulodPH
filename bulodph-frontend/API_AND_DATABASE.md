# BulodPH – Backend API & Database Contract

This document describes the API and database schema expected by the frontend for **authentication**, **registration**, and **role-based dashboards**. Implement these on your backend (e.g. Laravel, Node, etc.) so the app works end-to-end.

---

## 1. Database tables

### 1.1 `users` table (single table for all roles)

Store all users (clients/renters, car owners, marketing staff, admins) in one table with a `role` column.

| Column            | Type         | Nullable | Description |
|-------------------|--------------|----------|-------------|
| id                | BIGINT/UUID  | NO       | Primary key |
| full_name         | VARCHAR(255) | NO       | Letters, spaces, hyphens, apostrophes only |
| email             | VARCHAR(255) | NO       | Unique, lowercase |
| phone             | VARCHAR(20)  | NO       | E.164 style: `63` + 10 digits (e.g. `639171234567`) |
| password_hash     | VARCHAR(255) | NO       | Bcrypt (or Argon2) hash; never store plain password |
| province_code     | VARCHAR(20)  | NO       | PSGC province code |
| city_code         | VARCHAR(20)  | NO       | PSGC city/municipality code |
| barangay          | VARCHAR(255) | NO       | Barangay name |
| street_address    | VARCHAR(500) | NO       | Building, street, subdivision |
| role              | VARCHAR(50)  | NO       | One of: `client`, `admin`, `car_owner`, `marketing_staff` |
| organization_id   | VARCHAR(50)  | YES      | Optional; default `'1'` for single-tenant |
| is_active         | BOOLEAN      | NO       | Default `true` |
| remember_token    | VARCHAR(100) | YES      | If using cookie/session |
| created_at        | TIMESTAMP    | NO       | |
| updated_at        | TIMESTAMP    | NO       | |

- **Unique:** `email`.
- **Index:** `email`, `role`, `phone` (if you look up by phone).

**Role mapping from registration:**

- Frontend sends `account_type`: `renter` | `car_owner` | `marketing_partner`.
- Backend should store:
  - `renter` → `role = 'client'`
  - `car_owner` → `role = 'car_owner'`
  - `marketing_partner` → `role = 'marketing_staff'`

---

## 2. Password hashing (security)

- **Never** store plain-text passwords.
- On **register**: hash the password with **bcrypt** (cost ≥ 10) or **Argon2id**, then store in `password_hash`.
- On **login**: verify with `password_verify(plainPassword, user.password_hash)` (or equivalent).
- Optionally enforce: min length 8, and complexity rules (e.g. one letter, one number).

---

## 3. API endpoints

Base URL: `VITE_API_URL` (e.g. `http://localhost:8000/api`).  
All request/response bodies are **JSON**.  
Protected routes use header: `Authorization: Bearer <token>`.

---

### 3.1 `POST /api/register`

**Request body:**

```json
{
  "full_name": "Juan Dela Cruz",
  "email": "juan@example.com",
  "phone": "639171234567",
  "province_code": "0209",
  "city_code": "020901",
  "barangay": "Poblacion",
  "street_address": "123 Rizal St",
  "password": "secret123",
  "account_type": "renter"
}
```

- `account_type`: `renter` | `car_owner` | `marketing_partner`
- `phone`: digits only, 12 chars, starting with `63` (e.g. `639171234567`)

**Validation (backend):**

- `full_name`: required, letters/spaces/hyphens/apostrophes only, length ≥ 2.
- `email`: required, valid email, unique.
- `phone`: required, PH mobile format (63 + 10 digits, first digit 9).
- `province_code`, `city_code`: required, valid PSGC codes.
- `barangay`, `street_address`: required, non-empty.
- `password`: required, min 8 characters (and optional complexity).

**Success (201):**

Option A – redirect to login (no token):

```json
{
  "message": "Registration successful. Please sign in."
}
```

Option B – auto-login (return token + user):

```json
{
  "token": "eyJ0eXAiOiJKV1QiLCJhbGc...",
  "user": {
    "id": "1",
    "email": "juan@example.com",
    "name": "Juan Dela Cruz",
    "organization_id": "1",
    "mobile": "639171234567",
    "is_active": true,
    "roles": ["client"]
  }
}
```

**Error (422):**

```json
{
  "message": "The given data was invalid.",
  "errors": {
    "email": ["The email has already been taken."],
    "phone": ["The phone format is invalid."]
  }
}
```

---

### 3.2 `POST /api/login`

**Request body:**

```json
{
  "email": "juan@example.com",
  "password": "secret123"
}
```

**Success (200):**

```json
{
  "token": "eyJ0eXAiOiJKV1QiLCJhbGc...",
  "user": {
    "id": "1",
    "email": "juan@example.com",
    "name": "Juan Dela Cruz",
    "organization_id": "1",
    "mobile": "639171234567",
    "is_active": true,
    "roles": ["client"]
  }
}
```

- `roles`: array of strings. **First role** is used for redirect:
  - `client` (or `renter`) → **Client dashboard** (`/client`)
  - `admin` → **Admin dashboard** (`/admin`)
  - `car_owner` → **Car owner dashboard** (`/car-owner`)
  - `marketing_staff` (or `marketing_partner`) → **Marketing dashboard** (`/marketing`)

**Error (401):**

```json
{
  "message": "Invalid credentials."
}
```

Or (422):

```json
{
  "errors": {
    "email": ["These credentials do not match our records."]
  }
}
```

---

### 3.3 `POST /api/logout`

- **Headers:** `Authorization: Bearer <token>`
- **Success (200):** empty or `{ "message": "Logged out" }`
- Invalidates the token on the server (if using token blacklist or short-lived JWTs).

---

## 4. Frontend behavior summary

| Action        | Endpoint          | Redirect after success |
|---------------|-------------------|------------------------|
| Register      | POST /api/register| If token returned → role dashboard; else → Login |
| Login         | POST /api/login   | Role-based dashboard (client / admin / car-owner / marketing) |
| Logout        | POST /api/logout  | Login page             |
| Auth required| —                 | All `/client`, `/admin`, `/car-owner`, `/marketing`, and other dashboard routes require valid `Authorization` header; 401 → redirect to Login |

---

## 5. Suggested migrations (pseudo-SQL)

```sql
CREATE TABLE users (
  id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  full_name VARCHAR(255) NOT NULL,
  email VARCHAR(255) NOT NULL UNIQUE,
  phone VARCHAR(20) NOT NULL,
  password_hash VARCHAR(255) NOT NULL,
  province_code VARCHAR(20) NOT NULL,
  city_code VARCHAR(20) NOT NULL,
  barangay VARCHAR(255) NOT NULL,
  street_address VARCHAR(500) NOT NULL,
  role VARCHAR(50) NOT NULL,
  organization_id VARCHAR(50) DEFAULT '1',
  is_active BOOLEAN DEFAULT TRUE,
  created_at TIMESTAMP NULL,
  updated_at TIMESTAMP NULL,
  INDEX idx_email (email),
  INDEX idx_role (role),
  INDEX idx_phone (phone)
);
```

Use your framework’s migration tool and add any extra columns (e.g. `email_verified_at`) as needed.

---

## 5.1 Demo accounts (for pilot testing)

Seed these four users so the **floating demo accounts** on the login page work. All use password: **`Demo123!`** (hash it with bcrypt before inserting).

| Role             | Email                    | Full name      | Phone        | Purpose            |
|------------------|--------------------------|----------------|--------------|--------------------|
| `client`         | client@bulodph.demo      | Demo Client    | 639171234567 | Client dashboard   |
| `admin`          | admin@bulodph.demo       | Demo Admin     | 639171234568 | Admin dashboard    |
| `car_owner`      | carowner@bulodph.demo    | Demo Car Owner | 639171234569 | Car owner dashboard|
| `marketing_staff`| marketing@bulodph.demo   | Demo Marketing | 639171234570 | Marketing dashboard|

Use the same `province_code`, `city_code`, `barangay`, `street_address` for all (e.g. `0209`, `020901`, `Poblacion`, `123 Demo St`). Hash the password once and reuse for all four rows.

**Example (Laravel seeder):** Hash with `Hash::make('Demo123!')` and insert four rows with the emails/roles above. **Example (Node):** `bcrypt.hashSync('Demo123!', 10)`.

---

## 6. Security checklist

- [ ] Passwords hashed with bcrypt (or Argon2); never stored in plain text.
- [ ] HTTPS in production.
- [ ] Rate limiting on `/login` and `/register`.
- [ ] Validate and sanitize all inputs; use parameterized queries.
- [ ] Return generic “Invalid credentials” on login failure (do not reveal whether email exists).
- [ ] JWT/Sanctum: set reasonable expiry and secure cookie options if using cookies.
