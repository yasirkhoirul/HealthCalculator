import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/constant/app_colors.dart';
import '../viewmodels/theme_viewmodel.dart';

/// Section: TAMPILAN & TEMA (Dark Mode, Light Mode, & Sinkronisasi Sistem)
/// Memungkinkan pengguna memilih tema visual: Otomatis (Ikuti Sistem), Terang, atau Gelap.
class SettingsThemeSectionWidget extends StatelessWidget {
  const SettingsThemeSectionWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final themeVm = context.watch<ThemeViewModel>();
    final isSystemDark =
        MediaQuery.platformBrightnessOf(context) == Brightness.dark;

    final primaryColor = AppColors.primaryOf(context);
    final surfaceColor = AppColors.surfaceOf(context);
    final borderColor = AppColors.borderOf(context);
    final borderSubtleColor = AppColors.borderSubtleOf(context);
    final textPrimaryColor = AppColors.textPrimaryOf(context);
    final textSecondaryColor = AppColors.textSecondaryOf(context);
    final cardSubtleColor = AppColors.cardSubtleBgOf(context);
    final primaryLightColor = AppColors.primaryLightOf(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Header Section
        Row(
          children: [
            Icon(
              Icons.palette_outlined,
              size: 17,
              color: primaryColor,
            ),
            const SizedBox(width: 8),
            Text(
              'TAMPILAN & TEMA',
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
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
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
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Title & Subtitle Info
              Text(
                'Mode Tampilan Aplikasi',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: textPrimaryColor,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'Sesuaikan pencahayaan layar untuk kenyamanan belajar atau sinkronkan dengan sistem HP.',
                style: TextStyle(
                  fontSize: 12,
                  color: textSecondaryColor,
                  height: 1.35,
                ),
              ),
              const SizedBox(height: 14),

              // 3 Pilihan Tema: Sistem, Terang, Gelap
              Row(
                children: [
                  // 1. Opsi: Sistem (Otomatis)
                  Expanded(
                    child: _buildThemeOptionCard(
                      context: context,
                      title: 'Sistem',
                      subtitle: 'Otomatis',
                      icon: Icons.brightness_auto_rounded,
                      isSelected: themeVm.isSystemMode,
                      primaryColor: primaryColor,
                      borderColor: borderColor,
                      cardSubtleColor: cardSubtleColor,
                      primaryLightColor: primaryLightColor,
                      textPrimaryColor: textPrimaryColor,
                      textSecondaryColor: textSecondaryColor,
                      onTap: () => themeVm.setThemeMode(ThemeMode.system),
                    ),
                  ),
                  const SizedBox(width: 8),

                  // 2. Opsi: Terang (Light)
                  Expanded(
                    child: _buildThemeOptionCard(
                      context: context,
                      title: 'Terang',
                      subtitle: 'Siang Hari',
                      icon: Icons.light_mode_rounded,
                      isSelected: themeVm.isLightMode,
                      primaryColor: primaryColor,
                      borderColor: borderColor,
                      cardSubtleColor: cardSubtleColor,
                      primaryLightColor: primaryLightColor,
                      textPrimaryColor: textPrimaryColor,
                      textSecondaryColor: textSecondaryColor,
                      onTap: () => themeVm.setThemeMode(ThemeMode.light),
                    ),
                  ),
                  const SizedBox(width: 8),

                  // 3. Opsi: Gelap (Dark)
                  Expanded(
                    child: _buildThemeOptionCard(
                      context: context,
                      title: 'Gelap',
                      subtitle: 'Malam Hari',
                      icon: Icons.dark_mode_rounded,
                      isSelected: themeVm.isDarkMode,
                      primaryColor: primaryColor,
                      borderColor: borderColor,
                      cardSubtleColor: cardSubtleColor,
                      primaryLightColor: primaryLightColor,
                      textPrimaryColor: textPrimaryColor,
                      textSecondaryColor: textSecondaryColor,
                      onTap: () => themeVm.setThemeMode(ThemeMode.dark),
                    ),
                  ),
                ],
              ),

              Padding(
                padding: const EdgeInsets.symmetric(vertical: 14),
                child: Divider(
                  height: 1,
                  thickness: 1,
                  color: borderSubtleColor,
                ),
              ),

              // Status Sinkronisasi
              Row(
                children: [
                  Container(
                    width: 32,
                    height: 32,
                    decoration: BoxDecoration(
                      color: themeVm.isSystemMode
                          ? (AppColors.isDark(context)
                              ? AppColors.darkSuccessLight
                              : AppColors.successLight)
                          : primaryLightColor,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Center(
                      child: Icon(
                        themeVm.isSystemMode
                            ? Icons.sync_rounded
                            : (themeVm.isDarkMode
                                ? Icons.nightlight_round
                                : Icons.wb_sunny_rounded),
                        size: 17,
                        color: themeVm.isSystemMode
                            ? AppColors.successGreen
                            : primaryColor,
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          themeVm.isSystemMode
                              ? 'Tersinkronisasi dengan Perangkat'
                              : (themeVm.isDarkMode
                                  ? 'Mode Gelap Aktif Manual'
                                  : 'Mode Terang Aktif Manual'),
                          style: TextStyle(
                            fontSize: 12.5,
                            fontWeight: FontWeight.w700,
                            color: textPrimaryColor,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          themeVm.isSystemMode
                              ? 'Tema HP saat ini: ${isSystemDark ? "Gelap (Dark)" : "Terang (Light)"}'
                              : 'Tidak mengikuti perubahan tema sistem HP.',
                          style: TextStyle(
                            fontSize: 11,
                            color: textSecondaryColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                  if (themeVm.isSystemMode)
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 3.5,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.isDark(context)
                            ? AppColors.darkSuccessLight
                            : AppColors.successLight,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.check_circle_rounded,
                            size: 13,
                            color: AppColors.successGreen,
                          ),
                          SizedBox(width: 4),
                          Text(
                            'Sinkron',
                            style: TextStyle(
                              fontSize: 10.5,
                              fontWeight: FontWeight.w700,
                              color: AppColors.successGreen,
                            ),
                          ),
                        ],
                      ),
                    ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildThemeOptionCard({
    required BuildContext context,
    required String title,
    required String subtitle,
    required IconData icon,
    required bool isSelected,
    required Color primaryColor,
    required Color borderColor,
    required Color cardSubtleColor,
    required Color primaryLightColor,
    required Color textPrimaryColor,
    required Color textSecondaryColor,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeInOut,
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
        decoration: BoxDecoration(
          color: isSelected ? primaryLightColor : cardSubtleColor,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: isSelected ? primaryColor : borderColor,
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Icon(
                  icon,
                  size: 20,
                  color: isSelected ? primaryColor : textSecondaryColor,
                ),
                if (isSelected)
                  Icon(
                    Icons.check_circle_rounded,
                    size: 16,
                    color: primaryColor,
                  )
                else
                  const SizedBox(width: 16, height: 16),
              ],
            ),
            const SizedBox(height: 10),
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                title,
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: isSelected ? FontWeight.w800 : FontWeight.w600,
                  color: isSelected ? primaryColor : textPrimaryColor,
                ),
              ),
            ),
            const SizedBox(height: 2),
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                subtitle,
                style: TextStyle(
                  fontSize: 10,
                  color: textSecondaryColor,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
