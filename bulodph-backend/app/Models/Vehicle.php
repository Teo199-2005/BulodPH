<?php

declare(strict_types=1);

namespace App\Models;

use Illuminate\Database\Eloquent\Concerns\HasUuids;
use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\BelongsTo;

final class Vehicle extends Model
{
    use HasUuids;

    protected $table = 'vehicles';

    protected $fillable = [
        'user_id',
        'name',
        'type',
        'location',
        'price_per_day',
        'original_price_per_day',
        'description',
        'image',
        'status',
        'approved',
        'hidden_from_listing',
        'featured',
        'host_name',
        'business_name',
        'car_type',
        'capacity',
        'rental_mode',
        'min_rental_period_hours',
        'tags',
        'images_four_sides',
        'listed_at',
        'approved_at',
    ];

    protected function casts(): array
    {
        return [
            'price_per_day' => 'decimal:2',
            'original_price_per_day' => 'decimal:2',
            'approved' => 'boolean',
            'hidden_from_listing' => 'boolean',
            'featured' => 'boolean',
            'tags' => 'array',
            'images_four_sides' => 'array',
            'listed_at' => 'datetime',
            'approved_at' => 'datetime',
        ];
    }

    public function user(): BelongsTo
    {
        return $this->belongsTo(User::class);
    }

    protected static function booted(): void
    {
        static::creating(function (Vehicle $vehicle): void {
            if ($vehicle->listed_at === null) {
                $vehicle->listed_at = $vehicle->freshTimestamp();
            }
        });
    }
}
