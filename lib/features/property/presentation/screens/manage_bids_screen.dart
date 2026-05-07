import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:go_router/go_router.dart';
import 'package:bet/core/constants/app_colors.dart';
import '../widgets/bid_success_overlay.dart';

class ManageBidsScreen extends StatelessWidget {
  final String propertyId;

  const ManageBidsScreen({super.key, required this.propertyId});

  @override
  Widget build(BuildContext context) {
    const bgColor = Color(0xFFEAECEF);

    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        backgroundColor: bgColor,
        elevation: 0,
        centerTitle: false,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.primaryLightBlue),
          onPressed: () => context.pop(),
        ),
        title: Text(
          'Manage Bids',
          style: GoogleFonts.manrope(
            color: AppColors.primaryLightBlue,
            fontSize: 18,
            fontWeight: FontWeight.w800,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Title
            Text(
              'PROPERTY LISTING',
              style: GoogleFonts.inter(
                color: AppColors.primaryBlue,
                fontSize: 11,
                fontWeight: FontWeight.w800,
                letterSpacing: 1.5,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Skyline Penthouse',
              style: Theme.of(context).textTheme.displayLarge?.copyWith(
                    color: const Color(0xFF0C2442), // Deep blue/black
                    fontWeight: FontWeight.w900,
                  ),
            ),
            const SizedBox(height: 24),

            // Top Stats (Total Bids / Highest Bid)
            Row(
              children: [
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF1F3F6), // Slightly lighter gray than bg
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'TOTAL BIDS',
                          style: GoogleFonts.inter(
                            color: AppColors.primaryBlue,
                            fontSize: 10,
                            fontWeight: FontWeight.w800,
                            letterSpacing: 1.0,
                          ),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          '14',
                          style: GoogleFonts.manrope(
                            color: AppColors.primaryLightBlue,
                            fontSize: 32,
                            fontWeight: FontWeight.w900,
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
                      color: AppColors.primaryLightBlue,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.primaryLightBlue.withValues(alpha: 0.2),
                          blurRadius: 12,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'HIGHEST BID',
                          style: GoogleFonts.inter(
                            color: Colors.white.withValues(alpha: 0.8),
                            fontSize: 10,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 1.0,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          '4,850,\n000 Birr',
                          style: GoogleFonts.manrope(
                            color: Colors.white,
                            fontSize: 22,
                            fontWeight: FontWeight.w800,
                            height: 1.2,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Time Remaining Box
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
              decoration: BoxDecoration(
                color: const Color(0xFFDCDFE5), // Slightly darker gray/blue
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'TIME REMAINING',
                    style: GoogleFonts.inter(
                      color: AppColors.primaryBlue,
                      fontSize: 10,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 1.0,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      const Icon(
                        Icons.timer_outlined,
                        color: Color(0xFF917325),
                        size: 20,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        '02h 45m',
                        style: GoogleFonts.manrope(
                          color: const Color(0xFF917325),
                          fontSize: 24,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),

            // Bids List
            _BidCard(
              name: 'Abebe Tesfaye',
              price: '4,850,000 Birr',
              timeAgo: '2 MINS AGO',
              imageUrl: 'https://i.pravatar.cc/150?img=11',
              isHighest: true,
              isAcceptable: true,
            ),
            const SizedBox(height: 16),
            _BidCard(
              name: 'Selam Kebede',
              price: '4,825,000 Birr',
              timeAgo: '15 MINS AGO',
              imageUrl: 'https://i.pravatar.cc/150?img=5',
              isHighest: false,
              isAcceptable: false,
            ),
            const SizedBox(height: 16),
            _BidCard(
              name: 'Tola Bedhesa',
              price: '4,790,000 Birr',
              timeAgo: '1 HOUR AGO',
              imageUrl: 'https://i.pravatar.cc/150?img=33',
              isHighest: false,
              isAcceptable: false,
            ),
            const SizedBox(height: 32),

            // Previous Bids
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: const Color(0xFFE2E7ED),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'PREVIOUS BIDS',
                    style: GoogleFonts.inter(
                      color: AppColors.primaryBlue,
                      fontSize: 10,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 1.0,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      CircleAvatar(
                        radius: 16,
                        backgroundColor: AppColors.primaryLightBlue.withValues(alpha: 0.2),
                        child: Text(
                          'SC',
                          style: GoogleFonts.inter(
                            color: AppColors.primaryBlue,
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Text(
                        'Sarah Cala',
                        style: GoogleFonts.inter(
                          color: AppColors.primaryText,
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const Spacer(),
                      Text(
                        '4,750,000 Birr',
                        style: GoogleFonts.manrope(
                          color: AppColors.primaryBlue,
                          fontSize: 14,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _BidCard extends StatelessWidget {
  final String name;
  final String price;
  final String timeAgo;
  final String imageUrl;
  final bool isHighest;
  final bool isAcceptable;

  const _BidCard({
    required this.name,
    required this.price,
    required this.timeAgo,
    required this.imageUrl,
    required this.isHighest,
    required this.isAcceptable,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFEAECEF),
        borderRadius: BorderRadius.circular(16),
        boxShadow: isHighest
            ? [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.04),
                  blurRadius: 20,
                  offset: const Offset(-8, 4),
                )
              ]
            : [],
      ),
      child: Stack(
        children: [
          // Left dark border line for the highest bid
          if (isHighest)
            Positioned(
              left: 0,
              top: 24,
              bottom: 24,
              child: Container(
                width: 3,
                decoration: BoxDecoration(
                  color: const Color(0xFF132D46),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
          
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Highest bid badge
                if (isHighest) ...[
                  Align(
                    alignment: Alignment.topRight,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: const Color(0xFF67E2A9),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        'HIGHEST BID',
                        style: GoogleFonts.inter(
                          color: const Color(0xFF00684A),
                          fontSize: 9,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                ],
                
                // User info and bid row
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    CircleAvatar(
                      radius: 20,
                      backgroundImage: NetworkImage(imageUrl),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            name,
                            style: GoogleFonts.inter(
                              color: const Color(0xFF0C2442),
                              fontSize: 15,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          Text(
                            'Verified Buyer',
                            style: GoogleFonts.inter(
                              color: AppColors.primaryBlue,
                              fontSize: 11,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          price,
                          style: GoogleFonts.manrope(
                            color: isHighest ? const Color(0xFF00684A) : const Color(0xFF0C2442),
                            fontSize: 18,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          timeAgo,
                          style: GoogleFonts.inter(
                            color: AppColors.primaryBlue,
                            fontSize: 10,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 1.0,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                
                // Actions row
                Row(
                  children: [
                    if (isAcceptable) ...[
                      Expanded(
                        flex: 3,
                        child: SizedBox(
                          height: 48,
                          child: OutlinedButton(
                            onPressed: () {
                              context.push('/review-bid/skyline-123');
                            },
                            style: OutlinedButton.styleFrom(
                              side: BorderSide(
                                color: AppColors.primaryBlue.withValues(alpha: 0.2),
                                width: 1.5,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              padding: EdgeInsets.zero,
                            ),
                            child: Text(
                              'Review',
                              style: GoogleFonts.manrope(
                                color: AppColors.primaryBlue,
                                fontSize: 14,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                    ],
                    Expanded(
                      flex: 5,
                      child: SizedBox(
                        height: 48,
                        child: ElevatedButton(
                          onPressed: () {
                            if (isAcceptable) {
                              showDialog(
                                context: context,
                                builder: (context) => const BidSuccessOverlay(),
                              );
                            } else {
                              context.push('/review-bid/skyline-123');
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: isAcceptable 
                                ? AppColors.primaryLightBlue 
                                : const Color(0xFFD6DFE8),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            elevation: 0,
                          ),
                          child: Text(
                            isAcceptable ? 'Accept Bid' : 'Review Bidder',
                            style: GoogleFonts.manrope(
                              color: isAcceptable ? Colors.white : const Color(0xFF0C2442),
                              fontSize: 14,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
