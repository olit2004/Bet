import 'package:go_router/go_router.dart';
import 'presentation/screens/my_listings_screen.dart';
import 'presentation/screens/create_listing_screen.dart';
import 'presentation/screens/manage_bids_screen.dart';
import 'presentation/screens/review_bid_screen.dart';
import 'presentation/screens/property_details_screen.dart';
import 'presentation/screens/seller_profile_screen.dart';
import 'presentation/screens/active_auctions_screen.dart';
import 'presentation/screens/seller_dashboard_screen.dart';
import 'presentation/screens/place_bid_screen.dart';
import 'presentation/screens/counter_offer_screen.dart';
import 'package:bet/core/property/models/property_model.dart';

/// Routes for the Property & Bidding feature
class PropertyRoutes {
  static const String detail = '/property';
  static const String placeBid = '/place-bid';
  static const String counterOffer = '/counter-offer';

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
          path: '$detail/:id',
          builder: (context, state) {
            final id = state.pathParameters['id']!;
            final extra = state.extra as Property?;

            return PropertyDetailsScreen(
              propertyId: id,
              imageUrl: extra?.imageUrls.first ?? 'assets/images/properties/apartment.png',
              title: extra?.title ?? 'Property Details',
              location: extra?.address ?? 'Addis Ababa',
              property: extra, // Passing the full property object if available
            );
          },
        ),

        // 3. Place Bid Screen
        GoRoute(
          path: '$placeBid/:id',
          builder: (context, state) {
            final property = state.extra as Property;
            return PlaceBidScreen(property: property);
          },
        ),

        // 4. Counter Offer Screen
        GoRoute(
          path: '$counterOffer/:id',
          builder: (context, state) {
            final property = state.extra as Property;
            return CounterOfferScreen(property: property);
          },
        ),

        // 5. Create Listing Flow
        GoRoute(
          path: '/create-listing',
          builder: (context, state) => const CreateListingScreen(),
        ),

        // 6. Bidding Management Flow
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

        // 7. Active Auctions (The "Bids" tab in bottom nav)
        GoRoute(
          path: '/active-auctions',
          builder: (context, state) => const ActiveAuctionsScreen(),
        ),

        // 8. Professional Seller Profile
        GoRoute(
          path: '/seller-profile/:userId',
          builder: (context, state) {
            final userId = state.pathParameters['userId']!;
            return SellerProfileScreen(userId: userId);
          },
        ),
      ];
}
