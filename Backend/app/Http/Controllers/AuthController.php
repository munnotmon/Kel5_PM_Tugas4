<?php

namespace App\Http\Controllers;

use App\Models\User;
use App\Models\ProfilMahasiswa;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Hash;
use Illuminate\Support\Facades\Validator;
use Illuminate\Support\Facades\Auth;

class AuthController extends Controller
{
    public function register(Request $request)
    {
        $validator = Validator::make($request->all(), [
            'nama' => 'required|string|max:100',
            'email' => 'required|string|email|max:100|unique:users',
            'password' => 'required|string|min:6',
            'nomor_telepon' => 'nullable|string|max:20',
            'nim' => 'required|string|max:20|unique:profil_mahasiswa,nim',
            'program_studi' => 'nullable|string|max:100',
            'angkatan' => 'nullable|integer',
        ]);

        if ($validator->fails()) {
            return response()->json([
                'success' => false,
                'message' => implode(' ', $validator->errors()->all()),
                'errors' => $validator->errors()
            ], 422);
        }

        // Create user with student role
        $user = User::create([
            'nama' => $request->nama,
            'email' => $request->email,
            'password' => Hash::make($request->password),
            'role' => 'mahasiswa',
            'nomor_telepon' => $request->nomor_telepon,
        ]);

        // Create student profile
        $profile = ProfilMahasiswa::create([
            'user_id' => $user->id,
            'nim' => $request->nim,
            'program_studi' => $request->program_studi,
            'angkatan' => $request->angkatan,
        ]);

        $token = $user->createToken('auth_token')->plainTextToken;

        return response()->json([
            'success' => true,
            'message' => 'Registrasi berhasil',
            'data' => [
                'user' => $user->load('profilMahasiswa'),
                'token' => $token,
                'token_type' => 'Bearer',
            ]
        ], 201);
    }

    public function login(Request $request)
    {
        $validator = Validator::make($request->all(), [
            'email' => 'required|string|email',
            'password' => 'required|string',
        ]);

        if ($validator->fails()) {
            return response()->json([
                'success' => false,
                'message' => 'Email dan password diperlukan',
                'errors' => $validator->errors()
            ], 422);
        }

        $user = User::where('email', $request->email)->first();

        if (!$user || !Hash::check($request->password, $user->password)) {
            return response()->json([
                'success' => false,
                'message' => 'Kredensial salah'
            ], 401);
        }

        $token = $user->createToken('auth_token')->plainTextToken;

        return response()->json([
            'success' => true,
            'message' => 'Login berhasil',
            'data' => [
                'user' => $user->load('profilMahasiswa'),
                'token' => $token,
                'token_type' => 'Bearer',
            ]
        ]);
    }

    public function loginGoogle(Request $request)
    {
        $validator = Validator::make($request->all(), [
            'email' => 'required|string|email|max:100',
            'name' => 'required|string|max:100',
        ]);

        if ($validator->fails()) {
            return response()->json([
                'success' => false,
                'message' => 'Email dan nama diperlukan',
                'errors' => $validator->errors()
            ], 422);
        }

        // Find or create user
        $user = User::where('email', $request->email)->first();

        if (!$user) {
            // Generate a random password for social login users
            $user = User::create([
                'nama' => $request->name,
                'email' => $request->email,
                'password' => Hash::make(bin2hex(random_bytes(8))),
                'role' => 'mahasiswa',
                'nomor_telepon' => '081234567' . rand(100, 999),
            ]);

            // Create student profile
            ProfilMahasiswa::create([
                'user_id' => $user->id,
                'nim' => '21090' . rand(100, 999),
                'program_studi' => 'Teknologi Informasi',
                'angkatan' => 2026,
            ]);
        }

        $token = $user->createToken('auth_token')->plainTextToken;

        return response()->json([
            'success' => true,
            'message' => 'Login Google berhasil',
            'data' => [
                'user' => $user->load('profilMahasiswa'),
                'token' => $token,
                'token_type' => 'Bearer',
            ]
        ]);
    }

    public function me(Request $request)
    {
        return response()->json([
            'success' => true,
            'data' => $request->user()->load('profilMahasiswa')
        ]);
    }

    public function logout(Request $request)
    {
        $request->user()->currentAccessToken()->delete();

        return response()->json([
            'success' => true,
            'message' => 'Logout berhasil'
        ]);
    }

    public function updateProfile(Request $request)
    {
        $user = $request->user();

        $validator = Validator::make($request->all(), [
            'nama' => 'sometimes|required|string|max:100',
            'nomor_telepon' => 'nullable|string|max:20',
            'password' => 'nullable|string|min:6',
            'foto_profil' => 'nullable|image|mimes:jpeg,png,jpg|max:2048', // optional file upload
            'program_studi' => 'nullable|string|max:100',
            'angkatan' => 'nullable|integer',
        ]);

        if ($validator->fails()) {
            return response()->json([
                'success' => false,
                'message' => implode(' ', $validator->errors()->all()),
                'errors' => $validator->errors()
            ], 422);
        }

        if ($request->has('nama')) {
            $user->nama = $request->nama;
        }
        if ($request->has('nomor_telepon')) {
            $user->nomor_telepon = $request->nomor_telepon;
        }
        if ($request->has('password') && !empty($request->password)) {
            $user->password = Hash::make($request->password);
        }

        // Handle profile photo upload
        if ($request->hasFile('foto_profil')) {
            $file = $request->file('foto_profil');
            $fileName = time() . '_' . $file->getClientOriginalName();
            $path = $file->storeAs('public/foto_profil', $fileName);
            $user->foto_profil = asset('storage/foto_profil/' . $fileName);
        }

        $user->save();

        if ($user->role === 'mahasiswa') {
            $profile = ProfilMahasiswa::where('user_id', $user->id)->first();
            if ($profile) {
                if ($request->has('program_studi')) {
                    $profile->program_studi = $request->program_studi;
                }
                if ($request->has('angkatan')) {
                    $profile->angkatan = $request->angkatan;
                }
                $profile->save();
            }
        }

        return response()->json([
            'success' => true,
            'message' => 'Profil berhasil diperbarui',
            'data' => $user->load('profilMahasiswa')
        ]);
    }

    public function getMahasiswa(Request $request)
    {
        if (!in_array($request->user()->role, ['admin', 'superadmin'])) {
            return response()->json([
                'success' => false,
                'message' => 'Akses ditolak. Hanya admin yang dapat mengakses.'
            ], 403);
        }

        $mahasiswa = User::with('profilMahasiswa')
            ->where('role', 'mahasiswa')
            ->latest()
            ->get();

        return response()->json([
            'success' => true,
            'data' => $mahasiswa
        ]);
    }

    /**
     * Daftar akun Super Admin (hanya bisa diakses oleh Super Admin).
     */
    public function getSuperadmin(Request $request)
    {
        if ($request->user()->role !== 'superadmin') {
            return response()->json([
                'success' => false,
                'message' => 'Akses ditolak. Hanya Super Admin yang dapat mengakses.'
            ], 403);
        }

        $superadmin = User::where('role', 'superadmin')
            ->latest()
            ->get();

        return response()->json([
            'success' => true,
            'data' => $superadmin
        ]);
    }
}
