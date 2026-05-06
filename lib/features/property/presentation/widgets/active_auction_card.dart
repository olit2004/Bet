import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:bet/core/constants/app_colors.dart';

class ActiveAuctionCard extends StatelessWidget {
  final String imageUrl;
  final bool isVerified;
  final String timeRemaining;
  final String title;
  final String location;
  final String currentBid;
  final int bidsPlaced;
  final String? trendLabel;
  final VoidCallback onManageAuction;
  final VoidCallback? onTap;

  const ActiveAuctionCard({
    super.key,
    required this.imageUrl,
    this.isVerified = false,
    required this.timeRemaining,
    required this.title,
    required this.location,
    required this.currentBid,
    required this.bidsPlaced,
    this.trendLabel,
    required this.onManageAuction,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors
            .transparent, // Let the background show through if any, or maybe white
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Image Section ──
          GestureDetector(
            onTap: onTap,
            child: _buildImageSection(context),
          ),
          const SizedBox(height: 16),

            // ── Title & Price Section ──
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: Theme.of(context).textTheme.headlineMedium
                            ?.copyWith(
                              fontWeight: FontWeight.w800,
                              height: 1.2,
                            ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        location,
                        style: GoogleFonts.inter(
                          color: AppColors.secondaryText,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      'CURRENT BID',
                      style: GoogleFonts.inter(
                        color: AppColors.secondaryText,
                        fontSize: 10,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 1.0,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      currentBid,
                      style: GoogleFonts.manrope(
                        color: const Color(0xFF00684A), // Green price color
                        fontSize: 18,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 16),

            // ── Divider ──
            Divider(
              color: AppColors.secondaryText.withValues(alpha: 0.15),
              thickness: 1,
              height: 1,
            ),
            const SizedBox(height: 16),

            // ── Bids Info & Manage Button ──
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.people_outline_rounded,
                      color: AppColors.secondaryText,
                      size: 20,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      '$bidsPlaced Bids\nplaced',
                      style: GoogleFonts.inter(
                        color: AppColors.primaryText,
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        height: 1.2,
                      ),
                    ),
                  ],
                ),
                if (trendLabel != null)
                  Row(
                    children: [
                      Icon(
                        Icons.trending_up_rounded,
                        color: AppColors.secondaryText,
                        size: 20,
                      ),
                      const SizedBox(width: 6),
                      Text(
                        trendLabel!,
                        style: GoogleFonts.inter(
                          color: AppColors.primaryText,
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
              ],
            ),
            const SizedBox(height: 20),

            SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton(
                onPressed: onManageAuction,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryLightBlue,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(24), // Pill shape
                  ),
                  elevation: 0,
                ),
                child: Text(
                  'Manage Auction',
                  style: GoogleFonts.manrope(
                    color: Colors.white,
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),
          ],
        ),
      );
  }

  Widget _buildImageSection(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: SizedBox(
        height: 220,
        width: double.infinity,
        child: Stack(
          fit: StackFit.expand,
          children: [
            // Property image
            if (imageUrl.startsWith('assets/'))
              Image.asset(imageUrl, fit: BoxFit.cover)
            else
              Image.network(
                imageUrl,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    color: AppColors.inputFill,
                    child: const Center(
                      child: Icon(
                        Icons.image_outlined,
                        size: 48,
                        color: AppColors.secondaryText,
                      ),
                    ),
                  );
                },
              ),

            // Verified Badge (top left)
            if (isVerified)
              Positioned(
                top: 16,
                left: 16,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFF67E2A9), // Light green
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    'VERIFIED',
                    style: GoogleFonts.inter(
                      color: AppColors.primaryText,
                      fontSize: 11,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 0.5,
                    ),
                  ),
                ),
              ),
            // Listing Type Badge (if 'isVerified' is false but we need 'LISTING', shown in second screenshot)
            if (!isVerified)
              Positioned(
                top: 16,
                left: 16,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFF67E2A9), // Light green
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    'LISTING',
                    style: GoogleFonts.inter(
                      color: AppColors.primaryText,
                      fontSize: 11,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 0.5,
                    ),
                  ),
                ),
              ),

            // Time remaining badge (bottom left)
            Positioned(
              bottom: 16,
              left: 16,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.9),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.timer_outlined,
                      size: 16,
                      color: Color(0xFF917325), // Bronze/gold color
                    ),
                    const SizedBox(width: 6),
                    Text(
                      timeRemaining,
                      style: GoogleFonts.inter(
                        color: AppColors.primaryText,
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
