<?php

namespace App\Http\Controllers;

use App\Models\Notifikasi;
use Illuminate\Http\Request;

class NotifikasiController extends Controller
{
    public function index(Request $request)
    {
        $notifications = Notifikasi::where('user_id', $request->user()->id)
            ->latest()
            ->get();

        return response()->json([
            'success' => true,
            'data' => $notifications
        ]);
    }

    public function markAsRead(Request $request, $id)
    {
        $notification = Notifikasi::where('user_id', $request->user()->id)->find($id);

        if (!$notification) {
            return response()->json([
                'success' => false,
                'message' => 'Notifikasi tidak ditemukan'
            ], 404);
        }

        $notification->sudah_dibaca = true;
        $notification->save();

        return response()->json([
            'success' => true,
            'message' => 'Notifikasi ditandai sebagai dibaca',
            'data' => $notification
        ]);
    }

    public function markAllAsRead(Request $request)
    {
        Notifikasi::where('user_id', $request->user()->id)
            ->where('sudah_dibaca', false)
            ->update(['sudah_dibaca' => true]);

        return response()->json([
            'success' => true,
            'message' => 'Semua notifikasi ditandai sebagai dibaca'
        ]);
    }
}
