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
        Schema::create('konseling', function (Blueprint $table) {
            $table->bigIncrements('id');
            $table->unsignedBigInteger('mahasiswa_id')->index('konseling_mahasiswa_id_foreign');
            $table->unsignedBigInteger('admin_id')->nullable()->index('konseling_admin_id_foreign');
            $table->unsignedBigInteger('jadwal_id')->nullable()->index('konseling_jadwal_id_foreign');
            $table->string('nomor_antrian')->nullable();
            $table->text('keluhan')->nullable();
            $table->string('status')->default('Diajukan');
            $table->string('tipe')->default('konseling');
            $table->timestamps();
        });
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::dropIfExists('konseling');
    }
};
