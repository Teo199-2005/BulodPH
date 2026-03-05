<?php

namespace Database\Seeders;

use App\Models\NDISSupportItem;
use Illuminate\Database\Seeder;
use Illuminate\Support\Str;

class NDISSupportCatalogueSeeder extends Seeder
{
    /**
     * Seed NDIS Support Catalogue items.
     * Based on NDIS Price Guide 2024-25.
     */
    public function run(): void
    {
        $supportItems = [
            // Core Supports - Daily Activities
            [
                'support_item_number' => '01_011_0107_1_1',
                'support_item_name' => 'Assistance with Self-Care Activities - Standard - Weekday Daytime',
                'category_type' => 'CORE',
                'unit_of_measure' => 'HOUR',
                'price_cents' => 6854, // $68.54
                'effective_from' => '2024-07-01',
                'effective_to' => null,
            ],
            [
                'support_item_number' => '01_011_0107_1_1_T',
                'support_item_name' => 'Assistance with Self-Care Activities - Standard - Weekday Evening',
                'category_type' => 'CORE',
                'unit_of_measure' => 'HOUR',
                'price_cents' => 9596, // $95.96
                'effective_from' => '2024-07-01',
                'effective_to' => null,
            ],
            [
                'support_item_number' => '01_011_0107_1_1_S',
                'support_item_name' => 'Assistance with Self-Care Activities - Standard - Saturday',
                'category_type' => 'CORE',
                'unit_of_measure' => 'HOUR',
                'price_cents' => 10281, // $102.81
                'effective_from' => '2024-07-01',
                'effective_to' => null,
            ],
            [
                'support_item_number' => '01_011_0107_1_1_P',
                'support_item_name' => 'Assistance with Self-Care Activities - Standard - Sunday/Public Holiday',
                'category_type' => 'CORE',
                'unit_of_measure' => 'HOUR',
                'price_cents' => 13708, // $137.08
                'effective_from' => '2024-07-01',
                'effective_to' => null,
            ],

            // Community Access
            [
                'support_item_number' => '01_012_0106_1_1',
                'support_item_name' => 'Assistance with Social and Community Participation - Standard - Weekday Daytime',
                'category_type' => 'CORE',
                'unit_of_measure' => 'HOUR',
                'price_cents' => 6854, // $68.54
                'effective_from' => '2024-07-01',
                'effective_to' => null,
            ],
            [
                'support_item_number' => '01_012_0106_1_1_T',
                'support_item_name' => 'Assistance with Social and Community Participation - Standard - Weekday Evening',
                'category_type' => 'CORE',
                'unit_of_measure' => 'HOUR',
                'price_cents' => 9596, // $95.96
                'effective_from' => '2024-07-01',
                'effective_to' => null,
            ],

            // High Intensity Supports
            [
                'support_item_number' => '01_013_0107_1_1',
                'support_item_name' => 'Assistance with Self-Care Activities - High Intensity - Weekday Daytime',
                'category_type' => 'CORE',
                'unit_of_measure' => 'HOUR',
                'price_cents' => 8568, // $85.68
                'effective_from' => '2024-07-01',
                'effective_to' => null,
            ],

            // Capacity Building - Support Coordination
            [
                'support_item_number' => '07_001_0106_8_3',
                'support_item_name' => 'Support Coordination',
                'category_type' => 'CAPACITY_BUILDING',
                'unit_of_measure' => 'HOUR',
                'price_cents' => 19386, // $193.86
                'effective_from' => '2024-07-01',
                'effective_to' => null,
            ],

            // Specialist Support Coordination
            [
                'support_item_number' => '07_002_0106_8_3',
                'support_item_name' => 'Specialist Support Coordination',
                'category_type' => 'CAPACITY_BUILDING',
                'unit_of_measure' => 'HOUR',
                'price_cents' => 22143, // $221.43
                'effective_from' => '2024-07-01',
                'effective_to' => null,
            ],

            // Therapy Supports
            [
                'support_item_number' => '15_037_0128_1_3',
                'support_item_name' => 'Therapeutic Supports - Allied Health Assistant',
                'category_type' => 'CAPACITY_BUILDING',
                'unit_of_measure' => 'HOUR',
                'price_cents' => 6854, // $68.54
                'effective_from' => '2024-07-01',
                'effective_to' => null,
            ],
            [
                'support_item_number' => '15_038_0128_1_3',
                'support_item_name' => 'Therapeutic Supports - Occupational Therapist',
                'category_type' => 'CAPACITY_BUILDING',
                'unit_of_measure' => 'HOUR',
                'price_cents' => 19386, // $193.86
                'effective_from' => '2024-07-01',
                'effective_to' => null,
            ],
        ];

        foreach ($supportItems as $item) {
            NDISSupportItem::create([
                'id' => Str::orderedUuid(),
                ...$item,
            ]);
        }

        $this->command->info('NDIS Support Catalogue seeded: ' . count($supportItems) . ' items');
    }
}

