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
        'last_seen_at',
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
            'last_seen_at' => 'datetime',
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

    /**
     * Dapatkan URL foto profil secara dinamis biar ga error pas ganti local/ngrok.
     */
    public function getFotoProfilAttribute($value)
    {
        if (!$value) {
            return null;
        }

        // Kalo path-nya bentuk URL lengkap (http/https), ubah domainnya pake host yang sekarang aktif
        if (str_starts_with($value, 'http://') || str_starts_with($value, 'https://')) {
            $path = parse_url($value, PHP_URL_PATH);
            $path = ltrim($path, '/');
            return asset($path);
        }

        // Kalo disimpannya pake path relatif
        if (str_starts_with($value, 'storage/')) {
            return asset($value);
        }

        return asset('storage/' . $value);
    }
}
