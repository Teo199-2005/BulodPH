<?php

declare(strict_types=1);

namespace App\Domain\Shifts\Enums;

enum CertificationType: string
{
    case FIRST_AID = 'FIRST_AID';
    case CPR = 'CPR';
    case NDIS_WORKER_SCREENING = 'NDIS_WORKER_SCREENING';
    case WWCC = 'WWCC';
    case MANUAL_HANDLING = 'MANUAL_HANDLING';
    case MEDICATION_ADMINISTRATION = 'MEDICATION_ADMINISTRATION';

    public function label(): string
    {
        return match ($this) {
            self::FIRST_AID => 'First Aid',
            self::CPR => 'CPR',
            self::NDIS_WORKER_SCREENING => 'NDIS Worker Screening',
            self::WWCC => 'Working with Children Check',
            self::MANUAL_HANDLING => 'Manual Handling',
            self::MEDICATION_ADMINISTRATION => 'Medication Administration',
        };
    }

    public function isRequired(): bool
    {
        return match ($this) {
            self::FIRST_AID, self::CPR, self::NDIS_WORKER_SCREENING => true,
            default => false,
        };
    }
}

