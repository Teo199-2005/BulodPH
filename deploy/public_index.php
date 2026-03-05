<?php
/**
 * Laravel entry point for Hostinger when repo is deployed to public_html root.
 * Copy this file to public_html/index.php (so Laravel loads from public_html/bulodph-backend).
 */
use Illuminate\Http\Request;

define('LARAVEL_START', microtime(true));

$backend = __DIR__ . '/bulodph-backend';

if (file_exists($maintenance = $backend . '/storage/framework/maintenance.php')) {
    require $maintenance;
}

require $backend . '/vendor/autoload.php';

(require_once $backend . '/bootstrap/app.php')
    ->handleRequest(Request::capture());
