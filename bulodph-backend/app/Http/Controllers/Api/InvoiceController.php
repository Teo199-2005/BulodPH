<?php

declare(strict_types=1);

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Models\Invoice;
use Illuminate\Http\Request;

final class InvoiceController extends Controller
{
    public function index(Request $request)
    {
        $query = Invoice::query()->latest();

        if (! $request->user()?->hasRole('admin')) {
            $query->where('user_id', $request->user()?->id);
        }

        return response()->json(['data' => $query->get()]);
    }

    public function store(Request $request)
    {
        $payload = $request->validate([
            'booking_reference' => ['nullable', 'string'],
            'user_id' => ['nullable', 'uuid'],
            'owner_id' => ['nullable', 'uuid'],
            'subtotal' => ['nullable', 'numeric', 'min:0'],
            'taxes' => ['nullable', 'numeric', 'min:0'],
            'total' => ['nullable', 'numeric', 'min:0'],
            'currency' => ['nullable', 'string'],
            'status' => ['nullable', 'string'],
        ]);

        $invoice = Invoice::create([
            ...$payload,
            'currency' => $payload['currency'] ?? 'PHP',
            'status' => $payload['status'] ?? 'issued',
        ]);

        return response()->json(['data' => $invoice], 201);
    }

    public function show(Invoice $invoice)
    {
        return response()->json(['data' => $invoice]);
    }
}
