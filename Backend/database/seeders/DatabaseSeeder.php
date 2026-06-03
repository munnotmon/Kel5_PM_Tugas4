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
        // 0. Seed Super Admin User
        User::updateOrCreate(
            ['email' => 'superadmin@gmail.com'],
            [
                'nama' => 'Super Admin Polinema Care',
                'password' => Hash::make('123456'),
                'role' => 'superadmin',
                'nomor_telepon' => '081234567899',
            ]
        );

        // 1. Seed Admin User
        $admin = User::updateOrCreate(
            ['email' => 'admin@gmail.com'],
            [
                'nama' => 'Admin Polinema Care',
                'password' => Hash::make('123456'),
                'role' => 'admin',
                'nomor_telepon' => '081234567890',
            ]
        );

        // 2. Seed Mahasiswa User
        $student = User::updateOrCreate(
            ['email' => 'student@gmail.com'],
            [
                'nama' => 'Kelompok 5',
                'password' => Hash::make('123456'),
                'role' => 'mahasiswa',
                'nomor_telepon' => '081234567891',
            ]
        );

        // 3. Seed Mahasiswa Profile
        ProfilMahasiswa::updateOrCreate(
            ['user_id' => $student->id],
            [
                'nim' => '21090123',
                'program_studi' => 'Teknologi Informasi',
                'angkatan' => 2026,
            ]
        );

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
