import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:bet/core/constants/app_colors.dart';

class SellerButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final Color? color;
  final Color? textColor;
  final double? width;
  final double? height;
  final IconData? icon;
  final BoxBorder? border;

  const SellerButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.color,
    this.textColor,
    this.width,
    this.height,
    this.icon,
    this.border,
  });

  @override
  Widget build(BuildContext context) {
    // If it's a simple button with no icon or border, we could use CustomButton.
    // However, to maintain the professional seller look (shadows, specific heights),
    // we'll implement it here to ensure consistency across the seller feature.
    
    return Container(
      width: width ?? double.infinity,
      height: height ?? 56.0,
      decoration: BoxDecoration(
        color: color,
        gradient: (color == null && border == null) ? AppColors.primaryGradient : null,
        borderRadius: BorderRadius.circular(20.0),
        border: border,
        boxShadow: (color == null && border == null)
            ? [
                BoxShadow(
                  color: AppColors.primaryBlue.withValues(alpha: 0.35),
                  blurRadius: 16,
                  offset: const Offset(0, 6),
                ),
              ]
            : [],
      ),
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.0),
          ),
          padding: EdgeInsets.zero,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (icon != null) ...[
              Icon(icon, color: textColor ?? Colors.white, size: 20),
              const SizedBox(width: 10),
            ],
            Text(
              text,
              style: GoogleFonts.manrope(
                color: textColor ?? Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 16.0,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
