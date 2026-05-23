import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:bet/core/constants/app_colors.dart';
import 'package:bet/core/widgets/app_logo.dart';
import 'package:bet/features/seller/presentation/widgets/seller_button.dart';
import 'package:bet/features/seller/presentation/widgets/stat_item.dart';
import 'package:bet/features/seller/presentation/widgets/property_listing_card.dart';
import 'package:bet/features/seller/seller_routes.dart';
import '../../../auth/application/providers/auth_provider.dart';
import '../providers/seller_properties_provider.dart';

class MyListingsContent extends ConsumerStatefulWidget {
  final VoidCallback? onAddNewListing;

  const MyListingsContent({super.key, this.onAddNewListing});

  @override
  ConsumerState<MyListingsContent> createState() => _MyListingsContentState();
}

class _MyListingsContentState extends ConsumerState<MyListingsContent> {
  final ScrollController _scrollController = ScrollController();
  bool _isScrolled = false;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(() {
      if (_scrollController.offset > 0 && !_isScrolled) {
        setState(() => _isScrolled = true);
      } else if (_scrollController.offset <= 0 && _isScrolled) {
        setState(() => _isScrolled = false);
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authNotifierProvider);
    final userId = authState.user?.id ?? '';
    final propertiesAsync = ref.watch(sellerPropertiesProvider(userId));

    return Column(
      children: [
        // ── Stationary Header ──
        AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: _isScrolled
                ? [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.05),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ]
                : [],
          ),
          padding: const EdgeInsets.fromLTRB(24, 16, 24, 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const AppLogo(size: 32),
              const CircleAvatar(
                radius: 22,
                backgroundImage: AssetImage(
                  'assets/images/seller_profile.png',
                ),
              ),
            ],
          ),
        ),
        
        // ── Scrollable Body ──
        Expanded(
          child: SingleChildScrollView(
            controller: _scrollController,
            padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 16),

                // Title Section
                Text(
                  'PORTFOLIO OVERVIEW',
                  style: Theme.of(context).textTheme.labelSmall?.copyWith(
                    color: AppColors.primaryBlue,
                    letterSpacing: 1.5,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'My Listings',
                  style: Theme.of(
                    context,
                  ).textTheme.displayLarge?.copyWith(color: AppColors.primaryText),
                ),
                const SizedBox(height: 24),

                //Add New Listing Button
                SellerButton(
                  text: 'Add New Listing',
                  onPressed: widget.onAddNewListing ?? () {},
                  icon: Icons.add_circle,
                  color: AppColors.primaryLightBlue,
                ),
                const SizedBox(height: 20),

                propertiesAsync.when(
                  loading: () => const Center(
                    child: Padding(
                      padding: EdgeInsets.all(32.0),
                      child: CircularProgressIndicator(color: AppColors.primaryBlue),
                    ),
                  ),
                  error: (err, stack) => Center(
                    child: Text(
                      'Failed to load properties: $err',
                      style: const TextStyle(color: AppColors.error),
                    ),
                  ),
                  data: (properties) {
                    final activeCount = properties.where((p) => p.status == 'ACTIVE').length;
                    final totalBids = properties.fold<int>(0, (sum, p) => sum + (p.bidCount ?? 0));
                    final totalViews = properties.fold<int>(0, (sum, p) => sum + p.views);
                    
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        StatItem(
                          label: 'Active Properties',
                          value: activeCount.toString(),
                          valueColor: AppColors.primaryText,
                        ),
                        StatItem(
                          label: 'Total Bids',
                          value: totalBids.toString(),
                          valueColor: const Color(0xFF00684A),
                        ),
                        StatItem(
                          label: 'Total Views',
                          value: totalViews.toString(),
                          valueColor: AppColors.primaryText,
                          showDivider: false,
                        ),
                        const SizedBox(height: 32),
                        
                        if (properties.isEmpty)
                          const Center(
                            child: Padding(
                              padding: EdgeInsets.all(32.0),
                              child: Text(
                                'No listings yet. Create your first property!',
                                style: TextStyle(color: AppColors.secondaryText),
                              ),
                            ),
                          )
                        else
                          ...properties.map((property) {
                            final status = property.status == 'ACTIVE' 
                                ? ListingStatus.active 
                                : ListingStatus.sold;

                            // Ensure an image exists or fallback
                            final imageUrl = property.imageUrls.isNotEmpty 
                                ? 'http://localhost:8080${property.imageUrls.first}'
                                : 'assets/images/properties/villa.png'; // A local fallback

                            return Padding(
                              padding: const EdgeInsets.only(bottom: 24.0),
                              child: PropertyListingCard(
                                imageUrl: imageUrl,
                                status: status,
                                price: '${property.price} Birr',
                                title: property.title,
                                location: property.location,
                                stats: [
                                  ListingCardStat(label: 'TOTAL BIDS', value: (property.bidCount ?? 0).toString()),
                                  ListingCardStat(label: 'VIEWS', value: property.views.toString()),
                                  if (property.endTime != null)
                                    ListingCardStat(
                                      label: 'ENDING',
                                      value: '${property.endTime!.difference(DateTime.now()).inDays}d',
                                    ),
                                ],
                                actionLabel: 'Manage Bids',
                                onActionPressed: () {
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
              ],

            ),
          ),
        ),
      ],
    );
  }
}
