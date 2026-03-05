<?php

declare(strict_types=1);

namespace App\Http\Middleware;

use Closure;
use Illuminate\Http\Request;
use Illuminate\Support\Str;
use Symfony\Component\HttpFoundation\Response;

final class AuditRequest
{
    /**
     * Attach a unique request_id to every request for audit trail tracing.
     */
    public function handle(Request $request, Closure $next): Response
    {
        $requestId = (string) Str::uuid();
        $request->attributes->set('request_id', $requestId);

        $response = $next($request);

        // Add request_id to response headers for client-side tracing
        $response->headers->set('X-Request-ID', $requestId);

        return $response;
    }
}

