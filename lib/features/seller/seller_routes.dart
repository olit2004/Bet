import 'package:go_router/go_router.dart';
import 'presentation/screens/my_listings_screen.dart';
import 'presentation/screens/create_listing_screen.dart';
import 'presentation/screens/manage_bids_screen.dart';
import 'presentation/screens/review_bid_screen.dart';
import 'presentation/screens/seller_profile_screen.dart';
import 'presentation/screens/active_auctions_screen.dart';
import 'presentation/screens/seller_dashboard_screen.dart';
import 'presentation/screens/property_details_screen.dart';

class SellerRoutes {
  static const String dashboard = '/seller-dashboard';
  static const String myListings = '/my-listings';
  static const String createListing = '/create-listing';
  static const String manageBids = '/manage-bids';
  static const String reviewBid = '/review-bid';
  static const String activeAuctions = '/active-auctions';
  static const String profile = '/seller-profile';
  static const String propertyDetail = '/seller-property';

  static List<RouteBase> get routes => [
    // Seller Dashboard (Main Entry Point)
    GoRoute(
      path: dashboard,
      builder: (context, state) => const SellerDashboardScreen(),
    ),

    // Property Detail (Seller Specific)
    GoRoute(
      path: '$propertyDetail/:id',
      builder: (context, state) {
        final id = state.pathParameters['id']!;
        return PropertyDetailsScreen(propertyId: id);
      },
    ),

    // My Listings (Portfolio Overview)
    GoRoute(
      path: myListings,
      builder: (context, state) => const MyListingsScreen(),
    ),

    // Create Listing Flow
    GoRoute(
      path: createListing,
      builder: (context, state) => const CreateListingScreen(),
    ),

    // Bidding Management Flow
    GoRoute(
      path: '$manageBids/:propertyId',
      builder: (context, state) {
        final id = state.pathParameters['propertyId']!;
        return ManageBidsScreen(propertyId: id);
      },
    ),

    GoRoute(
      path: '$reviewBid/:propertyId/:bidId',
      builder: (context, state) {
        final propertyId = state.pathParameters['propertyId']!;
        final bidId = state.pathParameters['bidId']!;
        return ReviewBidScreen(propertyId: propertyId, bidId: bidId);
      },
    ),

    // Active Auctions
    GoRoute(
      path: activeAuctions,
      builder: (context, state) => const ActiveAuctionsScreen(),
    ),

    //  Seller Profile
    GoRoute(
      path: '$profile/:userId',
      builder: (context, state) {
        final userId = state.pathParameters['userId']!;
        return SellerProfileScreen(userId: userId);
      },
    ),
  ];
}
