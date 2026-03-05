<?php

use App\Models\Organization;
use App\Models\User;
use Illuminate\Foundation\Testing\RefreshDatabase;

uses(RefreshDatabase::class);

beforeEach(function () {
    $this->org = Organization::firstOrCreate(
        ['abn' => '11111111111'],
        ['trading_name' => 'BulodPH Platform', 'is_active' => true]
    );
});

test('login returns token and user when credentials are valid', function () {
    $user = User::factory()->create([
        'organization_id' => $this->org->id,
        'email' => 'test@bulodph.test',
        'password' => 'password123',
        'is_active' => true,
    ]);

    $response = $this->postJson('/api/login', [
        'email' => 'test@bulodph.test',
        'password' => 'password123',
    ]);

    $response->assertOk()
        ->assertJsonStructure(['token', 'user'])
        ->assertJsonPath('user.email', 'test@bulodph.test');
});

test('login fails with invalid credentials', function () {
    $response = $this->postJson('/api/login', [
        'email' => 'wrong@bulodph.test',
        'password' => 'wrong',
    ]);

    $response->assertUnprocessable()
        ->assertJsonValidationErrors(['email']);
});

test('health endpoint returns ok', function () {
    $response = $this->get('/up');

    $response->assertOk();
});
