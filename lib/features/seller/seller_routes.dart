import 'package:go_router/go_router.dart';
import 'presentation/screens/my_listings_screen.dart';
import 'presentation/screens/create_listing_screen.dart';
import 'presentation/screens/manage_bids_screen.dart';
import 'presentation/screens/review_bid_screen.dart';
import 'presentation/screens/seller_profile_screen.dart';
import 'presentation/screens/active_auctions_screen.dart';
import 'presentation/screens/seller_dashboard_screen.dart';

class SellerRoutes {
  static const String dashboard = '/seller-dashboard';
  static const String myListings = '/my-listings';
  static const String createListing = '/create-listing';
  static const String manageBids = '/manage-bids';
  static const String reviewBid = '/review-bid';
  static const String activeAuctions = '/active-auctions';
  static const String profile = '/seller-profile';

  static List<RouteBase> get routes => [
        // 0. Seller Dashboard (Main Entry Point)
        GoRoute(
          path: dashboard,
          builder: (context, state) => const SellerDashboardScreen(),
        ),

        // 1. My Listings (Portfolio Overview)
        GoRoute(
          path: myListings,
          builder: (context, state) => const MyListingsScreen(),
        ),

        // 5. Create Listing Flow
        GoRoute(
          path: createListing,
          builder: (context, state) => const CreateListingScreen(),
        ),

        // 6. Bidding Management Flow
        GoRoute(
          path: '$manageBids/:propertyId',
          builder: (context, state) {
            final id = state.pathParameters['propertyId']!;
            return ManageBidsScreen(propertyId: id);
          },
        ),

        // Sub-route for reviewing a specific bid
        GoRoute(
          path: '$reviewBid/:bidId',
          builder: (context, state) {
            final bidId = state.pathParameters['bidId']!;
            return ReviewBidScreen(bidId: bidId);
          },
        ),

        // 7. Active Auctions (The "Bids" tab in bottom nav)
        GoRoute(
          path: activeAuctions,
          builder: (context, state) => const ActiveAuctionsScreen(),
        ),

        // 8. Professional Seller Profile
        GoRoute(
          path: '$profile/:userId',
          builder: (context, state) {
            final userId = state.pathParameters['userId']!;
            return SellerProfileScreen(userId: userId);
          },
        ),
      ];
}
