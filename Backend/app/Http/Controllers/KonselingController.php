<?php

namespace App\Http\Controllers;

use App\Models\Konseling;
use App\Models\JadwalKonseling;
use App\Models\Notifikasi;
use App\Models\User;
use App\Models\Admin;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Validator;

class KonselingController extends Controller
{
    public function index(Request $request)
    {
        $user = $request->user();

        if ($user->role === 'admin') {
            $sessions = Konseling::with(['mahasiswa.profilMahasiswa', 'admin', 'jadwalKonseling', 'pesan'])
                ->latest()
                ->get();
        } else {
            $sessions = Konseling::with(['admin', 'jadwalKonseling', 'pesan'])
                ->where('mahasiswa_id', $user->id)
                ->latest()
                ->get();
        }

        return response()->json([
            'success' => true,
            'data' => $sessions
        ]);
    }

    public function store(Request $request)
    {
        $validator = Validator::make($request->all(), [
            'jadwal_id' => 'required|exists:jadwal_konseling,id',
            'keluhan' => 'nullable|string',
            'admin_id' => 'nullable|exists:users,id',
        ]);

        if ($validator->fails()) {
            return response()->json([
                'success' => false,
                'message' => 'Validasi gagal',
                'errors' => $validator->errors()
            ], 422);
        }

        $schedule = JadwalKonseling::find($request->jadwal_id);

        if ($request->admin_id) {
            $adminId = $request->admin_id;
            
            $sessionsOnDate = Konseling::where('admin_id', $adminId)
                ->where('status', '!=', 'Dibatalkan')
                ->with('jadwalKonseling')
                ->get();
            
            $targetDate = \Carbon\Carbon::parse($schedule->tanggal)->format('Y-m-d');
            $sessionCountOnDate = 0;
            
            foreach ($sessionsOnDate as $session) {
                $dates = [];
                if ($session->jadwalKonseling) {
                    $dates[] = $session->jadwalKonseling->tanggal->format('Y-m-d');
                }
                if (in_array($session->status, ['Selesai', 'Berlangsung']) && $session->updated_at) {
                    $dates[] = $session->updated_at->format('Y-m-d');
                }
                if (in_array($targetDate, $dates)) {
                    $sessionCountOnDate++;
                }
            }

            if ($sessionCountOnDate >= 5) {
                return response()->json([
                    'success' => false,
                    'message' => 'Konselor ini telah mencapai batas jatah maksimal sesi untuk tanggal tersebut.'
                ], 400);
            }
        }

        if ($schedule->status !== 'Tersedia') {
            return response()->json([
                'success' => false,
                'message' => 'Jadwal ini sudah tidak tersedia'
            ], 400);
        }

        // Calculate queue number for this schedule slot
        $queueNumber = Konseling::where('jadwal_id', $schedule->id)->count() + 1;

        $session = Konseling::create([
            'mahasiswa_id' => $request->user()->id,
            'admin_id' => $request->admin_id,
            'jadwal_id' => $schedule->id,
            'nomor_antrian' => $queueNumber,
            'keluhan' => $request->keluhan,
            'status' => 'Diajukan',
        ]);

        // Mark schedule as full
        $schedule->status = 'Penuh';
        $schedule->save();

        // Notify admins
        $admins = Admin::get();
        foreach ($admins as $admin) {
            Notifikasi::create([
                'user_id' => $admin->id,
                'judul' => 'Pengajuan Konseling Baru',
                'isi' => 'Mahasiswa ' . $request->user()->nama . ' mengajukan sesi konseling untuk tanggal ' . $schedule->tanggal->format('Y-m-d'),
                'sudah_dibaca' => false,
            ]);
        }

        return response()->json([
            'success' => true,
            'message' => 'Konseling berhasil diajukan',
            'data' => $session->load('jadwalKonseling')
        ], 201);
    }

