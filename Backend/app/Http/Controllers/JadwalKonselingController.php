<?php

namespace App\Http\Controllers;

use App\Models\JadwalKonseling;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Validator;

class JadwalKonselingController extends Controller
{
    public function index(Request $request)
    {
        $user = $request->user();
        $query = JadwalKonseling::orderBy('tanggal', 'asc')
            ->orderBy('jam_mulai', 'asc');

        if ($user && $user->role === 'admin') {
            $query->where('admin_id', $user->id);
        }

        $schedules = $query->get();

        return response()->json([
            'success' => true,
            'data' => $schedules
        ]);
    }

    public function store(Request $request)
    {
        if ($request->user()->role !== 'admin') {
            return response()->json([
                'success' => false,
                'message' => 'Akses ditolak'
            ], 403);
        }

        $validator = Validator::make($request->all(), [
            'tanggal' => 'required|date',
            'jam_mulai' => 'required|date_format:H:i',
            'jam_selesai' => 'required|date_format:H:i',
            'lokasi' => 'nullable|string|max:255',
            'status' => 'nullable|in:Tersedia,Penuh,Selesai',
        ]);

        if ($validator->fails()) {
            return response()->json([
                'success' => false,
                'message' => 'Validasi gagal',
                'errors' => $validator->errors()
            ], 422);
        }

        $tanggalBaru = substr($request->tanggal, 0, 10);
        $existingDates = JadwalKonseling::where('admin_id', $request->user()->id)
            ->selectRaw('DATE(tanggal) as tgl')
            ->groupBy('tgl')
            ->pluck('tgl');

        $isNewDay = !$existingDates->contains($tanggalBaru);
        if ($isNewDay && $existingDates->count() >= 3) {
            return response()->json([
                'success' => false,
                'message' => 'Maksimal hanya boleh memiliki 3 hari jadwal yang berbeda.'
            ], 422);
        }

        $schedule = JadwalKonseling::create([
            'admin_id' => $request->user()->id,
            'tanggal' => $request->tanggal,
            'jam_mulai' => $request->jam_mulai,
            'jam_selesai' => $request->jam_selesai,
            'lokasi' => $request->lokasi,
            'status' => $request->status ?? 'Tersedia',
        ]);

        return response()->json([
            'success' => true,
            'message' => 'Jadwal berhasil ditambahkan',
            'data' => $schedule
        ], 201);
    }

    public function destroy(Request $request, $id)
    {
        if ($request->user()->role !== 'admin') {
            return response()->json([
                'success' => false,
                'message' => 'Akses ditolak'
            ], 403);
        }

        $schedule = JadwalKonseling::find($id);

        if (!$schedule) {
            return response()->json([
                'success' => false,
                'message' => 'Jadwal tidak ditemukan'
            ], 404);
        }

        // Check if there are active bookings for this schedule
        if ($schedule->konseling()->whereNotIn('status', ['Dibatalkan', 'Selesai'])->exists()) {
            return response()->json([
                'success' => false,
                'message' => 'Jadwal tidak dapat dihapus karena sudah memiliki pemesanan aktif'
            ], 400);
        }

        $schedule->delete();

        return response()->json([
            'success' => true,
            'message' => 'Jadwal berhasil dihapus'
        ]);
    }
}
