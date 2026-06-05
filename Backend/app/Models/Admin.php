<?php

namespace App\Models;

class Admin extends User
{
    protected $table = 'users';

    protected static function boot()
    {
        parent::boot();

        static::creating(function ($model) {
            $model->role = 'admin';
        });

        static::addGlobalScope('role', function ($builder) {
            $builder->where('role', 'admin');
        });
    }

    public function konseling()
    {
        return $this->hasMany(Konseling::class, 'admin_id');
    }

    /**
     * Metode Bisnis: Verifikasi Laporan Perundungan
     */
    public function verifikasiLaporan($laporanId, $status)
    {
        $laporan = LaporanPerundungan::find($laporanId);
        if (!$laporan) {
            return false;
        }

        $laporan->status = $status;
        $laporan->save();

        $this->kirimNotifikasi(
            $laporan->pelapor_id,
            'Status Laporan Diperbarui',
            'Laporan Anda "' . $laporan->judul_pelaporan . '" sekarang berstatus: ' . $laporan->status
        );

        return true;
    }

    /**
     * Metode Bisnis: Kelola Status Konseling
     */
    public function kelolaKonseling($konselingId, $status)
    {
        $session = Konseling::find($konselingId);
        if (!$session) {
            return false;
        }

        $session->status = $status;
        if ($status === 'Diterima' || $status === 'Berlangsung') {
            $session->admin_id = $this->id;
        }
        $session->save();

        $schedule = JadwalKonseling::find($session->jadwal_id);
        if ($schedule) {
            if ($status === 'Selesai') {
                $schedule->status = 'Selesai';
                $schedule->save();
            } elseif ($status === 'Dibatalkan') {
                $schedule->status = 'Tersedia';
                $schedule->save();
            }
        }

        $this->kirimNotifikasi(
            $session->mahasiswa_id,
            'Status Sesi Konseling Diperbarui',
            'Sesi konseling Anda berstatus: ' . $session->status . ($session->admin_id ? ' dengan ' . $this->nama : '')
        );

        return true;
    }

    /**
     * Metode Bisnis: Kirim Notifikasi ke User Lain
     */
    public function kirimNotifikasi($userId, $judul, $isi)
    {
        return Notifikasi::create([
            'user_id' => $userId,
            'judul' => $judul,
            'isi' => $isi,
            'sudah_dibaca' => false,
        ]);
    }
}
