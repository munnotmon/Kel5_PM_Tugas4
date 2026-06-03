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
            'isi_pesan' => 'required|string',
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

        $message = Pesan::create([
            'konseling_id' => $request->konseling_id,
            'sender_id' => $request->user()->id,
            'isi_pesan' => $request->isi_pesan,
            'status_pesan' => 'Terkirim',
        ]);

        return response()->json([
            'success' => true,
            'data' => $message->load('sender')
        ], 201);
    }
}
