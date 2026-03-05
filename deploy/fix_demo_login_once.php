<?php
/**
 * One-time fix: set demo account passwords to Demo123! on Hostinger.
 *
 * 1. Upload this file to public_html/ (same folder as index.php).
 * 2. In the browser open: https://bulodph.com/fix_demo_login_once.php
 * 3. Check the message; then DELETE this file for security.
 *
 * Requires: public_html/bulodph-backend/ with .env and vendor (composer install done).
 */
$backend = __DIR__ . '/bulodph-backend';
if (!is_file($backend . '/vendor/autoload.php')) {
    die('Missing bulodph-backend/vendor. Run composer install in bulodph-backend first.');
}

require $backend . '/vendor/autoload.php';
$app = require_once $backend . '/bootstrap/app.php';
$app->make(\Illuminate\Contracts\Console\Kernel::class)->bootstrap();

$password = 'Demo123!';
$emails = ['admin@bulodph.demo', 'client@bulodph.demo', 'carowner@bulodph.demo', 'marketing@bulodph.demo'];

$updated = [];
$missing = [];
foreach ($emails as $email) {
    $user = \App\Models\User::where('email', $email)->first();
    if ($user) {
        $user->password = $password;
        $user->save();
        $updated[] = $email;
    } else {
        $missing[] = $email;
    }
}

header('Content-Type: text/plain; charset=utf-8');
echo "Demo login fix (one-time)\n\n";
echo "Password set to: Demo123!\n\n";
echo "Updated: " . implode(', ', $updated) . "\n";
if (!empty($missing)) {
    echo "Not found: " . implode(', ', $missing) . "\n";
    echo "-> Import bulodph.sql or run: php artisan migrate && php artisan db:seed --class=DemoAccountsSeeder\n";
}
echo "\nDelete this file (fix_demo_login_once.php) now for security.\n";
