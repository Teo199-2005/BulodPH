<?php

declare(strict_types=1);

namespace App\Models;

use App\Domain\Shifts\Enums\ShiftStatus;
use Illuminate\Database\Eloquent\Concerns\HasUuids;
use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\BelongsTo;
use Illuminate\Database\Eloquent\Relations\HasMany;

final class Shift extends Model
{
    use HasFactory, HasUuids;

    protected $fillable = [
        'organization_id',
        'client_id',
        'primary_worker_id',
        'parent_shift_id',
        'scheduled_start',
        'scheduled_end',
        'actual_start',
        'actual_end',
        'clock_in_latitude',
        'clock_in_longitude',
        'clock_out_latitude',
        'clock_out_longitude',
        'status',
        'cancellation_reason',
        'notes',
    ];

    protected $casts = [
        'scheduled_start' => 'datetime',
        'scheduled_end' => 'datetime',
        'actual_start' => 'datetime',
        'actual_end' => 'datetime',
        'clock_in_latitude' => 'decimal:7',
        'clock_in_longitude' => 'decimal:7',
        'clock_out_latitude' => 'decimal:7',
        'clock_out_longitude' => 'decimal:7',
        'status' => ShiftStatus::class,
    ];

    public function organization(): BelongsTo
    {
        return $this->belongsTo(Organization::class);
    }

    public function client(): BelongsTo
    {
        return $this->belongsTo(Client::class);
    }

    public function primaryWorker(): BelongsTo
    {
        return $this->belongsTo(User::class, 'primary_worker_id');
    }

    public function parentShift(): BelongsTo
    {
        return $this->belongsTo(Shift::class, 'parent_shift_id');
    }

    public function shadowShifts(): HasMany
    {
        return $this->hasMany(Shift::class, 'parent_shift_id');
    }

    public function shiftLines(): HasMany
    {
        return $this->hasMany(ShiftLine::class);
    }

    public function isShadowShift(): bool
    {
        return $this->parent_shift_id !== null;
    }
}

