import 'package:flutter/material.dart';

/// Tombol Tunggal "Pusatkan ke Lokasi Saya" (Single Recenter FAB)
///
/// FAB bulat berwarna ungu indigo solid (#4F46E5) dengan ikon target GPS
/// putih di dalamnya untuk memusatkan kembali tampilan peta ke posisi pengguna.
class SingleRecenterFabWidget extends StatelessWidget {
  final VoidCallback onPressed;
  final String tooltip;
  final double size;

  const SingleRecenterFabWidget({
    super.key,
    required this.onPressed,
    this.tooltip = 'Pusatkan ke Lokasi Saya',
    this.size = 44,
  });

  @override
  Widget build(BuildContext context) {
    const primaryPurple = Color(0xFF4F46E5);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Tooltip(
      message: tooltip,
      child: Material(
        color: Colors.transparent,
        shape: const CircleBorder(),
        elevation: 4,
        shadowColor: primaryPurple.withValues(alpha: 0.45),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: onPressed,
          customBorder: const CircleBorder(),
          splashColor: Colors.white.withValues(alpha: 0.25),
          highlightColor: Colors.white.withValues(alpha: 0.15),
          child: Ink(
            width: size,
            height: size,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: primaryPurple,
              border: Border.all(
                color: isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0),
                width: 1,
              ),
            ),
            child: Center(
              child: Icon(
                Icons.my_location_rounded,
                size: size >= 48 ? 24 : 20,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

