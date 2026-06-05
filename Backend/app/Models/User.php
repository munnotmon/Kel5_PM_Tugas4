<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Foundation\Auth\User as Authenticatable;
use Illuminate\Notifications\Notifiable;
use Laravel\Sanctum\HasApiTokens;

class User extends Authenticatable
{
    use HasApiTokens, HasFactory, Notifiable;

    protected $table = 'users';

    protected $fillable = [
        'nama',
        'email',
        'password',
        'role',
        'foto_profil',
        'nomor_telepon',
        // Profil konselor (untuk user role 'admin')
        'spesialisasi',
        'rating',
        'pengalaman_tahun',
        'tentang',
        'spesialisasi_list',
        'pendidikan',
        'pengalaman',
        'hari_praktik',
        'jam_tersedia',
        'is_online',
    ];

    protected $hidden = [
        'password',
    ];

    protected function casts(): array
    {
        return [
            'password' => 'hashed',
            'rating' => 'decimal:1',
            'spesialisasi_list' => 'array',
            'pendidikan' => 'array',
            'pengalaman' => 'array',
            'hari_praktik' => 'array',
            'jam_tersedia' => 'array',
            'is_online' => 'boolean',
        ];
    }

    public function profilMahasiswa()
    {
        return $this->hasOne(ProfilMahasiswa::class, 'user_id');
    }

    public function laporanPerundungan()
    {
        return $this->hasMany(LaporanPerundungan::class, 'pelapor_id');
    }

    public function konselingMahasiswa()
    {
        return $this->hasMany(Konseling::class, 'mahasiswa_id');
    }

    public function konselingAdmin()
    {
        return $this->hasMany(Konseling::class, 'admin_id');
    }

    public function pesan()
    {
        return $this->hasMany(Pesan::class, 'sender_id');
    }

    public function notifikasi()
    {
        return $this->hasMany(Notifikasi::class, 'user_id');
    }

    public function ubahKeRoleSpesifik()
    {
        switch ($this->role) {
            case 'mahasiswa':
                $instance = new Mahasiswa();
                break;
            case 'admin':
                $instance = new Admin();
                break;
            case 'superadmin':
                $instance = new SuperAdmin();
                break;
            default:
                return $this;
        }

        $instance->setRawAttributes($this->getAttributes(), true);
        $instance->exists = true;
        return $instance;
    }
}
