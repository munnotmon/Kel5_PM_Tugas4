<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    public function up(): void
    {
        Schema::table('konseling', function (Blueprint $table) {
            if (!Schema::hasColumn('konseling', 'tipe')) {
                $table->string('tipe')->default('konseling')->after('status');
            }
        });
    }

    public function down(): void
    {
        Schema::table('konseling', function (Blueprint $table) {
            if (Schema::hasColumn('konseling', 'tipe')) {
                $table->dropColumn('tipe');
            }
        });
    }
};
