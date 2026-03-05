<?php

declare(strict_types=1);

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Models\BlogPost;
use Illuminate\Http\Request;

final class BlogPostController extends Controller
{
    public function index()
    {
        return response()->json([
            'data' => BlogPost::query()
                ->where('status', 'published')
                ->orderByDesc('published_at')
                ->get(),
        ]);
    }

    public function show(BlogPost $post)
    {
        return response()->json(['data' => $post]);
    }

    public function store(Request $request)
    {
        $payload = $request->validate([
            'slug' => ['required', 'string'],
            'title' => ['required', 'string'],
            'content' => ['required', 'string'],
            'status' => ['nullable', 'string'],
            'published_at' => ['nullable', 'date'],
        ]);

        $post = BlogPost::create($payload);

        return response()->json(['data' => $post], 201);
    }

    public function update(Request $request, BlogPost $post)
    {
        $payload = $request->validate([
            'title' => ['sometimes', 'string'],
            'content' => ['sometimes', 'string'],
            'status' => ['sometimes', 'string'],
            'published_at' => ['nullable', 'date'],
        ]);

        $post->update($payload);

        return response()->json(['data' => $post]);
    }
}
