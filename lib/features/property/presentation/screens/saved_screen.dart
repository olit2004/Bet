import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/constants/app_colors.dart';

class SavedScreen extends StatelessWidget {
  const SavedScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        title: Text(
          'Saved Properties',
          style: GoogleFonts.manrope(
            fontWeight: FontWeight.bold,
            color: AppColors.primaryText,
          ),
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.favorite_border, size: 64, color: AppColors.secondaryText.withValues(alpha: 0.3)),
            const SizedBox(height: 16),
            Text(
              'No saved properties yet',
              style: GoogleFonts.inter(
                fontSize: 16,
                color: AppColors.secondaryText,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
