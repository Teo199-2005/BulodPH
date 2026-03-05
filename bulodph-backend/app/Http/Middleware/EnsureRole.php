<?php

declare(strict_types=1);

namespace App\Http\Middleware;

use Closure;
use Illuminate\Http\Request;
use Symfony\Component\HttpFoundation\Response;

/**
 * Restrict API routes to users with specific roles.
 * Use: ->middleware('role:admin') or ->middleware('role:admin,car_owner')
 */
final class EnsureRole
{
    public function handle(Request $request, Closure $next, string ...$roles): Response
    {
        if (!$request->user()) {
            return response()->json(['message' => 'Unauthenticated.'], 401);
        }

        $user = $request->user();
        if ($user->organization_id) {
            setPermissionsTeamId($user->organization_id);
        }
        $userRoles = $user->getRoleNames()->map(fn ($r) => strtolower((string) $r))->toArray();
        $allowed = array_map('strtolower', $roles);

        foreach ($allowed as $role) {
            $normalized = $role === 'car owner' ? 'car_owner' : $role;
            if (in_array($normalized, $userRoles) || in_array(str_replace('_', ' ', $role), $userRoles)) {
                return $next($request);
            }
        }

        return response()->json(['message' => 'Forbidden. Insufficient permissions.'], 403);
    }
}
