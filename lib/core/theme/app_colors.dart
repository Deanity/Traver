import 'package:flutter/material.dart';

class AppColors {
  AppColors._();

  // Primary Palette
  static const Color primary = Color(0xFFFFD43B);
  static const Color onPrimary = Color(0xFF1A1A1A);

  // Background & Surfaces
  static const Color background = Color(0xFFFFFFFF);
  static const Color surface = Color(0xFFF7F7F7);
  static const Color surfaceSecondary = Color(0xFFEEEEEE);

  // Text
  static const Color textPrimary = Color(0xFF1A1A1A);
  static const Color textSecondary = Color(0xFF8A8A8A);
  static const Color textLight = Color(0xFFFFFFFF);

  // Borders & Dividers
  static const Color border = Color(0xFFE8E8E8);

  // Semantic
  static const Color success = Color(0xFF2DBE60);
  static const Color error = Color(0xFFE5484D);
  static const Color warning = Color(0xFFF5A524);
  static const Color info = Color(0xFF3B82F6);

  // Overlays
  static const Color overlayDark = Color(0x80000000); // 50% black
  static const Color overlayGradientStart = Colors.transparent;
  static const Color overlayGradientEnd = Color(0xCC000000); // 80% black
}
