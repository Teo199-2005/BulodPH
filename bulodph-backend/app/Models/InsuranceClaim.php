<?php

declare(strict_types=1);

namespace App\Models;

use Illuminate\Database\Eloquent\Concerns\HasUuids;
use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

final class InsuranceClaim extends Model
{
    use HasFactory, HasUuids;

    protected $fillable = [
        'insurance_selection_id',
        'user_id',
        'description',
        'claim_amount',
        'status',
        'evidence_path',
    ];
}
