<?php

declare(strict_types=1);

namespace App\Models;

use Illuminate\Database\Eloquent\Concerns\HasUuids;
use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

final class TrustSafetyPolicy extends Model
{
    use HasFactory, HasUuids;

    protected $fillable = [
        'slug',
        'title',
        'content',
        'is_published',
        'created_by',
    ];
}
