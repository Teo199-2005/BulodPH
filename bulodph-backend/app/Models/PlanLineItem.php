<?php

declare(strict_types=1);

namespace App\Models;

use Illuminate\Database\Eloquent\Concerns\HasUuids;
use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\BelongsTo;
use Illuminate\Database\Eloquent\Relations\HasMany;

final class PlanLineItem extends Model
{
    use HasFactory, HasUuids;

    protected $fillable = [
        'budget_category_id',
        'support_item_id',
        'allocated_units',
        'allocated_amount_cents',
        'used_units',
        'used_amount_cents',
        'is_active',
    ];

    protected $casts = [
        'allocated_units' => 'decimal:2',
        'allocated_amount_cents' => 'integer',
        'used_units' => 'decimal:2',
        'used_amount_cents' => 'integer',
        'is_active' => 'boolean',
    ];

    public function budgetCategory(): BelongsTo
    {
        return $this->belongsTo(BudgetCategory::class);
    }

    public function supportItem(): BelongsTo
    {
        return $this->belongsTo(NDISSupportItem::class, 'support_item_id');
    }

    public function shiftLines(): HasMany
    {
        return $this->hasMany(ShiftLine::class);
    }
}

