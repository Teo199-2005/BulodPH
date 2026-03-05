<?php

declare(strict_types=1);

namespace App\Models;

use Illuminate\Database\Eloquent\Concerns\HasUuids;
use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

final class AffiliateApplication extends Model
{
    use HasFactory, HasUuids;

    protected $fillable = [
        'name',
        'email',
        'company',
        'status',
        'notes',
    ];
}
