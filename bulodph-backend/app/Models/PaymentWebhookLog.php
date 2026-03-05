<?php

declare(strict_types=1);

namespace App\Models;

use Illuminate\Database\Eloquent\Concerns\HasUuids;
use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

final class PaymentWebhookLog extends Model
{
    use HasFactory, HasUuids;

    protected $fillable = [
        'provider',
        'event',
        'reference',
        'payload',
        'status',
    ];

    protected $casts = [
        'payload' => 'array',
    ];
}
