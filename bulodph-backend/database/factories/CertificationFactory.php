<?php

declare(strict_types=1);

namespace Database\Factories;

use App\Domain\Shifts\Enums\CertificationType;
use App\Models\Certification;
use App\Models\User;
use Illuminate\Database\Eloquent\Factories\Factory;

final class CertificationFactory extends Factory
{
    protected $model = Certification::class;

    public function definition(): array
    {
        $issuedDate = $this->faker->dateTimeBetween('-2 years', '-6 months');
        $expiryDate = (clone $issuedDate)->modify('+' . $this->faker->numberBetween(12, 36) . ' months');

        return [
            'user_id' => User::factory(),
            'certification_type' => $this->faker->randomElement(CertificationType::cases()),
            'certification_number' => 'CERT-' . str_pad((string) $this->faker->numberBetween(0, 99999999), 8, '0', STR_PAD_LEFT),
            'issued_date' => $issuedDate->format('Y-m-d'),
            'expiry_date' => $expiryDate->format('Y-m-d'),
            'document_path' => 'certifications/' . $this->faker->uuid() . '.pdf',
        ];
    }

    public function expired(): static
    {
        return $this->state(fn (array $attributes) => [
            'expiry_date' => $this->faker->dateTimeBetween('-1 year', '-1 day')->format('Y-m-d'),
        ]);
    }

    public function firstAid(): static
    {
        return $this->state(fn (array $attributes) => [
            'certification_type' => CertificationType::FIRST_AID,
        ]);
    }

    public function cpr(): static
    {
        return $this->state(fn (array $attributes) => [
            'certification_type' => CertificationType::CPR,
        ]);
    }

    public function ndisWorkerScreening(): static
    {
        return $this->state(fn (array $attributes) => [
            'certification_type' => CertificationType::NDIS_WORKER_SCREENING,
        ]);
    }
}

