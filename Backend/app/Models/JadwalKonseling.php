<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class JadwalKonseling extends Model
{
    use HasFactory;

    protected $table = 'jadwal_konseling';

    protected $fillable = [
        'admin_id',
        'tanggal',
        'jam_mulai',
        'jam_selesai',
        'lokasi',
        'status',
    ];

    protected $casts = [
        'tanggal' => 'date',
    ];

    public function konseling()
    {
        return $this->hasMany(Konseling::class, 'jadwal_id');
    }
}
