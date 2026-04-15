import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:go_router/go_router.dart';

import 'router.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      title: 'Polinema Care+',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color.fromARGB(255, 111, 190, 204),
        ),
        useMaterial3: true,
        textTheme: GoogleFonts.plusJakartaSansTextTheme(),
      ),
      routerConfig: appRouter,
    );
  }
}

class MainScreen extends StatelessWidget {
  final StatefulNavigationShell navigationShell;

  const MainScreen({super.key, required this.navigationShell});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color.fromARGB(179, 247, 250, 249),
              Color.fromARGB(255, 245, 249, 255),
            ],
          ),
        ),
        child: navigationShell,
      ),
      bottomNavigationBar: CustomBottomNavBar(
        currentIndex: navigationShell.currentIndex,
        onTap: (index) {
          navigationShell.goBranch(
            index,
            initialLocation: index == navigationShell.currentIndex,
          );
        },
      ),
    );
  }
}

class CustomBottomNavBar extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;
  const CustomBottomNavBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  static const _bgLightGrey = Color.fromARGB(255, 240, 244, 247);
  static const _iconGrey = Color(0xFF8A97A8);
  static const _activeGreen = Color(0xFFD6F5E3);
  static const _darkGreen = Color(0xFF004D40);
  static const _defaultBlue = Color(0xFF00668F);

  static const List<_NavItem> _items = [
    _NavItem(icon: Icons.home_rounded, label: 'Home'),
    _NavItem(icon: Icons.bar_chart_rounded, label: 'Activity'),
    _NavItem(icon: Icons.send_rounded, label: 'Inbox', isCenterFab: true),
    _NavItem(icon: Icons.psychology_rounded, label: 'Counseling'),
    _NavItem(icon: Icons.person_rounded, label: 'Profile'),
  ];

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      bottom: true,
      child: Stack(
        clipBehavior: Clip.none,
        alignment: Alignment.center,
        children: [
          Container(
            height: 85,
            decoration: const BoxDecoration(
              color: _bgLightGrey,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(45),
                topRight: Radius.circular(45),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 10,
                  offset: Offset(0, -2),
                ),
              ],
            ),
            child: Row(
              children: List.generate(_items.length, (i) {
                final item = _items[i];
                if (item.isCenterFab) return const Expanded(child: SizedBox());
                final isActive = currentIndex == i;

                return Expanded(
                  child: GestureDetector(
                    onTap: () => onTap(i),
                    behavior: HitTestBehavior.opaque,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        AnimatedContainer(
                          duration: const Duration(milliseconds: 250),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 8,
                          ),
                          decoration: BoxDecoration(
                            color: isActive ? _activeGreen : Colors.transparent,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Icon(
                            item.icon,
                            size: 26,
                            color: isActive ? _darkGreen : _iconGrey,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          item.label,
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 11,
                            fontWeight: isActive
                                ? FontWeight.bold
                                : FontWeight.w500,
                            color: isActive ? _darkGreen : _iconGrey,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }),
            ),
          ),
          Positioned(
            top: -30,
            child: GestureDetector(
              onTap: () => onTap(2),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 250),
                width: 70,
                height: 70,
                decoration: BoxDecoration(
                  color: currentIndex == 2 ? _activeGreen : _defaultBlue,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      blurRadius: 10,
                      offset: const Offset(0, 5),
                    ),
                  ],
                ),
                child: Center(
                  child: Transform.rotate(
                    angle: -0.5,
                    child: Icon(
                      Icons.send_rounded,
                      color: currentIndex == 2 ? _darkGreen : Colors.white,
                      size: 32,
                    ),
                  ),
                ),
              ),
            ),
          ),
          Positioned(
            bottom: 10,
            child: GestureDetector(
              onTap: () => onTap(2),
              child: Text(
                'Inbox',
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 11,
                  fontWeight: currentIndex == 2
                      ? FontWeight.bold
                      : FontWeight.w500,
                  color: currentIndex == 2 ? _darkGreen : _iconGrey,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _NavItem {
  final IconData icon;
  final String label;
  final bool isCenterFab;
  const _NavItem({
    required this.icon,
    required this.label,
    this.isCenterFab = false,
  });
}
