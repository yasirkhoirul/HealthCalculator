import 'package:flutter/material.dart';
import '../../../../core/constant/app_colors.dart';

/// Switch kustom bergaya modern dengan warna aktif hijau muda / lime (AppColors.activeGreen)
/// dan animasi transisi halus.
class LimeSwitchWidget extends StatelessWidget {
  final bool value;
  final ValueChanged<bool> onChanged;

  const LimeSwitchWidget({
    super.key,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onChanged(!value),
      behavior: HitTestBehavior.opaque,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeInOut,
        width: 50,
        height: 28,
        padding: const EdgeInsets.symmetric(horizontal: 3, vertical: 2),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: value ? AppColors.activeGreen : AppColors.borderOf(context),
        ),
        child: AnimatedAlign(
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeInOut,
          alignment: value ? Alignment.centerRight : Alignment.centerLeft,
          child: Container(
            width: 24,
            height: 24,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.surface,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.12),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
