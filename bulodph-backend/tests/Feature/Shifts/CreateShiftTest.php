<?php

use App\Actions\Shifts\CreateShiftAction;
use App\Data\Shifts\CreateShiftData;
use App\Models\BudgetCategory;
use App\Models\Certification;
use App\Models\Client;
use App\Models\NDISPlan;
use App\Models\NDISSupportItem;
use App\Models\Organization;
use App\Models\PlanLineItem;
use App\Models\Shift;
use App\Models\User;
use Carbon\Carbon;
use Illuminate\Foundation\Testing\RefreshDatabase;
use Illuminate\Validation\ValidationException;

uses(RefreshDatabase::class);

beforeEach(function () {
    $this->organization = Organization::factory()->create();
    $this->worker = User::factory()->create(['organization_id' => $this->organization->id]);
    $this->client = Client::factory()->create(['organization_id' => $this->organization->id]);

    // Create NDIS Plan with budget
    $plan = NDISPlan::factory()->create(['client_id' => $this->client->id]);
    $budgetCategory = BudgetCategory::factory()->create([
        'ndis_plan_id' => $plan->id,
        'total_budget_cents' => 100000, // $1000
    ]);

    $supportItem = NDISSupportItem::factory()->create([
        'price_cents' => 5000, // $50/hour
    ]);

    $this->planLineItem = PlanLineItem::factory()->create([
        'budget_category_id' => $budgetCategory->id,
        'support_item_id' => $supportItem->id,
        'allocated_amount_cents' => 100000,
        'used_amount_cents' => 0,
    ]);

    // Create valid certifications
    Certification::factory()->create([
        'user_id' => $this->worker->id,
        'certification_type' => 'FIRST_AID',
        'expiry_date' => Carbon::now()->addYear(),
    ]);

    Certification::factory()->create([
        'user_id' => $this->worker->id,
        'certification_type' => 'CPR',
        'expiry_date' => Carbon::now()->addYear(),
    ]);

    Certification::factory()->create([
        'user_id' => $this->worker->id,
        'certification_type' => 'NDIS_WORKER_SCREENING',
        'expiry_date' => Carbon::now()->addYear(),
    ]);
});

test('can create shift with valid data', function () {
    $data = new CreateShiftData(
        client_id: $this->client->id,
        primary_worker_id: $this->worker->id,
        parent_shift_id: null,
        scheduled_start: Carbon::now()->addDay()->setHour(9),
        scheduled_end: Carbon::now()->addDay()->setHour(17),
        plan_line_item_ids: [$this->planLineItem->id],
        notes: 'Test shift'
    );

    $action = app(CreateShiftAction::class);
    $shift = $action->execute($data, $this->worker);

    expect($shift)->not->toBeNull()
        ->and($shift->status->value)->toBe('SCHEDULED')
        ->and($shift->shiftLines)->toHaveCount(1);
});

test('fails when worker has overlapping shift', function () {
    // Create existing shift
    $existingShift = Shift::factory()->create([
        'organization_id' => $this->organization->id,
        'primary_worker_id' => $this->worker->id,
        'scheduled_start' => Carbon::now()->addDay()->setHour(10),
        'scheduled_end' => Carbon::now()->addDay()->setHour(14),
    ]);

    $data = new CreateShiftData(
        client_id: $this->client->id,
        primary_worker_id: $this->worker->id,
        parent_shift_id: null,
        scheduled_start: Carbon::now()->addDay()->setHour(9),
        scheduled_end: Carbon::now()->addDay()->setHour(17),
        plan_line_item_ids: [$this->planLineItem->id],
        notes: null
    );

    $action = app(CreateShiftAction::class);

    expect(fn() => $action->execute($data, $this->worker))
        ->toThrow(ValidationException::class);
});

test('fails when worker has expired certification', function () {
    // Expire First Aid certification
    Certification::where('user_id', $this->worker->id)
        ->where('certification_type', 'FIRST_AID')
        ->update(['expiry_date' => Carbon::now()->subDay()]);

    $data = new CreateShiftData(
        client_id: $this->client->id,
        primary_worker_id: $this->worker->id,
        parent_shift_id: null,
        scheduled_start: Carbon::now()->addDay()->setHour(9),
        scheduled_end: Carbon::now()->addDay()->setHour(17),
        plan_line_item_ids: [$this->planLineItem->id],
        notes: null
    );

    $action = app(CreateShiftAction::class);

    expect(fn() => $action->execute($data, $this->worker))
        ->toThrow(ValidationException::class);
});

test('fails when insufficient budget', function () {
    // Exhaust budget
    $this->planLineItem->update(['used_amount_cents' => 99000]);

    $data = new CreateShiftData(
        client_id: $this->client->id,
        primary_worker_id: $this->worker->id,
        parent_shift_id: null,
        scheduled_start: Carbon::now()->addDay()->setHour(9),
        scheduled_end: Carbon::now()->addDay()->setHour(17), // 8 hours = $400
        plan_line_item_ids: [$this->planLineItem->id],
        notes: null
    );

    $action = app(CreateShiftAction::class);

    expect(fn() => $action->execute($data, $this->worker))
        ->toThrow(ValidationException::class);
});

test('shadow shift must be within parent shift timeframe', function () {
    $parentShift = Shift::factory()->create([
        'organization_id' => $this->organization->id,
        'primary_worker_id' => User::factory()->create(['organization_id' => $this->organization->id])->id,
        'scheduled_start' => Carbon::now()->addDay()->setHour(10),
        'scheduled_end' => Carbon::now()->addDay()->setHour(14),
    ]);

    $data = new CreateShiftData(
        client_id: $this->client->id,
        primary_worker_id: $this->worker->id,
        parent_shift_id: $parentShift->id,
        scheduled_start: Carbon::now()->addDay()->setHour(9), // Before parent
        scheduled_end: Carbon::now()->addDay()->setHour(15), // After parent
        plan_line_item_ids: [$this->planLineItem->id],
        notes: null
    );

    $action = app(CreateShiftAction::class);

    expect(fn() => $action->execute($data, $this->worker))
        ->toThrow(ValidationException::class);
});

