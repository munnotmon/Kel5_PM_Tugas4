<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    /**
     * Run the migrations.
     */
    public function up(): void
    {
        Schema::create('users', function (Blueprint $table) {
            $table->bigIncrements('id');
            $table->string('nama', 100);
            $table->string('email', 100)->unique();
            $table->string('password');
            $table->string('role')->default('mahasiswa');
            $table->string('foto_profil')->nullable();
            $table->string('nomor_telepon', 20)->nullable();
            $table->string('spesialisasi')->nullable();
            $table->decimal('rating', 2, 1)->nullable();
            $table->string('pengalaman_tahun')->nullable();
            $table->text('tentang')->nullable();
            $table->json('spesialisasi_list')->nullable();
            $table->json('pendidikan')->nullable();
            $table->json('pengalaman')->nullable();
            $table->json('hari_praktik')->nullable();
            $table->json('jam_tersedia')->nullable();
            $table->boolean('is_online')->default(false);
            $table->timestamps();
        });
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::dropIfExists('users');
    }
};
