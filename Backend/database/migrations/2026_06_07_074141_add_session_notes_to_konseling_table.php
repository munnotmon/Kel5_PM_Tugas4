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
        Schema::table('konseling', function (Blueprint $table) {
            $table->text('catatan_konselor')->nullable();
            $table->text('rekomendasi_pemulihan')->nullable();
        });
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::table('konseling', function (Blueprint $table) {
            $table->dropColumn(['catatan_konselor', 'rekomendasi_pemulihan']);
        });
    }
};
