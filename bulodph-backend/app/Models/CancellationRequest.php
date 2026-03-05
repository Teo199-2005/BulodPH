<?php

declare(strict_types=1);

namespace App\Models;

use Illuminate\Database\Eloquent\Concerns\HasUuids;
use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\HasOne;

final class CancellationRequest extends Model
{
    use HasFactory, HasUuids;

    protected $fillable = [
        'booking_reference',
        'user_id',
        'reason',
        'status',
        'requested_at',
    ];

    protected $casts = [
        'requested_at' => 'datetime',
    ];

    public function refund(): HasOne
    {
        return $this->hasOne(Refund::class);
    }
}
