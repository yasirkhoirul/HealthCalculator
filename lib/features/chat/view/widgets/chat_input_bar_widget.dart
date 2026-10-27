import 'package:flutter/material.dart';
import '../../../../core/constant/app_colors.dart';

/// Bar input pesan obrolan bergaya TikTok Direct Message.
/// Memiliki input pill rounded, tombol aksi "Knock / Ajak Belajar" yang memicu bottom sheet durasi,
/// dan tombol kirim pesan interaktif.
class ChatInputBarWidget extends StatefulWidget {
  final ValueChanged<String> onSendMessage;
  final void Function(String spotName, int durationMinutes) onSendKnock;
  final VoidCallback? onShareSpotPressed;

  const ChatInputBarWidget({
    super.key,
    required this.onSendMessage,
    required this.onSendKnock,
    this.onShareSpotPressed,
  });

  @override
  State<ChatInputBarWidget> createState() => _ChatInputBarWidgetState();
}

class _ChatInputBarWidgetState extends State<ChatInputBarWidget> {
  late final TextEditingController _controller;
  bool _canSend = false;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
    _controller.addListener(_handleTextChange);
  }

  void _handleTextChange() {
    final hasText = _controller.text.trim().isNotEmpty;
    if (_canSend != hasText) {
      setState(() {
        _canSend = hasText;
      });
    }
  }

  @override
  void dispose() {
    _controller.removeListener(_handleTextChange);
    _controller.dispose();
    super.dispose();
  }

  void _submit() {
    final text = _controller.text.trim();
    if (text.isEmpty) return;

    widget.onSendMessage(text);
    _controller.clear();
  }

  void _showKnockDialog() {
    int selectedDuration = 60;
    String selectedSpot = 'Main Campus Library Floor 2';
    final spots = [
      'Main Campus Library Floor 2',
      'Student Hub & Co-Study',
      'Vokasi Creative Coworking',
      'Kantin Kopi & Belajar',
    ];
    final durations = [30, 45, 60, 90, 120];

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.surfaceOf(context),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (bottomSheetContext) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            final primaryColor = AppColors.primaryOf(context);
            final textPrimaryColor = AppColors.textPrimaryOf(context);
            final textSecondaryColor = AppColors.textSecondaryOf(context);
            final borderColor = AppColors.borderOf(context);

            return SafeArea(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: Container(
                        width: 40,
                        height: 4,
                        decoration: BoxDecoration(
                          color: borderColor,
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(9),
                          decoration: BoxDecoration(
                            color: primaryColor.withValues(alpha: 0.12),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(Icons.bolt_rounded, color: primaryColor, size: 22),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Kirim Ajakan Knock',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w800,
                                  color: textPrimaryColor,
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                'Kirim kartu ajakan belajar bersama ke obrolan',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: textSecondaryColor,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 18),

                    // Pilih Spot
                    Text(
                      'Pilih Spot Belajar:',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                        color: textPrimaryColor,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 14),
                      decoration: BoxDecoration(
                        color: AppColors.cardSubtleBgOf(context),
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(color: borderColor),
                      ),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<String>(
                          value: selectedSpot,
                          isExpanded: true,
                          icon: Icon(Icons.keyboard_arrow_down_rounded, color: primaryColor),
                          dropdownColor: AppColors.surfaceOf(context),
                          items: spots.map((s) {
                            return DropdownMenuItem(
                              value: s,
                              child: Text(
                                s,
                                style: TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w600,
                                  color: textPrimaryColor,
                                ),
                              ),
                            );
                          }).toList(),
                          onChanged: (val) {
                            if (val != null) {
                              setModalState(() => selectedSpot = val);
                            }
                          },
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Pilih Durasi Belajar
                    Text(
                      'Target Durasi Belajar:',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                        color: textPrimaryColor,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 8,
                      children: durations.map((duration) {
                        final isSelected = selectedDuration == duration;
                        return ChoiceChip(
                          label: Text('$duration mnt'),
                          selected: isSelected,
                          selectedColor: primaryColor,
                          labelStyle: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                            color: isSelected ? Colors.white : textPrimaryColor,
                          ),
                          backgroundColor: AppColors.cardSubtleBgOf(context),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                            side: BorderSide(
                              color: isSelected ? primaryColor : borderColor,
                            ),
                          ),
                          onSelected: (_) {
                            setModalState(() => selectedDuration = duration);
                          },
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: 20),

                    // Tombol Kirim Kartu Knock
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        onPressed: () {
                          Navigator.pop(bottomSheetContext);
                          widget.onSendKnock(selectedSpot, selectedDuration);
                        },
                        icon: const Icon(Icons.send_rounded, size: 17, color: Colors.white),
                        label: const Text(
                          'Kirim Kartu Knock ke Chat',
                          style: TextStyle(
                            fontSize: 13.5,
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
    final textMutedColor = AppColors.textMutedOf(context);

    return Container(
      decoration: BoxDecoration(
        color: surfaceColor,
        border: Border(
          top: BorderSide(color: borderColor, width: 0.8),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 6,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(10, 8, 10, 8),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              // 1. Tombol Knock / Ajak Belajar (Gaya Action Button TikTok DM)
              Tooltip(
                message: 'Knock / Ajak Belajar',
                child: Material(
                  color: Colors.transparent,
                  shape: const CircleBorder(),
                  clipBehavior: Clip.antiAlias,
                  child: InkWell(
                    onTap: _showKnockDialog,
                    child: Container(
                      width: 42,
                      height: 42,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: primaryColor.withValues(alpha: 0.1),
                      ),
                      child: Icon(
                        Icons.bolt_rounded,
                        color: primaryColor,
                        size: 23,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 8),

              // 2. Text Input Bar Rounded (Pill)
              Expanded(
                child: Container(
                  constraints: const BoxConstraints(maxHeight: 110),
                  decoration: BoxDecoration(
                    color: AppColors.cardSubtleBgOf(context),
                    borderRadius: BorderRadius.circular(24),
                    border: Border.all(color: borderColor),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      const SizedBox(width: 14),
                      Expanded(
                        child: TextField(
                          controller: _controller,
                          minLines: 1,
                          maxLines: 4,
                          textInputAction: TextInputAction.send,
                          onSubmitted: (_) => _submit(),
                          style: TextStyle(
                            fontSize: 14,
                            color: textPrimaryColor,
                          ),
                          decoration: InputDecoration(
                            hintText: 'Ketik pesan...',
                            hintStyle: TextStyle(
                              fontSize: 13.5,
                              color: textMutedColor,
                            ),
                            border: InputBorder.none,
                            isDense: true,
                            contentPadding: const EdgeInsets.symmetric(
                              vertical: 11,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 8),

              // 3. Send Message Button
              Material(
                color: _canSend ? primaryColor : primaryColor.withValues(alpha: 0.35),
                shape: const CircleBorder(),
                clipBehavior: Clip.antiAlias,
                child: InkWell(
                  onTap: _canSend ? _submit : null,
                  child: Container(
                    width: 42,
                    height: 42,
                    alignment: Alignment.center,
                    child: const Icon(
                      Icons.arrow_upward_rounded,
                      size: 21,
                      color: Colors.white,
                    ),
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
