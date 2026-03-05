<?php

declare(strict_types=1);

namespace App\Models;

use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\BelongsTo;

final class RentalBooking extends Model
{
    public $incrementing = false;

    protected $keyType = 'string';

    protected $fillable = [
        'id',
        'transaction_id',
        'vehicle_name',
        'business_name',
        'client_name',
        'client_email',
        'start_date',
        'end_date',
        'amount',
        'status',
        'previous_status',
        'confirmed_at',
        'paid_at',
        'cancelled_at',
        'completed_at',
        'archived',
        'car_owner_seen_at',
        'vehicle_id',
        'client_user_id',
    ];

    protected $casts = [
        'start_date' => 'date',
        'end_date' => 'date',
        'amount' => 'integer',
        'archived' => 'boolean',
        'car_owner_seen_at' => 'datetime',
        'confirmed_at' => 'datetime',
        'paid_at' => 'datetime',
        'cancelled_at' => 'datetime',
        'completed_at' => 'datetime',
    ];

    public static function validStatuses(): array
    {
        return ['Pending', 'Approved', 'Active', 'Completed', 'Cancelled', 'Rejected', 'Overdue', 'Pending cancellation'];
    }

    public function vehicle(): BelongsTo
    {
        return $this->belongsTo(Vehicle::class);
    }
}
