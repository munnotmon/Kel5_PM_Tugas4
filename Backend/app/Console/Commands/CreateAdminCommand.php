<?php

namespace App\Console\Commands;

use Illuminate\Console\Command;
use App\Models\User;
use Illuminate\Support\Facades\Hash;
use Illuminate\Support\Facades\Validator;

class CreateAdminCommand extends Command
{
    /**
     * The name and signature of the console command.
     *
     * @var string
     */
    protected $signature = 'make:admin-user';

    /**
     * The console command description.
     *
     * @var string
     */
    protected $description = 'Membuat user admin baru secara dinamis';

    /**
     * Execute the console command.
     */
    public function handle()
    {
        $this->info('--- Pembuatan User Admin Baru ---');

        $nama = $this->ask('Masukkan Nama Lengkap Admin');
        $email = $this->ask('Masukkan Email Admin');
        $password = $this->secret('Masukkan Password Admin (min. 6 karakter)');
        $phone = $this->ask('Masukkan Nomor Telepon Admin (Opsional)');

        // Validasi input
        $validator = Validator::make([
            'nama' => $nama,
            'email' => $email,
            'password' => $password,
            'nomor_telepon' => $phone,
        ], [
            'nama' => 'required|string|max:100',
            'email' => 'required|string|email|max:100|unique:users,email',
            'password' => 'required|string|min:6',
            'nomor_telepon' => 'nullable|string|max:20',
        ]);

        if ($validator->fails()) {
            $this->error('Validasi Gagal:');
            foreach ($validator->errors()->all() as $error) {
                $this->error('- ' . $error);
            }
            return 1;
        }

        // Buat user admin
        User::create([
            'nama' => $nama,
            'email' => $email,
            'password' => Hash::make($password),
            'role' => 'admin',
            'nomor_telepon' => $phone,
        ]);

        $this->info('Berhasil! User admin baru telah didaftarkan.');
        return 0;
    }
}
