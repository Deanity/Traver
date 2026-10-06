import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'app_colors.dart';

class AppTypography {
  AppTypography._();

  static TextStyle get display => GoogleFonts.urbanist(
        fontSize: 28,
        fontWeight: FontWeight.bold,
        height: 36 / 28,
        color: AppColors.textPrimary,
      );

  static TextStyle get heading1 => GoogleFonts.urbanist(
        fontSize: 24,
        fontWeight: FontWeight.bold,
        height: 32 / 24,
        color: AppColors.textPrimary,
      );

  static TextStyle get heading2 => GoogleFonts.urbanist(
        fontSize: 20,
        fontWeight: FontWeight.w600,
        height: 28 / 20,
        color: AppColors.textPrimary,
      );

  static TextStyle get title => GoogleFonts.urbanist(
        fontSize: 16,
        fontWeight: FontWeight.w600,
        height: 24 / 16,
        color: AppColors.textPrimary,
      );

  static TextStyle get body => GoogleFonts.urbanist(
        fontSize: 14,
        fontWeight: FontWeight.normal,
        height: 22 / 14,
        color: AppColors.textPrimary,
      );

  static TextStyle get bodyMedium => GoogleFonts.urbanist(
        fontSize: 14,
        fontWeight: FontWeight.w500,
        height: 22 / 14,
        color: AppColors.textPrimary,
      );

  static TextStyle get caption => GoogleFonts.urbanist(
        fontSize: 12,
        fontWeight: FontWeight.normal,
        height: 18 / 12,
        color: AppColors.textSecondary,
      );

  static TextStyle get overline => GoogleFonts.urbanist(
        fontSize: 10,
        fontWeight: FontWeight.w500,
        height: 14 / 10,
        color: AppColors.textSecondary,
      );
}
