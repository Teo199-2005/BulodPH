<?php

declare(strict_types=1);

namespace App\Observers;

use App\Models\AuditLog;
use App\Models\NDISPlan;

final class NDISPlanObserver
{
    public function created(NDISPlan $plan): void
    {
        $this->logAudit($plan, 'created', null, $plan->toArray());
    }

    public function updated(NDISPlan $plan): void
    {
        $this->logAudit($plan, 'updated', $plan->getOriginal(), $plan->getChanges());
    }

    public function deleted(NDISPlan $plan): void
    {
        $this->logAudit($plan, 'deleted', $plan->toArray(), null);
    }

    private function logAudit(NDISPlan $plan, string $event, ?array $oldValues, ?array $newValues): void
    {
        // Get organization_id from client relationship
        $organizationId = $plan->client->organization_id ?? null;

        AuditLog::create([
            'organization_id' => $organizationId,
            'user_id' => auth()->id(),
            'request_id' => request()->attributes->get('request_id') ?? request()->header('X-Request-ID'),
            'auditable_type' => NDISPlan::class,
            'auditable_id' => $plan->id,
            'event' => $event,
            'old_values' => $oldValues,
            'new_values' => $newValues,
            'ip_address' => request()->ip() ?? '127.0.0.1',
            'user_agent' => request()->userAgent() ?? 'CLI',
            'created_at' => now(),
        ]);
    }
}

