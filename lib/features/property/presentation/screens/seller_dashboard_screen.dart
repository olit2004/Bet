import 'package:flutter/material.dart';
import 'package:bet/core/constants/app_colors.dart';
import '../views/seller_profile_content.dart';
import '../views/create_property_content.dart';
import '../views/my_listings_content.dart';
import '../views/active_auctions_content.dart';

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
            MyListingsContent(
              onAddNewListing: () {
                setState(() {
                  _currentIndex = 2; // Switch to Create tab
                });
              },
            ),
            // Tab 1: Bids (Active Auctions)
            const ActiveAuctionsContent(),
            // Tab 2: Create Listing
            const CreatePropertyContent(),
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
        unselectedItemColor: AppColors.secondaryText.withValues(alpha: 0.5),
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


}
