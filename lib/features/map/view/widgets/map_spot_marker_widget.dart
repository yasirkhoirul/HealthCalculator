import 'package:flutter/material.dart';
import '../../../../core/constant/app_colors.dart';
import '../../data/models/spot_model.dart';

/// Marker Pin Spot Belajar di atas peta kampus (MapSpotMarkerWidget)
/// Menampilkan ikon kategori dengan glow/border dan label nama tempat di bawahnya.
class MapSpotMarkerWidget extends StatelessWidget {
  final SpotModel spot;
  final bool isSelected;
  final VoidCallback? onTap;

  const MapSpotMarkerWidget({
    super.key,
    required this.spot,
    this.isSelected = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    const primaryPurple = Color(0xFF4F46E5);
    final surfaceColor = AppColors.surfaceOf(context);
    final textPrimaryColor = AppColors.textPrimaryOf(context);

    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            padding: const EdgeInsets.all(9),
            decoration: BoxDecoration(
              color: isSelected ? primaryPurple : surfaceColor,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: (isSelected ? primaryPurple : Colors.black)
                      .withValues(alpha: 0.25),
                  blurRadius: isSelected ? 16 : 8,
                  offset: const Offset(0, 4),
                ),
              ],
              border: Border.all(
                color: isSelected ? Colors.white : primaryPurple,
                width: 2.5,
              ),
            ),
            child: Icon(
              _getSpotIcon(spot.category),
              size: isSelected ? 24 : 18,
              color: isSelected ? Colors.white : primaryPurple,
            ),
          ),
          const SizedBox(height: 3),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2.5),
            decoration: BoxDecoration(
              color: surfaceColor.withValues(alpha: 0.95),
              borderRadius: BorderRadius.circular(6),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.08),
                  blurRadius: 4,
                ),
              ],
            ),
            child: Text(
              spot.name,
              style: TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.w700,
                color: textPrimaryColor,
              ),
            ),
          ),
        ],
      ),
    );
  }

  IconData _getSpotIcon(String category) {
    final cat = category.toLowerCase();
    if (cat.contains('library') || cat.contains('perpustakaan')) {
      return Icons.local_library_rounded;
    } else if (cat.contains('coworking') || cat.contains('hub')) {
      return Icons.laptop_chromebook_rounded;
    } else if (cat.contains('cafe') || cat.contains('roastery')) {
      return Icons.local_cafe_rounded;
    } else if (cat.contains('event') || cat.contains('meet')) {
      return Icons.event_seat_rounded;
    } else if (cat.contains('studio')) {
      return Icons.palette_rounded;
    }
    return Icons.school_rounded;
  }
}
