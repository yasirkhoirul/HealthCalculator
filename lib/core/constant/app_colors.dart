import 'package:flutter/material.dart';

/// App color constants for StudyMap / HangoutMap.
/// Follows lib/core/constant/ convention in ARCHITECTURE.md.
abstract class AppColors {
  // Primary Indigo / Royal Blue palette
  static const Color primary = Color(0xFF2C2CB4);
  static const Color primaryDark = Color(0xFF1E1E8F);
  static const Color primaryLight = Color(0xFFE8EEFF);
  static const Color primaryBorder = Color(0xFFC7D7FE);

  // Background and Surfaces
  static const Color background = Color(0xFFFAFAFA);
  static const Color surface = Colors.white;
  static const Color cardSubtleBg = Color(0xFFF1F5FD);
  static const Color border = Color(0xFFE2E8F0);
  static const Color borderSubtle = Color(0xFFF1F5F9);

  // Typography
  static const Color textPrimary = Color(0xFF0F172A);
  static const Color textSecondary = Color(0xFF64748B);
  static const Color textMuted = Color(0xFF94A3B8);
  static const Color textBody = Color(0xFF475569);

  // Indicators & Badges
  static const Color activeGreen = Color(0xFF84CC16);
  static const Color successGreen = Color(0xFF15803D);
  static const Color successLight = Color(0xFFDCFCE7);
  static const Color darkDot = Color(0xFF14532D);

  // Floating Student Markers
  static const Color studentAvatarPurple = Color(0xFF4338CA);
  static const Color studentAvatarSlate = Color(0xFF1E293B);
  static const Color studentAvatarOlive = Color(0xFF4D7C0F);

  // Social / Google
  static const Color googleBlue = Color(0xFF4285F4);
  static const Color googleGreen = Color(0xFF34A853);
  static const Color googleYellow = Color(0xFFFBBC05);
  static const Color googleRed = Color(0xFFEA4335);

  // Feedback
  static const Color error = Color(0xFFEF4444);
  static const Color errorDark = Color(0xFFDC2626);

  // Dark Palette (Sleek Slate & Indigo Dark Mode)
  static const Color darkBackground = Color(0xFF0B0F19);
  static const Color darkSurface = Color(0xFF161F30);
  static const Color darkCardSubtleBg = Color(0xFF1E293B);
  static const Color darkBorder = Color(0xFF2E3D52);
  static const Color darkBorderSubtle = Color(0xFF1F2B3E);

  static const Color darkTextPrimary = Color(0xFFF8FAFC);
  static const Color darkTextSecondary = Color(0xFF94A3B8);
  static const Color darkTextMuted = Color(0xFF64748B);
  static const Color darkTextBody = Color(0xFFCBD5E1);

  static const Color darkPrimary = Color(0xFF4F46E5);
  static const Color darkPrimaryLight = Color(0xFF1E1B4B);
  static const Color darkPrimaryBorder = Color(0xFF3730A3);

  static const Color darkSuccessLight = Color(0xFF064E3B);

  // Context-aware dynamic color getters
  static bool isDark(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark;

  static Color backgroundOf(BuildContext context) =>
      isDark(context) ? darkBackground : background;

  static Color surfaceOf(BuildContext context) =>
      isDark(context) ? darkSurface : surface;

  static Color cardSubtleBgOf(BuildContext context) =>
      isDark(context) ? darkCardSubtleBg : cardSubtleBg;

  static Color borderOf(BuildContext context) =>
      isDark(context) ? darkBorder : border;

  static Color borderSubtleOf(BuildContext context) =>
      isDark(context) ? darkBorderSubtle : borderSubtle;

  static Color textPrimaryOf(BuildContext context) =>
      isDark(context) ? darkTextPrimary : textPrimary;

  static Color textSecondaryOf(BuildContext context) =>
      isDark(context) ? darkTextSecondary : textSecondary;

  static Color textMutedOf(BuildContext context) =>
      isDark(context) ? darkTextMuted : textMuted;

  static Color textBodyOf(BuildContext context) =>
      isDark(context) ? darkTextBody : textBody;

  static Color primaryOf(BuildContext context) =>
      isDark(context) ? darkPrimary : primary;

  static Color primaryLightOf(BuildContext context) =>
      isDark(context) ? darkPrimaryLight : primaryLight;

  static Color primaryBorderOf(BuildContext context) =>
      isDark(context) ? darkPrimaryBorder : primaryBorder;

  static Color successLightOf(BuildContext context) =>
      isDark(context) ? darkSuccessLight : successLight;
}
