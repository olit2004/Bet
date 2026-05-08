import 'package:flutter/material.dart';

/// Defines the color palette for the entire application based on the Figma design system.
class AppColors {
  AppColors._(); // Private constructor to prevent instantiation

  // Solid Colors
  static const Color primaryBlue = Color(0xFF3F51F3); // More vibrant Indigo-Blue
  static const Color primaryLightBlue = Color(0xFF5366FC);

  static const Color background = Color(0xFFF5F7FC);
  static const Color surface = Color(0xFFFFFFFF);
  static const Color inputFill = Color(0xFFF1F4F9);
  static const Color chipBackground = Color(0xFFE8EAF6); // Lavender-ish light blue

  static const Color primaryText = Color(0xFF05345C);
  static const Color secondaryText = Color(0xFF3D618C);

  static const Color success = Color(0xFF28A745);
  static const Color error = Color(0xFFFF4D4F);

  // New Design Colors
  static const Color verifiedGreen = Color(0xFF5CE7B4);
  static const Color verifiedText = Color(0xFF0C6B49);
  static const Color bidOrange = Color(0xFFF9A825);
  static const Color bannerGrey = Color(0xFFE0E0E0);
  static const Color secondaryContainer = Color(0xFFE8F1FF); // Very light blue for specs/price cards
  static const Color navItemSelection = Color(0xFFE8EAF6);

  // Gradients
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [primaryBlue, primaryLightBlue],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
}
