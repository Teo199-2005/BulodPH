<?php

declare(strict_types=1);

namespace App\Models;

use Illuminate\Database\Eloquent\Concerns\HasUuids;
use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\BelongsTo;

final class CartItem extends Model
{
    use HasUuids;

    protected $fillable = [
        'user_id',
        'vehicle_id',
        'vehicle_name',
        'vehicle_image',
        'start_date',
        'end_date',
        'price_per_day',
        'quantity_days',
        'meet_up',
    ];

    protected function casts(): array
    {
        return [
            'start_date' => 'date',
            'end_date' => 'date',
            'price_per_day' => 'integer',
            'quantity_days' => 'integer',
        ];
    }

    public function user(): BelongsTo
    {
        return $this->belongsTo(User::class);
    }
}
