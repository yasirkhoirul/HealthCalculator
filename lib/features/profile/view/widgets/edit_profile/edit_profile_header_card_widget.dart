import 'package:flutter/material.dart';
import '../../../../../core/constant/app_colors.dart';

/// Card Profil Atas
/// Menampilkan Avatar Mahasiswa, status online, badge verified, dan 3 tombol aksi cepat.
class EditProfileHeaderCardWidget extends StatelessWidget {
  final String name;
  final String username;
  final String campusBranch;
  final String? photoUrl;
  final VoidCallback? onGalleryTap;
  final VoidCallback? onCameraTap;
  final VoidCallback? onZenlyAvatarTap;

  const EditProfileHeaderCardWidget({
    super.key,
    required this.name,
    required this.username,
    required this.campusBranch,
    this.photoUrl,
    this.onGalleryTap,
    this.onCameraTap,
    this.onZenlyAvatarTap,
  });

  @override
  Widget build(BuildContext context) {
    final surfaceColor = AppColors.surfaceOf(context);
    final borderColor = AppColors.borderOf(context);
    final primaryColor = AppColors.primaryOf(context);
    final textPrimaryColor = AppColors.textPrimaryOf(context);
    final textSecondaryColor = AppColors.textSecondaryOf(context);
    final primaryLightColor = AppColors.primaryLightOf(context);
    final cardSubtleColor = AppColors.cardSubtleBgOf(context);
    final isDarkMode = AppColors.isDark(context);

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: surfaceColor,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: borderColor),
        boxShadow: [
          BoxShadow(
            color: primaryColor.withValues(alpha: 0.05),
            blurRadius: 20,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          // Background soft ambient glow (aura zenly-style)
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            height: 110,
            child: Container(
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    AppColors.activeGreen.withValues(alpha: 0.12),
                    primaryColor.withValues(alpha: 0.08),
                    primaryLightColor.withValues(alpha: 0.05),
                  ],
                ),
              ),
            ),
          ),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
            child: Column(
              children: [
                // Avatar dengan online dot & camera button
                Center(
                  child: Stack(
                    clipBehavior: Clip.none,
                    children: [
                      // Avatar Utama
                      Container(
                        width: 90,
                        height: 90,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(color: surfaceColor, width: 3.5),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.1),
                              blurRadius: 14,
                              offset: const Offset(0, 5),
                            ),
                          ],
                        ),
                        child: ClipOval(
                          child: photoUrl != null && photoUrl!.isNotEmpty
                              ? Image.network(
                                  photoUrl!,
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) =>
                                      _buildFallbackAvatar(),
                                )
                              : _buildFallbackAvatar(),
                        ),
                      ),

                      // Dot Hijau Online (Sudut Kanan Atas)
                      Positioned(
                        top: 2,
                        right: 4,
                        child: Container(
                          width: 16,
                          height: 16,
                          decoration: BoxDecoration(
                            color: AppColors.activeGreen,
                            shape: BoxShape.circle,
                            border: Border.all(color: surfaceColor, width: 2.5),
                            boxShadow: [
                              BoxShadow(
                                color: AppColors.activeGreen.withValues(alpha: 0.4),
                                blurRadius: 6,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                        ),
                      ),

                      // Ikon Kamera Ubah Foto (Sudut Kanan Bawah)
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: GestureDetector(
                          onTap: onCameraTap,
                          child: Container(
                            width: 28,
                            height: 28,
                            decoration: BoxDecoration(
                              color: primaryColor,
                              shape: BoxShape.circle,
                              border: Border.all(color: surfaceColor, width: 2),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withValues(alpha: 0.15),
                                  blurRadius: 6,
                                  offset: const Offset(0, 2),
                                ),
                              ],
                            ),
                            child: const Center(
                              child: Icon(
                                Icons.camera_alt_rounded,
                                color: Colors.white,
                                size: 14,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 12),

                // Nama Mahasiswa + Verified Badge Biru
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Flexible(
                      child: Text(
                        name,
                        style: TextStyle(
                          fontSize: 19,
                          fontWeight: FontWeight.w800,
                          color: textPrimaryColor,
                          letterSpacing: -0.3,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const SizedBox(width: 6),
                    Icon(
                      Icons.verified_rounded,
                      color: primaryColor,
                      size: 20,
                    ),
                  ],
                ),

                const SizedBox(height: 3),

                // Handle & Kampus
                Text(
                  '$username • $campusBranch',
                  style: TextStyle(
                    fontSize: 12.5,
                    fontWeight: FontWeight.w500,
                    color: textSecondaryColor,
                  ),
                  textAlign: TextAlign.center,
                ),

                const SizedBox(height: 18),

                // 3 Quick Action Buttons
                Row(
                  children: [
                    Expanded(
                      child: _buildQuickActionButton(
                        icon: Icons.photo_outlined,
                        label: 'Foto Galeri',
                        backgroundColor: isDarkMode
                            ? AppColors.darkSuccessLight
                            : AppColors.successLight,
                        textColor: AppColors.successGreen,
                        iconColor: AppColors.successGreen,
                        onTap: onGalleryTap,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: _buildQuickActionButton(
                        icon: Icons.camera_alt_outlined,
                        label: 'Ambil Foto',
                        backgroundColor: primaryLightColor,
                        textColor: isDarkMode
                            ? AppColors.darkTextPrimary
                            : AppColors.primaryDark,
                        iconColor: primaryColor,
                        onTap: onCameraTap,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: _buildQuickActionButton(
                        icon: Icons.face_retouching_natural_rounded,
                        label: 'Zenly Avatar',
                        backgroundColor: cardSubtleColor,
                        textColor: AppColors.studentAvatarPurple,
                        iconColor: AppColors.studentAvatarPurple,
                        onTap: onZenlyAvatarTap,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFallbackAvatar() {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColors.primary,
            AppColors.primaryDark,
          ],
        ),
      ),
      child: Center(
        child: Text(
          name.isNotEmpty ? name[0].toUpperCase() : 'A',
          style: const TextStyle(
            color: Colors.white,
            fontSize: 34,
            fontWeight: FontWeight.w800,
          ),
        ),
      ),
    );
  }

  Widget _buildQuickActionButton({
    required IconData icon,
    required String label,
    required Color backgroundColor,
    required Color textColor,
    required Color iconColor,
    required VoidCallback? onTap,
  }) {
    return Material(
      color: backgroundColor,
      borderRadius: BorderRadius.circular(20),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: iconColor.withValues(alpha: 0.15)),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 14, color: iconColor),
              const SizedBox(width: 4),
              Flexible(
                child: Text(
                  label,
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    color: textColor,
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
