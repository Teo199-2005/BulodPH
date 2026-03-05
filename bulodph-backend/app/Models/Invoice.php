<?php

declare(strict_types=1);

namespace App\Models;

use Illuminate\Database\Eloquent\Concerns\HasUuids;
use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

final class Invoice extends Model
{
    use HasFactory, HasUuids;

    protected $fillable = [
        'booking_reference',
        'user_id',
        'owner_id',
        'subtotal',
        'taxes',
        'total',
        'currency',
        'status',
        'paid_at',
        'pdf_path',
    ];

    protected function casts(): array
    {
        return [
            'paid_at' => 'datetime',
        ];
    }
}
