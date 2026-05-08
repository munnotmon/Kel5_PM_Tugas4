import 'package:flutter/material.dart';

class LaporanPerundunganPage extends StatefulWidget {
  const LaporanPerundunganPage({super.key});

  @override
  State<LaporanPerundunganPage> createState() => _LaporanPerundunganPageState();
}

class _LaporanPerundunganPageState extends State<LaporanPerundunganPage> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _namaController = TextEditingController();
  final TextEditingController _nimController = TextEditingController();
  final TextEditingController _teleponController = TextEditingController();

  String? _selectedProdi;

  final List<String> _prodiList = [
    'Teknologi Informasi',
    'Teknik Kimia',
    'Teknik Elektro',
    'Teknik Mesin',
    'Teknik Sipil',
    'Administrasi Niaga',
    'Akuntansi',
  ];

  @override
  void dispose() {
    _namaController.dispose();
    _nimController.dispose();
    _teleponController.dispose();
    super.dispose();
  }

  void _handleNext() {
    if (_formKey.currentState!.validate()) {
      // TODO: Navigate to Step 2
      // Navigator.pushNamed(context, '/laporan-step2', arguments: {
      //   'nama': _namaController.text,
      //   'nim': _nimController.text,
      //   'telepon': _teleponController.text,
      //   'prodi': _selectedProdi,
      // });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Melanjutkan ke langkah 2...')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      appBar: _buildAppBar(),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildStepIndicator(),
                      const SizedBox(height: 20),
                      _buildHeader(),
                      const SizedBox(height: 24),
                      _buildSecurityCard(),
                      const SizedBox(height: 28),
                      _buildFormFields(),
                      const SizedBox(height: 32),
                    ],
                  ),
                ),
              ),
            ),
            _buildNextButton(),
          ],
        ),
      ),
      bottomNavigationBar: _buildBottomNavBar(),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back, color: Color(0xFF1A6B8A)),
        onPressed: () => Navigator.pop(context),
      ),
      title: const Text(
        'Laporkan Perundungan',
        style: TextStyle(
          color: Color(0xFF1A6B8A),
          fontWeight: FontWeight.bold,
          fontSize: 18,
        ),
      ),
      actions: [
        Padding(
          padding: const EdgeInsets.only(right: 16),
          child: CircleAvatar(
            radius: 18,
            backgroundColor: const Color(0xFFE8D5C4),
            child: ClipOval(
              child: Container(
                color: const Color(0xFFE8D5C4),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildStepIndicator() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text(
          'LANGKAH 1 DARI 4',
          style: TextStyle(
            color: Color(0xFF1A6B8A),
            fontWeight: FontWeight.w600,
            fontSize: 12,
            letterSpacing: 0.5,
          ),
        ),
        Row(
          children: List.generate(4, (index) {
            return Container(
              margin: const EdgeInsets.only(left: 6),
              width: index == 0 ? 28 : 10,
              height: 6,
              decoration: BoxDecoration(
                color: index == 0
                    ? const Color(0xFF1A6B8A)
                    : const Color(0xFFD0D8E4),
                borderRadius: BorderRadius.circular(10),
              ),
            );
          }),
        ),
      ],
    );
  }

  Widget _buildHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Data Diri Pelapor',
          style: TextStyle(
            fontSize: 26,
            fontWeight: FontWeight.bold,
            color: Color(0xFF1A2D3D),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'Ceritakan secara jujur. Keamanan Anda adalah\nprioritas utama kami.',
          style: TextStyle(
            fontSize: 14,
            color: Colors.grey[600],
            height: 1.5,
          ),
        ),
      ],
    );
  }

  Widget _buildSecurityCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: const Color(0xFFE0F2ED),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(
              Icons.shield_outlined,
              color: Color(0xFF1A6B8A),
              size: 26,
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Aman & Terlindung',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                    color: Color(0xFF1A2D3D),
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  'Informasi identitas Anda akan dijaga kerahasiaannya dan hanya digunakan untuk keperluan verifikasi serta bantuan profesional.',
                  style: TextStyle(
                    fontSize: 13,
                    color: Colors.grey[600],
                    height: 1.5,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFormFields() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildLabel('Nama Lengkap'),
        const SizedBox(height: 8),
        _buildTextField(
          controller: _namaController,
          hint: 'Masukkan nama sesuai KTM',
          keyboardType: TextInputType.name,
          validator: (val) =>
              val == null || val.isEmpty ? 'Nama lengkap wajib diisi' : null,
        ),
        const SizedBox(height: 20),
        _buildLabel('NIM (Nomor Induk Mahasiswa)'),
        const SizedBox(height: 8),
        _buildTextField(
          controller: _nimController,
          hint: 'Contoh: 21090123',
          keyboardType: TextInputType.number,
          validator: (val) =>
              val == null || val.isEmpty ? 'NIM wajib diisi' : null,
        ),
        const SizedBox(height: 20),
        _buildLabel('Nomor Telepon / WA'),
        const SizedBox(height: 8),
        _buildTextField(
          controller: _teleponController,
          hint: '0812-xxxx-xxxx',
          keyboardType: TextInputType.phone,
          validator: (val) =>
              val == null || val.isEmpty ? 'Nomor telepon wajib diisi' : null,
        ),
        const SizedBox(height: 20),
        _buildLabel('Program Studi'),
        const SizedBox(height: 8),
        _buildProdiDropdown(),
      ],
    );
  }

  Widget _buildLabel(String label) {
    return Row(
      children: [
        Text(
          label,
          style: const TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 14,
            color: Color(0xFF1A2D3D),
          ),
        ),
        const SizedBox(width: 4),
        const Text(
          '*',
          style: TextStyle(color: Colors.red, fontSize: 14),
        ),
      ],
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hint,
    TextInputType keyboardType = TextInputType.text,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      validator: validator,
      style: const TextStyle(fontSize: 14, color: Color(0xFF1A2D3D)),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: TextStyle(color: Colors.grey[400], fontSize: 14),
        filled: true,
        fillColor: const Color(0xFFF0F2F5),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFF1A6B8A), width: 1.5),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.red, width: 1.5),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.red, width: 1.5),
        ),
      ),
    );
  }

  Widget _buildProdiDropdown() {
    return DropdownButtonFormField<String>(
      value: _selectedProdi,
      hint: Text(
        'Pilih Prodi',
        style: TextStyle(color: Colors.grey[400], fontSize: 14),
      ),
      icon: const Icon(Icons.keyboard_arrow_down, color: Color(0xFF1A6B8A)),
      style: const TextStyle(fontSize: 14, color: Color(0xFF1A2D3D)),
      decoration: InputDecoration(
        filled: true,
        fillColor: const Color(0xFFF0F2F5),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFF1A6B8A), width: 1.5),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.red, width: 1.5),
        ),
      ),
      validator: (val) => val == null ? 'Program studi wajib dipilih' : null,
      onChanged: (val) => setState(() => _selectedProdi = val),
      items: _prodiList.map((prodi) {
        return DropdownMenuItem(
          value: prodi,
          child: Text(prodi),
        );
      }).toList(),
    );
  }

  Widget _buildNextButton() {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 20),
      color: const Color(0xFFF5F7FA),
      child: SizedBox(
        width: double.infinity,
        height: 52,
        child: DecoratedBox(
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0xFF1A6B8A), Color(0xFF2AAFCF)],
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
            ),
            borderRadius: BorderRadius.circular(30),
          ),
          child: ElevatedButton(
            onPressed: _handleNext,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.transparent,
              shadowColor: Colors.transparent,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              ),
            ),
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Selanjutnya',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(width: 8),
                Icon(Icons.arrow_forward, color: Colors.white, size: 18),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBottomNavBar() {
    return BottomAppBar(
      color: Colors.white,
      elevation: 10,
      shape: const CircularNotchedRectangle(),
      notchMargin: 8,
      child: SizedBox(
        height: 60,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _buildNavItem(Icons.home_outlined, 'Home', false),
            _buildNavItem(Icons.bar_chart, 'Activity', true),
            const SizedBox(width: 40), // FAB notch space
            _buildNavItem(Icons.psychology_outlined, 'Counseling', false),
            _buildNavItem(Icons.person_outline, 'Profile', false),
          ],
        ),
      ),
    );
  }

  Widget _buildNavItem(IconData icon, String label, bool isActive) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          decoration: isActive
              ? BoxDecoration(
                  color: const Color(0xFFE0F2ED),
                  borderRadius: BorderRadius.circular(8),
                )
              : null,
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
          child: Icon(
            icon,
            color: isActive ? const Color(0xFF1A6B8A) : Colors.grey[500],
            size: 22,
          ),
        ),
        Text(
          label,
          style: TextStyle(
            fontSize: 11,
            color: isActive ? const Color(0xFF1A6B8A) : Colors.grey[500],
            fontWeight: isActive ? FontWeight.w600 : FontWeight.normal,
          ),
        ),
      ],
    );
  }
}