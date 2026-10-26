import 'package:flutter/material.dart';
import '../../../../core/constant/app_colors.dart';
import '../../data/models/study_status_model.dart';
import '../viewmodels/map_viewmodel.dart';
import 'map_status_bubble_widget.dart';

/// Modal Bottom Sheet Pemilih Status Emote Belajar ("Study Mood / Vibe Status")
/// Memungkinkan pengguna memilih preset emote & menulis pesan singkat (maks 30 karakter).
class MapStatusPickerBottomSheet extends StatefulWidget {
  final MapViewModel mapViewModel;

  const MapStatusPickerBottomSheet({
    super.key,
    required this.mapViewModel,
  });

  @override
  State<MapStatusPickerBottomSheet> createState() =>
      _MapStatusPickerBottomSheetState();
}

class _MapStatusPickerBottomSheetState extends State<MapStatusPickerBottomSheet> {
  late StudyStatusModel _selectedPreset;
  late final TextEditingController _messageController;
  final int _maxChars = 30;

  @override
  void initState() {
    super.initState();
    _selectedPreset = widget.mapViewModel.currentStatus;
    _messageController = TextEditingController(
      text: widget.mapViewModel.currentStatus.customMessage ?? '',
    );
  }

  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
  }

  void _applyStatus() {
    final messenger = ScaffoldMessenger.of(context);
    final navigator = Navigator.of(context);
    final customMsg = _messageController.text.trim();
    final updated = _selectedPreset.copyWith(
      customMessage: customMsg.isNotEmpty ? customMsg : null,
      updatedAt: DateTime.now(),
    );

    widget.mapViewModel.setStudyStatus(updated);
    navigator.pop();

    messenger.showSnackBar(
      SnackBar(
        content: Text(
          'Status emote "${updated.emoji} ${updated.displayText}" berhasil dipasang di peta!',
        ),
        duration: const Duration(seconds: 1),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final surfaceColor = AppColors.surfaceOf(context);
    final borderColor = AppColors.borderOf(context);
    final textPrimaryColor = AppColors.textPrimaryOf(context);
    final textSecondaryColor = AppColors.textSecondaryOf(context);
    final isDark = AppColors.isDark(context);

    final previewStatus = _selectedPreset.copyWith(
      customMessage: _messageController.text.trim().isNotEmpty
          ? _messageController.text.trim()
          : null,
    );

    return Container(
      decoration: BoxDecoration(
        color: surfaceColor,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
        border: Border.all(color: borderColor, width: 0.8),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.4 : 0.1),
            blurRadius: 20,
            offset: const Offset(0, -6),
          ),
        ],
      ),
      child: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Drag Handle Bar
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
              const SizedBox(height: 14),

              // Title & Close Button
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Status Belajarmu Sekarang',
                          style: TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.w800,
                            color: textPrimaryColor,
                            letterSpacing: -0.2,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          'Pilih mood belajar yang tampil di atas avatarmu',
                          style: TextStyle(
                            fontSize: 12,
                            color: textSecondaryColor,
                          ),
                        ),
                      ],
                    ),
                  ),
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
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 16),

              // Live Preview Floating Bubble
              Center(
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                  decoration: BoxDecoration(
                    color: AppColors.cardSubtleBgOf(context),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: borderColor),
                  ),
                  child: Column(
                    children: [
                      Text(
                        'Pratinjau Bubble di Peta:',
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          color: textSecondaryColor,
                        ),
                      ),
                      const SizedBox(height: 8),
                      MapStatusBubbleWidget(
                        status: previewStatus,
                        isMyLocation: true,
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 18),

              // Preset Emote Belajar Cards / Pills
              Text(
                'Pilih Vibe Emote:',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  color: textPrimaryColor,
                ),
              ),
              const SizedBox(height: 10),

              Column(
                children: StudyStatusModel.presets.map((preset) {
                  final isSelected = _selectedPreset.emoji == preset.emoji;

                  return Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                        borderRadius: BorderRadius.circular(14),
                        onTap: () {
                          setState(() {
                            _selectedPreset = preset;
                          });
                        },
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 14,
                            vertical: 10,
                          ),
                          decoration: BoxDecoration(
                            color: isSelected
                                ? const Color(0xFF4F46E5).withValues(alpha: 0.1)
                                : AppColors.cardSubtleBgOf(context),
                            borderRadius: BorderRadius.circular(14),
                            border: Border.all(
                              color: isSelected
                                  ? const Color(0xFF4F46E5)
                                  : borderColor,
                              width: isSelected ? 1.6 : 0.8,
                            ),
                          ),
                          child: Row(
                            children: [
                              Text(
                                preset.emoji,
                                style: const TextStyle(fontSize: 22),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      preset.label,
                                      style: TextStyle(
                                        fontSize: 13.5,
                                        fontWeight: FontWeight.w700,
                                        color: isSelected
                                            ? const Color(0xFF4F46E5)
                                            : textPrimaryColor,
                                      ),
                                    ),
                                    if (preset.customMessage != null) ...[
                                      const SizedBox(height: 2),
                                      Text(
                                        preset.customMessage!,
                                        style: TextStyle(
                                          fontSize: 11.5,
                                          color: textSecondaryColor,
                                        ),
                                      ),
                                    ],
                                  ],
                                ),
                              ),
                              if (isSelected)
                                const Icon(
                                  Icons.check_circle_rounded,
                                  color: Color(0xFF4F46E5),
                                  size: 19,
                                ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),

              const SizedBox(height: 14),

              // Optional Custom Message Input
              Text(
                'Pesan Singkat Kustom (Opsional):',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  color: textPrimaryColor,
                ),
              ),
              const SizedBox(height: 8),

              TextField(
                controller: _messageController,
                maxLength: _maxChars,
                onChanged: (_) => setState(() {}),
                style: TextStyle(fontSize: 13.5, color: textPrimaryColor),
                decoration: InputDecoration(
                  hintText: 'Tulis pesan singkat... (contoh: Lagi tugas)',
                  hintStyle: TextStyle(
                    fontSize: 12.5,
                    color: AppColors.textMutedOf(context),
                  ),
                  filled: true,
                  fillColor: AppColors.cardSubtleBgOf(context),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 12,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: BorderSide(color: borderColor),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: BorderSide(color: borderColor),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: const BorderSide(
                      color: Color(0xFF4F46E5),
                      width: 1.5,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 12),

              // Action Button: Pasang Status di Peta
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: _applyStatus,
                  icon: const Icon(
                    Icons.bolt_rounded,
                    color: Colors.white,
                    size: 20,
                  ),
                  label: const Text(
                    'Pasang Status di Peta',
                    style: TextStyle(
                      fontSize: 14.5,
                      fontWeight: FontWeight.w800,
                      color: Colors.white,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF4F46E5), // Ungu indigo TikTok style
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    elevation: 0,
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
