import 'package:flutter/material.dart';
import '../../../../core/constant/app_colors.dart';

/// Banner informasi pertemanan di bawah AppBar obrolan.
/// Ditampilkan bila kedua pengguna belum berstatus pertemanan "Accepted".
class ChatFriendshipBannerWidget extends StatelessWidget {
  final bool isPending;
  final VoidCallback onAddFriendPressed;

  const ChatFriendshipBannerWidget({
    super.key,
    required this.isPending,
    required this.onAddFriendPressed,
  });

  @override
  Widget build(BuildContext context) {
    final primaryColor = AppColors.primaryOf(context);
    final primaryLightColor = AppColors.primaryLightOf(context);
    final borderColor = AppColors.borderOf(context);
    final textPrimaryColor = AppColors.textPrimaryOf(context);
    final textSecondaryColor = AppColors.textSecondaryOf(context);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        color: isPending
            ? primaryLightColor.withValues(alpha: 0.6)
            : primaryLightColor,
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
              size: 18,
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
                  isPending
                      ? 'Permintaan Terkirim'
                      : 'Kalian belum berteman di StudyMap',
                  style: TextStyle(
                    fontSize: 12.5,
                    fontWeight: FontWeight.w700,
                    color: textPrimaryColor,
                  ),
                ),
                const SizedBox(height: 1),
                Text(
                  isPending
                      ? 'Menunggu persetujuan dari lawan bicara.'
                      : 'Tambah teman agar lebih mudah koordinasi spot.',
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
              disabledForegroundColor: Colors.white.withValues(alpha: 0.8),
              elevation: 0,
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
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
                    fontSize: 11.5,
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
