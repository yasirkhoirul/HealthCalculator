import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../../../core/constant/app_base_state.dart';
import '../../../../core/constant/app_colors.dart';
import '../../../../core/di/injection.dart';
import '../../../../router/app_routes.dart';
import '../viewmodels/user_detail_viewmodel.dart';
import '../widgets/user_action_button_widget.dart';

/// Halaman Detail Profil Pengguna Lain (`UserDetailPage`).
/// Menampilkan informasi profil lengkap mahasiswa, aktivitas belajar, dan tombol aksi pertemanan.
class UserDetailPage extends StatelessWidget {
  final String userId;

  const UserDetailPage({
    super.key,
    required this.userId,
  });

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<UserDetailViewModel>(
      create: (_) => locator<UserDetailViewModel>()..loadUserDetail(userId),
      child: _UserDetailContentView(userId: userId),
    );
  }
}

class _UserDetailContentView extends StatelessWidget {
  final String userId;

  const _UserDetailContentView({required this.userId});

  void _navigateToChat(BuildContext context) {
    context.pushNamed(
      AppRoutes.chatDetail,
      pathParameters: {'userId': userId},
    );
  }

  void _showInviteBottomSheet(BuildContext context, String userName) {
    final surfaceColor = AppColors.surfaceOf(context);
    final textPrimaryColor = AppColors.textPrimaryOf(context);
    final textSecondaryColor = AppColors.textSecondaryOf(context);
    final primaryColor = AppColors.primaryOf(context);

    showModalBottomSheet(
      context: context,
      backgroundColor: surfaceColor,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (bottomSheetContext) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: AppColors.borderOf(context),
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
                const SizedBox(height: 18),
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: AppColors.studentAvatarPurple.withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: const Icon(
                        Icons.bolt_rounded,
                        color: AppColors.studentAvatarPurple,
                        size: 24,
                      ),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Ajak Belajar Bareng',
                            style: TextStyle(
                              fontSize: 16.5,
                              fontWeight: FontWeight.w800,
                              color: textPrimaryColor,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            'Kirim knock notifikasi langsung ke $userName',
                            style: TextStyle(
                              fontSize: 12.5,
                              color: textSecondaryColor,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Text(
                  'Pilih Spot Pertemuan:',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: textPrimaryColor,
                  ),
                ),
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                  decoration: BoxDecoration(
                    color: AppColors.cardSubtleBgOf(context),
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: AppColors.borderOf(context)),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.place_rounded, color: primaryColor, size: 20),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          'Main Campus Library Floor 2 (Lt. 2)',
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: textPrimaryColor,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pop(bottomSheetContext);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Knock request berhasil dikirim ke $userName!'),
                          backgroundColor: primaryColor,
                          duration: const Duration(seconds: 2),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: primaryColor,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                    child: const Text(
                      'Kirim Permintaan Belajar',
                      style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final detailViewModel = context.watch<UserDetailViewModel>();
    final userState = detailViewModel.userState;

    final surfaceColor = AppColors.surfaceOf(context);
    final borderColor = AppColors.borderOf(context);
    final textPrimaryColor = AppColors.textPrimaryOf(context);
    final textSecondaryColor = AppColors.textSecondaryOf(context);
    final textMutedColor = AppColors.textMutedOf(context);
    final primaryColor = AppColors.primaryOf(context);
    final primaryLightColor = AppColors.primaryLightOf(context);
    final cardSubtleColor = AppColors.cardSubtleBgOf(context);

    return Scaffold(
      backgroundColor: AppColors.backgroundOf(context),
      appBar: AppBar(
        backgroundColor: surfaceColor,
        elevation: 0,
        scrolledUnderElevation: 1,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new_rounded, color: textPrimaryColor, size: 20),
          onPressed: () => context.pop(),
        ),
        title: Text(
          'Profil Mahasiswa',
          style: TextStyle(
            fontSize: 17.5,
            fontWeight: FontWeight.w800,
            color: textPrimaryColor,
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.share_outlined, color: textPrimaryColor, size: 21),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Tautan profil disalin ke clipboard.'),
                  duration: Duration(seconds: 1),
                ),
              );
            },
          ),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Container(color: borderColor, height: 0.8),
        ),
      ),
      body: switch (userState) {
        AppStateLoading() => const Center(
            child: CircularProgressIndicator(),
          ),
        AppStateError(:final message) => Center(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.error_outline_rounded, size: 42, color: AppColors.error),
                  const SizedBox(height: 10),
                  Text(
                    message,
                    textAlign: TextAlign.center,
                    style: TextStyle(color: textSecondaryColor, fontSize: 13.5),
                  ),
                  const SizedBox(height: 14),
                  OutlinedButton(
                    onPressed: () => detailViewModel.loadUserDetail(userId),
                    child: const Text('Coba Lagi'),
                  ),
                ],
              ),
            ),
          ),
        AppStateSuccess(:final data) => data == null
            ? const Center(child: Text('Data profil tidak ditemukan.'))
            : ListView(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                children: [
                  // 1. Header Card (Avatar + Online Ring + Nama + Verified + Kampus)
                  Container(
                    padding: const EdgeInsets.all(18),
                    decoration: BoxDecoration(
                      color: surfaceColor,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: borderColor),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.04),
                          blurRadius: 10,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        // Avatar Bulat Besar
                        Stack(
                          alignment: Alignment.center,
                          children: [
                            Container(
                              width: 82,
                              height: 82,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                gradient: LinearGradient(
                                  colors: [primaryColor, AppColors.studentAvatarPurple],
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: primaryColor.withValues(alpha: 0.25),
                                    blurRadius: 12,
                                    offset: const Offset(0, 4),
                                  ),
                                ],
                              ),
                              child: Center(
                                child: Text(
                                  data.name.isNotEmpty
                                      ? data.name
                                          .split(' ')
                                          .take(2)
                                          .map((e) => e[0])
                                          .join()
                                          .toUpperCase()
                                      : 'SM',
                                  style: const TextStyle(
                                    fontSize: 28,
                                    fontWeight: FontWeight.w800,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                            Positioned(
                              right: 2,
                              bottom: 2,
                              child: Container(
                                width: 18,
                                height: 18,
                                decoration: BoxDecoration(
                                  color: AppColors.activeGreen,
                                  shape: BoxShape.circle,
                                  border: Border.all(color: surfaceColor, width: 2.5),
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 14),

                        // Nama + Badge Verified SSO
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Flexible(
                              child: Text(
                                data.name,
                                style: TextStyle(
                                  fontSize: 19,
                                  fontWeight: FontWeight.w800,
                                  color: textPrimaryColor,
                                ),
                                textAlign: TextAlign.center,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            const SizedBox(width: 6),
                            const Icon(
                              Icons.verified_rounded,
                              size: 18,
                              color: AppColors.primary,
                            ),
                          ],
                        ),
                        const SizedBox(height: 3),
                        Text(
                          '${data.username} • NIM ${data.nim}',
                          style: TextStyle(
                            fontSize: 12.5,
                            color: textSecondaryColor,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: primaryLightColor,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            '${data.major} • ${data.campus}',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: primaryColor,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),

                        const SizedBox(height: 18),

                        // 2. Aksi Tombol Pertemanan & Chat
                        UserActionButtonWidget(
                          friendshipStatus: detailViewModel.friendshipStatus,
                          onToggleFriendship: () {
                            detailViewModel.toggleFriendship(userId);
                          },
                          onSendMessage: () => _navigateToChat(context),
                          onInviteStudy: () => _showInviteBottomSheet(context, data.name),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 16),

                  // 3. Aktivitas Belajar (Stats Row Card)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                    decoration: BoxDecoration(
                      color: surfaceColor,
                      borderRadius: BorderRadius.circular(18),
                      border: Border.all(color: borderColor),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        _buildStatItem(
                          context: context,
                          icon: Icons.timer_outlined,
                          value: '${data.totalFocusHours} Jam',
                          label: 'Total Belajar',
                          primaryColor: primaryColor,
                        ),
                        _buildDivider(borderColor),
                        _buildStatItem(
                          context: context,
                          icon: Icons.task_alt_rounded,
                          value: '${data.completedSessions}',
                          label: 'Sesi Selesai',
                          primaryColor: AppColors.successGreen,
                        ),
                        _buildDivider(borderColor),
                        _buildStatItem(
                          context: context,
                          icon: Icons.people_outline_rounded,
                          value: '${data.connectedBuddies}',
                          label: 'Study Buddy',
                          primaryColor: AppColors.studentAvatarPurple,
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 16),

                  // 4. Bio & Radar Status Card
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: surfaceColor,
                      borderRadius: BorderRadius.circular(18),
                      border: Border.all(color: borderColor),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(Icons.notes_rounded, size: 18, color: primaryColor),
                            const SizedBox(width: 8),
                            Text(
                              'Bio & Status Belajar',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w700,
                                color: textPrimaryColor,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        Text(
                          data.bio,
                          style: TextStyle(
                            fontSize: 13,
                            color: AppColors.textBodyOf(context),
                            height: 1.45,
                          ),
                        ),
                        const SizedBox(height: 14),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                          decoration: BoxDecoration(
                            color: cardSubtleColor,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: borderColor),
                          ),
                          child: Row(
                            children: [
                              Container(
                                width: 9,
                                height: 9,
                                decoration: const BoxDecoration(
                                  color: AppColors.activeGreen,
                                  shape: BoxShape.circle,
                                ),
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  'Terlihat aktif di radar peta kampus',
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                    color: textSecondaryColor,
                                  ),
                                ),
                              ),
                              Icon(
                                Icons.radar_rounded,
                                size: 18,
                                color: primaryColor,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 16),

                  // 5. Minat Belajar Aktif (Chips Display)
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: surfaceColor,
                      borderRadius: BorderRadius.circular(18),
                      border: Border.all(color: borderColor),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(Icons.interests_outlined, size: 18, color: primaryColor),
                            const SizedBox(width: 8),
                            Text(
                              'Minat & Topik Belajar',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w700,
                                color: textPrimaryColor,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: data.interests.map((interest) {
                            return Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 6,
                              ),
                              decoration: BoxDecoration(
                                color: primaryLightColor,
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(color: borderColor),
                              ),
                              child: Text(
                                interest,
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                  color: primaryColor,
                                ),
                              ),
                            );
                          }).toList(),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 16),

                  // 6. Lokasi Spot Belajar Terakhir
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: surfaceColor,
                      borderRadius: BorderRadius.circular(18),
                      border: Border.all(color: borderColor),
                    ),
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: primaryLightColor,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Icon(
                            Icons.location_on_rounded,
                            color: primaryColor,
                            size: 22,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Main Campus Library Floor 2',
                                style: TextStyle(
                                  fontSize: 13.5,
                                  fontWeight: FontWeight.w700,
                                  color: textPrimaryColor,
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                '120m dari lokasi Anda • Lantai 2 Sayap Timur',
                                style: TextStyle(
                                  fontSize: 11.5,
                                  color: textMutedColor,
                                ),
                              ),
                            ],
                          ),
                        ),
                        TextButton(
                          onPressed: () {
                            context.pushNamed(AppRoutes.map);
                          },
                          child: Text(
                            'Peta',
                            style: TextStyle(
                              fontSize: 12.5,
                              fontWeight: FontWeight.w700,
                              color: primaryColor,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 24),
                ],
              ),
        _ => const SizedBox.shrink(),
      },
    );
  }

  Widget _buildStatItem({
    required BuildContext context,
    required IconData icon,
    required String value,
    required String label,
    required Color primaryColor,
  }) {
    return Column(
      children: [
        Icon(icon, size: 20, color: primaryColor),
        const SizedBox(height: 6),
        Text(
          value,
          style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w800,
            color: AppColors.textPrimaryOf(context),
          ),
        ),
        const SizedBox(height: 2),
        Text(
          label,
          style: TextStyle(
            fontSize: 11,
            color: AppColors.textSecondaryOf(context),
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  Widget _buildDivider(Color borderColor) {
    return Container(
      height: 36,
      width: 1,
      color: borderColor,
    );
  }
}
