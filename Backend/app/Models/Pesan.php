<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class Pesan extends Model
{
    use HasFactory;

    protected $table = 'pesan';

    protected $fillable = [
        'konseling_id',
        'sender_id',
        'isi_pesan',
        'path_gambar',
        'status_pesan',
    ];

    public function konseling()
    {
        return $this->belongsTo(Konseling::class, 'konseling_id');
    }

    public function sender()
    {
        return $this->belongsTo(User::class, 'sender_id');
    }
}
