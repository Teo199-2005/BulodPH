<?php

declare(strict_types=1);

namespace App\Models;

use Illuminate\Database\Eloquent\Concerns\HasUuids;
use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

final class DisputeEvidence extends Model
{
    use HasFactory, HasUuids;

    protected $fillable = [
        'dispute_id',
        'uploaded_by_user_id',
        'file_path',
        'mime',
        'size',
    ];
}
