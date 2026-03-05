<?php

declare(strict_types=1);

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Models\PaymentWebhookLog;

final class PaymentWebhookLogController extends Controller
{
    public function index()
    {
        return response()->json(['data' => PaymentWebhookLog::query()->latest()->get()]);
    }
}
