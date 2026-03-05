<?php

declare(strict_types=1);

namespace App\Models;

use Illuminate\Database\Eloquent\Concerns\HasUuids;
use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\BelongsTo;

final class ClientProfile extends Model
{
    use HasUuids;

    protected $table = 'client_profiles';

    protected $fillable = [
        'user_id',
        'display_name',
        'avatar_url',
        'phone',
        'city',
        'province',
        'address',
        'id_number',
        'emergency_contact_name',
        'emergency_contact_phone',
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
        return strtolower(preg_replace('/[^a-z0-9]+/i', '-', trim($name)) ?: 'client');
    }
}
