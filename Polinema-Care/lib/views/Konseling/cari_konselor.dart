import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:go_router/go_router.dart';
import '../../controllers/counseling_controller.dart';
import '../../models/counselor_model.dart';

class FindCounselorPage extends StatefulWidget {
  const FindCounselorPage({super.key});

  @override
  State<FindCounselorPage> createState() => _FindCounselorPageState();
}

class _FindCounselorPageState extends State<FindCounselorPage> {
  String _searchQuery = '';
  String _selectedFilter = 'Semua';
  Timer? _debounce;

  List<Konselor> _allKonselor = [];
  bool _isLoading = true;

  List<String> _filters = ['Semua'];

  @override
  void initState() {
    super.initState();
    _loadKonselor();
  }

  Future<void> _loadKonselor() async {
    setState(() => _isLoading = true);
    final data = await CounselingController.fetchKonselor();
    if (!mounted) return;

    final Set<String> uniqueSpecs = {};
    for (final k in data) {
      for (final spec in k.specialties) {
        if (spec.trim().isNotEmpty) {
          final cleaned = spec.trim();
          uniqueSpecs.add(cleaned[0].toUpperCase() + cleaned.substring(1));
        }
      }
    }

    setState(() {
      _allKonselor = data;
      _filters = ['Semua', ...uniqueSpecs.toList()..sort()];
      _isLoading = false;
    });
  }

  @override
  void dispose() {
    _debounce?.cancel();
    super.dispose();
  }

