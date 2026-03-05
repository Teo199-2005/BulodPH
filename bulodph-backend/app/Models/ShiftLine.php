<?php

declare(strict_types=1);

namespace App\Models;

use Illuminate\Database\Eloquent\Concerns\HasUuids;
use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\BelongsTo;

final class ShiftLine extends Model
{
    use HasFactory, HasUuids;

    protected $fillable = [
        'shift_id',
        'plan_line_item_id',
        'units',
        'unit_price_cents',
        'total_cents',
        'is_billable',
    ];

    protected $casts = [
        'units' => 'decimal:2',
        'unit_price_cents' => 'integer',
        'total_cents' => 'integer',
        'is_billable' => 'boolean',
    ];

    public function shift(): BelongsTo
    {
        return $this->belongsTo(Shift::class);
    }

    public function planLineItem(): BelongsTo
    {
        return $this->belongsTo(PlanLineItem::class);
    }
}

