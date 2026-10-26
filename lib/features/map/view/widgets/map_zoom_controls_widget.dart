import 'package:flutter/material.dart';
import '../../../../core/constant/app_colors.dart';

/// Kontrol interaktif Zoom In (+) dan Zoom Out (-) melayang di peta kampus.
///
/// Menyediakan sepasang tombol vertikal berbentuk kapsul dengan efek ripple,
/// pembatasan visual zoom (disabled state), dan touch target minimal 44x44 dp.
class MapZoomControlsWidget extends StatelessWidget {
  final VoidCallback onZoomIn;
  final VoidCallback onZoomOut;
  final bool canZoomIn;
  final bool canZoomOut;

  const MapZoomControlsWidget({
    super.key,
    required this.onZoomIn,
    required this.onZoomOut,
    this.canZoomIn = true,
    this.canZoomOut = true,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = AppColors.isDark(context);
    final surfaceColor = isDark ? const Color(0xFF1E293B) : Colors.white;
    final borderColor = isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0);
    final dividerColor = isDark ? const Color(0xFF334155) : const Color(0xFFF1F5F9);
    final activeIconColor = isDark ? const Color(0xFFF1F5F9) : const Color(0xFF1E293B);
    final disabledIconColor = isDark ? const Color(0xFF475569) : const Color(0xFFCBD5E1);

    return Container(
      width: 46,
      decoration: BoxDecoration(
        color: surfaceColor,
        borderRadius: BorderRadius.circular(23),
        border: Border.all(color: borderColor, width: 1.0),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.35 : 0.08),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // ─── 1. Tombol Zoom In (+) ───
          _buildZoomButton(
            icon: Icons.add_rounded,
            tooltip: 'Perbesar Peta',
            isEnabled: canZoomIn,
            activeColor: activeIconColor,
            disabledColor: disabledIconColor,
            onTap: onZoomIn,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(23)),
          ),

          // Divider horizontal halus
          Container(
            height: 1,
            width: 30,
            color: dividerColor,
          ),

          // ─── 2. Tombol Zoom Out (-) ───
          _buildZoomButton(
            icon: Icons.remove_rounded,
            tooltip: 'Perkecil Peta',
            isEnabled: canZoomOut,
            activeColor: activeIconColor,
            disabledColor: disabledIconColor,
            onTap: onZoomOut,
            borderRadius: const BorderRadius.vertical(bottom: Radius.circular(23)),
          ),
        ],
      ),
    );
  }

  Widget _buildZoomButton({
    required IconData icon,
    required String tooltip,
    required bool isEnabled,
    required Color activeColor,
    required Color disabledColor,
    required VoidCallback onTap,
    required BorderRadius borderRadius,
  }) {
    return Tooltip(
      message: tooltip,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: isEnabled ? onTap : null,
          borderRadius: borderRadius,
          splashColor: const Color(0xFF4F46E5).withValues(alpha: 0.15),
          highlightColor: const Color(0xFF4F46E5).withValues(alpha: 0.08),
          child: SizedBox(
            width: 46,
            height: 46, // Touch target 46x46 memenuhi batas minimal 44x44
            child: Center(
              child: Icon(
                icon,
                size: 22,
                color: isEnabled ? activeColor : disabledColor,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
