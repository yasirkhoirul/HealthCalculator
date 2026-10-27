import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../../core/constant/app_colors.dart';

/// Custom AppBar untuk Halaman Edit Profile
/// Menyediakan tombol kembali, branding StudyMap, tombol aksi "Simpan", dan menu opsi (...).
class EditProfileAppBarWidget extends StatelessWidget implements PreferredSizeWidget {
  final VoidCallback onSave;
  final bool isLoading;
  final VoidCallback? onReset;

  const EditProfileAppBarWidget({
    super.key,
    required this.onSave,
    this.isLoading = false,
    this.onReset,
  });

  @override
  Size get preferredSize => const Size.fromHeight(60);

  @override
  Widget build(BuildContext context) {
    final surfaceColor = AppColors.surfaceOf(context);
    final borderSubtleColor = AppColors.borderSubtleOf(context);
    final primaryColor = AppColors.primaryOf(context);
    final textPrimaryColor = AppColors.textPrimaryOf(context);
    final textSecondaryColor = AppColors.textSecondaryOf(context);

    return AppBar(
      backgroundColor: surfaceColor,
      elevation: 0,
      scrolledUnderElevation: 0.5,
      centerTitle: false,
      leading: IconButton(
        icon: Icon(
          Icons.arrow_back_rounded,
          color: primaryColor,
          size: 24,
        ),
        onPressed: () {
          if (context.canPop()) {
            context.pop();
          } else {
            Navigator.of(context).maybePop();
          }
        },
        tooltip: 'Kembali',
      ),
      titleSpacing: 0,
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'StudyMap',
            style: TextStyle(
              color: primaryColor,
              fontSize: 18,
              fontWeight: FontWeight.w800,
              letterSpacing: -0.3,
            ),
          ),
          const SizedBox(height: 1),
          Text(
            'Profil & Edit Data',
            style: TextStyle(
              color: textSecondaryColor,
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
      actions: [
        // Tombol "✓ Simpan"
        Center(
          child: Padding(
            padding: const EdgeInsets.only(right: 6),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: isLoading ? null : onSave,
                borderRadius: BorderRadius.circular(20),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
                  decoration: BoxDecoration(
                    color: isLoading ? primaryColor.withValues(alpha: 0.5) : primaryColor,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: primaryColor.withValues(alpha: 0.25),
                        blurRadius: 8,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (isLoading)
                        const SizedBox(
                          width: 13,
                          height: 13,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        )
                      else
                        const Icon(
                          Icons.check_rounded,
                          color: Colors.white,
                          size: 16,
                        ),
                      const SizedBox(width: 5),
                      const Text(
                        'Simpan',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 13,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),

        // Menu Opsi Lainnya (...)
        PopupMenuButton<String>(
          icon: Icon(
            Icons.more_horiz_rounded,
            color: textPrimaryColor,
            size: 24,
          ),
          tooltip: 'Menu Opsi',
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          onSelected: (val) {
            if (val == 'reset') {
              onReset?.call();
            } else if (val == 'help') {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Bantuan: Isi data profil kampus Anda untuk terhubung di peta belajar.'),
                  duration: Duration(seconds: 2),
                ),
              );
            }
          },
          itemBuilder: (context) => [
            PopupMenuItem(
              value: 'help',
              child: Row(
                children: [
                  Icon(Icons.help_outline_rounded, size: 18, color: primaryColor),
                  const SizedBox(width: 10),
                  const Text('Bantuan & FAQ'),
                ],
              ),
            ),
            PopupMenuItem(
              value: 'reset',
              child: Row(
                children: [
                  Icon(Icons.refresh_rounded, size: 18, color: textSecondaryColor),
                  const SizedBox(width: 10),
                  const Text('Reset ke Semula'),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(width: 4),
      ],
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(1),
        child: Container(color: borderSubtleColor, height: 1),
      ),
    );
  }
}
