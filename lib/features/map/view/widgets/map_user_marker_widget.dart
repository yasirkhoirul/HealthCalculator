import 'package:flutter/material.dart';
import '../../../../core/constant/app_colors.dart';
import '../../data/models/user_presence_model.dart';
import 'map_status_bubble_widget.dart';

/// Pin Marker Avatar Pengguna Lain di Peta Kampus (Zenly / TikTok Map Style)
/// Mendukung bubble emote belajar dinamis, animasi state terpilih (scale up & glow highlight), dan gesture interaktif.
class MapUserMarkerWidget extends StatelessWidget {
  final UserPresenceModel user;
  final bool isSelected;
  final VoidCallback onTap;

  const MapUserMarkerWidget({
    super.key,
    required this.user,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final surfaceColor = AppColors.surfaceOf(context);
    final textPrimaryColor = AppColors.textPrimaryOf(context);
    final primaryColor = AppColors.primaryOf(context);

    return Tooltip(
      message: '${user.name} • ${user.currentTopic}',
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: onTap,
        child: AnimatedScale(
          scale: isSelected ? 1.18 : 1.0,
          duration: const Duration(milliseconds: 250),
          curve: Curves.easeOutBack,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Bubble Emote Status Belajar (Jika Ada)
              if (user.status != null)
                Padding(
                  padding: const EdgeInsets.only(bottom: 2),
                  child: MapStatusBubbleWidget(
                    status: user.status!,
                    isMyLocation: false,
                  ),
                ),

              // Avatar dengan Active Ring & Highlight Glow
              AnimatedContainer(
                duration: const Duration(milliseconds: 250),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  boxShadow: [
                    if (isSelected)
                      BoxShadow(
                        color: primaryColor.withValues(alpha: 0.45),
                        blurRadius: 16,
                        spreadRadius: 3,
                      )
                    else
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.18),
                        blurRadius: 8,
                        offset: const Offset(0, 3),
                      ),
                  ],
                ),
                child: Stack(
                  clipBehavior: Clip.none,
                  children: [
                    // Outer Ring Accent
                    Container(
                      width: 44,
                      height: 44,
                      padding: const EdgeInsets.all(2.5),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: isSelected
                            ? primaryColor
                            : (user.isOnline
                                ? const Color(0xFF22C55E)
                                : AppColors.borderOf(context)),
                        border: Border.all(
                          color: surfaceColor,
                          width: 2,
                        ),
                      ),
                      child: Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [
                              primaryColor,
                              AppColors.studentAvatarPurple,
                            ],
                          ),
                        ),
                        child: Center(
                          child: Text(
                            user.avatarInitials,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 13,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                        ),
                      ),
                    ),

                    // Dot Indikator Status Bulat (Hijau saat online, abu saat offline)
                    Positioned(
                      right: -1,
                      bottom: -1,
                      child: Container(
                        width: 13,
                        height: 13,
                        decoration: BoxDecoration(
                          color: user.isOnline
                              ? const Color(0xFF22C55E)
                              : AppColors.textMutedOf(context),
                          shape: BoxShape.circle,
                          border: Border.all(color: surfaceColor, width: 2),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 3),

              // Label Nama Mini Pill
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: isSelected
                      ? primaryColor
                      : surfaceColor.withValues(alpha: 0.94),
                  borderRadius: BorderRadius.circular(6),
                  border: Border.all(
                    color: isSelected ? primaryColor : AppColors.borderSubtleOf(context),
                    width: 0.8,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.08),
                      blurRadius: 4,
                      offset: const Offset(0, 1.5),
                    ),
                  ],
                ),
                child: Text(
                  user.name,
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w700,
                    color: isSelected ? Colors.white : textPrimaryColor,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
