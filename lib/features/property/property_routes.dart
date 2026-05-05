import 'package:go_router/go_router.dart';
import 'presentation/screens/home_screen.dart';
import 'presentation/screens/property_detail_screen.dart';
import 'domain/models/property_model.dart';

class PropertyRoutes {
  static const String home = '/home';
  static const String detail = '/property-detail';

  static List<GoRoute> get routes => [
    GoRoute(
      path: home,
      builder: (context, state) => const HomeScreen(),
    ),
    GoRoute(
      path: detail,
      builder: (context, state) {
        final property = state.extra as Property;
        return PropertyDetailScreen(property: property);
      },
    ),
  ];
}
