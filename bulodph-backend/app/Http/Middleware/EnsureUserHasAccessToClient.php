<?php

declare(strict_types=1);

namespace App\Http\Middleware;

use App\Models\Client;
use Closure;
use Illuminate\Http\Request;
use Symfony\Component\HttpFoundation\Response;

final class EnsureUserHasAccessToClient
{
    /**
     * Ensure the authenticated user's organization matches the client's organization.
     *
     * Usage: Route parameter must be named 'client' (UUID).
     */
    public function handle(Request $request, Closure $next): Response
    {
        $clientId = $request->route('client');

        if (!$clientId) {
            abort(400, 'Client ID is required.');
        }

        $client = Client::findOrFail($clientId);

        if ($client->organization_id !== $request->user()->organization_id) {
            abort(403, 'You do not have access to this client.');
        }

        // Attach client to request for downstream use
        $request->merge(['_client' => $client]);

        return $next($request);
    }
}

