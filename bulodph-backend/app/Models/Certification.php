<?php

declare(strict_types=1);

namespace App\Models;

use App\Domain\Shifts\Enums\CertificationType;
use Illuminate\Database\Eloquent\Concerns\HasUuids;
use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\BelongsTo;

final class Certification extends Model
{
    use HasFactory, HasUuids;

    protected $fillable = [
        'user_id',
        'certification_type',
        'certification_number',
        'issued_date',
        'expiry_date',
        'document_path',
    ];

    protected $casts = [
        'certification_type' => CertificationType::class,
        'issued_date' => 'date',
        'expiry_date' => 'date',
    ];

    public function user(): BelongsTo
    {
        return $this->belongsTo(User::class);
    }

    public function isExpired(): bool
    {
        return $this->expiry_date->isPast();
    }
}

