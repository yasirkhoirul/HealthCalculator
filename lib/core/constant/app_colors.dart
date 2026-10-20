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
}
