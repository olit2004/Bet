import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:bet/features/seller/presentation/screens/active_auctions_screen.dart';
import 'package:bet/features/seller/presentation/widgets/active_auction_card.dart';
import 'package:bet/features/seller/presentation/providers/seller_properties_provider.dart';
import 'package:bet/features/seller/domain/entities/seller_property.dart';
import 'package:bet/features/auth/application/providers/auth_provider.dart';
import 'package:bet/features/auth/domain/entities/user.dart';

class _MockAuthNotifier extends Notifier<AuthStateData> implements AuthNotifier {
  @override
  AuthStateData build() {
    return AuthStateData(
      status: AuthState.authenticated,
      user: User(
        id: 'seller-123',
        email: 'seller@test.com',
        role: 'SELLER',
        name: 'Tariku Abebe',
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
  group('ActiveAuctionsScreen Widget Tests', () {
    const mockAuctions = [
      SellerProperty(
        id: 'prop-1',
        title: 'Modern Apartment Kazanchis',
        description: 'Cozy place.',
        price: 2500000.0,
        listingType: 'AUCTION',
        latitude: 9.0,
        longitude: 38.0,
        location: 'Kazanchis, Addis Ababa',
        type: 'SALE',
        status: 'ACTIVE',
        bidCount: 5,
        imageUrls: [],
        ownerId: 'seller-123',
        endTime: null,
      ),
      SellerProperty(
        id: 'prop-2',
        title: 'Bole Commercial Complex',
        description: 'Office building.',
        price: 45000000.0,
        listingType: 'FIXED',
        latitude: 9.0,
        longitude: 38.0,
        location: 'Bole, Addis Ababa',
        type: 'SALE',
        status: 'ACTIVE',
        bidCount: 0,
        imageUrls: [],
        ownerId: 'seller-123',
      ),
    ];

    Widget createWidgetUnderTest({
      Future<List<SellerProperty>> Function(Ref)? providerOverride,
      List<SellerProperty>? propertiesList,
    }) {
      return ProviderScope(
        overrides: [
          authNotifierProvider.overrideWith(() => _MockAuthNotifier()),
          if (providerOverride != null)
            sellerPropertiesProvider('seller-123').overrideWith(providerOverride)
          else
            sellerPropertiesProvider('seller-123').overrideWith((ref) => propertiesList ?? []),
        ],
        child: const MaterialApp(
          home: ActiveAuctionsScreen(),
        ),
      );
    }

    testWidgets('renders loading state initially', (WidgetTester tester) async {
      await tester.pumpWidget(createWidgetUnderTest(
        providerOverride: (ref) => Completer<List<SellerProperty>>().future,
      ));

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets('renders empty state when there are no active auctions', (WidgetTester tester) async {
      await tester.pumpWidget(createWidgetUnderTest(
        propertiesList: [],
      ));
      await tester.pump();

      expect(find.text('Live Auctions'), findsOneWidget);
      expect(find.text('0'), findsNWidgets(2));
      
      expect(find.text('You do not have any active auctions.'), findsOneWidget);
    });

    testWidgets('renders stats and active auction cards correctly', (WidgetTester tester) async {
      await tester.binding.setSurfaceSize(const Size(800, 1200));
      addTearDown(() => tester.binding.setSurfaceSize(null));

      await tester.pumpWidget(createWidgetUnderTest(
        propertiesList: mockAuctions,
      ));
      await tester.pump();

      expect(find.text('Live Auctions'), findsOneWidget);
      expect(find.text('1'), findsOneWidget);
      expect(find.text('5'), findsOneWidget);

      expect(find.byType(ActiveAuctionCard), findsOneWidget);
      expect(find.text('Modern Apartment Kazanchis'), findsOneWidget);
      expect(find.text('Kazanchis, Addis Ababa'), findsOneWidget);
      expect(find.text('2500000.0 Birr'), findsOneWidget);
      
      expect(find.text('Bole Commercial Complex'), findsNothing);
    });
  });
}
