import 'package:flutter/material.dart';
import '../../../../core/constant/app_colors.dart';

/// Section: BANTUAN & DUKUNGAN
/// Berisi Pusat Bantuan StudyMap, Laporkan Bug, Tentang StudyMap (versi build),
/// tombol Outlined "Keluar Akun", serta footer teks StudyMap.
class SettingsSupportSectionWidget extends StatelessWidget {
  final VoidCallback? onHelpCenterTap;
  final VoidCallback? onReportBugTap;
  final VoidCallback? onAboutTap;
  final VoidCallback? onLogoutTap;

  const SettingsSupportSectionWidget({
    super.key,
    this.onHelpCenterTap,
    this.onReportBugTap,
    this.onAboutTap,
    this.onLogoutTap,
  });

  @override
  Widget build(BuildContext context) {
    final primaryColor = AppColors.primaryOf(context);
    final surfaceColor = AppColors.surfaceOf(context);
    final borderColor = AppColors.borderOf(context);
    final borderSubtleColor = AppColors.borderSubtleOf(context);
    final textPrimaryColor = AppColors.textPrimaryOf(context);
    final textSecondaryColor = AppColors.textSecondaryOf(context);
    final textMutedColor = AppColors.textMutedOf(context);
    final textBodyColor = AppColors.textBodyOf(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Header Section
        Row(
          children: [
            Icon(
              Icons.help_outline_rounded,
              size: 17,
              color: primaryColor,
            ),
            const SizedBox(width: 8),
            Text(
              'BANTUAN & DUKUNGAN',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w800,
                color: primaryColor,
                letterSpacing: 0.5,
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),

        // Card Container
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            color: surfaceColor,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: borderColor,
              width: 1.2,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.02),
                blurRadius: 10,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: Column(
            children: [
              // 1. Pusat Bantuan StudyMap
              InkWell(
                onTap: onHelpCenterTap,
                borderRadius: BorderRadius.circular(10),
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  child: Row(
                    children: [
                      Icon(
                        Icons.support_outlined,
                        size: 20,
                        color: textBodyColor,
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Text(
                          'Pusat Bantuan StudyMap',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                            color: textPrimaryColor,
                          ),
                        ),
                      ),
                      Icon(
                        Icons.open_in_new_rounded,
                        size: 18,
                        color: textSecondaryColor,
                      ),
                    ],
                  ),
                ),
              ),

              Divider(
                height: 1,
                thickness: 1,
                color: borderSubtleColor,
              ),

              // 2. Laporkan Bug
              InkWell(
                onTap: onReportBugTap,
                borderRadius: BorderRadius.circular(10),
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  child: Row(
                    children: [
                      Icon(
                        Icons.bug_report_outlined,
                        size: 20,
                        color: textBodyColor,
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Text(
                          'Laporkan Bug',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                            color: textPrimaryColor,
                          ),
                        ),
                      ),
                      Icon(
                        Icons.chevron_right_rounded,
                        size: 18,
                        color: textMutedColor,
                      ),
                    ],
                  ),
                ),
              ),

              Divider(
                height: 1,
                thickness: 1,
                color: borderSubtleColor,
              ),

              // 3. Tentang StudyMap
              InkWell(
                onTap: onAboutTap,
                borderRadius: BorderRadius.circular(10),
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  child: Row(
                    children: [
                      Icon(
                        Icons.info_outline_rounded,
                        size: 20,
                        color: textBodyColor,
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Text(
                          'Tentang StudyMap',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                            color: textPrimaryColor,
                          ),
                        ),
                      ),
                      Text(
                        'v2.4 (Build 842)',
                        style: TextStyle(
                          fontSize: 12.5,
                          fontWeight: FontWeight.w500,
                          color: textSecondaryColor,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: 20),

        // Tombol Outlined "Keluar Akun"
        OutlinedButton(
          onPressed: onLogoutTap ??
              () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Aksi Keluar Akun dipilih'),
                    duration: Duration(seconds: 2),
                  ),
                );
              },
          style: OutlinedButton.styleFrom(
            backgroundColor: surfaceColor,
            side: BorderSide(
              color: AppColors.error.withValues(alpha: 0.3),
              width: 1.3,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(24),
            ),
            padding: const EdgeInsets.symmetric(vertical: 13),
            elevation: 0,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              Icon(
                Icons.logout_rounded,
                size: 18,
                color: AppColors.errorDark,
              ),
              SizedBox(width: 8),
              Text(
                'Keluar Akun',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: AppColors.errorDark,
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: 16),

        // Footer Teks StudyMap
        Text(
          'StudyMap • Universitas & Komunitas Belajar Mandiri',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 11.5,
            fontWeight: FontWeight.w500,
            color: textMutedColor,
          ),
        ),
        const SizedBox(height: 10),
      ],
    );
  }
}
