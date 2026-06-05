<?php

namespace App\Http\Controllers;

use App\Models\User;
use App\Models\Admin;
use App\Models\SuperAdmin;
use App\Models\Konseling;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Hash;
use Illuminate\Support\Facades\Validator;

class KonselorController extends Controller
{
    /**
     * Daftar konselor (semua user dengan role admin yang punya profil konselor).
     */
    public function index(Request $request)
    {
        $query = Admin::query();
        if ($request->user() && $request->user()->role === 'mahasiswa') {
            $query->whereNotNull('spesialisasi');
        }

        $konselor = $query->orderByDesc('is_online')
            ->orderByDesc('rating')
            ->get();

        $data = $konselor->map(fn ($k) => $this->transform($k));

        return response()->json([
            'success' => true,
            'data' => $data,
            'online_count' => $konselor->where('is_online', true)->count(),
        ]);
    }

    /**
     * Detail satu konselor.
     */
    public function show($id)
    {
        $konselor = Admin::find($id);

        if (!$konselor) {
            return response()->json([
                'success' => false,
                'message' => 'Konselor tidak ditemukan',
            ], 404);
        }

        return response()->json([
            'success' => true,
            'data' => $this->transform($konselor),
        ]);
    }

    /**
     * Profil konselor milik admin yang sedang login.
     */
    public function myProfile(Request $request)
    {
        $user = $request->user();

        if ($user->role !== 'admin') {
            return response()->json(['success' => false, 'message' => 'Akses ditolak'], 403);
        }

        return response()->json([
            'success' => true,
            'data' => $this->transform($user),
        ]);
    }

    /**
     * Update profil konselor milik admin yang sedang login.
     */
    public function updateMyProfile(Request $request)
    {
        $user = $request->user();

        if ($user->role !== 'admin') {
            return response()->json(['success' => false, 'message' => 'Akses ditolak'], 403);
        }

        $validator = Validator::make($request->all(), [
            'nama' => 'sometimes|string|max:100',
            'spesialisasi' => 'sometimes|string|max:150',
            'rating' => 'nullable|numeric|min:0|max:5',
            'pengalaman_tahun' => 'nullable|string|max:50',
            'tentang' => 'nullable|string',
            'spesialisasi_list' => 'nullable|array',
            'pendidikan' => 'nullable|array',
            'pengalaman' => 'nullable|array',
            'hari_praktik' => 'nullable|array',
            'jam_tersedia' => 'nullable|array',
            'is_online' => 'nullable|boolean',
            'foto_profil' => 'nullable|string',
            'nomor_telepon' => 'nullable|string|max:20',
        ]);

        if ($validator->fails()) {
            return response()->json([
                'success' => false,
                'message' => 'Validasi gagal',
                'errors' => $validator->errors(),
            ], 422);
        }

        $user->fill($request->only([
            'nama', 'spesialisasi', 'rating', 'pengalaman_tahun', 'tentang',
            'spesialisasi_list', 'pendidikan', 'pengalaman', 'hari_praktik',
            'jam_tersedia', 'foto_profil', 'nomor_telepon',
        ]));
        $user->save();

        return response()->json([
            'success' => true,
            'message' => 'Profil konselor berhasil diperbarui',
            'data' => $this->transform($user),
        ]);
    }

    public function store(Request $request)
    {
        if ($request->user()->role !== 'admin' && $request->user()->role !== 'superadmin') {
            return response()->json(['success' => false, 'message' => 'Akses ditolak'], 403);
        }

        $validator = Validator::make($request->all(), [
            'nama' => 'required|string|max:100',
            'email' => 'required|email|max:100|unique:users,email',
            'password' => 'required|string|min:6',
            'role' => 'nullable|in:admin,superadmin',
            'spesialisasi' => 'nullable|string|max:150',
            'rating' => 'nullable|numeric|min:0|max:5',
            'pengalaman_tahun' => 'nullable|string|max:50',
            'tentang' => 'nullable|string',
            'spesialisasi_list' => 'nullable|array',
            'pendidikan' => 'nullable|array',
            'pengalaman' => 'nullable|array',
            'hari_praktik' => 'nullable|array',
            'jam_tersedia' => 'nullable|array',
            'is_online' => 'nullable|boolean',
            'foto_profil' => 'nullable|string',
            'nomor_telepon' => 'nullable|string|max:20',
        ]);

        if ($validator->fails()) {
            return response()->json([
                'success' => false,
                'message' => 'Validasi gagal',
                'errors' => $validator->errors(),
            ], 422);
        }

        $role = in_array($request->role, ['admin', 'superadmin']) ? $request->role : 'admin';

        $data = [
            'nama' => $request->nama,
            'email' => $request->email,
            'password' => Hash::make($request->password),
            'nomor_telepon' => $request->nomor_telepon,
            'foto_profil' => $request->foto_profil,
            'spesialisasi' => $request->spesialisasi,
            'rating' => $request->rating ?? 5.0,
            'pengalaman_tahun' => $request->pengalaman_tahun,
            'tentang' => $request->tentang,
            'spesialisasi_list' => $request->spesialisasi_list ?? [],
            'pendidikan' => $request->pendidikan ?? [],
            'pengalaman' => $request->pengalaman ?? [],
            'hari_praktik' => $request->hari_praktik ?? [],
            'jam_tersedia' => $request->jam_tersedia ?? [],
            'is_online' => $request->is_online ?? false,
        ];

        if ($role === 'superadmin') {
            $konselor = SuperAdmin::create($data);
        } else {
            $konselor = Admin::create($data);
        }

        return response()->json([
            'success' => true,
            'message' => $role === 'superadmin'
                ? 'Akun Super Admin berhasil ditambahkan'
                : 'Akun Admin/Konselor berhasil ditambahkan',
            'data' => $this->transform($konselor),
        ], 201);
    }

