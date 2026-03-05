<?php

declare(strict_types=1);

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Models\Receipt;

final class ReceiptController extends Controller
{
    public function show(Receipt $receipt)
    {
        return response()->json(['data' => $receipt]);
    }
}
