<?php

declare(strict_types=1);

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Models\Payout;
use App\Models\RentalBooking;
use Illuminate\Http\JsonResponse;
use Illuminate\Http\Request;
use Illuminate\Support\Carbon;

final class ReportController extends Controller
{
    /**
     * Financial summary for the reports page (admin).
     * Optional query: startDate, endDate (Y-m-d).
     */
    public function financial(Request $request): JsonResponse
    {
        $start = $request->input('startDate') ? Carbon::parse($request->input('startDate'))->startOfDay() : now()->subDays(30)->startOfDay();
        $end = $request->input('endDate') ? Carbon::parse($request->input('endDate'))->endOfDay() : now()->endOfDay();
        $prevStart = $start->copy()->subDays($start->diffInDays($end) + 1);
        $prevEnd = $start->copy()->subDay()->endOfDay();

        $completedStatuses = ['Completed', 'Approved', 'Active'];
        $totalRevenue = (int) RentalBooking::query()
            ->whereBetween('created_at', [$start, $end])
            ->whereIn('status', $completedStatuses)
            ->sum('amount');

        $prevRevenue = (int) RentalBooking::query()
            ->whereBetween('created_at', [$prevStart, $prevEnd])
            ->whereIn('status', $completedStatuses)
            ->sum('amount');
        $totalRevenueTrend = $prevRevenue > 0 ? round((($totalRevenue - $prevRevenue) / $prevRevenue) * 100, 1) : 0;

        $paidToOwners = (int) Payout::query()
            ->whereNotNull('paid_at')
            ->whereBetween('paid_at', [$start, $end])
            ->sum('amount');
        $prevPaid = (int) Payout::query()
            ->whereNotNull('paid_at')
            ->whereBetween('paid_at', [$prevStart, $prevEnd])
            ->sum('amount');
        $paidToOwnersTrend = $prevPaid > 0 ? round((($paidToOwners - $prevPaid) / $prevPaid) * 100, 1) : 0;

        $pendingPayouts = (int) Payout::query()->where('status', 'pending')->sum('amount');
        $pendingPayoutsCount = Payout::query()->where('status', 'pending')->count();
        $overduePayouts = (int) Payout::query()
            ->where('status', 'pending')
            ->where('requested_at', '<', now()->subDays(7))
            ->sum('amount');
        $overduePayoutsCount = Payout::query()
            ->where('status', 'pending')
            ->where('requested_at', '<', now()->subDays(7))
            ->count();

        $data = [
            'totalRevenue' => $totalRevenue,
            'totalRevenueTrend' => $totalRevenueTrend,
            'paidToOwners' => $paidToOwners,
            'paidToOwnersTrend' => $paidToOwnersTrend,
            'pendingPayouts' => $pendingPayouts,
            'pendingPayoutsCount' => $pendingPayoutsCount,
            'overduePayouts' => $overduePayouts,
            'overduePayoutsCount' => $overduePayoutsCount,
        ];

        return response()->json(['data' => $data]);
    }

    /**
     * Booking stats (counts by status) for the reports page (admin).
     */
    public function bookings(Request $request): JsonResponse
    {
        $start = $request->input('startDate') ? Carbon::parse($request->input('startDate'))->startOfDay() : now()->subDays(30)->startOfDay();
        $end = $request->input('endDate') ? Carbon::parse($request->input('endDate'))->endOfDay() : now()->endOfDay();

        $query = RentalBooking::query()->whereBetween('created_at', [$start, $end]);

        $completed = (clone $query)->where('status', 'Completed')->count();
        $scheduled = (clone $query)->whereIn('status', ['Approved', 'Active'])->count();
        $pending = (clone $query)->where('status', 'Pending')->count();
        $cancelled = (clone $query)->whereIn('status', ['Cancelled', 'Rejected'])->count();

        $data = [
            'completed' => $completed,
            'scheduled' => $scheduled,
            'pending' => $pending,
            'cancelled' => $cancelled,
        ];

        return response()->json(['data' => $data]);
    }
}