    /**
     * Update profil konselor/admin (dipakai Admin-Web).
     */
    public function update(Request $request, $id)
    {
        if ($request->user()->role !== 'admin' && $request->user()->role !== 'superadmin') {
            return response()->json(['success' => false, 'message' => 'Akses ditolak'], 403);
        }

        $konselor = User::whereIn('role', ['admin', 'superadmin'])->find($id);
        if (!$konselor) {
            return response()->json(['success' => false, 'message' => 'User tidak ditemukan'], 404);
        }

        $validator = Validator::make($request->all(), [
            'nama' => 'sometimes|string|max:100',
            'email' => 'sometimes|email|max:100|unique:users,email,' . $id,
            'password' => 'nullable|string|min:6',
            'role' => 'sometimes|in:admin,superadmin',
            'spesialisasi' => 'nullable|string|max:150',
            'rating' => 'nullable|numeric|min:0|max:5',
            'pengalaman_tahun' => 'nullable|string|max:50',
            'tentang' => 'nullable|string',
            'spesialisasi_list' => 'nullable|array',
            'pendidikan' => 'nullable|array',
            'pengalaman' => 'nullable|array',
            'hari_praktik' => 'nullable|array',
            'jam_tersedia' => 'nullable|array',
            'is_online' => 'nullable|boolean',
            'foto_profil' => 'nullable|string',
            'nomor_telepon' => 'nullable|string|max:20',
        ]);

        if ($validator->fails()) {
            return response()->json([
                'success' => false,
                'message' => 'Validasi gagal',
                'errors' => $validator->errors(),
            ], 422);
        }

        // Fill other fields
        $konselor->fill($request->only([
            'nama', 'email', 'role', 'spesialisasi', 'rating', 'pengalaman_tahun', 'tentang',
            'spesialisasi_list', 'pendidikan', 'pengalaman', 'hari_praktik',
            'jam_tersedia', 'foto_profil', 'nomor_telepon',
        ]));

        if ($request->filled('password')) {
            $konselor->password = Hash::make($request->password);
        }

        $konselor->save();

        return response()->json([
            'success' => true,
            'message' => 'Profil berhasil diperbarui',
            'data' => $this->transform($konselor),
        ]);
    }

    /**
     * Hapus akun admin/konselor/superadmin.
     */
    public function destroy(Request $request, $id)
    {
        if ($request->user()->role !== 'superadmin') {
            return response()->json(['success' => false, 'message' => 'Akses ditolak. Hanya Super Admin yang dapat menghapus akun.'], 403);
        }

        if ($request->user()->id == $id) {
            return response()->json(['success' => false, 'message' => 'Anda tidak dapat menghapus akun Anda sendiri.'], 400);
        }

        $user = User::whereIn('role', ['admin', 'superadmin'])->find($id);
        if (!$user) {
            return response()->json(['success' => false, 'message' => 'User tidak ditemukan.'], 404);
        }

        $user->delete();

        return response()->json([
            'success' => true,
            'message' => 'Akun berhasil dihapus.',
        ]);
    }

    /**
     * Ubah user (admin) menjadi data yang dikonsumsi Flutter (Konselor.fromMap).
     */
    private function transform(User $k): array
    {
        $sessionCount = Konseling::where('admin_id', $k->id)
            ->where('status', 'Selesai')
            ->count();

        return [
            'id' => $k->id,
            'name' => $k->nama,
            'email' => $k->email,
            'role' => $k->role,
            'specialty' => $k->spesialisasi ?? '',
            'rating' => number_format((float) ($k->rating ?? 5.0), 1),
            'experience_years' => $k->pengalaman_tahun ?? '',
            'sessions' => $sessionCount . ' Sesi',
            'about' => $k->tentang ?? '',
            'foto_profil' => $k->foto_profil,
            'nomor_telepon' => $k->nomor_telepon,
            'is_online' => (bool) $k->is_online,
            'specialties' => $k->spesialisasi_list ?? [],
            'educations' => $k->pendidikan ?? [],
            'experiences' => $k->pengalaman ?? [],
            'practice_days' => $k->hari_praktik ?? [],
            'available_times' => $k->jam_tersedia ?? [],
        ];
    }
}
