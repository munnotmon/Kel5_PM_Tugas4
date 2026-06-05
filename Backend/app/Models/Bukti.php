<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class Bukti extends Model
{
    use HasFactory;

    protected $table = 'bukti';

    protected $fillable = [
        'laporan_id',
        'nama_file',
        'path_file',
    ];

    public function laporanPerundungan()
    {
        return $this->belongsTo(LaporanPerundungan::class, 'laporan_id');
    }
}
