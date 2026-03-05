<?php

declare(strict_types=1);

namespace App\Models;

use Illuminate\Database\Eloquent\Concerns\HasUuids;
use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

final class Message extends Model
{
    use HasFactory, HasUuids;

    protected $fillable = [
        'thread_id',
        'sender_id',
        'body',
        'attachment_path',
        'attachment_mime',
        'attachment_size',
    ];
}
