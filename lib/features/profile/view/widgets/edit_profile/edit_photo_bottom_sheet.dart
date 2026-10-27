import 'package:flutter/material.dart';
import '../../../../../core/constant/app_colors.dart';

/// Modal Bottom Sheet untuk Ganti Foto Profil Mahasiswa
class EditPhotoBottomSheet extends StatelessWidget {
  final VoidCallback? onCameraSelect;
  final VoidCallback? onGallerySelect;
  final VoidCallback? onZenlyAvatarSelect;
  final VoidCallback? onRemovePhoto;

  const EditPhotoBottomSheet({
    super.key,
    this.onCameraSelect,
    this.onGallerySelect,
    this.onZenlyAvatarSelect,
    this.onRemovePhoto,
  });

  static void show(
    BuildContext context, {
    VoidCallback? onCameraSelect,
    VoidCallback? onGallerySelect,
    VoidCallback? onZenlyAvatarSelect,
    VoidCallback? onRemovePhoto,
  }) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (ctx) => EditPhotoBottomSheet(
        onCameraSelect: () {
          Navigator.pop(ctx);
          onCameraSelect?.call();
        },
        onGallerySelect: () {
          Navigator.pop(ctx);
          onGallerySelect?.call();
        },
        onZenlyAvatarSelect: () {
          Navigator.pop(ctx);
          onZenlyAvatarSelect?.call();
        },
        onRemovePhoto: () {
          Navigator.pop(ctx);
          onRemovePhoto?.call();
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final surfaceColor = AppColors.surfaceOf(context);
    final borderColor = AppColors.borderOf(context);
    final borderSubtleColor = AppColors.borderSubtleOf(context);
    final textPrimaryColor = AppColors.textPrimaryOf(context);
    final textSecondaryColor = AppColors.textSecondaryOf(context);
    final primaryColor = AppColors.primaryOf(context);
    final primaryLightColor = AppColors.primaryLightOf(context);
    final successLightColor = AppColors.isDark(context)
        ? AppColors.darkSuccessLight
        : AppColors.successLight;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      decoration: BoxDecoration(
        color: surfaceColor,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Handle bar
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: borderColor,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 16),

            Text(
              'Ganti Foto Profil',
              style: TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.w800,
                color: textPrimaryColor,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              'Pilih metode untuk memperbarui tampilan foto belajarmu',
              style: TextStyle(
                fontSize: 12.5,
                color: textSecondaryColor,
              ),
            ),
            const SizedBox(height: 20),

            _buildOptionTile(
              context: context,
              icon: Icons.camera_alt_outlined,
              iconColor: primaryColor,
              iconBg: primaryLightColor,
              title: 'Ambil Foto Langsung',
              subtitle: 'Gunakan kamera depan untuk foto kampus',
              onTap: onCameraSelect,
            ),
            Divider(color: borderSubtleColor, height: 1),

            _buildOptionTile(
              context: context,
              icon: Icons.photo_library_outlined,
              iconColor: AppColors.successGreen,
              iconBg: successLightColor,
              title: 'Pilih dari Galeri',
              subtitle: 'Upload foto dari album smartphone',
              onTap: onGallerySelect,
            ),
            Divider(color: borderSubtleColor, height: 1),

            _buildOptionTile(
              context: context,
              icon: Icons.face_retouching_natural_rounded,
              iconColor: AppColors.studentAvatarPurple,
              iconBg: primaryLightColor,
              title: 'Zenly 3D Avatar',
              subtitle: 'Gunakan karakter 3D kartun mahasiswa',
              onTap: onZenlyAvatarSelect,
            ),

            if (onRemovePhoto != null) ...[
              Divider(color: borderSubtleColor, height: 1),
              _buildOptionTile(
                context: context,
                icon: Icons.delete_outline_rounded,
                iconColor: AppColors.errorDark,
                iconBg: AppColors.error.withValues(alpha: 0.1),
                title: 'Hapus Foto Profil',
                subtitle: 'Kembalikan ke inisial huruf nama',
                onTap: onRemovePhoto,
              ),
            ],
            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }

  Widget _buildOptionTile({
    required BuildContext context,
    required IconData icon,
    required Color iconColor,
    required Color iconBg,
    required String title,
    required String subtitle,
    required VoidCallback? onTap,
  }) {
    return ListTile(
      onTap: onTap,
      contentPadding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
      leading: Container(
        width: 42,
        height: 42,
        decoration: BoxDecoration(
          color: iconBg,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Center(
          child: Icon(icon, color: iconColor, size: 22),
        ),
      ),
      title: Text(
        title,
        style: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w700,
          color: AppColors.textPrimaryOf(context),
        ),
      ),
      subtitle: Text(
        subtitle,
        style: TextStyle(
          fontSize: 12,
          color: AppColors.textSecondaryOf(context),
        ),
      ),
      trailing: Icon(
        Icons.chevron_right_rounded,
        size: 20,
        color: AppColors.textMutedOf(context),
      ),
    );
  }
}
