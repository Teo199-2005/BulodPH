<?php

declare(strict_types=1);

namespace App\Observers;

use App\Models\AuditLog;
use App\Models\Shift;

final class ShiftObserver
{
    public function created(Shift $shift): void
    {
        $this->logAudit($shift, 'created', null, $shift->toArray());
    }

    public function updated(Shift $shift): void
    {
        $this->logAudit($shift, 'updated', $shift->getOriginal(), $shift->getChanges());
    }

    public function deleted(Shift $shift): void
    {
        $this->logAudit($shift, 'deleted', $shift->toArray(), null);
    }

    private function logAudit(Shift $shift, string $event, ?array $oldValues, ?array $newValues): void
    {
        AuditLog::create([
            'organization_id' => $shift->organization_id,
            'user_id' => auth()->id(),
            'request_id' => request()->attributes->get('request_id') ?? request()->header('X-Request-ID'),
            'auditable_type' => Shift::class,
            'auditable_id' => $shift->id,
            'event' => $event,
            'old_values' => $oldValues,
            'new_values' => $newValues,
            'ip_address' => request()->ip() ?? '127.0.0.1',
            'user_agent' => request()->userAgent() ?? 'CLI',
            'created_at' => now(),
        ]);
    }
}

