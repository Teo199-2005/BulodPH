# Database Seeder Guide

## Overview

The database seeders populate the HPA Plus database with NDIS Support Catalogue items and test data for development and testing.

---

## Seeders Created

### 1. NDISSupportCatalogueSeeder

**Purpose:** Seeds the NDIS Support Catalogue with real support items from the NDIS Price Guide 2024-25.

**Items Included:**
- **Core Supports - Daily Activities**
  - Assistance with Self-Care Activities (Weekday Daytime, Evening, Saturday, Sunday/Public Holiday)
  - Assistance with Social and Community Participation (Weekday Daytime, Evening)
  - High Intensity Supports
  - Provider Travel (per kilometre)

- **Capacity Building - Support Coordination**
  - Support Coordination ($193.86/hour)
  - Specialist Support Coordination ($221.43/hour)

- **Capacity Building - Therapy Supports**
  - Allied Health Assistant ($68.54/hour)
  - Occupational Therapist ($193.86/hour)

**Total Items:** 13 support items

---

### 2. TestDataSeeder

**Purpose:** Creates a complete test environment with organization, users, clients, and NDIS plans.

**Data Created:**

#### Organization
- **Trading Name:** HPA Plus Demo Provider
- **ABN:** 12345678901
- **NDIS Registration:** NDIS-REG-001

#### Roles
- Admin
- Support Worker
- Coordinator

#### Users
| Email | Password | Role | Mobile |
|-------|----------|------|--------|
| admin@hpaplus.com.au | password | Admin | 0400000001 |
| worker1@hpaplus.com.au | password | Support Worker | 0400000002 |
| worker2@hpaplus.com.au | password | Support Worker | 0400000003 |

#### Certifications
Both support workers have:
- ✅ First Aid (valid for 3 years)
- ✅ CPR (valid for 12 months)
- ✅ NDIS Worker Screening (valid for 5 years)

#### Clients
1. **John Smith**
   - NDIS Number: 400000001
   - Location: Sydney, NSW
   - Emergency Contact: Jane Smith (0400111222)

2. **Sarah Johnson**
   - NDIS Number: 400000002
   - Location: Melbourne, VIC
   - Emergency Contact: Michael Johnson (0400333444)

#### NDIS Plans

**John Smith's Plan (PLAN-2024-001)**
- Duration: 12 months (started 2 months ago)
- Total Budget: $50,000
- Line Items:
  - Self-Care Activities: $30,000 allocated
  - Community Participation: $20,000 allocated

**Sarah Johnson's Plan (PLAN-2024-002)**
- Duration: 12 months (started 1 month ago)
- Total Budget: $40,000
- Line Items:
  - Self-Care Activities: $25,000 allocated
  - Community Participation: $15,000 allocated

---

## Running the Seeders

### Run All Seeders
```bash
cd hpa-plus-backend
php artisan db:seed
```

### Run Specific Seeder
```bash
# NDIS Support Catalogue only
php artisan db:seed --class=NDISSupportCatalogueSeeder

# Test data only
php artisan db:seed --class=TestDataSeeder
```

### Fresh Migration + Seed
```bash
php artisan migrate:fresh --seed
```

---

## Usage in Development

### Login to Frontend
1. Navigate to http://localhost:5173
2. Use any of the test credentials:
   - **Admin:** admin@hpaplus.com.au / password
   - **Worker:** worker1@hpaplus.com.au / password

### API Testing
```bash
# Login
curl -X POST http://localhost:8000/api/login \
  -H "Content-Type: application/json" \
  -d '{"email":"admin@hpaplus.com.au","password":"password"}'

# Get clients (with token)
curl http://localhost:8000/api/clients \
  -H "Authorization: Bearer YOUR_TOKEN_HERE"
```

---

## Extending the Seeders

### Add More NDIS Support Items

Edit `NDISSupportCatalogueSeeder.php` and add to the `$supportItems` array:

```php
[
    'support_item_number' => '01_XXX_XXXX_X_X',
    'support_item_name' => 'Your Support Item Name',
    'support_category_number' => '01',
    'support_category_name' => 'Assistance with Daily Life',
    'unit_of_measure' => 'Hour',
    'price_cents' => 10000, // $100.00
    'is_active' => true,
],
```

### Add More Test Users

Edit `TestDataSeeder.php` and add after existing workers:

```php
$worker3 = User::factory()->create([
    'organization_id' => $organization->id,
    'email' => 'worker3@hpaplus.com.au',
    'password' => Hash::make('password'),
    'mobile' => '0400000004',
    'is_active' => true,
]);
$worker3->assignRole($supportWorkerRole);
```

---

## Notes

- All monetary values are stored in **cents** (e.g., $68.54 = 6854 cents)
- NDIS support item numbers follow the official NDIS Price Guide format
- Certifications are created with realistic expiry dates
- Plans are created with active status and realistic budget allocations
- All test data uses the same organization for multi-tenant isolation

---

## Troubleshooting

### Error: "Class NDISSupportCatalogueSeeder does not exist"
```bash
composer dump-autoload
```

### Error: "SQLSTATE[23000]: Integrity constraint violation"
Make sure migrations are run before seeding:
```bash
php artisan migrate
php artisan db:seed
```

### Error: "Call to undefined method Role::create()"
Make sure spatie/laravel-permission migrations are run:
```bash
php artisan migrate
```

---

**STATUS:** ✅ Seeders ready to use. Run `php artisan db:seed` after migrations complete.

