# Audit Strategy - HPA Plus

## Overview
100% coverage of data mutations with distributed tracing support via `request_id`.

---

## Audit Logs Table Schema

```sql
CREATE TABLE audit_logs (
    id UUID PRIMARY KEY,
    organization_id UUID NOT NULL,
    user_id UUID NULL,
    request_id UUID NOT NULL,
    auditable_type VARCHAR(255) NOT NULL,
    auditable_id UUID NOT NULL,
    event VARCHAR(50) NOT NULL,
    old_values JSON NULL,
    new_values JSON NOT NULL,
    ip_address VARCHAR(45) NOT NULL,
    user_agent TEXT NOT NULL,
    created_at TIMESTAMP NOT NULL,
    
    INDEX idx_audit_composite (organization_id, auditable_type, auditable_id, created_at),
    INDEX idx_request_trace (request_id, created_at)
);
```

---

## Implementation

### 1. Middleware: AuditRequest
Attaches unique `request_id` to every HTTP request.

```php
// app/Http/Middleware/AuditRequest.php
public function handle(Request $request, Closure $next): Response
{
    $requestId = (string) Str::uuid();
    $request->attributes->set('request_id', $requestId);
    
    $response = $next($request);
    $response->headers->set('X-Request-ID', $requestId);
    
    return $response;
}
```

### 2. Model Observers
Automatically log all `created`, `updated`, `deleted` events.

```php
// app/Observers/ShiftObserver.php
class ShiftObserver
{
    public function created(Shift $shift): void
    {
        AuditLog::create([
            'organization_id' => $shift->organization_id,
            'user_id' => auth()->id(),
            'request_id' => request()->attributes->get('request_id'),
            'auditable_type' => Shift::class,
            'auditable_id' => $shift->id,
            'event' => 'created',
            'old_values' => null,
            'new_values' => $shift->toArray(),
            'ip_address' => request()->ip(),
            'user_agent' => request()->userAgent(),
            'created_at' => now(),
        ]);
    }
    
    public function updated(Shift $shift): void
    {
        AuditLog::create([
            'organization_id' => $shift->organization_id,
            'user_id' => auth()->id(),
            'request_id' => request()->attributes->get('request_id'),
            'auditable_type' => Shift::class,
            'auditable_id' => $shift->id,
            'event' => 'updated',
            'old_values' => $shift->getOriginal(),
            'new_values' => $shift->getChanges(),
            'ip_address' => request()->ip(),
            'user_agent' => request()->userAgent(),
            'created_at' => now(),
        ]);
    }
}
```

### 3. Register Observers
```php
// app/Providers/AppServiceProvider.php
public function boot(): void
{
    Shift::observe(ShiftObserver::class);
    Client::observe(ClientObserver::class);
    NDISPlan::observe(NDISPlanObserver::class);
    // ... register all auditable models
}
```

---

## Query Examples

### 1. Trace All Actions in a Single Request
```php
AuditLog::where('request_id', $requestId)
    ->orderBy('created_at')
    ->get();
```

**Use Case:** Debugging failed transactions, tracing cascading updates.

---

### 2. View All Changes to a Specific Shift
```php
AuditLog::where('auditable_type', Shift::class)
    ->where('auditable_id', $shiftId)
    ->orderBy('created_at')
    ->get();
```

**Use Case:** Compliance audits, dispute resolution.

---

### 3. Find Who Modified a Client's NDIS Plan
```php
AuditLog::where('auditable_type', NDISPlan::class)
    ->where('auditable_id', $planId)
    ->where('event', 'updated')
    ->with('user')
    ->get();
```

**Use Case:** Privacy breach investigations (APP compliance).

---

### 4. Detect Suspicious Activity (Multiple Failed Logins)
```php
AuditLog::where('event', 'login_failed')
    ->where('ip_address', $ipAddress)
    ->where('created_at', '>=', now()->subHour())
    ->count();
```

**Use Case:** Security monitoring, rate limiting.

---

## Retention Policy

### Compliance Requirements
- **NDIS:** 7 years
- **ISO 27001:** 1 year minimum
- **APP:** Indefinite for sensitive data

### Implementation
```php
// app/Console/Commands/PurgeOldAuditLogs.php
Artisan::command('audit:purge', function () {
    $cutoffDate = now()->subYears(7);
    
    AuditLog::where('created_at', '<', $cutoffDate)
        ->whereNotIn('auditable_type', [
            Client::class,
            NDISPlan::class,
            // Keep client/plan audits indefinitely
        ])
        ->delete();
});
```

---

## Performance Optimization

### 1. Partitioning (MySQL 8.0+)
```sql
ALTER TABLE audit_logs
PARTITION BY RANGE (YEAR(created_at)) (
    PARTITION p2024 VALUES LESS THAN (2025),
    PARTITION p2025 VALUES LESS THAN (2026),
    PARTITION p2026 VALUES LESS THAN (2027),
    PARTITION pmax VALUES LESS THAN MAXVALUE
);
```

### 2. Archival Strategy
- **Hot Storage:** Last 12 months (MySQL)
- **Warm Storage:** 1-7 years (S3 + Athena)
- **Cold Storage:** >7 years (Glacier)

---

## Security Considerations

### 1. Immutable Logs
- No `UPDATE` or `DELETE` operations allowed
- Use database triggers to prevent modifications

```sql
CREATE TRIGGER prevent_audit_update
BEFORE UPDATE ON audit_logs
FOR EACH ROW
BEGIN
    SIGNAL SQLSTATE '45000'
    SET MESSAGE_TEXT = 'Audit logs are immutable';
END;
```

### 2. Encryption at Rest
- Enable MySQL encryption: `innodb_encrypt_tables = ON`
- Encrypt JSON fields containing PII

### 3. Access Control
- Audit log queries restricted to `Admin` role
- Separate read-only database user for compliance team

---

## Monitoring & Alerting

### 1. High-Volume Mutations
Alert if >1000 audit logs created in 1 minute (potential attack).

### 2. Unauthorized Access Attempts
Alert if `user_id IS NULL` and `event = 'access_denied'`.

### 3. Data Deletion Events
Alert on any `event = 'deleted'` for `Client` or `NDISPlan`.

---

**STATUS:** Audit infrastructure ready. Observers to be registered in `AppServiceProvider`.

