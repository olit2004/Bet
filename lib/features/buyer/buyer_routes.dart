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
          path: '$detail/:id',
          builder: (context, state) {
            final id = state.pathParameters['id']!;
            final extra = state.extra;
            
            Property? property;
            String? imageUrl;
            String? title;
            String? location;

            if (extra is Property) {
              property = extra;
              imageUrl = property.imageUrls.isNotEmpty ? property.imageUrls.first : null;
              title = property.title;
              location = property.address;
            } else if (extra is Map<String, dynamic>) {
              imageUrl = extra['imageUrl'] as String?;
              title = extra['title'] as String?;
              location = extra['location'] as String?;
            }

            return PropertyDetailsScreen(
              propertyId: id,
              imageUrl: imageUrl ?? 'assets/images/properties/apartment.png',
              title: title ?? 'Property Details',
              location: location ?? 'Addis Ababa',
              property: property,
            );
          },
        ),

        // 2. Place Bid Screen
        GoRoute(
          path: '$placeBid/:id',
          builder: (context, state) {
            final property = state.extra as Property;
            return PlaceBidScreen(property: property);
          },
        ),

        // 3. Counter Offer Screen
        GoRoute(
          path: '$counterOffer/:id',
          builder: (context, state) {
            final property = state.extra as Property;
            return CounterOfferScreen(property: property);
          },
        ),
      ];
}
