import 'package:flutter/material.dart';
import '../../../../core/constant/app_colors.dart';

/// Header AppBar dengan gaya TikTok Direct Message (DM).
/// Menampilkan tombol kembali, area profil interaktif di tengah (nama, badge verified, status aktif),
/// serta menu opsi titik tiga di kanan.
class ChatAppBarHeaderWidget extends StatelessWidget implements PreferredSizeWidget {
  final String userName;
  final String userStatus;
  final String userInitials;
  final bool isOnline;
  final VoidCallback onBack;
  final VoidCallback onProfileTap;
  final VoidCallback? onBlockUser;
  final VoidCallback? onReportUser;

  const ChatAppBarHeaderWidget({
    super.key,
    required this.userName,
    required this.userStatus,
    required this.userInitials,
    required this.isOnline,
    required this.onBack,
    required this.onProfileTap,
    this.onBlockUser,
    this.onReportUser,
  });

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight + 1);

  @override
  Widget build(BuildContext context) {
    final surfaceColor = AppColors.surfaceOf(context);
    final borderColor = AppColors.borderOf(context);
    final textPrimaryColor = AppColors.textPrimaryOf(context);
    final textSecondaryColor = AppColors.textSecondaryOf(context);
    final primaryColor = AppColors.primaryOf(context);

    return AppBar(
      backgroundColor: surfaceColor,
      elevation: 0,
      scrolledUnderElevation: 0.5,
      titleSpacing: 0,
      leading: IconButton(
        icon: Icon(
          Icons.arrow_back_ios_new_rounded,
          color: textPrimaryColor,
          size: 19,
        ),
        onPressed: onBack,
      ),
      // Central Interactive Profile Area (TikTok DM style)
      title: InkWell(
        onTap: onProfileTap,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Stack(
                children: [
                  CircleAvatar(
                    radius: 19,
                    backgroundColor: primaryColor,
                    child: Text(
                      userInitials,
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                        fontSize: 13,
                      ),
                    ),
                  ),
                  Positioned(
                    right: 0,
                    bottom: 0,
                    child: Container(
                      width: 10.5,
                      height: 10.5,
                      decoration: BoxDecoration(
                        color: isOnline
                            ? const Color(0xFF22C55E)
                            : AppColors.textMutedOf(context),
                        shape: BoxShape.circle,
                        border: Border.all(color: surfaceColor, width: 2),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(width: 10),
              Flexible(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Flexible(
                          child: Text(
                            userName,
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w700,
                              color: textPrimaryColor,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        const SizedBox(width: 4),
                        const Icon(
                          Icons.verified_rounded,
                          size: 15,
                          color: AppColors.primary,
                        ),
                      ],
                    ),
                    const SizedBox(height: 1),
                    Text(
                      userStatus,
                      style: TextStyle(
                        fontSize: 11,
                        color: isOnline
                            ? AppColors.activeGreen
                            : textSecondaryColor,
                        fontWeight: FontWeight.w500,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      actions: [
        PopupMenuButton<String>(
          icon: Icon(
            Icons.more_vert_rounded,
            color: textPrimaryColor,
            size: 21,
          ),
          onSelected: (value) {
            if (value == 'profile') {
              onProfileTap();
            } else if (value == 'block') {
              onBlockUser?.call();
            } else if (value == 'report') {
              onReportUser?.call();
            }
          },
          itemBuilder: (context) => [
            const PopupMenuItem(
              value: 'profile',
              child: Row(
                children: [
                  Icon(Icons.person_outline_rounded, size: 18),
                  SizedBox(width: 8),
                  Text('Lihat Profil Lengkap'),
                ],
              ),
            ),
            const PopupMenuItem(
              value: 'block',
              child: Row(
                children: [
                  Icon(Icons.block_flipped, size: 18, color: AppColors.error),
                  SizedBox(width: 8),
                  Text('Blokir Pengguna', style: TextStyle(color: AppColors.error)),
                ],
              ),
            ),
            const PopupMenuItem(
              value: 'report',
              child: Row(
                children: [
                  Icon(Icons.flag_outlined, size: 18),
                  SizedBox(width: 8),
                  Text('Laporkan'),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(width: 6),
      ],
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(1),
        child: Container(color: borderColor, height: 0.8),
      ),
    );
  }
}
