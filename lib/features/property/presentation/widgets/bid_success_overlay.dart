import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:go_router/go_router.dart';
import 'package:bet/core/constants/app_colors.dart';

class BidSuccessOverlay extends StatelessWidget {
  const BidSuccessOverlay({super.key});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      backgroundColor: const Color(0xFFEAECEF),
      insetPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
      child: Stack(
        clipBehavior: Clip.none,
        alignment: Alignment.topCenter,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(24, 56, 24, 32),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Top close button
                Align(
                  alignment: Alignment.topRight,
                  child: GestureDetector(
                    onTap: () => context.pop(),
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: AppColors.primaryBlue.withValues(alpha: 0.1),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.close, color: AppColors.primaryBlue, size: 20),
                    ),
                  ),
                ),
                
                Text(
                  'Bid Accepted!',
                  style: Theme.of(context).textTheme.displayLarge?.copyWith(
                        color: AppColors.primaryText,
                        fontWeight: FontWeight.w900,
                        fontSize: 28,
                      ),
                ),
                const SizedBox(height: 16),
                RichText(
                  textAlign: TextAlign.center,
                  text: TextSpan(
                    style: GoogleFonts.inter(
                      color: AppColors.primaryText.withValues(alpha: 0.8),
                      fontSize: 14,
                      height: 1.5,
                    ),
                    children: const [
                      TextSpan(text: 'Congratulations! You have\naccepted the bid for the '),
                      TextSpan(
                        text: 'Skyline\nPenthouse',
                        style: TextStyle(fontWeight: FontWeight.w800),
                      ),
                      TextSpan(text: '. We are now initiating\nthe secure escrow process.'),
                    ],
                  ),
                ),
                const SizedBox(height: 32),
                
                // Final Sale Price Box
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: const Color(0xFFD6DFE8),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Row(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Image.asset(
                          'assets/images/properties/apartment.png',
                          width: 72,
                          height: 72,
                          fit: BoxFit.cover,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'FINAL SALE PRICE',
                              style: GoogleFonts.inter(
                                color: AppColors.primaryBlue,
                                fontSize: 10,
                                fontWeight: FontWeight.w800,
                                letterSpacing: 1.0,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              '18,450,000 Birr',
                              style: GoogleFonts.manrope(
                                color: const Color(0xFF00684A),
                                fontSize: 18,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 32),
                
                // List items
                _buildListItem(
                  icon: Icons.notifications_none,
                  textSpan: TextSpan(
                    style: GoogleFonts.inter(
                      color: AppColors.primaryText.withValues(alpha: 0.8),
                      fontSize: 13,
                      height: 1.5,
                    ),
                    children: const [
                      TextSpan(text: 'The buyer, '),
                      TextSpan(text: 'Abebe Tesfaye', style: TextStyle(fontWeight: FontWeight.w800)),
                      TextSpan(text: ', will be notified immediately.'),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                _buildListItem(
                  icon: Icons.gavel_rounded,
                  textSpan: TextSpan(
                    style: GoogleFonts.inter(
                      color: AppColors.primaryText.withValues(alpha: 0.8),
                      fontSize: 13,
                      height: 1.5,
                    ),
                    children: const [
                      TextSpan(text: 'Our legal team will reach out with the contract details within 24 hours.'),
                    ],
                  ),
                ),
                const SizedBox(height: 48),
                
                TextButton(
                  onPressed: () {
                    context.pop(); // close dialog
                    // You might want to pop back to dashboard here depending on routing setup
                  },
                  child: Text(
                    'Back to My Listings',
                    style: GoogleFonts.inter(
                      color: AppColors.primaryBlue,
                      fontSize: 16,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
              ],
            ),
          ),
          
          // Floating green checkmark circle
          Positioned(
            top: -40,
            child: Container(
              padding: const EdgeInsets.all(20),
              decoration: const BoxDecoration(
                color: Color(0xFF67E2A9),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.check,
                color: Color(0xFF00684A),
                size: 40,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildListItem({required IconData icon, required TextSpan textSpan}) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: AppColors.primaryBlue.withValues(alpha: 0.15),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: AppColors.primaryBlue, size: 20),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: RichText(text: textSpan),
        ),
      ],
    );
  }
}
