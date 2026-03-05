<?php

declare(strict_types=1);

namespace App\Http\Middleware;

use Closure;
use Illuminate\Database\Eloquent\Builder;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Auth;
use Symfony\Component\HttpFoundation\Response;

final class EnsureTenantScope
{
    /**
     * Apply global scope to all queries to filter by organization_id.
     */
    public function handle(Request $request, Closure $next): Response
    {
        if (Auth::check()) {
            $organizationId = Auth::user()->organization_id;

            // Apply global scope to models with organization_id
            Builder::macro('forCurrentOrganization', function () use ($organizationId) {
                return $this->where('organization_id', $organizationId);
            });
        }

        return $next($request);
    }
}

