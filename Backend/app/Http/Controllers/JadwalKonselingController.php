<?php

namespace App\Http\Controllers;

use App\Models\JadwalKonseling;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Validator;

class JadwalKonselingController extends Controller
{
    public function index(Request $request)
    {
        $this->generateMissingSchedules();

        $schedules = JadwalKonseling::orderBy('tanggal', 'asc')
            ->orderBy('jam_mulai', 'asc')
            ->get();

        return response()->json([
            'success' => true,
            'data' => $schedules
        ]);
    }

    private function generateMissingSchedules()
    {
        $counselors = \App\Models\User::whereNotNull('hari_praktik')->get();
        $today = new \DateTime();

        foreach ($counselors as $counselor) {
            $practiceDays = $counselor->hari_praktik ?? [];
            $availableTimes = $counselor->jam_tersedia ?? [];

            if (empty($practiceDays) || empty($availableTimes)) {
                continue;
            }

            for ($i = 0; $i < 14; $i++) {
                $date = clone $today;
                $date->modify("+$i day");
                $weekday = (int)$date->format('N'); // 1 (Mon) to 7 (Sun)

                if (in_array($weekday, $practiceDays)) {
                    $dateStr = $date->format('Y-m-d');

                    foreach ($availableTimes as $timeStr) {
                        preg_match('/(\d{1,2}):(\d{2})/', $timeStr, $matches);
                        if (!empty($matches)) {
                            $hour = str_pad($matches[1], 2, '0', STR_PAD_LEFT);
                            $minute = $matches[2];
                            $startTime = "$hour:$minute:00";

                            // End time defaults to 1 hour later
                            $endHour = str_pad((int)$hour + 1, 2, '0', STR_PAD_LEFT);
                            $endTime = "$endHour:$minute:00";

                            $exists = JadwalKonseling::where('tanggal', $dateStr)
                                ->where('jam_mulai', $startTime)
                                ->exists();

                            if (!$exists) {
                                JadwalKonseling::create([
                                    'tanggal' => $dateStr,
                                    'jam_mulai' => $startTime,
                                    'jam_selesai' => $endTime,
                                    'lokasi' => 'Gedung TI Lt. 3',
                                    'status' => 'Tersedia',
                                ]);
                            }
                        }
                    }
                }
            }
        }
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

        $schedule = JadwalKonseling::create([
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
        if ($schedule->konseling()->where('status', '!=', 'Dibatalkan')->exists()) {
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
