<?php

namespace Database\Seeders;

use App\Models\User;
use App\Models\ProfilMahasiswa;
use App\Models\JadwalKonseling;
use Illuminate\Database\Seeder;
use Illuminate\Support\Facades\Hash;

class DatabaseSeeder extends Seeder
{
    public function run(): void
    {
        // 1. Seed Admin User
        $admin = User::create([
            'nama' => 'Admin Polinema Care',
            'email' => 'admin@gmail.com',
            'password' => Hash::make('123456'),
            'role' => 'admin',
            'nomor_telepon' => '081234567890',
        ]);

        // 2. Seed Mahasiswa User
        $student = User::create([
            'nama' => 'Kelompok 5',
            'email' => 'student@gmail.com',
            'password' => Hash::make('123456'),
            'role' => 'mahasiswa',
            'nomor_telepon' => '081234567891',
        ]);

        // 3. Seed Mahasiswa Profile
        ProfilMahasiswa::create([
            'user_id' => $student->id,
            'nim' => '21090123',
            'program_studi' => 'Teknologi Informasi',
            'angkatan' => 2026,
        ]);

        // 4. Seed Jadwal Konseling
        JadwalKonseling::create([
            'tanggal' => date('Y-m-d'),
            'jam_mulai' => '09:00:00',
            'jam_selesai' => '10:00:00',
            'lokasi' => 'Gedung TI Lt. 3',
            'status' => 'Tersedia',
        ]);

        JadwalKonseling::create([
            'tanggal' => date('Y-m-d', strtotime('+1 day')),
            'jam_mulai' => '13:00:00',
            'jam_selesai' => '14:00:00',
            'lokasi' => 'Gedung Sipil Lt. 2',
            'status' => 'Tersedia',
        ]);

        JadwalKonseling::create([
            'tanggal' => date('Y-m-d', strtotime('+2 days')),
            'jam_mulai' => '15:30:00',
            'jam_selesai' => '16:30:00',
            'lokasi' => 'Gedung TI Lt. 3',
            'status' => 'Tersedia',
        ]);
    }
}
