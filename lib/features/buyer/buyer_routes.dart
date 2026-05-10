import 'package:go_router/go_router.dart';
import 'package:bet/features/buyer/presentation/screens/property_details_screen.dart';
import 'package:bet/features/buyer/presentation/screens/place_bid_screen.dart';
import 'package:bet/features/buyer/presentation/screens/counter_offer_screen.dart';
import 'package:bet/core/property/models/property_model.dart';

class BuyerRoutes {
  static const String detail = '/property';
  static const String placeBid = '/place-bid';
  static const String counterOffer = '/counter-offer';

  static List<RouteBase> get routes => [
        // 1. Property Details
        GoRoute(
          name: 'property-detail',
          path: '$detail/:id',
          builder: (context, state) {
            final id = state.pathParameters['id']!;
            final extra = state.extra as Property?;

            return PropertyDetailsScreen(
              propertyId: id,
              imageUrl: extra?.imageUrls.first ?? 'assets/images/properties/apartment.png',
              title: extra?.title ?? 'Property Details',
              location: extra?.address ?? 'Addis Ababa',
              property: extra,
            );
          },
        ),

        // 2. Place Bid Screen
        GoRoute(
          name: 'place-bid',
          path: '$placeBid/:id',
          builder: (context, state) {
            final property = state.extra as Property;
            return PlaceBidScreen(property: property);
          },
        ),

        // 3. Counter Offer Screen
        GoRoute(
          name: 'counter-offer',
          path: '$counterOffer/:id',
          builder: (context, state) {
            final property = state.extra as Property;
            return CounterOfferScreen(property: property);
          },
        ),
      ];
}
