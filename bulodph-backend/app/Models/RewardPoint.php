<?php

declare(strict_types=1);

namespace App\Models;

use Illuminate\Database\Eloquent\Concerns\HasUuids;
use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

final class RewardPoint extends Model
{
    use HasFactory, HasUuids;

    protected $fillable = [
        'user_id',
        'points_delta',
        'balance_after',
        'reason',
    ];
}
