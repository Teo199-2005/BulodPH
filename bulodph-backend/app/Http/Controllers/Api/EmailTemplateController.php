<?php

declare(strict_types=1);

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Models\EmailTemplate;
use Illuminate\Http\Request;

final class EmailTemplateController extends Controller
{
    public function index()
    {
        return response()->json(['data' => EmailTemplate::query()->orderBy('name')->get()]);
    }

    public function store(Request $request)
    {
        $payload = $request->validate([
            'name' => ['required', 'string'],
            'subject' => ['required', 'string'],
            'body' => ['required', 'string'],
            'is_active' => ['boolean'],
        ]);

        $template = EmailTemplate::create($payload);

        return response()->json(['data' => $template], 201);
    }

    public function update(Request $request, EmailTemplate $template)
    {
        $payload = $request->validate([
            'subject' => ['sometimes', 'string'],
            'body' => ['sometimes', 'string'],
            'is_active' => ['sometimes', 'boolean'],
        ]);

        $template->update($payload);

        return response()->json(['data' => $template]);
    }
}
