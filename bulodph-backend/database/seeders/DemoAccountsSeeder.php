<?php

namespace Database\Seeders;

use App\Models\Organization;
use App\Models\User;
use Illuminate\Database\Seeder;
use Spatie\Permission\Models\Role;

class DemoAccountsSeeder extends Seeder
{
    /**
     * Seed demo accounts for BulodPH pilot testing (client, admin, car_owner, marketing_staff).
     * Password for all: Demo123!
     */
    public function run(): void
    {
        $organization = Organization::firstOrCreate(
            ['abn' => '99999999999'],
            [
                'trading_name' => 'BulodPH Demo',
                'is_active' => true,
            ]
        );

        // Plain password so User model's 'hashed' cast hashes it once (avoid double-hash)
        $demoPassword = 'Demo123!';
        $guard = 'web';
        $teamId = $organization->id;

        $accounts = [
            [
                'email' => 'client@bulodph.demo',
                'name' => 'Demo Client',
                'mobile' => '639171234567',
                'role_name' => 'client',
            ],
            [
                'email' => 'admin@bulodph.demo',
                'name' => 'Demo Admin',
                'mobile' => '639171234568',
                'role_name' => 'admin',
            ],
            [
                'email' => 'carowner@bulodph.demo',
                'name' => 'Demo Car Owner',
                'mobile' => '639171234569',
                'role_name' => 'car_owner',
            ],
            [
                'email' => 'marketing@bulodph.demo',
                'name' => 'Demo Marketing',
                'mobile' => '639171234570',
                'role_name' => 'marketing_staff',
            ],
        ];

        setPermissionsTeamId($teamId);

        foreach ($accounts as $account) {
            $role = Role::firstOrCreate(
                [
                    'organization_id' => $teamId,
                    'name' => $account['role_name'],
                    'guard_name' => $guard,
                ]
            );

            $user = User::updateOrCreate(
                ['email' => $account['email']],
                [
                    'organization_id' => $organization->id,
                    'name' => $account['name'] ?? $account['email'],
                    'email' => $account['email'],
                    'password' => $demoPassword, // User model casts to 'hashed'
                    'mobile' => $account['mobile'],
                    'is_active' => true,
                ]
            );

            if (!$user->hasRole($role)) {
                $user->assignRole($role);
            }

            $this->command->info("Demo account: {$account['email']} ({$account['role_name']})");
        }

        $this->command->info('Demo accounts seeded. Password for all: Demo123!');
    }
}
