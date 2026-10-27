import 'package:flutter/material.dart';
import '../../../../core/constant/app_colors.dart';
import '../../data/models/chat_message_model.dart';
import 'chat_knock_card_widget.dart';

/// Widget Bubble Pesan untuk Obrolan Langsung (Chat Room).
/// Menangani pesan teks biasa dan mendelegasikan kartu ajakan ke [ChatKnockCardWidget].
class ChatBubbleWidget extends StatelessWidget {
  final ChatMessageModel message;
  final bool isMe;
  final ValueChanged<bool>? onRespondKnock;

  const ChatBubbleWidget({
    super.key,
    required this.message,
    required this.isMe,
    this.onRespondKnock,
  });

  @override
  Widget build(BuildContext context) {
    // Jika pesan merupakan kartu ajakan Knock
    if (message.knockPayload != null) {
      return ChatKnockCardWidget(
        message: message,
        knock: message.knockPayload!,
        isMe: isMe,
        onRespond: onRespondKnock,
      );
    }

    final primaryColor = AppColors.primaryOf(context);
    final cardSubtleColor = AppColors.cardSubtleBgOf(context);
    final textPrimaryColor = AppColors.textPrimaryOf(context);
    final textMutedColor = AppColors.textMutedOf(context);

    // Format waktu (HH:mm)
    final hour = message.timestamp.hour.toString().padLeft(2, '0');
    final minute = message.timestamp.minute.toString().padLeft(2, '0');
    final timeString = '$hour:$minute';

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 3.5),
      child: Row(
        mainAxisAlignment:
            isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          ConstrainedBox(
            constraints: BoxConstraints(
              maxWidth: MediaQuery.of(context).size.width * 0.76,
            ),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 9.5),
              decoration: BoxDecoration(
                color: isMe ? primaryColor : cardSubtleColor,
                borderRadius: BorderRadius.only(
                  topLeft: const Radius.circular(18),
                  topRight: const Radius.circular(18),
                  bottomLeft: Radius.circular(isMe ? 18 : 4),
                  bottomRight: Radius.circular(isMe ? 4 : 18),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: isMe ? 0.08 : 0.03),
                    blurRadius: 5,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment:
                    isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
                children: [
                  Text(
                    message.message,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: isMe ? Colors.white : textPrimaryColor,
                      height: 1.35,
                    ),
                  ),
                  const SizedBox(height: 3),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        timeString,
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w500,
                          color: isMe
                              ? Colors.white.withValues(alpha: 0.8)
                              : textMutedColor,
                        ),
                      ),
                      if (isMe) ...[
                        const SizedBox(width: 4),
                        Icon(
                          message.isRead
                              ? Icons.done_all_rounded
                              : Icons.done_rounded,
                          size: 13,
                          color: Colors.white.withValues(alpha: 0.9),
                        ),
                      ],
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
