import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart' as riverpod;
import 'package:provider/provider.dart' as legacy_provider;
import 'package:bet/features/buyer/presentation/screens/home_screen.dart';
import 'package:bet/features/buyer/presentation/widgets/property_card.dart';
import 'package:bet/core/property/providers/property_provider.dart';
import 'package:bet/core/providers/navigation_provider.dart';
import 'package:bet/core/property/repositories/property_repository.dart';
import 'package:bet/core/property/models/property_model.dart';
import 'package:bet/features/auth/application/providers/auth_provider.dart';
import 'package:bet/features/auth/domain/entities/user.dart';

class FakePropertyRepository implements PropertyRepository {
  List<Property> properties = [];
  bool throwError = false;

  @override
  Future<List<Property>> getProperties() async {
    if (throwError) {
      throw Exception('Network error');
    }
    return properties;
  }

  @override
  Future<Property?> getPropertyById(String id) async {
    return properties.firstWhere((p) => p.id == id);
  }

  @override
  Future<List<Property>> searchProperties(String query) async {
    return properties.where((p) => p.title.toLowerCase().contains(query.toLowerCase())).toList();
  }

  @override
  Future<List<Property>> getPropertiesByCategory(PropertyCategory category) async {
    return properties.where((p) => p.category == category).toList();
  }
}

class _MockAuthNotifier extends riverpod.Notifier<AuthStateData> implements AuthNotifier {
  @override
  AuthStateData build() {
    return AuthStateData(
      status: AuthState.authenticated,
      user: User(
        id: '1',
        email: 'buyer@test.com',
        role: 'BUYER',
        name: 'Fita Alemayehu',
        isVerified: true,
      ),
    );
  }

  @override
  Future<void> checkAuthStatus() async {}
  @override
  Future<void> login(String email, String password) async {}
  @override
  Future<void> register({required String email, required String password, required String role, required String name, required String phone, String? company}) async {}
  @override
  Future<void> logout() async {}
  @override
  Future<void> deleteAccount() async {}
  @override
  Future<void> updateProfile({String? email, String? bio}) async {}
  @override
  Future<void> uploadProfileImage(dynamic imageFile) async {}
  @override
  Future<void> submitVerification(String faydaId, dynamic imageFile) async {}
}

void main() {
  group('HomeScreen (Property List) Widget Tests', () {
    late FakePropertyRepository fakeRepository;

    setUp(() {
      fakeRepository = FakePropertyRepository();
      fakeRepository.properties = [
        const Property(
          id: '2',
          title: 'Villa in Bole',
          description: 'Suburban villa.',
          price: 12500000.0,
          address: 'Bole, Addis Ababa',
          imageUrls: [],
          category: PropertyCategory.buy,
          specs: [],
        ),
        const Property(
          id: '3',
          title: 'Apartment in Kazanchis',
          description: 'Downtown apartment.',
          price: 50000.0,
          address: 'Kazanchis, Addis Ababa',
          imageUrls: [],
          category: PropertyCategory.rent,
          specs: [],
        ),
      ];
    });

    Widget createWidgetUnderTest() {
      final propertyProvider = PropertyProvider(repository: fakeRepository);
      final navigationProvider = NavigationProvider();

      return riverpod.ProviderScope(
        overrides: [
          authNotifierProvider.overrideWith(() => _MockAuthNotifier()),
        ],
        child: legacy_provider.MultiProvider(
          providers: [
            legacy_provider.ChangeNotifierProvider<PropertyProvider>.value(value: propertyProvider),
            legacy_provider.ChangeNotifierProvider<NavigationProvider>.value(value: navigationProvider),
          ],
          child: const MaterialApp(
            home: HomeScreen(),
          ),
        ),
      );
    }

    testWidgets('displays list of properties when successfully loaded', (WidgetTester tester) async {
      await tester.binding.setSurfaceSize(const Size(800, 1200));
      addTearDown(() => tester.binding.setSurfaceSize(null));

      await tester.pumpWidget(createWidgetUnderTest());
      
      await tester.pump();
      await tester.pump();

      expect(find.byType(PropertyCard), findsNWidgets(2));
      expect(find.text('Villa in Bole'), findsOneWidget);
      expect(find.text('Apartment in Kazanchis'), findsOneWidget);
    });

    testWidgets('displays search off error/empty state when no properties are found', (WidgetTester tester) async {
      fakeRepository.properties = [];

      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pump();
      await tester.pump();

      expect(find.byType(PropertyCard), findsNothing);
      expect(find.text('No properties found'), findsOneWidget);
      expect(find.byIcon(Icons.search_off), findsOneWidget);
    });

    testWidgets('displays error card and retry button when loading fails', (WidgetTester tester) async {
      await tester.binding.setSurfaceSize(const Size(800, 1200));
      addTearDown(() => tester.binding.setSurfaceSize(null));

      fakeRepository.throwError = true;

      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pump();
      await tester.pump();

      expect(find.text('Failed to load properties. Please try again.'), findsOneWidget);
      expect(find.widgetWithText(ElevatedButton, 'Retry'), findsOneWidget);

      fakeRepository.throwError = false;
      await tester.tap(find.widgetWithText(ElevatedButton, 'Retry'));
      await tester.pump();
      await tester.pump();

      expect(find.text('Failed to load properties. Please try again.'), findsNothing);
      expect(find.byType(PropertyCard), findsNWidgets(2));
    });
  });
}
