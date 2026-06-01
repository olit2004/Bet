import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:bet/features/buyer/presentation/screens/place_bid_screen.dart';
import 'package:bet/core/property/models/property_model.dart';
import 'package:bet/features/auction/application/providers/bid_provider.dart';
import 'package:bet/core/widgets/custom_button.dart';

class _MockBidNotifier extends Notifier<BidStateData> implements BidNotifier {
  final BidStateData initialState;
  double? placedAmount;
  bool placeBidCalled = false;

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
  }) async {
    placeBidCalled = true;
    placedAmount = amount;
    state = BidStateData(status: BidStatus.success);
  }

  @override
  Future<void> acceptBid(String bidId) async {}

  @override
  Future<void> retractBid(String bidId) async {}
}

void main() {
  group('PlaceBidScreen Widget Tests', () {
    const mockProperty = Property(
      id: '2',
      title: 'Luxury Mansion',
      description: 'A beautiful luxury mansion.',
      price: 15000000.0,
      currency: 'ETB',
      address: 'Bole Medhanialem, Addis Ababa',
      imageUrls: [],
      category: PropertyCategory.buy,
      specs: [],
      isVerified: true,
      isFeatured: true,
    );

    late _MockBidNotifier mockNotifier;

    Widget createWidgetUnderTest({required BidStateData bidState}) {
      mockNotifier = _MockBidNotifier(bidState);
      return ProviderScope(
        overrides: [
          bidNotifierProvider.overrideWith(() => mockNotifier),
        ],
        child: const MaterialApp(
          home: PlaceBidScreen(
            property: mockProperty,
          ),
        ),
      );
    }

    testWidgets('renders all key placing elements on screen', (WidgetTester tester) async {
      await tester.binding.setSurfaceSize(const Size(800, 1200));
      addTearDown(() => tester.binding.setSurfaceSize(null));

      final bidState = BidStateData(status: BidStatus.initial);

      await tester.pumpWidget(createWidgetUnderTest(bidState: bidState));
      await tester.pump();

      expect(find.text('Luxury Mansion'), findsOneWidget);
      expect(find.text('Bole Medhanialem, Addis Ababa'), findsOneWidget);

      expect(find.text('HIGHEST BID'), findsOneWidget);
      expect(find.text('ENDS IN'), findsOneWidget);

      expect(find.text('Minimum increment: 10,000 ETB'), findsOneWidget);
      expect(find.text('0 active bidders'), findsOneWidget);

      expect(find.text('ETB'), findsOneWidget);

      expect(find.byType(CustomButton), findsOneWidget);
      expect(find.text('Submit'), findsOneWidget);
    });

    testWidgets('shows warning snackbar if trying to place a lower or equal bid amount', (WidgetTester tester) async {
      await tester.binding.setSurfaceSize(const Size(800, 1200));
      addTearDown(() => tester.binding.setSurfaceSize(null));

      final bidState = BidStateData(status: BidStatus.initial, bids: []);

      await tester.pumpWidget(createWidgetUnderTest(bidState: bidState));
      await tester.pump();

      await tester.enterText(find.byType(TextField), '14000000');
      await tester.pump();

      await tester.tap(find.byType(CustomButton));
      await tester.pump();

      expect(find.text('Your bid must be greater than the current highest bid!'), findsOneWidget);
      expect(mockNotifier.placeBidCalled, isFalse);
    });

    testWidgets('successfully calls placeBid and triggers success overlay on valid bid entry', (WidgetTester tester) async {
      await tester.binding.setSurfaceSize(const Size(800, 1200));
      addTearDown(() => tester.binding.setSurfaceSize(null));

      final bidState = BidStateData(status: BidStatus.initial, bids: []);

      await tester.pumpWidget(createWidgetUnderTest(bidState: bidState));
      await tester.pump();

      await tester.enterText(find.byType(TextField), '16000000');
      await tester.pump();

      await tester.tap(find.byType(CustomButton));
      await tester.pump();
      await tester.pumpAndSettle();

      expect(mockNotifier.placeBidCalled, isTrue);
      expect(mockNotifier.placedAmount, 16000000.0);

      expect(find.text('Success!'), findsOneWidget);
      expect(find.text('Your bid has been placed successfully.'), findsOneWidget);
    });
  });
}
