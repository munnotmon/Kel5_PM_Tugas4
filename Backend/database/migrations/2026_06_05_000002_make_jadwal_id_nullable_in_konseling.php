<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    public function up(): void
    {
        Schema::table('konseling', function (Blueprint $table) {
            $table->dropForeign('konseling_ibfk_2');
            $table->dropForeign('konseling_ibfk_3');
        });

        \Illuminate\Support\Facades\DB::statement('ALTER TABLE konseling MODIFY admin_id BIGINT NULL, MODIFY jadwal_id BIGINT NULL');

        Schema::table('konseling', function (Blueprint $table) {
            $table->foreign('admin_id')->references('id')->on('users')->onDelete('cascade');
            $table->foreign('jadwal_id')->references('id')->on('jadwal_konseling')->onDelete('cascade');
        });
    }

    public function down(): void
    {
        Schema::table('konseling', function (Blueprint $table) {
            $table->dropForeign('konseling_ibfk_2');
            $table->dropForeign('konseling_ibfk_3');
        });

        \Illuminate\Support\Facades\DB::statement('ALTER TABLE konseling MODIFY admin_id BIGINT NOT NULL, MODIFY jadwal_id BIGINT NOT NULL');

        Schema::table('konseling', function (Blueprint $table) {
            $table->foreign('admin_id')->references('id')->on('users')->onDelete('cascade');
            $table->foreign('jadwal_id')->references('id')->on('jadwal_konseling')->onDelete('cascade');
        });
    }
};
