import 'package:flutter/material.dart';
import '../../../../core/constant/app_colors.dart';
import 'map_recenter_fab_widget.dart';

// ─────────────────────────────────────────────────────────────────────────────
// 1. PIN 1: KOTLIN • 45M (PULSING GREEN GLOW AVATAR & ⚡ 84% BADGE)
// ─────────────────────────────────────────────────────────────────────────────
class MapKotlinPinWidget extends StatelessWidget {
  final VoidCallback? onTap;

  const MapKotlinPinWidget({super.key, this.onTap});

  @override
  Widget build(BuildContext context) {
    final isDark = AppColors.isDark(context);
    final surfaceColor = isDark ? const Color(0xFF1E293B) : Colors.white;

    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Floating Speech Bubble: ⚡ 🟢 Kotlin • 45m
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            decoration: BoxDecoration(
              color: surfaceColor,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: const Color(0xFF22C55E).withValues(alpha: 0.7),
                width: 1.5,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.12),
                  blurRadius: 8,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(
                  Icons.bolt_rounded,
                  size: 15,
                  color: Color(0xFFEAB308),
                ),
                const SizedBox(width: 3),
                Container(
                  width: 6,
                  height: 6,
                  decoration: const BoxDecoration(
                    color: Color(0xFF22C55E),
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 5),
                Text(
                  'Kotlin • 45m',
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    color: isDark ? Colors.white : const Color(0xFF1E293B),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 4),

          // Avatar dengan Lingkaran Glow Hijau
          Stack(
            alignment: Alignment.center,
            clipBehavior: Clip.none,
            children: [
              // Radial Green Glow Ring
              Container(
                width: 54,
                height: 54,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: const Color(0xFF22C55E).withValues(alpha: 0.22),
                  border: Border.all(
                    color: const Color(0xFF22C55E).withValues(alpha: 0.45),
                    width: 2,
                  ),
                ),
              ),

              // Avatar Circle
              Container(
                width: 42,
                height: 42,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white, width: 2),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.15),
                      blurRadius: 6,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: ClipOval(
                  child: Image.network(
                    'https://images.unsplash.com/photo-1534528741775-53994a69daeb?w=150&q=80',
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => Container(
                      color: const Color(0xFF818CF8),
                      alignment: Alignment.center,
                      child: const Text(
                        'AN',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
              ),

              // Badges di Bawah Avatar (⚡ 84% & <>)
              Positioned(
                bottom: -8,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 5,
                        vertical: 1.5,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFF1E293B),
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                          color: Colors.white.withValues(alpha: 0.2),
                          width: 0.8,
                        ),
                      ),
                      child: const Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.bolt, size: 10, color: Color(0xFFFACC15)),
                          SizedBox(width: 1),
                          Text(
                            '84%',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 9.5,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 3),
                    Container(
                      padding: const EdgeInsets.all(2.5),
                      decoration: BoxDecoration(
                        color: const Color(0xFF4F46E5),
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white, width: 0.8),
                      ),
                      child: const Icon(
                        Icons.code_rounded,
                        size: 9,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// 2. PIN 2: STUDIO • 3 BUDDIES [HOT] (OVERLAPPING AVATARS & ⚡ 92%)
// ─────────────────────────────────────────────────────────────────────────────
class MapStudioHotPinWidget extends StatelessWidget {
  final VoidCallback? onTap;

  const MapStudioHotPinWidget({super.key, this.onTap});

  @override
  Widget build(BuildContext context) {
    final isDark = AppColors.isDark(context);
    final surfaceColor = isDark ? const Color(0xFF1E293B) : Colors.white;

    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Floating Speech Bubble: 👋 Studio • 3 buddies [HOT]
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            decoration: BoxDecoration(
              color: surfaceColor,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0),
                width: 1,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.12),
                  blurRadius: 8,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text('👋', style: TextStyle(fontSize: 12)),
                const SizedBox(width: 4),
                Text(
                  'Studio • 3 buddies',
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    color: isDark ? Colors.white : const Color(0xFF1E293B),
                  ),
                ),
                const SizedBox(width: 5),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1.5),
                  decoration: BoxDecoration(
                    color: const Color(0xFF84CC16),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: const Text(
                    'HOT',
                    style: TextStyle(
                      color: Color(0xFF0F172A),
                      fontSize: 8.5,
                      fontWeight: FontWeight.w900,
                      letterSpacing: 0.5,
                    ),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 4),

          // Overlapping Avatars (2 Photos + "+1" Purple Circle)
          Stack(
            alignment: Alignment.center,
            clipBehavior: Clip.none,
            children: [
              SizedBox(
                width: 78,
                height: 42,
                child: Stack(
                  children: [
                    // Avatar 1
                    Positioned(
                      left: 0,
                      child: _buildAvatarCircle(
                        'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=150&q=80',
                        'JD',
                        const Color(0xFF6366F1),
                      ),
                    ),
                    // Avatar 2
                    Positioned(
                      left: 20,
                      child: _buildAvatarCircle(
                        'https://images.unsplash.com/photo-1494790108377-be9c29b29330?w=150&q=80',
                        'SR',
                        const Color(0xFFEC4899),
                      ),
                    ),
                    // Avatar 3 (+1)
                    Positioned(
                      left: 40,
                      child: Container(
                        width: 38,
                        height: 38,
                        decoration: BoxDecoration(
                          color: const Color(0xFF4F46E5),
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.white, width: 2),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.15),
                              blurRadius: 4,
                            ),
                          ],
                        ),
                        alignment: Alignment.center,
                        child: const Text(
                          '+1',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 11,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // Badge Data Bawah: ⚡ 92%
              Positioned(
                bottom: -8,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 1.5),
                  decoration: BoxDecoration(
                    color: const Color(0xFF1E293B),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      color: Colors.white.withValues(alpha: 0.2),
                      width: 0.8,
                    ),
                  ),
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.bolt, size: 10, color: Color(0xFFFACC15)),
                      SizedBox(width: 1),
                      Text(
                        '92%',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 9.5,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildAvatarCircle(String url, String fallback, Color fallbackColor) {
    return Container(
      width: 38,
      height: 38,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: Colors.white, width: 2),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.15),
            blurRadius: 4,
          ),
        ],
      ),
      child: ClipOval(
        child: Image.network(
          url,
          fit: BoxFit.cover,
          errorBuilder: (_, __, ___) => Container(
            color: fallbackColor,
            alignment: Alignment.center,
            child: Text(
              fallback,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 11,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// 3. PIN 3: CALCULUS • CAFE ADA (AVATAR INDIGO & ⚡ 19% BADGE)
// ─────────────────────────────────────────────────────────────────────────────
class MapCalculusCafePinWidget extends StatelessWidget {
  final VoidCallback? onTap;

  const MapCalculusCafePinWidget({super.key, this.onTap});

  @override
  Widget build(BuildContext context) {
    final isDark = AppColors.isDark(context);
    final surfaceColor = isDark ? const Color(0xFF1E293B) : Colors.white;

    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Floating Speech Bubble: ☕ Calculus • Cafe Ada
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            decoration: BoxDecoration(
              color: surfaceColor,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0),
                width: 1,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.12),
                  blurRadius: 8,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text('☕', style: TextStyle(fontSize: 12)),
                const SizedBox(width: 4),
                Text(
                  'Calculus • Cafe Ada',
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    color: isDark ? Colors.white : const Color(0xFF1E293B),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 4),

          // Avatar Bulat dengan Border Indigo / Ungu
          Stack(
            alignment: Alignment.center,
            clipBehavior: Clip.none,
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: const Color(0xFF6366F1), width: 3),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF6366F1).withValues(alpha: 0.3),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: ClipOval(
                  child: Image.network(
                    'https://images.unsplash.com/photo-1517841905240-472988babdf9?w=150&q=80',
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => Container(
                      color: const Color(0xFF6366F1),
                      alignment: Alignment.center,
                      child: const Text(
                        'CA',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
              ),

              // Badges di Bawah Avatar (⚡ 19% & Mute/Headphone)
              Positioned(
                bottom: -8,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 5,
                        vertical: 1.5,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFF1E293B),
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                          color: Colors.white.withValues(alpha: 0.2),
                          width: 0.8,
                        ),
                      ),
                      child: const Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.bolt, size: 10, color: Color(0xFFF87171)),
                          SizedBox(width: 1),
                          Text(
                            '19%',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 9.5,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 3),
                    Container(
                      padding: const EdgeInsets.all(2.5),
                      decoration: BoxDecoration(
                        color: const Color(0xFF4F46E5),
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white, width: 0.8),
                      ),
                      child: const Icon(
                        Icons.headphones_rounded,
                        size: 9,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// 4. OVERLAYS CONTROL: COMPASS 'N' (KIRI ATAS)
// ─────────────────────────────────────────────────────────────────────────────
class MapCompassControlWidget extends StatelessWidget {
  final VoidCallback? onTap;

  const MapCompassControlWidget({super.key, this.onTap});

  @override
  Widget build(BuildContext context) {
    final isDark = AppColors.isDark(context);
    final surfaceColor = isDark ? const Color(0xFF1E293B) : Colors.white;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(22),
        child: Container(
          width: 44,
          height: 44,
          decoration: BoxDecoration(
            color: surfaceColor,
            shape: BoxShape.circle,
            border: Border.all(
              color: isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0),
              width: 1,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: isDark ? 0.3 : 0.08),
                blurRadius: 10,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'N',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w800,
                  color: isDark ? Colors.white : const Color(0xFF1E293B),
                ),
              ),
              Container(
                width: 3,
                height: 8,
                decoration: BoxDecoration(
                  color: const Color(0xFF4F46E5),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// 5. OVERLAYS CONTROL: VERTICAL RIGHT BUTTONS (EYE, FIRE, TARGET GPS)
// ─────────────────────────────────────────────────────────────────────────────
class MapRightControlsStackWidget extends StatelessWidget {
  final VoidCallback? onEyeTap;
  final VoidCallback? onFireTap;
  final VoidCallback? onGpsTap;

  const MapRightControlsStackWidget({
    super.key,
    this.onEyeTap,
    this.onFireTap,
    this.onGpsTap,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = AppColors.isDark(context);
    final surfaceColor = isDark ? const Color(0xFF1E293B) : Colors.white;
    final iconColor = isDark ? Colors.white : const Color(0xFF334155);

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // 1. Eye Button (Visibility)
        _buildCircleButton(
          icon: Icons.remove_red_eye_outlined,
          color: surfaceColor,
          iconColor: iconColor,
          isDark: isDark,
          tooltip: 'Visibilitas Peta',
          onTap: onEyeTap,
        ),
        const SizedBox(height: 10),

        // 2. Fire Button (Trending Vibe)
        _buildCircleButton(
          icon: Icons.local_fire_department_rounded,
          color: surfaceColor,
          iconColor: const Color(0xFF4F46E5),
          isDark: isDark,
          tooltip: 'Trending Study Vibe',
          onTap: onFireTap,
        ),
        const SizedBox(height: 10),

        // 3. Target GPS Button (Ungu Solid / Pusatkan ke Lokasi Saya)
        MapRecenterFabWidget(
          onPressed: onGpsTap ?? () {},
        ),
      ],
    );
  }

  Widget _buildCircleButton({
    required IconData icon,
    required Color color,
    required Color iconColor,
    required bool isDark,
    required String tooltip,
    VoidCallback? onTap,
  }) {
    return Tooltip(
      message: tooltip,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(22),
          child: Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle,
              border: Border.all(
                color: isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0),
                width: 1,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: isDark ? 0.3 : 0.1),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Icon(icon, size: 20, color: iconColor),
          ),
        ),
      ),
    );
  }
}
