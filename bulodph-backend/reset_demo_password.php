<?php
/**
 * One-time script: generate bcrypt hash for Demo123! and verify it.
 * Run: php reset_demo_password.php
 * Then use the printed SQL in phpMyAdmin.
 */
$password = 'Demo123!';
$hash = password_hash($password, PASSWORD_BCRYPT);
$ok = password_verify($password, $hash);
echo "Hash: " . $hash . "\n";
echo "Verify: " . ($ok ? 'OK' : 'FAIL') . "\n";
echo "\n-- Run this in phpMyAdmin (database u476461747_bulodph):\n";
echo "UPDATE users SET password = '" . $hash . "' WHERE email = 'admin@bulodph.demo';\n";
