<?php

declare(strict_types=1);

namespace App\Models;

use Illuminate\Database\Eloquent\Concerns\HasUuids;
use Illuminate\Database\Eloquent\Model;

final class PromoCode extends Model
{
    use HasUuids;

    protected $fillable = [
        'code',
        'title',
        'description',
        'discount_percent',
        'min_rental_days',
        'max_rental_days',
        'active',
        'expires_at',
    ];

    protected function casts(): array
    {
        return [
            'active' => 'boolean',
            'expires_at' => 'datetime',
        ];
    }
}