    public function show(Request $request, $id)
    {
        $user = $request->user();
        $session = Konseling::with(['mahasiswa.profilMahasiswa', 'admin', 'jadwalKonseling', 'pesan.sender'])->find($id);

        if (!$session) {
            return response()->json([
                'success' => false,
                'message' => 'Sesi konseling tidak ditemukan'
            ], 404);
        }

        if ($user->role !== 'admin' && $session->mahasiswa_id !== $user->id) {
            return response()->json([
                'success' => false,
                'message' => 'Akses ditolak'
            ], 403);
        }

        return response()->json([
            'success' => true,
            'data' => $session
        ]);
    }

    public function updateStatus(Request $request, $id)
    {
        $user = $request->user();

        $validator = Validator::make($request->all(), [
            'status' => 'required|in:Diajukan,Diterima,Berlangsung,Selesai,Dibatalkan',
            'catatan_konselor' => 'required_if:status,Selesai|string|nullable',
            'rekomendasi_pemulihan' => 'required_if:status,Selesai|string|nullable',
        ]);

        if ($validator->fails()) {
            return response()->json([
                'success' => false,
                'message' => 'Status tidak valid atau form catatan/rekomendasi belum diisi.',
                'errors' => $validator->errors()
            ], 422);
        }

        $session = Konseling::find($id);

        if (!$session) {
            return response()->json([
                'success' => false,
                'message' => 'Sesi konseling tidak ditemukan'
            ], 404);
        }

        $isAdmin = ($user->role === 'admin');
        $isOwner = ($session->mahasiswa_id === $user->id);

        if (!$isAdmin && !($isOwner && $request->status === 'Dibatalkan')) {
            return response()->json([
                'success' => false,
                'message' => 'Akses ditolak'
            ], 403);
        }

        $oldStatus = $session->status;
        $session->status = $request->status;

        if ($request->status === 'Selesai') {
            $session->catatan_konselor = $request->catatan_konselor;
            $session->rekomendasi_pemulihan = $request->rekomendasi_pemulihan;
        }

        // Auto assign current admin as counselor if they accept the session
        if ($isAdmin && ($request->status === 'Diterima' || $request->status === 'Berlangsung')) {
            $session->admin_id = $user->id;
        }

        $session->save();

        // Sync schedule status based on counseling status
        $schedule = JadwalKonseling::find($session->jadwal_id);
        if ($schedule) {
            if ($request->status === 'Selesai') {
                $schedule->status = 'Selesai';
                $schedule->save();
            } elseif ($request->status === 'Dibatalkan') {
                $schedule->status = 'Tersedia';
                $schedule->save();
            }
        }

        // Notify mahasiswa
        Notifikasi::create([
            'user_id' => $session->mahasiswa_id,
            'judul' => 'Status Sesi Konseling Diperbarui',
            'isi' => 'Sesi konseling Anda berstatus: ' . $session->status . ($session->admin_id ? ' dengan ' . $session->admin->nama : ''),
            'sudah_dibaca' => false,
        ]);

        return response()->json([
            'success' => true,
            'message' => 'Status sesi konseling berhasil diperbarui',
            'data' => $session->load(['mahasiswa.profilMahasiswa', 'admin', 'jadwalKonseling'])
        ]);
    }

    public function updateCatatan(Request $request, $id)
    {
        $validator = Validator::make($request->all(), [
            'catatan' => 'nullable|string',
        ]);

        if ($validator->fails()) {
            return response()->json([
                'success' => false,
                'message' => 'Validasi gagal',
                'errors' => $validator->errors()
            ], 422);
        }

        $session = Konseling::find($id);

        if (!$session) {
            return response()->json([
                'success' => false,
                'message' => 'Sesi konseling tidak ditemukan'
            ], 404);
        }

        $user = $request->user();
        if ($user->role !== 'admin' && $session->mahasiswa_id !== $user->id) {
            return response()->json([
                'success' => false,
                'message' => 'Akses ditolak'
            ], 403);
        }

        $session->keluhan = $request->catatan;
        $session->catatan_mahasiswa = $request->catatan;
        $session->save();

        return response()->json([
            'success' => true,
            'message' => 'Catatan berhasil diperbarui',
            'data' => $session
        ]);
    }
}
