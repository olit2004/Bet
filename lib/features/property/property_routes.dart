import 'package:go_router/go_router.dart';
import 'presentation/screens/my_listings_screen.dart';
import 'presentation/screens/create_listing_screen.dart';
import 'presentation/screens/manage_bids_screen.dart';
import 'presentation/screens/review_bid_screen.dart';
import 'presentation/screens/property_details_screen.dart';
import 'presentation/screens/seller_profile_screen.dart';
import 'presentation/screens/active_auctions_screen.dart';

import 'presentation/screens/seller_dashboard_screen.dart';

/// Routes for the Property & Bidding feature
class PropertyRoutes {
  static List<RouteBase> get routes => [
        // 0. Seller Dashboard (Main Entry Point)
        GoRoute(
          path: '/seller-dashboard',
          builder: (context, state) => const SellerDashboardScreen(),
        ),

        // 1. My Listings (Portfolio Overview)
        GoRoute(
          path: '/my-listings',
          builder: (context, state) => const MyListingsScreen(),
        ),

        // 2. Property Details
        GoRoute(
          path: '/property/:id',
          builder: (context, state) {
            final id = state.pathParameters['id']!;
            final extra = state.extra as Map<String, dynamic>?;

            return PropertyDetailsScreen(
              propertyId: id,
              imageUrl:
                  extra?['imageUrl'] ?? 'assets/images/properties/apartment.png',
              title: extra?['title'] ?? 'Property Details',
              location: extra?['location'] ?? 'Addis Ababa',
            );
          },
        ),

        // 3. Create Listing Flow
        GoRoute(
          path: '/create-listing',
          builder: (context, state) => const CreateListingScreen(),
        ),

        // 4. Bidding Management Flow
        GoRoute(
          path: '/manage-bids/:propertyId',
          builder: (context, state) {
            final id = state.pathParameters['propertyId']!;
            return ManageBidsScreen(propertyId: id);
          },
        ),

        // Sub-route for reviewing a specific bid
        GoRoute(
          path: '/review-bid/:bidId',
          builder: (context, state) {
            final bidId = state.pathParameters['bidId']!;
            return ReviewBidScreen(bidId: bidId);
          },
        ),

        // 5. Active Auctions (The "Bids" tab in bottom nav)
        GoRoute(
          path: '/active-auctions',
          builder: (context, state) => const ActiveAuctionsScreen(),
        ),

        // 6. Professional Seller Profile
        GoRoute(
          path: '/seller-profile/:userId',
          builder: (context, state) {
            final userId = state.pathParameters['userId']!;
            return SellerProfileScreen(userId: userId);
          },
        ),
      ];
}