  void _onSearchChanged(String query) {
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () {
      if (mounted) {
        setState(() {
          _searchQuery = query;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
  List<Konselor> filteredKonselor = _allKonselor.where((konselor) {
    // 1. Cek Pencarian Text
    final String name = konselor.name.toLowerCase();
    final String specialty = konselor.specialty.toLowerCase();
    final bool matchesSearch =
        name.contains(_searchQuery.toLowerCase()) ||
        specialty.contains(_searchQuery.toLowerCase());

    // 2. Cek Filter Kategori (Chips)
    bool matchesFilter = true;
    if (_selectedFilter != 'Semua') {
      final List<String> specialties =
          konselor.specialties.map((e) => e.toLowerCase()).toList();
      matchesFilter = specialties.contains(_selectedFilter.toLowerCase());
    }

    return matchesSearch && matchesFilter;
  }).toList();

  return Scaffold(
    backgroundColor: const Color(0xFFF5F7FA),
    appBar: AppBar(
      backgroundColor: const Color(0xFFF5F7FA),
      elevation: 0,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back, color: Color(0xFF1A6B8A)),
        onPressed: () => context.pop(),
      ),
      title: Text(
        "Find Support",
        style: GoogleFonts.plusJakartaSans(
          color: const Color(0xFF1A6B8A),
          fontWeight: FontWeight.bold,
          fontSize: 18,
        ),
      ),
      actions: const [],
    ),
    body: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // --- SEARCH BAR ---
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: TextField(
            onChanged: _onSearchChanged,
            decoration: InputDecoration(
              hintText: "Cari nama atau spesialisasi...",
              hintStyle: GoogleFonts.plusJakartaSans(
                color: Colors.grey[400],
                fontSize: 14,
              ),
              prefixIcon: const Icon(Icons.search, color: Colors.grey),
              filled: true,
              fillColor: Colors.white,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(30),
                borderSide: BorderSide.none,
              ),
              contentPadding: const EdgeInsets.symmetric(vertical: 0),
            ),
          ),
        ),

        // --- CHIPS FILTER ---
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: Row(
            children: _filters.map((filter) {
              return _buildChip(filter, _selectedFilter == filter);
            }).toList(),
          ),
        ),

        const SizedBox(height: 10),

        // --- HEADER: KONSELOR TERSEDIA ---
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Konselor Tersedia",
                    style: GoogleFonts.plusJakartaSans(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                      color: const Color(0xFF1A2D3D),
                    ),
                  ),
                  Text(
                    "${CounselingController.onlineCount} ONLINE",
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFF10B981),
                      letterSpacing: 0.5,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 4),
              Text(
                "Pilih teman bicara yang tepat untukmu",
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 12,
                  color: Colors.grey[600],
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: 16),

        // --- LIST DATA KONSELOR ---
        Expanded(
          child: _isLoading
              ? const Center(child: CircularProgressIndicator())
              : filteredKonselor.isEmpty
                  ? _buildEmptyState()
                  : RefreshIndicator(
                      onRefresh: _loadKonselor,
                      // PERBAIKAN 2: Menggunakan ListView.builder untuk performa yang lebih baik
                      child: ListView.builder(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        itemCount: filteredKonselor.length,
                        itemBuilder: (context, index) {
                          return _buildCounselorTile(
                            context,
                            filteredKonselor[index],
                          );
                        },
                      ),
                    ),
        ),
        const SizedBox(height: 16), 
      ],
    ),
  );
}



  Widget _buildChip(String label, bool active) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedFilter = label;
        });
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        margin: const EdgeInsets.only(right: 8),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        decoration: BoxDecoration(
          color: active ? const Color(0xFF1A6B8A) : Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: active ? const Color(0xFF1A6B8A) : Colors.grey.shade300,
          ),
        ),
        child: Text(
          label,
          style: GoogleFonts.plusJakartaSans(
            color: active ? Colors.white : Colors.grey[600],
            fontWeight: active ? FontWeight.bold : FontWeight.w600,
            fontSize: 13,
          ),
        ),
      ),
    );
  }

  Widget _buildCounselorTile(BuildContext context, Konselor data) {
    return GestureDetector(
      onTap: () {
        if (data.isQuotaFull) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                "Sesi ${data.name} hari ini sudah penuh",
                style: GoogleFonts.plusJakartaSans(
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              backgroundColor: Colors.red[700],
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          );
          return;
        }
        context.push('/counseling/profil', extra: data.toMap());
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Opacity(
          opacity: data.isQuotaFull ? 0.55 : 1.0,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Stack(
                children: [
                  CircleAvatar(
                    radius: 35,
                    backgroundColor: Colors.blueGrey[100],
                    backgroundImage: NetworkImage(
                      (data.fotoProfil != null && data.fotoProfil!.isNotEmpty)
                          ? data.fotoProfil!
                          : "https://i.pravatar.cc/150?u=${data.name}",
                    ),
                  ),
                  if (data.isOnline)
                    Positioned(
                      bottom: 0,
                      right: 4,
                      child: Container(
                        width: 14,
                        height: 14,
                        decoration: BoxDecoration(
                          color: const Color(0xFF10B981),
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.white, width: 2),
                        ),
                      ),
                    ),
                ],
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Text(
                            data.name,
                            style: GoogleFonts.plusJakartaSans(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                              color: const Color(0xFF1A2D3D),
                              height: 1.2,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      data.specialty,
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 12,
                        color: const Color(0xFF1A6B8A),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Icon(
                          Icons.chat_bubble_outline,
                          color: Colors.grey[500],
                          size: 14,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          data.sessions.replaceAll(' Sesi', ''),
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 11,
                            color: Colors.grey[600],
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        Text(
                          " Sesi",
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 11,
                            color: Colors.grey[600],
                          ),
                        ),
                        const SizedBox(width: 12),
                        const Spacer(),
                        if (data.isQuotaFull)
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.red[50],
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(color: Colors.red.shade200),
                            ),
                            child: Text(
                              "Sesi Penuh",
                              style: GoogleFonts.plusJakartaSans(
                                fontSize: 11,
                                fontWeight: FontWeight.bold,
                                color: Colors.red[700],
                              ),
                            ),
                          )
                        else ...[
                          Text(
                            "Lihat Profil",
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: const Color(0xFF1A6B8A),
                            ),
                          ),
                          const Icon(
                            Icons.chevron_right,
                            color: Color(0xFF1A6B8A),
                            size: 16,
                          ),
                        ],
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.search_off, size: 60, color: Colors.grey[300]),
          const SizedBox(height: 16),
          Text(
            "Konselor tidak ditemukan",
            style: GoogleFonts.plusJakartaSans(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            "Coba ubah kata kunci pencarian atau filter",
            style: GoogleFonts.plusJakartaSans(
              fontSize: 13,
              color: Colors.grey[500],
            ),
          ),
        ],
      ),
    );
  }
}
