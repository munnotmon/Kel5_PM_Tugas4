<?php

namespace App\Http\Controllers;

use App\Models\Pesan;
use App\Models\Konseling;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Validator;

class ChatController extends Controller
{
    public function getMessages(Request $request, $konselingId)
    {
        $user = $request->user();
        $session = Konseling::find($konselingId);

        if (!$session) {
            return response()->json([
                'success' => false,
                'message' => 'Sesi konseling tidak ditemukan'
            ], 404);
        }

        // Validate access
        if ($user->role !== 'admin' && $session->mahasiswa_id !== $user->id) {
            return response()->json([
                'success' => false,
                'message' => 'Akses ditolak'
            ], 403);
        }

        // Update read status for incoming messages
        Pesan::where('konseling_id', $konselingId)
            ->where('sender_id', '!=', $user->id)
            ->where('status_pesan', 'Terkirim')
            ->update(['status_pesan' => 'Dibaca']);

        $messages = Pesan::with('sender')
            ->where('konseling_id', $konselingId)
            ->orderBy('created_at', 'asc')
            ->get();

        return response()->json([
            'success' => true,
            'data' => $messages
        ]);
    }

    public function sendMessage(Request $request)
    {
        $validator = Validator::make($request->all(), [
            'konseling_id' => 'required|exists:konseling,id',
            'isi_pesan' => 'nullable|string',
            'gambar' => 'nullable|file|max:20480',
        ]);

        if ($validator->fails()) {
            return response()->json([
                'success' => false,
                'message' => 'Validasi gagal',
                'errors' => $validator->errors()
            ], 422);
        }

        $session = Konseling::find($request->konseling_id);

        // Validate access
        if ($request->user()->role !== 'admin' && $session->mahasiswa_id !== $request->user()->id) {
            return response()->json([
                'success' => false,
                'message' => 'Akses ditolak'
            ], 403);
        }

        $path = null;
        if ($request->hasFile('gambar')) {
            $file = $request->file('gambar');
            $fileName = time() . '_' . rand(100, 999) . '_' . $file->getClientOriginalName();
            $file->storeAs('chat', $fileName, 'public');
            $path = asset('storage/chat/' . $fileName);
        }

        $message = Pesan::create([
            'konseling_id' => $request->konseling_id,
            'sender_id' => $request->user()->id,
            'isi_pesan' => $request->isi_pesan ?? 'Lampiran Gambar',
            'path_gambar' => $path,
            'status_pesan' => 'Terkirim',
        ]);

        // Create notification for the recipient
        if ($request->user()->role === 'admin') {
            // Admin sending to student
            \App\Models\Notifikasi::create([
                'user_id' => $session->mahasiswa_id,
                'judul' => 'Pesan Baru dari Admin',
                'isi' => $message->isi_pesan ?? 'Mengirim lampiran gambar',
                'sudah_dibaca' => false,
            ]);
        } else {
            // Student sending to admin
            if ($session->admin_id) {
                \App\Models\Notifikasi::create([
                    'user_id' => $session->admin_id,
                    'judul' => 'Pesan Baru dari Mahasiswa',
                    'isi' => $message->isi_pesan ?? 'Mengirim lampiran gambar',
                    'sudah_dibaca' => false,
                ]);
            } else {
                // Notify all admins if admin_id is null
                $admins = \App\Models\User::where('role', 'admin')->get();
                foreach ($admins as $admin) {
                    \App\Models\Notifikasi::create([
                        'user_id' => $admin->id,
                        'judul' => 'Pesan Baru dari Mahasiswa',
                        'isi' => $message->isi_pesan ?? 'Mengirim lampiran gambar',
                        'sudah_dibaca' => false,
                    ]);
                }
            }
        }

        return response()->json([
            'success' => true,
            'data' => $message->load('sender')
        ], 201);
    }
}
