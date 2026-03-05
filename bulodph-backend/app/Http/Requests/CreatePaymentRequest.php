<?php

declare(strict_types=1);

namespace App\Http\Requests;

use Illuminate\Foundation\Http\FormRequest;

final class CreatePaymentRequest extends FormRequest
{
    public function authorize(): bool
    {
        return true;
    }

    /**
     * @return array<string, array<int, string>>
     */
    public function rules(): array
    {
        return [
            'booking_id' => ['required', 'string', 'max:64'],
            'amount' => ['required', 'integer', 'min:1'],
            'currency' => ['nullable', 'string', 'in:PHP,USD'],
            'return_url' => ['nullable', 'url', 'max:512'],
            'cancel_url' => ['nullable', 'url', 'max:512'],
        ];
    }

    /**
     * @return array<string, string>
     */
    public function messages(): array
    {
        return [
            'booking_id.required' => 'Booking reference is required.',
            'amount.required' => 'Amount is required.',
            'amount.min' => 'Amount must be at least 1.',
        ];
    }
}
