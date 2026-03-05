<?php

declare(strict_types=1);

namespace App\Providers;

use App\Models\Client;
use App\Models\NDISPlan;
use App\Models\Shift;
use App\Observers\ClientObserver;
use App\Observers\NDISPlanObserver;
use App\Observers\ShiftObserver;
use Illuminate\Support\ServiceProvider;

final class AppServiceProvider extends ServiceProvider
{
    public function register(): void
    {
        //
    }

    public function boot(): void
    {
        // Register model observers for audit logging
        Shift::observe(ShiftObserver::class);
        Client::observe(ClientObserver::class);
        NDISPlan::observe(NDISPlanObserver::class);
    }
}
