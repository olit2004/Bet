import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:bet/core/constants/app_colors.dart';
import 'package:bet/core/widgets/app_logo.dart';
import 'package:bet/features/seller/presentation/widgets/seller_button.dart';
import 'package:bet/features/seller/presentation/widgets/stat_item.dart';
import 'package:bet/features/seller/presentation/widgets/property_listing_card.dart';
import 'package:bet/features/seller/seller_routes.dart';

class MyListingsContent extends StatefulWidget {
  final VoidCallback? onAddNewListing;

  const MyListingsContent({super.key, this.onAddNewListing});

  @override
  State<MyListingsContent> createState() => _MyListingsContentState();
}

class _MyListingsContentState extends State<MyListingsContent> {
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

                const StatItem(
                  label: 'Active Properties',
                  value: '13',
                  valueColor: AppColors.primaryText,
                ),
                const StatItem(
                  label: 'Total Bids',
                  value: '48',
                  valueColor: Color(0xFF00684A),
                ),
                const StatItem(
                  label: 'Views (30d)',
                  value: '2.4k',
                  valueColor: AppColors.primaryText,
                ),
                const StatItem(
                  label: 'Conversion',
                  value: '8.2%',
                  valueColor: AppColors.primaryBlue,
                  showDivider: false,
                ),
                const SizedBox(height: 32),

                PropertyListingCard(
                  imageUrl: 'assets/images/properties/villa.png',
                  status: ListingStatus.active,
                  price: '32,250,000 Birr',
                  title: 'Skyline Penthouse',
                  location: 'Yeka, Addis Ababa',
                  stats: const [
                    ListingCardStat(label: 'TOTAL BIDS', value: '14'),
                    ListingCardStat(label: 'VIEWS', value: '1,240'),
                    ListingCardStat(label: 'ENDING IN', value: '2d 4h'),
                  ],
                  actionLabel: 'Manage Bids',
                  onActionPressed: () {
                    context.push('${SellerRoutes.manageBids}/skyline-123');
                  },
                  onTap: () {
                    context.push(
                      '${SellerRoutes.propertyDetail}/skyline-123',
                      extra: {
                        'imageUrl': 'assets/images/properties/villa.png',
                        'title': 'Skyline Penthouse',
                        'location': 'Yeka, Addis Ababa',
                      },
                    );
                  },
                ),
                const SizedBox(height: 24),

                PropertyListingCard(
                  imageUrl: 'assets/images/properties/apartment.png',
                  status: ListingStatus.sold,
                  price: '28,000,000 Birr',
                  title: '3bdrm Apartment',
                  location: 'Bole, Addis Ababa',
                  stats: const [
                    ListingCardStat(label: 'FINAL BIDS', value: '32'),
                    ListingCardStat(label: 'TOTAL VIEWS', value: '5,892'),
                    ListingCardStat(label: 'STATUS', value: 'Completed'),
                  ],
                  actionLabel: 'Download Sales Report',
                  onActionPressed: () {},
                  onTap: () {
                    context.push(
                      '${SellerRoutes.propertyDetail}/apartment-123',
                      extra: {
                        'imageUrl': 'assets/images/properties/apartment.png',
                        'title': '3bdrm Apartment',
                        'location': 'Bole, Addis Ababa',
                      },
                    );
                  },
                ),
                const SizedBox(height: 16),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
