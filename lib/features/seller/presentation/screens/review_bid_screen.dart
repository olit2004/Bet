import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:go_router/go_router.dart';
import 'package:bet/core/constants/app_colors.dart';
import 'package:bet/features/seller/presentation/widgets/bid_success_overlay.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:bet/features/seller/presentation/providers/property_detail_provider.dart';
import 'package:bet/features/seller/presentation/providers/create_property_provider.dart';
import 'package:bet/features/seller/presentation/providers/seller_properties_provider.dart';

class ReviewBidScreen extends ConsumerStatefulWidget {
  final String propertyId;
  final String bidId;

  const ReviewBidScreen({super.key, required this.propertyId, required this.bidId});

  @override
  ConsumerState<ReviewBidScreen> createState() => _ReviewBidScreenState();
}

class _ReviewBidScreenState extends ConsumerState<ReviewBidScreen> {
  bool _isLoading = false;

  Future<void> _handleAcceptOffer(bool isAuction) async {
    setState(() => _isLoading = true);
    try {
      final repository = ref.read(sellerPropertyRepositoryProvider);
      await repository.acceptOffer(widget.bidId, isAuction);
      
      // Invalidate providers so they fetch fresh data
      ref.invalidate(propertyDetailProvider(widget.propertyId));
      final property = ref.read(propertyDetailProvider(widget.propertyId)).value;
      if (property != null) {
        ref.invalidate(sellerPropertiesProvider(property.ownerId));
      }

      if (mounted) {
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (context) => const BidSuccessOverlay(),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(e.toString()), backgroundColor: AppColors.error),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final propertyAsync = ref.watch(propertyDetailProvider(widget.propertyId));
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
      body: propertyAsync.when(
        loading: () => const Center(
          child: CircularProgressIndicator(color: AppColors.primaryBlue),
        ),
        error: (err, stack) => Center(
          child: Text(
            'Failed to load bid details: $err',
            style: const TextStyle(color: AppColors.error),
          ),
        ),
        data: (property) {
          final isAuction = property.listingType == 'AUCTION';
          
          dynamic offer;
          if (isAuction) {
            offer = property.bids?.firstWhere((b) => b.id == widget.bidId);
          } else {
            offer = property.proposals?.firstWhere((p) => p.id == widget.bidId);
          }

          if (offer == null) {
            return const Center(child: Text('Offer not found.'));
          }

          final bidderName = offer.bidderName ?? 'Anonymous';
          final amount = offer.amount?.toStringAsFixed(0) ?? '--';
          final propertyImageUrl = property.imageUrls.isNotEmpty 
              ? 'http://localhost:8080${property.imageUrls.first}' 
              : 'assets/images/properties/apartment.png';
          final isAcceptable = offer.status == 'PENDING' || offer.status == 'ACTIVE';

          return SingleChildScrollView(
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
                          color: const Color(0xFF267D8F),
                          child: propertyImageUrl.startsWith('assets/')
                            ? Image.asset(propertyImageUrl, fit: BoxFit.cover)
                            : Image.network(propertyImageUrl, fit: BoxFit.cover),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              property.location,
                              style: GoogleFonts.inter(
                                color: AppColors.primaryBlue.withValues(alpha: 0.8),
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              property.title,
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
                            backgroundImage: const AssetImage('assets/images/bidder_1.png'),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  bidderName,
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
                                'Member since 2024',
                                style: GoogleFonts.inter(
                                  color: const Color(0xFF0C2442),
                                  fontSize: 11,
                                  fontWeight: FontWeight.w600,
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
                      if (offer.details != null && offer.details!.isNotEmpty) ...[
                        const SizedBox(height: 12),
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            color: const Color(0xFFEBECEE), // Lighter inner box
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Text(
                            '"${offer.details}"',
                            style: GoogleFonts.inter(
                              color: AppColors.primaryBlue.withValues(alpha: 0.8),
                              fontSize: 16,
                              fontStyle: FontStyle.italic,
                              height: 1.5,
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
                const SizedBox(height: 40),

                // Current Offer
                Text(
                  isAuction ? 'CURRENT BID' : 'CURRENT OFFER',
                  style: GoogleFonts.inter(
                    color: AppColors.primaryBlue.withValues(alpha: 0.8),
                    fontSize: 11,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 1.5,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  '$amount Birr',
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
                              'Verified\nFunds',
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
                              'STATUS',
                              style: GoogleFonts.inter(
                                color: AppColors.primaryBlue.withValues(alpha: 0.8),
                                fontSize: 9,
                                fontWeight: FontWeight.w800,
                                letterSpacing: 1.0,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              offer.status,
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
                if (isAcceptable)
                  SizedBox(
                    width: double.infinity,
                    height: 56,
                    child: ElevatedButton.icon(
                      onPressed: _isLoading ? null : () => _handleAcceptOffer(isAuction),
                      icon: _isLoading 
                          ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                          : const Icon(Icons.check_circle_outline, color: Colors.white, size: 20),
                      label: Text(
                        _isLoading ? 'Accepting...' : (isAuction ? 'Accept Bid' : 'Accept Offer'),
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
                    isAcceptable ? 'DECLINE OFFER' : 'GO BACK',
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
          );
        },
      ),
    );
  }
}
