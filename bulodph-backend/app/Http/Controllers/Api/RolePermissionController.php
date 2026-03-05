<?php

declare(strict_types=1);

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use Illuminate\Http\Request;
use Spatie\Permission\Models\Permission;
use Spatie\Permission\Models\Role;

final class RolePermissionController extends Controller
{
    public function index()
    {
        return response()->json([
            'data' => [
                'roles' => Role::query()->with('permissions')->get(),
                'permissions' => Permission::query()->orderBy('name')->get(),
            ],
        ]);
    }

    public function updateRolePermissions(Request $request, Role $role)
    {
        $payload = $request->validate([
            'permissions' => ['required', 'array'],
            'permissions.*' => ['string'],
        ]);

        $role->syncPermissions($payload['permissions']);

        return response()->json(['data' => $role->load('permissions')]);
    }
}
