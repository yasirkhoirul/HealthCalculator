import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

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
    final effectiveBgColor = backgroundColor ?? AppColors.primaryOf(context);

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
            shadowColor: Colors.transparent,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(borderRadius),
            ),
            padding: padding,
          ),
          child: isLoading
              ? const SizedBox(
                  width: 22,
                  height: 22,
                  child: CircularProgressIndicator(
                    strokeWidth: 2.5,
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
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
                        style: TextStyle(
                          fontSize: 15.5,
                          fontWeight: FontWeight.w700,
                          color: textColor,
                          letterSpacing: 0.2,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
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
