import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:bet/core/constants/app_colors.dart';

/// A reusable card for displaying a performance metric with a large value,
/// subtitle description, and a decorative icon.
/// Used on the Seller Profile and potentially on analytics screens.
class PerformanceCard extends StatelessWidget {
  final String label;
  final String value;
  final String subtitle;
  final IconData icon;
  final Color valueColor;
  final Color? backgroundColor;

  const PerformanceCard({
    super.key,
    required this.label,
    required this.value,
    required this.subtitle,
    required this.icon,
    this.valueColor = AppColors.primaryText,
    this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: backgroundColor ?? AppColors.inputFill,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Stack(
        children: [
          // Content
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: GoogleFonts.inter(
                  color: AppColors.secondaryText,
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 0.5,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                value,
                style: GoogleFonts.manrope(
                  color: valueColor,
                  fontSize: 32,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                subtitle,
                style: GoogleFonts.inter(
                  color: AppColors.secondaryText.withValues(alpha: 0.7),
                  fontSize: 12,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ],
          ),
          // Decorative icon (top right)
          Positioned(
            top: 0,
            right: 0,
            child: Icon(
              icon,
              size: 32,
              color: AppColors.secondaryText.withValues(alpha: 0.2),
            ),
          ),
        ],
      ),
    );
  }
}
