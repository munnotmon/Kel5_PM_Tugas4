<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class ProfilMahasiswa extends Model
{
    use HasFactory;

    protected $table = 'profil_mahasiswa';

    public $timestamps = false; // The schema doesn't have created_at/updated_at for profil_mahasiswa

    protected $fillable = [
        'user_id',
        'nim',
        'program_studi',
        'angkatan',
    ];

    public function user()
    {
        return $this->belongsTo(User::class, 'user_id');
    }
}
