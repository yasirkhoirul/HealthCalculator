import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../../../core/constant/app_colors.dart';
import '../../../../router/app_routes.dart';
import '../viewmodels/profile_viewmodel.dart';
import '../widgets/profile_header_widget.dart';
import '../widgets/profile_stats_widget.dart';

/// Halaman Profil Utama (Tab 4 di Bottom Navigation Bar)
/// Bersifat Read-Only / Display informasi mahasiswa.
/// Memuat AppBar dengan tombol Pengaturan (Gear), Header Mahasiswa, Tombol Edit Profil,
/// Ringkasan Statistik, Bio Aktif, Minat Belajar, dan Status Radar Peta.
class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    final profileVm = context.watch<ProfileViewModel>();
    final user = profileVm.user;

    final surfaceColor = AppColors.surfaceOf(context);
    final borderColor = AppColors.borderOf(context);
    final borderSubtleColor = AppColors.borderSubtleOf(context);
    final textPrimaryColor = AppColors.textPrimaryOf(context);
    final textSecondaryColor = AppColors.textSecondaryOf(context);
    final textBodyColor = AppColors.textBodyOf(context);
    final primaryColor = AppColors.primaryOf(context);
    final cardSubtleColor = AppColors.cardSubtleBgOf(context);

    return Scaffold(
      backgroundColor: AppColors.backgroundOf(context),
      appBar: AppBar(
        backgroundColor: surfaceColor,
        elevation: 0,
        scrolledUnderElevation: 0.5,
        title: Text(
          'Profil',
          style: TextStyle(
            color: textPrimaryColor,
            fontSize: 20,
            fontWeight: FontWeight.w800,
            letterSpacing: -0.3,
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(
              Icons.settings_outlined,
              color: primaryColor,
              size: 24,
            ),
            tooltip: 'Pengaturan Sistem',
            onPressed: () => context.pushNamed(AppRoutes.settings),
          ),
          const SizedBox(width: 8),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Container(color: borderSubtleColor, height: 1),
        ),
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // 1. Header Info Pengguna + Tombol Aksi "Edit Profil"
            ProfileHeaderWidget(user: user),

            const SizedBox(height: 18),

            // 2. Ringkasan Statistik Belajar Semester Ini
            ProfileStatsWidget(
              totalFocusHours: user.totalFocusHours,
              completedSessions: user.completedSessions,
              connectedBuddies: user.connectedBuddies,
            ),

            const SizedBox(height: 18),

            // 3. Bio & Status Radar Aktif (Display Read-Only)
            Container(
              padding: const EdgeInsets.all(18),
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
                  Row(
                    children: [
                      Icon(
                        Icons.chat_bubble_outline_rounded,
                        size: 18,
                        color: primaryColor,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'Bio & Status Radar',
                        style: TextStyle(
                          fontSize: 13.5,
                          fontWeight: FontWeight.w800,
                          color: textPrimaryColor,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: cardSubtleColor,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: borderSubtleColor),
                    ),
                    child: Text(
                      user.bio.isNotEmpty
                          ? user.bio
                          : 'Belum ada status radar aktif.',
                      style: TextStyle(
                        fontSize: 13,
                        color: textBodyColor,
                        height: 1.45,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 18),

            // 4. Minat Belajar Aktif (Chips Display Read-Only)
            Container(
              padding: const EdgeInsets.all(18),
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
                  Row(
                    children: [
                      Icon(
                        Icons.auto_stories_outlined,
                        size: 18,
                        color: primaryColor,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'Topik / Minat Belajar Aktif',
                        style: TextStyle(
                          fontSize: 13.5,
                          fontWeight: FontWeight.w800,
                          color: textPrimaryColor,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      for (final interest in user.interests)
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 14,
                            vertical: 7,
                          ),
                          decoration: BoxDecoration(
                            color: primaryColor,
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: [
                              BoxShadow(
                                color: primaryColor.withValues(alpha: 0.2),
                                blurRadius: 4,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: Text(
                            interest,
                            style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w700,
                              color: Colors.white,
                            ),
                          ),
                        ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 18),

            // 5. Status Visibilitas di Radar Peta Saat Ini
            Container(
              padding: const EdgeInsets.all(18),
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
                children: [
                  Container(
                    width: 38,
                    height: 38,
                    decoration: BoxDecoration(
                      color: user.isMapVisible
                          ? (AppColors.isDark(context)
                              ? AppColors.darkSuccessLight
                              : AppColors.successLight)
                          : cardSubtleColor,
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: Icon(
                        Icons.radar_rounded,
                        color: user.isMapVisible
                            ? AppColors.successGreen
                            : AppColors.textMutedOf(context),
                        size: 20,
                      ),
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          user.isMapVisible
                              ? 'Radar Kampus Aktif (Radius 2 km)'
                              : 'Mode Hantu (Lokasi Tersembunyi)',
                          style: TextStyle(
                            fontSize: 13.5,
                            fontWeight: FontWeight.w800,
                            color: textPrimaryColor,
                          ),
                        ),
                        const SizedBox(height: 3),
                        Text(
                          user.isMapVisible
                              ? 'Teman sekitar dapat melihat posisimu di Perpustakaan Pusat.'
                              : 'Lokasimu saat ini tidak ditampilkan di peta kampus.',
                          style: TextStyle(
                            fontSize: 11.5,
                            color: textSecondaryColor,
                            height: 1.3,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}
