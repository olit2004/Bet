import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:bet/features/buyer/presentation/screens/property_details_screen.dart';
import 'package:bet/core/property/models/property_model.dart';
import 'package:bet/features/auction/application/providers/bid_provider.dart';
import 'package:bet/features/auction/domain/entities/bid_entity.dart';

class _MockBidNotifier extends Notifier<BidStateData> implements BidNotifier {
  final BidStateData initialState;

  _MockBidNotifier(this.initialState);

  @override
  BidStateData build() {
    return initialState;
  }

  @override
  Future<void> fetchPropertyBids(String propertyId) async {}

  @override
  Future<void> placeBid(
    String propertyId,
    double amount, {
    List<int>? bankStatementBytes,
    String? bankStatementFileName,
    String? bankStatementFilePath,
  }) async {}

  @override
  Future<void> acceptBid(String bidId) async {}

  @override
  Future<void> retractBid(String bidId) async {}
}

void main() {
  group('PropertyDetailsScreen Widget Tests', () {
    const mockProperty = Property(
      id: '2',
      title: 'Luxury Mansion',
      description: 'A beautiful luxury mansion designed by Marcus Thorne.',
      price: 15000000.0,
      currency: 'ETB',
      address: 'Bole Medhanialem, Addis Ababa',
      imageUrls: [],
      category: PropertyCategory.buy,
      specs: [
        PropertySpec(label: 'beds', value: '6', icon: 'bed'),
        PropertySpec(label: 'baths', value: '5', icon: 'bathtub'),
        PropertySpec(label: 'sqm', value: '500', icon: 'square_foot'),
      ],
      isVerified: true,
      isFeatured: true,
      sellerName: 'Abebe Tola',
      sellerPhone: '+251911111111',
      sellerBio: 'Professional Broker',
      locale: 'Bole Medhanialem',
      isSellerVerified: true,
      sellerFaydaStatus: 'APPROVED',
    );

    Widget createWidgetUnderTest({required BidStateData bidState}) {
      return ProviderScope(
        overrides: [
          bidNotifierProvider.overrideWith(() => _MockBidNotifier(bidState)),
        ],
        child: const MaterialApp(
          home: PropertyDetailsScreen(
            propertyId: '2',
            imageUrl: 'http://localhost:8080/mansion.jpg',
            title: 'Luxury Mansion',
            location: 'Bole Medhanialem, Addis Ababa',
            property: mockProperty,
          ),
        ),
      );
    }

    testWidgets('renders property headers and main detailed fields', (WidgetTester tester) async {
      await tester.binding.setSurfaceSize(const Size(800, 1600));
      addTearDown(() => tester.binding.setSurfaceSize(null));

      final bidState = BidStateData(status: BidStatus.initial);

      await tester.pumpWidget(createWidgetUnderTest(bidState: bidState));
      await tester.pump();

      expect(find.text('Luxury Mansion'), findsOneWidget);
      expect(find.text('Bole Medhanialem, Addis Ababa'), findsOneWidget);

      expect(find.text('6'), findsOneWidget);
      expect(find.text('5'), findsOneWidget);
      expect(find.text('500'), findsOneWidget);

      expect(find.text('A beautiful luxury mansion designed by Marcus Thorne.'), findsOneWidget);
      expect(find.text('Abebe Tola'), findsOneWidget);
      expect(find.text('+251911111111'), findsOneWidget);
      expect(find.text('Professional Broker'), findsOneWidget);

      expect(find.widgetWithText(ElevatedButton, 'Place Bid'), findsOneWidget);
    });

    testWidgets('calculates and shows the highest bid dynamically', (WidgetTester tester) async {
      await tester.binding.setSurfaceSize(const Size(800, 1200));
      addTearDown(() => tester.binding.setSurfaceSize(null));

      final bidState = BidStateData(
        status: BidStatus.success,
        bids: [
          BidEntity(
            id: 'b-1',
            propertyId: '2',
            buyerId: 'buyer-1',
            amount: 16500000.0,
            createdAt: DateTime.now(),
            updatedAt: DateTime.now(),
            status: 'ACTIVE',
          )
        ],
      );

      await tester.pumpWidget(createWidgetUnderTest(bidState: bidState));
      await tester.pump();

      expect(find.text('15,000,000 ETB'), findsOneWidget);
      expect(find.text('16,500,000 ETB'), findsOneWidget);
    });
  });
}
