import 'package:flutter/material.dart';
import '../constants.dart';
import 'package:go_router/go_router.dart';

// ─── Status Bar ──────────────────────────────────────────────────────────────
class PhoneStatusBar extends StatelessWidget {
  const PhoneStatusBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.fromLTRB(20, 10, 20, 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text(
            '19:02',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w700,
              color: kTextPrimary,
            ),
          ),
          Row(
            children: [
              Icon(Icons.wifi, size: 14, color: kTextPrimary),
              const SizedBox(width: 4),
              Icon(Icons.signal_cellular_alt, size: 14, color: kTextPrimary),
            ],
          ),
        ],
      ),
    );
  }
}

// ─── Top Nav Bar ─────────────────────────────────────────────────────────────
class PhoneNavTop extends StatelessWidget {
  final String title;
  final Widget? trailing;

  const PhoneNavTop({super.key, required this.title, this.trailing});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.fromLTRB(16, 6, 16, 10),
      child: Row(
        children: [
          Container(
            width: 28,
            height: 28,
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(8)),
            child: const Icon(
              Icons.chevron_left,
              size: 22,
              color: kTextPrimary,
            ),
          ),
          const SizedBox(width: 8),
          Text(
            title,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: kTextPrimary,
            ),
          ),
          const Spacer(),
          if (trailing != null) trailing!,
        ],
      ),
    );
  }
}

// ─── Bottom Navigation ───────────────────────────────────────────────────────
class BottomNav extends StatelessWidget {
  final int activeIndex;

  const BottomNav({super.key, required this.activeIndex});

  @override
  Widget build(BuildContext context) {
    final items = [
      {'icon': Icons.home_outlined, 'label': 'Home'},
      {'icon': Icons.calendar_today_outlined, 'label': 'Jadwal'},
      {'icon': Icons.chat_bubble_outline, 'label': ''},
      {'icon': Icons.star_outline, 'label': 'Aktivitas'},
      {'icon': Icons.person_outline, 'label': 'Profil'},
    ];

    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: Color(0xFFE8F4F4))),
      ),
      padding: const EdgeInsets.fromLTRB(10, 8, 10, 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: List.generate(items.length, (i) {
          final isFab = i == 2;
          final isActive = i == activeIndex;

          if (isFab) {
            return Container(
              width: 48,
              height: 48,
              margin: const EdgeInsets.only(bottom: 16),
              decoration: BoxDecoration(
                color: kTeal,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: kTeal.withOpacity(0.35),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: const Icon(
                Icons.chat_bubble_outline,
                color: Colors.white,
                size: 22,
              ),
            );
          }

          return Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                items[i]['icon'] as IconData,
                size: 20,
                color: isActive ? kTeal : kTextMuted,
              ),
              const SizedBox(height: 2),
              Text(
                items[i]['label'] as String,
                style: TextStyle(
                  fontSize: 9,
                  color: isActive ? kTeal : kTextMuted,
                ),
              ),
            ],
          );
        }),
      ),
    );
  }
}

// ─── Konselor Card ───────────────────────────────────────────────────────────
class KonselorCard extends StatelessWidget {
  final String initials;
  final String name;
  final String specialist;
  final Color avatarColor;
  final Widget? trailing;

  const KonselorCard({
    super.key,
    required this.initials,
    required this.name,
    required this.specialist,
    this.avatarColor = kTeal,
    this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: kBorder),
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 22,
            backgroundColor: avatarColor,
            child: Text(
              initials,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w700,
                color: Colors.white,
              ),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: kTextPrimary,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  specialist,
                  style: const TextStyle(fontSize: 11, color: kTextSecondary),
                ),
              ],
            ),
          ),
          if (trailing != null) trailing!,
        ],
      ),
    );
  }
}

// ─── Info Row ────────────────────────────────────────────────────────────────
class InfoRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const InfoRow({
    super.key,
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 14, color: kTeal),
        const SizedBox(width: 6),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: const TextStyle(fontSize: 10, color: kTextMuted),
            ),
            Text(
              value,
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: kTextPrimary,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

// ─── Section Title ───────────────────────────────────────────────────────────
class SectionTitle extends StatelessWidget {
  final IconData icon;
  final String title;

  const SectionTitle({super.key, required this.icon, required this.title});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 14, bottom: 8),
      child: Row(
        children: [
          Icon(icon, size: 14, color: kTeal),
          const SizedBox(width: 6),
          Text(
            title,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: kTextSecondary,
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Check Item ──────────────────────────────────────────────────────────────
class CheckItem extends StatelessWidget {
  final String text;
  final bool done;

  const CheckItem({super.key, required this.text, required this.done});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 16,
          height: 16,
          margin: const EdgeInsets.only(top: 1),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: done ? kTeal : Colors.transparent,
            border: Border.all(color: kTeal, width: 1.5),
          ),
          child: done
              ? const Icon(Icons.check, color: Colors.white, size: 9)
              : null,
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            text,
            style: const TextStyle(fontSize: 11, color: Color(0xFF475569)),
          ),
        ),
      ],
    );
  }
}

// ─── Buttons ─────────────────────────────────────────────────────────────────
class TealButton extends StatelessWidget {
  final String label;
  final IconData? icon;
  final VoidCallback? onTap;

  const TealButton({super.key, required this.label, this.icon, this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          gradient: const LinearGradient(colors: [kTeal, kTealDark]),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (icon != null) ...[
              Icon(icon, color: Colors.white, size: 14),
              const SizedBox(width: 6),
            ],
            Text(
              label,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class OutlineButton extends StatelessWidget {
  final String label;
  final IconData? icon;
  final Color color;
  final Color? bgColor;
  final VoidCallback? onTap;

  const OutlineButton({
    super.key,
    required this.label,
    this.icon,
    this.color = kTeal,
    this.bgColor,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 11),
        decoration: BoxDecoration(
          color: bgColor ?? Colors.white,
          border: Border.all(color: color, width: 1.5),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (icon != null) ...[
              Icon(icon, color: color, size: 14),
              const SizedBox(width: 6),
            ],
            Text(
              label,
              style: TextStyle(
                color: color,
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
