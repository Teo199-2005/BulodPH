<?php

declare(strict_types=1);

namespace App\Models;

use Illuminate\Database\Eloquent\Concerns\HasUuids;
use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\BelongsTo;

final class CarRentalProfile extends Model
{
    use HasUuids;

    protected $table = 'car_rental_profiles';

    protected $fillable = [
        'user_id',
        'business_name',
        'logo_url',
        'bio',
        'city',
        'province',
        'address',
        'phone',
        'email',
        'business_permit_number',
        'business_address',
        'slug',
        'verified_at',
    ];

    protected function casts(): array
    {
        return [
            'verified_at' => 'datetime',
        ];
    }

    public function user(): BelongsTo
    {
        return $this->belongsTo(User::class);
    }

    public static function slugFrom(string $name): string
    {
        return strtolower(preg_replace('/[^a-z0-9]+/i', '-', trim($name)) ?: 'profile');
    }
}
