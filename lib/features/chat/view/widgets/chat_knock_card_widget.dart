import 'package:flutter/material.dart';
import '../../../../core/constant/app_colors.dart';
import '../../data/models/chat_message_model.dart';
import '../../data/models/knock_payload_model.dart';

/// Kartu Interaktif Ajakan Belajar "Knock" di dalam alur pesan obrolan.
/// Menampilkan detail lokasi spot, durasi belajar, dan tombol penerimaan langsung di dalam chat.
class ChatKnockCardWidget extends StatelessWidget {
  final ChatMessageModel message;
  final KnockPayloadModel knock;
  final bool isMe;
  final ValueChanged<bool>? onRespond;

  const ChatKnockCardWidget({
    super.key,
    required this.message,
    required this.knock,
    required this.isMe,
    this.onRespond,
  });

  @override
  Widget build(BuildContext context) {
    final surfaceColor = AppColors.surfaceOf(context);
    final borderColor = AppColors.borderOf(context);
    final primaryColor = AppColors.primaryOf(context);
    final primaryLightColor = AppColors.primaryLightOf(context);
    final textPrimaryColor = AppColors.textPrimaryOf(context);
    final textSecondaryColor = AppColors.textSecondaryOf(context);

    final isPending = knock.status == 'pending';
    final isAccepted = knock.status == 'accepted';
    final isDeclined = knock.status == 'declined';

    // Format waktu
    final hour = message.timestamp.hour.toString().padLeft(2, '0');
    final minute = message.timestamp.minute.toString().padLeft(2, '0');
    final timeString = '$hour:$minute';

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      child: Align(
        alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
        child: ConstrainedBox(
          constraints: BoxConstraints(
            maxWidth: MediaQuery.of(context).size.width * 0.82,
          ),
          child: Container(
            decoration: BoxDecoration(
              color: surfaceColor,
              borderRadius: BorderRadius.circular(18),
              border: Border.all(
                color: isAccepted
                    ? AppColors.successGreen.withValues(alpha: 0.4)
                    : primaryColor.withValues(alpha: 0.3),
                width: 1.2,
              ),
              boxShadow: [
                BoxShadow(
                  color: (isAccepted ? AppColors.successGreen : primaryColor)
                      .withValues(alpha: 0.08),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                // 1. Header Card: Knock Badge & Timestamp
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 9),
                  decoration: BoxDecoration(
                    color: isAccepted
                        ? (AppColors.isDark(context)
                            ? AppColors.darkSuccessLight
                            : AppColors.successLight)
                        : primaryLightColor,
                    borderRadius: const BorderRadius.vertical(top: Radius.circular(17)),
                  ),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(5),
                        decoration: BoxDecoration(
                          color: isAccepted ? AppColors.successGreen : primaryColor,
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          isAccepted
                              ? Icons.check_circle_rounded
                              : Icons.bolt_rounded,
                          size: 14,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          isAccepted
                              ? 'Ajakan Belajar Diterima'
                              : 'Ajakan Belajar (Knock)',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                            color: isAccepted ? AppColors.successGreen : primaryColor,
                          ),
                        ),
                      ),
                      Text(
                        timeString,
                        style: TextStyle(
                          fontSize: 10.5,
                          fontWeight: FontWeight.w500,
                          color: textSecondaryColor,
                        ),
                      ),
                    ],
                  ),
                ),

                // 2. Body Details: Spot Name & Duration
                Padding(
                  padding: const EdgeInsets.all(14),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Icon(
                            Icons.place_rounded,
                            size: 18,
                            color: primaryColor,
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  knock.spotName,
                                  style: TextStyle(
                                    fontSize: 13.5,
                                    fontWeight: FontWeight.w700,
                                    color: textPrimaryColor,
                                  ),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  'Estimasi durasi: ${knock.durationMinutes} Menit',
                                  style: TextStyle(
                                    fontSize: 11.5,
                                    color: textSecondaryColor,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),

                      // 3. Status Action & Confirmation
                      if (isPending) ...[
                        if (!isMe) ...[
                          // Penerima ajakan: Tombol Terima / Tolak
                          Row(
                            children: [
                              Expanded(
                                child: OutlinedButton(
                                  onPressed: () => onRespond?.call(false),
                                  style: OutlinedButton.styleFrom(
                                    padding: const EdgeInsets.symmetric(vertical: 8),
                                    side: BorderSide(color: borderColor),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                  ),
                                  child: Text(
                                    'Tolak',
                                    style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w600,
                                      color: textSecondaryColor,
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: ElevatedButton(
                                  onPressed: () => onRespond?.call(true),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: primaryColor,
                                    foregroundColor: Colors.white,
                                    padding: const EdgeInsets.symmetric(vertical: 8),
                                    elevation: 0,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                  ),
                                  child: const Text(
                                    'Terima Ajakan',
                                    style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ] else ...[
                          // Pengirim ajakan: Status menunggu
                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 10),
                            decoration: BoxDecoration(
                              color: primaryLightColor.withValues(alpha: 0.4),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.hourglass_top_rounded,
                                  size: 14,
                                  color: primaryColor,
                                ),
                                const SizedBox(width: 6),
                                Text(
                                  'Menunggu konfirmasi lawan bicara...',
                                  style: TextStyle(
                                    fontSize: 11.5,
                                    fontWeight: FontWeight.w600,
                                    color: primaryColor,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ] else if (isAccepted) ...[
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 10),
                          decoration: BoxDecoration(
                            color: AppColors.isDark(context)
                                ? AppColors.darkSuccessLight
                                : AppColors.successLight,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: const Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.check_circle_outline_rounded,
                                size: 15,
                                color: AppColors.successGreen,
                              ),
                              SizedBox(width: 6),
                              Text(
                                'Ajakan Diterima ✓ Sesi Siap Dimulai',
                                style: TextStyle(
                                  fontSize: 11.5,
                                  fontWeight: FontWeight.w700,
                                  color: AppColors.successGreen,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ] else if (isDeclined) ...[
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 10),
                          decoration: BoxDecoration(
                            color: AppColors.cardSubtleBgOf(context),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.cancel_outlined,
                                size: 15,
                                color: textSecondaryColor,
                              ),
                              const SizedBox(width: 6),
                              Text(
                                'Ajakan Belajar Ditolak',
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
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
