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
        Schema::table('bukti', function (Blueprint $table) {
            $table->foreign(['laporan_id'])->references(['id'])->on('laporan_perundungan')->onUpdate('no action')->onDelete('cascade');
        });
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::table('bukti', function (Blueprint $table) {
            $table->dropForeign('bukti_laporan_id_foreign');
        });
    }
};
