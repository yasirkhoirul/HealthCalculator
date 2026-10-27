import 'package:flutter/material.dart';
import '../../../../core/constant/app_colors.dart';

/// Widget tombol aksi pertemanan dinamis pada halaman Detail Profil Pengguna.
/// Menyesuaikan state: 'none' (+ Tambah Teman), 'pending' (Permintaan Terkirim), dan 'friends' (Teman ✓).
class UserActionButtonWidget extends StatelessWidget {
  final String friendshipStatus; // 'none', 'pending', 'friends'
  final VoidCallback onToggleFriendship;
  final VoidCallback onSendMessage;
  final VoidCallback onInviteStudy;

  const UserActionButtonWidget({
    super.key,
    required this.friendshipStatus,
    required this.onToggleFriendship,
    required this.onSendMessage,
    required this.onInviteStudy,
  });

  @override
  Widget build(BuildContext context) {
    final primaryColor = AppColors.primaryOf(context);
    final textSecondaryColor = AppColors.textSecondaryOf(context);
    final borderColor = AppColors.borderOf(context);

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          children: [
            // 1. Primary Action: Status Pertemanan
            Expanded(
              flex: 3,
              child: _buildFriendshipButton(
                context: context,
                primaryColor: primaryColor,
                textSecondaryColor: textSecondaryColor,
                borderColor: borderColor,
              ),
            ),
            const SizedBox(width: 10),

            // 2. Secondary Action: Kirim Pesan (Chat)
            Expanded(
              flex: 2,
              child: OutlinedButton.icon(
                onPressed: onSendMessage,
                icon: Icon(Icons.chat_bubble_outline_rounded, size: 17, color: primaryColor),
                label: Text(
                  'Obrolan',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: primaryColor,
                  ),
                ),
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  side: BorderSide(color: primaryColor, width: 1.2),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),

        // 3. Tertiary Action: Ajak Belajar Bareng (Knock Request)
        SizedBox(
          width: double.infinity,
          child: ElevatedButton.icon(
            onPressed: onInviteStudy,
            icon: const Icon(Icons.bolt_rounded, size: 18, color: Colors.white),
            label: const Text(
              'Ajak Belajar Bareng (Knock Request)',
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w700,
                color: Colors.white,
              ),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.studentAvatarPurple,
              padding: const EdgeInsets.symmetric(vertical: 12),
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildFriendshipButton({
    required BuildContext context,
    required Color primaryColor,
    required Color textSecondaryColor,
    required Color borderColor,
  }) {
    switch (friendshipStatus) {
      case 'friends':
        return ElevatedButton.icon(
          onPressed: onToggleFriendship,
          icon: const Icon(Icons.check_rounded, size: 18, color: AppColors.successGreen),
          label: const Text(
            'Teman ✓',
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w700,
              color: AppColors.successGreen,
            ),
          ),
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.isDark(context)
                ? AppColors.darkSuccessLight
                : AppColors.successLight,
            elevation: 0,
            padding: const EdgeInsets.symmetric(vertical: 12),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(14),
              side: const BorderSide(color: AppColors.successGreen, width: 1),
            ),
          ),
        );

      case 'pending':
        return OutlinedButton.icon(
          onPressed: onToggleFriendship,
          icon: Icon(Icons.hourglass_top_rounded, size: 17, color: textSecondaryColor),
          label: Text(
            'Permintaan Terkirim',
            style: TextStyle(
              fontSize: 12.5,
              fontWeight: FontWeight.w600,
              color: textSecondaryColor,
            ),
          ),
          style: OutlinedButton.styleFrom(
            padding: const EdgeInsets.symmetric(vertical: 12),
            side: BorderSide(color: borderColor, width: 1.2),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(14),
            ),
          ),
        );

      case 'none':
      default:
        return ElevatedButton.icon(
          onPressed: onToggleFriendship,
          icon: const Icon(Icons.person_add_rounded, size: 17, color: Colors.white),
          label: const Text(
            '+ Tambah Teman',
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w700,
              color: Colors.white,
            ),
          ),
          style: ElevatedButton.styleFrom(
            backgroundColor: primaryColor,
            elevation: 0,
            padding: const EdgeInsets.symmetric(vertical: 12),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(14),
            ),
          ),
        );
    }
  }
}
