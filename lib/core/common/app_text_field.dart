import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

/// Reusable modern rounded text field component for StudyMap.
class AppTextField extends StatelessWidget {
  final TextEditingController? controller;
  final String? hintText;
  final String? labelText;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final TextInputType? keyboardType;
  final bool obscureText;
  final String? Function(String?)? validator;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onFieldSubmitted;
  final bool enabled;
  final double borderRadius;
  final Color? fillColor;
  final Color? borderColor;
  final Color? focusedBorderColor;
  final EdgeInsetsGeometry contentPadding;

  const AppTextField({
    super.key,
    this.controller,
    this.hintText,
    this.labelText,
    this.prefixIcon,
    this.suffixIcon,
    this.keyboardType,
    this.obscureText = false,
    this.validator,
    this.onChanged,
    this.onFieldSubmitted,
    this.enabled = true,
    this.borderRadius = 24.0,
    this.fillColor,
    this.borderColor,
    this.focusedBorderColor,
    this.contentPadding =
        const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
  });

  @override
  Widget build(BuildContext context) {
    final effectiveFillColor = fillColor ?? AppColors.surfaceOf(context);
    final effectiveBorderColor = borderColor ?? AppColors.borderOf(context);
    final effectiveFocusedBorderColor =
        focusedBorderColor ?? AppColors.primaryOf(context);

    return TextFormField(
      controller: controller,
      enabled: enabled,
      obscureText: obscureText,
      keyboardType: keyboardType,
      validator: validator,
      onChanged: onChanged,
      onFieldSubmitted: onFieldSubmitted,
      style: TextStyle(
        fontSize: 15,
        color: AppColors.textPrimaryOf(context),
      ),
      decoration: InputDecoration(
        filled: true,
        fillColor: effectiveFillColor,
        hintText: hintText,
        hintStyle: TextStyle(
          fontSize: 14.5,
          color: AppColors.textMutedOf(context),
        ),
        labelText: labelText,
        labelStyle: TextStyle(
          fontSize: 14.5,
          color: AppColors.textSecondaryOf(context),
        ),
        prefixIcon: prefixIcon,
        suffixIcon: suffixIcon,
        contentPadding: contentPadding,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(borderRadius),
          borderSide: BorderSide(color: effectiveBorderColor, width: 1.0),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(borderRadius),
          borderSide: BorderSide(color: effectiveBorderColor, width: 1.0),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(borderRadius),
          borderSide:
              BorderSide(color: effectiveFocusedBorderColor, width: 1.8),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(borderRadius),
          borderSide:
              BorderSide(color: AppColors.primaryRedOf(context), width: 1.2),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(borderRadius),
          borderSide:
              BorderSide(color: AppColors.primaryRedOf(context), width: 1.8),
        ),
      ),
    );
  }
}
