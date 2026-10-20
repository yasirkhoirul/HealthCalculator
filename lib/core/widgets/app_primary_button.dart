import 'package:flutter/material.dart';
import '../constant/app_colors.dart';

/// Reusable primary button for StudyMap / HangoutMap with smooth animations,
/// custom gradients/colors, loading indicator, and optional leading/trailing icons.
class AppPrimaryButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final bool isLoading;
  final Color? backgroundColor;
  final Color textColor;
  final double height;
  final double borderRadius;
  final Widget? leadingIcon;
  final Widget? trailingIcon;
  final double? width;
  final EdgeInsetsGeometry padding;

  const AppPrimaryButton({
    super.key,
    required this.text,
    this.onPressed,
    this.isLoading = false,
    this.backgroundColor,
    this.textColor = Colors.white,
    this.height = 52.0,
    this.borderRadius = 26.0,
    this.leadingIcon,
    this.trailingIcon,
    this.width = double.infinity,
    this.padding = const EdgeInsets.symmetric(horizontal: 20),
  });

  @override
  Widget build(BuildContext context) {
    final effectiveBgColor = backgroundColor ?? AppColors.primary;

    return SizedBox(
      width: width,
      height: height,
      child: DecoratedBox(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(borderRadius),
          boxShadow: onPressed == null || isLoading
              ? null
              : [
                  BoxShadow(
                    color: effectiveBgColor.withValues(alpha: 0.35),
                    blurRadius: 16,
                    offset: const Offset(0, 6),
                  ),
                ],
        ),
        child: ElevatedButton(
          onPressed: isLoading ? null : onPressed,
          style: ElevatedButton.styleFrom(
            backgroundColor: effectiveBgColor,
            foregroundColor: textColor,
            disabledBackgroundColor: effectiveBgColor.withValues(alpha: 0.5),
            disabledForegroundColor: textColor.withValues(alpha: 0.7),
            elevation: 0,
            padding: padding,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(borderRadius),
            ),
          ),
          child: isLoading
              ? SizedBox(
                  width: 22,
                  height: 22,
                  child: CircularProgressIndicator(
                    strokeWidth: 2.5,
                    valueColor: AlwaysStoppedAnimation<Color>(textColor),
                  ),
                )
              : Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (leadingIcon != null) ...[
                      leadingIcon!,
                      const SizedBox(width: 8),
                    ],
                    Flexible(
                      child: Text(
                        text,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: textColor,
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                          letterSpacing: 0.2,
                        ),
                      ),
                    ),
                    if (trailingIcon != null) ...[
                      const SizedBox(width: 8),
                      trailingIcon!,
                    ],
                  ],
                ),
        ),
      ),
    );
  }
}
