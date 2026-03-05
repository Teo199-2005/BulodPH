<?php

declare(strict_types=1);

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Models\Client;
use Illuminate\Http\JsonResponse;
use Illuminate\Http\Request;

final class ClientController extends Controller
{
    public function index(Request $request): JsonResponse
    {
        $search = $this->sanitizeSearchLike($request->input('search'));
        $clients = Client::query()
            ->with(['ndisPlans' => fn($q) => $q->where('is_active', true)])
            ->when($search !== null && $search !== '', function ($q) use ($search) {
                $q->where(function ($query) use ($search) {
                    $query->where('first_name', 'like', '%' . $search . '%')
                        ->orWhere('last_name', 'like', '%' . $search . '%')
                        ->orWhere('ndis_number', 'like', '%' . $search . '%');
                });
            })
            ->orderBy('last_name')
            ->orderBy('first_name')
            ->paginate(20);

        return response()->json($clients);
    }

    public function store(Request $request): JsonResponse
    {
        $validated = $request->validate([
            'ndis_number' => 'required|string|max:20|unique:clients,ndis_number',
            'first_name' => 'required|string|max:100',
            'last_name' => 'required|string|max:100',
            'date_of_birth' => 'required|date',
            'address_line_1' => 'required|string|max:255',
            'address_line_2' => 'nullable|string|max:255',
            'suburb' => 'required|string|max:100',
            'state' => 'required|string|in:NSW,VIC,QLD,SA,WA,TAS,NT,ACT',
            'postcode' => 'required|string|max:4',
            'latitude' => 'required|numeric',
            'longitude' => 'required|numeric',
            'emergency_contact_name' => 'required|string|max:200',
            'emergency_contact_phone' => 'required|string|max:20',
        ]);

        $validated['organization_id'] = auth()->user()->organization_id;

        $client = Client::create($validated);

        return response()->json($client, 201);
    }

    public function show(Client $client): JsonResponse
    {
        $this->authorize('view', $client);

        return response()->json(
            $client->load(['ndisPlans.budgetCategories.planLineItems.supportItem'])
        );
    }

    public function update(Request $request, Client $client): JsonResponse
    {
        $this->authorize('update', $client);

        $validated = $request->validate([
            'first_name' => 'sometimes|string|max:100',
            'last_name' => 'sometimes|string|max:100',
            'address_line_1' => 'sometimes|string|max:255',
            'address_line_2' => 'nullable|string|max:255',
            'suburb' => 'sometimes|string|max:100',
            'state' => 'sometimes|string|in:NSW,VIC,QLD,SA,WA,TAS,NT,ACT',
            'postcode' => 'sometimes|string|max:4',
            'latitude' => 'sometimes|numeric',
            'longitude' => 'sometimes|numeric',
            'emergency_contact_name' => 'sometimes|string|max:200',
            'emergency_contact_phone' => 'sometimes|string|max:20',
        ]);

        $client->update($validated);

        return response()->json($client);
    }

    public function destroy(Client $client): JsonResponse
    {
        $this->authorize('delete', $client);

        $client->delete();

        return response()->json(null, 204);
    }

    private function sanitizeSearchLike(mixed $value): ?string
    {
        if ($value === null || $value === '') {
            return null;
        }
        $s = \is_string($value) ? $value : (string) $value;
        $s = mb_substr(trim($s), 0, 100);
        if ($s === '') {
            return null;
        }
        return str_replace(['\\', '%', '_'], ['\\\\', '\\%', '\\_'], $s);
    }
}

