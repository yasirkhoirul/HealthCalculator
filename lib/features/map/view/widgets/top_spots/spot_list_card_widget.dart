import 'package:flutter/material.dart';
import 'package:health_calculator/core/constant/app_colors.dart';
import 'package:health_calculator/features/map/data/models/spot_model.dart';

/// Card List Spot Reusable
/// Digunakan pada preview sheet ("Top Campus Spots Live") di MapScreen
/// dan halaman detail penelusuran spot ("TopSpotsListPage").
class SpotListCardWidget extends StatelessWidget {
  final SpotModel spot;
  final VoidCallback? onTap;
  final VoidCallback? onRouteTap;
  final bool isCompact;

  const SpotListCardWidget({
    super.key,
    required this.spot,
    this.onTap,
    this.onRouteTap,
    this.isCompact = false,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = AppColors.isDark(context);
    final surfaceColor = isDark ? const Color(0xFF1E293B) : Colors.white;
    final textPrimary = AppColors.textPrimaryOf(context);
    final textMuted = AppColors.textMutedOf(context);
    const primaryPurple = Color(0xFF4F46E5);

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20),
        child: Container(
          padding: EdgeInsets.all(isCompact ? 10 : 14),
          decoration: BoxDecoration(
            color: surfaceColor,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0),
              width: 1,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: isDark ? 0.25 : 0.05),
                blurRadius: 12,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // ─── 1. Foto Thumbnail Spot + Badge Jarak Meter Melayang ───
              Stack(
                alignment: Alignment.bottomLeft,
                children: [
                  Container(
                    width: isCompact ? 68 : 80,
                    height: isCompact ? 68 : 80,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      color: const Color(0xFFE2E8F0),
                    ),
                    clipBehavior: Clip.antiAlias,
                    child: Image.network(
                      spot.imageUrl ??
                          'https://images.unsplash.com/photo-1521587760476-6c12a4b040da?w=300&q=80',
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => Container(
                        color: const Color(0xFF818CF8),
                        alignment: Alignment.center,
                        child: Icon(
                          Icons.apartment_rounded,
                          color: Colors.white,
                          size: isCompact ? 28 : 34,
                        ),
                      ),
                    ),
                  ),

                  // Distance Overlay Badge (misal: "350m", "720m")
                  Positioned(
                    left: 5,
                    bottom: 5,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 6,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.black.withValues(alpha: 0.72),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        spot.formattedDistance,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 10,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 0.2,
                        ),
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(width: 12),

              // ─── 2. Info Spot, Keramaian, & Teman ───
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Nama Spot
                    Text(
                      spot.name,
                      style: TextStyle(
                        fontSize: isCompact ? 14 : 15.5,
                        fontWeight: FontWeight.w700,
                        color: textPrimary,
                        letterSpacing: -0.2,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),

                    const SizedBox(height: 3),

                    // Subtitle (misal: "Silent Zone • Power outlets at 90%")
                    Text(
                      spot.subtitle,
                      style: TextStyle(
                        fontSize: 11.5,
                        fontWeight: FontWeight.w400,
                        color: textMuted,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),

                    const SizedBox(height: 6),

                    // Row Status: 🟢 14 Desks Open • 28 friends nearby
                    Row(
                      children: [
                        // Dot status
                        Container(
                          width: 6.5,
                          height: 6.5,
                          decoration: BoxDecoration(
                            color: _getStatusColor(spot.crowdLevel),
                            shape: BoxShape.circle,
                          ),
                        ),
                        const SizedBox(width: 5),
                        Text(
                          spot.crowdStatus,
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w700,
                            color: _getStatusColor(spot.crowdLevel),
                          ),
                        ),
                        const SizedBox(width: 6),
                        Container(
                          width: 3,
                          height: 3,
                          decoration: BoxDecoration(
                            color: textMuted.withValues(alpha: 0.5),
                            shape: BoxShape.circle,
                          ),
                        ),
                        const SizedBox(width: 6),
                        Expanded(
                          child: Text(
                            spot.friendsSummary,
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w500,
                              color: textMuted,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(width: 8),

              // ─── 3. Tombol Aksi Navigasi / Rute ───
              Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: onRouteTap ?? onTap,
                  borderRadius: BorderRadius.circular(22),
                  child: Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      color: isDark
                          ? const Color(0xFF312E81)
                          : const Color(0xFFEEF2FF),
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: primaryPurple.withValues(alpha: 0.2),
                        width: 1,
                      ),
                    ),
                    child: const Icon(
                      Icons.navigation_rounded,
                      color: primaryPurple,
                      size: 20,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Color _getStatusColor(String level) {
    switch (level.toLowerCase()) {
      case 'silent zone':
        return const Color(0xFF22C55E);
      case 'moderate crowd':
        return const Color(0xFF65A30D);
      case 'buzzing':
        return const Color(0xFFF59E0B);
      default:
        return const Color(0xFF22C55E);
    }
  }
}
