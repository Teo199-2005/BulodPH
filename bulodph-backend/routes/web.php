<?php

use Illuminate\Support\Facades\Route;

/*
| Your website is the Vue frontend (hpa-plus-frontend). This Laravel app is the API backend only.
| Hit /api/* for API routes. Root URL below just identifies the service.
*/
Route::get('/', function () {
    return response()->json([
        'name'    => 'HPA Plus API',
        'message' => 'This is the API backend. Use the Vue frontend as your website. API routes are under /api.',
        'api'     => url('/api'),
    ], 200, ['Content-Type' => 'application/json']);
});
