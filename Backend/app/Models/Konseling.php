<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class Konseling extends Model
{
    use HasFactory;

    protected $table = 'konseling';

    protected $fillable = [
        'mahasiswa_id',
        'admin_id',
        'jadwal_id',
        'nomor_antrian',
        'keluhan',
        'status',
    ];

    public function mahasiswa()
    {
        return $this->belongsTo(User::class, 'mahasiswa_id');
    }

    public function admin()
    {
        return $this->belongsTo(User::class, 'admin_id');
    }

    public function jadwalKonseling()
    {
        return $this->belongsTo(JadwalKonseling::class, 'jadwal_id');
    }

    public function pesan()
    {
        return $this->hasMany(Pesan::class, 'konseling_id');
    }
}
