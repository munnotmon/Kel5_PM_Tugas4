<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    public function up(): void
    {
        Schema::create('users', function (Blueprint $table) {
            $table->id();
            $table->string('nama', 100);
            $table->string('email', 100)->unique();
            $table->string('password');
            $table->string('role')->default('mahasiswa');
            $table->string('foto_profil')->nullable();
            $table->string('nomor_telepon', 20)->nullable();
            $table->string('spesialisasi')->nullable();
            $table->decimal('rating', 2, 1)->nullable();
            $table->string('pengalaman_tahun')->nullable();
            $table->text('tentang')->nullable();
            $table->json('spesialisasi_list')->nullable();
            $table->json('pendidikan')->nullable();
            $table->json('pengalaman')->nullable();
            $table->json('hari_praktik')->nullable();
            $table->json('jam_tersedia')->nullable();
            $table->boolean('is_online')->default(false);
            $table->timestamps();
        });

        Schema::create('profil_mahasiswa', function (Blueprint $table) {
            $table->id();
            $table->foreignId('user_id')->constrained('users')->onDelete('cascade');
            $table->string('nim')->unique();
            $table->string('program_studi')->nullable();
            $table->integer('angkatan')->nullable();
        });

        Schema::create('jadwal_konseling', function (Blueprint $table) {
            $table->id();
            $table->date('tanggal');
            $table->time('jam_mulai');
            $table->time('jam_selesai');
            $table->string('lokasi');
            $table->string('status')->default('Tersedia');
            $table->timestamps();
        });

        Schema::create('konseling', function (Blueprint $table) {
            $table->id();
            $table->foreignId('mahasiswa_id')->constrained('users')->onDelete('cascade');
            $table->foreignId('admin_id')->nullable()->constrained('users')->onDelete('cascade');
            $table->foreignId('jadwal_id')->constrained('jadwal_konseling')->onDelete('cascade');
            $table->string('nomor_antrian')->nullable();
            $table->text('keluhan')->nullable();
            $table->string('status')->default('Diajukan');
            $table->timestamps();
        });

        Schema::create('laporan_perundungan', function (Blueprint $table) {
            $table->id();
            $table->foreignId('pelapor_id')->constrained('users')->onDelete('cascade');
            $table->string('judul_pelaporan');
            $table->string('jenis_perundungan')->nullable();
            $table->text('kronologi');
            $table->text('deskripsi_pelaku')->nullable();
            $table->string('lokasi')->nullable();
            $table->dateTime('tanggal_kejadian')->nullable();
            $table->string('status')->default('Menunggu');
            $table->timestamps();
        });

        Schema::create('bukti', function (Blueprint $table) {
            $table->id();
            $table->foreignId('laporan_id')->constrained('laporan_perundungan')->onDelete('cascade');
            $table->string('nama_file');
            $table->string('path_file');
            $table->timestamps();
        });

        Schema::create('notifikasi', function (Blueprint $table) {
            $table->id();
            $table->foreignId('user_id')->constrained('users')->onDelete('cascade');
            $table->string('judul');
            $table->text('isi');
            $table->boolean('sudah_dibaca')->default(false);
            $table->timestamps();
        });

        Schema::create('pesan', function (Blueprint $table) {
            $table->id();
            $table->foreignId('konseling_id')->constrained('konseling')->onDelete('cascade');
            $table->foreignId('sender_id')->constrained('users')->onDelete('cascade');
            $table->text('isi_pesan');
            $table->string('status_pesan')->default('sent');
            $table->timestamps();
        });
    }

    public function down(): void
    {
        Schema::dropIfExists('pesan');
        Schema::dropIfExists('notifikasi');
        Schema::dropIfExists('bukti');
        Schema::dropIfExists('laporan_perundungan');
        Schema::dropIfExists('konseling');
        Schema::dropIfExists('jadwal_konseling');
        Schema::dropIfExists('profil_mahasiswa');
        Schema::dropIfExists('users');
    }
};
