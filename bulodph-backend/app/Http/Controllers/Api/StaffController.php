<?php

declare(strict_types=1);

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Models\User;
use Illuminate\Http\JsonResponse;
use Illuminate\Http\Request;

final class StaffController extends Controller
{
    /**
     * List staff (car owners + marketing) for announcements recipient selection.
     */
    public function index(Request $request): JsonResponse
    {
        $teamId = $request->user()->organization_id;
        $users = User::query()
            ->where('organization_id', $teamId)
            ->whereHas('roles', fn ($q) => $q->where('name', 'car_owner'))
            ->orderBy('name')
            ->get(['id', 'name', 'email']);

        $data = $users->map(function (User $u) {
            return [
                'id' => $u->id,
                'name' => $u->name ?? $u->email,
                'email' => $u->email,
            ];
        });

        return response()->json(['data' => $data->values()->all()]);
    }
}
