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
        Schema::create('pesan', function (Blueprint $table) {
            $table->bigIncrements('id');
            $table->unsignedBigInteger('konseling_id')->index('pesan_konseling_id_foreign');
            $table->unsignedBigInteger('sender_id')->index('pesan_sender_id_foreign');
            $table->text('isi_pesan')->nullable();
            $table->string('path_gambar')->nullable();
            $table->string('status_pesan')->default('sent');
            $table->timestamps();
        });
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::dropIfExists('pesan');
    }
};
