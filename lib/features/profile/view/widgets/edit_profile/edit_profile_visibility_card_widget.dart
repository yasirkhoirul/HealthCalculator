import 'package:flutter/material.dart';
import '../../../../../core/constant/app_colors.dart';

/// Card Visibilitas di Peta Kampus
/// Mengontrol apakah spot belajar pengguna ditampilkan ke teman dalam radius sekitar.
class EditProfileVisibilityCardWidget extends StatelessWidget {
  final bool isVisible;
  final ValueChanged<bool> onToggle;
  final String locationDescription;

  const EditProfileVisibilityCardWidget({
    super.key,
    required this.isVisible,
    required this.onToggle,
    this.locationDescription =
        'Teman dalam radius 2 km dapat melihat kamu sedang aktif belajar di Perpustakaan Pusat.',
  });

  @override
  Widget build(BuildContext context) {
    final surfaceColor = AppColors.surfaceOf(context);
    final borderColor = AppColors.borderOf(context);
    final textPrimaryColor = AppColors.textPrimaryOf(context);
    final textSecondaryColor = AppColors.textSecondaryOf(context);
    final primaryColor = AppColors.primaryOf(context);
    final primaryBorderColor = AppColors.primaryBorderOf(context);
    final successLightColor = AppColors.isDark(context)
        ? AppColors.darkSuccessLight
        : AppColors.successLight;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
      decoration: BoxDecoration(
        color: surfaceColor,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: borderColor),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Row Header: Radar Icon + Title + Switch Toggle
          Row(
            children: [
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: successLightColor,
                  shape: BoxShape.circle,
                ),
                child: const Center(
                  child: Icon(
                    Icons.radar_rounded,
                    color: AppColors.successGreen,
                    size: 20,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  'Visibilitas di Peta Kampus',
                  style: TextStyle(
                    fontSize: 14.5,
                    fontWeight: FontWeight.w800,
                    color: textPrimaryColor,
                    letterSpacing: -0.2,
                  ),
                ),
              ),
              Switch.adaptive(
                value: isVisible,
                onChanged: onToggle,
                activeThumbColor: primaryColor,
                activeTrackColor: primaryBorderColor,
                inactiveThumbColor: AppColors.surfaceOf(context),
                inactiveTrackColor: borderColor,
              ),
            ],
          ),

          const SizedBox(height: 6),

          // Subtitle deskripsi radius
          Text(
            locationDescription,
            style: TextStyle(
              fontSize: 12,
              color: textSecondaryColor,
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }
}
