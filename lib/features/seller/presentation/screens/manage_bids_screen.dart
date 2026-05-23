import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:go_router/go_router.dart';

import 'package:bet/core/constants/app_colors.dart';
import 'package:bet/features/seller/presentation/widgets/bid_success_overlay.dart';
import 'package:bet/features/auction/application/providers/bid_provider.dart';
import 'package:bet/features/seller/presentation/providers/property_detail_provider.dart';
import 'package:bet/features/seller/presentation/providers/create_property_provider.dart';
import '../../../auth/application/providers/auth_provider.dart';

class ManageBidsScreen extends ConsumerWidget {
  final String propertyId;

  const ManageBidsScreen({
    super.key,
    required this.propertyId,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final propertyAsync = ref.watch(propertyDetailProvider(propertyId));
    final authState = ref.watch(authNotifierProvider);
    final user = authState.user;

    const bgColor = Color(0xFFEAECEF);

    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        backgroundColor: bgColor,
        elevation: 0,
        centerTitle: false,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back,
            color: AppColors.primaryLightBlue,
          ),
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
            backgroundColor: Colors.grey.shade200,
            backgroundImage: (user?.avatarUrl != null && user!.avatarUrl!.isNotEmpty)
                ? NetworkImage('http://localhost:8080${user.avatarUrl}') as ImageProvider
                : null,
            child: (user?.avatarUrl == null || user!.avatarUrl!.isEmpty)
                ? const Icon(Icons.person, size: 24, color: Colors.grey)
                : null,
          ),
          const SizedBox(width: 16),
        ],
      ),
      body: propertyAsync.when(
        loading: () => const Center(
          child: CircularProgressIndicator(
            color: AppColors.primaryBlue,
          ),
        ),
        error: (err, stack) => Center(
          child: Text(
            'Failed to load bids: $err',
            style: const TextStyle(
              color: AppColors.error,
            ),
          ),
        ),
        data: (property) {
          final isAuction = property.listingType == 'AUCTION';

          final List<dynamic> offers = isAuction
              ? (property.bids ?? [])
              : (property.proposals ?? []);

          final totalOffers = offers.length;

          double highestOffer = 0;

          if (offers.isNotEmpty) {
            highestOffer = offers
                .map(
                  (o) => (o.amount as num?)?.toDouble() ?? 0.0,
                )
                .reduce((a, b) => a > b ? a : b);
          }

          String timeRemaining = 'N/A';

          if (property.endTime != null) {
            final diff = property.endTime!.difference(DateTime.now());

            if (diff.isNegative) {
              timeRemaining = property.status == 'ACTIVE' ? 'Awaiting Acceptance' : 'Ended';
            } else {
              final hours = diff.inHours;
              final minutes = diff.inMinutes % 60;

              timeRemaining = '${hours}h ${minutes}m';
            }
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.symmetric(
              horizontal: 24,
              vertical: 16,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
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
                  style:
                      Theme.of(context).textTheme.displayLarge?.copyWith(
                            color: const Color(0xFF0C2442),
                            fontWeight: FontWeight.w900,
                          ),
                ),
                const SizedBox(height: 24),

                Row(
                  children: [
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF1F3F6),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Column(
                          crossAxisAlignment:
                              CrossAxisAlignment.start,
                          children: [
                            Text(
                              isAuction
                                  ? 'TOTAL BIDS'
                                  : 'PROPOSALS',
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
                                color:
                                    AppColors.primaryLightBlue,
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
                          color:
                              AppColors.primaryLightBlue,
                          borderRadius:
                              BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                              color: AppColors
                                  .primaryLightBlue
                                  .withValues(alpha: 0.2),
                              blurRadius: 12,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment:
                              CrossAxisAlignment.start,
                          children: [
                            Text(
                              isAuction
                                  ? 'HIGHEST BID'
                                  : 'HIGHEST OFFER',
                              style: GoogleFonts.inter(
                                color: Colors.white
                                    .withValues(alpha: 0.8),
                                fontSize: 10,
                                fontWeight: FontWeight.w700,
                                letterSpacing: 1.0,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              highestOffer > 0
                                  ? '${highestOffer.toStringAsFixed(0)} Birr'
                                  : '--',
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

                if (isAuction) ...[
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 20,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFFDCDFE5),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Column(
                      crossAxisAlignment:
                          CrossAxisAlignment.start,
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
                                color:
                                    const Color(0xFF917325),
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
                        style: TextStyle(
                          color: AppColors.secondaryText,
                        ),
                      ),
                    ),
                  )
                else ...[
                  ...offers.asMap().entries.map((entry) {
                    final index = entry.key;
                    final offer = entry.value;

                    String timeAgo = '';

                    if (offer.createdAt != null) {
                      final diff = DateTime.now()
                          .difference(offer.createdAt!);

                      if (diff.inMinutes < 60) {
                        timeAgo =
                            '${diff.inMinutes} MINS AGO';
                      } else if (diff.inHours < 24) {
                        timeAgo =
                            '${diff.inHours} HOURS AGO';
                      } else {
                        timeAgo =
                            '${diff.inDays} DAYS AGO';
                      }
                    }

                    final isHighestOffer =
                        index == 0 && highestOffer > 0;

                    return Padding(
                      padding:
                          const EdgeInsets.only(bottom: 16),
                      child: _BidCard(
                        bidId: offer.id,
                        propertyId: property.id,
                        name:
                            offer.bidderName ?? 'Anonymous',
                        price:
                            '${offer.amount?.toStringAsFixed(0) ?? '--'} Birr',
                        timeAgo: timeAgo,
                        imageUrl: (offer.bidderAvatarUrl != null && offer.bidderAvatarUrl!.isNotEmpty)
                            ? offer.bidderAvatarUrl!
                            : 'assets/images/bidder_${(index % 2) + 1}.png',
                        isHighest: isHighestOffer,
                        isAcceptable:
                            offer.status == 'PENDING' ||
                                offer.status == 'ACTIVE',
                        isAuction: isAuction,
                        isVerified:
                            offer.isVerified ?? false,
                        bidderFaydaStatus: offer.bidderFaydaStatus,
                        propertyTitle: property.title,
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

class _BidCard extends ConsumerWidget {
  final String propertyId;
  final String bidId;
  final String name;
  final String price;
  final String timeAgo;
  final String imageUrl;
  final bool isHighest;
  final bool isAcceptable;
  final bool isAuction;
  final bool isVerified;
  final String? bidderFaydaStatus;
  final String propertyTitle;

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
    required this.isVerified,
    this.bidderFaydaStatus,
    required this.propertyTitle,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFEAECEF),
        borderRadius: BorderRadius.circular(16),
        boxShadow: isHighest
            ? [
                BoxShadow(
                  color: Colors.black.withValues(
                    alpha: 0.04,
                  ),
                  blurRadius: 20,
                  offset: const Offset(-8, 4),
                ),
              ]
            : [],
      ),
      child: Stack(
        children: [
          if (isHighest)
            Positioned(
              left: 0,
              top: 24,
              bottom: 24,
              child: Container(
                width: 3,
                decoration: BoxDecoration(
                  color: const Color(0xFF132D46),
                  borderRadius:
                      BorderRadius.circular(2),
                ),
              ),
            ),

          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment.start,
              children: [
                if (isHighest) ...[
                  Align(
                    alignment: Alignment.topRight,
                    child: Container(
                      padding:
                          const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFF67E2A9),
                        borderRadius:
                            BorderRadius.circular(12),
                      ),
                      child: Text(
                        'HIGHEST BID',
                        style: GoogleFonts.inter(
                          color:
                              const Color(0xFF00684A),
                          fontSize: 9,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                ],

                Row(
                  crossAxisAlignment:
                      CrossAxisAlignment.center,
                  children: [
                     CircleAvatar(
                      radius: 20,
                      backgroundImage: (imageUrl.startsWith('http') || imageUrl.startsWith('/'))
                          ? NetworkImage(
                              imageUrl.startsWith('http')
                                  ? imageUrl
                                  : 'http://localhost:8080$imageUrl',
                            ) as ImageProvider
                          : AssetImage(imageUrl),
                    ),
                    const SizedBox(width: 12),

                    Expanded(
                      child: Column(
                        crossAxisAlignment:
                            CrossAxisAlignment.start,
                        children: [
                          Text(
                            name,
                            style: GoogleFonts.inter(
                              color:
                                  const Color(0xFF0C2442),
                              fontSize: 15,
                              fontWeight:
                                  FontWeight.w700,
                            ),
                          ),

                          if (isVerified || bidderFaydaStatus == 'APPROVED')
                            Row(
                              children: [
                                const Icon(
                                  Icons.verified,
                                  color: AppColors
                                      .primaryBlue,
                                  size: 12,
                                ),
                                const SizedBox(
                                    width: 4),
                                Text(
                                  'Verified Buyer',
                                  style:
                                      GoogleFonts.inter(
                                    color: AppColors
                                        .primaryBlue,
                                    fontSize: 11,
                                    fontWeight:
                                        FontWeight
                                            .w500,
                                  ),
                                ),
                              ],
                            )
                          else if (bidderFaydaStatus == 'PENDING')
                            Row(
                              children: [
                                Icon(
                                  Icons.hourglass_empty,
                                  color: const Color(0xFFD97706),
                                  size: 12,
                                ),
                                const SizedBox(
                                    width: 4),
                                Text(
                                  'Pending verification',
                                  style:
                                      GoogleFonts.inter(
                                    color: const Color(0xFFD97706),
                                    fontSize: 11,
                                    fontWeight:
                                        FontWeight
                                            .w500,
                                  ),
                                ),
                              ],
                            )
                          else
                            Row(
                              children: [
                                Icon(
                                  Icons.info_outline,
                                  color: Colors.grey.shade600,
                                  size: 12,
                                ),
                                const SizedBox(
                                    width: 4),
                                Text(
                                  'Unverified',
                                  style:
                                      GoogleFonts.inter(
                                    color: Colors.grey.shade600,
                                    fontSize: 11,
                                    fontWeight:
                                        FontWeight
                                            .w500,
                                  ),
                                ),
                              ],
                            ),
                        ],
                      ),
                    ),

                    Column(
                      crossAxisAlignment:
                          CrossAxisAlignment.end,
                      children: [
                        Text(
                          price,
                          style: GoogleFonts.manrope(
                            color: isHighest
                                ? const Color(
                                    0xFF00684A)
                                : const Color(
                                    0xFF0C2442),
                            fontSize: 18,
                            fontWeight:
                                FontWeight.w800,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          timeAgo,
                          style: GoogleFonts.inter(
                            color:
                                AppColors.primaryBlue,
                            fontSize: 10,
                            fontWeight:
                                FontWeight.w700,
                            letterSpacing: 1.0,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),

                const SizedBox(height: 20),

                Row(
                  children: [
                    if (isAcceptable) ...[
                      Expanded(
                        flex: 3,
                        child: SizedBox(
                          height: 48,
                          child: OutlinedButton(
                            onPressed: () {
                              context.push(
                                '/review-bid/$propertyId/$bidId',
                              );
                            },
                            style:
                                OutlinedButton.styleFrom(
                              side: BorderSide(
                                color: AppColors
                                    .primaryBlue
                                    .withValues(
                                  alpha: 0.2,
                                ),
                                width: 1.5,
                              ),
                              shape:
                                  RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius
                                        .circular(12),
                              ),
                              padding: EdgeInsets.zero,
                            ),
                            child: Text(
                              'Review',
                              style:
                                  GoogleFonts.manrope(
                                color: AppColors
                                    .primaryBlue,
                                fontSize: 14,
                                fontWeight:
                                    FontWeight.w700,
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
                          onPressed: () async {
                            if (isAcceptable) {
                              if (isAuction) {
                                await ref
                                    .read(
                                      bidNotifierProvider
                                          .notifier,
                                    )
                                    .acceptBid(bidId);
                              } else {
                                final repository = ref.read(sellerPropertyRepositoryProvider);
                                await repository.acceptOffer(bidId, false);
                              }

                              ref.invalidate(propertyDetailProvider(propertyId));

                               if (context.mounted) {
                                showDialog(
                                  context: context,
                                  builder: (context) =>
                                      BidSuccessOverlay(
                                        propertyTitle: propertyTitle,
                                        amount: price,
                                        bidderName: name,
                                      ),
                                );
                              }
                            } else {
                              context.push(
                                '/review-bid/$propertyId/$bidId',
                              );
                            }
                          },
                          style:
                              ElevatedButton.styleFrom(
                            backgroundColor:
                                isAcceptable
                                    ? AppColors
                                        .primaryLightBlue
                                    : const Color(
                                        0xFFD6DFE8),
                            shape:
                                RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.circular(
                                      12),
                            ),
                            elevation: 0,
                          ),
                          child: Text(
                            isAcceptable
                                ? 'Accept Offer'
                                : 'Review Buyer',
                            style:
                                GoogleFonts.manrope(
                              color: isAcceptable
                                  ? Colors.white
                                  : const Color(
                                      0xFF0C2442),
                              fontSize: 14,
                              fontWeight:
                                  FontWeight.w800,
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