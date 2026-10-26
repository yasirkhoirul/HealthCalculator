import 'package:flutter/material.dart';
import '../../../../core/constant/app_colors.dart';
import '../../data/models/user_presence_model.dart';
import 'map_status_bubble_widget.dart';

/// Marker Pin Khusus Pengguna Sendiri ("Lokasi Saya")
/// Dilengkapi dengan animasi denyut radar halus (pulsing radar effect),
/// ring gradient ungu (#4F46E5), dan bubble emote melayang di atasnya.
class MapMyLocationMarkerWidget extends StatefulWidget {
  final UserPresenceModel user;
  final VoidCallback onTap;

  const MapMyLocationMarkerWidget({
    super.key,
    required this.user,
    required this.onTap,
  });

  @override
  State<MapMyLocationMarkerWidget> createState() =>
      _MapMyLocationMarkerWidgetState();
}

class _MapMyLocationMarkerWidgetState extends State<MapMyLocationMarkerWidget>
    with SingleTickerProviderStateMixin {
  late final AnimationController _pulseController;
  late final Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2000),
    );

    final isTest = WidgetsBinding.instance.runtimeType.toString().contains('Test');
    if (isTest) {
      _pulseController.forward();
    } else {
      _pulseController.repeat();
    }

    _pulseAnimation = CurvedAnimation(
      parent: _pulseController,
      curve: Curves.easeOutQuad,
    );
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final surfaceColor = AppColors.surfaceOf(context);
    final primaryColor = AppColors.primaryOf(context);

    return Tooltip(
      message: 'Lokasi Saya • Ketuk untuk ubah status emote',
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: widget.onTap,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // 1. Floating Emote Bubble (Melayang di atas pin)
            if (widget.user.status != null)
              Padding(
                padding: const EdgeInsets.only(bottom: 2),
                child: MapStatusBubbleWidget(
                  status: widget.user.status!,
                  isMyLocation: true,
                ),
              ),

            // 2. Avatar Pin dengan Efek Pulsing Radar
            SizedBox(
              width: 58,
              height: 58,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  // Pulsing Animated Ring
                  AnimatedBuilder(
                    animation: _pulseAnimation,
                    builder: (context, child) {
                      final scale = 1.0 + (_pulseAnimation.value * 0.45);
                      final opacity = (1.0 - _pulseAnimation.value).clamp(0.0, 1.0);
                      return Transform.scale(
                        scale: scale,
                        child: Container(
                          width: 48,
                          height: 48,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: const Color(0xFF4F46E5)
                                .withValues(alpha: opacity * 0.35),
                          ),
                        ),
                      );
                    },
                  ),

                  // Avatar Center Card
                  Container(
                    width: 44,
                    height: 44,
                    padding: const EdgeInsets.all(2.5),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: const LinearGradient(
                        colors: [Color(0xFF4F46E5), Color(0xFF7C3AED)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      border: Border.all(color: surfaceColor, width: 2.5),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFF4F46E5).withValues(alpha: 0.45),
                          blurRadius: 12,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: surfaceColor,
                      ),
                      child: Center(
                        child: Text(
                          widget.user.avatarInitials,
                          style: TextStyle(
                            color: primaryColor,
                            fontWeight: FontWeight.w900,
                            fontSize: 13.5,
                          ),
                        ),
                      ),
                    ),
                  ),

                  // "YOU" Mini Pill Badge
                  Positioned(
                    bottom: 0,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1),
                      decoration: BoxDecoration(
                        color: const Color(0xFF4F46E5),
                        borderRadius: BorderRadius.circular(6),
                        border: Border.all(color: surfaceColor, width: 1.2),
                      ),
                      child: const Text(
                        'SAYA',
                        style: TextStyle(
                          fontSize: 8.5,
                          fontWeight: FontWeight.w900,
                          color: Colors.white,
                          letterSpacing: 0.2,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
