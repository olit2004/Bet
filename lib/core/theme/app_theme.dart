import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../constants/app_colors.dart';

/// Defines the global theme configuration for the application.
class AppTheme {
  AppTheme._();

  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      scaffoldBackgroundColor: AppColors.background,
      cardColor: AppColors.surface,
      colorScheme: ColorScheme.fromSeed(
        seedColor: AppColors.primaryBlue,
        primary: AppColors.primaryBlue,
        surface: AppColors.surface,
        error: AppColors.error,
      ),
      textTheme: TextTheme(
        // Headings/Titles using Manrope and primaryText color
        displayLarge: GoogleFonts.manrope(color: AppColors.primaryText, fontSize: 32, fontWeight: FontWeight.bold),
        displayMedium: GoogleFonts.manrope(color: AppColors.primaryText, fontSize: 28, fontWeight: FontWeight.bold),
        displaySmall: GoogleFonts.manrope(color: AppColors.primaryText, fontSize: 24, fontWeight: FontWeight.bold),
        headlineLarge: GoogleFonts.manrope(color: AppColors.primaryText, fontSize: 22, fontWeight: FontWeight.w700),
        headlineMedium: GoogleFonts.manrope(color: AppColors.primaryText, fontSize: 20, fontWeight: FontWeight.w600),
        headlineSmall: GoogleFonts.manrope(color: AppColors.primaryText, fontSize: 18, fontWeight: FontWeight.w600),
        titleLarge: GoogleFonts.manrope(color: AppColors.primaryText, fontSize: 16, fontWeight: FontWeight.w600),
        titleMedium: GoogleFonts.manrope(color: AppColors.primaryText, fontSize: 14, fontWeight: FontWeight.w500),
        titleSmall: GoogleFonts.manrope(color: AppColors.primaryText, fontSize: 12, fontWeight: FontWeight.w500),

        // Body/Subtitles using Inter and secondaryText color
        bodyLarge: GoogleFonts.inter(color: AppColors.secondaryText, fontSize: 16, fontWeight: FontWeight.normal),
        bodyMedium: GoogleFonts.inter(color: AppColors.secondaryText, fontSize: 14, fontWeight: FontWeight.normal),
        bodySmall: GoogleFonts.inter(color: AppColors.secondaryText, fontSize: 12, fontWeight: FontWeight.normal),
        labelLarge: GoogleFonts.inter(color: AppColors.secondaryText, fontSize: 14, fontWeight: FontWeight.w500),
        labelMedium: GoogleFonts.inter(color: AppColors.secondaryText, fontSize: 12, fontWeight: FontWeight.w500),
        labelSmall: GoogleFonts.inter(color: AppColors.secondaryText, fontSize: 11, fontWeight: FontWeight.w500),
      ),
    );
  }
}
