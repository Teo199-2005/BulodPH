<?php

declare(strict_types=1);

namespace App\Observers;

use App\Models\AuditLog;
use App\Models\Client;

final class ClientObserver
{
    public function created(Client $client): void
    {
        $this->logAudit($client, 'created', null, $client->toArray());
    }

    public function updated(Client $client): void
    {
        $this->logAudit($client, 'updated', $client->getOriginal(), $client->getChanges());
    }

    public function deleted(Client $client): void
    {
        $this->logAudit($client, 'deleted', $client->toArray(), null);
    }

    private function logAudit(Client $client, string $event, ?array $oldValues, ?array $newValues): void
    {
        AuditLog::create([
            'organization_id' => $client->organization_id,
            'user_id' => auth()->id(),
            'request_id' => request()->attributes->get('request_id') ?? request()->header('X-Request-ID'),
            'auditable_type' => Client::class,
            'auditable_id' => $client->id,
            'event' => $event,
            'old_values' => $oldValues,
            'new_values' => $newValues,
            'ip_address' => request()->ip() ?? '127.0.0.1',
            'user_agent' => request()->userAgent() ?? 'CLI',
            'created_at' => now(),
        ]);
    }
}

