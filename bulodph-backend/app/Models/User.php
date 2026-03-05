<?php

declare(strict_types=1);

namespace App\Models;

use Illuminate\Database\Eloquent\Concerns\HasUuids;
use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Relations\BelongsTo;
use Illuminate\Database\Eloquent\Relations\HasMany;
use Illuminate\Foundation\Auth\User as Authenticatable;
use Illuminate\Notifications\Notifiable;
use Laravel\Sanctum\HasApiTokens;
use Spatie\Permission\Traits\HasRoles;

final class User extends Authenticatable
{
    use HasApiTokens, HasFactory, HasRoles, HasUuids, Notifiable;

    protected $fillable = [
        'organization_id',
        'name',
        'email',
        'password',
        'tfn_encrypted',
        'mobile',
        'city',
        'province',
        'address',
        'notes',
        'avatar_url',
        'is_active',
        'marketing_consent_at',
        'marketing_consent_source',
        'email_verified_at',
    ];

    protected $hidden = [
        'password',
        'remember_token',
        'tfn_encrypted',
    ];

    protected function casts(): array
    {
        return [
            'password' => 'hashed',
            'is_active' => 'boolean',
            'marketing_consent_at' => 'datetime',
            'email_verified_at' => 'datetime',
        ];
    }

    public function organization(): BelongsTo
    {
        return $this->belongsTo(Organization::class);
    }

    public function shifts(): HasMany
    {
        return $this->hasMany(Shift::class, 'primary_worker_id');
    }

    public function certifications(): HasMany
    {
        return $this->hasMany(Certification::class);
    }

    public function carRentalProfile(): \Illuminate\Database\Eloquent\Relations\HasOne
    {
        return $this->hasOne(CarRentalProfile::class);
    }

    public function clientProfile(): \Illuminate\Database\Eloquent\Relations\HasOne
    {
        return $this->hasOne(ClientProfile::class);
    }
}
