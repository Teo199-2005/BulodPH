<?php
/**
 * One-time debug: run login logic and show any error (for 500 on /api/login).
 * 1. Upload to public_html/ and open https://bulodph.com/debug_login_500.php
 * 2. Check the output; then DELETE this file.
 */
$backend = __DIR__ . '/bulodph-backend';
if (!is_file($backend . '/vendor/autoload.php')) {
    header('Content-Type: text/plain');
    die('Missing bulodph-backend/vendor. Run composer install.');
}

require $backend . '/vendor/autoload.php';
$app = require_once $backend . '/bootstrap/app.php';
$kernel = $app->make(\Illuminate\Contracts\Http\Kernel::class);
$kernel->bootstrap();

header('Content-Type: text/plain; charset=utf-8');

$email = 'admin@bulodph.demo';
$password = 'Demo123!';

try {
    $user = \App\Models\User::where('email', $email)->where('is_active', true)->first();
    if (!$user) {
        echo "User not found or inactive: $email\n";
        exit;
    }
    if (!\Illuminate\Support\Facades\Hash::check($password, $user->password)) {
        echo "Password mismatch for $email\n";
        exit;
    }
    if ($user->organization_id) {
        setPermissionsTeamId($user->organization_id);
    }
    $token = $user->createToken('api-token')->plainTextToken;
    echo "OK. Token (first 20 chars): " . substr($token, 0, 20) . "...\n";
    echo "Login would succeed. If /api/login still returns 500, the error may be in middleware or route setup.\n";
} catch (\Throwable $e) {
    echo "Error: " . $e->getMessage() . "\n";
    echo "File: " . $e->getFile() . " Line: " . $e->getLine() . "\n";
    echo "\nStack trace:\n" . $e->getTraceAsString();
}
