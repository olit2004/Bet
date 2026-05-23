import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:go_router/go_router.dart';
import 'package:bet/core/constants/app_colors.dart';
import 'package:bet/features/seller/presentation/widgets/active_auction_card.dart';
import '../../../auth/application/providers/auth_provider.dart';
import '../providers/seller_properties_provider.dart';
import '../../seller_routes.dart';

class ActiveAuctionsContent extends ConsumerWidget {
  const ActiveAuctionsContent({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authNotifierProvider);
    final userId = authState.user?.id ?? '';
    final propertiesAsync = ref.watch(sellerPropertiesProvider(userId));

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
      child: propertiesAsync.when(
        loading: () => const Center(
          child: Padding(
            padding: EdgeInsets.all(32.0),
            child: CircularProgressIndicator(color: AppColors.primaryBlue),
          ),
        ),
        error: (err, stack) => Center(
          child: Text(
            'Failed to load auctions: $err',
            style: const TextStyle(color: AppColors.error),
          ),
        ),
        data: (properties) {
          final activeAuctions = properties
              .where((p) => p.listingType == 'AUCTION' && p.status == 'ACTIVE')
              .toList();
          
          final totalBids = activeAuctions.fold<int>(
            0,
            (sum, p) => sum + (p.bidCount ?? 0),
          );

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Stats Section
              Row(
                children: [
                  Expanded(
                    child: _buildStatCard(
                      title: 'Live Auctions',
                      value: activeAuctions.length.toString(),
                      valueColor: AppColors.primaryBlue,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: _buildStatCard(
                      title: 'Total Bids',
                      value: totalBids.toString(),
                      valueColor: const Color(0xFF00684A),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 32),

              if (activeAuctions.isEmpty)
                const Center(
                  child: Padding(
                    padding: EdgeInsets.all(32.0),
                    child: Text(
                      'You do not have any active auctions.',
                      style: TextStyle(color: AppColors.secondaryText),
                    ),
                  ),
                )
              else
                ...activeAuctions.map((property) {
                  final imageUrl = property.imageUrls.isNotEmpty 
                      ? 'http://localhost:8080${property.imageUrls.first}'
                      : 'assets/images/properties/apartment.png';

                  // Calculate time remaining based on endTime
                  String timeRemaining = '00h 00m remaining';
                  if (property.endTime != null) {
                    final diff = property.endTime!.difference(DateTime.now());
                    if (diff.isNegative) {
                      timeRemaining = 'Ended';
                    } else {
                      final days = diff.inDays;
                      final hours = diff.inHours % 24;
                      final minutes = diff.inMinutes % 60;
                      if (days > 0) {
                        timeRemaining = '${days}d ${hours}h remaining';
                      } else {
                        timeRemaining = '${hours}h ${minutes}m remaining';
                      }
                    }
                  }

                  return Padding(
                    padding: const EdgeInsets.only(bottom: 24.0),
                    child: ActiveAuctionCard(
                      imageUrl: imageUrl,
                      isVerified: true,
                      timeRemaining: timeRemaining,
                      title: property.title,
                      location: property.location,
                      currentBid: '${property.price} Birr', // TODO: Fetch highest bid dynamically in the future
                      bidsPlaced: property.bidCount ?? 0,
                      onManageAuction: () {
                        context.push('${SellerRoutes.manageBids}/${property.id}');
                      },
                      onTap: () {
                        context.push(
                          '${SellerRoutes.propertyDetail}/${property.id}',
                          extra: {
                            'propertyId': property.id,
                            'imageUrl': imageUrl,
                            'title': property.title,
                            'location': property.location,
                          },
                        );
                      },
                    ),
                  );
                }),
            ],
          );
        },
      ),
    );
  }


  Widget _buildStatCard({
    required String title,
    required String value,
    required Color valueColor,
  }) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: GoogleFonts.inter(
              color: AppColors.secondaryText,
              fontSize: 13,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: GoogleFonts.manrope(
              color: valueColor,
              fontSize: 28,
              fontWeight: FontWeight.w800,
            ),
          ),
        ],
      ),
    );
  }
}
