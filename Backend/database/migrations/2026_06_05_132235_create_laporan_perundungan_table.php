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
        Schema::create('laporan_perundungan', function (Blueprint $table) {
            $table->bigIncrements('id');
            $table->unsignedBigInteger('pelapor_id')->index('laporan_perundungan_pelapor_id_foreign');
            $table->string('judul_pelaporan');
            $table->string('jenis_perundungan')->nullable();
            $table->text('kronologi');
            $table->text('deskripsi_pelaku')->nullable();
            $table->string('lokasi')->nullable();
            $table->dateTime('tanggal_kejadian')->nullable();
            $table->string('status')->default('Menunggu');
            $table->timestamps();
        });
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::dropIfExists('laporan_perundungan');
    }
};
