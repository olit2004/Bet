import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:bet/core/constants/app_colors.dart';

class BidInfoCard extends StatelessWidget {
  final String label;
  final String value;
  final IconData? icon;
  final bool isDark;

  const BidInfoCard({
    super.key,
    required this.label,
    required this.value,
    this.icon,
    this.isDark = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? AppColors.primaryLightBlue : const Color(0xFFEDF1F9),
        borderRadius: BorderRadius.circular(16),
        boxShadow: isDark
            ? [
                BoxShadow(
                  color: AppColors.primaryLightBlue.withValues(alpha: 0.3),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                )
              ]
            : null,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label.toUpperCase(),
            style: GoogleFonts.inter(
              color: isDark
                  ? Colors.white.withValues(alpha: 0.8)
                  : AppColors.secondaryText,
              fontSize: 10,
              fontWeight: FontWeight.w700,
              letterSpacing: 1.2,
            ),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              if (icon != null) ...[
                Icon(
                  icon,
                  size: 18,
                  color: isDark ? Colors.white : const Color(0xFF917325),
                ),
                const SizedBox(width: 6),
              ],
              Expanded(
                child: Text(
                  value,
                  style: GoogleFonts.manrope(
                    color: isDark ? Colors.white : AppColors.primaryText,
                    fontSize: 20,
                    fontWeight: FontWeight.w800,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
