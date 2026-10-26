import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constant/app_colors.dart';
import '../../../../core/di/injection.dart';
import '../../../../router/app_routes.dart';
import '../../../chat/view/viewmodels/chat_viewmodel.dart';
import '../../data/models/user_presence_model.dart';

/// Modal Bottom Sheet Detail Presensi Pengguna ("Location Details" / Mini Profile Preview)
/// Terintegrasi dengan navigasi UserDetailPage dan ChatDetailPage.
class MapUserDetailBottomSheet extends StatefulWidget {
  final UserPresenceModel user;

  const MapUserDetailBottomSheet({
    super.key,
    required this.user,
  });

  @override
  State<MapUserDetailBottomSheet> createState() =>
      _MapUserDetailBottomSheetState();
}

class _MapUserDetailBottomSheetState extends State<MapUserDetailBottomSheet> {
  int _selectedDuration = 45;

  void _navigateToUserProfile() {
    Navigator.of(context).pop();
    context.pushNamed(
      AppRoutes.userDetail,
      pathParameters: {'userId': widget.user.id},
    );
  }

  void _navigateToChat() {
    Navigator.of(context).pop();
    context.pushNamed(
      AppRoutes.chatDetail,
      pathParameters: {'userId': widget.user.id},
    );
  }

  void _sendKnockAndOpenChat() {
    // Kirim kartu Knock via ChatViewModel
    if (locator.isRegistered<ChatViewModel>()) {
      locator<ChatViewModel>().sendKnockInvitation(
        targetUserId: widget.user.id,
        spotName: widget.user.currentSpotName,
        durationMinutes: _selectedDuration,
      );
    }

    Navigator.of(context).pop();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Ajakan belajar di ${widget.user.currentSpotName} ($_selectedDuration mnt) terkirim ke ${widget.user.name}!',
        ),
        duration: const Duration(seconds: 1),
      ),
    );

    context.pushNamed(
      AppRoutes.chatDetail,
      pathParameters: {'userId': widget.user.id},
    );
  }

  void _showDurationPicker() {
    final durations = [30, 45, 60, 90, 120];

    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.surfaceOf(context),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (modalCtx) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            final primaryColor = AppColors.primaryOf(context);
            final textPrimary = AppColors.textPrimaryOf(context);
            final textSecondary = AppColors.textSecondaryOf(context);

            return SafeArea(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 16, 20, 20),
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
                    const SizedBox(height: 16),
                    Text(
                      'Pilih Durasi Belajar Bersama',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w800,
                        color: textPrimary,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Ajakan akan dikirimkan ke chat obrolan dengan ${widget.user.name}.',
                      style: TextStyle(fontSize: 12, color: textSecondary),
                    ),
                    const SizedBox(height: 16),
                    Wrap(
                      spacing: 8,
                      children: durations.map((dur) {
                        final isSel = _selectedDuration == dur;
                        return ChoiceChip(
                          label: Text('$dur menit'),
                          selected: isSel,
                          selectedColor: primaryColor,
                          labelStyle: TextStyle(
                            fontSize: 12.5,
                            fontWeight: FontWeight.w700,
                            color: isSel ? Colors.white : textPrimary,
                          ),
                          backgroundColor: AppColors.cardSubtleBgOf(context),
                          onSelected: (_) {
                            setModalState(() => _selectedDuration = dur);
                            setState(() => _selectedDuration = dur);
                          },
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: 20),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        onPressed: () {
                          Navigator.pop(modalCtx);
                          _sendKnockAndOpenChat();
                        },
                        icon: const Icon(Icons.send_rounded, color: Colors.white, size: 18),
                        label: const Text(
                          'Kirim Ajakan Belajar',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                          ),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: primaryColor,
                          padding: const EdgeInsets.symmetric(vertical: 13),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final surfaceColor = AppColors.surfaceOf(context);
    final borderColor = AppColors.borderOf(context);
    final primaryColor = AppColors.primaryOf(context);
    final textPrimaryColor = AppColors.textPrimaryOf(context);
    final textSecondaryColor = AppColors.textSecondaryOf(context);
    final isDark = AppColors.isDark(context);

    return Container(
      decoration: BoxDecoration(
        color: surfaceColor,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
        border: Border.all(color: borderColor, width: 0.8),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.35 : 0.08),
            blurRadius: 20,
            offset: const Offset(0, -6),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Top Drag Handle & Close Button
              Center(
                child: Container(
                  width: 38,
                  height: 4,
                  decoration: BoxDecoration(
                    color: AppColors.borderOf(context),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 12),

              // ─── Header Profil Interaktif (Dapat diketuk untuk buka profil) ───
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    child: InkWell(
                      borderRadius: BorderRadius.circular(14),
                      onTap: _navigateToUserProfile,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 4),
                        child: Row(
                          children: [
                            // Avatar dengan Dot Online/Offline
                            Stack(
                              clipBehavior: Clip.none,
                              children: [
                                CircleAvatar(
                                  radius: 26,
                                  backgroundColor: AppColors.primaryLightOf(context),
                                  child: Text(
                                    widget.user.avatarInitials,
                                    style: TextStyle(
                                      color: primaryColor,
                                      fontWeight: FontWeight.w800,
                                      fontSize: 16,
                                    ),
                                  ),
                                ),
                                Positioned(
                                  right: 0,
                                  bottom: 0,
                                  child: Container(
                                    width: 13,
                                    height: 13,
                                    decoration: BoxDecoration(
                                      color: widget.user.isOnline
                                          ? const Color(0xFF22C55E)
                                          : AppColors.textMutedOf(context),
                                      shape: BoxShape.circle,
                                      border: Border.all(color: surfaceColor, width: 2),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(width: 14),

                            // Nama, Verified Badge & Spot Belajar
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Flexible(
                                        child: Text(
                                          widget.user.name,
                                          style: TextStyle(
                                            fontSize: 17,
                                            fontWeight: FontWeight.w800,
                                            color: textPrimaryColor,
                                            letterSpacing: -0.2,
                                          ),
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                      const SizedBox(width: 4),
                                      const Icon(
                                        Icons.verified_rounded,
                                        size: 16,
                                        color: AppColors.primary,
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 2),
                                  Row(
                                    children: [
                                      Icon(
                                        Icons.place_rounded,
                                        size: 13,
                                        color: primaryColor,
                                      ),
                                      const SizedBox(width: 3),
                                      Flexible(
                                        child: Text(
                                          widget.user.currentSpotName,
                                          style: TextStyle(
                                            fontSize: 12.5,
                                            fontWeight: FontWeight.w600,
                                            color: textSecondaryColor,
                                          ),
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),

                  // Tombol Tutup (✕) di pojok kanan atas
                  Material(
                    color: Colors.transparent,
                    shape: const CircleBorder(),
                    clipBehavior: Clip.antiAlias,
                    child: IconButton(
                      icon: Icon(
                        Icons.close_rounded,
                        size: 20,
                        color: textSecondaryColor,
                      ),
                      onPressed: () => Navigator.of(context).pop(),
                      tooltip: 'Tutup',
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 14),

              // ─── Badges & Status Belajar ───
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  // Major / Minat Pill (Hijau Muda)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    decoration: BoxDecoration(
                      color: isDark
                          ? const Color(0xFF14532D).withValues(alpha: 0.45)
                          : const Color(0xFFDCFCE7),
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                        color: isDark
                            ? const Color(0xFF22C55E).withValues(alpha: 0.3)
                            : const Color(0xFF86EFAC),
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.school_rounded,
                          size: 13,
                          color: isDark ? const Color(0xFF4ADE80) : const Color(0xFF15803D),
                        ),
                        const SizedBox(width: 5),
                        Text(
                          widget.user.major,
                          style: TextStyle(
                            fontSize: 11.5,
                            fontWeight: FontWeight.w700,
                            color: isDark ? const Color(0xFF4ADE80) : const Color(0xFF15803D),
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Topik Belajar Aktif (Indigo)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    decoration: BoxDecoration(
                      color: primaryColor.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                        color: primaryColor.withValues(alpha: 0.25),
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.menu_book_rounded,
                          size: 13,
                          color: primaryColor,
                        ),
                        const SizedBox(width: 5),
                        Text(
                          widget.user.currentTopic,
                          style: TextStyle(
                            fontSize: 11.5,
                            fontWeight: FontWeight.w700,
                            color: primaryColor,
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Estimasi Jarak
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    decoration: BoxDecoration(
                      color: AppColors.cardSubtleBgOf(context),
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: borderColor),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.navigation_rounded,
                          size: 12,
                          color: textSecondaryColor,
                        ),
                        const SizedBox(width: 5),
                        Text(
                          '120m dari lokasimu',
                          style: TextStyle(
                            fontSize: 11.5,
                            fontWeight: FontWeight.w600,
                            color: textSecondaryColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 18),

              // ─── Bilah Aksi Cepat Buka Chat Langsung ───
              InkWell(
                borderRadius: BorderRadius.circular(12),
                onTap: _navigateToChat,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                  decoration: BoxDecoration(
                    color: AppColors.cardSubtleBgOf(context),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: borderColor),
                  ),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          color: primaryColor.withValues(alpha: 0.12),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.chat_bubble_outline_rounded,
                          size: 16,
                          color: primaryColor,
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          'Buka Obrolan Langsung dengan ${widget.user.name}',
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w700,
                            color: textPrimaryColor,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      Icon(
                        Icons.arrow_forward_ios_rounded,
                        size: 13,
                        color: textSecondaryColor,
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 14),

              // ─── Tombol Aksi Utama: "Ajak Belajar Bareng" (Knock Request) ───
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: _showDurationPicker,
                  icon: const Icon(
                    Icons.bolt_rounded,
                    color: Colors.white,
                    size: 20,
                  ),
                  label: const Text(
                    'Ajak Belajar Bareng (Knock)',
                    style: TextStyle(
                      fontSize: 14.5,
                      fontWeight: FontWeight.w800,
                      color: Colors.white,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF4F46E5), // Ungu indigo TikTok DM style
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    elevation: 0,
                    shadowColor: Colors.transparent,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
