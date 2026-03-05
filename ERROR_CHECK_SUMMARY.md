# Error check summary

## Status

- **Frontend** (`bulodph-frontend`): Lint, type-check, build, and tests pass.
- **Backend** (`bulodph-backend`): PHP syntax and routes are valid; **all 10 tests pass** after the fixes below.

## Backend test fixes applied

1. **Pest bootstrap**  
   Added `tests/Pest.php` so tests use `Tests\TestCase` (Laravel app boots). This fixed "Call to a member function connection() on null" in AuthTest.

2. **Test database**  
   In `phpunit.xml`, enabled in-memory SQLite (`DB_CONNECTION=sqlite`, `DB_DATABASE=:memory:`).  
   AuthTest and CreateShiftTest use `RefreshDatabase` so migrations run and tables exist.

3. **User schema vs factory/model**  
   The `users` table has no `email_verified_at` column. Removed `email_verified_at` from the User factory and from the User model’s `casts` so inserts and serialization match the schema.

4. **Factories (Faker)**  
   Replaced `numerify()` / `regexify()` in factories with `numberBetween()` and `str_pad()` so tests work regardless of Faker formatters.  
   Updated factories: ClientFactory, OrganizationFactory, CertificationFactory, NDISSupportItemFactory, NDISPlanFactory, UserFactory.

5. **NDIS support item enum**  
   `ndis_support_items.unit_of_measure` is an enum `('HOUR','EACH','WEEK','MONTH')`. NDISSupportItemFactory now uses only these uppercase values (removed "Day" and mixed case).

6. **ValidateStaffCertificationsAction**  
   `certification_type` is cast to `CertificationType` enum; `pluck('certification_type')` returns enum objects. Mapped results to string values before `array_diff()` to avoid "Object could not be converted to string".

7. **CreateShiftTest**  
   Added missing `use App\Models\Shift;` so `Shift::factory()` resolves.  
   Added `uses(RefreshDatabase::class)` so the shift tests run with a migrated in-memory database.

## How to re-check

- **Backend:** From `bulodph-backend`, run `php artisan test`.
- **Frontend:** From `bulodph-frontend`, run `npm run build` and `npm run test` (and `npm run lint` / type-check if you use them).
