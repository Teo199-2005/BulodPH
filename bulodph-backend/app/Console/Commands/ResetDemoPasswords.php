<?php

declare(strict_types=1);

namespace App\Console\Commands;

use App\Models\User;
use Illuminate\Console\Command;

final class ResetDemoPasswords extends Command
{
    protected $signature = 'demo:reset-passwords';

    protected $description = 'Set password to Demo123! for all demo accounts (admin@bulodph.demo, etc.). Run once after importing DB.';

    public function handle(): int
    {
        $emails = [
            'admin@bulodph.demo',
            'client@bulodph.demo',
            'carowner@bulodph.demo',
            'marketing@bulodph.demo',
        ];

        $password = 'Demo123!';

        foreach ($emails as $email) {
            $user = User::where('email', $email)->first();
            if ($user) {
                $user->password = $password;
                $user->save();
                $this->info("Updated password for: {$email}");
            } else {
                $this->warn("User not found: {$email}");
            }
        }

        $this->info('Done. Demo password is: Demo123!');
        return self::SUCCESS;
    }
}
