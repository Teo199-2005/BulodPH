<?php
/**
 * One-time debug: find why /api/login returns 500.
 * Upload to public_html/debug-login.php, visit https://bulodph.com/debug-login.php
 * Then open public_html/bulodph-backend/storage/logs/debug-login.txt
 * DELETE this file after use.
 */
error_reporting(E_ALL);
ini_set('display_errors', '1');

$logFile = __DIR__ . '/bulodph-backend/storage/logs/debug-login.txt';
$write = function ($msg) use ($logFile) {
    file_put_contents($logFile, date('Y-m-d H:i:s') . ' ' . $msg . "\n", FILE_APPEND);
};

file_put_contents($logFile, "=== Debug login " . date('Y-m-d H:i:s') . " ===\n");

try {
    $write("Loading Laravel...");
    require __DIR__ . '/bulodph-backend/vendor/autoload.php';
    $app = require_once __DIR__ . '/bulodph-backend/bootstrap/app.php';
    $app->make(\Illuminate\Contracts\Console\Kernel::class)->bootstrap();
    $write("Laravel booted.");

    $email = 'admin@bulodph.demo';
    $password = 'Demo123!';

    $write("Finding user: $email");
    $user = \App\Models\User::where('email', $email)->where('is_active', true)->first();
    if (!$user) {
        $write("ERROR: User not found or is_active=0");
        exit;
    }
    $write("User found: " . $user->id);

    $write("Checking password...");
    $ok = \Illuminate\Support\Facades\Hash::check($password, $user->password);
    $write("Password check: " . ($ok ? 'OK' : 'FAIL'));

    if (!$ok) {
        $write("Stopping (wrong password).");
        exit;
    }

    $write("Setting permissions team...");
    setPermissionsTeamId($user->organization_id);
    $write("OK.");

    $write("Creating token...");
    $token = $user->createToken('api-token')->plainTextToken;
    $write("Token created (length " . strlen($token) . ").");

    $write("Getting roles...");
    $roles = $user->getRoleNames();
    $write("Roles: " . $roles->toJson());

    $write("SUCCESS: Login would work. 500 is likely from something else (middleware, CORS, etc).");
} catch (\Throwable $e) {
    $write("EXCEPTION: " . $e->getMessage());
    $write("File: " . $e->getFile() . " Line: " . $e->getLine());
    $write("Trace: " . $e->getTraceAsString());
}

$write("Done.");
