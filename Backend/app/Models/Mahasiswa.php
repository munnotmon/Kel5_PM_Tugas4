<?php

namespace App\Models;

class Mahasiswa extends User
{
    protected $table = 'users';

    protected static function boot()
    {
        parent::boot();

        static::creating(function ($model) {
            $model->role = 'mahasiswa';
        });

        static::addGlobalScope('role', function ($builder) {
            $builder->where('role', 'mahasiswa');
        });
    }

    public function profilMahasiswa()
    {
        return $this->hasOne(ProfilMahasiswa::class, 'user_id');
    }

    public function laporanPerundungan()
    {
        return $this->hasMany(LaporanPerundungan::class, 'pelapor_id');
    }

    public function konseling()
    {
        return $this->hasMany(Konseling::class, 'mahasiswa_id');
    }
}
