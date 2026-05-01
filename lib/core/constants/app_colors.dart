import 'package:flutter/material.dart';

/// Defines the color palette for the entire application based on the Figma design system.
class AppColors {
  AppColors._(); // Private constructor to prevent instantiation

  // Solid Colors
  static const Color primaryBlue = Color(0xFF374CE2);
  static const Color primaryLightBlue = Color(0xFF5366FC);

  static const Color background = Color(0xFFF5F7FC);
  static const Color surface = Color(0xFFFFFFFF);
  static const Color inputFill = Color(0xFFF1F4F9);
  static const Color cardBackground = Color(0xFF9CB0C4); // Added for login section

  static const Color primaryText = Color(0xFF05345C);
  static const Color secondaryText = Color(0xFF3D618C);

  static const Color success = Color(0xFF28A745);
  static const Color error = Color(0xFFFF4D4F);

  // Gradients
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [primaryBlue, primaryLightBlue],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
}
