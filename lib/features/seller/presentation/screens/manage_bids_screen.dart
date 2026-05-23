import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:go_router/go_router.dart';
import 'package:bet/core/constants/app_colors.dart';
import 'package:bet/features/seller/presentation/widgets/bid_success_overlay.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:bet/features/seller/presentation/providers/property_detail_provider.dart';

class ManageBidsScreen extends ConsumerWidget {
  final String propertyId;

  const ManageBidsScreen({super.key, required this.propertyId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final propertyAsync = ref.watch(propertyDetailProvider(propertyId));
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
        actions: [
          CircleAvatar(
            radius: 18,
            backgroundImage: const AssetImage(
              'assets/images/seller_profile.png',
            ),
          ),
          const SizedBox(width: 16),
        ],
      ),
      body: propertyAsync.when(
        loading: () => const Center(
          child: CircularProgressIndicator(color: AppColors.primaryBlue),
        ),
        error: (err, stack) => Center(
          child: Text(
            'Failed to load bids: $err',
            style: const TextStyle(color: AppColors.error),
          ),
        ),
        data: (property) {
          final isAuction = property.listingType == 'AUCTION';
          
          // Get the list of offers (either bids or proposals)
          final List<dynamic> offers = isAuction
              ? (property.bids ?? [])
              : (property.proposals ?? []);
          
          final totalOffers = offers.length;
          
          double highestOffer = 0;
          if (offers.isNotEmpty) {
            highestOffer = offers.map((o) => (o.amount as num?)?.toDouble() ?? 0.0).reduce((a, b) => a > b ? a : b);
          }

          // Calculate time remaining
          String timeRemaining = 'N/A';
          if (property.endTime != null) {
            final diff = property.endTime!.difference(DateTime.now());
            if (diff.isNegative) {
              timeRemaining = 'Ended';
            } else {
              final hours = diff.inHours;
              final minutes = diff.inMinutes % 60;
              timeRemaining = '${hours}h ${minutes}m';
            }
          }

          return SingleChildScrollView(
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
                  property.title,
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
                          color: const Color(
                            0xFFF1F3F6,
                          ), // Slightly lighter gray than bg
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              isAuction ? 'TOTAL BIDS' : 'PROPOSALS',
                              style: GoogleFonts.inter(
                                color: AppColors.primaryBlue,
                                fontSize: 10,
                                fontWeight: FontWeight.w800,
                                letterSpacing: 1.0,
                              ),
                            ),
                            const SizedBox(height: 12),
                            Text(
                              totalOffers.toString(),
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
                              color: AppColors.primaryLightBlue.withValues(
                                alpha: 0.2,
                              ),
                              blurRadius: 12,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              isAuction ? 'HIGHEST BID' : 'HIGHEST OFFER',
                              style: GoogleFonts.inter(
                                color: Colors.white.withValues(alpha: 0.8),
                                fontSize: 10,
                                fontWeight: FontWeight.w700,
                                letterSpacing: 1.0,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              highestOffer > 0 ? '${highestOffer.toStringAsFixed(0)} Birr' : '--',
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
                if (isAuction) ...[
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
                              timeRemaining,
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
                ],

                if (offers.isEmpty)
                  const Padding(
                    padding: EdgeInsets.only(top: 48.0),
                    child: Center(
                      child: Text(
                        'No offers yet.',
                        style: TextStyle(color: AppColors.secondaryText),
                      ),
                    ),
                  )
                else ...[
                  // List all offers dynamically
                  ...offers.asMap().entries.map((entry) {
                    final index = entry.key;
                    final offer = entry.value;
                    
                    // Simple logic to display time ago (you can use a package like timeago in real app)
                    String timeAgo = '';
                    if (offer.createdAt != null) {
                      final diff = DateTime.now().difference(offer.createdAt!);
                      if (diff.inMinutes < 60) {
                        timeAgo = '${diff.inMinutes} MINS AGO';
                      } else if (diff.inHours < 24) {
                        timeAgo = '${diff.inHours} HOURS AGO';
                      } else {
                        timeAgo = '${diff.inDays} DAYS AGO';
                      }
                    }

                    // For now we set the first one as highest for visual effect assuming they are sorted by backend
                    final isHighestOffer = index == 0 && highestOffer > 0;
                    
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 16.0),
                      child: _BidCard(
                        bidId: offer.id,
                        propertyId: property.id,
                        name: offer.bidderName ?? 'Anonymous',
                        price: '${offer.amount?.toStringAsFixed(0) ?? '--'} Birr',
                        timeAgo: timeAgo,
                        imageUrl: 'assets/images/bidder_${(index % 2) + 1}.png',
                        isHighest: isHighestOffer,
                        isAcceptable: offer.status == 'PENDING' || offer.status == 'ACTIVE',
                        isAuction: isAuction,
                      ),
                    );
                  }),
                ],
                const SizedBox(height: 32),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _BidCard extends StatelessWidget {
  final String propertyId;
  final String bidId;
  final String name;
  final String price;
  final String timeAgo;
  final String imageUrl;
  final bool isHighest;
  final bool isAcceptable;
  final bool isAuction;

  const _BidCard({
    required this.propertyId,
    required this.bidId,
    required this.name,
    required this.price,
    required this.timeAgo,
    required this.imageUrl,
    required this.isHighest,
    required this.isAcceptable,
    required this.isAuction,
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
                ),
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
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 4,
                      ),
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
                      backgroundImage: AssetImage(imageUrl),
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
                            color: isHighest
                                ? const Color(0xFF00684A)
                                : const Color(0xFF0C2442),
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
                              context.push('/review-bid/$propertyId/$bidId');
                            },
                            style: OutlinedButton.styleFrom(
                              side: BorderSide(
                                color: AppColors.primaryBlue.withValues(
                                  alpha: 0.2,
                                ),
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
                              context.push('/review-bid/$propertyId/$bidId');
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
                            isAcceptable ? 'Accept Offer' : 'Review Buyer',
                            style: GoogleFonts.manrope(
                              color: isAcceptable
                                  ? Colors.white
                                  : const Color(0xFF0C2442),
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
