import 'package:flutter/material.dart';
import 'package:bet/core/constants/app_colors.dart';
import 'package:bet/core/widgets/app_logo.dart';
import '../widgets/stat_item.dart';
import '../widgets/property_listing_card.dart';
import '../widgets/seller_profile_content.dart';

/// The seller dashboard acts as the shell for the seller experience.
/// It owns the bottom navigation bar and swaps the body content
/// based on the selected tab.
class SellerDashboardScreen extends StatefulWidget {
  const SellerDashboardScreen({super.key});

  @override
  State<SellerDashboardScreen> createState() => _SellerDashboardScreenState();
}

class _SellerDashboardScreenState extends State<SellerDashboardScreen> {
  int _currentIndex = 0;

  /// Tab titles used in the AppBar for non-home tabs.
  static const _tabTitles = ['Listings', 'Bids', 'Create Listing', 'Profile'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // ── AppBar with back arrow for non-home tabs ──
      appBar: _currentIndex != 0
          ? AppBar(
              leading: IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () {
                  setState(() {
                    _currentIndex = 0;
                  });
                },
              ),
              title: Text(
                _tabTitles[_currentIndex],
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      color: AppColors.primaryText,
                      fontWeight: FontWeight.w700,
                    ),
              ),
              backgroundColor: Colors.white,
              foregroundColor: AppColors.primaryText,
              elevation: 0,
              centerTitle: true,
            )
          : null,
      body: SafeArea(
        child: IndexedStack(
          index: _currentIndex,
          children: [
            // Tab 0: Listings (Dashboard)
            _buildListingsContent(context),
            // Tab 1: Bids (Placeholder)
            _buildPlaceholder('Bids', Icons.gavel_rounded),
            // Tab 2: Create (Placeholder)
            _buildPlaceholder('Create Listing', Icons.add_circle_outline_rounded),
            // Tab 3: Profile
            const SellerProfileContent(userId: 'current-user'),
          ],
        ),
      ),
      // ── Flutter built-in BottomNavigationBar ──
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        type: BottomNavigationBarType.fixed,
        selectedItemColor: AppColors.primaryBlue,
        unselectedItemColor: AppColors.secondaryText.withOpacity(0.5),
        selectedFontSize: 12,
        unselectedFontSize: 11,
        backgroundColor: Colors.white,
        elevation: 8,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.grid_view_rounded),
            label: 'Listings',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.gavel_rounded),
            label: 'Bids',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.add_circle_outline_rounded),
            label: 'Create',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline_rounded),
            label: 'Profile',
          ),
        ],
      ),
    );
  }

  /// The original dashboard content (listings, stats, property cards).
  Widget _buildListingsContent(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Header ──
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

          // ── Title Section ──
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
            style: Theme.of(context).textTheme.displayLarge?.copyWith(
                  color: AppColors.primaryText,
                ),
          ),
          const SizedBox(height: 24),

          // ── Add New Listing Button ──
          SizedBox(
            width: double.infinity,
            height: 56,
            child: ElevatedButton.icon(
              onPressed: () {
                setState(() {
                  _currentIndex = 2; // Switch to Create tab
                });
              },
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

          // ── Statistics (Vertical list with dividers) ──
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

          // ── Property Listing Cards ──
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
              // TODO: Navigate to manage bids
            },
            onMenuPressed: () {
              // TODO: Show property options menu
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
            onActionPressed: () {
              // TODO: Download sales report
            },
            onMenuPressed: () {
              // TODO: Show property options menu
            },
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }

  /// Placeholder widget for tabs that are not yet implemented.
  Widget _buildPlaceholder(String title, IconData icon) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 64, color: AppColors.secondaryText.withOpacity(0.3)),
          const SizedBox(height: 16),
          Text(
            title,
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  color: AppColors.secondaryText.withOpacity(0.5),
                ),
          ),
          const SizedBox(height: 8),
          Text(
            'Coming Soon',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: AppColors.secondaryText.withOpacity(0.4),
                ),
          ),
        ],
      ),
    );
  }
}
