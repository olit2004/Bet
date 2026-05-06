import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:bet/core/constants/app_colors.dart';

class ProfileStat extends StatelessWidget {
  final String value;
  final String label;
  final Color valueColor;

  const ProfileStat({
    super.key,
    required this.value,
    required this.label,
    this.valueColor = AppColors.primaryText,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          value,
          style: GoogleFonts.manrope(
            color: valueColor,
            fontSize: 36,
            fontWeight: FontWeight.w800,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          label,
          style: GoogleFonts.inter(
            color: AppColors.secondaryText,
            fontSize: 11,
            fontWeight: FontWeight.w600,
            letterSpacing: 1.0,
          ),
        ),
      ],
    );
  }
}
