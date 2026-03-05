<?php

declare(strict_types=1);

namespace App\Actions\Certifications;

use App\Domain\Shifts\Enums\CertificationType;
use App\Models\Certification;
use Carbon\Carbon;
use Illuminate\Validation\ValidationException;

final readonly class ValidateStaffCertificationsAction
{
    /**
     * Validate that a staff member has all required certifications and they are not expired.
     *
     * @throws ValidationException
     */
    public function execute(string $userId, Carbon $asOfDate): void
    {
        $requiredCertifications = [
            CertificationType::FIRST_AID,
            CertificationType::CPR,
            CertificationType::NDIS_WORKER_SCREENING,
        ];

        $validCertifications = Certification::where('user_id', $userId)
            ->whereIn('certification_type', array_map(fn($cert) => $cert->value, $requiredCertifications))
            ->where('expiry_date', '>=', $asOfDate)
            ->pluck('certification_type')
            ->map(fn($c) => $c instanceof CertificationType ? $c->value : (string) $c)
            ->values()
            ->toArray();

        $missingCertifications = array_diff(
            array_map(fn($cert) => $cert->value, $requiredCertifications),
            $validCertifications
        );

        if (!empty($missingCertifications)) {
            $labels = array_map(
                fn($certType) => CertificationType::from($certType)->label(),
                $missingCertifications
            );

            throw ValidationException::withMessages([
                'primary_worker_id' => [
                    'Worker is missing or has expired certifications: ' . implode(', ', $labels)
                ]
            ]);
        }
    }
}

