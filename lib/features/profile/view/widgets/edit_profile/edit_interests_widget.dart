import 'package:flutter/material.dart';
import '../../../../../core/constant/app_colors.dart';

/// Widget Manajemen Minat Belajar Aktif
/// Menampilkan chips minat dengan opsi hapus (✕) dan tombol "+ Tambah Minat".
class EditInterestsWidget extends StatelessWidget {
  final List<String> interests;
  final void Function(String interest) onAddInterest;
  final void Function(String interest) onRemoveInterest;

  const EditInterestsWidget({
    super.key,
    required this.interests,
    required this.onAddInterest,
    required this.onRemoveInterest,
  });

  void _showAddInterestDialog(BuildContext context) {
    final textController = TextEditingController();
    final primaryColor = AppColors.primaryOf(context);
    final textPrimaryColor = AppColors.textPrimaryOf(context);
    final textSecondaryColor = AppColors.textSecondaryOf(context);
    final borderColor = AppColors.borderOf(context);
    final cardSubtleColor = AppColors.cardSubtleBgOf(context);

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppColors.surfaceOf(context),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text(
          'Tambah Minat Belajar',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w800,
            color: textPrimaryColor,
          ),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Masukkan topik atau materi kuliah yang sedang kamu fokuskan:',
              style: TextStyle(fontSize: 12.5, color: textSecondaryColor),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: textController,
              autofocus: true,
              style: TextStyle(fontSize: 13.5, color: textPrimaryColor),
              textCapitalization: TextCapitalization.words,
              decoration: InputDecoration(
                hintText: 'Contoh: Machine Learning, Database',
                hintStyle: TextStyle(fontSize: 13, color: AppColors.textMutedOf(context)),
                filled: true,
                fillColor: cardSubtleColor,
                contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: borderColor),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: borderColor),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: primaryColor, width: 1.5),
                ),
              ),
              onSubmitted: (val) {
                if (val.trim().isNotEmpty) {
                  onAddInterest(val.trim());
                  Navigator.of(ctx).pop();
                }
              },
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: Text('Batal', style: TextStyle(color: textSecondaryColor)),
          ),
          ElevatedButton(
            onPressed: () {
              if (textController.text.trim().isNotEmpty) {
                onAddInterest(textController.text.trim());
                Navigator.of(ctx).pop();
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: primaryColor,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              elevation: 0,
            ),
            child: const Text(
              'Tambah',
              style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    ).then((_) => textController.dispose());
  }

  @override
  Widget build(BuildContext context) {
    final textPrimaryColor = AppColors.textPrimaryOf(context);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: AppColors.surfaceOf(context),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: AppColors.borderOf(context)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 14,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Topik / Minat Belajar Aktif',
            style: TextStyle(
              fontSize: 13.5,
              fontWeight: FontWeight.w700,
              color: textPrimaryColor,
            ),
          ),
          const SizedBox(height: 10),

          // Chips Wrap
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              for (final interest in interests)
                _buildInterestChip(
                  context: context,
                  label: interest,
                  onRemove: () => onRemoveInterest(interest),
                ),
            ],
          ),

          const SizedBox(height: 12),

          // Tombol "+ Tambah Minat" (Fresh Green Button)
          InkWell(
            onTap: () => _showAddInterestDialog(context),
            borderRadius: BorderRadius.circular(20),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
              decoration: BoxDecoration(
                color: AppColors.activeGreen,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.activeGreen.withValues(alpha: 0.35),
                    blurRadius: 6,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.add_rounded,
                    color: AppColors.darkDot,
                    size: 16,
                  ),
                  SizedBox(width: 4),
                  Text(
                    'Tambah Minat',
                    style: TextStyle(
                      fontSize: 11.5,
                      fontWeight: FontWeight.w700,
                      color: AppColors.darkDot,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInterestChip({
    required BuildContext context,
    required String label,
    required VoidCallback onRemove,
  }) {
    final primaryColor = AppColors.primaryOf(context);
    return Container(
      padding: const EdgeInsets.only(left: 14, right: 6, top: 6, bottom: 6),
      decoration: BoxDecoration(
        color: primaryColor,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: primaryColor.withValues(alpha: 0.25),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontSize: 11.5,
              fontWeight: FontWeight.w700,
              color: Colors.white,
            ),
          ),
          const SizedBox(width: 4),
          InkWell(
            onTap: onRemove,
            borderRadius: BorderRadius.circular(12),
            child: const Padding(
              padding: EdgeInsets.all(2),
              child: Icon(
                Icons.close_rounded,
                color: Colors.white,
                size: 14,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
