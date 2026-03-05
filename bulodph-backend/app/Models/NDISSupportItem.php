<?php

declare(strict_types=1);

namespace App\Models;

use Illuminate\Database\Eloquent\Concerns\HasUuids;
use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\HasMany;

final class NDISSupportItem extends Model
{
    use HasFactory, HasUuids;

    protected $table = 'ndis_support_items';

    protected $fillable = [
        'support_item_number',
        'support_item_name',
        'category_type',
        'unit_of_measure',
        'price_cents',
        'effective_from',
        'effective_to',
    ];

    protected $casts = [
        'price_cents' => 'integer',
        'effective_from' => 'date',
        'effective_to' => 'date',
    ];

    public function planLineItems(): HasMany
    {
        return $this->hasMany(PlanLineItem::class, 'support_item_id');
    }
}

