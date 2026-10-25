import 'package:flutter/material.dart';
import '../../../../../core/constant/app_colors.dart';

/// Section Aktivitas Belajar Semester Ini
/// Berisi indikator status sesi aktif dan 3 kartu metrik statistik fokus belajar.
class EditProfileStatsRowWidget extends StatelessWidget {
  final double totalFocusHours;
  final int completedSessions;
  final int studyBuddiesCount;
  final bool isSessionActive;

  const EditProfileStatsRowWidget({
    super.key,
    required this.totalFocusHours,
    required this.completedSessions,
    required this.studyBuddiesCount,
    this.isSessionActive = true,
  });

  @override
  Widget build(BuildContext context) {
    // Format total jam (contoh: 48 Jam atau 48.5 Jam)
    final hoursText = totalFocusHours % 1 == 0
        ? '${totalFocusHours.toInt()} Jam'
        : '${totalFocusHours.toStringAsFixed(1)} Jam';

    final textSecondaryColor = AppColors.textSecondaryOf(context);
    final primaryColor = AppColors.primaryOf(context);
    final primaryLightColor = AppColors.primaryLightOf(context);
    final successLightColor = AppColors.isDark(context)
        ? AppColors.darkSuccessLight
        : AppColors.successLight;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Section Header Row
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'AKTIVITAS BELAJAR SEMESTER INI',
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w800,
                color: textSecondaryColor,
                letterSpacing: 0.6,
              ),
            ),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 7,
                  height: 7,
                  decoration: BoxDecoration(
                    color: isSessionActive ? AppColors.successGreen : AppColors.textMutedOf(context),
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 5),
                Text(
                  isSessionActive ? 'Aktif Sesi' : 'Tidak Aktif',
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    color: isSessionActive ? AppColors.successGreen : textSecondaryColor,
                  ),
                ),
              ],
            ),
          ],
        ),

        const SizedBox(height: 10),

        // 3 Metric Cards
        Row(
          children: [
            Expanded(
              child: _buildMetricCard(
                context: context,
                icon: Icons.access_time_filled_rounded,
                iconColor: AppColors.successGreen,
                iconBgColor: successLightColor,
                value: hoursText,
                label: 'Total Belajar',
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: _buildMetricCard(
                context: context,
                icon: Icons.groups_rounded,
                iconColor: primaryColor,
                iconBgColor: primaryLightColor,
                value: '$completedSessions Sesi',
                label: 'Bareng Teman',
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: _buildMetricCard(
                context: context,
                icon: Icons.diamond_rounded,
                iconColor: primaryColor,
                iconBgColor: primaryLightColor,
                value: '$studyBuddiesCount',
                label: 'Study Buddy',
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildMetricCard({
    required BuildContext context,
    required IconData icon,
    required Color iconColor,
    required Color iconBgColor,
    required String value,
    required String label,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 8),
      decoration: BoxDecoration(
        color: AppColors.surfaceOf(context),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.borderOf(context)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 34,
            height: 34,
            decoration: BoxDecoration(
              color: iconBgColor,
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Icon(icon, color: iconColor, size: 18),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: TextStyle(
              fontSize: 15.5,
              fontWeight: FontWeight.w800,
              color: AppColors.textPrimaryOf(context),
              letterSpacing: -0.2,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            label,
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w500,
              color: AppColors.textSecondaryOf(context),
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
