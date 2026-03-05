<?php

declare(strict_types=1);

namespace App\Http\Middleware;

use Illuminate\Foundation\Http\Middleware\ValidateCsrfToken as Middleware;

/**
 * CSRF validation with API upload routes excluded (Bearer token auth, no cookie).
 * Used by Sanctum for stateful frontend requests; these paths use token-only auth.
 */
class ValidateCsrfTokenExceptApiUploads extends Middleware
{
    /**
     * The URIs that should be excluded from CSRF verification.
     *
     * @var array<int, string>
     */
    protected $except = [
        'api/login',
        'api/profile/avatar',
        'api/profile/*',
    ];
}
