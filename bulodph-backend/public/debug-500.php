<?php
/**
 * One-time debug script to find why the site returns 500.
 * Upload to public_html/debug-500.php, visit https://bulodph.com/debug-500.php
 * then open public_html/bulodph-backend/storage/logs/debug-500-result.txt
 * DELETE this file after use.
 */
error_reporting(E_ALL);
ini_set('display_errors', '1');
ini_set('log_errors', '1');

$logDir = __DIR__ . '/bulodph-backend/storage/logs';
$logFile = $logDir . '/debug-500-result.txt';

$write = function ($msg) use ($logFile) {
    file_put_contents($logFile, $msg . "\n", FILE_APPEND);
};

file_put_contents($logFile, "=== " . date('Y-m-d H:i:s') . " ===\n");

try {
    $write("Step 1: Loading autoload...");
    require __DIR__ . '/bulodph-backend/vendor/autoload.php';
    $write("Step 2: Autoload OK. Loading bootstrap/app.php...");
    $app = require_once __DIR__ . '/bulodph-backend/bootstrap/app.php';
    $write("Step 3: Bootstrap OK. Booting app...");
    $app->make(\Illuminate\Contracts\Console\Kernel::class)->bootstrap();
    $write("Step 4: Boot OK. Handling request...");
    $app->handleRequest(\Illuminate\Http\Request::capture());
    $write("Step 5: Request handled. No 500 from Laravel.");
} catch (\Throwable $e) {
    $write("ERROR: " . $e->getMessage());
    $write("File: " . $e->getFile() . " Line: " . $e->getLine());
    $write("Trace:\n" . $e->getTraceAsString());
}

$write("Done.");
