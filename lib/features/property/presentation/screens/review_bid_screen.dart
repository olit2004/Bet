import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:go_router/go_router.dart';
import 'package:bet/core/constants/app_colors.dart';
import '../widgets/bid_success_overlay.dart';

class ReviewBidScreen extends StatelessWidget {
  final String bidId; // Or propertyId

  const ReviewBidScreen({super.key, required this.bidId});

  @override
  Widget build(BuildContext context) {
    const bgColor = Color(0xFFEAECEF);

    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        backgroundColor: bgColor,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.primaryBlue),
          onPressed: () => context.pop(),
        ),
        title: Text(
          'Review Bid',
          style: GoogleFonts.manrope(
            color: AppColors.primaryBlue,
            fontSize: 18,
            fontWeight: FontWeight.w900,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.more_vert, color: AppColors.primaryBlue),
            onPressed: () {},
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Property Info Card
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFFF1F3F6),
                borderRadius: BorderRadius.circular(24),
              ),
              child: Row(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: Container(
                      width: 64,
                      height: 64,
                      color: const Color(0xFF267D8F), // Approximate tint for the image
                      child: Image.asset(
                        'assets/images/properties/apartment.png',
                        fit: BoxFit.cover,
                        color: const Color(0xFF267D8F).withValues(alpha: 0.5), // Subtle tint
                        colorBlendMode: BlendMode.srcATop,
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Yeka, Addis Ababa',
                          style: GoogleFonts.inter(
                            color: AppColors.primaryBlue.withValues(alpha: 0.8),
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Skyline Penthouse',
                          style: GoogleFonts.inter(
                            color: const Color(0xFF0C2442),
                            fontSize: 16,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Bidder Card
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: const Color(0xFFDCDFE5), // Darker gray/blue
                borderRadius: BorderRadius.circular(24),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CircleAvatar(
                        radius: 28,
                        backgroundImage: const NetworkImage('https://i.pravatar.cc/150?img=11'),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Abebe\nTesfaye',
                              style: GoogleFonts.inter(
                                color: const Color(0xFF0C2442),
                                fontSize: 16,
                                fontWeight: FontWeight.w800,
                                height: 1.2,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                              decoration: BoxDecoration(
                                color: const Color(0xFF67E2A9),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Text(
                                'VERIFIED',
                                style: GoogleFonts.inter(
                                  color: const Color(0xFF00684A),
                                  fontSize: 10,
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            'STATS',
                            style: GoogleFonts.inter(
                              color: AppColors.primaryBlue.withValues(alpha: 0.8),
                              fontSize: 10,
                              fontWeight: FontWeight.w700,
                              letterSpacing: 1.0,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Member since 2019',
                            style: GoogleFonts.inter(
                              color: const Color(0xFF0C2442),
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            '10 Successful\nAcquisitions',
                            textAlign: TextAlign.right,
                            style: GoogleFonts.inter(
                              color: const Color(0xFF00684A),
                              fontSize: 11,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  Text(
                    'Verified Buyer',
                    style: GoogleFonts.inter(
                      color: AppColors.primaryBlue.withValues(alpha: 0.8),
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 12),
                  // Quote Box
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: const Color(0xFFEBECEE), // Lighter inner box
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Text(
                      '"We are prepared to close\nimmediately and have our\nproof of funds ready for\nreview."',
                      style: GoogleFonts.inter(
                        color: AppColors.primaryBlue.withValues(alpha: 0.8),
                        fontSize: 16,
                        fontStyle: FontStyle.italic,
                        height: 1.5,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 40),

            // Current Offer
            Text(
              'CURRENT OFFER',
              style: GoogleFonts.inter(
                color: AppColors.primaryBlue.withValues(alpha: 0.8),
                fontSize: 11,
                fontWeight: FontWeight.w800,
                letterSpacing: 1.5,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              '\$4,850,000',
              style: GoogleFonts.manrope(
                color: const Color(0xFF0C2442),
                fontSize: 48,
                fontWeight: FontWeight.w900,
                letterSpacing: -1.0,
              ),
            ),
            const SizedBox(height: 32),

            // Info Boxes (Payment Type & Closing Time)
            Row(
              children: [
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: const Color(0xFFDCDFE5), // Darker gray/blue
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Column(
                      children: [
                        const Icon(Icons.money, color: AppColors.primaryBlue, size: 24),
                        const SizedBox(height: 12),
                        Text(
                          'PAYMENT TYPE',
                          style: GoogleFonts.inter(
                            color: AppColors.primaryBlue.withValues(alpha: 0.8),
                            fontSize: 9,
                            fontWeight: FontWeight.w800,
                            letterSpacing: 1.0,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'All-cash offer',
                          textAlign: TextAlign.center,
                          style: GoogleFonts.inter(
                            color: const Color(0xFF0C2442),
                            fontSize: 14,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: const Color(0xFFDCDFE5), // Darker gray/blue
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Column(
                      children: [
                        const Icon(Icons.access_time, color: AppColors.primaryBlue, size: 24),
                        const SizedBox(height: 12),
                        Text(
                          'CLOSING TIME',
                          style: GoogleFonts.inter(
                            color: AppColors.primaryBlue.withValues(alpha: 0.8),
                            fontSize: 9,
                            fontWeight: FontWeight.w800,
                            letterSpacing: 1.0,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          '24-hour\nescrow',
                          textAlign: TextAlign.center,
                          style: GoogleFonts.inter(
                            color: const Color(0xFF0C2442),
                            fontSize: 14,
                            fontWeight: FontWeight.w800,
                            height: 1.3,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 48),

            // Actions
            SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton.icon(
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (context) => const BidSuccessOverlay(),
                  );
                },
                icon: const Icon(Icons.check_circle_outline, color: Colors.white, size: 20),
                label: Text(
                  'Accept Bid',
                  style: GoogleFonts.manrope(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryLightBlue,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  elevation: 4,
                  shadowColor: AppColors.primaryLightBlue.withValues(alpha: 0.4),
                ),
              ),
            ),
            const SizedBox(height: 24),
            TextButton(
              onPressed: () {
                context.pop();
              },
              child: Text(
                'DECLINE OFFER',
                style: GoogleFonts.inter(
                  color: const Color(0xFFA55A5A), // Desaturated red/maroon
                  fontSize: 13,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 1.5,
                ),
              ),
            ),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }
}
