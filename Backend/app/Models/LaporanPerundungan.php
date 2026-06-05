<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class LaporanPerundungan extends Model
{
    use HasFactory;

    protected $table = 'laporan_perundungan';

    protected $fillable = [
        'pelapor_id',
        'judul_pelaporan',
        'jenis_perundungan',
        'kronologi',
        'deskripsi_pelaku',
        'lokasi',
        'tanggal_kejadian',
        'status',
    ];

    protected $casts = [
        'tanggal_kejadian' => 'datetime:Y-m-d H:i:s',
    ];

    public function pelapor()
    {
        return $this->belongsTo(Mahasiswa::class, 'pelapor_id');
    }

    public function bukti()
    {
        return $this->hasMany(Bukti::class, 'laporan_id');
    }
}
