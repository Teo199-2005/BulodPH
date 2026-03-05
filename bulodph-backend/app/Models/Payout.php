<?php

declare(strict_types=1);

namespace App\Models;

use Illuminate\Database\Eloquent\Concerns\HasUuids;
use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\BelongsTo;

final class Payout extends Model
{
    use HasUuids;

    protected $fillable = [
        'user_id',
        'type',
        'payee_name',
        'amount',
        'method',
        'status',
        'requested_at',
        'paid_at',
        'rejected_at',
        'reject_reason',
    ];

    protected $casts = [
        'amount' => 'integer',
        'requested_at' => 'datetime',
        'paid_at' => 'datetime',
        'rejected_at' => 'datetime',
    ];

    public function user(): BelongsTo
    {
        return $this->belongsTo(User::class);
    }
}
