# Polinema Care+
> **Platform Layanan Konseling & Pelaporan Tindakan Perundungan Mahasiswa Politeknik Negeri Malang**

Polinema Care+ adalah platform terintegrasi (Multi-tier Application) yang dirancang untuk menyediakan ruang aman bagi mahasiswa dalam melaporkan insiden perundungan (bullying) secara rahasia dan melakukan konseling secara langsung dengan konselor/admin profesional.

Project ini dikembangkan untuk tugas Semester 3 (Kelompok 5) dengan membagi sistem menjadi tiga platform terintegrasi: **Backend REST API (Laravel)**, **Web Dashboard Admin (React)**, dan **Aplikasi Mobile Mahasiswa (Flutter)**.

---

## Tech Stack & Arsitektur

### 1. Backend REST API (`/Backend`)
* **Framework**: Laravel 10+ (PHP 8.x)
* **Database**: MySQL
* **Autentikasi**: Laravel Sanctum (Token-based Authentication)
* **Fitur Utama**: Manajemen Akun, Endpoint Moderasi Laporan, Endpoint Konseling, API Live Chat, Real-time Notification System, dan Password Hashing dengan Bcrypt.

### 2. Dashboard Web Admin (`/Admin-Web`)
* **Library Utama**: React.js (Vite)
* **Styling**: Vanilla CSS (Premium Dark Mode/Sleek Aesthetics)
* **HTTP Client**: Axios (dengan Request/Response Interceptor untuk integrasi Token JWT)
* **Fitur Utama**:
  * Moderasi Laporan Perundungan (`Menunggu` ➔ `Diterima` ➔ `Diproses` ➔ `Selesai`/`Ditolak`).
  * Live Chat Konseling dengan mahasiswa (mendukung *Read-Only History* setelah sesi selesai).
  * Manajemen Akun Admin/Konselor & Jadwal Praktik.
  * Reset Password Akun Mahasiswa secara aman.

### 3. Aplikasi Mobile Mahasiswa (`/Polinema-Care`)
* **Framework**: Flutter (Dart)
* **State Management & Navigation**: GoRouter, Custom Controllers (Auth, Laporan, Chat, Sesi)
* **Fitur Utama**:
  * Pendaftaran & Login Akun Mahasiswa (mendukung Login Google).
  * Pembuatan Laporan Perundungan lengkap dengan lampiran bukti dokumen/gambar.
  * Pengajuan Sesi Konseling & Pemesanan Jadwal Konselor.
  * Fitur Tanya Jawab / Chat Room dengan Konselor Pendamping secara langsung.
  * Bottom Sheet Lupa Kata Sandi terintegrasi salin kontak WhatsApp & Email.

---

## Struktur Proyek
```text
Kel5_PM_Tugas4/
├── Backend/                 # Source Code Laravel REST API
│   ├── app/Http/Controllers # Logika API (Auth, Chat, Laporan, dll)
│   ├── app/Models           # Model Eloquent Database
│   └── routes/api.php       # Semua rute API yang diakses klien
│
├── Admin-Web/               # Source Code Web Dashboard React
│   ├── src/App.jsx          # Logika UI & Navigasi Utama Web
│   └── src/index.css        # Desain Sistem CSS
│
└── Polinema-Care/           # Source Code Aplikasi Mobile Flutter
    ├── lib/controllers      # Controller REST API client
    ├── lib/services         # Http helper client (api_service.dart)
    └── lib/views            # Layar & Widget UI Flutter
```

---

## Panduan Menjalankan Project (Local Development)

### Prasyarat:
* PHP >= 8.1 dan Composer installed
* Node.js >= 18 dan npm installed
* Flutter SDK (Channel Stable) dan Dart installed
* XAMPP / MySQL Server running

---

### Langkah 1: Menjalankan Backend Laravel
1. Masuk ke folder backend:
   ```bash
   cd Backend
   ```
2. Salin file konfigurasi lingkungan:
   ```bash
   cp .env.example .env
   ```
3. Sesuaikan konfigurasi database MySQL Anda di file `.env`:
   ```env
   DB_CONNECTION=mysql
   DB_HOST=127.0.0.1
   DB_PORT=3306
   DB_DATABASE=nama_database_anda
   DB_USERNAME=root
   DB_PASSWORD=
   ```
4. Install dependensi composer:
   ```bash
   composer install
   ```
5. Generate application key:
   ```bash
   php artisan key:generate
   ```
6. Jalankan migrasi database beserta seeder-nya:
   ```bash
   php artisan migrate --seed
   ```
7. Jalankan server lokal Laravel:
   ```bash
   php artisan serve
   ```
   *(Secara default berjalan di `http://127.0.0.1:8000`)*

---

### Langkah 2: Menjalankan Dashboard Web Admin
1. Masuk ke folder Admin-Web:
   ```bash
   cd ../Admin-Web
   ```
2. Install dependensi npm:
   ```bash
   npm install
   ```
3. Jalankan server pembangunan web:
   ```bash
   npm run dev
   ```
   *(Secara default berjalan di `http://localhost:5173`)*

---

### Langkah 3: Menjalankan Aplikasi Mobile Flutter
1. Masuk ke folder Polinema-Care:
   ```bash
   cd ../Polinema-Care
   ```
2. Ambil paket dependensi flutter:
   ```bash
   flutter pub get
   ```
3. Jika Anda menguji di **HP fisik Android** melalui USB debugging, jalankan port forwarding agar HP Anda bisa menembus localhost komputer:
   ```bash
   adb reverse tcp:8000 tcp:8000
   ```
4. Jalankan aplikasi Flutter:
   ```bash
   flutter run
   ```

---

## Cara Mengganti Mode Koneksi (Local vs Ngrok)
Kami telah menyediakan konfigurasi sakelar pintar (*toggle switch*) agar Anda dapat berganti antara server lokal offline dan server online publik (Ngrok) dengan satu langkah mudah:

* **Di Flutter (`Polinema-Care/lib/services/api_service.dart`)**:
  Ubah nilai `useNgrok` secara manual:
  ```dart
  static const bool useNgrok = false; // Set true jika ingin memakai Ngrok
  ```
* **Di Web Admin (`Admin-Web/src/App.jsx`)**:
  Ubah nilai `useNgrok` secara manual:
  ```javascript
  const useNgrok = false; // Set true jika ingin memakai Ngrok
  ```

---
uang obrolan aman merupakan prioritas utama dari pengembangan Polinema Care+.*
