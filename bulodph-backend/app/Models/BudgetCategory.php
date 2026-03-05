<?php

declare(strict_types=1);

namespace App\Models;

use Illuminate\Database\Eloquent\Concerns\HasUuids;
use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\BelongsTo;
use Illuminate\Database\Eloquent\Relations\HasMany;

final class BudgetCategory extends Model
{
    use HasFactory, HasUuids;

    protected $fillable = [
        'ndis_plan_id',
        'category_type',
        'total_budget_cents',
        'spent_cents',
        'committed_cents',
    ];

    protected $casts = [
        'total_budget_cents' => 'integer',
        'spent_cents' => 'integer',
        'committed_cents' => 'integer',
    ];

    public function ndisPlan(): BelongsTo
    {
        return $this->belongsTo(NDISPlan::class);
    }

    public function planLineItems(): HasMany
    {
        return $this->hasMany(PlanLineItem::class);
    }

    public function getRemainingBudgetCentsAttribute(): int
    {
        return $this->total_budget_cents - $this->spent_cents - $this->committed_cents;
    }
}

