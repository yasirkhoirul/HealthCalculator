import 'package:flutter/material.dart';
import '../../../../core/constant/app_colors.dart';

/// Banner pertemanan gaya TikTok DM ("Follow / Add Friend Banner").
/// Muncul di bagian atas ruang chat jika kedua pengguna belum berstatus teman.
class ChatFollowBannerWidget extends StatelessWidget {
  final String userName;
  final bool isPending;
  final VoidCallback onAddFriendPressed;

  const ChatFollowBannerWidget({
    super.key,
    required this.userName,
    required this.isPending,
    required this.onAddFriendPressed,
  });

  @override
  Widget build(BuildContext context) {
    final primaryColor = AppColors.primaryOf(context);
    final cardSubtleColor = AppColors.cardSubtleBgOf(context);
    final textPrimaryColor = AppColors.textPrimaryOf(context);
    final textSecondaryColor = AppColors.textSecondaryOf(context);
    final borderColor = AppColors.borderOf(context);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        color: cardSubtleColor,
        border: Border(
          bottom: BorderSide(color: borderColor, width: 0.8),
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(7),
            decoration: BoxDecoration(
              color: primaryColor.withValues(alpha: 0.12),
              shape: BoxShape.circle,
            ),
            child: Icon(
              isPending ? Icons.hourglass_top_rounded : Icons.person_add_rounded,
              size: 17,
              color: primaryColor,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  isPending ? 'Permintaan Terkirim' : 'Tambah Teman di StudyMap',
                  style: TextStyle(
                    fontSize: 12.5,
                    fontWeight: FontWeight.w700,
                    color: textPrimaryColor,
                  ),
                ),
                const SizedBox(height: 1),
                Text(
                  isPending
                      ? 'Menunggu persetujuan dari $userName.'
                      : 'Berteman untuk melihat lokasi radar dan koordinasi spot.',
                  style: TextStyle(
                    fontSize: 11,
                    color: textSecondaryColor,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          const SizedBox(width: 10),
          ElevatedButton(
            onPressed: isPending ? null : onAddFriendPressed,
            style: ElevatedButton.styleFrom(
              backgroundColor: primaryColor,
              foregroundColor: Colors.white,
              disabledBackgroundColor: primaryColor.withValues(alpha: 0.35),
              disabledForegroundColor: Colors.white.withValues(alpha: 0.85),
              elevation: 0,
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
              minimumSize: const Size(0, 34),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (!isPending) ...[
                  const Icon(Icons.add_rounded, size: 15),
                  const SizedBox(width: 4),
                ],
                Text(
                  isPending ? 'Terkirim ⏳' : 'Tambah',
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
