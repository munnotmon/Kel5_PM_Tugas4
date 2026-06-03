<?php

namespace Database\Seeders;

use App\Models\User;
use Illuminate\Database\Seeder;
use Illuminate\Support\Facades\Hash;

class KonselorSeeder extends Seeder
{
    /**
     * Seed data konselor awal (migrasi dari daftarKonselor hardcoded di Flutter).
     */
    public function run(): void
    {
        $konselors = [
            [
                'nama' => 'dr. Anton Wijaya',
                'email' => 'anton.wijaya@polinema.care',
                'spesialisasi' => 'Spesialis Trauma & Perundungan',
                'rating' => 4.9,
                'pengalaman_tahun' => '12 Tahun Eksp.',
                'tentang' => 'Halo, saya dr. Anton. Saya mendedikasikan karir saya untuk membantu individu yang menghadapi dampak psikologis dari trauma dan perundungan. Melalui pendekatan yang empatik dan ruang yang aman, kita akan bekerja sama untuk memulihkan kepercayaan diri dan kesehatan mental Anda.',
                'spesialisasi_list' => ['Trauma', 'Perundungan', 'Konseling Remaja'],
                'pendidikan' => [
                    ['title' => 'S3 Psikologi Klinis', 'subtitle' => 'Universitas Indonesia • 2015'],
                ],
                'pengalaman' => [
                    ['title' => 'Kepala Konselor', 'subtitle' => 'Pusat Rehabilitasi Mental Nasional • 2018 - Sekarang'],
                ],
                'hari_praktik' => [1, 3, 5],
                'jam_tersedia' => ['09:00 WIB', '10:30 WIB', '13:00 WIB', '15:30 WIB'],
                'is_online' => true,
            ],
            [
                'nama' => 'Siska, M.Psi',
                'email' => 'siska@polinema.care',
                'spesialisasi' => 'Kecemasan Sosial',
                'rating' => 4.8,
                'pengalaman_tahun' => '8 Tahun Eksp.',
                'tentang' => 'Halo, saya Siska. Saya fokus pada penanganan kecemasan sosial dan depresi ringan. Mari kita ciptakan ruang nyaman untuk bercerita tanpa penghakiman.',
                'spesialisasi_list' => ['Kecemasan Sosial', 'Depresi'],
                'pendidikan' => [
                    ['title' => 'S2 Psikologi Profesi', 'subtitle' => 'Universitas Gadjah Mada • 2018'],
                ],
                'pengalaman' => [
                    ['title' => 'Psikolog Klinis', 'subtitle' => 'Klinik Sehati • 2019 - Sekarang'],
                ],
                'hari_praktik' => [2, 4],
                'jam_tersedia' => ['10:00 WIB', '11:30 WIB', '14:00 WIB', '16:30 WIB'],
                'is_online' => true,
            ],
            [
                'nama' => 'Budi Hartono, S.Psi',
                'email' => 'budi.hartono@polinema.care',
                'spesialisasi' => 'Konselor Akademik & Karir',
                'rating' => 4.8,
                'pengalaman_tahun' => '5 Tahun Eksp.',
                'tentang' => 'Halo, saya Budi. Khawatir dengan masa depan atau tugas kampus yang menumpuk? Mari kita obrolkan strategi belajar dan pemetaan karirmu secara terstruktur.',
                'spesialisasi_list' => ['Stres Akademik', 'Karir', 'Manajemen Waktu'],
                'pendidikan' => [
                    ['title' => 'S1 Psikologi', 'subtitle' => 'Universitas Airlangga • 2021'],
                ],
                'pengalaman' => [
                    ['title' => 'Konselor Akademik', 'subtitle' => 'Pusat Bimbingan Kampus • 2022 - Sekarang'],
                ],
                'hari_praktik' => [1, 2, 4],
                'jam_tersedia' => ['08:30 WIB', '10:00 WIB', '13:30 WIB', '15:00 WIB'],
                'is_online' => false,
            ],
            [
                'nama' => 'dr. Sarah Johnson',
                'email' => 'sarah.johnson@polinema.care',
                'spesialisasi' => 'Konselor Psikologi Klinis',
                'rating' => 4.9,
                'pengalaman_tahun' => '10 Tahun Eksp.',
                'tentang' => 'Halo, saya dr. Sarah. Saya berdedikasi membantu individu dalam mengelola stres, kecemasan, dan masalah psikologis klinis lainnya. Mari kita temukan akar masalah dan merancang langkah pemulihan yang tepat bersama-sama.',
                'spesialisasi_list' => ['Psikologi Klinis', 'Manajemen Stres', 'Kecemasan'],
                'pendidikan' => [
                    ['title' => 'S3 Psikologi Klinis', 'subtitle' => 'Universitas Padjadjaran • 2016'],
                ],
                'pengalaman' => [
                    ['title' => 'Psikolog Klinis Utama', 'subtitle' => 'Klinik Sehat Jiwa • 2017 - Sekarang'],
                    ['title' => 'Konselor Relawan', 'subtitle' => 'Yayasan Peduli Mental • 2015 - 2017'],
                ],
                'hari_praktik' => [3, 5],
                'jam_tersedia' => ['09:30 WIB', '11:00 WIB', '14:30 WIB', '16:00 WIB'],
                'is_online' => true,
            ],
        ];

        foreach ($konselors as $data) {
            User::updateOrCreate(
                ['email' => $data['email']],
                array_merge($data, [
                    'password' => Hash::make('password'),
                    'role' => 'admin',
                ])
            );
        }
    }
}
