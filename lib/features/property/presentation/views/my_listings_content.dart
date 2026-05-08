import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:bet/core/constants/app_colors.dart';
import 'package:bet/core/widgets/app_logo.dart';
import '../widgets/stat_item.dart';
import '../widgets/property_listing_card.dart';

class MyListingsContent extends StatelessWidget {
  final VoidCallback? onAddNewListing;

  const MyListingsContent({super.key, this.onAddNewListing});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const AppLogo(size: 32),
              const CircleAvatar(
                radius: 22,
                backgroundImage: NetworkImage(
                  'https://i.pravatar.cc/150?img=11',
                ),
              ),
            ],
          ),
          const SizedBox(height: 32),

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
          SizedBox(
            width: double.infinity,
            height: 56,
            child: ElevatedButton.icon(
              onPressed: onAddNewListing,
              icon: const Icon(Icons.add_circle, color: Colors.white),
              label: const Text(
                'Add New Listing',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryLightBlue,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
                elevation: 0,
              ),
            ),
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
              context.push('/manage-bids/skyline-123');
            },
            onTap: () {
              context.push(
                '/property/skyline-123',
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
                '/property/apartment-123',
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
    );
  }
}
