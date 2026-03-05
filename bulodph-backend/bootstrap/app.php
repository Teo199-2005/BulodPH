<?php

use App\Http\Middleware\AuditRequest;
use App\Http\Middleware\EnsureTenantScope;
use App\Http\Middleware\SecurityHeaders;
use Illuminate\Foundation\Application;
use Illuminate\Foundation\Configuration\Exceptions;
use Illuminate\Foundation\Configuration\Middleware;

return Application::configure(basePath: dirname(__DIR__))
    ->withRouting(
        web: __DIR__.'/../routes/web.php',
        api: __DIR__.'/../routes/api.php',
        commands: __DIR__.'/../routes/console.php',
        health: '/up',
    )
    ->withMiddleware(function (Middleware $middleware) {
        // Exempt API routes from CSRF when using Bearer token (Sanctum)
        $middleware->validateCsrfTokens(except: ['api/login', 'api/profile/avatar', 'api/*']);
        $middleware->append(SecurityHeaders::class);
        // Do NOT prepend EnsureFrontendRequestsAreStateful to API: it requires session which API routes don't have by default, causing 500 on login. This app uses Bearer token only.
        $middleware->alias([
            'audit.request' => AuditRequest::class,
            'tenant.scope' => EnsureTenantScope::class,
            'role' => \App\Http\Middleware\EnsureRole::class,
        ]);
    })
    ->withExceptions(function (Exceptions $exceptions) {
        $exceptions->reportable(function (\Throwable $e) {
            $log = dirname(__DIR__) . '/storage/logs/login-error.txt';
            @file_put_contents($log, date('Y-m-d H:i:s') . ' ' . $e->getMessage() . "\n" . $e->getFile() . ':' . $e->getLine() . "\n" . $e->getTraceAsString() . "\n---\n", FILE_APPEND);
        });
        // Return JSON for API 500s when debug is on so we can see the real error in the browser/network tab
        $exceptions->renderable(function (\Throwable $e, \Illuminate\Http\Request $request) {
            if ($request->is('api/*') && config('app.debug')) {
                return response()->json([
                    'error' => $e->getMessage(),
                    'file' => $e->getFile(),
                    'line' => $e->getLine(),
                ], 500);
            }
        });
    })->create();
