<?php
/**
 * One-time debug: show why the site returns 500.
 * 1. Upload this file to public_html/ (same folder as index.php).
 * 2. Open https://bulodph.com/debug_500.php in your browser.
 * 3. Note the error message; then DELETE this file from the server.
 */
header('Content-Type: text/plain; charset=utf-8');
error_reporting(E_ALL);
ini_set('display_errors', '1');

$backend = __DIR__ . '/bulodph-backend';

if (!is_dir($backend)) {
    die("Missing folder: bulodph-backend (expected at public_html/bulodph-backend)\n");
}
if (!is_file($backend . '/vendor/autoload.php')) {
    die("Missing bulodph-backend/vendor. Run: composer install --no-dev then upload vendor folder.\n");
}
if (!is_file($backend . '/.env')) {
    die("Missing bulodph-backend/.env. Copy .env.example to .env and set APP_KEY and DB_*.\n");
}

try {
    require $backend . '/vendor/autoload.php';
    $app = require_once $backend . '/bootstrap/app.php';
    $kernel = $app->make(\Illuminate\Contracts\Http\Kernel::class);
    $kernel->bootstrap();
    echo "Laravel bootstrap OK.\n";
    echo "APP_ENV=" . config('app.env') . "\n";
    echo "APP_DEBUG=" . (config('app.debug') ? 'true' : 'false') . "\n";
} catch (\Throwable $e) {
    echo "Error: " . $e->getMessage() . "\n";
    echo "File: " . $e->getFile() . " Line: " . $e->getLine() . "\n\n";
    echo "Stack trace:\n" . $e->getTraceAsString();
}
