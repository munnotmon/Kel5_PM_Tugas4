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
            $table->foreign(['admin_id'])->references(['id'])->on('users')->onUpdate('no action')->onDelete('cascade');
            $table->foreign(['jadwal_id'])->references(['id'])->on('jadwal_konseling')->onUpdate('no action')->onDelete('cascade');
            $table->foreign(['mahasiswa_id'])->references(['id'])->on('users')->onUpdate('no action')->onDelete('cascade');
        });
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::table('konseling', function (Blueprint $table) {
            $table->dropForeign('konseling_admin_id_foreign');
            $table->dropForeign('konseling_jadwal_id_foreign');
            $table->dropForeign('konseling_mahasiswa_id_foreign');
        });
    }
};
