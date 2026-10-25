import 'package:flutter/material.dart';
import '../../../../core/constant/app_colors.dart';

/// Widget Kartu Statistik Semester Mahasiswa pada Halaman Profil Utama
/// Menampilkan Total Jam Belajar, Sesi Bareng Teman, dan Study Buddy.
class ProfileStatsWidget extends StatelessWidget {
  final double totalFocusHours;
  final int completedSessions;
  final int connectedBuddies;

  const ProfileStatsWidget({
    super.key,
    required this.totalFocusHours,
    required this.completedSessions,
    required this.connectedBuddies,
  });

  @override
  Widget build(BuildContext context) {
    final hoursText = totalFocusHours % 1 == 0
        ? '${totalFocusHours.toInt()} Jam'
        : '${totalFocusHours.toStringAsFixed(1)} Jam';

    final surfaceColor = AppColors.surfaceOf(context);
    final borderColor = AppColors.borderOf(context);
    final primaryColor = AppColors.primaryOf(context);
    final primaryLightColor = AppColors.primaryLightOf(context);
    final textPrimaryColor = AppColors.textPrimaryOf(context);
    final textSecondaryColor = AppColors.textSecondaryOf(context);
    final successLightColor = AppColors.isDark(context)
        ? AppColors.darkSuccessLight
        : AppColors.successLight;

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
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
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildStatItem(
            icon: Icons.access_time_filled_rounded,
            iconColor: AppColors.successGreen,
            iconBg: successLightColor,
            value: hoursText,
            label: 'Total Belajar',
            textPrimaryColor: textPrimaryColor,
            textSecondaryColor: textSecondaryColor,
          ),
          _buildDivider(borderColor),
          _buildStatItem(
            icon: Icons.groups_rounded,
            iconColor: primaryColor,
            iconBg: primaryLightColor,
            value: '$completedSessions Sesi',
            label: 'Bareng Teman',
            textPrimaryColor: textPrimaryColor,
            textSecondaryColor: textSecondaryColor,
          ),
          _buildDivider(borderColor),
          _buildStatItem(
            icon: Icons.diamond_rounded,
            iconColor: primaryColor,
            iconBg: primaryLightColor,
            value: '$connectedBuddies',
            label: 'Study Buddy',
            textPrimaryColor: textPrimaryColor,
            textSecondaryColor: textSecondaryColor,
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem({
    required IconData icon,
    required Color iconColor,
    required Color iconBg,
    required String value,
    required String label,
    required Color textPrimaryColor,
    required Color textSecondaryColor,
  }) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 34,
          height: 34,
          decoration: BoxDecoration(
            color: iconBg,
            shape: BoxShape.circle,
          ),
          child: Center(
            child: Icon(icon, color: iconColor, size: 17),
          ),
        ),
        const SizedBox(height: 6),
        Text(
          value,
          style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w800,
            color: textPrimaryColor,
            letterSpacing: -0.2,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          label,
          style: TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w500,
            color: textSecondaryColor,
          ),
        ),
      ],
    );
  }

  Widget _buildDivider(Color color) {
    return Container(
      width: 1,
      height: 38,
      color: color,
    );
  }
}
