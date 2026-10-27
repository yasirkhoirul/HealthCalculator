import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';

/// Docked Edge-to-Edge Bottom Navigation Bar
/// Menempel penuh di bagian bawah layar (non-floating) dengan garis pemisah
/// atas halus dan indikator aktif proporsional.
class CustomBottomNavbar extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;

  const CustomBottomNavbar({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = AppColors.isDark(context);
    final surfaceColor = isDark ? const Color(0xFF1E293B) : Colors.white;
    final dividerColor = isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0);

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: surfaceColor,
        border: Border(
          top: BorderSide(
            color: dividerColor,
            width: 1.0,
          ),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.30 : 0.05),
            blurRadius: 10,
            offset: const Offset(0, -3),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: SizedBox(
          height: 64,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              // 1. Compass / Map (Aktif: icon warna putih di dalam lingkaran ungu solid #4F46E5)
              _buildNavItem(
                context: context,
                index: 0,
                icon: Icons.explore_rounded,
                inactiveIcon: Icons.explore_outlined,
                tooltip: 'Peta Spot',
                isCompass: true,
              ),

              // 2. Timer / Active Session
              _buildNavItem(
                context: context,
                index: 1,
                icon: Icons.timer_rounded,
                inactiveIcon: Icons.timer_outlined,
                tooltip: 'Fokus Belajar',
              ),

              // 3. Chat / Messages
              _buildNavItem(
                context: context,
                index: 2,
                icon: Icons.chat_bubble_rounded,
                inactiveIcon: Icons.chat_bubble_outline_rounded,
                tooltip: 'Pesan & Teman',
              ),

              // 4. Profile / Person
              _buildNavItem(
                context: context,
                index: 3,
                icon: Icons.person_rounded,
                inactiveIcon: Icons.person_outline_rounded,
                tooltip: 'Profil Saya',
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem({
    required BuildContext context,
    required int index,
    required IconData icon,
    required IconData inactiveIcon,
    required String tooltip,
    bool isCompass = false,
  }) {
    final isSelected = currentIndex == index;
    const primaryPurple = Color(0xFF4F46E5);
    final isDark = AppColors.isDark(context);
    final inactiveColor =
        isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B);

    return Tooltip(
      message: tooltip,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => onTap(index),
          borderRadius: BorderRadius.circular(25),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: isSelected
                  ? (isCompass ? primaryPurple : primaryPurple.withValues(alpha: 0.12))
                  : Colors.transparent,
            ),
            child: Icon(
              isSelected ? icon : inactiveIcon,
              size: 24,
              color: isSelected
                  ? (isCompass ? Colors.white : primaryPurple)
                  : inactiveColor,
            ),
          ),
        ),
      ),
    );
  }
}
