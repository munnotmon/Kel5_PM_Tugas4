<?php

use Illuminate\Support\Facades\Route;
use App\Http\Controllers\AuthController;
use App\Http\Controllers\LaporanController;
use App\Http\Controllers\JadwalKonselingController;
use App\Http\Controllers\KonselingController;
use App\Http\Controllers\ChatController;
use App\Http\Controllers\NotifikasiController;
use App\Http\Controllers\KonselorController;

// Public Auth Routes
Route::post('/register', [AuthController::class, 'register']);
Route::post('/login', [AuthController::class, 'login']);
Route::post('/login-google', [AuthController::class, 'loginGoogle']);

// Authenticated Routes (Protected by Sanctum)
Route::middleware('auth:sanctum')->group(function () {
    // Auth & Profile
    Route::get('/me', [AuthController::class, 'me']);
    Route::post('/logout', [AuthController::class, 'logout']);
    Route::post('/profile/update', [AuthController::class, 'updateProfile']);
    Route::get('/mahasiswa', [AuthController::class, 'getMahasiswa']);
    Route::get('/superadmin', [AuthController::class, 'getSuperadmin']);

    // Laporan Perundungan
    Route::get('/laporan', [LaporanController::class, 'index']);
    Route::post('/laporan', [LaporanController::class, 'store']);
    Route::get('/laporan/{id}', [LaporanController::class, 'show']);
    Route::post('/laporan/{id}/status', [LaporanController::class, 'updateStatus']);

    // Konselor (Profil Konselor)
    Route::get('/konselor', [KonselorController::class, 'index']);
    Route::get('/konselor/me', [KonselorController::class, 'myProfile']);
    Route::post('/konselor/me', [KonselorController::class, 'updateMyProfile']);
    Route::get('/konselor/{id}', [KonselorController::class, 'show'])->where('id', '[0-9]+');
    Route::post('/konselor', [KonselorController::class, 'store']);
    Route::post('/konselor/{id}', [KonselorController::class, 'update'])->where('id', '[0-9]+');

    // Jadwal Konseling
    Route::get('/jadwal', [JadwalKonselingController::class, 'index']);
    Route::post('/jadwal', [JadwalKonselingController::class, 'store']);
    Route::delete('/jadwal/{id}', [JadwalKonselingController::class, 'destroy']);

    // Konseling (Pemesanan & Sesi)
    Route::get('/konseling', [KonselingController::class, 'index']);
    Route::post('/konseling', [KonselingController::class, 'store']);
    Route::get('/konseling/{id}', [KonselingController::class, 'show']);
    Route::post('/konseling/{id}/status', [KonselingController::class, 'updateStatus']);

    // Chat
    Route::get('/chat/{konselingId}', [ChatController::class, 'getMessages']);
    Route::post('/chat', [ChatController::class, 'sendMessage']);

    // Notifikasi
    Route::get('/notifikasi', [NotifikasiController::class, 'index']);
    Route::post('/notifikasi/{id}/read', [NotifikasiController::class, 'markAsRead']);
    Route::post('/notifikasi/read-all', [NotifikasiController::class, 'markAllAsRead']);
});
