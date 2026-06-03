<?php

namespace App\Http\Controllers;

use App\Models\LaporanPerundungan;
use App\Models\Bukti;
use App\Models\Notifikasi;
use App\Models\User;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Validator;
use Illuminate\Support\Facades\Storage;

class LaporanController extends Controller
{
    public function index(Request $request)
    {
        $user = $request->user();

        if ($user->role === 'admin') {
            $reports = LaporanPerundungan::with(['pelapor.profilMahasiswa', 'bukti'])->latest()->get();
        } else {
            $reports = LaporanPerundungan::with('bukti')
                ->where('pelapor_id', $user->id)
                ->latest()
                ->get();
        }

        return response()->json([
            'success' => true,
            'data' => $reports
        ]);
    }

    public function store(Request $request)
    {
        \Illuminate\Support\Facades\Log::info('LaporanController@store request data: ', $request->all());

        $validator = Validator::make($request->all(), [
            'judul_pelaporan' => 'required|string|max:255',
            'jenis_perundungan' => 'nullable|string|max:100',
            'kronologi' => 'required|string',
            'deskripsi_pelaku' => 'nullable|string',
            'lokasi' => 'nullable|string|max:255',
            'tanggal_kejadian' => 'nullable|date',
            'bukti_files' => 'nullable|array',
            'bukti_files.*' => 'file|max:1048576', // max 1GB per file
            'program_studi' => 'nullable|string|max:100',
        ]);

        if ($validator->fails()) {
            \Illuminate\Support\Facades\Log::warning('LaporanController@store validation failed: ', $validator->errors()->toArray());
            return response()->json([
                'success' => false,
                'message' => implode(' ', $validator->errors()->all()),
                'errors' => $validator->errors()
            ], 422);
        }

        $report = LaporanPerundungan::create([
            'pelapor_id' => $request->user()->id,
            'judul_pelaporan' => $request->judul_pelaporan,
            'jenis_perundungan' => $request->jenis_perundungan,
            'kronologi' => $request->kronologi,
            'deskripsi_pelaku' => $request->deskripsi_pelaku,
            'lokasi' => $request->lokasi,
            'tanggal_kejadian' => $request->tanggal_kejadian,
            'status' => 'Menunggu',
        ]);

        // Update program studi in mahasiswa's profile if provided
        if ($request->has('program_studi') && $request->program_studi) {
            $user = $request->user();
            $profile = \App\Models\ProfilMahasiswa::where('user_id', $user->id)->first();
            if ($profile) {
                $profile->program_studi = $request->program_studi;
                $profile->save();
            }
        }

        // Process attachments/bukti files
        if ($request->hasFile('bukti_files')) {
            foreach ($request->file('bukti_files') as $file) {
                $originalName = $file->getClientOriginalName();
                $fileName = time() . '_' . rand(100, 999) . '_' . $originalName;
                $path = $file->storeAs('public/bukti', $fileName);

                Bukti::create([
                    'laporan_id' => $report->id,
                    'nama_file' => $originalName,
                    'path_file' => asset('storage/bukti/' . $fileName),
                ]);
            }
        }

        // Notify admins about new report
        $admins = User::where('role', 'admin')->get();
        foreach ($admins as $admin) {
            Notifikasi::create([
                'user_id' => $admin->id,
                'judul' => 'Laporan Perundungan Baru',
                'isi' => 'Mahasiswa ' . $request->user()->nama . ' melaporkan perundungan: "' . $report->judul_pelaporan . '"',
                'sudah_dibaca' => false,
            ]);
        }

        return response()->json([
            'success' => true,
            'message' => 'Laporan berhasil diajukan',
            'data' => $report->load('bukti')
        ], 201);
    }

    public function show(Request $request, $id)
    {
        $user = $request->user();
        $report = LaporanPerundungan::with(['pelapor.profilMahasiswa', 'bukti'])->find($id);

        if (!$report) {
            return response()->json([
                'success' => false,
                'message' => 'Laporan tidak ditemukan'
            ], 404);
        }

        // Check if report belongs to user or user is admin
        if ($user->role !== 'admin' && $report->pelapor_id !== $user->id) {
            return response()->json([
                'success' => false,
                'message' => 'Akses ditolak'
            ], 403);
        }

        return response()->json([
            'success' => true,
            'data' => $report
        ]);
    }

    public function updateStatus(Request $request, $id)
    {
        $user = $request->user();

        if ($user->role !== 'admin') {
            return response()->json([
                'success' => false,
                'message' => 'Akses ditolak. Hanya admin yang dapat mengubah status laporan.'
            ], 403);
        }

        $validator = Validator::make($request->all(), [
            'status' => 'required|in:Menunggu,Diproses,Ditolak,Selesai',
        ]);

        if ($validator->fails()) {
            return response()->json([
                'success' => false,
                'message' => 'Status tidak valid',
                'errors' => $validator->errors()
            ], 422);
        }

        $report = LaporanPerundungan::find($id);

        if (!$report) {
            return response()->json([
                'success' => false,
                'message' => 'Laporan tidak ditemukan'
            ], 404);
        }

        $report->status = $request->status;
        $report->save();

        // Notify reporter about status update
        Notifikasi::create([
            'user_id' => $report->pelapor_id,
            'judul' => 'Status Laporan Diperbarui',
            'isi' => 'Laporan Anda "' . $report->judul_pelaporan . '" sekarang berstatus: ' . $report->status,
            'sudah_dibaca' => false,
        ]);

        return response()->json([
            'success' => true,
            'message' => 'Status laporan berhasil diperbarui',
            'data' => $report->load(['pelapor.profilMahasiswa', 'bukti'])
        ]);
    }

    public function getOrCreateChatForReport(Request $request, $id)
    {
        $user = $request->user();

        if ($user->role !== 'admin') {
            return response()->json([
                'success' => false,
                'message' => 'Akses ditolak. Hanya admin yang dapat menghubungi pelapor.'
            ], 403);
        }

        $report = LaporanPerundungan::find($id);

        if (!$report) {
            return response()->json([
                'success' => false,
                'message' => 'Laporan tidak ditemukan'
            ], 404);
        }

        // Cari sesi chat tindak lanjut laporan yang sudah ada antara admin ini dan pelapor yang masih aktif
        $session = \App\Models\Konseling::where('mahasiswa_id', $report->pelapor_id)
            ->where('admin_id', $user->id)
            ->where('tipe', 'laporan')
            ->whereNotIn('status', ['Selesai', 'Dibatalkan'])
            ->first();

        if (!$session) {
            $session = \App\Models\Konseling::create([
                'mahasiswa_id' => $report->pelapor_id,
                'admin_id' => $user->id,
                'jadwal_id' => null,
                'keluhan' => 'Tindak lanjut laporan: ' . $report->judul_pelaporan,
                'status' => 'Berlangsung',
                'tipe' => 'laporan',
            ]);
        }

        return response()->json([
            'success' => true,
            'message' => 'Sesi chat berhasil dihubungkan',
            'data' => $session->load(['mahasiswa.profilMahasiswa', 'admin', 'jadwalKonseling'])
        ]);
    }
}
