<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    public function up(): void
    {
        Schema::table('pesan', function (Blueprint $table) {
            if (!Schema::hasColumn('pesan', 'path_gambar')) {
                $table->string('path_gambar')->nullable()->after('isi_pesan');
            }
        });
    }

    public function down(): void
    {
        Schema::table('pesan', function (Blueprint $table) {
            if (Schema::hasColumn('pesan', 'path_gambar')) {
                $table->dropColumn('path_gambar');
            }
        });
    }
};
