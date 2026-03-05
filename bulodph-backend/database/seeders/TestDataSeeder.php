<?php

namespace Database\Seeders;

use App\Models\BudgetCategory;
use App\Models\Certification;
use App\Models\Client;
use App\Models\NDISPlan;
use App\Models\NDISSupportItem;
use App\Models\Organization;
use App\Models\PlanLineItem;
use App\Models\User;
use App\Domain\Shifts\Enums\CertificationType;
use Illuminate\Database\Seeder;
use Illuminate\Support\Facades\Hash;
use Spatie\Permission\Models\Role;

class TestDataSeeder extends Seeder
{
    /**
     * Seed test data for development and testing.
     */
    public function run(): void
    {
        // Create test organization
        $organization = Organization::factory()->create([
            'trading_name' => 'HPA Plus Demo Provider',
            'abn' => '12345678901',
            'ndis_registration_number' => 'NDIS-REG-001',
            'is_active' => true,
        ]);

        $this->command->info("Created organization: {$organization->trading_name}");

        // Create roles
        $adminRole = Role::create([
            'name' => 'Admin',
            'organization_id' => $organization->id,
            'guard_name' => 'web',
        ]);

        $supportWorkerRole = Role::create([
            'name' => 'Support Worker',
            'organization_id' => $organization->id,
            'guard_name' => 'web',
        ]);

        $coordinatorRole = Role::create([
            'name' => 'Coordinator',
            'organization_id' => $organization->id,
            'guard_name' => 'web',
        ]);

        $this->command->info('Created roles: Admin, Support Worker, Coordinator');

        // Create admin user
        $admin = User::factory()->create([
            'organization_id' => $organization->id,
            'email' => 'admin@hpaplus.com.au',
            'password' => Hash::make('password'),
            'mobile' => '0400000001',
            'is_active' => true,
        ]);
        setPermissionsTeamId($organization->id);
        $admin->assignRole($adminRole);

        $this->command->info("Created admin user: {$admin->email}");

        // Create support workers
        $worker1 = User::factory()->create([
            'organization_id' => $organization->id,
            'email' => 'worker1@hpaplus.com.au',
            'password' => Hash::make('password'),
            'mobile' => '0400000002',
            'is_active' => true,
        ]);
        $worker1->assignRole($supportWorkerRole);

        $worker2 = User::factory()->create([
            'organization_id' => $organization->id,
            'email' => 'worker2@hpaplus.com.au',
            'password' => Hash::make('password'),
            'mobile' => '0400000003',
            'is_active' => true,
        ]);
        $worker2->assignRole($supportWorkerRole);

        $this->command->info('Created 2 support workers');

        // Create certifications for workers
        Certification::factory()->create([
            'user_id' => $worker1->id,
            'certification_type' => CertificationType::FIRST_AID,
            'certification_number' => 'FA-2024-001',
            'issued_date' => now()->subMonths(6),
            'expiry_date' => now()->addMonths(30),
        ]);

        Certification::factory()->create([
            'user_id' => $worker1->id,
            'certification_type' => CertificationType::CPR,
            'certification_number' => 'CPR-2024-001',
            'issued_date' => now()->subMonths(3),
            'expiry_date' => now()->addMonths(9),
        ]);

        Certification::factory()->create([
            'user_id' => $worker1->id,
            'certification_type' => CertificationType::NDIS_WORKER_SCREENING,
            'certification_number' => 'NDIS-WS-2024-001',
            'issued_date' => now()->subYear(),
            'expiry_date' => now()->addYears(4),
        ]);

        Certification::factory()->create([
            'user_id' => $worker2->id,
            'certification_type' => CertificationType::FIRST_AID,
            'certification_number' => 'FA-2024-002',
            'issued_date' => now()->subMonths(4),
            'expiry_date' => now()->addMonths(32),
        ]);

        Certification::factory()->create([
            'user_id' => $worker2->id,
            'certification_type' => CertificationType::CPR,
            'certification_number' => 'CPR-2024-002',
            'issued_date' => now()->subMonths(2),
            'expiry_date' => now()->addMonths(10),
        ]);

        Certification::factory()->create([
            'user_id' => $worker2->id,
            'certification_type' => CertificationType::NDIS_WORKER_SCREENING,
            'certification_number' => 'NDIS-WS-2024-002',
            'issued_date' => now()->subMonths(8),
            'expiry_date' => now()->addYears(4)->addMonths(4),
        ]);

        $this->command->info('Created certifications for workers');

        // Create test clients
        $client1 = Client::factory()->create([
            'organization_id' => $organization->id,
            'ndis_number' => '400000001',
            'first_name' => 'John',
            'last_name' => 'Smith',
            'date_of_birth' => '1990-05-15',
            'address_line_1' => '123 Main Street',
            'suburb' => 'Sydney',
            'state' => 'NSW',
            'postcode' => '2000',
            'latitude' => -33.8688,
            'longitude' => 151.2093,
            'emergency_contact_name' => 'Jane Smith',
            'emergency_contact_phone' => '0400111222',
        ]);

        $client2 = Client::factory()->create([
            'organization_id' => $organization->id,
            'ndis_number' => '400000002',
            'first_name' => 'Sarah',
            'last_name' => 'Johnson',
            'date_of_birth' => '1985-08-22',
            'address_line_1' => '456 Park Avenue',
            'suburb' => 'Melbourne',
            'state' => 'VIC',
            'postcode' => '3000',
            'latitude' => -37.8136,
            'longitude' => 144.9631,
            'emergency_contact_name' => 'Michael Johnson',
            'emergency_contact_phone' => '0400333444',
        ]);

        $this->command->info('Created 2 test clients');

        // Get support items
        $selfCareWeekday = NDISSupportItem::where('support_item_number', '01_011_0107_1_1')->first();
        $communityWeekday = NDISSupportItem::where('support_item_number', '01_012_0106_1_1')->first();

        // Create NDIS plans with budget categories and line items
        $plan1 = NDISPlan::factory()->create([
            'client_id' => $client1->id,
            'plan_number' => 'PLAN-2024-001',
            'start_date' => now()->subMonths(2),
            'end_date' => now()->addMonths(10),
            'is_active' => true,
        ]);

        $category1 = BudgetCategory::factory()->create([
            'ndis_plan_id' => $plan1->id,
            'category_type' => 'CORE',
            'total_budget_cents' => 5000000, // $50,000
        ]);

        PlanLineItem::factory()->create([
            'budget_category_id' => $category1->id,
            'support_item_id' => $selfCareWeekday->id,
            'allocated_amount_cents' => 3000000, // $30,000
        ]);

        PlanLineItem::factory()->create([
            'budget_category_id' => $category1->id,
            'support_item_id' => $communityWeekday->id,
            'allocated_amount_cents' => 2000000, // $20,000
        ]);

        $this->command->info("Created NDIS plan for {$client1->full_name}");

        $plan2 = NDISPlan::factory()->create([
            'client_id' => $client2->id,
            'plan_number' => 'PLAN-2024-002',
            'start_date' => now()->subMonth(),
            'end_date' => now()->addMonths(11),
            'is_active' => true,
        ]);

        $category2 = BudgetCategory::factory()->create([
            'ndis_plan_id' => $plan2->id,
            'category_type' => 'CORE',
            'total_budget_cents' => 4000000, // $40,000
        ]);

        PlanLineItem::factory()->create([
            'budget_category_id' => $category2->id,
            'support_item_id' => $selfCareWeekday->id,
            'allocated_amount_cents' => 2500000, // $25,000
        ]);

        PlanLineItem::factory()->create([
            'budget_category_id' => $category2->id,
            'support_item_id' => $communityWeekday->id,
            'allocated_amount_cents' => 1500000, // $15,000
        ]);

        $this->command->info("Created NDIS plan for {$client2->full_name}");

        $this->command->info('✅ Test data seeding complete!');
        $this->command->newLine();
        $this->command->info('Login credentials:');
        $this->command->info('  Admin: admin@hpaplus.com.au / password');
        $this->command->info('  Worker 1: worker1@hpaplus.com.au / password');
        $this->command->info('  Worker 2: worker2@hpaplus.com.au / password');
    }
}

